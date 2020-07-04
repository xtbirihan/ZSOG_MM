*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_009_KARGO_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data.
  DATA: lt_cargo TYPE TABLE OF zsog_mm_007_s_010,
        ls_cargo TYPE zsog_mm_007_s_010.
  DATA: lt_teslimat_bilgisi TYPE TABLE OF zsog_mm_007_s_010,
        ls_teslimat_bilgisi TYPE zsog_mm_007_s_010.
  DATA: ls_alv  TYPE zsog_mm_007_s_010,
        lv_code TYPE int4.

  SELECT z2~ebeln
         z2~ebelp
         z2~banfn
         z2~bnfpo
         z2~matnr
         z2~maktx
         z2~menge
         z2~meins
         z2~werks
         z2~name1
         z2~afnam
         z2~afnam_name1
         z2~street
         z2~house_num1
         z2~city2
         z2~city1
         z2~bezei
         z2~telnr_long
         z2~telnr_long2
         z2~bedat
         z2~err_code
         e~badat
         z2~cargo_key
         z2~invoice_key
    FROM zsog_mm_019_t_02 AS z2   "added by ilknurnacar 07042020
*    FROM zsog_mm_006_t_02 AS z2  "commented by ilknurnacar 07042020
    LEFT OUTER JOIN eban AS e ON e~banfn = z2~banfn
                             AND e~bnfpo = z2~bnfpo
    INTO CORRESPONDING FIELDS OF TABLE lt_cargo
    WHERE  z2~afnam  IN s_kunnr
      AND  z2~matnr  IN s_matnr
      AND  z2~ebeln  IN s_ebeln.

  IF lt_cargo IS NOT INITIAL.
    SELECT cargo_key
           invoice_key
           ebelp
           banfn
           bnfpo
           out_flag
           out_result
           sender_cust_id
           shipping_count
           job_id
           doc_id
           operation_code
           operation_message
           operation_status
           delivery_date
           delivery_time
           receiver_info
           err_code
           err_message
           mblnr
           mjahr
           doc_record_date
           doc_record_time
           user_name
           receivercustname
           takip_linki
      FROM zsog_mm_019_t_03   " added by ilknunacar07042020
*      FROM zsog_mm_006_t_03  " commented by ilknunacar07042020
      INTO CORRESPONDING FIELDS OF TABLE lt_teslimat_bilgisi
      FOR ALL ENTRIES IN lt_cargo
      WHERE cargo_key = lt_cargo-cargo_key
        AND operation_code IN s_drm.
  ENDIF.

  SORT lt_teslimat_bilgisi BY cargo_key .
  LOOP AT lt_cargo INTO ls_cargo.
    READ TABLE lt_teslimat_bilgisi INTO ls_teslimat_bilgisi
                                   WITH KEY cargo_key   = ls_cargo-cargo_key " added by ilknunacar07042020
                                   BINARY SEARCH.

    IF s_drm IS INITIAL.
      CONDENSE ls_cargo-err_code.
      CLEAR lv_code.
      lv_code = ls_cargo-err_code.
      IF lv_code EQ 0.
        ls_cargo-err_message = 'Sipariş Kargoya iletildi'.
      ELSE.
        ls_cargo-err_message = 'Sipariş Kargoya iletilmedi'.
      ENDIF.
      ls_cargo-operation_code    = ls_teslimat_bilgisi-operation_code.
      ls_cargo-operation_message = ls_teslimat_bilgisi-operation_message.
      ls_cargo-operation_status  = ls_teslimat_bilgisi-operation_status.
      ls_cargo-delivery_date     = ls_teslimat_bilgisi-delivery_date.
      ls_cargo-delivery_time     = ls_teslimat_bilgisi-delivery_time.
      ls_cargo-receiver_info     = ls_teslimat_bilgisi-receiver_info.
      ls_cargo-receivercustname  = ls_teslimat_bilgisi-receiver_info.
      ls_cargo-takip_linki       = ls_teslimat_bilgisi-takip_linki.
      APPEND ls_cargo TO gt_alv.
    ELSE.
      IF sy-subrc EQ '0'.
        CONDENSE ls_cargo-err_code.
        CLEAR lv_code.
        lv_code = ls_cargo-err_code.
        IF lv_code EQ '0'.
          ls_cargo-err_message = 'Sipariş Kargoya iletildi'.
        ELSE.
          ls_cargo-err_message = 'Sipariş Kargoya iletilmedi'.
        ENDIF.
        ls_cargo-operation_code    = ls_teslimat_bilgisi-operation_code.
        ls_cargo-operation_message = ls_teslimat_bilgisi-operation_message.
        ls_cargo-operation_status  = ls_teslimat_bilgisi-operation_status.
        ls_cargo-delivery_date     = ls_teslimat_bilgisi-delivery_date.
        ls_cargo-delivery_time     = ls_teslimat_bilgisi-delivery_time.
        ls_cargo-receiver_info     = ls_teslimat_bilgisi-receiver_info.
        ls_cargo-receivercustname  = ls_teslimat_bilgisi-receiver_info.
        ls_cargo-takip_linki       = ls_teslimat_bilgisi-takip_linki.
        APPEND ls_cargo TO gt_alv.
      ENDIF.
    ENDIF.

    CLEAR: ls_teslimat_bilgisi, ls_cargo .
  ENDLOOP.
ENDFORM.                    "get_data

*&---------------------------------------------------------------------*
*&      Form  fieldcatalog
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM fieldcatalog .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
*     I_BUFFER_ACTIVE        =
      i_structure_name       = 'ZSOG_MM_007_S_010'
*     I_CLIENT_NEVER_DISPLAY = 'X'
*     I_BYPASSING_BUFFER     =
*     I_INTERNAL_TABNAME     =
    CHANGING
      ct_fieldcat            = gt_fieldcat[]
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  CLEAR gs_fieldcat.
  LOOP AT gt_fieldcat INTO gs_fieldcat.
    CASE gs_fieldcat-fieldname.
      WHEN 'AFNAM'.
        gs_fieldcat-scrtext_s = 'Bayi'.
        gs_fieldcat-scrtext_m = 'Bayi'.
        gs_fieldcat-scrtext_l = 'Bayi'.
        gs_fieldcat-colddictxt = 'M'.
      WHEN 'AFNAM_NAME1'.
        gs_fieldcat-scrtext_s = 'Bayi Adı'.
        gs_fieldcat-scrtext_m = 'Bayi Adı'.
        gs_fieldcat-scrtext_l = 'Bayi Adı'.
        gs_fieldcat-colddictxt = 'M'.
      WHEN 'MAKTX'.
        gs_fieldcat-scrtext_s = 'Malzm Tanımı'.
        gs_fieldcat-scrtext_m = 'Malzeme Tanımı'.
        gs_fieldcat-scrtext_l = 'Malzeme Tanımı'.
        gs_fieldcat-colddictxt = 'M'.
      WHEN 'BNFPO'.
        gs_fieldcat-scrtext_s = 'Talep Kalemi'.
        gs_fieldcat-scrtext_m = 'Talep Kalemi'.
        gs_fieldcat-scrtext_l = 'Talep Kalemi'.
        gs_fieldcat-colddictxt = 'M'.
      WHEN 'EBELN'.
        gs_fieldcat-scrtext_s = 'SA Belge No'.
        gs_fieldcat-scrtext_m = 'SA Belge No'.
        gs_fieldcat-scrtext_l = 'Satınalma Belge No'.
        gs_fieldcat-colddictxt = 'M'.
      WHEN 'EBELP'.
        gs_fieldcat-scrtext_s = 'SA Kalem'.
        gs_fieldcat-scrtext_m = 'SA Kalem'.
        gs_fieldcat-scrtext_l = 'Satın Alma Kalem'.
        gs_fieldcat-colddictxt = 'M'.
      WHEN 'CARGO_KEY'.
        gs_fieldcat-tech = 'X'.
      WHEN 'ERR_CODE'.
        gs_fieldcat-tech = 'X'.
      WHEN 'IRSALIYE_NUMARA'.
        gs_fieldcat-no_out = 'X'.
      WHEN 'GONDERICI'.
        gs_fieldcat-no_out = 'X'.
      WHEN 'ALICI'.
        gs_fieldcat-no_out = 'X'.
      WHEN 'KARGO_TAKIP_NO'.
        gs_fieldcat-no_out = 'X'.
      WHEN 'DURUM_KODU'.
        gs_fieldcat-no_out = 'X'.
      WHEN 'DURUM'.
        gs_fieldcat-no_out = 'X'.
      WHEN 'TESLIM_ALAN'.
        gs_fieldcat-no_out = 'X'.
      WHEN 'TESLIM_TARIHI'.
        gs_fieldcat-no_out = 'X'.
      WHEN 'TESLIM_SAATI'.
        gs_fieldcat-no_out = 'X'.
    ENDCASE.
    MODIFY gt_fieldcat FROM gs_fieldcat.
  ENDLOOP.

ENDFORM.                    "fieldcatalog

*&---------------------------------------------------------------------*
*&      Form  show_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM show_data .
  CLEAR: gt_fieldcat, gt_fieldcat[].

  PERFORM fieldcatalog.
  PERFORM exclude_tb_functions CHANGING gt_exclude.

  IF gr_container IS INITIAL.

    CREATE OBJECT gr_container
      EXPORTING
        container_name              = gc_custom_control_name
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.

    CREATE OBJECT gr_alvgrid
      EXPORTING
        i_parent          = gr_container
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5.

    gs_layout-zebra = 'X'.
    gs_layout-cwidth_opt = 'X'.
    gs_layout-sel_mode = 'A'.
*    gs_layout-no_rowmark = 'X'.

    CALL METHOD gr_alvgrid->set_table_for_first_display
      EXPORTING
        it_toolbar_excluding          = gt_exclude
        i_structure_name              = 'ZSOG_MM_007_S_010'
        is_layout                     = gs_layout
*       is_variant                    = gs_variant
      CHANGING
        it_outtab                     = gt_alv
        it_fieldcatalog               = gt_fieldcat
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.


    CALL METHOD gr_alvgrid->set_toolbar_interactive.

    CALL METHOD gr_alvgrid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified.

    CALL METHOD gr_alvgrid->set_ready_for_input
      EXPORTING
        i_ready_for_input = 1.

  ELSE.
    CALL METHOD gr_alvgrid->refresh_table_display.
  ENDIF.

ENDFORM.                    " SHOW_DATA
*&---------------------------------------------------------------------*
*&      Form  EXCLUDE_TB_FUNCTIONS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_EXCLUDE  text
*----------------------------------------------------------------------*
FORM exclude_tb_functions  CHANGING et_exclude TYPE ui_functions.
  DATA: ls_exclude LIKE LINE OF et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_detail.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy_row.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_delete_row.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_append_row.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_insert_row.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_move_row.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_cut.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_paste.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_paste_new_row.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_undo.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_print.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_check.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_views.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_graph.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_maintain_variant.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_refresh.
  APPEND ls_exclude TO et_exclude.

ENDFORM.                    " EXCLUDE_TB_FUNCTIONS
*&---------------------------------------------------------------------*
*&      Form  HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_UCOMM  text
*----------------------------------------------------------------------*
FORM handle_user_command  USING    p_e_ucomm.

ENDFORM.                    " HANDLE_USER_COMMAND
