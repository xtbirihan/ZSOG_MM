*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_011_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*

FORM get_data .


  TYPES: BEGIN OF ltt_data1,
      lifnr TYPE lfa1-lifnr,
      vbeln TYPE lips-vbeln,
      vgbel TYPE lips-vgbel,
      vgpos TYPE lips-vgpos,
      mblnr TYPE mkpf-mblnr,
      zeile TYPE mseg-zeile,
      budat_mkpf TYPE mseg-budat_mkpf,
      ebelp TYPE ekpo-ebelp,
      ebeln TYPE ekpo-ebeln,
    END OF ltt_data1.

  DATA: lt_data1 TYPE TABLE OF ltt_data1,
        ls_data1 TYPE ltt_data1.
  FIELD-SYMBOLS: <fs_data1> TYPE ltt_data1.

  TYPES: BEGIN OF ltt_data,
        lifnr TYPE lfa1-lifnr,
        vbeln TYPE lips-vbeln,
        vgbel TYPE lips-vgbel,
        vgpos TYPE lips-vgpos,
*        mblnr TYPE mkpf-mblnr,
*        zeile TYPE mseg-zeile,
*        budat_mkpf TYPE mseg-budat_mkpf,
*        ebelp TYPE ekpo-ebelp,
*        ebeln TYPE ekpo-ebeln,
      END OF ltt_data.

  DATA: lt_data TYPE TABLE OF ltt_data,
        ls_data TYPE ltt_data.
*  FIELD-SYMBOLS: <fs_data1> TYPE ltt_data.

  TYPES: BEGIN OF ltt_mseg,
   ebeln TYPE ekpo-ebeln,
   ebelp TYPE ekpo-ebelp,
   mblnr TYPE mseg-mblnr,
   zeile TYPE mseg-zeile,
   budat_mkpf TYPE mseg-budat_mkpf,
  END OF ltt_mseg.

  DATA: lt_mseg TYPE TABLE OF ltt_mseg,
        ls_mseg TYPE ltt_mseg.

  TYPES: BEGIN OF ltt_data2,
        ebeln TYPE ekpo-ebeln,
        ebelp TYPE ekpo-ebelp,
        matnr TYPE ekpo-matnr,
        maktx TYPE makt-maktx,
        menge TYPE ekpo-menge,
        meins TYPE ekpo-meins,
        netwr TYPE ekpo-netwr,
        waers TYPE ekko-waers,
        belnr TYPE rseg-belnr,
        buzei TYPE rseg-buzei,
        gjahr TYPE rseg-gjahr,
        budat TYPE rbkp-budat,
        menge1 TYPE rseg-menge,
        bstme TYPE rseg-bstme,
        fatura_tutarı TYPE rseg-wrbtr,
*        waers1 TYPE rbkp-waers,
        xblnr TYPE bsik-xblnr,
      END OF ltt_data2.

  DATA: lt_data2 TYPE TABLE OF ltt_data2,
        ls_data2 TYPE ltt_data2.

  TYPES: BEGIN OF ltt_data3,
    bukrs  TYPE bsik-bukrs,
    lifnr  TYPE bsik-lifnr,
    xblnr  TYPE bsik-xblnr,
    shkzg  TYPE bsik-shkzg,
    masraf_toplam TYPE bsik-dmbtr,
    yan_masraf    TYPE bsik-wrbtr,
    waers  TYPE bsik-waers,
  END OF ltt_data3.

  DATA: lt_data3 TYPE TABLE OF ltt_data3,
        ls_data3 TYPE ltt_data3.

  TYPES: BEGIN OF ltt_masraf_toplam,
       lifnr  TYPE bsik-lifnr ,
       masraf_toplam TYPE bsik-dmbtr,
       END OF ltt_masraf_toplam.

  DATA: lt_masraf_toplam TYPE TABLE OF ltt_masraf_toplam,
        ls_masraf_toplam TYPE ltt_masraf_toplam.

  TYPES: BEGIN OF ltt_collect,
         ebeln  TYPE ekpo-ebeln ,
         fatura_tutarı TYPE rseg-wrbtr,
         END OF ltt_collect.

  DATA: lt_collect TYPE TABLE OF ltt_collect,
        ls_collect TYPE ltt_collect.

  SELECT f~lifnr l~vbeln l~vgbel l~vgpos
        " mf~mblnr m~zeile m~budat_mkpf
  FROM lfa1 AS f
*  INNER JOIN likp AS p ON p~vbeln = f~lifnr
  INNER JOIN lips AS l ON l~vbeln = f~lifnr
*  INNER JOIN mkpf AS mf ON mf~le_vbeln = l~vbeln
*  INNER JOIN mseg AS m ON m~mblnr = mf~mblnr
  INTO TABLE lt_data
  WHERE f~lifnr IN s_lifnr.


  SELECT m~ebeln m~ebelp m~mblnr m~zeile m~budat_mkpf
  FROM mseg AS m
  INTO TABLE lt_mseg
   FOR ALL ENTRIES IN lt_data
  WHERE ebeln = lt_data-vgbel.

  LOOP AT lt_data INTO ls_data.

    READ TABLE lt_mseg INTO ls_mseg WITH KEY ebeln = ls_data-vgbel.

    ls_data1-lifnr = ls_data-lifnr.
    ls_data1-vbeln = ls_data-vbeln.
    ls_data1-vgbel = ls_data-vgbel.
    ls_data1-vgpos = ls_data-vgpos.
    ls_data1-mblnr = ls_mseg-mblnr.
    ls_data1-zeile = ls_mseg-zeile.
    ls_data1-budat_mkpf = ls_mseg-budat_mkpf.
    APPEND ls_data1 TO lt_data1.
    CLEAR : ls_data1, ls_data, ls_mseg.
  ENDLOOP.

  LOOP AT lt_data1 ASSIGNING <fs_data1>.
    <fs_data1>-ebelp = <fs_data1>-vgpos.
  ENDLOOP.
  IF sy-subrc NE 0.
    MESSAGE e129(zmm) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.


  IF lt_data1 IS NOT INITIAL.
    SELECT ep~ebeln ep~ebelp ep~matnr mk~maktx ep~menge ep~meins ep~netwr ek~waers rs~belnr
      rs~buzei rs~gjahr rb~budat rs~menge rs~bstme  rs~wrbtr  AS fatura_tutarı "rb~waers
      ep~ebeln AS xblnr"bs~wrbtr AS masraf_toplam bs~wrbtr AS yan_masraf
      FROM ekpo AS ep
  INNER JOIN ekko AS ek ON ek~ebeln = ep~ebeln
  INNER JOIN rseg AS rs ON rs~ebeln = ep~ebeln
                       AND rs~ebelp = ep~ebelp
  INNER JOIN rbkp AS rb ON rb~belnr = rs~belnr
                       AND rb~gjahr = rs~gjahr
  INNER JOIN makt AS mk ON mk~matnr = ep~matnr
                       AND mk~spras = sy-langu
   INTO TABLE lt_data2
      FOR ALL ENTRIES IN lt_data1
      WHERE ep~ebeln = lt_data1-vgbel
        AND ep~ebelp = lt_data1-ebelp
        AND rs~bukrs = '2425'
        AND rb~stblg EQ space.
  ENDIF.
  IF lt_data2 IS NOT INITIAL.
    SELECT bukrs lifnr xblnr shkzg dmbtr AS masraf_toplam wrbtr AS yan_masraf
      waers
      FROM bsik
      INTO TABLE lt_data3
      FOR ALL ENTRIES IN lt_data2
        WHERE bukrs EQ '2425'
              AND xblnr EQ lt_data2-xblnr
              AND lifnr IN s_lifnr
              AND shkzg EQ 'S'.
  ENDIF.

  LOOP AT lt_data3 INTO ls_data3.
    ls_masraf_toplam-lifnr = ls_data3-lifnr .
    ls_masraf_toplam-masraf_toplam = ls_data3-masraf_toplam .
    COLLECT ls_masraf_toplam INTO lt_masraf_toplam.
    CLEAR ls_masraf_toplam.
  ENDLOOP.

  LOOP AT lt_data2 INTO ls_data2.
    ls_collect-ebeln = ls_data2-ebeln .
    ls_collect-fatura_tutarı = ls_data2-fatura_tutarı .
    COLLECT ls_collect INTO lt_collect.
    CLEAR ls_collect.
  ENDLOOP.

  SORT lt_collect BY ebeln.
  SORT lt_data2 BY ebeln ebelp.
  SORT lt_data3 BY lifnr.

  LOOP AT lt_data1 ASSIGNING <fs_data1>.
    gs_out-vbeln          = <fs_data1>-vbeln.
    gs_out-mblnr          = <fs_data1>-mblnr.
    gs_out-zeile          = <fs_data1>-zeile.
    gs_out-budat_mkpf     = <fs_data1>-budat_mkpf.
    gs_out-vgbel          = <fs_data1>-vgbel.
    gs_out-vgpos          = <fs_data1>-vgpos.

    READ TABLE lt_data2 INTO ls_data2 WITH KEY ebeln  = <fs_data1>-vgbel
                                               ebelp  = <fs_data1>-ebelp
                                               BINARY SEARCH.
    gs_out-matnr          = ls_data2-matnr.
    gs_out-maktx          = ls_data2-maktx.
    gs_out-menge          = ls_data2-menge.
    gs_out-meins          = ls_data2-meins.
    gs_out-netwr          = ls_data2-netwr.
    gs_out-waers          = ls_data2-waers.
    gs_out-belnr          = ls_data2-belnr.
    gs_out-buzei          = ls_data2-buzei.
    gs_out-gjahr          = ls_data2-gjahr.
    gs_out-budat          = ls_data2-budat.
    gs_out-menge_f        = ls_data2-menge1.
    gs_out-bstme          = ls_data2-bstme.
    gs_out-fatura_tutarı  = ls_data2-fatura_tutarı.


    READ TABLE lt_data3 INTO ls_data3 WITH KEY  lifnr = <fs_data1>-lifnr
                                                          BINARY SEARCH.
    gs_out-waers_f       = 'TRY'.

    READ TABLE lt_collect INTO ls_collect WITH KEY ebeln = ls_data2-ebeln BINARY SEARCH.
    READ TABLE lt_masraf_toplam INTO ls_masraf_toplam WITH KEY lifnr = ls_data3-lifnr BINARY SEARCH.
    gs_out-masraf_toplam = ls_masraf_toplam-masraf_toplam .
    gs_out-yan_masraf    = ( ls_masraf_toplam-masraf_toplam * gs_out-fatura_tutarı ) / ls_collect-fatura_tutarı.

    APPEND gs_out TO gt_out.
    CLEAR: ls_data2, gs_out, ls_collect, ls_masraf_toplam .
  ENDLOOP.

ENDFORM.                    " GET_DATA

*&---------------------------------------------------------------------*
*&      Form  fieldcatalog
*&---------------------------------------------------------------------*
FORM fieldcatalog .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZMM_S_ITHALAT_KAPAMA'
      i_client_never_display = 'X'
      i_bypassing_buffer     = 'X'
    CHANGING
      ct_fieldcat            = gt_fieldcat[]
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  CLEAR gs_fieldcat.
  LOOP AT gt_fieldcat INTO gs_fieldcat.
    CASE gs_fieldcat-fieldname.
      WHEN 'VBELN'.
        gs_fieldcat-scrtext_s = 'Dosya No'.
        gs_fieldcat-scrtext_m = 'Dosya No'.
        gs_fieldcat-scrtext_l = 'Dosya No'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'MBLNR'.
        gs_fieldcat-scrtext_s = 'Malzeme B'.
        gs_fieldcat-scrtext_m = 'Malzeme Belgesi'.
        gs_fieldcat-scrtext_l = 'Malzeme Belgesi'.
        gs_fieldcat-colddictxt = 'M'.
*        gs_fieldcat-col_pos   = 2.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'ZEILE'.
        gs_fieldcat-scrtext_s  = 'Mal Belg Kalemi'.
        gs_fieldcat-scrtext_m  = 'Malzeme Bel Kalemi'.
        gs_fieldcat-scrtext_l  = 'Malzeme Belgesi Kalemi'.
        gs_fieldcat-coltext    = 'M'.
        gs_fieldcat-no_out    = 'X'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'BUDAT_MKPF'.
        gs_fieldcat-scrtext_s = 'Belge Tarihi'.
        gs_fieldcat-scrtext_m = 'Belge Tarihi'.
        gs_fieldcat-scrtext_l = 'Belge Tarihi'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'VGBEL'.
        gs_fieldcat-scrtext_s = 'SAS Belgesi'.
        gs_fieldcat-scrtext_m = 'SAS Belgesi'.
        gs_fieldcat-scrtext_l = 'SAS Belgesi'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'VGPOS'.
        gs_fieldcat-scrtext_s = 'SAS Kalem'.
        gs_fieldcat-scrtext_m = 'SAS Kalem'.
        gs_fieldcat-scrtext_l = 'SAS Kalem'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'MATNR'.
        gs_fieldcat-scrtext_s = 'Malzeme'.
        gs_fieldcat-scrtext_m = 'Malzeme'.
        gs_fieldcat-scrtext_l = 'Malzeme'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'MAKTX'.
        gs_fieldcat-scrtext_s = 'Malzeme Tan'.
        gs_fieldcat-scrtext_m = 'Malzeme Tanımı'.
        gs_fieldcat-scrtext_l = 'Malzeme Tanımı'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'MENGE'.
        gs_fieldcat-scrtext_s = 'SAS Miktarı'.
        gs_fieldcat-scrtext_m = 'SAS Miktarı'.
        gs_fieldcat-scrtext_l = 'SAS Miktarı'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'MEINS'.
        gs_fieldcat-scrtext_s = 'SAS Birimi'.
        gs_fieldcat-scrtext_m = 'SAS Birimi'.
        gs_fieldcat-scrtext_l = 'SAS Birimi'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'NETWR'.
        gs_fieldcat-scrtext_s = 'SAS Tutarı'.
        gs_fieldcat-scrtext_m = 'SAS Tutarı'.
        gs_fieldcat-scrtext_l = 'SAS Tutarı'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'WAERS'.
        gs_fieldcat-scrtext_s = 'SAS PB'.
        gs_fieldcat-scrtext_m = 'SAS Para Birimi'.
        gs_fieldcat-scrtext_l = 'SAS Para Birimi'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'BELNR'.
        gs_fieldcat-scrtext_s = 'Fatura Belgesi'.
        gs_fieldcat-scrtext_m = 'Fatura Belgesi'.
        gs_fieldcat-scrtext_l = 'Fatura Belgesi'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'BUZEI'.
        gs_fieldcat-scrtext_s = 'F Belg Ka'.
        gs_fieldcat-scrtext_m = 'Fatura Bel Kalemi'.
        gs_fieldcat-scrtext_l = 'Fatura Belgesi Kalemi'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'GJAHR'.
        gs_fieldcat-scrtext_s = 'F Belg Yılı'.
        gs_fieldcat-scrtext_m = 'Fatura Bel Yılı'.
        gs_fieldcat-scrtext_l = 'Fatura Belgesi Yılı'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'BUDAT'.
        gs_fieldcat-scrtext_s = 'F Tarihi'.
        gs_fieldcat-scrtext_m = 'Fatura Tarihi'.
        gs_fieldcat-scrtext_l = 'Fatura Tarihi'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'MENGE'.
        gs_fieldcat-scrtext_s = 'F Miktarı'.
        gs_fieldcat-scrtext_m = 'Fatura Miktarı'.
        gs_fieldcat-scrtext_l = 'Fatura Miktarı'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'BSTME'.
        gs_fieldcat-scrtext_s = 'F Ölçü Birimi'.
        gs_fieldcat-scrtext_m = 'Fatura Ölçü Birimi'.
        gs_fieldcat-scrtext_l = 'Fatura Miktarı Ölçü Birimi'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'FATURA_TUTARI'.
        gs_fieldcat-scrtext_s = 'F Tutarı'.
        gs_fieldcat-scrtext_m = 'Fatura Tutarı'.
        gs_fieldcat-scrtext_l = 'Fatura Tutarı'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'WAERS'.
        gs_fieldcat-scrtext_s = 'Para Birimi'.
        gs_fieldcat-scrtext_m = 'Para Birimi'.
        gs_fieldcat-scrtext_l = 'Para Birimi'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'MASRAF_TOPLAM'.
        gs_fieldcat-scrtext_s = 'Yan Masraf Toplamı'.
        gs_fieldcat-scrtext_m = 'Yan Masraf Toplamı'.
        gs_fieldcat-scrtext_l = 'Yan Masraf Toplamı'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'YAN_MASRAF'.
        gs_fieldcat-scrtext_s = 'Dağıtılmış Y Masraf'.
        gs_fieldcat-scrtext_m = 'Dağıtılmış Yan Masraf'.
        gs_fieldcat-scrtext_l = 'Dağıtılmış Yan Masraf'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'SHKZG'.
        gs_fieldcat-no_out = 'X'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
    ENDCASE.
  ENDLOOP.

ENDFORM.                    "FIELDCATALOG

*&---------------------------------------------------------------------*
*&      Form  SHOW_DATA
*&---------------------------------------------------------------------*

FORM show_data .
* DATA: lcl_alv_event TYPE REF TO lcl_event_receiver.
  CLEAR: gt_fieldcat, gt_fieldcat[].

  PERFORM fieldcatalog.

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


    CALL METHOD gr_alvgrid->set_table_for_first_display
      EXPORTING
*       I_BUFFER_ACTIVE               =
*       I_BYPASSING_BUFFER            =
*       I_CONSISTENCY_CHECK           =
*       I_STRUCTURE_NAME              =
*       IS_VARIANT                    =
*       I_SAVE                        =
*       I_DEFAULT                     = 'X'
        is_layout                     = gs_layout
      CHANGING
        it_outtab                     = gt_out[]
        it_fieldcatalog               = gt_fieldcat
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.

  ELSE.
    CALL METHOD gr_alvgrid->refresh_table_display.
  ENDIF.

ENDFORM.                    " SHOW_DATA
*&---------------------------------------------------------------------*
*&      Form  SECIM_TESPIT
*&---------------------------------------------------------------------*
*FORM secim_tespit.
*  CLEAR:gv_hata.
*  CALL METHOD gr_alvgrid->get_selected_rows
*    IMPORTING
*      et_row_no = gt_row_no[].
*  IF gt_row_no[] IS INITIAL.
*    MESSAGE 'Lütfen satır seçiniz!' TYPE 'I'.
*    gv_hata = 'X'.
*  ENDIF.
*ENDFORM.                    " SECIM_TESPIT

*&---------------------------------------------------------------------*
*&      Form  KAYDET
*&---------------------------------------------------------------------*

FORM kaydet .
  DATA: ls_alv                TYPE  zsog_mm_010_001.
  DATA: lt_return             TYPE STANDARD TABLE OF bapiret2,
        ls_return             TYPE bapiret2,
        lv_item_no            TYPE bapi_incinv_create_item-invoice_doc_item,
        lv_ref_doc_it            TYPE bapi_incinv_create_item-ref_doc_it.
  DATA ls_headerdata          TYPE bapi_incinv_create_header.
  DATA lt_itemdata            TYPE STANDARD TABLE OF bapi_incinv_create_item WITH HEADER LINE.
  DATA lv_invoicedocnumber TYPE bapi_incinv_fld-inv_doc_no.



  LOOP AT gt_out INTO gs_out.

    lv_item_no = lv_item_no + 1.
    lv_ref_doc_it = lv_ref_doc_it + 1.

    lt_itemdata-invoice_doc_item  = lv_item_no.
    lt_itemdata-po_number         = gs_out-vgbel.
    lt_itemdata-po_item           = gs_out-vgpos.
    lt_itemdata-ref_doc           = gs_out-mblnr.
    lt_itemdata-ref_doc_year      = sy-datum+0(4).
    lt_itemdata-ref_doc_it        = lv_ref_doc_it.
    lt_itemdata-de_cre_ind        = 'X'.
    lt_itemdata-tax_code          = 'V0'.
    lt_itemdata-item_amount       = gs_out-yan_masraf.
    lt_itemdata-quantity          = gs_out-menge.
    lt_itemdata-po_unit           = gs_out-bstme.
    APPEND lt_itemdata.

    CLEAR: lt_itemdata.
  ENDLOOP.

  ls_headerdata-invoice_ind = 'X'.
  ls_headerdata-doc_date    = sy-datum.
  ls_headerdata-pstng_date  = sy-datum.
  ls_headerdata-ref_doc_no  = gs_out-vgbel.
  ls_headerdata-comp_code   = '2425'.
  ls_headerdata-diff_inv    = gs_out-vbeln.
  ls_headerdata-currency    = 'TRY'.
  ls_headerdata-gross_amount = gs_out-masraf_toplam.

  CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE' DESTINATION 'NONE'
    EXPORTING
      headerdata       = ls_headerdata
*    IMPORTING
*      invoicedocnumber = lv_invoicedocnumber
*      fiscalyear       = lv_fiscalyear
    TABLES
      itemdata         = lt_itemdata[]
*      accountingdata   = pt_accountingdata[]
      return           = lt_return.


  LOOP AT lt_return INTO ls_return WHERE type CA 'EAX'.
    EXIT.
  ENDLOOP.
  IF sy-subrc EQ 0.
    PERFORM bapi_rollback_destination.
    APPEND ls_return TO lt_return.
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
    APPEND ls_return TO lt_return.
  ENDIF.

  IF lt_return IS NOT INITIAL.
    PERFORM msg_display_error_table TABLES lt_return.
  ENDIF.


ENDFORM.                    " KAYDET

*&---------------------------------------------------------------------*
*&      Form  bapi_rollback_destination
*&---------------------------------------------------------------------*
FORM bapi_rollback_destination .
  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK' DESTINATION 'NONE'.
ENDFORM.                    "bapi_rollback_destination

*&---------------------------------------------------------------------*
*&      Form  bapi_commit_destination
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
