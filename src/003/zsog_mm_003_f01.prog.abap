*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_003_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SHOW_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_data .
  CALL SCREEN 0100.
ENDFORM.                    "show_data
*&---------------------------------------------------------------------*
*&      Form  SHOW_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_alv .
  IF go_custom_container IS INITIAL.
*    CREATE OBJECT go_custom_container
*      EXPORTING
*        container_name = go_container.
*
*    CREATE OBJECT go_grid
*      EXPORTING
*        i_parent = go_custom_container.
*-Layout
    CLEAR gs_layo100.
    gs_layo100-zebra      = 'X'.
    gs_layo100-cwidth_opt = 'X'.
    gs_layo100-sel_mode   = 'A'.
    gs_layo100-stylefname = 'FIELD_STYLE'.
    gs_layo100-info_fname = 'LINECOLOR'.

*** Alt
    gs_layo200-zebra      = 'X'.
    gs_layo200-cwidth_opt = 'X'.
    gs_layo200-sel_mode   = 'A'.
    gs_layo200-stylefname = 'FIELD_STYLE'.
    gs_layo200-info_fname = 'LINECOLOR'.

    gs_variant-report     = sy-repid .
    gs_variant2-report    = sy-repid .

*- Fieldcatalog
    PERFORM build_fcat .
    PERFORM build_fcat2 .

*- Exclude Buttons
    PERFORM exclude_button CHANGING gt_exclude .
    PERFORM exclude_button2 CHANGING gt_exclude2 .

**- Parçalı ALV için
    PERFORM set_container.
    PERFORM set_alv.

*-Alv Event
    DATA: lcl_alv_event TYPE REF TO lcl_event_receiver.
    CREATE OBJECT lcl_alv_event.

*    SET HANDLER lcl_alv_event->handle_data_changed  FOR go_grid.
    SET HANDLER lcl_alv_event->handle_toolbar       FOR go_grid.
    SET HANDLER lcl_alv_event->handle_user_command  FOR go_grid.
    SET HANDLER lcl_alv_event->hotspot_click        FOR go_grid.
*
*    CALL METHOD go_grid->register_edit_event
*      EXPORTING
*        i_event_id = cl_gui_alv_grid=>mc_evt_enter.
*
*    CALL METHOD go_grid->register_edit_event
*      EXPORTING
*        i_event_id = cl_gui_alv_grid=>mc_evt_modified.

    PERFORM refresh_table_display USING go_grid .

  ELSE .
    PERFORM check_changed_data    USING go_grid .
    PERFORM refresh_table_display USING go_grid .
  ENDIF .
ENDFORM.                    "show_alv
*&---------------------------------------------------------------------*
*&      Form  BUILD_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_fcat .
  DATA: lt_kkblo_fieldcat TYPE kkblo_t_fieldcat,
        lv_repid          TYPE sy-repid.
  FIELD-SYMBOLS: <fs_fcat> LIKE gs_fcat.

  lv_repid = sy-repid.

  CALL FUNCTION 'K_KKB_FIELDCAT_MERGE'
    EXPORTING
      i_callback_program     = lv_repid
      i_tabname              = 'GS_OUT'
      i_inclname             = lv_repid
    CHANGING
      ct_fieldcat            = lt_kkblo_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      OTHERS                 = 2.
  IF lt_kkblo_fieldcat IS INITIAL.
    MESSAGE ID sy-msgid TYPE 'A' NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CLEAR gt_fcat[].
  CALL FUNCTION 'LVC_TRANSFER_FROM_KKBLO'
    EXPORTING
      it_fieldcat_kkblo = lt_kkblo_fieldcat
    IMPORTING
      et_fieldcat_lvc   = gt_fcat[]
    EXCEPTIONS
      it_data_missing   = 1
      OTHERS            = 2.
  IF gt_fcat IS INITIAL.
    MESSAGE ID sy-msgid TYPE 'A' NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT gt_fcat INTO gs_fcat.
    gs_fcat-key = ' '.

    CASE gs_fcat-fieldname .
      WHEN 'MATNR'.
        gs_fcat-scrtext_s  = 'Malzeme'.
        gs_fcat-scrtext_m  = 'Malzeme'.
        gs_fcat-scrtext_l  = 'Malzeme'.
        gs_fcat-coltext    = 'Malzeme'.
      WHEN 'T_FIYAT'.
        gs_fcat-scrtext_s  = 'Top. Fiyat'.
        gs_fcat-scrtext_m  = 'Top. Fiyat'.
        gs_fcat-scrtext_l  = 'Top. Fiyat'.
        gs_fcat-coltext    = 'Top. Fiyat'.
*        gs_fcat-edit       = 'X'.
      WHEN 'EBELN'.
        gs_fcat-scrtext_s  = 'Teklif Talebi No'.
        gs_fcat-scrtext_m  = 'Teklif Talebi No'.
        gs_fcat-scrtext_l  = 'Teklif Talebi No'.
        gs_fcat-coltext    = 'Teklif Talebi No'.
        gs_fcat-hotspot    = 'X'.
      WHEN 'NAME1'.
        gs_fcat-scrtext_s  = 'Satıcı'.
        gs_fcat-scrtext_m  = 'Satıcı'.
        gs_fcat-scrtext_l  = 'Satıcı'.
        gs_fcat-coltext    = 'Satıcı'.
      WHEN 'STCD1'.
        gs_fcat-scrtext_s  = 'Vergi Dairesi'.
        gs_fcat-scrtext_m  = 'Vergi Dairesi'.
        gs_fcat-scrtext_l  = 'Vergi Dairesi'.
        gs_fcat-coltext    = 'Vergi Dairesi'.
      WHEN 'STCD2'.
        gs_fcat-scrtext_s  = 'Vergi No'.
        gs_fcat-scrtext_m  = 'Vergi No'.
        gs_fcat-scrtext_l  = 'Vergi No'.
        gs_fcat-coltext    = 'Vergi No'.
    ENDCASE.
    MODIFY gt_fcat FROM gs_fcat.
  ENDLOOP.

ENDFORM.                    "build_fcat
*&---------------------------------------------------------------------*
*&      Form  BUILD_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_fcat2 .
  DATA: lt_kkblo_fieldcat TYPE kkblo_t_fieldcat,
        lv_repid          TYPE sy-repid.
  FIELD-SYMBOLS: <fs_fcat> LIKE gs_fcat2.

  lv_repid = sy-repid.

  CALL FUNCTION 'K_KKB_FIELDCAT_MERGE'
    EXPORTING
      i_callback_program     = lv_repid
      i_tabname              = 'GS_KALEM'
      i_inclname             = lv_repid
    CHANGING
      ct_fieldcat            = lt_kkblo_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      OTHERS                 = 2.
  IF lt_kkblo_fieldcat IS INITIAL.
    MESSAGE ID sy-msgid TYPE 'A' NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CLEAR gt_fcat2[].
  CALL FUNCTION 'LVC_TRANSFER_FROM_KKBLO'
    EXPORTING
      it_fieldcat_kkblo = lt_kkblo_fieldcat
    IMPORTING
      et_fieldcat_lvc   = gt_fcat2[]
    EXCEPTIONS
      it_data_missing   = 1
      OTHERS            = 2.
  IF gt_fcat IS INITIAL.
    MESSAGE ID sy-msgid TYPE 'A' NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT gt_fcat2 INTO gs_fcat2.
    gs_fcat2-key = ' '.

    CASE gs_fcat2-fieldname .
      WHEN 'MATNR'.
        gs_fcat2-scrtext_s  = 'Malzeme'.
        gs_fcat2-scrtext_m  = 'Malzeme'.
        gs_fcat2-scrtext_l  = 'Malzeme'.
        gs_fcat2-coltext    = 'Malzeme'.
      WHEN 'T_FIYAT'.
        gs_fcat2-scrtext_s  = 'Top. Fiyat'.
        gs_fcat2-scrtext_m  = 'Top. Fiyat'.
        gs_fcat2-scrtext_l  = 'Top. Fiyat'.
        gs_fcat2-coltext    = 'Top. Fiyat'.
*        gs_fcat-edit       = 'X'.
      WHEN 'EBELN'.
        gs_fcat2-scrtext_s  = 'Teklif Talebi No'.
        gs_fcat2-scrtext_m  = 'Teklif Talebi No'.
        gs_fcat2-scrtext_l  = 'Teklif Talebi No'.
        gs_fcat2-coltext    = 'Teklif Talebi No'.
        gs_fcat2-hotspot    = 'X'.
      WHEN 'NAME1'.
        gs_fcat2-scrtext_s  = 'Satıcı'.
        gs_fcat2-scrtext_m  = 'Satıcı'.
        gs_fcat2-scrtext_l  = 'Satıcı'.
        gs_fcat2-coltext    = 'Satıcı'.
      WHEN 'TEKLIF_NO'.
        gs_fcat2-no_out     = 'X'.
    ENDCASE.
    MODIFY gt_fcat2 FROM gs_fcat2.
  ENDLOOP.

ENDFORM.                    "build_fcat
*&---------------------------------------------------------------------*
*&      Form  EXCLUDE_BUTTON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_EXCLUDE  text
*----------------------------------------------------------------------*
FORM exclude_button  CHANGING et_exclude TYPE ui_functions.
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
*    ls_exclude = cl_gui_alv_grid=>mc_fc_find.
*  APPEND ls_exclude TO et_exclude.
ENDFORM.                    "exclude_button
*&---------------------------------------------------------------------*
*&      Form  EXCLUDE_BUTTON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_EXCLUDE  text
*----------------------------------------------------------------------*
FORM exclude_button2  CHANGING et_exclude TYPE ui_functions.
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
*    ls_exclude = cl_gui_alv_grid=>mc_fc_find.
*  APPEND ls_exclude TO et_exclude.
ENDFORM.                    "exclude_button
*&---------------------------------------------------------------------*
*&      Form  CHECK_CHANGED_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GO_GRID  text
*----------------------------------------------------------------------*
FORM check_changed_data USING io_grid TYPE REF TO cl_gui_alv_grid .
  DATA: lv_valid TYPE c.

  CALL METHOD io_grid->check_changed_data
    IMPORTING
      e_valid = lv_valid.
ENDFORM.                    "check_changed_data
*&---------------------------------------------------------------------*
*&      Form  REFRESH_TABLE_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GO_GRID  text
*----------------------------------------------------------------------*
FORM refresh_table_display USING p_grid TYPE REF TO cl_gui_alv_grid.
  DATA : ls_stable TYPE lvc_s_stbl .

  ls_stable-row = 'X'.
  ls_stable-col = 'X'.
  CALL METHOD p_grid->refresh_table_display
    EXPORTING
      is_stable      = ls_stable
      i_soft_refresh = 'X'
    EXCEPTIONS
      finished       = 1
      OTHERS         = 2.
ENDFORM.                    " REFRESH_TABLE_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  PDF_INDIR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pdf_indir .
***** ----> Form Data

  DATA:  ls_header TYPE zmm_st_007,
         ls_footer TYPE zmm_st_009,
         ls_table  TYPE zmm_st_008,
         lt_table  TYPE TABLE OF zmm_st_008.

  FIELD-SYMBOLS: <fs_table> TYPE zmm_st_008.
  DATA: lv_ebeln  TYPE ekko-ebeln.
  DATA: lv_formname TYPE tdsfname.
  DATA: lv_func(30) TYPE c. "fonksiyon adı
  DATA: ls_control_param   TYPE ssfctrlop,
        ls_output_param    TYPE ssfcompop,
        job_output_info    TYPE ssfcrescl,
        job_output_options TYPE ssfcresop,
        lt_otf             TYPE itcoo OCCURS 0 WITH HEADER LINE,
        lv_tddest          TYPE rspopname,
        pdf_tab            LIKE tline OCCURS 0 WITH HEADER LINE,
        lv_bin_file        TYPE xstring,
        lv_bin_filesize    TYPE i,
        lt_binary_content  TYPE solix_tab.
***** <---- Form Data
  DATA: BEGIN OF ls_collect,
        ebeln     LIKE ekko-ebeln,
        matnr     LIKE eban-matnr,
        maktx     LIKE makt-maktx,
        menge     LIKE eket-menge,
        meins     LIKE ekpo-meins,
        name1     LIKE lfa1-name1,
        slfdt     LIKE eket-slfdt,
        netpr_1   LIKE ekpo-netpr,
        waers_1   LIKE ekko-waers,
        netpr_2   LIKE ekpo-netpr,
        waers_2   LIKE ekko-waers,
        netpr_3   LIKE ekpo-netpr,
        waers_3   LIKE ekko-waers,
        teklif_no TYPE c,
       END OF ls_collect,
      lt_collect LIKE TABLE OF ls_collect.

  DATA: BEGIN OF ls_matnr,
         matnr TYPE mara-matnr,
        END OF ls_matnr,
        lt_matnr LIKE TABLE OF ls_matnr.

  DATA: lv_netpr_1_top TYPE ekpo-netpr.
  DATA: lv_netpr_2_top TYPE ekpo-netpr.
  DATA: lv_netpr_3_top TYPE ekpo-netpr.

  DATA:
    lt_rows   TYPE lvc_t_row,
    ls_row    TYPE lvc_s_row,
    lv_error  TYPE c,
    lv_lines  TYPE i,
    lv_tabix  TYPE i,
    lv_matnr  TYPE mara-matnr.

  DATA: lt_kalem LIKE gt_kalem,
        ls_kalem LIKE gs_kalem.

  DATA: lt_out LIKE gt_out,
        ls_out LIKE gs_out.

  DATA:   lv_file_name TYPE string,
          lv_file_path TYPE string,
          lv_full_path TYPE string,
          lv_user_act  TYPE i.

  CLEAR: lt_rows[], ls_kalem, lt_kalem, lv_tabix, lv_matnr, ls_matnr, lt_matnr.

  CLEAR: lv_formname, lv_func, ls_control_param, ls_output_param,
         job_output_info, job_output_options, lt_otf, lv_tddest,
         pdf_tab, lv_bin_file, lv_bin_filesize, lt_binary_content, lv_ebeln,
         lv_user_act.

  CALL METHOD go_grid->get_selected_rows
    IMPORTING
      et_index_rows = lt_rows[].

  " satır seçim kontrol
  DESCRIBE TABLE lt_rows LINES lv_lines.
  IF lt_rows IS INITIAL.
    lv_error = 'X'.
    MESSAGE s110(zmm) DISPLAY LIKE 'E'.
  ELSE.
    IF lv_lines < 2 OR lv_lines > 3.
      lv_error = 'X'.
      MESSAGE s111(zmm) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.

  CHECK lv_error IS INITIAL.

  " seçilen satırları lt_out'a topla
  LOOP AT lt_rows INTO ls_row.
    READ TABLE gt_out INTO gs_out INDEX ls_row-index.
    lv_tabix = ls_row-index.
    CLEAR gt_kalem.
    PERFORM get_item USING lv_tabix.
    APPEND LINES OF gt_kalem TO lt_kalem.
    APPEND gs_out TO lt_out.
  ENDLOOP.

  CLEAR lv_tabix.

  " üst başlık
  SELECT SINGLE
    ad~mc_name1
    ad~name_co
    ad~str_suppl1
    ad~mc_city1
    ad~tel_number
    ad~fax_number
  FROM ekko AS ek
  INNER JOIN ekpo AS ep ON ep~ebeln = ek~ebeln
  INNER JOIN eket AS et ON et~ebeln = ep~ebeln
                       AND et~ebelp = ep~ebelp
  INNER JOIN lfa1 AS l1 ON l1~lifnr = ek~lifnr
  INNER JOIN t001 AS t1 ON t1~bukrs = ek~bukrs
  INNER JOIN adrc AS ad ON ad~addrnumber = t1~adrnr
  INTO ls_header
  WHERE ek~ebeln = gs_out-ebeln.
  IF sy-subrc <> 0 .
    lv_error = 'X'.
  ENDIF.

  CHECK lv_error IS INITIAL.

  " karşılaştırma başlıkları
  IF lv_lines = 2.
***************** Başlık ***************
    READ TABLE lt_out INTO ls_out INDEX 1.
    ls_header-ebeln_1 = ls_out-ebeln.
    ls_header-name1_1 = ls_out-name1.
    ls_header-slfdt_1 = ls_out-slfdt.
    READ TABLE lt_out INTO ls_out INDEX 2.
    ls_header-ebeln_2 = ls_out-ebeln.
    ls_header-name1_2 = ls_out-name1.
    ls_header-slfdt_2 = ls_out-slfdt.
****************  Başlık ****************
  ELSEIF lv_lines = 3.
**************** Başlık ****************
    READ TABLE lt_out INTO ls_out INDEX 1.
    ls_header-ebeln_1 = ls_out-ebeln.
    ls_header-name1_1 = ls_out-name1.
    ls_header-slfdt_1 = ls_out-slfdt.
    READ TABLE lt_out INTO ls_out INDEX 2.
    ls_header-ebeln_2 = ls_out-ebeln.
    ls_header-name1_2 = ls_out-name1.
    ls_header-slfdt_2 = ls_out-slfdt.
    READ TABLE lt_out INTO ls_out INDEX 3.
    ls_header-ebeln_3 = ls_out-ebeln.
    ls_header-name1_3 = ls_out-name1.
    ls_header-slfdt_3 = ls_out-slfdt.
**************** Başlık ****************
  ENDIF.

  CLEAR lv_tabix.
  LOOP AT lt_out INTO ls_out.
    lv_tabix = sy-tabix.
    LOOP AT lt_kalem INTO ls_kalem WHERE ebeln = ls_out-ebeln.
      CLEAR: ls_collect, ls_matnr.
      MOVE-CORRESPONDING ls_kalem TO ls_collect.

      IF lv_tabix = 1.
        ls_collect-netpr_1 = ls_kalem-menge * ls_kalem-netpr.
        ls_collect-waers_1 = ls_kalem-waers.
      ELSEIF lv_tabix = 2.
        ls_collect-netpr_2 = ls_kalem-menge * ls_kalem-netpr.
        ls_collect-waers_2 = ls_kalem-waers.
      ELSEIF lv_tabix = 3.
        ls_collect-netpr_3 = ls_kalem-menge * ls_kalem-netpr.
        ls_collect-waers_3 = ls_kalem-waers.
      ENDIF.
      COLLECT ls_collect INTO lt_collect.
      ls_matnr = ls_kalem-matnr.
      COLLECT ls_matnr INTO lt_matnr.
    ENDLOOP.
  ENDLOOP.

  SORT lt_collect BY matnr.
  SORT lt_matnr   BY matnr.

  LOOP AT lt_matnr INTO ls_matnr.
    CLEAR ls_table.
    LOOP AT lt_collect INTO ls_collect WHERE matnr = ls_matnr-matnr.
      ls_table-matnr = ls_collect-matnr.
      ls_table-maktx = ls_collect-maktx.
      ls_table-meins = ls_collect-meins.
      ls_table-menge = ls_collect-menge.
      IF ls_collect-teklif_no = 1.
        ls_table-netpr_1 = ls_collect-netpr_1.
        ls_table-waers_1 = ls_collect-waers_1.
      ELSEIF ls_collect-teklif_no = 2.
        ls_table-netpr_2 = ls_collect-netpr_2.
        ls_table-waers_2 = ls_collect-waers_2.
      ELSEIF ls_collect-teklif_no = 3.
        ls_table-netpr_3 = ls_collect-netpr_3.
        ls_table-waers_3 = ls_collect-waers_3.
      ENDIF.
    ENDLOOP.
    APPEND ls_table TO lt_table.
  ENDLOOP.

  CLEAR: lv_netpr_1_top, lv_netpr_2_top ,lv_netpr_3_top.
  LOOP AT lt_table INTO ls_table.
    lv_netpr_1_top = ls_table-netpr_1 + lv_netpr_1_top.
    lv_netpr_2_top = ls_table-netpr_2 + lv_netpr_2_top.
    lv_netpr_3_top = ls_table-netpr_3 + lv_netpr_3_top.
    ls_footer-waers_1 = ls_table-waers_1.
    ls_footer-waers_2 = ls_table-waers_2.
    ls_footer-waers_3 = ls_table-waers_3.
  ENDLOOP.
  ls_footer-netpr_1 = lv_netpr_1_top.
  ls_footer-netpr_2 = lv_netpr_2_top.
  ls_footer-netpr_3 = lv_netpr_3_top.

  CHECK lv_error IS  INITIAL.
  lv_formname = 'ZMM_SF_TK_FORM'.
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = lv_formname
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = lv_func
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    lv_error = 'X'.
*    ent_retco = 1.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  ls_control_param-preview   = 'X'.
  ls_control_param-no_dialog = 'X'.
  ls_control_param-getotf    = 'X'.
  ls_control_param-langu     = sy-langu.
  ls_output_param-tdimmed    = 'X'.
  ls_output_param-tddest     = 'LP01'.

  CALL FUNCTION lv_func
    EXPORTING
*     ARCHIVE_INDEX        =
*     ARCHIVE_INDEX_TAB    =
*     ARCHIVE_PARAMETERS   =
      control_parameters   = ls_control_param
*     MAIL_APPL_OBJ        =
*     MAIL_RECIPIENT       =
*     MAIL_SENDER          =
      output_options       = ls_output_param
      user_settings        = abap_false
      gs_header            = ls_header
      gt_table             = lt_table
      gs_footer            = ls_footer
    IMPORTING
*     DOCUMENT_OUTPUT_INFO =
      job_output_info      = job_output_info
      job_output_options   = job_output_options
    EXCEPTIONS
      formatting_error     = 1
      internal_error       = 2
      send_error           = 3
      user_canceled        = 4
      OTHERS               = 5.
  IF sy-subrc <> 0.
*    ent_retco = 2.
    lv_error = 'X'.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CHECK job_output_info-otfdata[] IS NOT INITIAL.
  lt_otf[] = job_output_info-otfdata[].

  CALL FUNCTION 'CONVERT_OTF'
    EXPORTING
      format                = 'PDF'
    IMPORTING
*     bin_file              = lv_bin_file
      bin_filesize          = lv_bin_filesize
    TABLES
      otf                   = lt_otf[]
      lines                 = pdf_tab[]
    EXCEPTIONS
      err_max_linewidth     = 1
      err_format            = 2
      err_conv_not_possible = 3
      err_bad_otf           = 4
      OTHERS                = 5.

*  lt_binary_content[] = cl_document_bcs=>xstring_to_solix( lv_bin_file ).
*
  CHECK lv_error IS INITIAL.

  CLEAR: lv_file_name, lv_file_path, lv_full_path.

  CONCATENATE 'Teklif_Karsilastirmasi' sy-datum INTO lv_file_name.

  CALL METHOD cl_gui_frontend_services=>file_save_dialog
    EXPORTING
      default_extension    = 'PDF'
      default_file_name    = lv_file_name
      file_filter          = 'PDF'
      prompt_on_overwrite  = 'X'
    CHANGING
      filename             = lv_file_name
      path                 = lv_file_path
      fullpath             = lv_full_path
      user_action          = lv_user_act
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  IF lv_user_act = 0.

    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        bin_filesize            = lv_bin_filesize
        filename                = lv_full_path
        filetype                = 'BIN'
      TABLES
        data_tab                = pdf_tab[]
      EXCEPTIONS
        file_write_error        = 1
        no_batch                = 2
        gui_refuse_filetransfer = 3
        invalid_type            = 4
        no_authority            = 5
        unknown_error           = 6
        header_not_allowed      = 7
        separator_not_allowed   = 8
        filesize_not_allowed    = 9
        header_too_long         = 10
        dp_error_create         = 11
        dp_error_send           = 12
        dp_error_write          = 13
        unknown_dp_error        = 14
        access_denied           = 15
        dp_out_of_memory        = 16
        disk_full               = 17
        dp_timeout              = 18
        file_not_found          = 19
        dataprovider_exception  = 20
        control_flush_error     = 21.
  ELSE.
    MESSAGE s112(zmm) DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.                    " PDF_INDIR
*&---------------------------------------------------------------------*
*&      Form  SET_CONTAINER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_container .
  IF go_docking IS INITIAL.
*    CREATE docking container
    CREATE OBJECT go_docking
      EXPORTING
        parent = cl_gui_container=>screen0 " main screen -> level 0 !!!
        ratio  = 95
*       side   = cl_gui_docking_container=>dock_at_left
        side   = cl_gui_docking_container=>property_docking
      EXCEPTIONS
        others = 6.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

* Create splitter container
    CREATE OBJECT go_splitter
      EXPORTING
        parent                  = go_docking
        rows                    = 2
        columns                 = 1
*       NO_AUTODEF_PROGID_DYNNR =
*       NAME                    =
      EXCEPTIONS
        cntl_error              = 1
        cntl_system_error       = 2
        OTHERS                  = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

* Get cell container
    CALL METHOD go_splitter->get_container
      EXPORTING
        row       = 1
        column    = 1
      RECEIVING
        container = go_cell_top.
    CALL METHOD go_splitter->get_container
      EXPORTING
        row       = 2
        column    = 1
      RECEIVING
        container = go_cell_bottom.

* Create ALV grids
    CREATE OBJECT go_grid
      EXPORTING
        i_parent = go_cell_top
      EXCEPTIONS
        others   = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT go_grid2
      EXPORTING
        i_parent = go_cell_bottom
      EXCEPTIONS
        others   = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.

ENDFORM.                    " SET_CONTAINER
*&---------------------------------------------------------------------*
*&      Form  SET_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_alv .
  CALL METHOD go_grid->set_table_for_first_display
    EXPORTING
*     i_structure_name     = 'ZEKTLG_ST029'
      is_layout            = gs_layo100
      it_toolbar_excluding = gt_exclude
      is_variant           = gs_variant
      i_save               = 'A'
    CHANGING
      it_outtab            = gt_out[]
      it_sort              = gt_sort[]
      it_fieldcatalog      = gt_fcat[].
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

** KALEM
  CALL METHOD go_grid2->set_table_for_first_display
    EXPORTING
*     i_structure_name     = 'ZEKTLG_ST030'
      is_layout            = gs_layo200
      it_toolbar_excluding = gt_exclude2
      is_variant           = gs_variant2
      i_save               = 'A'
    CHANGING
      it_outtab            = gt_kalem[]
      it_sort              = gt_sort2[]
      it_fieldcatalog      = gt_fcat2[].
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


* Link the docking container to the target dynpro
  gv_repid = syst-repid.
  CALL METHOD go_docking->link
    EXPORTING
      repid     = gv_repid
      dynnr     = '0100'
*     CONTAINER = 'CUSTOM_CONTROL'
    EXCEPTIONS
      OTHERS    = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.                    " SET_ALV
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
  DATA: lv_error TYPE c.
  FIELD-SYMBOLS: <fs_out> LIKE gs_out.
  CLEAR: lv_error, gt_out.

  SELECT
   ek~ebeln
   l1~name1
   l1~stcd1
   l1~stcd2
   et~slfdt
  FROM ekko AS ek
  INNER JOIN ekpo AS ep ON ep~ebeln = ek~ebeln
  INNER JOIN eket AS et ON et~ebeln = ep~ebeln
                       AND et~ebelp = ep~ebelp
  INNER JOIN eban AS eb ON eb~banfn = et~banfn
                       AND eb~bnfpo = et~bnfpo
  INNER JOIN lfa1 AS l1 ON l1~lifnr = ek~lifnr
  LEFT OUTER JOIN makt AS mk ON mk~matnr = eb~matnr
                            AND mk~spras = sy-langu
  INTO TABLE gt_out
   WHERE ek~ebeln IN s_ebeln
     AND ek~bukrs  = p_bukrs
     AND ek~submi IN s_submi
     AND ep~netpr <> ''.
  IF sy-subrc <> 0.
    lv_error = 'X'.
    MESSAGE i109(zmm) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  CHECK lv_error IS INITIAL.

  SORT gt_out BY ebeln.
  DELETE ADJACENT DUPLICATES FROM gt_out COMPARING ebeln.

ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      Form  GET_ITEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_item USING ev_tabix TYPE i.
*  CONSTANTS:
  DATA: lv_error TYPE c.
  FIELD-SYMBOLS: <fs_kalem> LIKE gs_kalem.
  CLEAR: lv_error, gt_kalem.

  CLEAR gt_kalem.

  SELECT
   ek~ebeln
   eb~matnr
   mk~maktx
   et~menge
   ep~meins
   l1~name1
   ep~netpr
   ek~waers
   et~slfdt
  FROM ekko AS ek
  INNER JOIN ekpo AS ep ON ep~ebeln = ek~ebeln
  INNER JOIN eket AS et ON et~ebeln = ep~ebeln
                       AND et~ebelp = ep~ebelp
  INNER JOIN eban AS eb ON eb~banfn = et~banfn
                       AND eb~bnfpo = et~bnfpo
  INNER JOIN lfa1 AS l1 ON l1~lifnr = ek~lifnr
  LEFT OUTER JOIN makt AS mk ON mk~matnr = eb~matnr
                            AND mk~spras = sy-langu
  INTO TABLE gt_kalem
   WHERE ek~ebeln = gs_out-ebeln.
  IF sy-subrc = 0.
    LOOP AT gt_kalem ASSIGNING <fs_kalem>.
      <fs_kalem>-teklif_no = ev_tabix.
      MODIFY gt_kalem FROM <fs_kalem> TRANSPORTING teklif_no.
    ENDLOOP.
  ENDIF.

ENDFORM.                    " GET_ITEM
*&---------------------------------------------------------------------*
*&      Form  GET_ITEM_HOTSPT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_item_hotspt .
  DATA: lv_error TYPE c.
  FIELD-SYMBOLS: <fs_kalem> LIKE gs_kalem.
  CLEAR: lv_error, gt_kalem.

  CLEAR gt_kalem.
  SELECT
   ek~ebeln
   eb~matnr
   mk~maktx
   et~menge
   ep~meins
   l1~name1
   ep~netpr
   ek~waers
   et~slfdt
  FROM ekko AS ek
  INNER JOIN ekpo AS ep ON ep~ebeln = ek~ebeln
  INNER JOIN eket AS et ON et~ebeln = ep~ebeln
                       AND et~ebelp = ep~ebelp
  INNER JOIN eban AS eb ON eb~banfn = et~banfn
                       AND eb~bnfpo = et~bnfpo
  INNER JOIN lfa1 AS l1 ON l1~lifnr = ek~lifnr
  LEFT OUTER JOIN makt AS mk ON mk~matnr = eb~matnr
                            AND mk~spras = sy-langu
  INTO TABLE gt_kalem
   WHERE ek~ebeln = gs_out-ebeln.
  IF sy-subrc <> 0.
    lv_error = 'X'.
  ENDIF.

  CHECK lv_error IS INITIAL.
*
  LOOP AT gt_kalem ASSIGNING <fs_kalem>.
    <fs_kalem>-t_fiyat = <fs_kalem>-menge * <fs_kalem>-netpr.
    <fs_kalem>-t_waers = <fs_kalem>-waers.
    MODIFY gt_kalem FROM <fs_kalem> TRANSPORTING t_fiyat t_waers.
  ENDLOOP.
ENDFORM.                    " GET_ITEM_HOTSPT
