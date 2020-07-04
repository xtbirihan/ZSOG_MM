*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_006_CARGO_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  INITIALIZE_ALV
*&---------------------------------------------------------------------*
FORM initialize_alv .
  DATA message   TYPE REF TO cx_salv_msg.

  TRY.
      cl_salv_table=>factory(
      IMPORTING
        r_salv_table = gs_scr_1903-r_alv
      CHANGING
        t_table      = gs_scr_1903-alv ).

      gs_scr_1903-r_columns = gs_scr_1903-r_alv->get_columns( ).

      PERFORM enable_layout_settings.
      PERFORM optimize_column_width.
      PERFORM hide_client_column.
      PERFORM set_column_names.
      PERFORM set_toolbar.
      PERFORM display_settings.
      PERFORM set_hotspot_click.

      " ...
      " PERFORM setting_n.
    CATCH cx_salv_msg INTO message.
      " error handling
  ENDTRY.
ENDFORM.                    "initialize_alv
*&---------------------------------------------------------------------*
*&      Form  enable_layout_settings
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM enable_layout_settings.
*&---------------------------------------------------------------------*
  DATA layout_settings TYPE REF TO cl_salv_layout.
  DATA layout_key      TYPE salv_s_layout_key.


  layout_settings = gs_scr_1903-r_alv->get_layout( ).
  layout_key-report = sy-repid.
  layout_settings->set_key( layout_key ).
  layout_settings->set_save_restriction( if_salv_c_layout=>restrict_none ).

*  DATA: lr_selections TYPE REF TO cl_salv_selections.
  gs_scr_1903-r_selections = gs_scr_1903-r_alv->get_selections( ).
  gs_scr_1903-r_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

ENDFORM.                    "ENABLE_LAYOUT_SETTINGS

*&---------------------------------------------------------------------*
FORM optimize_column_width.
*&---------------------------------------------------------------------*
  gs_scr_1903-r_columns->set_optimize( ).
ENDFORM.                    "OPTIMIZE_COLUMN_WIDTH

*&---------------------------------------------------------------------*
FORM hide_client_column.
*&---------------------------------------------------------------------*
  DATA not_found TYPE REF TO cx_salv_not_found.

  TRY.
      gs_scr_1903-r_column = gs_scr_1903-r_columns->get_column( 'CELLTAB' ).
      gs_scr_1903-r_column->set_visible( if_salv_c_bool_sap=>false ).
    CATCH cx_salv_not_found INTO not_found.
      " error handling
  ENDTRY.


  TRY.
      gs_scr_1903-r_column = gs_scr_1903-r_columns->get_column( 'SIL' ).
      gs_scr_1903-r_column->set_visible( if_salv_c_bool_sap=>false ).
    CATCH cx_salv_not_found INTO not_found.
      " error handling
  ENDTRY.

ENDFORM.                    " HIDE_CLIENT_COLUMN

*&---------------------------------------------------------------------*
FORM set_column_names.
*&---------------------------------------------------------------------*
*  DATA not_found TYPE REF TO cx_salv_not_found.
*
*  TRY.
*      gr_column = gr_columns->get_column( 'WAVWR' ).
*      gr_column->set_short_text( 'Maliyet' ).
*      gr_column->set_medium_text( 'Maliyet' ).
*      gr_column->set_long_text( 'Maliyet' ).
*    CATCH cx_salv_not_found INTO not_found.
*      " error handling
*  ENDTRY.
ENDFORM.                    " SET_DEPARTURE_COUNTRY_COLUMN

*&---------------------------------------------------------------------*
FORM set_toolbar.
*&---------------------------------------------------------------------*
  DATA functions TYPE REF TO cl_salv_functions_list.
  functions = gs_scr_1903-r_alv->get_functions( ).
  functions->set_all( ).

  gs_scr_1903-r_alv->set_screen_status(
    pfstatus      =  'STANDARD'
    report        =  sy-repid
    set_functions = gs_scr_1903-r_alv->c_functions_all ).
ENDFORM.                    " SET_TOOLBAR
*&---------------------------------------------------------------------*
FORM display_settings.
*&---------------------------------------------------------------------*
  DATA display_settings TYPE REF TO cl_salv_display_settings.
  DATA: lv_tanim TYPE text70.
  DATA: lv_line TYPE i.
  lv_line  = lines( gs_scr_1903-alv ).
  lv_tanim = |Kargo Entegrasyonu | && |--> | && |{ lv_line }| && | Kayıt Bulundu|.

  display_settings = gs_scr_1903-r_alv->get_display_settings( ).
  display_settings->set_striped_pattern( if_salv_c_bool_sap=>true ).
  display_settings->set_list_header( lv_tanim ).
ENDFORM.                    "display_settings
*&---------------------------------------------------------------------*
*&      Form  SET_HOTSPOT_CLICK
*&---------------------------------------------------------------------*
FORM set_hotspot_click .
*-- events
  gs_scr_1903-r_events = gs_scr_1903-r_alv->get_event( ).
  CREATE OBJECT event_handler.
*  SET HANDLER event_handler->on_link_click   FOR gr_events.
  SET HANDLER event_handler->on_user_command FOR gs_scr_1903-r_events.
ENDFORM.                    "set_hotspot_click
*&---------------------------------------------------------------------*
FORM display_alv.
*&---------------------------------------------------------------------*
  gs_scr_1903-r_alv->display( ).
ENDFORM.                    " DISPLAY_ALV
*&---------------------------------------------------------------------*
*&      Form  handle_user_command
*&---------------------------------------------------------------------*
FORM handle_user_command USING i_ucomm TYPE salv_de_function.
  CASE i_ucomm.
    WHEN 'CARGO'.
      PERFORM send_to_cargo.
*      gs_scr_1903-ucomm_first_alv = '&YENI'.
*      CALL SCREEN 1903.
    WHEN '&DEGISTIR'.
*      gs_scr_1903-ucomm_first_alv = '&DEGISTIR'.
*      PERFORM kayit_degistir.
  ENDCASE.
ENDFORM.                    "handle_user_command
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data .
  DATA: ls_alv TYPE zsog_mm_006_cargo_01.
  TYPES: BEGIN OF ltt_data ,
          ebeln         TYPE zsog_mm_006_cargo_01-ebeln       ,
          ebelp         TYPE zsog_mm_006_cargo_01-ebelp       ,
          banfn         TYPE zsog_mm_006_cargo_01-banfn       ,
          bnfpo         TYPE zsog_mm_006_cargo_01-bnfpo       ,
          matnr         TYPE zsog_mm_006_cargo_01-matnr       ,
          maktx         TYPE zsog_mm_006_cargo_01-maktx       ,
          menge         TYPE zsog_mm_006_cargo_01-menge       ,
          meins         TYPE zsog_mm_006_cargo_01-meins       ,
          werks         TYPE zsog_mm_006_cargo_01-werks       ,
          name1         TYPE zsog_mm_006_cargo_01-name1       ,
          afnam         TYPE zsog_mm_006_cargo_01-afnam       ,
          afnam_name1   TYPE zsog_mm_006_cargo_01-afnam_name1 ,
          adrnr         TYPE kna1-adrnr                       ,
          bedat         TYPE zsog_mm_006_cargo_01-bedat       ,
          sil(1),
  END OF ltt_data.

  DATA: lt_data TYPE STANDARD TABLE OF ltt_data ,
        ls_data TYPE ltt_data.
  TYPES: BEGIN OF ltt_adrc ,
          addrnumber    TYPE adrc-addrnumber                  ,
          name_co       TYPE zsog_mm_006_cargo_01-name_co     ,
          street        TYPE zsog_mm_006_cargo_01-street      ,
          house_num1    TYPE zsog_mm_006_cargo_01-house_num1  ,
          city2         TYPE zsog_mm_006_cargo_01-city2       ,
          city1         TYPE zsog_mm_006_cargo_01-city1       ,
          region        TYPE adrc-region,
          langu         TYPE adrc-langu,
          country       TYPE adrc-country,
         END OF ltt_adrc.
  DATA: lt_adrc  TYPE HASHED TABLE OF ltt_adrc WITH UNIQUE KEY addrnumber,
        ls_adrc  TYPE ltt_adrc.
  DATA: lt_t005u TYPE SORTED TABLE OF t005u WITH UNIQUE KEY spras land1 bland,
        ls_t005u TYPE t005u.

  TYPES:  BEGIN OF ltt_adr2,
          addrnumber TYPE adr2-addrnumber,
          consnumber TYPE adr2-consnumber,
          telnr_long TYPE adr2-telnr_long,
          END OF ltt_adr2.
  DATA: lt_adr2 TYPE HASHED TABLE OF ltt_adr2 WITH UNIQUE KEY addrnumber consnumber,
        ls_adr2 TYPE ltt_adr2.

  DATA: lv_proxy TYPE REF TO zarascg_co_service_soap.
  DATA: lt_alv  TYPE TABLE OF zsog_mm_006_cargo_01.

  SELECT  k~ebeln
          p~ebelp
          e~banfn
          e~bnfpo
          b~matnr
          t~maktx
          b~menge
          b~meins
          p~werks
          w~name1
          b~afnam
          a~name1 AS afnam_name1
          a~adrnr
          k~bedat
    FROM ekko AS k
    INNER JOIN ekpo AS p ON k~ebeln = p~ebeln
    INNER JOIN eket AS e ON p~ebeln = e~ebeln
                        AND p~ebelp = e~ebelp
    INNER JOIN eban AS b ON b~banfn = e~banfn
                        AND b~bnfpo = e~bnfpo
    INNER JOIN makt AS t ON t~matnr = b~matnr
                        AND t~spras = sy-langu
    INNER JOIN t001w AS w ON w~werks = p~werks
    INNER JOIN kna1  AS a ON a~kunnr = b~afnam
    INTO TABLE lt_data
    WHERE k~bedat IN s_bedat
      AND k~lifnr IN s_lifnr
      AND k~ebeln IN s_ebeln
      AND k~bukrs = '2425'
      AND k~bsart = 'ZSG1'
      AND p~loekz = ''
      AND b~loekz = ''.
  IF sy-subrc NE 0.
    MESSAGE i013(zsg) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  DATA: lt_log TYPE TABLE OF zsog_mm_006_t_02,
        ls_log TYPE zsog_mm_006_t_02.
  IF lt_data IS NOT INITIAL.
    SELECT * FROM zsog_mm_006_t_02 INTO TABLE lt_log
                                   FOR ALL ENTRIES IN lt_data
                                   WHERE ebeln = lt_data-ebeln
                                     AND ebelp = lt_data-ebelp
                                     AND banfn = lt_data-banfn
                                     AND bnfpo = lt_data-bnfpo
                                     AND durum = 1.
  ENDIF.
  SORT lt_data BY ebeln ebelp banfn bnfpo.
  LOOP AT lt_log INTO ls_log.
    READ TABLE lt_data INTO ls_data WITH KEY ebeln = ls_log-ebeln
                                             ebelp = ls_log-ebelp
                                             banfn = ls_log-banfn
                                             bnfpo = ls_log-bnfpo  BINARY SEARCH.
    IF sy-subrc EQ 0.
      ls_data-sil = 'X'.
      MODIFY lt_data FROM ls_data INDEX sy-tabix TRANSPORTING sil.
    ENDIF.
    CLEAR: ls_data.
  ENDLOOP.
  DELETE lt_data WHERE sil EQ 'X'.
  IF lt_data IS INITIAL.
    MESSAGE i013(zsg) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.
  IF lt_data IS NOT INITIAL.
    SELECT addrnumber
           name_co
           street
           house_num1
           city2
           city1
           region
           langu
           country
           FROM adrc
           INTO TABLE lt_adrc
           FOR ALL ENTRIES IN lt_data
           WHERE addrnumber = lt_data-adrnr.

  ENDIF.

  IF lt_adrc IS NOT INITIAL.
    SELECT * FROM t005u INTO TABLE lt_t005u
             FOR ALL ENTRIES IN lt_adrc
             WHERE bland = lt_adrc-region
               AND spras = lt_adrc-langu
               AND land1 = lt_adrc-country.

    SELECT addrnumber
           consnumber
           telnr_long
           FROM adr2
           INTO TABLE lt_adr2
           FOR ALL ENTRIES IN lt_adrc
           WHERE addrnumber = lt_adrc-addrnumber
             AND ( consnumber EQ 001 OR  consnumber EQ 002 ).
  ENDIF.

  LOOP AT lt_data INTO ls_data.
    MOVE-CORRESPONDING ls_data TO ls_alv.
    READ TABLE lt_adrc INTO ls_adrc WITH TABLE KEY addrnumber = ls_data-adrnr .
    ls_alv-name_co       = ls_adrc-name_co     .
    ls_alv-street        = ls_adrc-street      .
    ls_alv-house_num1    = ls_adrc-house_num1  .
    ls_alv-city2         = ls_adrc-city2       .
    ls_alv-city1         = ls_adrc-city1       .

    READ TABLE lt_t005u INTO ls_t005u WITH KEY bland = ls_adrc-region
                                               spras = ls_adrc-langu
                                               land1 = ls_adrc-country.
    ls_alv-bezei = ls_t005u-bezei.

    READ TABLE lt_adr2 INTO ls_adr2 WITH TABLE KEY addrnumber = ls_data-adrnr
                                                   consnumber = 001.
    ls_alv-telnr_long = ls_adr2-telnr_long+2(11).
    CLEAR: ls_adr2.
    READ TABLE lt_adr2 INTO ls_adr2 WITH TABLE KEY addrnumber = ls_data-adrnr
                                                   consnumber = 002.
    ls_alv-telnr_long2 = ls_adr2-telnr_long+2(11).
    APPEND ls_alv TO gs_scr_1903-alv.
    CLEAR: ls_alv, ls_adrc, ls_t005u, ls_adr2.
  ENDLOOP.
  SORT gs_scr_1903-alv BY ebeln ebelp.

  IF ch1 EQ 'X'.
    lt_alv = gs_scr_1903-alv.
    PERFORM get_proxy CHANGING lv_proxy.
    PERFORM set_orders TABLES lt_alv USING lv_proxy.
  ENDIF.

  PERFORM initialize_alv.
  PERFORM display_alv.
ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      Form  SEND_TO_CARGO
*&---------------------------------------------------------------------*
FORM send_to_cargo .
  DATA: lt_rows  TYPE salv_t_row,
        ls_rows  TYPE int4.
  DATA: lv_proxy TYPE REF TO zarascg_co_service_soap.
  DATA: lt_alv  TYPE TABLE OF zsog_mm_006_cargo_01,
        ls_alv  TYPE zsog_mm_006_cargo_01.

  lt_rows = gs_scr_1903-r_selections->get_selected_rows( ).
  IF lt_rows IS INITIAL.
    MESSAGE i000(zsg) WITH text-004.
    RETURN.
  ENDIF.
  LOOP AT lt_rows INTO ls_rows.
    READ TABLE gs_scr_1903-alv INTO ls_alv INDEX ls_rows.
    APPEND ls_alv TO lt_alv.
    CLEAR: ls_alv.
  ENDLOOP.

  PERFORM get_proxy CHANGING lv_proxy.
  PERFORM set_orders TABLES lt_alv USING lv_proxy.

ENDFORM.                    " SEND_TO_CARGO
*&---------------------------------------------------------------------*
*&      Form  GET_PROXY
*&---------------------------------------------------------------------*
FORM get_proxy  CHANGING pv_proxy TYPE REF TO zarascg_co_service_soap.
  DATA: lr_sys_fault TYPE REF TO cx_ai_system_fault.
  DATA: lv_string TYPE string.
  TRY.
      CREATE OBJECT pv_proxy
        EXPORTING
          logical_port_name = 'ZARAS_KARGO_LP'.
    CATCH cx_ai_system_fault  INTO lr_sys_fault.
*       lv_string = lr_sys_fault->get_text( ).
  ENDTRY.
ENDFORM.                    " GET_PROXY
*&---------------------------------------------------------------------*
*&      Form  SET_ORDERS
*&---------------------------------------------------------------------*
FORM set_orders  TABLES   pt_alv   STRUCTURE zsog_mm_006_cargo_01
                 USING    pv_proxy TYPE REF TO zarascg_co_service_soap.

  DATA: lr_sys_fault  TYPE REF TO cx_ai_system_fault,
        lr_appl_fault TYPE REF TO cx_ai_application_fault,
        ls_alv        TYPE zsog_mm_006_cargo_01.
  DATA: ls_alv1       TYPE zsog_mm_006_cargo_01.

  DATA: lt_input            TYPE zcargo_set_order_soap_in,
        ls_order_info       TYPE zcargo_array_of_order,
        lt_order            TYPE zcargo_order_tab,
        ls_order            TYPE zcargo_order,
        lt_output           TYPE zcargo_set_order_soap_out,
        lt_piece_detail     TYPE zcargo_array_of_piece_detail,
        lt_piece_detail_tab TYPE zcargo_piece_detail_tab,
        ls_pice_detail      TYPE zcargo_piece_detail.


  DATA: lt_user TYPE TABLE OF zsog_mm_006_t_01,
        ls_user TYPE zsog_mm_006_t_01.
  DATA: ls_result TYPE zcargo_order_result_info.
  DATA: ls_log    TYPE zsog_mm_006_t_02,
        lt_log   TYPE TABLE OF zsog_mm_006_t_02.

  DATA: ls_get_input  TYPE zcargo_get_order_soap_in,
        ls_get_output	TYPE zcargo_get_order_soap_out,
        lv_date(10),
        lt_order_result TYPE TABLE OF zcargo_array_of_order,
        lt_order_tab    TYPE zcargo_order_tab,
        ls_order_tab    TYPE zcargo_order.

  SELECT * FROM zsog_mm_006_t_01 INTO TABLE lt_user.

  SORT pt_alv BY banfn bnfpo afnam.
  DELETE ADJACENT DUPLICATES FROM pt_alv COMPARING banfn bnfpo afnam.
  LOOP AT pt_alv INTO ls_alv.

    IF sy-sysid EQ 'DHD'.
      READ TABLE lt_user INTO ls_user WITH KEY sysid = 'DHD'.
    ELSEIF sy-sysid EQ 'DHP'.
      READ TABLE lt_user INTO ls_user WITH KEY sysid = 'DHP'.
    ENDIF.
    lt_input-user_name = ls_user-user_name.
    lt_input-password  = ls_user-password.
    ls_order-trading_waybill_number = ls_alv-afnam.
    CONCATENATE ls_alv-banfn ls_alv-bnfpo ls_alv-afnam INTO ls_order-integration_code.
    ls_order-receiver_name = ls_alv-afnam_name1.
    CONCATENATE ls_alv-street ls_alv-house_num1 ls_alv-city2 ls_alv-city1
           INTO ls_order-receiver_address SEPARATED BY space.
    ls_order-receiver_phone1                 = ls_alv-telnr_long.
    IF ls_order-receiver_phone1 IS INITIAL.
      ls_order-receiver_phone1 = '0'.
    ENDIF.
    ls_order-receiver_phone2                 = ls_alv-telnr_long2.
    IF ls_order-receiver_phone2  IS INITIAL.
       ls_order-receiver_phone2  = '0'.
    ENDIF.
    ls_order-receiver_city_name              = ls_alv-city1.
    ls_order-receiver_town_name              = ls_alv-city2.
    ls_order-city_code                       = ls_alv-city1.
    ls_order-town_code                       = ls_alv-city2.
*    ls_order-receiver_district_name          = ls_alv-city2.  "bölge adı
*    ls_order-receiver_quarter_name           = ls_alv-street.
    ls_order-receiver_avenue_name            = ls_alv-street.
    ls_order-receiver_street_name            = ls_alv-street.
    ls_order-payor_type_code                 = '1'.
    ls_order-is_world_wide                   = '0'.
*    ls_order-piece_count                     =  1.

*    CONCATENATE ls_alv-banfn ls_alv-afnam INTO  ls_pice_detail-barcode_number.
*    APPEND ls_pice_detail TO lt_piece_detail_tab.
*    IF lt_piece_detail_tab IS NOT INITIAL .
*      APPEND LINES OF lt_piece_detail_tab TO lt_piece_detail-piece_detail.
*    ENDIF.
*    ls_order-piece_details  = lt_piece_detail.
    APPEND ls_order TO lt_order.
    IF lt_order IS NOT INITIAL.
      APPEND LINES OF lt_order  TO ls_order_info-order.
      lt_input-order_info = ls_order_info.
    ENDIF.
    TRY.
        pv_proxy->set_order(
          EXPORTING
            input  = lt_input
          IMPORTING
            output = lt_output
               ).

      CATCH cx_ai_system_fault INTO lr_sys_fault.
        IF lr_sys_fault IS NOT INITIAL.
          RAISE proxy_create_system_fault.
        ENDIF.
      CATCH cx_ai_application_fault INTO  lr_appl_fault.
        IF lr_appl_fault IS NOT INITIAL.
          RAISE proxy_create_appl_fault.
        ENDIF.
    ENDTRY.

***************** damlap 05.08.2019 ************** başlangıç

    READ TABLE lt_output-set_order_result-order_result_info INTO ls_result INDEX 1.

    IF ls_result-result_code EQ 0.
      ls_alv-durum = 1."başarılı
    ELSE.
      ls_alv-durum = 2."başarısız
    ENDIF.
    ls_alv-result_code = ls_result-result_code.

    MOVE-CORRESPONDING ls_alv TO ls_log.
    APPEND ls_log TO lt_log.
    MODIFY gs_scr_1903-alv FROM ls_alv TRANSPORTING durum result_code WHERE ebeln = ls_alv-ebeln
                                                                        AND ebelp = ls_alv-ebelp
                                                                        AND banfn = ls_alv-banfn
                                                                        AND bnfpo = ls_alv-bnfpo.
****************** damlap 05.08.2019 ************** bitiş
    CLEAR: ls_order, ls_pice_detail, lt_piece_detail_tab, lt_piece_detail.
    CLEAR: ls_order_info, lt_input, lt_output, ls_alv, ls_log.
  ENDLOOP.

  IF sy-sysid EQ 'DHD'.
    READ TABLE lt_user INTO ls_user WITH KEY sysid = 'DHD'.
  ELSEIF sy-sysid EQ 'DHP'.
    READ TABLE lt_user INTO ls_user WITH KEY sysid = 'DHP'.
  ENDIF.

  ls_get_input-user_name = ls_user-user_name.
  ls_get_input-password  = ls_user-password.
  CONCATENATE sy-datum+6(2)   '.'  sy-datum+4(2) '.'  sy-datum+0(4) INTO lv_date.
  ls_get_input-date = lv_date.

  TRY.
      pv_proxy->get_order(
        EXPORTING
          input  = ls_get_input
        IMPORTING
          output = ls_get_output
      ).
    CATCH cx_ai_system_fault INTO lr_sys_fault.
      IF lr_sys_fault IS NOT INITIAL.
        RAISE proxy_create_system_fault.
      ENDIF.
    CATCH cx_ai_application_fault INTO  lr_appl_fault.
      IF lr_appl_fault IS NOT INITIAL.
        RAISE proxy_create_appl_fault.
      ENDIF.
  ENDTRY.
  SORT lt_log BY banfn bnfpo afnam.

  LOOP AT ls_get_output-get_order_result-order INTO ls_order_tab WHERE integration_code CA 'SG'.
    IF ls_order_tab-integration_code IS NOT INITIAL.
      READ TABLE lt_log INTO ls_log WITH KEY banfn = ls_order_tab-integration_code+0(10)
                                             bnfpo = ls_order_tab-integration_code+10(5)
                                             afnam = ls_order_tab-integration_code+15(8).
      IF sy-subrc EQ 0.
        ls_log-durum = 1.
        MODIFY lt_log FROM ls_log INDEX sy-tabix TRANSPORTING durum.
      ENDIF.
    ENDIF.
    CLEAR: ls_log.
  ENDLOOP.

  IF lt_log IS NOT INITIAL.
    MODIFY zsog_mm_006_t_02 FROM TABLE lt_log.
    COMMIT WORK AND WAIT.
  ENDIF.
  IF ch1 NE 'X'.
    gs_scr_1903-r_alv->refresh( ).
  ENDIF.

ENDFORM.                    " SET_ORDERS
