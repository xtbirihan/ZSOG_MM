*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_015_KARGO_MG_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data .

  DATA : lt_data1 TYPE TABLE OF zsog_mm_019_t_02,
         ls_data1 TYPE zsog_mm_019_t_02,
         lt_data2 TYPE TABLE OF zsog_mm_019_t_03,
         ls_data2 TYPE zsog_mm_019_t_03,
         lt_kayit TYPE TABLE OF zsog_mm_015_t_02,
         ls_kayit TYPE zsog_mm_015_t_02.
  DATA : lv_musteri_ozel_kodu TYPE char50.
* commented by ilknurnacar 06042020
**  SELECT *
**  FROM zsog_mm_006_t_02
**  INTO TABLE lt_data1
** WHERE bedat IN s_datum
**   AND durum = '1'.
**
**  SELECT *
**  FROM zsog_mm_006_t_03
**  INTO TABLE lt_data2
** WHERE durum_kodu = '6'
**   AND  ( tıp_kodu = '1'
**   OR    tıp_kodu = '2' ).

*
*  SELECT *
*    FROM zsog_mm_015_t_01
*    INTO TABLE lt_kayıt
*    WHERE bedat IN s_datum.

*  SORT lt_kayit BY musteri_ozel_kodu.
*  SORT lt_data2 BY musteri_ozel_kodu.
*
*  LOOP AT lt_data1 INTO ls_data1.
*    CONCATENATE ls_data1-banfn ls_data1-bnfpo ls_data1-afnam
*           INTO lv_musteri_ozel_kodu.
*
*    READ TABLE lt_kayit INTO ls_kayit
*      WITH KEY musteri_ozel_kodu = lv_musteri_ozel_kodu
*      BINARY SEARCH.
*    IF sy-subrc = 0."mal girişi yapıldıysa tekrar göndermemek için kntrl
*      CONTINUE.
*    ELSE.
*
*      READ TABLE lt_data2 INTO ls_data2
*      WITH KEY musteri_ozel_kodu = lv_musteri_ozel_kodu
*      BINARY SEARCH.
*      IF sy-subrc = 0.
*
*        MOVE-CORRESPONDING ls_data1 TO gs_out.
*        MOVE-CORRESPONDING ls_data2 TO gs_out.
*        APPEND gs_out TO gt_out.
*
*      ENDIF.
*
*    ENDIF.
*    CLEAR:ls_data1,ls_data2,gs_out,ls_kayit,lv_musteri_ozel_kodu.
*  ENDLOOP.
* end of commented by ilknurnacar 06042020

* added by ilknurnacar 06042020
  SELECT *
  FROM zsog_mm_019_t_02
  INTO TABLE lt_data1
 WHERE bedat IN s_datum
   AND err_code  = '1'.

  SELECT *
  FROM zsog_mm_019_t_03
  INTO TABLE lt_data2
 WHERE operation_code = '6'.
*   AND  ( tıp_kodu = '1'
*   OR    tıp_kodu = '2' ).
* end of added by ilknurnacar 06042020
  SELECT *
    FROM zsog_mm_015_t_02
    INTO TABLE lt_kayıt
    WHERE bedat IN s_datum.

  SORT lt_kayit BY invoicekey.
  SORT lt_data2 BY invoice_key.
  CLEAR ls_data1.
  LOOP AT lt_data1 INTO ls_data1.
    READ TABLE lt_kayit TRANSPORTING NO FIELDS
                        WITH KEY invoicekey = ls_data1-invoice_key
                        BINARY SEARCH.
    IF sy-subrc = 0."mal girişi yapıldıysa tekrar göndermemek için kntrl
      CONTINUE.
    ELSE.
      CLEAR ls_data2.
      READ TABLE lt_data2 INTO ls_data2
                          WITH KEY invoice_key = ls_data1-invoice_key
                          BINARY SEARCH.
      IF sy-subrc = 0.

        MOVE-CORRESPONDING ls_data1 TO gs_out.
        MOVE-CORRESPONDING ls_data2 TO gs_out.
        APPEND gs_out TO gt_out.

      ENDIF.

    ENDIF.
    CLEAR:ls_data1,ls_data2,gs_out,ls_kayit.
  ENDLOOP.

  IF gt_out IS INITIAL.
    MESSAGE text-002 TYPE 'I'.
  ELSE.
    IF c_job = 'X'.
      PERFORM mal_kabul TABLES gt_out.
    ENDIF.
  ENDIF.

ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      Form  SHOW_DATA
*&---------------------------------------------------------------------*
FORM show_data .

  IF go_custom_container IS INITIAL.
    IF cl_gui_alv_grid=>offline( ) IS INITIAL.
      CREATE OBJECT go_custom_container
        EXPORTING
          container_name = go_container.
    ENDIF.
    CREATE OBJECT go_grid
      EXPORTING
        i_parent = go_custom_container.

*-Layout
    CLEAR gs_layo100.
    gs_layo100-zebra      = 'X'.
    gs_layo100-cwidth_opt = 'X'.
    gs_layo100-sel_mode   = 'A'.
    gs_layo100-stylefname = 'FIELD_STYLE'.
    gs_layo100-info_fname = 'LINECOLOR'.
    gs_variant-report     = sy-repid .

*- Fieldcatalog
    PERFORM build_fcat .

*- Exclude Buttons
    PERFORM exclude_button CHANGING gt_exclude .
    "C
*-Alv Event
    DATA: lcl_alv_event TYPE REF TO lcl_event_receiver.
    CREATE OBJECT lcl_alv_event.

    SET HANDLER lcl_alv_event->hotspot_click       FOR go_grid.
    SET HANDLER lcl_alv_event->handle_toolbar      FOR go_grid.
    SET HANDLER lcl_alv_event->handle_user_command FOR go_grid.

    CALL METHOD go_grid->set_table_for_first_display
      EXPORTING
        is_layout            = gs_layo100
        it_toolbar_excluding = gt_exclude
        is_variant           = gs_variant
        i_save               = 'A'
      CHANGING
        it_outtab            = gt_out[]
        it_fieldcatalog      = gt_fcat[].

    CALL METHOD go_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_enter.

    CALL METHOD go_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified.

    SET HANDLER lcl_alv_event->handle_data_changed FOR go_grid.

  ELSE .
    PERFORM check_changed_data USING go_grid .
    PERFORM refresh_table_display USING go_grid .
  ENDIF .
ENDFORM.                    "show_data
*&---------------------------------------------------------------------*
*&      Form  BUILD_FCAT
*&---------------------------------------------------------------------*
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
      WHEN 'MANDT'.
        gs_fcat-no_out = 'X'.
      WHEN 'CBOX'.
        gs_fcat-no_out = 'X'.
*      when 'ID'.
*        gs_fcat-scrtext_s  = 'Id'.
*        gs_fcat-scrtext_m  = 'Id'.
*        gs_fcat-scrtext_l  = 'Id'.
*        gs_fcat-coltext    = 'Id'.
    ENDCASE.
    MODIFY gt_fcat FROM gs_fcat.
  ENDLOOP.


ENDFORM.                    " BUILD_FCAT
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
*&      Form  MAL_KABUL
*&---------------------------------------------------------------------*
FORM mal_kabul TABLES pt_data.
  DATA:   ls_goodsmvt_header  TYPE bapi2017_gm_head_01,
          ls_goodsmvt_code    TYPE bapi2017_gm_code,
          lt_item             TYPE TABLE OF bapi2017_gm_item_create,
          ls_item             TYPE bapi2017_gm_item_create,
          ls_goodsmvt_headret TYPE bapi2017_gm_head_ret,
          lv_materialdocument TYPE bapi2017_gm_head_ret-mat_doc,
          lv_matdocumentyear  TYPE bapi2017_gm_head_ret-doc_year,
          lt_return           TYPE TABLE OF bapiret2,
          ls_return           TYPE bapiret2.
*  DATA:   lt_kayit            TYPE TABLE OF zsog_mm_015_t_01,  commented by ilknurnacar 06042020
*          ls_kayit            TYPE zsog_mm_015_t_01,
*          ls_data             TYPE zsog_mm_015_t_01,
*          ls_mal_kabul        TYPE zsog_mm_015_t_01.           end of commented by ilknurnacar 06042020
  DATA:  lt_kayit            TYPE TABLE OF zsog_mm_015_t_02,  " added by ilknurnacar 06042020
         ls_kayit            TYPE zsog_mm_015_t_02,
         ls_data             TYPE zsog_mm_015_t_02,
         ls_mal_kabul        TYPE zsog_mm_015_t_02.           "end of added by ilknurnacar 06042020

  IF pt_data[] IS INITIAL.
    MESSAGE i000(zsg) DISPLAY LIKE 'I'
    WITH 'Mal Kabul Yapacak Satatu Bulunamadı!'.
    RETURN.
  ENDIF.

  ls_goodsmvt_header-pstng_date = sy-datum.
  ls_goodsmvt_header-doc_date   = sy-datum .
  ls_goodsmvt_header-ref_doc_no   = 'Mal Girişi' .
  ls_goodsmvt_code-gm_code      = '01'.

  LOOP AT pt_data[] INTO ls_mal_kabul.
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
    ls_return-message_v1 = |Malzeme Belgesi | && | {
    lv_materialdocument } | && | kaydedildi |.
    APPEND ls_return TO lt_return.

    LOOP AT pt_data[] INTO ls_data.

      MOVE-CORRESPONDING ls_data TO ls_kayit.
      ls_kayit-log_date         = sy-datum.
      ls_kayit-log_time         = sy-uzeit.
      ls_kayit-materialdocument = lv_materialdocument.
      APPEND ls_kayit TO lt_kayit.
      CLEAR:ls_kayit,ls_data.

    ENDLOOP.
  ELSE.
    PERFORM bapi_rollback_destination.
  ENDIF.

  IF lt_kayit IS NOT INITIAL.
*    MODIFY zsog_mm_015_t_01 FROM TABLE lt_kayit.  commented by ilknurnacar 06042020
    MODIFY zsog_mm_015_t_02 FROM TABLE lt_kayit.  " added by ilknurnacar 06042020
    COMMIT WORK AND WAIT.
  ENDIF.

  IF lt_return IS NOT INITIAL.
    PERFORM msg_display_error_table TABLES lt_return.
  ENDIF.
ENDFORM.                    " MAL_KABUL
*&---------------------------------------------------------------------*
*&      Form  BAPI_COMMIT_DESTINATION
*&---------------------------------------------------------------------*
FORM bapi_commit_destination .
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' DESTINATION 'NONE'
    EXPORTING
      wait = 'X'.
ENDFORM.                    " BAPI_COMMIT_DESTINATION
*&---------------------------------------------------------------------*
*&      Form  BAPI_ROLLBACK_DESTINATION
*&---------------------------------------------------------------------*
FORM bapi_rollback_destination .
  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK' DESTINATION 'NONE'.
ENDFORM.                    "bapi_rollback_destination
*&---------------------------------------------------------------------*
*&      Form  msg_display_error_table
*&---------------------------------------------------------------------*
FORM msg_display_error_table TABLES pt_return STRUCTURE bapiret2.
  CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
    EXPORTING
      it_message = pt_return[].
ENDFORM.                    "msg_display_error_table
*&---------------------------------------------------------------------*
*&      Form  SECIM_TESPIT
*&---------------------------------------------------------------------*
FORM secim_tespit TABLES pt_row_no.
*  DATA: ls_out     TYPE zsog_mm_015_t_01.
  DATA: ls_out     TYPE zsog_mm_015_t_02.
  DATA: ls_row_no  TYPE lvc_s_roid .

  CLEAR:gv_error.

  CALL METHOD go_grid->get_selected_rows
    IMPORTING
      et_row_no = pt_row_no[].

  IF pt_row_no[] IS INITIAL.
    MESSAGE 'Lütfen satır seçiniz!' TYPE 'I'.
    gv_error = 'X'.
  ELSE.
    LOOP AT pt_row_no[] INTO ls_row_no.

      READ TABLE gt_out INTO ls_out INDEX ls_row_no-row_id.
      IF sy-subrc = 0.
        MOVE-CORRESPONDING ls_out TO gs_selected.
        APPEND gs_selected TO gt_selected.
      ENDIF.
      CLEAR : gs_selected,ls_out,ls_row_no.

    ENDLOOP.
  ENDIF.


ENDFORM.                    " SECIM_TESPIT
