*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_0012_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*----------------------------------------------------------------------*
FORM get_data .
  CONSTANTS:lc_lgort TYPE ekpo-lgort VALUE 'D001',
            lc_werks TYPE ekpo-lgort VALUE '2425'.

  CLEAR gt_data.
  SELECT a~ebeln
         a~ebelp
         a~matnr
         a~werks
         a~lgort
         b~menge
         a~meins
         c~afnam
  FROM ekpo AS a
  INNER JOIN eket AS b   ON  b~ebeln = a~ebeln
                         AND b~ebelp = a~ebelp
  INNER JOIN eban AS c   ON  c~banfn = b~banfn
                         AND c~bnfpo = b~bnfpo
  INTO  CORRESPONDING FIELDS OF TABLE gt_data
      WHERE a~ebeln IN s_ebeln
        AND a~werks EQ lc_werks
        AND a~lgort EQ lc_lgort.

  SORT gt_data BY ebeln ebelp.

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

    CREATE OBJECT gr_event_handler.
    SET HANDLER   gr_event_handler->handle_user_command  FOR gr_alvgrid.
    SET HANDLER   gr_event_handler->handle_toolbar       FOR gr_alvgrid.

    CALL METHOD gr_alvgrid->set_table_for_first_display
      EXPORTING
        i_buffer_active               = 'X'
        i_structure_name              = 'ZSOG_MM_007_S_009'
        is_layout                     = gs_layout
        it_toolbar_excluding          = gt_exclude[]
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
  DATA:ls_fieldcat TYPE lvc_s_fcat.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_buffer_active        = 'X'
      i_structure_name       = 'ZSOG_MM_007_S_009'
      i_client_never_display = 'X'
      i_bypassing_buffer     = 'X'
      i_internal_tabname     = 'gt_data'
    CHANGING
      ct_fieldcat            = gt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  LOOP AT gt_fieldcat INTO ls_fieldcat.
    CASE gs_fieldcat-fieldname.
*      WHEN 'MATNR'
*       gs_fieldcat-reptext   = 'Faturalama Belgesi'.
*        gs_fieldcat-scrtext_l = 'Faturalama Belgesi'.
*        gs_fieldcat-scrtext_s = 'Fat.Bel.'.
*        gs_fieldcat-scrtext_m = 'Fat.Belgesi'.
*        gs_fieldcat-edit     = 'X'.
    ENDCASE.
    ls_fieldcat-outputlen = 70.
    MODIFY gt_fieldcat FROM ls_fieldcat.
*
  ENDLOOP.

ENDFORM.                    "prepare_field_catalog
*&---------------------------------------------------------------------*
*&      Form  prepare_layout
*----------------------------------------------------------------------*
FORM prepare_layout.
  gs_layout-zebra      = 'X'.
  gs_layout-sel_mode   = 'A'.
  gs_layout-cwidth_opt = 'X'.
  gs_layout-info_fname = 'ROW_COLOR'.

ENDFORM.                    "prepare_layout
*&---------------------------------------------------------------------*
*&      Form  HANDLE_TOOLBAR
*----------------------------------------------------------------------*
FORM handle_toolbar  USING   e_object TYPE REF TO cl_alv_event_toolbar_set.
  DATA: ls_toolbar   TYPE stb_button.

  CLEAR ls_toolbar.
  MOVE 3 TO ls_toolbar-butn_type.
  APPEND ls_toolbar TO e_object->mt_toolbar.

  CLEAR ls_toolbar.
  MOVE 'SEND' TO ls_toolbar-function.
  MOVE text-002 TO ls_toolbar-quickinfo.
  MOVE text-002 TO ls_toolbar-text.
  MOVE icon_planning_in TO ls_toolbar-icon.
  MOVE ' ' TO ls_toolbar-disabled.
  APPEND ls_toolbar TO e_object->mt_toolbar.


ENDFORM.                    " HANDLE_TOOLBAR
*&---------------------------------------------------------------------*
*&      Form  HANDLE_USER_COMMAND
*----------------------------------------------------------------------*
FORM handle_user_command  USING    e_ucomm TYPE sy-ucomm.
  DATA :lt_selected_rows TYPE lvc_t_roid,
        lv_error         TYPE c,
        lt_group         TYPE tt_group,
        lt_data          TYPE TABLE OF zsog_mm_007_s_009,
        lt_messages      TYPE bapiret2_t.
  CLEAR: lv_error,lt_selected_rows,lt_group,lt_data,
         lt_messages.

  CASE e_ucomm.
    WHEN 'SEND'.
      PERFORM get_selected_rows      CHANGING lt_selected_rows lv_error.
      CHECK lv_error IS INITIAL.
      PERFORM set_bapi_data          USING    lt_selected_rows
                                     CHANGING lt_group
                                              lt_data.

      PERFORM call_bapi_good_receipt USING lt_group lt_data
                                     CHANGING lt_messages.

      PERFORM refresh_table_display.
      PERFORM display_messages       USING lt_messages.

  ENDCASE.
ENDFORM.                    " HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*&                 REFRESH_TABLE_DISPLAY
*&---------------------------------------------------------------------*
FORM refresh_table_display .
  DATA : ls_stable TYPE lvc_s_stbl .

  ls_stable-row = 'X'.
  ls_stable-col = 'X'.
  CALL METHOD gr_alvgrid->refresh_table_display
    EXPORTING
      is_stable      = ls_stable
      i_soft_refresh = 'X'
    EXCEPTIONS
      finished       = 1
      OTHERS         = 2.
ENDFORM.                    "refresh_table_display
*&---------------------------------------------------------------------*
*&                 FORM DISPLAY_MESSAGES
*&---------------------------------------------------------------------*
FORM display_messages  USING it_messages TYPE bapiret2_t.
  IF it_messages[] IS NOT INITIAL.
    CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
      EXPORTING
        it_message = it_messages[].
  ENDIF.
ENDFORM.                    "display_messages
*&---------------------------------------------------------------------*
*&      Form  GET_SELECTED_ROWS
*----------------------------------------------------------------------*
FORM get_selected_rows CHANGING et_selected_rows TYPE lvc_t_roid
                                ev_error         TYPE c.

  CALL METHOD gr_alvgrid->get_selected_rows
    IMPORTING
      et_row_no = et_selected_rows.

  IF et_selected_rows[] IS INITIAL.
    MESSAGE text-001 TYPE 'I'.
    ev_error = 'X'.
  ENDIF.


ENDFORM.                    " GET_SELECTED_ROWS
*&---------------------------------------------------------------------*
*&      Form  CALL_BAPI_GOOD_RECEIPT
*----------------------------------------------------------------------*
FORM call_bapi_good_receipt USING it_group       TYPE tt_group
                                  it_data        TYPE zsog_mm_007_tt_009
                            CHANGING et_messages TYPE bapiret2_t.
  CONSTANTS:lc_lgort TYPE ekpo-lgort VALUE 'D001',
            lc_werks TYPE ekpo-lgort VALUE '2425'.
  DATA:ls_goodsmvt_header  TYPE bapi2017_gm_head_01,
       ls_goodsmvt_code    TYPE bapi2017_gm_code ,
       ls_goodsmvt_headret TYPE bapi2017_gm_head_ret,
       lv_materialdocument TYPE bapi2017_gm_head_ret-mat_doc,
       lv_matdocumentyear  TYPE bapi2017_gm_head_ret-doc_year,
       ls_goodsmvt_item    TYPE bapi2017_gm_item_create,
       lt_goodsmvt_item    TYPE TABLE OF bapi2017_gm_item_create,
       lt_return           TYPE bapiret2_t,
       ls_return           TYPE bapiret2,
       ls_group            TYPE ty_group,
       ls_data             TYPE zsog_mm_007_s_009,
       ls_zsogmm007t07     TYPE zsog_mm_007_t_07,
       lt_zsogmm007t07     TYPE TABLE OF zsog_mm_007_t_07,
       lv_dummy            TYPE c.
  CLEAR:ls_goodsmvt_header ,ls_goodsmvt_code   ,
        ls_goodsmvt_headret,lv_materialdocument,
        lv_matdocumentyear ,ls_goodsmvt_item   ,
        ls_goodsmvt_item   ,lt_return,
        ls_zsogmm007t07    ,lt_zsogmm007t07,
        ls_return          ,ls_group       ,
        ls_data.

  LOOP AT it_group[] INTO ls_group.
    CLEAR ls_goodsmvt_header.
    ls_goodsmvt_header-pstng_date  = sy-datum.
    ls_goodsmvt_header-doc_date    = sy-datum.
    ls_goodsmvt_header-ref_doc_no  = ls_group-ebeln.

    CLEAR ls_goodsmvt_code.
    ls_goodsmvt_code-gm_code = '01'.

    CLEAR lt_goodsmvt_item.
    LOOP AT it_data[] INTO ls_data WHERE ebeln = ls_group-ebeln.
      CLEAR ls_goodsmvt_item.
      ls_goodsmvt_item-material	  = ls_data-matnr.
      ls_goodsmvt_item-plant      = lc_werks.
      ls_goodsmvt_item-stge_loc	  = lc_lgort.
      ls_goodsmvt_item-batch      = ls_data-afnam.
      ls_goodsmvt_item-move_type  = '101'.
      ls_goodsmvt_item-entry_qnt  = ls_data-menge.
      ls_goodsmvt_item-entry_uom  = ls_data-meins.
      ls_goodsmvt_item-po_number  = ls_data-ebeln.
      ls_goodsmvt_item-po_item    = ls_data-ebelp.
      ls_goodsmvt_item-mvt_ind    = 'B'.
      APPEND ls_goodsmvt_item TO lt_goodsmvt_item.

    ENDLOOP.

    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
      EXPORTING
        goodsmvt_header  = ls_goodsmvt_header
        goodsmvt_code    = ls_goodsmvt_code
      IMPORTING
        goodsmvt_headret = ls_goodsmvt_headret
        materialdocument = lv_materialdocument
        matdocumentyear  = lv_matdocumentyear
      TABLES
        goodsmvt_item    = lt_goodsmvt_item
        return           = lt_return.
    LOOP AT lt_return TRANSPORTING NO FIELDS WHERE type CA 'EAX'.
      EXIT.
    ENDLOOP.
    IF sy-subrc NE 0.
      LOOP AT it_data[] INTO ls_data WHERE ebeln = ls_group-ebeln.
        CLEAR ls_zsogmm007t07.
        MOVE-CORRESPONDING ls_data to ls_ZSOGMM007T07.
        ls_zsogmm007t07-mblnr     = lv_materialdocument.
        ls_zsogmm007t07-mjahr     = lv_matdocumentyear.
        ls_zsogmm007t07-user_name = sy-uname.
        ls_zsogmm007t07-post_date = sy-datum.
        ls_zsogmm007t07-post_time = sy-uzeit.
        INSERT zsog_mm_007_t_07 FROM ls_zsogmm007t07.
      ENDLOOP.
      IF sy-subrc = 0.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.
        CLEAR ls_data.
        ls_data-mblnr     = lv_materialdocument.
        ls_data-mjahr     = lv_matdocumentyear.
        ls_data-user_name = sy-uname.
        ls_data-post_date = sy-datum.
        ls_data-post_time = sy-uzeit.
        ls_data-row_color = gc_green.
        MESSAGE e009(zsg) INTO lv_dummy.
        PERFORM add_bapiret TABLES et_messages.
        MODIFY gt_data FROM ls_data TRANSPORTING mblnr
                                                 mjahr
                                                 user_name
                                                 post_date
                                                 post_time
                                                 row_color
                       WHERE ebeln = ls_group-ebeln.
      ELSE.
        CLEAR ls_return.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
          IMPORTING
            return = ls_return.

        CLEAR ls_data.
        ls_data-row_color = gc_red.

        MODIFY gt_data FROM ls_data TRANSPORTING row_color
                      WHERE ebeln = ls_group-ebeln.

      ENDIF.
    ELSE.
      CLEAR ls_return.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
        IMPORTING
          return = ls_return.

      CLEAR ls_data.
      ls_data-row_color = gc_red.

      MODIFY gt_data FROM ls_data TRANSPORTING row_color
                    WHERE ebeln = ls_group-ebeln.
    ENDIF.
    APPEND LINES OF lt_return TO et_messages.
  ENDLOOP.
ENDFORM.                    " CALL_BAPI_GOOD_RECEIPT
*&---------------------------------------------------------------------*
*&      Form  SET_BAPI_DATA
*----------------------------------------------------------------------*
FORM set_bapi_data  USING    it_selected_rows TYPE lvc_t_roid
                    CHANGING et_group         TYPE tt_group
                             et_data          TYPE zsog_mm_007_tt_009.
  DATA: ls_rows  TYPE lvc_s_roid,
        ls_group TYPE ty_group,
        ls_data   TYPE zsog_mm_007_s_009.

  CLEAR :ls_rows,ls_data,ls_group.
  LOOP AT it_selected_rows INTO ls_rows.
    READ TABLE gt_data INTO ls_data INDEX ls_rows-row_id.
    IF sy-subrc = 0.
      APPEND ls_data  TO et_data.

      CLEAR ls_group.
      ls_group-ebeln = ls_data-ebeln.
      COLLECT ls_group INTO et_group.
    ENDIF.

  ENDLOOP.
ENDFORM.                    " SET_BAPI_DATA
*&---------------------------------------------------------------------*
*&      Form  ADD_BAPIRET
*----------------------------------------------------------------------*
FORM add_bapiret  TABLES   et_message STRUCTURE bapiret2 .
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
  APPEND ls_return TO et_message.

ENDFORM.                    " ADD_BAPIRET
