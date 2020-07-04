*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_009_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  EXCEL_UPLOAD
*&---------------------------------------------------------------------*
FORM excel_upload .

  TYPES: BEGIN OF tt_maktx,
    matnr TYPE makt-matnr,
    maktx TYPE makt-maktx,
  END OF tt_maktx.


  DATA: lt_maktx TYPE TABLE OF tt_maktx,
        ls_maktx TYPE tt_maktx.

  CLEAR gt_file[].
  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = p_file
      i_begin_col             = '1'    "başlangıç sütunu
      i_begin_row             = '2'    "başlangıc satırı
      i_end_col               = '12'   "bitiş sütunu
      i_end_row               = '100000'  "bitiş satırı ( max satır)
    TABLES
      intern                  = gt_file
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.

  IF sy-subrc = 0.
    "" LOOP içerisinde satır satır döner.
    LOOP AT gt_file INTO gs_file.
      CASE gs_file-col.
        WHEN '0001'.
          MOVE gs_file-value TO gs_out-afnam.
        WHEN '0002'.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = gs_file-value
            IMPORTING
              output = gs_out-matnr.
          MOVE gs_file-value TO gs_out-matnr.
        WHEN '0003'.
          MOVE gs_file-value TO gs_out-matkl.
        WHEN '0004'.
          REPLACE ',' IN gs_file-value WITH '.'.
          REPLACE '%' IN gs_file-value WITH ''.
          IF gs_file-value NA '0123456789'.
          ELSE.
            MOVE gs_file-value TO gs_out-menge.
          ENDIF.
        WHEN '0005'.
          CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
            EXPORTING
              input          = gs_file-value
            IMPORTING
              output         = gs_file-value
            EXCEPTIONS
              unit_not_found = 1
              OTHERS         = 2. "Adet dönüşümü yapan fonksiyon
          MOVE gs_file-value TO gs_out-meins.
        WHEN '0006'.
          REPLACE ',' IN gs_file-value WITH '.'.
          REPLACE '%' IN gs_file-value WITH ''.
          IF gs_file-value NA '0123456789'.
          ELSE.
            MOVE gs_file-value TO gs_out-preis.
          ENDIF.
        WHEN '0007'.
          MOVE gs_file-value TO gs_out-waers.
        WHEN '0008'.
          MOVE gs_file-value TO gs_out-kostl.
        WHEN '0009'.
          MOVE gs_file-value TO gs_out-sakto.

          APPEND gs_out TO gt_out.
          CLEAR gs_out.
      ENDCASE.
    ENDLOOP.


    LOOP AT gt_out INTO gs_out.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = gs_out-matnr
        IMPORTING
          output = gs_out-matnr.

      SELECT matnr maktx FROM makt
        INTO TABLE lt_maktx
        WHERE matnr = gs_out-matnr.

      LOOP AT lt_maktx INTO ls_maktx.
        IF sy-subrc = 0.
          gs_out-maktx = ls_maktx-maktx.
        ENDIF.
      ENDLOOP.
      MODIFY gt_out FROM gs_out TRANSPORTING maktx.
    ENDLOOP.
  ENDIF.

  IF gt_out IS INITIAL.
    gv_error = 'X'.
    MESSAGE s125(zmm) WITH 'Dosya okunamadı' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.                    " EXCEL_UPLOAD

FORM f4_open_file .

  DATA: lt_filetable    TYPE filetable,  "type table
        ls_filetable    TYPE file_table, "structure
        lv_return_code  TYPE i,
        lv_window_title TYPE string.

  lv_window_title = TEXT-001.
  ""dosya seçim ekranını açar
  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title            = lv_window_title ""pencere başlığı
      default_extension       = c_ext_xls ""varsayılan uzantı
      file_filter             = '(*.XLSX)|*.XLSX|' "" filtre
    CHANGING
      file_table              = lt_filetable
      rc                      = lv_return_code
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.

  READ TABLE lt_filetable INTO ls_filetable INDEX 1.
  p_file = ls_filetable-filename.

ENDFORM.

FORM fieldcatalog .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
*     I_BUFFER_ACTIVE        =
      i_structure_name       = 'ZMM_S_SAT_YARATMA'
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
        gs_fieldcat-scrtext_s = 'Bayi No'.
        gs_fieldcat-scrtext_m = 'Bayi No'.
        gs_fieldcat-scrtext_l = 'Bayi No'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'MAKTX'.
        gs_fieldcat-scrtext_s = 'Malzeme T'.
        gs_fieldcat-scrtext_m = 'Malzeme Tanım'.
        gs_fieldcat-scrtext_l = 'Malzeme Tanım'.
        gs_fieldcat-colddictxt = 'M'.
        gs_fieldcat-col_pos   = 2.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'SAT_NO'.
        gs_fieldcat-scrtext_s  = 'SAT Numarası'.
        gs_fieldcat-scrtext_m  = 'SAT Numarası'.
        gs_fieldcat-scrtext_l  = 'SAT Numarası'.
        gs_fieldcat-coltext    = 'SAT Numarası'.
        gs_fieldcat-hotspot = 'X'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'MESSAGE'.
        gs_fieldcat-scrtext_s = 'Mesaj'.
        gs_fieldcat-scrtext_m = 'Mesaj Metni'.
        gs_fieldcat-scrtext_l = 'Mesaj Metni'.
        gs_fieldcat-colddictxt = 'M'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'DURUM'.
        gs_fieldcat-no_out     = 'X'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
      WHEN 'KONTROL'.
        gs_fieldcat-no_out     = 'X'.
        MODIFY gt_fieldcat FROM gs_fieldcat.
    ENDCASE.
  ENDLOOP.

ENDFORM.                    "FIELDCATALOG

*&---------------------------------------------------------------------*
*&      Form  SHOW_DATA
*&---------------------------------------------------------------------*

FORM show_data .
  DATA: lcl_alv_event TYPE REF TO lcl_event_receiver.
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
    gs_layout-info_fname = 'COLOR'.
    gs_layout-sel_mode = 'A'.

    CREATE OBJECT lcl_alv_event.
    CREATE OBJECT go_eventreceiver2.


    SET HANDLER lcl_alv_event->hotspot_click           FOR gr_alvgrid.
    SET HANDLER lcl_alv_event->handle_data_changed     FOR gr_alvgrid.
    SET HANDLER go_eventreceiver2->handle_double_click FOR gr_alvgrid.

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

FORM secim_tespit .

  DATA: lv_kayit TYPE char1.
  CLEAR:gv_hata, gt_row_no, gs_out-color, gs_row_no.

  CALL METHOD gr_alvgrid->get_selected_rows
    IMPORTING
      et_row_no = gt_row_no[].

  IF gt_row_no[] IS INITIAL.
    MESSAGE ID 'ZMM' TYPE 'I' NUMBER '126'.
    gv_hata = 'X'.
  ENDIF.

  CHECK gv_hata EQ ''.

  LOOP AT gt_row_no INTO gs_row_no.
    READ TABLE gt_out INTO gs_out INDEX gs_row_no-row_id TRANSPORTING color.
    IF gs_out-color IS INITIAL.
      lv_kayit = 'X'.
    ENDIF.
  ENDLOOP.

  IF lv_kayit EQ ''.
    MESSAGE ID 'ZMM' TYPE 'I' NUMBER '127'."'Oluşturulacak SAT bulunamadı!' TYPE 'I'.
    gv_hata = 'X'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  EXCEL_DOWNLOAD_SAMPLE
*&---------------------------------------------------------------------*

FORM excel_download_sample .

  REFRESH : it_tab1.

  CREATE OBJECT w_excel 'EXCEL.APPLICATION'.
  SET PROPERTY OF w_excel  'VISIBLE' = 1.

  CALL METHOD OF
      w_excel
      'WORKBOOKS' = w_workbook.

  CALL METHOD OF
      w_workbook
      'ADD'.

  SET PROPERTY OF w_excel 'SheetsInNewWorkbook' = 3.

  ASSIGN w_deli TO <fs> TYPE 'X'.
  w_hex = wl_c09.
  <fs> = w_hex.

  CONCATENATE 'Bayi NO'
              'Malzeme Numarası'
              'Mal Grubu'
              'Miktar'
              'Sas Ölçü Birimi'
              'Net Değer'
              'Para Birimi'
              'Masraf Yeri'
              'Ana Hesap'
              INTO wa_tab SEPARATED BY w_deli.
  APPEND wa_tab TO it_tab1.

* Downloading header details to first sheet
  PERFORM download_sheet TABLES it_tab1 USING 1 'Header Details'.

  GET PROPERTY OF w_excel 'ActiveSheet' = w_worksheet.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_SHEET
*&---------------------------------------------------------------------*

FORM download_sheet TABLES p_tab
                     USING p_sheet TYPE i
                           p_name TYPE string.

  CALL METHOD OF
      w_excel
      'WORKSHEETS' = w_worksheet
    EXPORTING
      #1           = p_sheet.

  CALL METHOD OF
      w_worksheet
      'ACTIVATE'.
  SET PROPERTY OF w_worksheet 'NAME' = p_name.

  CALL METHOD OF
      w_excel
      'Range' = w_range
    EXPORTING
      #1      = 'A1'
      #2      = 'AF1'.

  CALL METHOD OF
      w_range
      'INTERIOR' = w_int.
  SET PROPERTY OF w_int 'ColorIndex' = 6.
  SET PROPERTY OF w_int 'Pattern' = 1.

* Initially unlock all the columns( by default all the columns are
*  LOCKED )
  CALL METHOD OF
      w_excel
      'Columns' = w_columns.
  SET PROPERTY OF w_columns 'Locked' = 0.

* Locking and formatting first column
  CALL METHOD OF
      w_excel
      'Columns' = w_columns
    EXPORTING
      #1        = 1.

  SET PROPERTY OF w_columns  'Locked' = 1.
  SET PROPERTY OF w_columns  'NumberFormat' = '@'.

* Export the contents in the internal table to the clipboard
  CALL METHOD cl_gui_frontend_services=>clipboard_export
    IMPORTING
      data                 = p_tab[]
    CHANGING
      rc                   = w_rc
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.

* Paste the contents in the clipboard to the worksheet
  CALL METHOD OF
      w_worksheet
      'Paste'.

* Autofit the columns according to the contents
  CALL METHOD OF
      w_excel
      'Columns' = w_columns.
  CALL METHOD OF
      w_columns
      'AutoFit'.

  FREE OBJECT: w_columns, w_range.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  KAYDET
*&---------------------------------------------------------------------*

FORM KAYDET .
  CLEAR : gs_out-message, gs_out-color.
  DATA : lt_item        TYPE TABLE  OF bapimereqitemimp,
         lt_itemx       TYPE TABLE OF bapimereqitemx,
         lt_praccount   TYPE TABLE OF BAPIMEREQACCOUNT,
         lt_praccountx  TYPE TABLE OF BAPIMEREQACCOUNTX,
         lt_return      TYPE TABLE OF bapiret2,
         ls_return      TYPE bapiret2,
         ls_item        TYPE bapimereqitemimp,
         ls_itemx       TYPE bapimereqitemx,
         ls_praccount   TYPE BAPIMEREQACCOUNT,
         ls_praccountx  TYPE BAPIMEREQACCOUNTX,
         ls_header      TYPE bapimereqheader,
         ls_headerx     TYPE bapimereqheaderx.
  DATA: lv_pitem TYPE char5.
  DATA lv_dummy LIKE gs_out-message.

* Assigns the header
  ls_header-pr_type      = 'ZSG1'.
  ls_headerx-pr_type     = 'X'.

  CHECK gv_hata IS INITIAL.

  LOOP AT gt_row_no INTO gs_row_no.
    READ TABLE gt_out INTO gs_out INDEX gs_row_no-row_id.
    IF sy-subrc EQ 0.

      lv_pitem = lv_pitem + 10.

*Assigns the item details
      ls_item-preq_item  = lv_pitem."10 la başla
      ls_item-pur_group  = 'SG4'.
      ls_item-preq_name  = gs_out-afnam.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = gs_out-matnr
        IMPORTING
          output = gs_out-matnr.

      ls_item-material   = gs_out-matnr.
      ls_item-plant      = '2425'.
      ls_item-store_loc  = 'D001'.
      ls_item-matl_group = gs_out-matkl.
      ls_item-quantity   = gs_out-menge.
      ls_item-preq_date  = sy-datum.
      ls_item-unit       = gs_out-meins.
      ls_item-preq_price = gs_out-preis.
      ls_item-acctasscat = 'K'.

      APPEND ls_item TO lt_item.

      ls_itemx-preq_item  = lv_pitem.
      ls_itemx-pur_group  = 'X'.
      ls_itemx-preq_name  = 'X'.
      ls_itemx-material   = 'X'.
      ls_itemx-plant      = 'X'.
      ls_itemx-store_loc  = 'X'.
      ls_itemx-matl_group = 'X'.
      ls_itemx-quantity   = 'X'.
      ls_itemx-preq_date  = 'X'.
      ls_itemx-unit       = 'X'.
      ls_itemx-preq_price = 'X'.
      ls_itemx-acctasscat = 'X'.

      APPEND ls_itemx TO lt_itemx.

      ls_praccount-preq_item  = lv_pitem    .
      ls_praccount-serial_no  = '01'        .
      ls_praccount-quantity   = gs_out-menge.
      ls_praccount-gl_account = gs_out-sakto.
      ls_praccount-costcenter = gs_out-kostl.
      ls_praccount-co_area    = '7000'.
      ls_praccount-profit_ctr = 'DUMMY'.
      APPEND ls_praccount TO lt_praccount.

      ls_praccountx-preq_item  = lv_pitem.
      ls_praccountx-serial_no  = '01'.
      ls_praccountx-quantity   = 'X'.
      ls_praccountx-gl_account = 'X'.
      ls_praccountx-costcenter = 'X'.
      ls_praccountx-co_area    = 'X'.
      ls_praccountx-profit_ctr = 'X'.
      APPEND ls_praccountx TO lt_praccountx.
      CLEAR :ls_item, ls_itemx, ls_praccount, ls_praccountx.
    ENDIF.
  ENDLOOP.

  CALL FUNCTION 'BAPI_PR_CREATE'
    EXPORTING
      PRHEADER   = ls_header
      PRHEADERX  = ls_headerx
    TABLES
      RETURN     = lt_return
      PRITEM     = lt_item
      PRITEMX    = lt_itemx
      PRACCOUNT  = lt_praccount
      PRACCOUNTX = lt_praccountx.

  LOOP AT lt_return INTO ls_return WHERE type CA 'EAX'.
    EXIT.
  ENDLOOP.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK' .
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

  ENDIF.
  IF lt_return IS NOT INITIAL.
    CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
      EXPORTING
        it_message = lt_return.
  ENDIF.

  LOOP AT gt_row_no INTO gs_row_no.

    READ TABLE lt_return INTO ls_return WITH KEY type = 'S'
                                                   id = '06'
                                               number = '402'.
    IF sy-subrc EQ 0.
      gs_out-sat_no = ls_return-message_v1.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = gs_out-sat_no
        IMPORTING
          output = gs_out-sat_no.

      IF gs_out-sat_no IS NOT INITIAL.
        gs_out-color = 'C510'.
      ELSE.
        gs_out-color = 'C600'.
      endif.
      MODIFY gt_out FROM gs_out INDEX gs_row_no-row_id TRANSPORTING sat_no color.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " KAYDET

*&---------------------------------------------------------------------*
*&      Form  CONTROLS
*&---------------------------------------------------------------------*

FORM CONTROLS .

  DATA: lv_count TYPE i.
  DATA: lv_hata TYPE string.
  DATA: lv_waers LIKE tcurc-waers.
  DATA: lv_matnr TYPE i.
  DATA: lv_matkl TYPE i.

  DATA: BEGIN OF ls_kunnr,
         kunnr LIKE knb1-kunnr,
         bukrs LIKE knb1-bukrs,
      END OF ls_kunnr,
      lt_kunnr LIKE TABLE OF ls_kunnr.

  DATA: BEGIN OF ls_waers,
         waers LIKE tcurc-waers,
     END OF ls_waers,
     lt_waers LIKE TABLE OF ls_waers.

  DATA: BEGIN OF ls_meins,
     msehi LIKE t006a-msehi,
     END OF ls_meins,
     lt_meins LIKE TABLE OF ls_meins.

  DATA: BEGIN OF ls_matkl,
         matkl LIKE v_t023t-matkl,
         spras LIKE v_t023t-spras,
      END OF ls_matkl,
      lt_matkl LIKE TABLE OF ls_matkl.

  DATA: BEGIN OF ls_kostl,
           kostl LIKE csks-kostl,
           kokrs LIKE csks-kokrs,
           datbi LIKE csks-datbi,
        END OF ls_kostl,
        lt_kostl LIKE TABLE OF ls_kostl.

  DATA: BEGIN OF ls_sakto,
           sakto LIKE ska1-saknr,
           ktopl LIKE ska1-ktopl,
           xloev LIKE ska1-xloev,
        END OF ls_sakto,
        lt_sakto LIKE TABLE OF ls_sakto.


  SELECT kunnr
         bukrs
  FROM knb1
  INTO TABLE lt_kunnr
  WHERE bukrs = '2425'.

  SELECT waers
  FROM tcurt
  INTO TABLE lt_waers
  FOR ALL ENTRIES IN gt_out
  WHERE waers = gt_out-waers
    AND spras EQ sy-langu.

  SELECT msehi
  FROM t006a
  INTO TABLE lt_meins
  FOR ALL ENTRIES IN gt_out
  WHERE msehi = gt_out-meins
    AND spras EQ sy-langu.

  SELECT kostl
     kokrs
     datbi
    FROM csks
    INTO TABLE  lt_kostl
    WHERE kokrs = '7000'
      AND datbi > sy-datum.

  SELECT saknr
         ktopl
         xloev
    FROM ska1
    INTO TABLE lt_sakto
    WHERE ktopl = 'SGHP'
      AND xloev NE 'X'.


  SORT lt_kunnr by kunnr.
  SORT lt_waers by waers.
  SORT lt_meins by msehi.
  SORT lt_kostl by kostl.
  SORT lt_sakto by sakto.

  LOOP AT gt_out INTO gs_out.
    CLEAR: lv_count, lv_hata, gt_hatalar.

    IF gt_hatalar IS NOT INITIAL.
      LOOP AT gt_hatalar INTO gs_hatalar.
        CONCATENATE lv_hata  gs_hatalar INTO lv_hata  SEPARATED BY ' / '.
      ENDLOOP.
      gs_out-message = lv_hata.
      gs_out-color = 'C310'.
      gs_out-durum = 'E'.
    ENDIF.
    MODIFY gt_out FROM gs_out TRANSPORTING message color durum.
    CLEAR: lv_count, lv_hata, gt_hatalar.



* Bayi No alan kontrolü
    IF gs_out-afnam IS INITIAL.
      gs_hatalar-hata = 'Bayi No alanı boş girilemez!'.
      APPEND gs_hatalar TO gt_hatalar.
      gs_out-kontrol = 'X'.
      MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
    else.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = gs_out-afnam
        IMPORTING
          output = gs_out-afnam.

      READ TABLE lt_kunnr TRANSPORTING NO FIELDS
      WITH KEY kunnr = gs_out-afnam BINARY SEARCH.
      IF sy-subrc NE 0.
        gs_hatalar-hata = 'Bayi No geçersiz!'.
        APPEND gs_hatalar TO gt_hatalar.
        gs_out-kontrol = 'X'.
        MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
      ENDIF.
    ENDIF.

*Malzeme No alan kontrolü
    IF gs_out-matnr IS INITIAL.
      gs_hatalar-hata = 'Malzeme Numarası alanı boş girilemez!'.
      APPEND gs_hatalar TO gt_hatalar.
      gs_out-kontrol = 'X'.
      MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
    else.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = gs_out-matnr
        IMPORTING
          output = gs_out-matnr.

      SELECT COUNT(*) FROM mara INTO lv_matnr WHERE matnr = gs_out-matnr.
      IF sy-subrc NE 0.
        gs_hatalar-hata = 'Malzeme Numarası geçersiz!'.
        APPEND gs_hatalar TO gt_hatalar.
        gs_out-kontrol = 'X'.
        MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
      ENDIF.
    ENDIF.
*Mal Grubu alan kontrolü
    IF gs_out-matkl IS INITIAL.
      gs_hatalar-hata = 'Mal Grubu alanı boş girilemez!'.
      APPEND gs_hatalar TO gt_hatalar.
      gs_out-kontrol = 'X'.
      MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
    else.
      SELECT COUNT(*) FROM t023 INTO lv_matkl WHERE matkl = gs_out-matkl.
      IF sy-subrc NE 0.
        gs_hatalar-hata = 'Mal grubu geçersiz!'.
        APPEND gs_hatalar TO gt_hatalar.
        gs_out-kontrol = 'X'.
        MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
      ENDIF.
    ENDIF.

*Adet alan Kontrolü
    IF gs_out-menge IS INITIAL.
      gs_hatalar-hata = 'Miktar alanı boş girilemez!'.
      APPEND gs_hatalar TO gt_hatalar.
      gs_out-kontrol = 'X'.
      MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
    else.

      IF gs_out-menge = 0.
        gs_hatalar-hata = 'Miktar alanı için yanlış giriş!'.
        APPEND gs_hatalar TO gt_hatalar.
        gs_out-kontrol = 'X'.
        MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
      ENDIF.
      IF gs_out-menge < 0.
        gs_hatalar-hata = 'Miktar alanı negatif olamaz!'.
        APPEND gs_hatalar TO gt_hatalar.
        gs_out-kontrol = 'X'.
        MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
      ENDIF.
    ENDIF.

*Sas Ölçü Birimi alan kontrolü
    IF gs_out-meins IS INITIAL.
      gs_hatalar-hata = 'SAS Ölçü Birimi alanı boş girilemez!'.
      APPEND gs_hatalar TO gt_hatalar.
      gs_out-kontrol = 'X'.
      MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
    ELSE.

      READ TABLE lt_meins TRANSPORTING NO FIELDS
      WITH KEY msehi = gs_out-meins BINARY SEARCH.
      IF sy-subrc NE 0.
        gs_hatalar-hata = 'SAS Ölçü Birimi geçersiz!'.
        APPEND gs_hatalar TO gt_hatalar.
        gs_out-kontrol = 'X'.
        MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
      ENDIF.
    ENDIF.

*Net Değer alan kontrolü
    IF gs_out-preis IS INITIAL.
      gs_hatalar-hata = 'Net Değer alanı boş girilemez!'.
      APPEND gs_hatalar TO gt_hatalar.
      gs_out-kontrol = 'X'.
      MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
    ELSE.

      IF gs_out-preis = 0.
        gs_hatalar-hata = 'Net Değer alanı için yanlış giriş!'.
        APPEND gs_hatalar TO gt_hatalar.
        gs_out-kontrol = 'X'.
        MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
      ENDIF.

      IF gs_out-preis < 0.
        gs_hatalar-hata = 'Net Değer alanı negatif olamaz!'.
        APPEND gs_hatalar TO gt_hatalar.
        gs_out-kontrol = 'X'.
        MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
      ENDIF.
    ENDIF.

**"Para bilimi kontrolü
    IF gs_out-waers IS INITIAL.
      gs_hatalar-hata = 'Para Birimi alanı boş girilemez!'.
      APPEND gs_hatalar TO gt_hatalar.
      gs_out-kontrol = 'X'.
      MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
    ELSE.
      READ TABLE lt_waers TRANSPORTING NO FIELDS
      WITH KEY waers = gs_out-waers BINARY SEARCH.
      IF sy-subrc NE 0.
        gs_hatalar-hata = 'Para Birimi geçersiz!'.
        APPEND gs_hatalar TO gt_hatalar.
        gs_out-kontrol = 'X'.
        MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
      ENDIF.
    ENDIF.

*Masraf Yeri alan kontrolü
    IF gs_out-kostl IS INITIAL.
      gs_hatalar-hata = 'Masraf yeri alanı boş girilemez!'.
      APPEND gs_hatalar TO gt_hatalar.
      gs_out-kontrol = 'X'.
      MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
    ELSE.

      READ TABLE lt_kostl TRANSPORTING NO FIELDS
      WITH KEY kostl = gs_out-kostl BINARY SEARCH.
      IF sy-subrc NE 0.
        gs_hatalar-hata = 'Masraf yeri geçersiz!'.
        APPEND gs_hatalar TO gt_hatalar.
        gs_out-kontrol = 'X'.
        MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
      ENDIF.
    ENDIF.

*Ana Hesap alan kontrolü
    IF gs_out-sakto IS INITIAL.
      gs_hatalar-hata = 'Ana Hesap alanı boş girilemez!'.
      APPEND gs_hatalar TO gt_hatalar.
      gs_out-kontrol = 'X'.
      MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
    ELSE.

      READ TABLE lt_sakto TRANSPORTING NO FIELDS
      WITH KEY sakto = gs_out-sakto BINARY SEARCH.
      IF sy-subrc NE 0.
        gs_hatalar-hata = 'Ana hesap numarası geçersiz!'.
        APPEND gs_hatalar TO gt_hatalar.
        gs_out-kontrol = 'X'.
        MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
      ENDIF.
    ENDIF.


* hata mesajları
    IF gt_hatalar IS NOT INITIAL.
      LOOP AT gt_hatalar INTO gs_hatalar.
        CONCATENATE lv_hata  gs_hatalar INTO lv_hata  SEPARATED BY ' / '.
      ENDLOOP.
      CONCATENATE  'Detayları görmek için çift tıklayınız ' lv_hata INTO lv_hata SEPARATED BY ' - '.
      gs_out-message = lv_hata.
      gs_out-color = 'C600'.
      gs_out-durum = 'E'.
    ENDIF.

    MODIFY gt_out FROM gs_out TRANSPORTING message color durum waers  matkl.
    CLEAR: lv_count, lv_hata, gt_hatalar, gs_out.

  ENDLOOP.
ENDFORM.                    " CONTROLS

*&---------------------------------------------------------------------*
*&      Form  F_HANDLE_DATA_CHANGED
*&---------------------------------------------------------------------*
FORM f_handle_data_changed
  CHANGING er_data_changed TYPE REF TO cl_alv_changed_data_protocol.

  DATA: ls_good             TYPE lvc_s_modi, "C
**          lv_value_s_belgesi  LIKE gt_out-s_belgesi,
           lv_value_color_line TYPE char4,
           lv_value_durum      TYPE c,
           lv_error            TYPE c. "C.
**    "C
  LOOP AT er_data_changed->mt_mod_cells INTO ls_good.
    CLEAR lv_error.
*
    CASE ls_good-fieldname.
      WHEN 'COLOR'.
        CLEAR gt_out.
        READ TABLE gt_out INTO gs_out INDEX ls_good-row_id.
        IF sy-subrc = 0.
          "C
          CLEAR lv_value_color_line.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_value_color_line.


          gs_out-color = lv_value_color_line .
*            """ alv giriş kontrol
          IF gs_out-color  IS NOT INITIAL.
            MODIFY gt_out FROM gs_out INDEX ls_good-row_id
                                      TRANSPORTING color .
          ENDIF.
          IF lv_error = 'X'.
            EXIT.
          ENDIF.
        ENDIF.
    ENDCASE.
  ENDLOOP.
  IF lv_error IS NOT INITIAL.
    CALL METHOD er_data_changed->display_protocol.
  ENDIF.

ENDFORM.                    "f_handle_data_changed
*&---------------------------------------------------------------------*
*&      Form  EXCEL_CONTROL
*&---------------------------------------------------------------------*

FORM EXCEL_CONTROL .
  DATA lv_extention(10) TYPE c.
  CASE sy-ucomm.
    WHEN 'ONLI'.
      IF p_file IS INITIAL.
        MESSAGE e121(zmm) WITH 'Lütfen dosya yolu giriniz.' DISPLAY LIKE 'E'.
      ENDIF.
      CALL FUNCTION 'TRINT_FILE_GET_EXTENSION'
        EXPORTING
          filename  = p_file
        IMPORTING
          extension = lv_extention.
      IF lv_extention = 'XLS' OR lv_extention = 'XLSX'.
      ELSE.
        MESSAGE e122(zmm) WITH 'XLS uzantılı bir dosya yükleyiniz' DISPLAY LIKE 'E'.
      ENDIF.
  ENDCASE.
ENDFORM.                    " EXCEL_CONTROL
