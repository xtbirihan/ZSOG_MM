*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_019_QUERYSHIPMENT_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*----------------------------------------------------------------------*
FORM get_data .
  DATA: ls_alv       TYPE zsog_mm_019_yi_cargo_02.
  DATA: lv_proxy     TYPE REF TO zykco_shipping_order_dispatche.
  DATA: lt_messages  TYPE bapiret2_t.

  IF r_data = 'X'.
    PERFORM get_status.

    IF sy-batch NE 'X'.
      CALL SCREEN 0100.
    ENDIF.
  ENDIF.

  IF r_grecpt = 'X'.
    PERFORM get_documents_for_good_receipt.
    IF sy-batch EQ 'X'.
    ELSE.
      CALL SCREEN 0100.
    ENDIF.
  ENDIF.
ENDFORM.                    "get_data
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*----------------------------------------------------------------------*
FORM display_alv .
  IF gr_alvgrid IS INITIAL.

    CREATE OBJECT gr_custom_container
      EXPORTING
        container_name              = gr_custom_control_name
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT gr_alvgrid
      EXPORTING
        i_parent          = gr_custom_container
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    PERFORM prepare_field_catalog.
    PERFORM prepare_layout.

    CREATE OBJECT gr_event_receiver .
    SET HANDLER gr_event_receiver->handle_user_command   FOR gr_alvgrid.
    SET HANDLER gr_event_receiver->handle_toolbar        FOR gr_alvgrid.


    CALL METHOD gr_alvgrid->set_table_for_first_display
      EXPORTING
        i_buffer_active               = 'X'
        i_structure_name              = 'ZSOG_MM_019_YI_CARGO_02'
        is_layout                     = gs_layout
        it_toolbar_excluding          = gt_exclude[]
*        it_hyperlink                  = gt_hype_link
      CHANGING
        it_outtab                     = gt_data
        it_fieldcatalog               = gt_fieldcat
        it_sort                       = gt_sort
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
*   Implement suitable error handling here
    ENDIF.

  ELSEIF gr_alvgrid IS NOT INITIAL.
    CALL METHOD gr_alvgrid->refresh_table_display.
  ENDIF.

ENDFORM.                    "display_alv
*&---------------------------------------------------------------------*
*&      Form  PREPARE_FIELD_CATALOG
*----------------------------------------------------------------------*
FORM prepare_field_catalog .
  FIELD-SYMBOLS :<fs_fieldcat> TYPE lvc_s_fcat.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_buffer_active        = 'X'
      i_structure_name       = 'ZSOG_MM_019_YI_CARGO_02'
      i_client_never_display = 'X'
      i_bypassing_buffer     = 'X'
      i_internal_tabname     = 'GT_DATA'
    CHANGING
      ct_fieldcat            = gt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  LOOP AT gt_fieldcat ASSIGNING <fs_fieldcat>.
    CASE <fs_fieldcat>-fieldname.
      WHEN 'RESULT_CODE'.
*       gs_fieldcat-reptext   = 'Faturalama Belgesi'.
*        gs_fieldcat-scrtext_l = 'Faturalama Belgesi'.
*        gs_fieldcat-scrtext_s = 'Fat.Bel.'.
*        gs_fieldcat-scrtext_m = 'Fat.Belgesi'.
        <fs_fieldcat>-no_out     = 'X'.
*      WHEN 'TAKIP_LINKI'.
*        <fs_fieldcat>-hotspot = 'X'.
*        <fs_fieldcat>-web_field = 'URL_HANDLE'.
      WHEN 'URL_HANDLE'.
        <fs_fieldcat>-no_out     = 'X'.
      WHEN 'SIL'.
        <fs_fieldcat>-no_out     = 'X'.
    ENDCASE.
  ENDLOOP.
*  <fs_fieldcat>-fieldname = 'TAKIP_LINKI'.
*  <fs_fieldcat>-web_field = 'URL_HANDLE'.
*  APPEND <fs_fieldcat> TO gt_fieldcat.
ENDFORM.                    "prepare_field_catalog

*&---------------------------------------------------------------------*
*&      Form  prepare_layout
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM prepare_layout.
  gs_layout-zebra = 'X'.
  gs_layout-cwidth_opt = 'X'.
  gs_layout-info_fname =  'ROW_COLOR'.
*  gs_layout-grid_title = 'ZZZ Raporu'.
  gs_layout-sel_mode = 'A'.
ENDFORM.                    "prepare_layout
*&---------------------------------------------------------------------*
*&      Form  GET_PROXY
*----------------------------------------------------------------------*
FORM get_proxy  CHANGING ev_proxy TYPE REF TO zykco_shipping_order_dispatche
                         ev_error TYPE c.
  DATA: lr_sys_fault TYPE REF TO cx_ai_system_fault.
  DATA: lv_string TYPE string.
  TRY.
      CREATE OBJECT ev_proxy
        EXPORTING
          logical_port_name = 'ZYURTICI_KARGO_LP'.
    CATCH cx_ai_system_fault  INTO lr_sys_fault.
      ev_error = 'X'.
      lv_string = lr_sys_fault->get_text( ).
  ENDTRY.
ENDFORM.                    " GET_PROXY
*&---------------------------------------------------------------------*
*&      Form  SET_ORDERS
*----------------------------------------------------------------------*
FORM call_bapi  TABLES   it_alv      STRUCTURE   zsog_mm_019_yi_cargo_02
                CHANGING et_messages TYPE bapiret2_t.
  DATA:   ls_goodsmvt_header  TYPE  bapi2017_gm_head_01,
          ls_goodsmvt_code    TYPE  bapi2017_gm_code,
          lt_item             TYPE TABLE OF bapi2017_gm_item_create,
          ls_item             TYPE bapi2017_gm_item_create,
          ls_goodsmvt_headret TYPE  bapi2017_gm_head_ret,
          lv_materialdocument TYPE  bapi2017_gm_head_ret-mat_doc,
          lv_matdocumentyear  TYPE  bapi2017_gm_head_ret-doc_year,
          lt_return           TYPE  TABLE OF bapiret2,
          ls_return           TYPE  bapiret2.

  DATA: ls_mal_kabul TYPE  zsog_mm_019_yi_cargo_02.
  FIELD-SYMBOLS : <fs_mal_kabul> TYPE zsog_mm_019_yi_cargo_02.
  IF gt_data IS INITIAL.
    MESSAGE i000(zsg) DISPLAY LIKE 'I' WITH 'Mal Kabul Yapacak Satatu Bulunamdı!'.
    RETURN.
  ENDIF.

  ls_goodsmvt_header-pstng_date = sy-datum.
  ls_goodsmvt_header-doc_date   = sy-datum .
  ls_goodsmvt_header-ref_doc_no = 'Mal Girişi' .
  ls_goodsmvt_code-gm_code      = '01'.

  LOOP AT gt_data ASSIGNING <fs_mal_kabul>.
    ls_item-material    = <fs_mal_kabul>-matnr.
    ls_item-plant       = <fs_mal_kabul>-werks.
    ls_item-stge_loc    = 'D001'.
    ls_item-batch       = <fs_mal_kabul>-afnam.
    ls_item-move_type   = '101'.
    ls_item-entry_qnt   = <fs_mal_kabul>-menge.
    ls_item-entry_uom   = <fs_mal_kabul>-meins.
    ls_item-po_number   = <fs_mal_kabul>-ebeln.
    ls_item-po_item     = <fs_mal_kabul>-ebelp.
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
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

    ls_return-id = 'ZSG'.
    ls_return-number = '000'.
    ls_return-type = 'S'.
    ls_return-message_v1 = |Malzeme Belgesi | && | { lv_materialdocument } | && | kaydedildi |.
    APPEND ls_return TO et_messages.

    ls_mal_kabul-mblnr           = lv_materialdocument.
    ls_mal_kabul-mjahr           = lv_matdocumentyear.
    ls_mal_kabul-doc_record_date = sy-datum.
    ls_mal_kabul-doc_record_time = sy-uzeit.
    ls_mal_kabul-user_name       = sy-uname.

    LOOP AT gt_data INTO ls_mal_kabul.
      MODIFY gt_data FROM ls_mal_kabul TRANSPORTING mblnr
                                                  mjahr
                                                  doc_record_date
                                                  doc_record_time
                                                  user_name
                                     WHERE cargo_key   = ls_mal_kabul-cargo_key
                                       AND invoice_key = ls_mal_kabul-invoice_key
                                       AND ebelp       = ls_mal_kabul-ebelp
                                       AND banfn       = ls_mal_kabul-banfn
                                       AND bnfpo       = ls_mal_kabul-bnfpo.

      UPDATE zsog_mm_019_t_03 SET mblnr = ls_mal_kabul-mblnr
                                  mjahr = ls_mal_kabul-mjahr
                                  doc_record_date = ls_mal_kabul-doc_record_date
                                  doc_record_time = ls_mal_kabul-doc_record_time
                                  user_name = ls_mal_kabul-user_name
                               WHERE cargo_key = ls_mal_kabul-cargo_key
                                 AND invoice_key = ls_mal_kabul-invoice_key
                                 AND ebelp       = ls_mal_kabul-ebelp
                                 AND banfn       = ls_mal_kabul-banfn
                                 AND bnfpo       = ls_mal_kabul-bnfpo.

      UPDATE zsog_mm_019_t_02 SET mblnr = ls_mal_kabul-mblnr
                              WHERE cargo_key   = ls_mal_kabul-cargo_key
                                AND cargo_key   = ls_mal_kabul-cargo_key
                                AND invoice_key = ls_mal_kabul-invoice_key
                                AND ebeln       = ls_mal_kabul-ebeln
                                AND ebelp       = ls_mal_kabul-ebelp
                                AND banfn       = ls_mal_kabul-banfn
                                AND bnfpo       = ls_mal_kabul-bnfpo.

    ENDLOOP.
  ELSE.
    CLEAR ls_return.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
      IMPORTING
        return = ls_return.

  ENDIF.

  IF sy-batch NE 'X'.
    PERFORM refresh_table_display USING gr_alvgrid.
  ENDIF.
ENDFORM.                    " SET_ORDERS
*&---------------------------------------------------------------------*
*&                 REFRESH_TABLE_DISPLAY
*&---------------------------------------------------------------------*
FORM refresh_table_display USING ir_alvgrid TYPE REF TO cl_gui_alv_grid.
  DATA : ls_stable TYPE lvc_s_stbl .

  ls_stable-row = 'X'.
  ls_stable-col = 'X'.
  CALL METHOD ir_alvgrid->refresh_table_display
    EXPORTING
      is_stable      = ls_stable
      i_soft_refresh = 'X'
    EXCEPTIONS
      finished       = 1
      OTHERS         = 2.
ENDFORM.                    "refresh_table_display
*&---------------------------------------------------------------------*
*& Form handle_toolbar
*&---------------------------------------------------------------------*
FORM handle_toolbar  USING    e_object TYPE REF TO cl_alv_event_toolbar_set.
  CONSTANTS:c_separator               TYPE i VALUE 3.
  DATA: ls_toolbar  TYPE stb_button.

  IF r_grecpt = 'X'.
    CLEAR ls_toolbar.
    MOVE 3 TO ls_toolbar-butn_type.
    APPEND ls_toolbar TO e_object->mt_toolbar.
    CLEAR ls_toolbar.
    MOVE 'GOOD_RECEIPT'   TO ls_toolbar-function.
    MOVE text-002 TO ls_toolbar-quickinfo.
    MOVE text-002 TO ls_toolbar-text.
    MOVE icon_planning_in TO ls_toolbar-icon.
    MOVE ' ' TO ls_toolbar-disabled.
    APPEND ls_toolbar TO e_object->mt_toolbar.
  ENDIF.
ENDFORM.                    "handle_toolbar
*&---------------------------------------------------------------------*
*& Form handle_user_command
*&---------------------------------------------------------------------*
FORM handle_user_command  USING  e_ucomm TYPE  sy-ucomm.
  DATA:lt_selected_data  TYPE TABLE OF zsog_mm_019_yi_cargo_02,
       lv_error          TYPE c,
       lt_selected_rows  TYPE lvc_t_roid,
       lt_messages       TYPE bapiret2_t,
       lv_return_code    TYPE i,
       lv_proxy          TYPE REF TO zykco_shipping_order_dispatche.
  CLEAR: lv_error,lt_selected_rows,lt_messages,
         lv_proxy.
  CASE e_ucomm.
    WHEN 'GOOD_RECEIPT'.
      CLEAR: lv_error,lt_selected_rows.

      PERFORM get_proxy                     CHANGING  lv_proxy
                                                      lv_error.
      CHECK lv_error IS INITIAL.
      CLEAR lt_messages.
      PERFORM call_bapi                     TABLES   gt_data
                                            CHANGING lt_messages.

      PERFORM refresh_table_display         USING    gr_alvgrid.
      PERFORM display_messages              USING    lt_messages.
  ENDCASE.
ENDFORM.                    "handle_user_command
*&---------------------------------------------------------------------*
*& Form get_selected_rows
*&---------------------------------------------------------------------*
FORM get_selected_rows  USING    ir_alvgrid       TYPE REF TO cl_gui_alv_grid
                        CHANGING ev_error         TYPE c
                                 et_selected_rows TYPE lvc_t_roid.

  CALL METHOD ir_alvgrid->get_selected_rows
    IMPORTING
      et_row_no = et_selected_rows[].

  IF et_selected_rows[] IS INITIAL.
    MESSAGE text-001 TYPE 'I'.
    ev_error = 'X'.
  ENDIF.
ENDFORM.                    "get_selected_rows
*&---------------------------------------------------------------------*
*& Form set_selected_rows
*&---------------------------------------------------------------------*
FORM set_selected_rows  TABLES et_selected_data STRUCTURE zsog_mm_019_yi_cargo_02
                        USING  it_selected_rows TYPE lvc_t_roid.
  DATA:ls_data TYPE zsog_mm_019_yi_cargo_02,
       ls_rows TYPE lvc_s_roid.

  LOOP AT it_selected_rows[] INTO ls_rows.
    CLEAR ls_data.
    READ TABLE gt_data[] INTO ls_data INDEX ls_rows-row_id .
    IF sy-subrc = 0.
      APPEND ls_data TO et_selected_data.
    ENDIF.
  ENDLOOP.
ENDFORM.                    "set_selected_rows
*&---------------------------------------------------------------------*
*&                 FORM DISPLAY_MESSAGES
*&---------------------------------------------------------------------*
FORM display_messages USING it_messages TYPE bapiret2_t.
  IF it_messages[] IS NOT INITIAL.
    CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
      EXPORTING
        it_message = it_messages[].
  ENDIF.
ENDFORM.                    "display_messages
*&---------------------------------------------------------------------*
*&      Form  GET_CARGO_STATUS
*&---------------------------------------------------------------------*
FORM get_cargo_status TABLES   it_shipments STRUCTURE zsog_mm_019_yi_cargo_02
                      USING    iv_proxy     TYPE REF TO zykco_shipping_order_dispatche
                      CHANGING et_messages  TYPE bapiret2_t.

  DATA : ls_log             TYPE zsog_mm_019_t_03,
         lt_log             TYPE TABLE OF zsog_mm_019_t_03,
         ls_shipments       TYPE zsog_mm_019_yi_cargo_02,
         lv_dummy           TYPE c,
         ls_messages        TYPE bapiret2,
         ls_return          TYPE bapiret2,
         lv_message_c(100)  TYPE c.

  DATA : ls_input           TYPE zykshipping_order_dispatcher_5,
         ls_output          TYPE zykshipping_order_dispatcher_2,
         lv_proxy           TYPE REF TO zykco_shipping_order_dispatche,
         lr_sys_fault       TYPE REF TO cx_ai_system_fault,
         ls_user            TYPE zsog_mm_019_t_01,
         ls_shippingdetail  TYPE zykshipping_delivery_detail_vo,
         lv_string          TYPE string,
         ls_hype_link TYPE lvc_s_hype,
         lv_link TYPE int4.
  FIELD-SYMBOLS: <fs_any> TYPE any.

  CLEAR ls_user.
  SELECT SINGLE * FROM zsog_mm_019_t_01 INTO ls_user
                             WHERE sysid = sy-sysid.
  IF sy-subrc NE 0 OR ls_user IS INITIAL.
    MESSAGE e021(zsg) INTO lv_dummy.
    PERFORM add_bapiret TABLES et_messages.
    EXIT.
  ENDIF.
  CHECK ls_user IS NOT INITIAL.

  LOOP AT it_shipments INTO ls_shipments where doc_id is INITIAL.
    CHECK ls_shipments-row_color NE 'C500'.
    CLEAR: ls_log .
    CLEAR:  ls_output.
    IF <fs_any> IS ASSIGNED.
      UNASSIGN <fs_any>.
    ENDIF.

    ls_input-query_shipment-ws_user_name = ls_user-user_name.
    ls_input-query_shipment-ws_password  = ls_user-password.
    ls_input-query_shipment-ws_language  = ls_user-userlanguage.

    APPEND ls_shipments-barcode TO ls_input-query_shipment-keys .
    ls_input-query_shipment-key_type            = '0'.
*    ls_input-query_shipment-key_type           = '1'.
    ls_input-query_shipment-add_historical_data = 'X'.
*    ls_input-query_shipment-only_tracking       = 'X'.

    TRY.
        CALL METHOD iv_proxy->query_shipment
          EXPORTING
            input  = ls_input
          IMPORTING
            output = ls_output.
      CATCH cx_ai_system_fault INTO lr_sys_fault.
        lv_string = lr_sys_fault->get_text( ).
      CATCH cx_ai_application_fault.
      CATCH cx_sy_ref_is_initial.
    ENDTRY.

    IF ls_output IS INITIAL.
      ls_shipments-row_color = 'C600'.
      CLEAR lv_dummy.
      MESSAGE e020(zsg) INTO lv_dummy.
      PERFORM add_bapiret TABLES et_messages.
    ELSE.
      ls_shipments-out_flag = ls_output-query_shipment_response-shipping_delivery_vo-base-base-out_flag.
      ls_shipments-out_result = ls_output-query_shipment_response-shipping_delivery_vo-base-base-out_result.
      ls_shipments-shipping_count = ls_output-query_shipment_response-shipping_delivery_vo-count.


      CLEAR ls_shippingdetail.
      READ TABLE ls_output-query_shipment_response-shipping_delivery_vo-shipping_delivery_detail_vo
                                                  INTO ls_shippingdetail
                                                  WITH KEY cargo_key   = ls_shipments-barcode.
      IF sy-subrc = 0.
        IF ls_shippingdetail-err_code EQ 0.
          ls_shipments-row_color = 'C500'.
        ELSE.
          ls_shipments-row_color = 'C600'.
        ENDIF.
        ls_shipments-cargo_key = ls_shippingdetail-cargo_key.
        ls_shipments-barcode   = ls_shippingdetail-cargo_key.
        ls_shipments-err_code  = ls_shippingdetail-err_code.
        IF ls_shippingdetail-err_code EQ 0.
          MESSAGE s022(zsg) INTO ls_shippingdetail-err_message.
        ENDIF.
        ls_shipments-err_message      = ls_shippingdetail-err_message.


        ls_shipments-invoice_key       = ls_shippingdetail-invoice_key.
        ls_shipments-job_id            = ls_shippingdetail-job_id.

        ls_shipments-sender_cust_id    = ls_output-query_shipment_response-shipping_delivery_vo-sender_cust_id.
        ls_shipments-operation_code    = ls_shippingdetail-operation_code.
        ls_shipments-operation_message = ls_shippingdetail-operation_message.
        ls_shipments-operation_status  = ls_shippingdetail-operation_status.

        ls_shipments-doc_id            = ls_shippingdetail-shipping_delivery_item_detail-doc_id.
        ls_shipments-delivery_date     = ls_shippingdetail-shipping_delivery_item_detail-delivery_date.
        ls_shipments-delivery_time     = ls_shippingdetail-shipping_delivery_item_detail-delivery_time.
        ls_shipments-receiver_info     = ls_shippingdetail-shipping_delivery_item_detail-receiver_info.
        ls_shipments-receivercustname  = ls_shippingdetail-shipping_delivery_item_detail-receiver_cust_name.
        ls_shipments-takip_linki       = ls_shippingdetail-shipping_delivery_item_detail-tracking_url.
*        lv_link = lv_link + 1.
*        ls_shipments-url_handle        = lv_link.

*        CLEAR ls_hype_link.
*        ls_hype_link-handle = lv_link.
*        ls_hype_link-href   = ls_shipments-takip_linki.
*        APPEND ls_hype_link TO gt_hype_link.

        MOVE-CORRESPONDING ls_shipments TO ls_log.
        APPEND ls_log TO lt_log.


        CLEAR ls_messages.
        ls_messages-message      = ls_shippingdetail-invoice_key.
        CLEAR lv_message_c.
        lv_message_c             = ls_shippingdetail-err_message.
        IF strlen( lv_message_c ) > 50.
          ls_messages-message_v1 = lv_message_c+0(50).
          ls_messages-message_v2 = lv_message_c+50(50).
        ELSE.
          ls_messages-message_v1 = ls_shippingdetail-err_message.
          CONCATENATE text-003  ls_shippingdetail-cargo_key INTO
           ls_messages-message_v2 .
        ENDIF.
        CONCATENATE text-005 ls_shippingdetail-invoice_key INTO
        ls_messages-message_v3.
        IF ls_shippingdetail-err_code EQ 0.
          ls_messages-type = 'S'.
        ELSE.
          ls_messages-type = 'E'.
        ENDIF.
        PERFORM convert_message_to_bapiret USING ls_messages
                                           CHANGING et_messages.
      ELSE.
        ls_shipments-row_color = 'C600'.

      ENDIF.
    ENDIF.
    APPEND ls_shipments TO gt_data.

    CLEAR:  ls_input, ls_output, ls_shipments, ls_log , ls_shippingdetail.
  ENDLOOP.
*
  IF lt_log IS NOT INITIAL.
    MODIFY zsog_mm_019_t_03 FROM TABLE lt_log.
    IF sy-subrc = 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
    ELSE.
      CLEAR ls_return.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
        IMPORTING
          return = ls_return.
      CLEAR: et_messages[],lv_dummy.
      MESSAGE e020(zsg) INTO lv_dummy.
      PERFORM add_bapiret TABLES et_messages.
    ENDIF.
  ENDIF.

ENDFORM.                    " GET_CARGO_STATUS
*&---------------------------------------------------------------------*
*&      Form  GET_STATUS
*----------------------------------------------------------------------*
FORM get_status .
  DATA: lt_shipments TYPE TABLE OF zsog_mm_019_yi_cargo_02,
        lv_proxy     TYPE REF TO zykco_shipping_order_dispatche,
        lt_messages  TYPE bapiret2_t,
        lv_error     TYPE c.

  SELECT * FROM zsog_mm_019_t_02 INTO CORRESPONDING FIELDS OF TABLE lt_shipments
                                         WHERE bedat    IN s_bedat
                                           AND ebeln    IN s_ebeln
                                           AND err_code EQ 0
                                           AND mblnr    EQ space.
  IF lt_shipments IS  INITIAL.
    MESSAGE i013(zsg) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.
  SORT gt_data BY ebeln ebelp.
  PERFORM get_proxy CHANGING lv_proxy lv_error.
  CHECK lv_error IS INITIAL.
  PERFORM get_cargo_status TABLES lt_shipments
                           USING  lv_proxy
                           CHANGING lt_messages .

  PERFORM display_messages      USING lt_messages.

ENDFORM.                    " GET_STATUS
*&---------------------------------------------------------------------*
*&      Form  GET_DOCUMENTS_FOR_GOOD_RECEIPT
*----------------------------------------------------------------------*
FORM get_documents_for_good_receipt .
  DATA: lt_goodreceipt TYPE TABLE OF zsog_mm_019_yi_cargo_02.
  SELECT a~ebeln
         a~ebelp
         a~banfn
         a~bnfpo
         a~matnr
         a~maktx
         a~menge
         a~meins
         a~werks
         a~name1
         a~afnam
         a~afnam_name1
         a~name_co
         a~street
         a~house_num1
         a~city2
         a~city1
         a~bezei
         a~telnr_long
         a~telnr_long2
         a~bedat
         b~job_id
         b~out_result
         b~out_flag
         b~shipping_count
         b~cargo_key
         b~barcode
         b~invoice_key
         b~err_code
         b~err_message
         b~delivery_date
         b~delivery_time
         b~receiver_info
    FROM zsog_mm_019_t_02 AS a
    INNER JOIN zsog_mm_019_t_03 AS b ON  b~cargo_key =  a~cargo_key      "b~invoice_key = a~invoice_key
                                     "AND
    INTO CORRESPONDING FIELDS OF TABLE  lt_goodreceipt
      WHERE a~bedat IN s_bedat
        AND a~ebeln IN s_ebeln
        AND b~operation_code EQ 5
        AND b~mblnr  EQ space
        AND b~mjahr  EQ space.
  IF lt_goodreceipt IS   NOT INITIAL.
    APPEND LINES OF lt_goodreceipt TO gt_data.
  ENDIF.

  IF lt_goodreceipt IS  INITIAL.
    MESSAGE i013(zsg) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.
ENDFORM.                    " GET_DOCUMENTS_FOR_GOOD_RECEIPT
*&---------------------------------------------------------------------*
*& Form add_bapiret
*&---------------------------------------------------------------------*
FORM add_bapiret  TABLES et_messages STRUCTURE bapiret2.
  DATA : ls_return TYPE bapiret2.

  CALL FUNCTION 'FS_BAPI_BAPIRET2_FILL'
    EXPORTING
      type   = sy-msgty
      cl     = sy-msgid
      number = sy-msgno
      par1   = sy-msgv1
      par2   = sy-msgv2
      par3   = sy-msgv3
      par4   = sy-msgv4
    IMPORTING
      return = ls_return.
  APPEND ls_return TO et_messages.

ENDFORM.                    "add_bapiret
*&---------------------------------------------------------------------*
*&      Form  CONVERT_MESSAGE_TO_BAPIRET
*----------------------------------------------------------------------*
FORM convert_message_to_bapiret USING    is_messages TYPE bapiret2
                                CHANGING et_messages TYPE bapiret2_t.
  DATA:ls_messages TYPE bapiret2.
  CLEAR ls_messages.
  ls_messages-type       = is_messages-type.
  ls_messages-id         = 'ZSG'.
  ls_messages-number     = '000'.
  ls_messages-message    = is_messages-message.
  ls_messages-message_v1 = is_messages-message_v1.
  ls_messages-message_v2 = is_messages-message_v2.
  ls_messages-message_v3 = is_messages-message_v3.
  ls_messages-message_v4 = is_messages-message_v4.
  CONDENSE:ls_messages-message_v1,
           ls_messages-message_v2,
           ls_messages-message_v3,
           ls_messages-message_v4,
           ls_messages-message.
  APPEND ls_messages TO et_messages.
ENDFORM.                    " CONVERT_MESSAGE_TO_BAPIRET
