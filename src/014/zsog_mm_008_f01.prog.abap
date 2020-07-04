*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_008_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*

FORM get_data .

  TYPES: BEGIN OF ltt_eban,
           banfn TYPE eban-banfn,
           bnfpo TYPE eban-bnfpo,
           badat TYPE eban-badat,
           matnr TYPE eban-matnr,
           menge TYPE eban-menge,
           meins TYPE eban-meins,
           maktx TYPE makt-maktx,
           afnam TYPE eban-afnam,
           ebeln TYPE eban-ebeln,
           ebelp TYPE eban-ebelp,
           bsart TYPE eban-bsart,
           name1 TYPE kna1-name1,
           kunnr TYPE kna1-kunnr,
           loekz TYPE eban-loekz,
           END OF ltt_eban .
  DATA: lt_eban   TYPE TABLE OF ltt_eban,
        lt_eban2 TYPE TABLE OF ltt_eban,
        ls_eban TYPE ltt_eban.

  TYPES: BEGIN OF ltt_siparis,
         ebeln TYPE ekko-ebeln,
         ebelp TYPE ekpo-ebelp,
         werks TYPE ekpo-werks,
         name1 TYPE t001w-name1,
         bedat TYPE ekko-bedat ,
         menge TYPE eket-menge,
         meins TYPE ekpo-meins,
         banfn TYPE eket-banfn,
         bnfpo TYPE eket-bnfpo,
        END OF ltt_siparis.
  DATA: lt_siparis TYPE TABLE OF ltt_siparis,
        ls_siparis TYPE ltt_siparis.

  TYPES: BEGIN OF ltt_mseg,
          mblnr       TYPE  mseg-mblnr     ,
          mjahr       TYPE  mseg-mjahr     ,
          zeile       TYPE  mseg-zeile     ,
          ebeln       TYPE  mseg-ebeln     ,
          ebelp       TYPE  mseg-ebelp     ,
          charg       TYPE  mseg-charg     ,
          budat_mkpf  TYPE  mseg-budat_mkpf,
         END OF ltt_mseg.
  DATA: lt_mseg TYPE TABLE OF ltt_mseg,
        ls_mseg TYPE ltt_mseg.

**  TYPES: BEGIN OF ltt_cargo,
**        ebeln   TYPE  zsog_mm_006_t_02-ebeln,
**        ebelp   TYPE  zsog_mm_006_t_02-ebelp,
**        afnam   TYPE  zsog_mm_006_t_02-afnam,
**        banfn   TYPE  zsog_mm_006_t_02-banfn,
**        bnfpo   TYPE  zsog_mm_006_t_02-bnfpo,
**        durum   TYPE  zsog_mm_006_t_02-durum,
**        musteri_ozel_kodu   TYPE  zsog_mm_006_t_03-musteri_ozel_kodu,
**        irsaliye_numara   TYPE  zsog_mm_006_t_03-irsaliye_numara,
**        gonderici         TYPE  zsog_mm_006_t_03-gonderici,
**        alici             TYPE  zsog_mm_006_t_03-alici,
**        tip_kodu          TYPE  zsog_mm_006_t_03-tip_kodu,
**        durum_kodu        TYPE  zsog_mm_006_t_03-durum_kodu,
**        durumu          TYPE zsog_mm_006_t_03-durumu,
**        kargo_kodu      TYPE zsog_mm_006_t_03-kargo_kodu,
**        teslim_alan     TYPE zsog_mm_006_t_03-teslim_alan,
**        teslim_tarihi   TYPE zsog_mm_006_t_03-teslim_tarihi,
**        teslim_saati    TYPE zsog_mm_006_t_03-teslim_saati,
**       END OF ltt_cargo.
**  DATA: lt_cargo TYPE TABLE OF ltt_cargo,
**        ls_cargo TYPE ltt_cargo.
**
**  TYPES: BEGIN OF ltt_teslimat,
**        irsaliye_numara   TYPE  zsog_mm_006_t_03-irsaliye_numara,
**        gonderici         TYPE  zsog_mm_006_t_03-gonderici,
**        alici             TYPE  zsog_mm_006_t_03-alici,
**        tip_kodu          TYPE  zsog_mm_006_t_03-tip_kodu,
**        durum_kodu        TYPE  zsog_mm_006_t_03-durum_kodu,
**        durumu            TYPE  zsog_mm_006_t_03-durumu,
**        kargo_kodu        TYPE  zsog_mm_006_t_03-kargo_kodu,
**        teslim_alan       TYPE  zsog_mm_006_t_03-teslim_alan,
**        teslim_tarihi     TYPE  zsog_mm_006_t_03-teslim_tarihi,
**        teslim_saati      TYPE  zsog_mm_006_t_03-teslim_saati,
**        musteri_ozel_kodu TYPE  zsog_mm_006_t_03-musteri_ozel_kodu,
**       END OF ltt_teslimat.
**  DATA: lt_teslimat_bilgisi TYPE TABLE OF ltt_teslimat,
**        ls_teslimat_bilgisi TYPE ltt_teslimat.

  DATA: ls_alv TYPE zsog_mm_007_s_007.
  IF cb2 IS NOT INITIAL.
    SELECT
         e~banfn
         e~bnfpo
         e~badat
         e~matnr
         e~menge
         e~meins
         t~maktx
         e~afnam
         e~ebeln
         e~ebelp
         e~bsart
         k~name1
         k~kunnr
         e~loekz
    INTO TABLE lt_eban
    FROM eban AS e
    INNER JOIN makt AS t ON t~matnr = e~matnr
                        AND t~spras = sy-langu
    INNER JOIN kna1 AS k ON e~afnam = k~kunnr
            WHERE e~badat  IN s_badat
             AND  e~afnam  IN s_kunnr
             AND  e~matnr  IN s_matnr
             AND  e~ebeln  IN s_ebeln
             AND  e~bsart  = 'ZSG1'
             AND  e~werks  = '2425'
             AND  e~loekz  = ' '.
    IF sy-subrc NE 0.
      MESSAGE i010(zsg) DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ELSE.
    SELECT
     e~banfn
     e~bnfpo
     e~badat
     e~matnr
     e~menge
     e~meins
     t~maktx
     e~afnam
     e~ebeln
     e~ebelp
     e~bsart
     k~name1
     k~kunnr
INTO CORRESPONDING FIELDS OF TABLE lt_eban
FROM eban AS e
INNER JOIN makt AS t ON t~matnr = e~matnr
                    AND t~spras = sy-langu
INNER JOIN kna1 AS k ON e~afnam = k~kunnr
        WHERE e~badat  IN s_badat
         AND  e~afnam  IN s_kunnr
         AND  e~matnr  IN s_matnr
         AND  e~ebeln  IN s_ebeln
         AND  e~bsart  = 'ZSG1'
         AND  e~werks  = '2425'.
    IF sy-subrc NE 0.
      MESSAGE i010(zsg) DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDIF.

  IF lt_eban IS NOT INITIAL.
    SELECT
      k~ebeln
      p~ebelp
      p~werks
      w~name1
      k~bedat
      t~menge
      p~meins
      t~banfn
      t~bnfpo
      INTO TABLE lt_siparis
      FROM ekko AS k
      INNER JOIN ekpo AS p ON k~ebeln = p~ebeln
      INNER JOIN eket AS t ON p~ebeln = t~ebeln
                          AND p~ebelp = t~ebelp
      INNER JOIN t001w AS w ON p~werks = w~werks
      FOR ALL ENTRIES IN lt_eban
      WHERE k~ebeln = lt_eban-ebeln
        AND t~banfn = lt_eban-banfn
        AND t~bnfpo = lt_eban-bnfpo.

    lt_eban2 = lt_eban.
    DELETE lt_eban2 WHERE ebeln IS INITIAL.

**    IF lt_siparis IS NOT INITIAL.
**      SELECT ebeln
**             ebelp
**             afnam
**             banfn
**             bnfpo
**             durum
**        FROM zsog_mm_006_t_02 AS z2
**        INTO CORRESPONDING FIELDS OF TABLE lt_cargo
**        FOR ALL ENTRIES IN lt_siparis
**        WHERE ebeln = lt_siparis-ebeln
**          AND ebelp = lt_siparis-ebelp
**          AND banfn = lt_siparis-banfn
**          AND bnfpo = lt_siparis-bnfpo .
**    ENDIF.
**
**    LOOP AT lt_cargo INTO ls_cargo WHERE durum EQ '1'.
**      CONCATENATE ls_cargo-banfn ls_cargo-afnam
**      INTO ls_cargo-musteri_ozel_kodu.
* ls_cargo-bnfpo
**      MODIFY lt_cargo FROM ls_cargo TRANSPORTING musteri_ozel_kodu.
**      CLEAR: ls_cargo.
**    ENDLOOP.

**    IF lt_cargo IS NOT INITIAL.
**      SELECT irsaliye_numara
**             gonderici
**             alici
**             tip_kodu
**             durum_kodu
**             durumu
**             kargo_kodu
**             teslim_alan
**             teslim_tarihi
**             teslim_saati
**             musteri_ozel_kodu
**        FROM zsog_mm_006_t_03
**        INTO TABLE lt_teslimat_bilgisi
**        FOR ALL ENTRIES IN lt_cargo
**        WHERE musteri_ozel_kodu = lt_cargo-musteri_ozel_kodu
**          AND durum_kodu IN s_drm.
**    ENDIF.

**    SORT lt_teslimat_bilgisi BY musteri_ozel_kodu.
**    LOOP AT lt_cargo INTO ls_cargo WHERE durum EQ '1'.
**      READ TABLE lt_teslimat_bilgisi
**      INTO ls_teslimat_bilgisi
**      WITH KEY musteri_ozel_kodu = ls_cargo-musteri_ozel_kodu
**      BINARY SEARCH.
**      IF sy-subrc EQ '0'.
**        ls_cargo-irsaliye_numara =
**ls_teslimat_bilgisi-irsaliye_numara.
**        ls_cargo-gonderici     = ls_teslimat_bilgisi-gonderici.
**        ls_cargo-alici         = ls_teslimat_bilgisi-alici.
**        ls_cargo-tip_kodu      = ls_teslimat_bilgisi-tip_kodu.
**        ls_cargo-durum_kodu    = ls_teslimat_bilgisi-durum_kodu.
**        ls_cargo-durumu        = ls_teslimat_bilgisi-durumu.
**        ls_cargo-kargo_kodu    = ls_teslimat_bilgisi-kargo_kodu.
**        ls_cargo-teslim_alan   = ls_teslimat_bilgisi-teslim_alan.
**        ls_cargo-teslim_tarihi = ls_teslimat_bilgisi-teslim_tarihi.
**        ls_cargo-teslim_saati  = ls_teslimat_bilgisi-teslim_saati.
**        MODIFY lt_cargo FROM ls_cargo TRANSPORTING irsaliye_numara
**        gonderici alici tip_kodu durum_kodu durumu kargo_kodu
**        teslim_alan teslim_tarihi teslim_saati.
**      ENDIF.
**    ENDLOOP.

    IF lt_eban2 IS NOT INITIAL.
      IF cb1 IS NOT INITIAL.
        SELECT mblnr
               mjahr
               zeile
               ebeln
               ebelp
               charg
               budat_mkpf
          FROM mseg INTO TABLE lt_mseg
          FOR ALL ENTRIES IN lt_eban2
          WHERE ebeln = lt_eban2-ebeln
            AND ebelp = lt_eban2-ebelp
            AND charg = lt_eban2-kunnr
            AND mblnr = ''.
      ELSE.
        SELECT mblnr
               mjahr
               zeile
               ebeln
               ebelp
               charg
               budat_mkpf
          FROM mseg INTO TABLE lt_mseg
          FOR ALL ENTRIES IN lt_eban2
          WHERE ebeln = lt_eban2-ebeln
            AND ebelp = lt_eban2-ebelp
            AND charg = lt_eban2-kunnr.
      ENDIF.

    ENDIF.
  ENDIF.
  SORT lt_eban BY banfn bnfpo.
  SORT lt_siparis BY ebeln ebelp.
  SORT lt_mseg BY ebeln ebelp charg.
**  SORT lt_cargo BY banfn bnfpo.

  LOOP AT lt_eban INTO ls_eban.

    ls_alv-banfn        = ls_eban-banfn.
    ls_alv-bnfpo        = ls_eban-bnfpo.
    ls_alv-matnr        = ls_eban-matnr.
    ls_alv-maktx        = ls_eban-maktx.
    ls_alv-badat        = ls_eban-badat.
    ls_alv-sat_menge    = ls_eban-menge.
    ls_alv-sat_meins    = ls_eban-meins.
    ls_alv-kunnr        = ls_eban-afnam.
    ls_alv-name1        = ls_eban-name1.
    READ TABLE lt_siparis INTO ls_siparis WITH KEY ebeln = ls_eban-ebeln
                                                   ebelp = ls_eban-ebelp
                                                   BINARY SEARCH.
    ls_alv-ebeln         = ls_siparis-ebeln.
    ls_alv-ebelp         = ls_siparis-ebelp.
    ls_alv-bedat         = ls_siparis-bedat.
    ls_alv-termin_menge  = ls_siparis-menge.
    ls_alv-termin_meins  = ls_siparis-meins.

**    READ TABLE lt_cargo INTO ls_cargo WITH KEY ebeln = ls_eban-ebeln
**                                               ebelp = ls_eban-ebelp
**                                                   BINARY SEARCH.
**
**    IF sy-subrc EQ '0'.
**      IF ls_cargo-durum EQ '2'.
**        ls_alv-cargo_durumu = 'Sipariş Kargoya iletilmedi'.
**      ELSEIF ls_cargo-durum EQ '1'.
**        ls_alv-cargo_durumu = 'Sipariş Kargoya iletildi'.
**        ls_alv-irsaliye_numara = ls_cargo-irsaliye_numara.
**        ls_alv-gonderici       = ls_cargo-gonderici.
**        ls_alv-alici           = ls_cargo-alici.
**        ls_alv-tip_kodu        = ls_cargo-tip_kodu.
**        ls_alv-durum_kodu      = ls_cargo-durum_kodu.
**        ls_alv-durumu        = ls_cargo-durumu.
**        ls_alv-kargo_kodu    = ls_cargo-kargo_kodu.
**        ls_alv-teslim_alan   = ls_cargo-teslim_alan.
**        ls_alv-teslim_tarihi = ls_cargo-teslim_tarihi.
**        ls_alv-teslim_saati  = ls_cargo-teslim_saati.
**      ENDIF.
**    ENDIF.
    READ TABLE lt_mseg INTO ls_mseg WITH KEY ebeln = ls_eban-ebeln
                                             ebelp = ls_eban-ebelp
                                             charg =  ls_eban-kunnr
                                             BINARY SEARCH.
    ls_alv-mblnr    = ls_mseg-mblnr.
    ls_alv-mjahr    = ls_mseg-mjahr.
    ls_alv-zeile    = ls_mseg-zeile.
    ls_alv-budat_mkpf = ls_mseg-budat_mkpf.
    ls_alv-werks        = ls_siparis-werks.
    ls_alv-werks_name1  = ls_siparis-name1.

*durum kodu dolu olduğunda sadece dolu olanlar gelecek şartı
**    IF ls_alv-durum_kodu IS NOT INITIAL.
**      MOVE-CORRESPONDING ls_alv TO gs_kargo_durumu_kodu.
**      APPEND gs_kargo_durumu_kodu TO gt_kargo_durumu_kodu.
**    ENDIF.


*Durum kodu boş olduğunda CB3 dolu ve boş olduğunda
**    IF ls_alv-cargo_durumu IS NOT INITIAL
**      AND ls_alv-durum_kodu IS INITIAL.
**      MOVE-CORRESPONDING ls_alv TO gs_kargo_durumu.
**      APPEND gs_kargo_durumu TO gt_kargo_durumu.
**    ENDIF.
**    IF ls_alv-cargo_durumu IS NOT INITIAL
**      AND ls_alv-durum_kodu IS INITIAL..
**      MOVE-CORRESPONDING ls_alv TO gs_kargo_durumu.
**      APPEND gs_kargo_durumu TO gt_kargo_durumu.
**    ELSEIF ls_alv-cargo_durumu IS NOT INITIAL
**      AND ls_alv-durum_kodu IS NOT INITIAL.
**
**    ENDIF.

    IF ls_alv-bedat IN s_bedat.  "sas tarihi kontrolü eklendi
      APPEND ls_alv TO gt_alv.
    ENDIF.
    CLEAR: ls_alv, ls_siparis, ls_mseg.
  ENDLOOP.

ENDFORM.                    " GET_DATA

*&---------------------------------------------------------------------*
*&      Form  fieldcatalog
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM fieldcatalog .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
*     I_BUFFER_ACTIVE        =
      i_structure_name       = 'ZSOG_MM_007_S_007'
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
      WHEN 'BNFPO'.
        gs_fieldcat-scrtext_s = 'Talep Kalemi'.
        gs_fieldcat-scrtext_m = 'Talep Kalemi'.
        gs_fieldcat-scrtext_l = 'Talep Kalemi'.
        gs_fieldcat-colddictxt = 'M'.
        gs_fieldcat-col_pos   = 3.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'EBELN'.
        gs_fieldcat-scrtext_s = 'SA Belge No'.
        gs_fieldcat-scrtext_m = 'SA Belge No'.
        gs_fieldcat-scrtext_l = 'Satınalma Belge No'.
        gs_fieldcat-colddictxt = 'M'.
        gs_fieldcat-col_pos   = 3.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'EBELP'.
        gs_fieldcat-scrtext_s = 'SA Kalem'.
        gs_fieldcat-scrtext_m = 'SA Kalem'.
        gs_fieldcat-scrtext_l = 'Satın Alma Kalem'.
        gs_fieldcat-colddictxt = 'M'.
        gs_fieldcat-col_pos   = 4.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'MAKTX'.
        gs_fieldcat-scrtext_s = 'Mal Tanımı'.
        gs_fieldcat-scrtext_m = 'Malzeme Tanımı'.
        gs_fieldcat-scrtext_l = 'Malzeme Tanımı'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'KUNNR'.
        gs_fieldcat-scrtext_s = 'Bayi'.
        gs_fieldcat-scrtext_m = 'Bayi'.
        gs_fieldcat-scrtext_l = 'Bayi'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'AFNAM'.
        gs_fieldcat-scrtext_s = 'Bayi'.
        gs_fieldcat-scrtext_m = 'Bayi'.
        gs_fieldcat-scrtext_l = 'Bayi'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
**      WHEN 'IRSALIYE_NUMARA'.
**        gs_fieldcat-scrtext_s = 'İrsaliye No'.
**        gs_fieldcat-scrtext_m = 'İrsaliye No'.
**        gs_fieldcat-scrtext_l = 'İrsaliye Numarası'.
**        gs_fieldcat-colddictxt = 'M'.
**        MODIFY gt_fieldcat FROM gs_fieldcat.
**      WHEN 'GONDERICI'.
**        gs_fieldcat-scrtext_s = 'Gönderici'.
**        gs_fieldcat-scrtext_m = 'Gönderici'.
**        gs_fieldcat-scrtext_l = 'Gönderici'.
**        gs_fieldcat-colddictxt = 'M'.
**        MODIFY gt_fieldcat FROM gs_fieldcat.
**      WHEN 'ALICI'.
**        gs_fieldcat-scrtext_s = 'Alıcı'.
**        gs_fieldcat-scrtext_m = 'Alıcı'.
**        gs_fieldcat-scrtext_l = 'Alıcı'.
**        gs_fieldcat-colddictxt = 'M'.
**        MODIFY gt_fieldcat FROM gs_fieldcat.
**      WHEN 'TIP_KODU'.
**        gs_fieldcat-scrtext_s = 'Tip Kodu'.
**        gs_fieldcat-scrtext_m = 'Tip Kodu'.
**        gs_fieldcat-scrtext_l = 'Tip Kodu'.
**        gs_fieldcat-colddictxt = 'M'.
**        MODIFY gt_fieldcat FROM gs_fieldcat.
**      WHEN 'CARGO_DURUMU'.
**        gs_fieldcat-scrtext_s = 'Kargo Drm Kodu'.
**        gs_fieldcat-scrtext_m = 'Kargo Drm Kodu'.
**        gs_fieldcat-scrtext_l = 'Kargo Durum Kodu'.
**        gs_fieldcat-colddictxt = 'M'.
**        MODIFY gt_fieldcat FROM gs_fieldcat.
    ENDCASE.
  ENDLOOP.

ENDFORM.                    "fieldcatalog

*&---------------------------------------------------------------------*
*&      Form  show_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM show_data .
*  DATA: lcl_alv_event TYPE REF TO lcl_event_receiver.
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
    gs_layout-no_rowmark = 'X'.
*    gs_variant-report    = sy-repid.
*    gs_layout-stylefname = 'CELLSTYLES'.

*
*    CREATE OBJECT lcl_alv_event.
*    CREATE OBJECT go_eventreceiver2.

*    SET HANDLER lcl_alv_event->handle_data_changed FOR gr_alvgrid.
*    SET HANDLER lcl_alv_event->handle_user_command  FOR gr_alvgrid.
*    SET HANDLER lcl_alv_event->handle_toolbar   FOR gr_alvgrid.


*    CALL METHOD gr_alvgrid->register_edit_event
*      EXPORTING
*        i_event_id = cl_gui_alv_grid=>mc_evt_enter.

    CALL METHOD gr_alvgrid->set_table_for_first_display
      EXPORTING
        it_toolbar_excluding          = gt_exclude
        i_structure_name              = 'ZSOG_MM_007_S_007'
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
