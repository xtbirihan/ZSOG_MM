*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_006_CARGO_QRY_F01
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

  TRY.
      gs_scr_1903-r_column = gs_scr_1903-r_columns->get_column( 'MANDT' ).
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
    WHEN '&MALKABUL'.
      PERFORM mal_kabul.
    WHEN '&DEGISTIR'.
  ENDCASE.
ENDFORM.                    "handle_user_command
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data .

  DATA: lt_set_orders TYPE TABLE OF zsog_mm_006_t_02.
  DATA: lt_mal_giris  TYPE TABLE OF zsog_mm_006_t_02.
**  DATA: lt_log        TYPE TABLE OF zsog_mm_006_t_03.

  SELECT * FROM zsog_mm_006_t_02 INTO TABLE lt_set_orders
                                      WHERE bedat IN s_bedat
                                        AND durum EQ 1.
  PERFORM get_cargo_status TABLES lt_set_orders .
  IF lt_set_orders IS  INITIAL.
    MESSAGE i013(zsg) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.
  IF ch1 EQ 'X'.
*    PERFORM mal_kabul.
*    lt_alv = gs_scr_1903-alv.
*    PERFORM get_proxy CHANGING lv_proxy.
*    PERFORM set_orders TABLES lt_alv USING lv_proxy.
  ENDIF.

  PERFORM initialize_alv.
  PERFORM display_alv.
ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      Form  GET_CARGO_STATUS
*&---------------------------------------------------------------------*
FORM get_cargo_status TABLES pt_set_orders STRUCTURE zsog_mm_006_t_02.
*                             pt_mal_giris STRUCTURE zsog_mm_006_t_02.

  TYPES: BEGIN OF ltt_json,
         name TYPE char255,
         value  TYPE char255,
        END OF ltt_json.

  DATA:  ls_json_str                 TYPE zsog_mm_006_cargo_02.
  DATA:  lv_err                      TYPE string,
         ls_log                      TYPE zsog_mm_006_t_03,
         lt_in                       TYPE string_table,
         ls_in                       LIKE LINE OF lt_in,
         lv_in                       TYPE string,
         lv_query(18),
         lv_subrc                    TYPE sy-subrc,
         lt_split                    TYPE string_table,
         lt_split2                   TYPE string_table,
         ls_split                    LIKE LINE OF lt_split,
         lt_json                     TYPE TABLE OF ltt_json,
         ls_json                     TYPE ltt_json,
         lv_line                     TYPE i,
         ls_set_orders               TYPE zsog_mm_006_t_02.

  FIELD-SYMBOLS: <fs_any> TYPE any.

  DATA ls_input_json  TYPE zcgqry_iaras_cargo_integratio6.
  DATA ls_output_json TYPE zcgqry_iaras_cargo_integratio5.
  DATA: lv_proxy TYPE REF TO zsorgu_co_iaras_cargo_integrat.

  DATA: lr_sys_fault  TYPE REF TO cx_ai_system_fault,
        lr_appl_fault TYPE REF TO cx_ai_application_fault.
  TRY.
      CREATE OBJECT lv_proxy
        EXPORTING
          logical_port_name = 'ZSORGU_ARAS_CARGO_LP'.
    CATCH cx_ai_system_fault  INTO lr_sys_fault.
*       lv_string = lr_sys_fault->get_text( ).
  ENDTRY.

  CONCATENATE   '<LoginInfo>'
                '<UserName>Prodea</UserName>'
                '<Password>Prodea2019</Password>'
                '<CustomerCode>1920348850944</CustomerCode>'
                '</LoginInfo>'  INTO ls_input_json-login_info.

  LOOP AT pt_set_orders INTO ls_set_orders .
    CLEAR:
           ls_json_str                ,
           lv_err                     ,
           ls_log                     ,
           lt_in                      ,
           ls_in                      ,
           lv_in                      ,
           lv_query                   ,
           lv_subrc                   ,
           lt_split                   ,
           lt_split2                  ,
           ls_split                   ,
           lt_json                    ,
           ls_json                    ,
           lv_line                    .
*           rval.
    CLEAR:  ls_output_json.
    IF <fs_any> IS ASSIGNED.
      UNASSIGN <fs_any>.
    ENDIF.

    CONCATENATE  '<QueryInfo>'
                 '<QueryType>1</QueryType>'
                 '<IntegrationCode>'
                 ls_set_orders-banfn
                 ls_set_orders-bnfpo
                 ls_set_orders-afnam
                 '</IntegrationCode>'
                 '</QueryInfo>' INTO  ls_input_json-query_info.
    TRY.
        lv_proxy->get_query_json(
          EXPORTING
            input  = ls_input_json
          IMPORTING
            output = ls_output_json
               ).
      CATCH cx_ai_system_fault  INTO lr_sys_fault.
      CATCH cx_ai_application_fault INTO lr_appl_fault.
    ENDTRY.

    IF ls_output_json-get_query_jsonresult IS INITIAL.
      CONTINUE.
    ENDIF.

    lv_in = ls_output_json-get_query_jsonresult .
* handle newline and crlf in the same way
    REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf
      IN lv_in WITH cl_abap_char_utilities=>newline.

    SPLIT lv_in AT cl_abap_char_utilities=>newline INTO TABLE lt_in.
    READ TABLE lt_in INTO ls_in INDEX 1.

    LOOP AT lt_in INTO ls_in.
      lv_query = ls_in.
      IF lv_query EQ '"QueryResult":null'.
        lv_subrc = 4.
        EXIT.
      ENDIF.
      FIND '"QueryResult":null' IN ls_in.
      IF sy-subrc EQ 0.
        lv_subrc = 4.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF lv_subrc IS NOT INITIAL.
      lv_err = '"QueryResult":null'.
      CONTINUE.
    ENDIF.

    SPLIT ls_in AT '{' INTO TABLE lt_split.
    DELETE lt_split INDEX 1.
    DELETE lt_split INDEX 1.
    DELETE lt_split INDEX 1.
    READ TABLE lt_split INTO ls_split INDEX 1.
    CLEAR: lt_split.

    SPLIT ls_in AT '{' INTO TABLE lt_split.
    DELETE lt_split INDEX 1.
    DELETE lt_split INDEX 1.
    DELETE lt_split INDEX 1.
    READ TABLE lt_split INTO ls_split INDEX 1.
    CLEAR: lt_split.
    SPLIT ls_split AT ',' INTO TABLE lt_split.

    lv_line = lines( lt_split ).
    READ TABLE lt_split INTO ls_split INDEX lv_line.
    SPLIT ls_split AT '}' INTO TABLE lt_split2.
    READ TABLE lt_split2 INTO ls_split INDEX 1.
    MODIFY lt_split FROM ls_split INDEX lv_line.

    LOOP AT lt_split INTO ls_split.
      SPLIT ls_split AT ':' INTO ls_json-name
                              ls_json-value.
      REPLACE ALL OCCURRENCES OF '"' IN ls_json-name  WITH ''.
      CONDENSE ls_json-value.

      REPLACE ALL OCCURRENCES OF '"' IN ls_json-value  WITH ''.
      CONDENSE ls_json-value.

      APPEND ls_json TO lt_json.
      CLEAR: ls_json.
    ENDLOOP.

    LOOP AT lt_json INTO ls_json.
      ASSIGN COMPONENT ls_json-name OF STRUCTURE ls_json_str TO <fs_any>.
      IF <fs_any> IS ASSIGNED.
        <fs_any> = ls_json-value.
        UNASSIGN <fs_any>.
      ENDIF.
    ENDLOOP.
    MOVE-CORRESPONDING  ls_json_str TO ls_log .
    ls_log-mandt = sy-mandt.
    APPEND ls_log TO gs_scr_1903-alv.
    IF ls_json_str-durum_kodu EQ 6.
      APPEND ls_set_orders TO gs_scr_1903-mal_kabul.
    ENDIF.
  ENDLOOP.

*  DATA: lt_eket TYPE TABLE OF eket,
*        ls_eket TYPE eket.
*
*  IF gs_scr_1903-mal_kabul IS NOT INITIAL.
*    SELECT * FROM eket INTO TABLE lt_eket
*             FOR ALL ENTRIES IN gs_scr_1903-mal_kabul
*             WHERE banfn   = gs_scr_1903-mal_kabul-banfn
*              AND  bnfpo   =  gs_scr_1903-mal_kabul-bnfpo.
**              AND AFNAM   = gs_scr_1903-mal_kabul-AFNAM.
*  ENDIF.
*  SORT gs_scr_1903-mal_kabul by banfn bnfpo.
*  LOOP AT lt_eket INTO ls_eket.
*    IF ls_eket-WEMNG > 0.
*      READ TABLE gs_scr_1903-mal_kabul INTO ls_set_orders  WITH KEY banfn = ls_eket-banfn
*                                                                    bnfpo = ls_eket-bnfpo
*                                                                    BINARY SEARCH.
*      IF sy-subrc eq 0.
*        ls_set_orders-SIL = 'X'.
*        MODIFY gs_scr_1903-mal_kabul  FROM ls_set_orders INDEX sy-tabix TRANSPORTING sil.
*      ENDIF.
*    ENDIF.
*  ENDLOOP.
*  DELETE gs_scr_1903-mal_kabul WHERE sil = 'X'.

  IF gs_scr_1903-alv IS NOT INITIAL.
    MODIFY zsog_mm_006_t_03 FROM TABLE gs_scr_1903-alv.
    COMMIT WORK AND WAIT.
  ENDIF.

ENDFORM.                    " GET_CARGO_STATUS
*&---------------------------------------------------------------------*
*&      Form  msg_display_error_table
*&---------------------------------------------------------------------*
FORM msg_display_error_table TABLES pt_return STRUCTURE bapiret2.
  CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
    EXPORTING
      it_message = pt_return[].
ENDFORM.                    "msg_display_error_table
*&---------------------------------------------------------------------*
*&      Form  BAPI_COMMIT_DESTINATION
*&---------------------------------------------------------------------*
FORM bapi_commit_destination .
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' DESTINATION 'NONE'
    EXPORTING
      wait = 'X'.
ENDFORM.                    "bapi_commit_destination
*&---------------------------------------------------------------------*
*&      Form  BAPI_ROLLBACK_DESTINATION
*&---------------------------------------------------------------------*
FORM bapi_rollback_destination .
  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK' DESTINATION 'NONE'.
ENDFORM.                    "bapi_rollback_destination
*&---------------------------------------------------------------------*
*&      Form  MAL_KABUL
*&---------------------------------------------------------------------*
FORM mal_kabul .

  DATA:   ls_goodsmvt_header  TYPE  bapi2017_gm_head_01,
          ls_goodsmvt_code    TYPE  bapi2017_gm_code,
          lt_item             TYPE TABLE OF bapi2017_gm_item_create,
          ls_item             TYPE bapi2017_gm_item_create,
          ls_goodsmvt_headret TYPE  bapi2017_gm_head_ret,
          lv_materialdocument TYPE  bapi2017_gm_head_ret-mat_doc,
          lv_matdocumentyear  TYPE  bapi2017_gm_head_ret-doc_year,
          lt_return           TYPE  TABLE OF bapiret2,
          ls_return           TYPE  bapiret2.

  DATA: ls_mal_kabul TYPE  zsog_mm_006_t_02.

  IF gs_scr_1903-mal_kabul IS INITIAL.
    MESSAGE i000(zsg) DISPLAY LIKE 'I' WITH 'Mal Kabul Yapacak Satatu Bulunamdı!'.
    RETURN.
  ENDIF.

  ls_goodsmvt_header-pstng_date = sy-datum.
  ls_goodsmvt_header-doc_date   = sy-datum .
  ls_goodsmvt_header-ref_doc_no   = 'Mal Girişi' .
  ls_goodsmvt_code-gm_code      = '01'.

  LOOP AT gs_scr_1903-mal_kabul INTO ls_mal_kabul.
    ls_item-material    = ls_mal_kabul-matnr.
    ls_item-plant       = ls_mal_kabul-werks.
    ls_item-stge_loc    = 'D001'.
    ls_item-batch       = ls_mal_kabul-afnam.
    ls_item-move_type   = '101'.
    ls_item-entry_qnt   = ls_mal_kabul-menge.
    ls_item-entry_uom   = ls_mal_kabul-meins.
    ls_item-po_number   = ls_mal_kabul-ebeln.
    ls_item-po_item     = ls_mal_kabul-ebelp.
    ls_item-mvt_ind     = 'B'.
    APPEND ls_item TO lt_item.
    CLEAR: ls_item.
  ENDLOOP.

  CALL FUNCTION 'BAPI_GOODSMVT_CREATE' DESTINATION 'NONE'
    EXPORTING
      goodsmvt_header  = ls_goodsmvt_header
      goodsmvt_code    = ls_goodsmvt_code-gm_code
    IMPORTING
      goodsmvt_headret = ls_goodsmvt_headret
      materialdocument = lv_materialdocument
      matdocumentyear  = lv_matdocumentyear
    TABLES
      goodsmvt_item    = lt_item
      return           = lt_return.

  IF lv_materialdocument IS NOT INITIAL.
    PERFORM bapi_commit_destination.
    ls_return-id = 'ZSG'.
    ls_return-number = '000'.
    ls_return-type = 'S'.
    ls_return-message_v1 = |Malzeme Belgesi | && | { lv_materialdocument } | && | kaydedildi |.
    APPEND ls_return TO lt_return.
  ELSE.
    PERFORM bapi_rollback_destination.
  ENDIF.


  IF lt_return IS NOT INITIAL.
    PERFORM msg_display_error_table TABLES lt_return.
  ENDIF.


ENDFORM.                    " MAL_KABUL
