*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_018_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  get_data
*&---------------------------------------------------------------------*

FORM get_data .
  DATA: lv_frgzu TYPE i.
  TYPES: BEGIN OF ty_alv,
         frgco     TYPE zsog_mm_018_t_01-frgco,
         uname     TYPE zsog_mm_018_t_01-uname,
         mail_adres TYPE zsog_mm_018_t_01-mail_adres,
       END OF ty_alv.

  DATA: lt_alv TYPE TABLE OF ty_alv,
        ls_alv TYPE ty_alv.

  TYPES: BEGIN OF ty_alv1,
        smtp_addr  TYPE adr6-smtp_addr,
        persnumber TYPE usr21-persnumber,
        addrnumber TYPE usr21-addrnumber,
     END OF ty_alv1.

  DATA: lt_alv1 TYPE TABLE OF ty_alv1,
        ls_alv1 TYPE ty_alv1.

  DATA: lt_lines TYPE STANDARD TABLE OF tline,
        ls_lines TYPE tline,
        lv_name  TYPE thead-tdname.


  IF p_onay IS INITIAL.
    SELECT
           eb~sakto"
           s~txt50"
           a~banfn
           a~bnfpo
           a~preis"
           a~waers"
           a~menge
           a~lfdat"
           a~afnam
           a~badat
           a~frgst
           a~frgzu
           e~frgc1
           e~frgc2
           e~frgc3
           e~frgc4
           e~frgc5
           e~frgc6
           e~frgc7
           e~frgc8
      FROM eban AS a
      INNER JOIN ebkn AS eb ON eb~banfn = a~banfn
                            AND eb~bnfpo = a~bnfpo
      INNER JOIN skat AS s ON s~saknr = eb~sakto
                            AND s~spras = sy-langu
                            AND s~ktopl = 'SGHP'
      LEFT OUTER JOIN t16fs AS e ON e~frggr EQ a~frggr
                                AND e~frgsx EQ a~frgst
      INTO CORRESPONDING FIELDS OF TABLE gt_alv
      WHERE a~banfn IN s_banfn
        AND a~bnfpo IN s_bnfpo
        AND a~badat IN s_badat
        AND a~frgkz EQ 'X'
        AND a~loekz EQ ''
        AND a~werks EQ '2425'
        AND a~bsart NE 'ZSG1'.

    LOOP AT gt_alv INTO gs_alv.
      lv_frgzu = strlen( gs_alv-frgzu ).

      IF gs_alv-frgzu IS INITIAL.
        gs_alv-send_mail_user = gs_alv-frgc1.
      ELSEIF lv_frgzu EQ 1.
        gs_alv-send_mail_user = gs_alv-frgc2.
      ELSEIF lv_frgzu EQ 2.
        gs_alv-send_mail_user = gs_alv-frgc3.
      ELSEIF lv_frgzu EQ 3.
        gs_alv-send_mail_user = gs_alv-frgc4.
      ELSEIF lv_frgzu EQ 4.
        gs_alv-send_mail_user = gs_alv-frgc5.
      ELSEIF lv_frgzu EQ 5.
        gs_alv-send_mail_user = gs_alv-frgc6.
      ELSEIF lv_frgzu EQ 6.
        gs_alv-send_mail_user = gs_alv-frgc7.
      ELSEIF lv_frgzu EQ 7.
        gs_alv-send_mail_user = gs_alv-frgc8.
      ENDIF.
      MODIFY gt_alv FROM gs_alv TRANSPORTING send_mail_user.
      CLEAR: gs_alv.
    ENDLOOP.

    IF gt_alv IS NOT INITIAL.
      SELECT frgco
             uname
             mail_adres
        FROM zsog_mm_018_t_01
        INTO TABLE lt_alv
        FOR ALL ENTRIES IN gt_alv
        WHERE frgco = gt_alv-send_mail_user.
    ENDIF.

    LOOP AT gt_alv INTO gs_alv.
      READ TABLE lt_alv INTO ls_alv WITH KEY frgco = gs_alv-send_mail_user.
      IF sy-subrc = 0.
        gs_alv-frgct     = ls_alv-uname.
        gs_alv-smtp_addr = ls_alv-mail_adres.
      ENDIF.


      lv_name = gs_alv-banfn .
      CONDENSE lv_name.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'B01'
          language                = sy-langu
          name                    = lv_name
          object                  = 'EBANH'
        TABLES
          lines                   = lt_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc =  0.
        LOOP AT lt_lines INTO ls_lines.
          IF sy-tabix = 1.
            gs_alv-sat_aciklama = ls_lines-tdline.
          ELSE.
            gs_alv-sat_aciklama = gs_alv-sat_aciklama && | | && ls_lines-tdline.
          ENDIF.
        ENDLOOP.

      ENDIF.
*   added by prodea ilknurnacar-15052020
      IF gs_alv-sat_aciklama IS INITIAL.
        CLEAR :lt_lines.
        CONCATENATE gs_alv-banfn gs_alv-bnfpo INTO lv_name.
        CONDENSE lv_name.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'B01'
            language                = sy-langu
            name                    = lv_name
            object                  = 'EBAN'
          TABLES
            lines                   = lt_lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        IF sy-subrc =  0.
          LOOP AT lt_lines INTO ls_lines.
            IF sy-tabix = 1.
              gs_alv-sat_aciklama = ls_lines-tdline.
            ELSE.
              gs_alv-sat_aciklama = gs_alv-sat_aciklama && | | && ls_lines-tdline.
            ENDIF.
            CLEAR ls_lines.
          ENDLOOP.

        ENDIF.
      ENDIF.

      MODIFY gt_alv FROM gs_alv TRANSPORTING frgct smtp_addr sat_aciklama.
    ENDLOOP.

  ELSE.
    SELECT eb~sakto"
           s~txt50"
           a~banfn
           a~bnfpo
           a~preis"
           a~waers"
*           a~matnr
           a~menge
           a~lfdat"
           a~afnam
*           a~ernam
           a~badat
           a~frgst
           a~frgzu
           b~persnumber AS tanım
           b~addrnumber AS frgct
     FROM eban AS a
     INNER JOIN ebkn AS eb ON eb~banfn = a~banfn
                            AND eb~bnfpo = a~bnfpo
     INNER JOIN skat AS s ON s~saknr = eb~sakto
                            AND s~spras = sy-langu
                            AND s~ktopl = 'SGHP'
     LEFT OUTER JOIN usr21 AS b ON a~ernam EQ b~bname
     INTO CORRESPONDING FIELDS OF TABLE gt_alv
     WHERE a~banfn IN s_banfn
       AND a~bnfpo IN s_bnfpo
       AND a~badat IN s_badat
       AND a~frgkz EQ '2'
       AND a~loekz EQ ''
       AND a~werks EQ '2425'
       AND a~bsart NE 'ZSG1'
       AND mail_gonderildi NE 'X'.

    IF gt_alv IS NOT INITIAL.
      SELECT a~smtp_addr
             b~persnumber
             b~addrnumber
        FROM usr21 AS b
        INNER JOIN adr6 AS a ON a~persnumber = b~persnumber
                            AND a~addrnumber = b~addrnumber
        INTO TABLE lt_alv1.
    ENDIF.
    IF lt_alv1 IS NOT INITIAL.
      LOOP AT gt_alv INTO gs_alv.
        READ TABLE lt_alv1 INTO ls_alv1 WITH KEY persnumber = gs_alv-tanım
                                                 addrnumber = gs_alv-frgct.
        IF sy-subrc = 0.
          gs_alv-smtp_addr = ls_alv1-smtp_addr.
        ENDIF.
        MODIFY gt_alv FROM gs_alv TRANSPORTING smtp_addr.
      ENDLOOP.
    ENDIF.
  ENDIF.

ENDFORM.                    " get_data
*&---------------------------------------------------------------------*
*&      Form  display_alv
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_alv .

*---Creating custom container instance
  IF gr_alvgrid IS INITIAL.
    CREATE OBJECT gr_custom_container
      EXPORTING
*       parent                      =
        container_name              = gr_custom_control_name
*       style                       =
*       lifetime                    = lifetime_default
*       repid                       =
*       dynnr                       =
*       no_autodef_progid_dynnr     =
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

*---Creating ALV Grid instance
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

      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1
      sy-msgv2 sy-msgv3 sy-msgv4.

    ENDIF.

*---Giriş hazırlığı editlemek için!!
    CALL METHOD gr_alvgrid->set_ready_for_input
      EXPORTING
        i_ready_for_input = 1.

*----Preparing field catalog.
    PERFORM prepare_field_catalog.
*--Preparing layout structure
    PERFORM prepare_layout.
    PERFORM exclude_toolbar.
*---Creating an instance for the event handler
    CREATE OBJECT gr_event_handler .

*---Registering handler methods to handle ALV Grid event
    SET HANDLER gr_event_handler->handle_toolbar FOR gr_alvgrid .
    SET HANDLER gr_event_handler->handle_user_command FOR gr_alvgrid.
    SET HANDLER gr_event_handler->handle_hotspot_click FOR gr_alvgrid.
*    set handler gr_event_handler->handle_double_click for gr_alvgrid .
*    set handler gr_event_handler->handle_data_changed for gr_alvgrid.

    CALL METHOD gr_alvgrid->set_table_for_first_display
      EXPORTING
        i_buffer_active               = 'X'
*       I_CONSISTENCY_CHECK           =
        i_structure_name              = 'ZSOG_MM_018_S'
*       IS_VARIANT                    =
*       I_SAVE                        =
*       I_DEFAULT                     = 'X'
        is_layout                     = gs_layout
                                                                                                                                                                                                                       "      IS_PRINT                      =
*       IT_SPECIAL_GROUPS             =
        it_toolbar_excluding          = gt_exclude[]
*       IT_HYPERLINK                  =
      CHANGING
        it_outtab                     = gt_alv[]
        it_fieldcatalog               = gt_fieldcat
        it_sort                       = gt_sort[]
        it_filter                     = gt_filt[]
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1
      sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ELSEIF gr_alvgrid IS NOT INITIAL.
    CALL METHOD gr_alvgrid->refresh_table_display.
  ENDIF.

ENDFORM.                    " display_alv
*&---------------------------------------------------------------------*
*&      Form  prepare_field_catalog
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM prepare_field_catalog .
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_buffer_active        = 'X'
      i_structure_name       = 'ZSOG_MM_018_S'
*     I_CLIENT_NEVER_DISPLAY = 'X'
      i_bypassing_buffer     = 'X'
      i_internal_tabname     = 'GT_ALV'
    CHANGING
      ct_fieldcat            = gt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  LOOP AT gt_fieldcat INTO gs_fieldcat.
    CASE gs_fieldcat-fieldname.
      WHEN 'ISLENDI'.
        gs_fieldcat-no_out = 'X'.
      WHEN 'FRGC1'.
        gs_fieldcat-no_out = 'X'.
      WHEN 'FRGC2'.
        gs_fieldcat-no_out = 'X'.
      WHEN 'FRGC3'.
        gs_fieldcat-no_out = 'X'.
      WHEN 'FRGC4'.
        gs_fieldcat-no_out = 'X'.
      WHEN 'FRGC5'.
        gs_fieldcat-no_out = 'X'.
      WHEN 'FRGC6'.
        gs_fieldcat-no_out = 'X'.
      WHEN 'FRGC7'.
        gs_fieldcat-no_out = 'X'.
      WHEN 'FRGC8'.
        gs_fieldcat-no_out = 'X'.
    ENDCASE.
    IF p_onay IS INITIAL.
      CASE gs_fieldcat-fieldname.
        WHEN 'TANIM'.
          gs_fieldcat-no_out = 'X'.
      ENDCASE.
    ENDIF.
    MODIFY gt_fieldcat FROM gs_fieldcat.
  ENDLOOP.

ENDFORM.                    " prepare_field_catalog
*&---------------------------------------------------------------------*
*&      Form  prepare_layout
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM prepare_layout .
  gs_layout-zebra = 'X'.
  gs_layout-cwidth_opt = 'X'.
  gs_layout-info_fname =  'ROW_COLOR'.
  gs_layout-sel_mode = 'A'.

ENDFORM.                    " prepare_layout
*&---------------------------------------------------------------------*
*&      Form  handle_hotspot_click
*&---------------------------------------------------------------------*

FORM handle_hotspot_click   USING p_row_id TYPE lvc_s_row
                                  p_column_id TYPE lvc_s_col
                                  p_s_row_no TYPE lvc_s_roid.

ENDFORM.                    " handle_hotspot_click
*&---------------------------------------------------------------------*
*&      Form  handle_toolbar
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_OBJECT  text
*----------------------------------------------------------------------*
FORM handle_toolbar  USING  p_object TYPE REF TO cl_alv_event_toolbar_set.
  DATA: ls_toolbar TYPE stb_button.

  MOVE 'SEND_MAIL' TO ls_toolbar-function.                        "#ECnotext
  MOVE icon_mail TO ls_toolbar-icon.
  MOVE 'Mail Gönder'(001) TO ls_toolbar-quickinfo.
  MOVE 'Mail Gönder'(001) TO ls_toolbar-text.
  MOVE ' ' TO ls_toolbar-disabled.                          "#ECnotext
  APPEND ls_toolbar TO p_object->mt_toolbar.
  CLEAR ls_toolbar.

ENDFORM.                    " handle_toolbar
*&---------------------------------------------------------------------*
*&      Form  EXCLUDE_TOOLBAR
*&---------------------------------------------------------------------*

FORM exclude_toolbar .

  APPEND cl_gui_alv_grid=>mc_fc_back_classic TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_call_abc TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_call_chain TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_call_crbatch TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_call_crweb TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_call_lineitems TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_call_master_data TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_call_more TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_call_report TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_call_xint TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_call_xxl TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_check TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_col_invisible TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_col_optimize TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_count TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_current_variant TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_data_save TO gt_exclude.
* APPEND cl_gui_alv_grid=>mc_fc_delete_filter TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_deselect_all TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_detail TO gt_exclude.
* APPEND cl_gui_alv_grid=>mc_fc_excl_all TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_expcrdata TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_expcrdesig TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_expcrtempl TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_expmdb TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_extend TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_f4 TO gt_exclude.
* APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_exclude.
* APPEND cl_gui_alv_grid=>mc_fc_find TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_fix_columns TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_graph TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_help TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_html TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_info TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_load_variant TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_cut TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_move_row TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_paste TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_paste_new_row TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_undo TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_maintain_variant TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_maximum TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_minimum TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_pc_file TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_print TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_print_back TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_print_prev TO gt_exclude."List Ou
  APPEND cl_gui_alv_grid=>mc_fc_refresh TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_reprep TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_save_variant TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_select_all TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_send TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_separator TO gt_exclude.
* APPEND cl_gui_alv_grid=>mc_fc_sort TO gt_exclude.
* APPEND cl_gui_alv_grid=>mc_fc_sort_asc TO gt_exclude.
* APPEND cl_gui_alv_grid=>mc_fc_sort_dsc TO gt_exclude.
*  APPEND cl_gui_alv_grid=>mc_fc_subtot TO gt_exclude.
*  APPEND cl_gui_alv_grid=>mc_fc_sum TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_to_office TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_to_rep_tree TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_unfix_columns TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_url_copy_to_clipboard TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_variant_admin TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_views TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_view_crystal TO gt_exclude.
* APPEND cl_gui_alv_grid=>mc_fc_view_excel TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_view_grid TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_view_lotus TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_word_processor TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_lystyle_drag_drop_rows TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_lystyle_no_delete_rows TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_lystyle_no_insert_rows TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_ly_drag_drop_rows TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_ly_no_delete_rows TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_ly_no_insert_rows TO gt_exclude.
* APPEND cl_gui_alv_grid=>mc_mb_export TO gt_exclude.
* APPEND cl_gui_alv_grid=>mc_mb_filter TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_mb_paste TO gt_exclude.
*  APPEND cl_gui_alv_grid=>mc_mb_subtot TO gt_exclude.
*  APPEND cl_gui_alv_grid=>mc_mb_sum TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_mb_variant TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_mb_view TO gt_exclude.
* APPEND cl_gui_alv_grid=>mc_fg_sort TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_fg_edit TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_style4_link TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_style4_link_no TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_style_button TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_style_disabled TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_style_enabled TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_style_f4 TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_style_f4_no TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_style_hotspot TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_style_hotspot_no TO gt_exclude.
  APPEND cl_gui_alv_grid=>mc_style_no_delete_row TO gt_exclude.
  APPEND cl_gui_alv_grid=>m_buffer_inactive TO gt_exclude.
  APPEND cl_gui_alv_grid=>m_crystal_active TO gt_exclude.
* APPEND cl_gui_alv_grid=>M_DISPLAY_PROTOCOL to gt_exclude.
  APPEND cl_gui_alv_grid=>m_third_party TO gt_exclude.
  APPEND cl_gui_alv_grid=>m_third_party_web TO gt_exclude.
  APPEND cl_gui_alv_grid=>m_bufa_sync TO gt_exclude.

ENDFORM.                    "exclude_toolbar

*&---------------------------------------------------------------------*
*&      Form  handle_user_command
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->I_UCOMM    text
*----------------------------------------------------------------------*
FORM handle_user_command USING i_ucomm TYPE salv_de_function.
  CASE i_ucomm.
    WHEN 'SEND_MAIL'.
      IF p_onay IS INITIAL.
        "SAT'lar için onaycılarına hatırlatma maili gönder
        PERFORM prepare_and_send_mail.     "" onaylanmamış ~ SAT
      ELSE.
        "Onaylanan SAT'lar için Satınalma Departmanına Mail Gönder
        PERFORM prepare_and_send_mail_pd2.  "" onaylanmış
      ENDIF.

  ENDCASE.
ENDFORM.                    "handle_user_command

*&---------------------------------------------------------------------*
*&      Form  PREPARE_AND_SEND_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM prepare_and_send_mail .
  DATA: lt_objtxt   TYPE STANDARD TABLE OF solisti1,
        ls_objtxt   TYPE solisti1 .
  DATA: lv_excel  TYPE string,
        lv_string TYPE string.
  DATA: lt_binary_content  TYPE solix_tab.

  DATA: lv_mail TYPE zsog_mm_018_t_01-mail_adres.
  DATA: lt_alv TYPE TABLE OF zsog_mm_018_s,
        ls_alv TYPE zsog_mm_018_s.
  DATA: lv_menge TYPE char14.
  DATA: lv_preis TYPE char14.
  DATA: lv_banfn TYPE char50."zsog_mm_018_t_01-banfn.

  CLEAR lv_excel.

  SORT gt_alv BY smtp_addr.
  LOOP AT gt_alv INTO gs_alv.
    lv_banfn = gs_alv-banfn.
    IF lv_mail NE gs_alv-smtp_addr.
      lv_mail = gs_alv-smtp_addr.

      CONCATENATE 'Ana Hesap No' 'Ana Hesap Adı' 'Satınalma Talebi' 'SAT Kalemi'
       'SAT Tutarı' 'Para Birimi' 'Miktar' 'Teslim Tarihi' 'SAT Açıklaması' 'Talep Eden' "'Yaratan'
    'Talep Tarihi'
             INTO lv_excel SEPARATED BY cl_bcs_convert=>gc_tab.
      CONCATENATE lv_excel cl_bcs_convert=>gc_crlf INTO lv_excel.

      LOOP AT gt_alv INTO gs_alv WHERE smtp_addr = lv_mail.
        APPEND gs_alv TO lt_alv.
      ENDLOOP.
      PERFORM create_sender_recipient USING lv_mail.
      LOOP AT lt_alv INTO ls_alv.

        lv_menge = ls_alv-menge.
        lv_preis = ls_alv-preis.
        CONCATENATE ls_alv-sakto ls_alv-txt50 ls_alv-banfn ls_alv-bnfpo lv_preis
        ls_alv-waers lv_menge ls_alv-lfdat ls_alv-sat_aciklama ls_alv-afnam
         ls_alv-badat
                   INTO lv_string SEPARATED BY
                   cl_bcs_convert=>gc_tab.
        CONCATENATE lv_string cl_bcs_convert=>gc_crlf INTO lv_string.
        CONCATENATE lv_excel lv_string INTO lv_excel.
        CLEAR:  lv_string, lv_menge.
      ENDLOOP.

      CONCATENATE '<p>' 'Onayınızı beklemekte olan satınalma talepleri ekte listelenmiştir.' '</p>' INTO ls_objtxt-line RESPECTING BLANKS.
      APPEND ls_objtxt TO lt_objtxt.
      gr_document = cl_document_bcs=>create_document(
                 "Body txt formatı burada belirlenir.
                   i_type    = 'HTM'
                   i_text    =  lt_objtxt
                   i_subject = 'SAT Onay Talepleri' ).
      "Add lr_document to send request
      CALL METHOD gr_send_request->set_document( gr_document ).
      CALL METHOD cl_bcs_convert=>string_to_solix
        EXPORTING
          iv_string   = lv_excel
          iv_codepage = '4103'
          iv_add_bom  = 'X'
        IMPORTING
          et_solix    = lt_binary_content. "excel content
*
      CALL METHOD gr_document->add_attachment
        EXPORTING
          i_attachment_type    = 'XLS'
          i_attachment_subject = 'Mail Attachment'
                                                                                                                                                                                                                         " i_attachment_language = sy-langu
          i_att_content_hex    = lt_binary_content.
      " This code add pdf attachment at request
      CALL METHOD gr_send_request->set_document( gr_document ).

      "Send email
      CALL METHOD gr_send_request->send(
        EXPORTING
          i_with_error_screen = 'X'
        RECEIVING
          result              = gv_sent_to_all ).
      "Commit to send email
      COMMIT WORK AND WAIT.
      IF gv_sent_to_all NE 'X'.
        gv_error = 'X'.
        PERFORM add_message USING 'E' 'ZMM' '104'
              lv_banfn(50) 'Satınalma talebi' 'Mail gönderilemedi' ''.
      ELSE.
        PERFORM add_message USING 'S' 'ZMM' '104'
               lv_banfn(50) 'Satınalma talebi' 'Mail gönderildi' ''.
      ENDIF.
    ENDIF.
    CLEAR:gs_alv, lt_alv, lv_excel, ls_objtxt, lt_objtxt,lv_banfn.
  ENDLOOP.
  IF gt_message IS NOT INITIAL.
    PERFORM f_bapiret_display CHANGING gt_message.
  ENDIF.
*  MESSAGE ID 'ZMM' TYPE 'S' NUMBER '139'.

ENDFORM.                    "prepare_and_send_mail

*&---------------------------------------------------------------------*
*&      Form  PREPARE_AND_SEND_MAIL_PD2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM prepare_and_send_mail_pd2 .

  DATA: lt_objtxt   TYPE STANDARD TABLE OF solisti1,"başlangıç
        ls_objtxt   TYPE solisti1 .
  DATA: lv_excel  TYPE string,
        lv_string TYPE string.
  DATA: lt_binary_content  TYPE solix_tab."son

  DATA: lv_mail TYPE zsog_mm_018_t_01-mail_adres.
  DATA: lt_alv TYPE TABLE OF zsog_mm_018_s,
        ls_alv TYPE zsog_mm_018_s.
  DATA: lv_menge TYPE char14.
  DATA: lv_preis TYPE char14.
  DATA: lv_banfn TYPE char50.

  CLEAR lv_excel.

  SORT gt_alv BY smtp_addr.
  LOOP AT gt_alv INTO gs_alv.
    lv_banfn = gs_alv-banfn.
    IF lv_mail NE gs_alv-smtp_addr.
      lv_mail = gs_alv-smtp_addr.

      CONCATENATE 'Ana Hesap No' 'Ana Hesap Adı' 'Satınalma Talebi' 'SAT Kalemi'
       'SAT Tutarı' 'Para Birimi' 'Miktar' 'Teslim Tarihi' 'SAT Açıklaması' 'Talep Eden' 'Yaratan'
    'Talep Tarihi'
             INTO lv_excel SEPARATED BY cl_bcs_convert=>gc_tab.
      CONCATENATE lv_excel cl_bcs_convert=>gc_crlf INTO lv_excel.

      LOOP AT gt_alv INTO gs_alv WHERE smtp_addr = lv_mail.
        APPEND gs_alv TO lt_alv.
      ENDLOOP.
      PERFORM create_sender_recipient USING lv_mail.
      LOOP AT lt_alv INTO ls_alv.

        lv_menge = ls_alv-menge.
        lv_preis = ls_alv-preis.
        CONCATENATE ls_alv-sakto ls_alv-txt50 ls_alv-banfn ls_alv-bnfpo lv_preis
        ls_alv-waers lv_menge ls_alv-lfdat ls_alv-sat_aciklama ls_alv-afnam
         ls_alv-badat
               INTO lv_string SEPARATED BY cl_bcs_convert=>gc_tab.
        CONCATENATE lv_string cl_bcs_convert=>gc_crlf INTO lv_string.
        CONCATENATE lv_excel lv_string INTO lv_excel.
        CLEAR:  lv_string, lv_menge.
      ENDLOOP.

      CONCATENATE '<p>' 'Onaylanan satınalma talepleri ekte listelenmiştir. Bilgilerinize..' '</p>' INTO ls_objtxt-line RESPECTING BLANKS.
      APPEND ls_objtxt TO lt_objtxt.
      gr_document = cl_document_bcs=>create_document(
                 "Body txt formatı burada belirlenir.
                   i_type    = 'HTM'
                   i_text    =  lt_objtxt
                   i_subject = 'Onaylanmış Satınalma Talepleri' ).
      "Add lr_document to send request
      CALL METHOD gr_send_request->set_document( gr_document ).
      CALL METHOD cl_bcs_convert=>string_to_solix
        EXPORTING
          iv_string   = lv_excel
          iv_codepage = '4103'
          iv_add_bom  = 'X'
        IMPORTING
          et_solix    = lt_binary_content. "excel content
*
      CALL METHOD gr_document->add_attachment
        EXPORTING
          i_attachment_type    = 'XLS'
          i_attachment_subject = 'Mail Attachment'
                                                                                                                                                                          " i_attachment_language = sy-langu
          i_att_content_hex    = lt_binary_content.
      " This code add pdf attachment at request
      CALL METHOD gr_send_request->set_document( gr_document ).

      "Send email
      CALL METHOD gr_send_request->send(
        EXPORTING
          i_with_error_screen = 'X'
        RECEIVING
          result              = gv_sent_to_all ).
      "Commit to send email
      COMMIT WORK AND WAIT.
*******************************************************
      IF gv_sent_to_all NE 'X'.
        gv_error = 'X'.
        PERFORM add_message USING 'E' 'ZMM' '104'
              lv_banfn(50) 'Satınalma talebi' 'Mail gönderilemedi' ''.
      ELSE.
        PERFORM add_message USING 'S' 'ZMM' '104'
               lv_banfn(50) 'Satınalma talebi' 'Mail gönderildi' ''.

        LOOP AT lt_alv INTO ls_alv.
          UPDATE eban SET mail_gonderildi = 'X'
                      WHERE banfn EQ ls_alv-banfn
                        AND bnfpo EQ ls_alv-bnfpo.
        ENDLOOP.
      ENDIF.
*      IF sy-subrc EQ 0.
*
*      ENDIF.
*******************************************************
    ENDIF.
    CLEAR:gs_alv, lt_alv, lv_excel, ls_objtxt, lt_objtxt,lv_banfn.
  ENDLOOP.
  IF gt_message IS NOT INITIAL.
    PERFORM f_bapiret_display CHANGING gt_message.
  ENDIF.
*  MESSAGE ID 'ZMM' TYPE 'S' NUMBER '139'.

ENDFORM.                    "prepare_and_send_mail_pd2

*&---------------------------------------------------------------------*
*&      Form  CREATE_SENDER_RECIPIENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_sender_recipient USING p_lv_mail TYPE zsog_mm_018_t_01-mail_adres.
  gr_send_request = cl_bcs=>create_persistent( ). "Create request
  "Email FROM...
  gr_sender_mail    = cl_cam_address_bcs=>create_internet_address(
   'muhasebe@sansgirisim.com' ).
  "Set Sender.Add lr_sender_mail into lr_send_request
  gr_send_request->set_sender( gr_sender_mail ).
  "Email TO...
  gr_recipient = cl_cam_address_bcs=>create_internet_address(
  p_lv_mail ).
  gr_send_request->add_recipient( gr_recipient ).

  "Add lr_recipient to send request(gr_send_request)
  CALL METHOD gr_send_request->add_recipient
    EXPORTING
      i_recipient = gr_recipient
      i_express   = 'X'.
ENDFORM.                    " CREATE_SENDER_RECIPIENT

*&---------------------------------------------------------------------*
*&      Form  add_message
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IV_MSGTY   text
*      -->IV_MSGID   text
*      -->IV_MSGNO   text
*      -->IV_MSGV1   text
*      -->IV_MSGV2   text
*      -->IV_MSGV3   text
*      -->IV_MSGV4   text
*----------------------------------------------------------------------*
FORM add_message USING iv_msgty iv_msgid iv_msgno iv_msgv1
                       iv_msgv2 iv_msgv3 iv_msgv4.

  DATA : ls_return TYPE bapiret2 .

  CALL FUNCTION 'FS_BAPI_BAPIRET2_FILL'
    EXPORTING
      type   = iv_msgty
      cl     = iv_msgid
      number = iv_msgno
      par1   = iv_msgv1
      par2   = iv_msgv2
      par3   = iv_msgv3
      par4   = iv_msgv4
    IMPORTING
      return = ls_return.
  APPEND ls_return TO gt_message.

ENDFORM.                    "add_message
*&---------------------------------------------------------------------*
*& Form f_bapiret_display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_MESSAGE
*&---------------------------------------------------------------------*
FORM f_bapiret_display CHANGING et_message TYPE bapiret2_t .
  CHECK et_message[] IS NOT INITIAL .

  CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
    EXPORTING
      it_message = et_message[].

  CLEAR : et_message, et_message[].
ENDFORM.                    "f_bapiret_display
