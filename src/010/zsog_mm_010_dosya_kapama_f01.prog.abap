*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_010_DOSYA_KAPAMA_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  INITIALIZE_ALV
*&---------------------------------------------------------------------*
FORM initialize_alv .
  DATA message   TYPE REF TO cx_salv_msg.

  TRY.
      cl_salv_table=>factory(
      IMPORTING
        r_salv_table = gs_scr-1903-r_alv
      CHANGING
        t_table      = gs_scr-1903-alv ).

      gs_scr-1903-r_columns = gs_scr-1903-r_alv->get_columns( ).

      PERFORM enable_layout_settings.
      PERFORM optimize_column_width.
      PERFORM hide_client_column.
      PERFORM set_icon.
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
FORM enable_layout_settings.
*&---------------------------------------------------------------------*
  DATA layout_settings TYPE REF TO cl_salv_layout.
  DATA layout_key      TYPE salv_s_layout_key.


  layout_settings = gs_scr-1903-r_alv->get_layout( ).
  layout_key-report = sy-repid.
  layout_settings->set_key( layout_key ).
  layout_settings->set_save_restriction( if_salv_c_layout=>restrict_none ).

  gs_scr-1903-r_selections = gs_scr-1903-r_alv->get_selections( ).
  gs_scr-1903-r_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

ENDFORM.                    "ENABLE_LAYOUT_SETTINGS

*&---------------------------------------------------------------------*
FORM optimize_column_width.
*&---------------------------------------------------------------------*
  gs_scr-1903-r_columns->set_optimize( ).
ENDFORM.                    "OPTIMIZE_COLUMN_WIDTH

*&---------------------------------------------------------------------*
FORM hide_client_column.
*&---------------------------------------------------------------------*
  DATA not_found TYPE REF TO cx_salv_not_found.

  TRY.
      gs_scr-1903-r_column = gs_scr-1903-r_columns->get_column( 'DETAIL' ).
      gs_scr-1903-r_column->set_visible( if_salv_c_bool_sap=>false ).
    CATCH cx_salv_not_found INTO not_found.
      " error handling
  ENDTRY.

  TRY.
      gs_scr-1903-r_column = gs_scr-1903-r_columns->get_column( 'SIL' ).
      gs_scr-1903-r_column->set_visible( if_salv_c_bool_sap=>false ).
    CATCH cx_salv_not_found INTO not_found.
      " error handling
  ENDTRY.

ENDFORM.                    " HIDE_CLIENT_COLUMN
*&---------------------------------------------------------------------*
*&      Form  set_icon
*&---------------------------------------------------------------------*
FORM set_icon.
  DATA: lr_columns TYPE REF TO cl_salv_columns_table,
       lr_column  TYPE REF TO cl_salv_column_table.
*
  lr_columns = gs_scr-1903-r_alv->get_columns( ).
  lr_column ?= lr_columns->get_column( 'ICON' ).
  lr_column->set_icon( if_salv_c_bool_sap=>true ).
*
*  lr_column ?= lr_columns->get_column( 'STATUS' ).
*  lr_column->set_icon( if_salv_c_bool_sap=>true ).
*
  lr_column ?= lr_columns->get_column( 'ICON' ).
  lr_column->set_cell_type( if_salv_c_cell_type=>hotspot ).

ENDFORM.                    "set_icon
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
  functions = gs_scr-1903-r_alv->get_functions( ).
  functions->set_all( ).

  gs_scr-1903-r_alv->set_screen_status(
    pfstatus      = 'STANDARD'
    report        = sy-repid
    set_functions = gs_scr-1903-r_alv->c_functions_all ).
ENDFORM.                    " SET_TOOLBAR
*&---------------------------------------------------------------------*
FORM display_settings.
*&---------------------------------------------------------------------*
  DATA display_settings TYPE REF TO cl_salv_display_settings.
  DATA: lv_tanim TYPE text70.
  DATA: lv_line TYPE i.
  lv_line  = lines( gs_scr-1903-alv ).
  lv_tanim = |Terminal İthalat Süreci | && |--> | && |{ lv_line }| && | Kayıt Bulundu|.

  display_settings = gs_scr-1903-r_alv->get_display_settings( ).
  display_settings->set_striped_pattern( if_salv_c_bool_sap=>true ).
  display_settings->set_list_header( lv_tanim ).
ENDFORM.                    "display_settings
*&---------------------------------------------------------------------*
*&      Form  SET_HOTSPOT_CLICK
*&---------------------------------------------------------------------*
FORM set_hotspot_click .
*-- events
  gs_scr-1903-r_events = gs_scr-1903-r_alv->get_event( ).
  CREATE OBJECT event_handler.
  SET HANDLER event_handler->on_link_click   FOR gs_scr-1903-r_events.
  SET HANDLER event_handler->on_user_command FOR gs_scr-1903-r_events.
ENDFORM.                    "set_hotspot_click
*&---------------------------------------------------------------------*
FORM display_alv.
*&---------------------------------------------------------------------*
  gs_scr-1903-r_alv->display( ).
ENDFORM.                    " DISPLAY_ALV
*&---------------------------------------------------------------------*
*&      Form  handle_user_command
*&---------------------------------------------------------------------*
FORM handle_user_command USING i_ucomm TYPE salv_de_function.
  CASE i_ucomm.
    WHEN '&DETAIL'.
      PERFORM detail.
*      CALL SCREEN 1903.
    WHEN '&INVOICE'.
      PERFORM create_invoce.
  ENDCASE.
ENDFORM.                    "handle_user_command
*&---------------------------------------------------------------------*
*&      Form  ON_LINK_CLICK
*&---------------------------------------------------------------------*
FORM on_link_click  USING    p_row
                             p_column.
  DATA: lt_bapiret2 TYPE TABLE OF bapiret2.
  DATA: ls_alv      TYPE zsog_mm_010_001.
  DATA: lo_alv TYPE REF TO cl_salv_table.

  CASE p_column.
    WHEN 'ICON'.
      CLEAR: gs_scr-1903-detail.
      READ TABLE gs_scr-1903-alv INTO ls_alv INDEX p_row.
      IF ls_alv-detail IS NOT INITIAL.
        gs_scr-1903-detail = ls_alv-detail.
        PERFORM initialize_alv2 USING 'ICON'.
        PERFORM display_alv.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    " ON_LINK_CLICK
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data .

  DATA: lv_count TYPE i,
        lv_total TYPE zsog_mm_010_001-dgtlms_yan_masraf,
        lv_index TYPE sy-tabix.
  TYPES: BEGIN OF ltt_ithalat,
         lifnr TYPE lfa1-lifnr,
         vbeln TYPE likp-vbeln,
         posnr TYPE lips-posnr,
         vgbel TYPE lips-vgbel,
         vgpos TYPE lips-vgpos,
         ebelp TYPE ekpo-ebelp,
         END OF ltt_ithalat.
  DATA: lt_ithalat TYPE TABLE OF ltt_ithalat.
  FIELD-SYMBOLS: <fs_ithalat> TYPE ltt_ithalat.

  TYPES: BEGIN OF ltt_po,
         ebeln   TYPE zsog_mm_010_001-ebeln,
         ebelp   TYPE zsog_mm_010_001-ebelp,
         matnr   TYPE zsog_mm_010_001-matnr,
         maktx   TYPE zsog_mm_010_001-maktx,
         menge   TYPE zsog_mm_010_001-menge,
         meins   TYPE zsog_mm_010_001-meins,
         netwr   TYPE zsog_mm_010_001-netwr,
         waers   TYPE zsog_mm_010_001-waers,
         belnr   TYPE rseg-belnr,
         gjahr   TYPE rseg-gjahr,
         buzei   TYPE rseg-buzei,
         r_menge TYPE rseg-menge,
         r_wrbtr TYPE rseg-wrbtr,
         bstme   TYPE rseg-bstme,
         budat   TYPE rbkp-budat,
         r_waers TYPE rbkp-waers,
         xblnr   TYPE bsik-xblnr,
         END OF ltt_po.

  DATA: lt_po TYPE TABLE OF ltt_po,
        ls_po TYPE ltt_po.


  TYPES: BEGIN OF ltt_po_collect,
         ebeln   TYPE zsog_mm_010_001-ebeln,
         r_menge TYPE rseg-menge,
         r_wrbtr TYPE rseg-wrbtr,
         END OF ltt_po_collect.

  DATA: lt_po_collect TYPE TABLE OF ltt_po_collect,
        ls_po_collect TYPE ltt_po_collect.

  TYPES: BEGIN OF ltt_bsik,
         bukrs  TYPE bsik-bukrs ,
         lifnr  TYPE bsik-lifnr ,
         gjahr  TYPE bsik-gjahr ,
         belnr  TYPE bsik-belnr ,
         buzei  TYPE bsik-buzei ,
         budat  TYPE bsik-budat ,
         bldat  TYPE bsik-bldat ,
         waers  TYPE bsik-waers ,
         xblnr  TYPE bsik-xblnr ,
         blart  TYPE bsik-blart ,
         shkzg  TYPE bsik-shkzg ,
         mwskz  TYPE bsik-mwskz ,
         dmbtr  TYPE bsik-dmbtr ,
         wrbtr  TYPE bsik-wrbtr ,
         sgtxt  TYPE bsik-sgtxt ,
         anln1  TYPE bsik-anln1 ,
         ebeln  TYPE bsik-ebeln ,
         ebelp  TYPE bsik-ebelp ,
         saknr  TYPE bsik-saknr ,
         hkont  TYPE bsik-hkont ,
         fkont  TYPE bsik-fkont ,
         END OF ltt_bsik.
  DATA: lt_bsik TYPE TABLE OF ltt_bsik,
        ls_bsik TYPE ltt_bsik.

  TYPES: BEGIN OF ltt_bsik_collect,
         xblnr  TYPE bsik-xblnr ,
         lifnr  TYPE bsik-lifnr ,
         dmbtr  TYPE bsik-dmbtr ,
         wrbtr  TYPE bsik-wrbtr ,
         END OF ltt_bsik_collect.
  DATA: lt_bsik_collect TYPE TABLE OF ltt_bsik_collect,
        ls_bsik_collect TYPE ltt_bsik_collect.


  TYPES: BEGIN OF ltt_duran_varlik,
          mblnr       TYPE mseg-mblnr     ,
          mjahr       TYPE mseg-mjahr     ,
          zeile       TYPE mseg-zeile     ,
          ebeln       TYPE mseg-ebeln     ,
          ebelp       TYPE mseg-ebelp     ,
          bwart       TYPE mseg-bwart     ,
          matnr       TYPE mseg-matnr     ,
          werks       TYPE mseg-werks     ,
          werks_name  TYPE t001w-name1    ,
          lgort       TYPE mseg-lgort     ,
          lgobe       TYPE t001l-lgobe    ,
          charg       TYPE mseg-charg     ,
          budat_mkpf  TYPE mseg-budat_mkpf,
          obknr       TYPE ser03-obknr    ,
          obzae       TYPE objk-obzae     ,
          equnr       TYPE objk-equnr     ,
         END OF ltt_duran_varlik.
  DATA: lt_duran_varlik TYPE TABLE OF ltt_duran_varlik.
  FIELD-SYMBOLS: <fs_duran_varlik> TYPE ltt_duran_varlik.
  FIELD-SYMBOLS: <fs_duran_varlik2> TYPE ltt_duran_varlik.

  TYPES: BEGIN OF ltt_ekipman,
         anlnr TYPE m_equia-anlnr,
         anlun TYPE m_equia-anlun,
         bukrs TYPE m_equia-bukrs,
         equnr TYPE m_equia-equnr,
         eqktu TYPE m_equia-eqktu,
         sernr TYPE equi-sernr,
         END OF ltt_ekipman.
  DATA: lt_ekipman TYPE TABLE OF ltt_ekipman,
        ls_ekipman TYPE ltt_ekipman.


  DATA: ls_alv TYPE zsog_mm_010_001,
        ls_detail  TYPE zsog_mm_010_002.

  SELECT l~lifnr
         p~vbeln
         s~posnr
         s~vgbel
         s~vgpos
      INTO TABLE lt_ithalat
      FROM lfa1 AS l
      INNER JOIN likp AS p ON p~vbeln = l~lifnr
      INNER JOIN lips AS s ON s~vbeln = p~vbeln
      WHERE l~lifnr IN s_lifnr.
  IF sy-subrc NE 0.
    MESSAGE i013(zsg) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  LOOP AT lt_ithalat ASSIGNING <fs_ithalat>.
    <fs_ithalat>-ebelp = <fs_ithalat>-vgpos.
  ENDLOOP.

  SELECT  o~ebeln
          o~ebelp
          o~matnr
          t~maktx
          o~menge
          o~meins
          o~netwr
          k~waers
          r~belnr
          r~gjahr
          r~buzei
          r~menge AS r_menge
          r~wrbtr AS r_wrbtr
          r~bstme
          p~budat
          p~waers AS r_waers
          o~ebeln AS xblnr
       INTO TABLE lt_po
       FROM ekpo AS o
       INNER JOIN ekko AS k ON o~ebeln = k~ebeln
       INNER JOIN rseg AS r ON r~ebeln = o~ebeln
                           AND r~ebelp = o~ebelp

       INNER JOIN rbkp AS p ON r~belnr = p~belnr
                           AND r~gjahr = p~gjahr
       INNER JOIN makt AS t ON o~matnr = t~matnr
                            AND t~spras = sy-langu
       FOR ALL ENTRIES IN lt_ithalat
       WHERE o~ebeln = lt_ithalat-vgbel
         AND o~ebelp = lt_ithalat-ebelp
         and r~tbtkz eq ''.


  IF lt_po IS NOT INITIAL.

    SELECT bukrs
           lifnr
           gjahr
           belnr
           buzei
           budat
           bldat
           waers
           xblnr
           blart
           shkzg
           mwskz
           dmbtr
           wrbtr
           sgtxt
           anln1
           ebeln
           ebelp
           saknr
           hkont
           fkont
          FROM bsik INTO TABLE lt_bsik
          FOR ALL ENTRIES IN lt_po
          WHERE bukrs EQ '2425'
            AND xblnr EQ lt_po-xblnr
            AND lifnr IN s_lifnr
            AND budat IN s_budat
            AND ( shkzg EQ 'S' OR shkzg EQ 'H' ).
  ENDIF.
  LOOP AT lt_bsik INTO ls_bsik.
    ls_bsik_collect-xblnr = ls_bsik-xblnr .
    ls_bsik_collect-lifnr = ls_bsik-lifnr .
    ls_bsik_collect-dmbtr = ls_bsik-dmbtr .
    ls_bsik_collect-wrbtr = ls_bsik-wrbtr .
    IF ls_bsik-shkzg EQ 'H'.
      ls_bsik_collect-dmbtr = ls_bsik-dmbtr * -1 .
      ls_bsik_collect-wrbtr = ls_bsik-wrbtr * -1 .
    ELSEIF ls_bsik-shkzg EQ 'S'.
      ls_bsik_collect-dmbtr = ls_bsik-dmbtr .
      ls_bsik_collect-wrbtr = ls_bsik-wrbtr  .
    ENDIF.
    COLLECT ls_bsik_collect INTO lt_bsik_collect.
    CLEAR: ls_bsik_collect.
  ENDLOOP.

  LOOP AT lt_po INTO ls_po.
    ls_po_collect-ebeln    = ls_po-ebeln.
    ls_po_collect-r_menge  = ls_po-r_menge.
    ls_po_collect-r_wrbtr  = ls_po-r_wrbtr.
    COLLECT ls_po_collect INTO lt_po_collect.
    CLEAR: ls_po_collect.
  ENDLOOP.

  IF lt_po IS NOT INITIAL.
    SELECT m~mblnr
           m~mjahr
           m~zeile
           m~ebeln
           m~ebelp
           m~bwart
           m~matnr
           m~werks
           w~name1 AS werks_name
           m~lgort
           l~lgobe
           m~charg
           m~budat_mkpf
           s~obknr
           j~obzae
           j~equnr
      INTO TABLE lt_duran_varlik
      FROM mseg AS m
      INNER JOIN ser03 AS s ON s~mblnr EQ m~mblnr
                           AND s~mjahr EQ m~mjahr
                           AND s~zeile EQ m~zeile
      INNER JOIN objk AS j ON s~obknr = j~obknr
      LEFT OUTER JOIN t001w AS w ON w~werks = m~werks
      LEFT OUTER JOIN t001l AS l ON l~lgort = m~lgort
      FOR ALL ENTRIES IN lt_po
      WHERE ebeln = lt_po-ebeln
        AND ebelp = lt_po-ebelp.

    IF lt_duran_varlik IS NOT INITIAL.
      SELECT m~anlnr
             m~anlun
             m~bukrs
             m~equnr
             m~eqktu
             e~sernr
         INTO TABLE lt_ekipman
         FROM m_equia AS m
         INNER JOIN equi AS e ON e~equnr EQ m~equnr
         FOR ALL ENTRIES IN lt_duran_varlik
         WHERE m~equnr = lt_duran_varlik-equnr.
    ENDIF.
  ENDIF.


  SORT lt_po_collect BY ebeln.
  SORT lt_bsik_collect BY xblnr.
  SORT lt_po BY ebeln ebelp.
  SORT lt_duran_varlik BY ebeln ebelp.
  SORT lt_ekipman BY equnr.

  LOOP AT lt_ithalat ASSIGNING <fs_ithalat>.
    READ TABLE lt_po INTO ls_po WITH KEY ebeln  = <fs_ithalat>-vgbel
                                         ebelp  = <fs_ithalat>-ebelp BINARY SEARCH.

    ls_alv-ebeln          = ls_po-ebeln.
    ls_alv-ebelp          = ls_po-ebelp.
    ls_alv-lifnr          = <fs_ithalat>-lifnr.
    ls_alv-matnr          = ls_po-matnr.
    ls_alv-maktx          = ls_po-maktx.
    ls_alv-menge          = ls_po-menge.
    ls_alv-meins          = ls_po-meins.
    ls_alv-netwr          = ls_po-netwr.
    ls_alv-waers          = ls_po-waers.
    ls_alv-fatura_miktar  = ls_po-r_menge.
    ls_alv-fatura_tutari  = ls_po-r_wrbtr.
    READ TABLE lt_bsik_collect INTO ls_bsik_collect WITH KEY xblnr = ls_po-ebeln BINARY SEARCH.

*    ls_alv-toplam_yan_masraf = ls_bsik_collect-wrbtr.  "mustafa
    ls_alv-toplam_yan_masraf = ls_bsik_collect-dmbtr.
    READ TABLE lt_po_collect INTO ls_po_collect WITH KEY ebeln = ls_po-ebeln BINARY SEARCH.
    IF ls_po_collect-r_wrbtr IS NOT INITIAL.
*      ls_alv-dgtlms_yan_masraf = ( ls_bsik_collect-wrbtr * ls_alv-fatura_tutari ) / ls_po_collect-r_wrbtr.   "mustafa
      ls_alv-dgtlms_yan_masraf = ( ls_bsik_collect-dmbtr * ls_alv-fatura_tutari ) / ls_po_collect-r_wrbtr.
    ENDIF.
    ls_alv-icon = icon_doc_header_detail.

    READ TABLE lt_duran_varlik TRANSPORTING NO FIELDS
       WITH KEY ebeln = ls_po-ebeln
                ebelp = ls_po-ebelp
       BINARY SEARCH.
    IF sy-subrc EQ 0.
      LOOP AT lt_duran_varlik FROM sy-tabix ASSIGNING <fs_duran_varlik>.
        IF <fs_duran_varlik>-ebeln <> ls_po-ebeln OR
           <fs_duran_varlik>-ebelp <> ls_po-ebelp.
          EXIT.
        ENDIF.
        lv_index = lv_index + 1.

        READ TABLE lt_duran_varlik TRANSPORTING NO FIELDS
                                   WITH KEY ebeln = ls_po-ebeln
                                            ebelp = ls_po-ebelp
                                   BINARY SEARCH.
        IF sy-subrc EQ 0.
          LOOP AT lt_duran_varlik FROM sy-tabix ASSIGNING <fs_duran_varlik2>.
            IF <fs_duran_varlik2>-ebeln <> ls_po-ebeln OR
               <fs_duran_varlik2>-ebelp <> ls_po-ebelp.
              EXIT.
            ENDIF.
            lv_count = lv_count + 1.
          ENDLOOP.
        ENDIF.

        MOVE-CORRESPONDING ls_alv TO ls_detail.
        ls_detail-yan_masraf_great_total = ls_detail-dgtlms_yan_masraf .
        lv_total = lv_total + ls_detail-dgtlms_yan_masraf / lv_count.
        IF lv_total > ls_detail-dgtlms_yan_masraf.
          ls_detail-dgtlms_yan_masraf = ls_detail-dgtlms_yan_masraf - lv_total +
                                        ls_detail-dgtlms_yan_masraf / lv_count.
        ELSE.
          ls_detail-dgtlms_yan_masraf = ls_detail-dgtlms_yan_masraf / lv_count.
        ENDIF.
        IF lv_index EQ lv_count.
          IF lv_total < ls_alv-dgtlms_yan_masraf.
            ls_detail-dgtlms_yan_masraf = ls_detail-dgtlms_yan_masraf + ls_alv-dgtlms_yan_masraf - lv_total.
          ENDIF.
        ENDIF.
        ls_detail-mblnr       = <fs_duran_varlik>-mblnr     .
        ls_detail-mjahr       = <fs_duran_varlik>-mjahr     .
        ls_detail-zeile       = <fs_duran_varlik>-zeile     .
        ls_detail-ebeln       = <fs_duran_varlik>-ebeln     .
        ls_detail-ebelp       = <fs_duran_varlik>-ebelp     .
        ls_detail-matnr       = <fs_duran_varlik>-matnr     .
        ls_detail-werks       = <fs_duran_varlik>-werks     .
        ls_detail-werks_name  = <fs_duran_varlik>-werks_name.
        ls_detail-lgort       = <fs_duran_varlik>-lgort     .
        ls_detail-lgobe       = <fs_duran_varlik>-lgobe     .
        ls_detail-budat_mkpf  = <fs_duran_varlik>-budat_mkpf.

        ls_detail-belnr   =  ls_po-belnr .
        ls_detail-buzei   =  ls_po-buzei .
        ls_detail-gjahr   =  ls_po-gjahr .
        ls_detail-budat   =  ls_po-budat .
        ls_detail-waers   =  ls_po-r_waers.
        ls_detail-bstme   =  ls_po-bstme.

        READ TABLE lt_ekipman INTO ls_ekipman WITH KEY equnr = <fs_duran_varlik>-equnr BINARY SEARCH.
        ls_detail-anln1 = ls_ekipman-anlnr.
        ls_detail-sernr = ls_ekipman-sernr.
        APPEND ls_detail TO ls_alv-detail .
        CLEAR: ls_detail, lv_count.
      ENDLOOP.
    ENDIF.

    APPEND ls_alv TO gs_scr-1903-alv.
    CLEAR: ls_po, ls_alv, ls_bsik_collect, lv_count, lv_total, lv_index.
  ENDLOOP.

  PERFORM initialize_alv.
  PERFORM display_alv.
ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      Form  INITIALIZE_ALV
*&---------------------------------------------------------------------*
FORM initialize_alv2 USING pv_value.
  DATA message   TYPE REF TO cx_salv_msg.

  TRY.
      cl_salv_table=>factory(
      IMPORTING
        r_salv_table = gs_scr-1903-r_alv
      CHANGING
        t_table      = gs_scr-1903-detail ).

      gs_scr-1903-r_columns = gs_scr-1903-r_alv->get_columns( ).

      PERFORM enable_layout_settings.
      PERFORM optimize_column_width.
      PERFORM hide_client_column.
*      PERFORM set_icon.
      PERFORM set_column_names.
      PERFORM set_toolbar2.
      PERFORM display_settings2.
      PERFORM set_hotspot_click.
      PERFORM hide_pf_status USING pv_value.
      " ...
      " PERFORM setting_n.
    CATCH cx_salv_msg INTO message.
      " error handling
  ENDTRY.
ENDFORM.                    "initialize_alv
*&---------------------------------------------------------------------*
FORM set_toolbar2.
*&---------------------------------------------------------------------*
  DATA functions TYPE REF TO cl_salv_functions_list.
  functions = gs_scr-1903-r_alv->get_functions( ).
  functions->set_all( ).

  gs_scr-1903-r_alv->set_screen_status(
    pfstatus      = 'STANDARD2'
    report        = sy-repid
    set_functions = gs_scr-1903-r_alv->c_functions_all ).
ENDFORM.                    " SET_TOOLBAR
*&---------------------------------------------------------------------*
FORM display_settings2.
*&---------------------------------------------------------------------*
  DATA display_settings TYPE REF TO cl_salv_display_settings.
  DATA: lv_tanim TYPE text70.
  DATA: lv_line TYPE i.
  lv_line  = lines( gs_scr-1903-detail ).
  lv_tanim = |Terminal İthalat Süreci Detay | && |--> | && |{ lv_line }| && | Kayıt Bulundu|.

  display_settings = gs_scr-1903-r_alv->get_display_settings( ).
  display_settings->set_striped_pattern( if_salv_c_bool_sap=>true ).
  display_settings->set_list_header( lv_tanim ).
ENDFORM.                    "display_settings
*&---------------------------------------------------------------------*
*&      Form  DETAIL
*&---------------------------------------------------------------------*
FORM detail .
  DATA: ls_alv     TYPE  zsog_mm_010_001.
  CLEAR: gs_scr-1903-detail.
  LOOP AT gs_scr-1903-alv INTO ls_alv.
    IF ls_alv-detail IS NOT INITIAL.
      APPEND LINES OF ls_alv-detail  TO gs_scr-1903-detail.
    ENDIF.
  ENDLOOP.
  IF gs_scr-1903-detail IS NOT INITIAL.
    PERFORM initialize_alv2 USING 'DETAIL'.
    PERFORM display_alv.
  ENDIF.
ENDFORM.                    " DETAIL
*&---------------------------------------------------------------------*
*&      Form  HIDE_PF_STATUS
*&---------------------------------------------------------------------*
FORM hide_pf_status  USING pv_value.
  IF pv_value EQ 'ICON'.
    DATA: lo_functions TYPE REF TO cl_salv_functions,
          lt_func_list TYPE salv_t_ui_func,
          la_func_list LIKE LINE OF lt_func_list,
          found TYPE abap_bool.

    lo_functions = gs_scr-1903-r_alv->get_functions( ).
    lt_func_list = lo_functions->get_functions( ).
    LOOP AT lt_func_list INTO la_func_list.
      IF la_func_list-r_function->get_name( ) = '&INVOICE'.
        found = abap_true.
        la_func_list-r_function->set_visible( ' ' ).
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.                    " HIDE_PF_STATUS
*&---------------------------------------------------------------------*
*&      Form  CREATE_INVOCE
*&---------------------------------------------------------------------*
FORM create_invoce .
  DATA: ls_alv                TYPE  zsog_mm_010_001.
  DATA: ls_detail             TYPE  zsog_mm_010_002.
  DATA: lt_return             TYPE STANDARD TABLE OF bapiret2,
        ls_return             TYPE bapiret2,
        lv_item_no            TYPE bapi_incinv_create_item-invoice_doc_item.
  DATA ls_headerdata          TYPE bapi_incinv_create_header.
  DATA lt_itemdata            TYPE STANDARD TABLE OF bapi_incinv_create_item.
  DATA lt_accountingdata      TYPE STANDARD TABLE OF bapi_incinv_create_account.

  LOOP AT gs_scr-1903-alv INTO ls_alv.
    LOOP AT ls_alv-detail INTO ls_detail.
      IF sy-tabix EQ 1.
        lv_item_no = lv_item_no + 1.
        PERFORM fill_bapi_itemdata TABLES lt_itemdata USING ls_detail lv_item_no.
      ENDIF.
      PERFORM fill_bapi_accountingdata TABLES lt_accountingdata
                                        USING ls_detail lv_item_no.

      ls_headerdata-gross_amount = ls_alv-dgtlms_yan_masraf + ls_headerdata-gross_amount .
    ENDLOOP.
    IF sy-subrc EQ 0.
      ls_headerdata-gross_amount = ls_alv-dgtlms_yan_masraf .
      PERFORM fill_bapi_headerdata  USING ls_detail CHANGING ls_headerdata.
      PERFORM call_bapi TABLES lt_itemdata lt_accountingdata lt_return USING ls_headerdata.
    ENDIF.
    CLEAR: lt_itemdata,lt_accountingdata, ls_headerdata, lt_itemdata, lt_accountingdata.
*    ls_headerdata-gross_amount = ls_alv-dgtlms_yan_masraf + ls_headerdata-gross_amount .
  ENDLOOP.
*  IF sy-subrc EQ 0.
*    PERFORM fill_bapi_headerdata  USING ls_detail CHANGING ls_headerdata.
*    PERFORM call_bapi TABLES lt_itemdata lt_accountingdata lt_return USING ls_headerdata.
*  ENDIF.
  IF lt_return IS NOT INITIAL.
    PERFORM msg_display_error_table TABLES lt_return.
  ENDIF.
*  SET SCREEN 0.
*LEAVE PROGRAM.
ENDFORM.                    " CREATE_INVOCE
*&---------------------------------------------------------------------*
*&      Form  BAPI_ROLLBACK_DESTINATION
*&---------------------------------------------------------------------*
FORM bapi_rollback_destination .
  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK' DESTINATION 'NONE'.
ENDFORM.                    "bapi_rollback_destination

*&---------------------------------------------------------------------*
*&      Form  BAPI_COMMIT_DESTINATION
*&---------------------------------------------------------------------*
FORM bapi_commit_destination .
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' DESTINATION 'NONE'
    EXPORTING
      wait = 'X'.
ENDFORM.                    "bapi_commit_destination
*&---------------------------------------------------------------------*
*&      Form  msg_display_error_table
*&---------------------------------------------------------------------*
FORM msg_display_error_table TABLES pt_return STRUCTURE bapiret2.
  CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
    EXPORTING
      it_message = pt_return[].
ENDFORM.                    "msg_display_error_table
*&---------------------------------------------------------------------*
*&      Form  FILL_BAPI_HEADERDATA
*&---------------------------------------------------------------------*
FORM fill_bapi_headerdata USING ps_detail STRUCTURE zsog_mm_010_002
                       CHANGING ps_headerdata  STRUCTURE bapi_incinv_create_header.

  ps_headerdata-invoice_ind = 'X'.
  ps_headerdata-doc_date    = sy-datum.
  ps_headerdata-pstng_date  = sy-datum.
  ps_headerdata-ref_doc_no  = ps_detail-ebeln.
  ps_headerdata-comp_code   = '2425'.
  ps_headerdata-diff_inv    = s_lifnr-low.
  ps_headerdata-currency    = 'TRY'.
*ps_detail-GROSS_AMOUNT

ENDFORM.                    " FILL_BAPI_HEADERDATA
*&---------------------------------------------------------------------*
*&      Form  FILL_BAPI_ITEMDATA
*&---------------------------------------------------------------------*
FORM fill_bapi_itemdata  TABLES   pt_itemdata STRUCTURE bapi_incinv_create_item
                         USING    ps_detail   STRUCTURE zsog_mm_010_002
                                  pv_item_no  TYPE bapi_incinv_create_item-invoice_doc_item.

  pt_itemdata-invoice_doc_item  = pv_item_no.
  pt_itemdata-po_number         = ps_detail-ebeln.
  pt_itemdata-po_item           = ps_detail-ebelp.
  pt_itemdata-ref_doc           = ps_detail-mblnr.
  pt_itemdata-ref_doc_year      = ps_detail-mjahr.
  pt_itemdata-ref_doc_it        = ps_detail-zeile.
  pt_itemdata-de_cre_ind        = 'X'.
  pt_itemdata-tax_code          = 'V0'.
  pt_itemdata-item_amount       = ps_detail-yan_masraf_great_total.
  pt_itemdata-quantity          = ps_detail-fatura_miktar.
  pt_itemdata-po_unit           = ps_detail-bstme.
  APPEND pt_itemdata.

ENDFORM.                    " FILL_BAPI_ITEMDATA
*&---------------------------------------------------------------------*
*&      Form  FILL_BAPI_ITEMDATA
*&---------------------------------------------------------------------*
FORM fill_bapi_accountingdata  TABLES pt_accountingdata STRUCTURE bapi_incinv_create_account
                                USING ps_detail   STRUCTURE zsog_mm_010_002
                                      pv_item_no  TYPE bapi_incinv_create_item-invoice_doc_item.

  pt_accountingdata-invoice_doc_item  = pv_item_no.
  pt_accountingdata-xunpl             = 'X'.
  pt_accountingdata-tax_code          = 'V0'.
  pt_accountingdata-item_amount       = ps_detail-dgtlms_yan_masraf.
  pt_accountingdata-quantity          = 1.
  pt_accountingdata-po_unit           = ps_detail-meins.
  pt_accountingdata-gl_account        = '7400002002'.
  pt_accountingdata-costcenter        = '1052425004'.
  pt_accountingdata-asset_no          = ps_detail-anln1.
  pt_accountingdata-sub_number        = '0000'.
*  pt_accountingdata-bus_area          = '1100'.
  pt_accountingdata-co_area           = '7000'.
  APPEND pt_accountingdata.

ENDFORM.                    " FILL_BAPI_ITEMDATA
*&---------------------------------------------------------------------*
*&      Form  CALL_BAPI
*&---------------------------------------------------------------------*
FORM call_bapi  TABLES   pt_itemdata       STRUCTURE bapi_incinv_create_item
                         pt_accountingdata STRUCTURE bapi_incinv_create_account
                         pt_return         STRUCTURE bapiret2
                USING    ps_headerdata     STRUCTURE bapi_incinv_create_header.

  DATA: lt_return  TYPE STANDARD TABLE OF bapiret2,
        ls_return  TYPE bapiret2,
        lv_invoicedocnumber TYPE bapi_incinv_fld-inv_doc_no,
        lv_fiscalyear       TYPE bapi_incinv_fld-fisc_year.
  CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE' DESTINATION 'NONE'
    EXPORTING
      headerdata       = ps_headerdata
    IMPORTING
      invoicedocnumber = lv_invoicedocnumber
      fiscalyear       = lv_fiscalyear
    TABLES
      itemdata         = pt_itemdata[]
      accountingdata   = pt_accountingdata[]
      return           = lt_return.
  LOOP AT lt_return INTO ls_return WHERE type CA 'EAX'.
    EXIT.
  ENDLOOP.
  IF sy-subrc EQ 0.
    PERFORM bapi_rollback_destination.
    APPEND LINES OF lt_return TO pt_return[].
    RETURN.
  ELSE.
    PERFORM bapi_commit_destination.
    ls_return-type       = 'S'.
    ls_return-id         = 'ZSG'.
    ls_return-number     = '000'.
    ls_return-message    = lv_invoicedocnumber && | faturası başarıyla yaratıldı!|.
    ls_return-message_v1 = lv_invoicedocnumber && | faturası başarıyla yaratıldı!|.
    ls_return-message_v2 = lv_invoicedocnumber && | faturası başarıyla yaratıldı!|.
    ls_return-message_v3 = lv_invoicedocnumber && | faturası başarıyla yaratıldı!|.
    APPEND ls_return TO lt_return.

  ENDIF.
  IF lt_return IS NOT INITIAL.
    APPEND LINES OF lt_return TO pt_return[].
  ENDIF.

ENDFORM.                    " CALL_BAPI
