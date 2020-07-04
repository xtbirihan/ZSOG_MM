*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_016_STOK_RAPORU_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data.
  CONSTANTS: lc_bsart LIKE eban-bsart VALUE 'ZSG1',
             lc_afnam LIKE eban-afnam VALUE 'SG%',
             lc_werks LIKE mchb-werks VALUE '2425',
             lc_lgort LIKE mchb-lgort VALUE 'D001',
             lc_init  LIKE eban-ebeln VALUE IS INITIAL.
  DATA: lv_gjahr TYPE gjahr,
        lv_monat TYPE monat.

  lv_gjahr = sy-datum+0(4).
  lv_monat = sy-datum+4(2).

  DATA: BEGIN OF ls_kna1,
          name1 LIKE kna1-name1,
          kunnr LIKE kna1-kunnr,
        END OF ls_kna1,
        lt_kna1 LIKE TABLE OF ls_kna1.

  DATA: BEGIN OF ls_clabs,
          clabs LIKE mchb-clabs,
          charg LIKE mchb-charg,
          matnr LIKE mchb-matnr,
        END OF ls_clabs,
        lt_clabs LIKE TABLE OF ls_clabs.

  DATA: BEGIN OF ls_aedat,
          aedat LIKE ekko-aedat,
          ebeln LIKE ekko-ebeln,
        END OF ls_aedat,
        lt_aedat LIKE TABLE OF ls_aedat.

  DATA: BEGIN OF ls_game_no,
        game_no LIKE zsog_mm_007_t_01-game_no,
        matnr   LIKE zsog_mm_007_t_01-matnr,
      END OF ls_game_no,
      lt_game_no LIKE TABLE OF ls_game_no.

  DATA: BEGIN OF ls_wagers,
        no_of_sold_wagers LIKE zsg_t_001-no_of_sold_wagers,
        retailer_no       LIKE zsg_t_001-retailer_no,
        game_no           LIKE zsog_mm_007_t_01-game_no,
      END OF ls_wagers,
      lt_wagers LIKE TABLE OF ls_wagers.
  DATA: lt_wagers_coll LIKE lt_wagers.

  "ilk tablo olarak eban seçip üzerine yazacağım.
  SELECT afnam matnr badat txz01 ernam menge meins ebeln bedat FROM eban
    INTO CORRESPONDING FIELDS OF TABLE gt_out
      WHERE bsart EQ   lc_bsart
        AND afnam LIKE lc_afnam
        AND matnr IN   s_matnr
        AND afnam IN   s_kunnr
        AND ebeln NE   lc_init.

  "   Afnam ve matnr alanlarına göre dublike olan kayıtların
  " günün tarihine en yakın olanı tutup diğerlerini siliyorum.
  SORT gt_out BY afnam matnr badat DESCENDING.
  DELETE ADJACENT DUPLICATES FROM gt_out COMPARING afnam matnr.

* gt_out boş olursa for all entries in komutu çalışmaz.
  IF gt_out IS NOT INITIAL.
    SELECT name1 kunnr FROM kna1
      INTO TABLE lt_kna1
      FOR ALL ENTRIES IN gt_out
      WHERE kunnr EQ gt_out-afnam.

    SELECT clabs charg matnr FROM mchb
      INTO TABLE lt_clabs
      FOR ALL ENTRIES IN gt_out
      WHERE charg EQ gt_out-afnam
        AND matnr EQ gt_out-matnr
        AND werks EQ lc_werks
        AND lgort EQ lc_lgort.

*    SELECT aedat ebeln FROM ekko
*      INTO TABLE lt_aedat
*      FOR ALL ENTRIES IN gt_out
*      WHERE ebeln EQ gt_out-ebeln.

    SELECT game_no matnr FROM zsog_mm_007_t_01
      INTO TABLE lt_game_no
      FOR ALL ENTRIES IN gt_out
      WHERE matnr EQ gt_out-matnr.

    SELECT no_of_sold_wagers retailer_no game_no FROM zsg_t_001
      INTO TABLE lt_wagers
      FOR ALL ENTRIES IN lt_game_no
      WHERE gjahr = lv_gjahr
        AND monat = lv_monat
        AND game_no = lt_game_no-game_no.
    IF sy-subrc = 0.
      LOOP AT lt_wagers INTO ls_wagers.
        COLLECT ls_wagers INTO lt_wagers_coll.
      ENDLOOP.
    ENDIF.

  ENDIF.

  SORT: lt_kna1  BY kunnr,
        lt_clabs BY charg matnr,
*        lt_aedat BY ebeln,
        lt_wagers_coll BY retailer_no.

  LOOP AT gt_out INTO gs_out.
    CLEAR: ls_kna1, ls_clabs, ls_aedat, ls_game_no, ls_wagers.
    gs_out-meins_e = 'ST'.
    gs_out-meins_s = 'ST'.

    READ TABLE lt_kna1 INTO ls_kna1 WITH KEY kunnr = gs_out-afnam BINARY SEARCH.
    IF sy-subrc = 0.
      gs_out-name1 = ls_kna1-name1.
    ENDIF.

    READ TABLE lt_clabs INTO ls_clabs WITH KEY charg = gs_out-afnam
                                               matnr = gs_out-matnr  BINARY SEARCH.
    IF sy-subrc = 0.
      gs_out-clabs = ls_clabs-clabs.
    ENDIF.

*    READ TABLE lt_aedat INTO ls_aedat WITH KEY ebeln = gs_out-ebeln BINARY SEARCH.
*    IF sy-subrc = 0.
*      gs_out-aedat = ls_aedat-aedat.
*    ENDIF.

    READ TABLE lt_game_no INTO ls_game_no WITH KEY matnr = gs_out-matnr .
    IF sy-subrc = 0.
      READ TABLE lt_wagers_coll INTO ls_wagers WITH KEY retailer_no = gs_out-afnam
                                                        game_no     = ls_game_no-game_no.
      IF sy-subrc = 0.
        gs_out-no_of_sold_wagers = ls_wagers-no_of_sold_wagers.
      ENDIF.
    ENDIF.

*    IF gs_out-aedat IS INITIAL.
*
*      gs_out-color_line = 'C600'.
*      MESSAGE s135(zmm).
*    ENDIF.

    MODIFY gt_out FROM gs_out TRANSPORTING meins_e meins_s name1 clabs aedat no_of_sold_wagers .
  ENDLOOP.

*--------------------------------------------------------------------*
*- satır sayısı doldurulur.

  DATA lv_count TYPE i.

  lv_count = lines( gt_out ).

  CLEAR gv_title.
  gv_title = |Kağıt Malzemeler Satış ve Stok Durum Raporu|
   && | --> | && | Kayıt sayısı: | && lv_count.
*--------------------------------------------------------------------*

ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      Form  SHOW_DATA
*&---------------------------------------------------------------------*
FORM show_data .
  CALL  SCREEN 0100.
ENDFORM.                    " SHOW_DATA
*&---------------------------------------------------------------------*
*&      Form  SHOW_ALV
*&---------------------------------------------------------------------*
FORM show_alv .

  IF go_custom_container IS INITIAL.  ""CONT boşsa alv basılacak.
    CREATE OBJECT go_custom_container
      EXPORTING
        container_name = go_container.

    CREATE OBJECT go_grid
      EXPORTING
        i_parent = go_custom_container.

*-Layout
    PERFORM build_layout.

*- Fieldcatalog
    PERFORM build_fcat .

*- Exclude Buttons
    PERFORM exclude_button CHANGING gt_exclude .

**-Alv Event
*    PERFORM event_handler.

    CALL METHOD go_grid->set_table_for_first_display ""alv basılır.
      EXPORTING
        is_layout            = gs_layo100
        it_toolbar_excluding = gt_exclude
        is_variant           = gs_variant
        i_save               = 'A'
      CHANGING
        it_outtab            = gt_out[]
        it_fieldcatalog      = gt_fcat[].

  ELSE .
    PERFORM check_changed_data    USING go_grid .
    PERFORM refresh_table_display USING go_grid .
    ""cont boş değilse refresh edilir.
  ENDIF.

ENDFORM.                    " SHOW_ALV
*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
FORM build_layout .
  CLEAR gs_layo100.
  gs_layo100-zebra      = 'X'.
  gs_layo100-cwidth_opt = 'X'.
  gs_layo100-sel_mode   = 'A'.
*  gs_layo100-info_fname = 'COLOR_LINE'.
  gs_variant-report     = sy-repid .
ENDFORM.                    " BUILD_LAYOUT
*&---------------------------------------------------------------------*
*&      Form  BUILD_FCAT
*&---------------------------------------------------------------------*
FORM build_fcat .

  DATA:
      lt_kkblo_fieldcat TYPE kkblo_t_fieldcat,
      lv_repid          TYPE sy-repid.

  lv_repid = sy-repid.

*LVC_TRANSFER_FROM_SLIS
*REUSE_ALV_FIELDCATALOG_MERGE

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
  IF sy-subrc NE 0.
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
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE 'A' NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT gt_fcat INTO gs_fcat.
    gs_fcat-key = ' '.
    CASE gs_fcat-fieldname .
      WHEN 'EBELN'.
        gs_fcat-no_out    = 'X'.
      WHEN 'COLOR_LINE'.
        gs_fcat-no_out    = 'X'.
      WHEN 'EBELP'.
        gs_fcat-no_out    = 'X'.
      WHEN 'BADAT'.
        gs_fcat-scrtext_s  = 'Son Siparişin Talep T.'.
        gs_fcat-scrtext_m  = 'Son Siparişin Talep T.'.
        gs_fcat-scrtext_l  = 'Son Siparişin Talep T.'.
        gs_fcat-coltext    = 'Son Siparişin Talep T.'.
      WHEN 'AEDAT'.
        gs_fcat-no_out    = 'X'.
        gs_fcat-scrtext_s  = 'Son Sipariş Tarihi'.
        gs_fcat-scrtext_m  = 'Son Sipariş Tarihi'.
        gs_fcat-scrtext_l  = 'Son Sipariş Tarihi'.
        gs_fcat-coltext    = 'Son Sipariş Tarihi'.
      WHEN 'MEINS'.
        gs_fcat-scrtext_s  = 'Temel Ölçü Birimi'.
        gs_fcat-scrtext_m  = 'Temel Ölçü Birimi'.
        gs_fcat-scrtext_l  = 'Temel Ölçü Birimi'.
        gs_fcat-coltext    = 'Temel Ölçü Birimi'.
      WHEN 'NO_OF_SOLD_WAGERS'.
        gs_fcat-scrtext_s  = 'Aylık Satılan Kupon'.
        gs_fcat-scrtext_m  = 'Aylık Satılan Kupon'.
        gs_fcat-scrtext_l  = 'Aylık Satılan Kupon'.
        gs_fcat-coltext    = 'Aylık Satılan Kupon'.
      WHEN 'ERNAM'.
        gs_fcat-scrtext_s  = 'Son Talebi Açan'.
        gs_fcat-scrtext_m  = 'Son Talebi Açan'.
        gs_fcat-scrtext_l  = 'Son Talebi Açan'.
        gs_fcat-coltext    = 'Son Talebi Açan'.
      WHEN 'MENGE'.
        gs_fcat-scrtext_s  = 'Son Sipariş Adeti'.
        gs_fcat-scrtext_m  = 'Son Sipariş Adeti'.
        gs_fcat-scrtext_l  = 'Son Sipariş Adeti'.
        gs_fcat-coltext    = 'Son Sipariş Adeti'.
      WHEN 'MEINS_S'.
        gs_fcat-scrtext_s  = 'Satış Ölçü Birimi'.
        gs_fcat-scrtext_m  = 'Satış Ölçü Birimi'.
        gs_fcat-scrtext_l  = 'Satış Ölçü Birimi'.
        gs_fcat-coltext    = 'Satış Ölçü Birimi'.
      WHEN 'MEINS_E'.
        gs_fcat-scrtext_s  = 'Ölçü Birimi'.
        gs_fcat-scrtext_m  = 'Ölçü Birimi'.
        gs_fcat-scrtext_l  = 'Ölçü Birimi'.
        gs_fcat-coltext    = 'Ölçü Birimi'.
      WHEN 'CLABS'.
        gs_fcat-scrtext_s  = 'Tahmini Bayi Stoku'.
        gs_fcat-scrtext_m  = 'Tahmini Bayi Stoku'.
        gs_fcat-scrtext_l  = 'Tahmini Bayi Stoku'.
        gs_fcat-coltext    = 'Tahmini Bayi Stoku'.
      WHEN 'BEDAT'.
        gs_fcat-scrtext_s  = 'Son Sipariş Tarihi'.
        gs_fcat-scrtext_m  = 'Son Sipariş Tarihi'.
        gs_fcat-scrtext_l  = 'Son Sipariş Tarihi'.
        gs_fcat-coltext    = 'Son Sipariş Tarihi'.
    ENDCASE.
    MODIFY gt_fcat FROM gs_fcat.
*    TRANSPORTING col_pos hotspot ....
  ENDLOOP.

ENDFORM.                    " BUILD_FCAT
*&---------------------------------------------------------------------*
*&      Form  EXCLUDE_BUTTON
*&---------------------------------------------------------------------*
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

ENDFORM.                    " EXCLUDE_BUTTON
*&---------------------------------------------------------------------*
*&      Form  CHECK_CHANGED_DATA
*&---------------------------------------------------------------------*
FORM check_changed_data USING io_grid TYPE REF TO cl_gui_alv_grid .

  DATA: lv_valid TYPE c.

  CALL METHOD io_grid->check_changed_data
    IMPORTING
      e_valid = lv_valid.

ENDFORM.                    " CHECK_CHANGED_DATA
*&---------------------------------------------------------------------*
*&      Form  REFRESH_TABLE_DISPLAY
*&---------------------------------------------------------------------*
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
