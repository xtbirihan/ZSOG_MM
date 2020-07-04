*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_017_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F4_OPEN_FILE
*&---------------------------------------------------------------------*

FORM f4_open_file .

  DATA: lt_filetable    TYPE filetable,  "type table
        ls_filetable    TYPE file_table, "structure
        lv_return_code  TYPE i,
        lv_window_title TYPE string.

  lv_window_title = text-001.
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
ENDFORM.                    " F4_OPEN_FILE
*&---------------------------------------------------------------------*
*&      Form  EXCEL_UPLOAD
*&---------------------------------------------------------------------*

FORM excel_upload .

  CLEAR gt_file[].
  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = p_file
      i_begin_col             = '1'    "başlangıç sütunu
      i_begin_row             = '2'    "başlangıc satırı
      i_end_col               = '8'   "bitiş sütunu
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
         CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
          EXPORTING
            date_external            = gs_file-value
          IMPORTING
            date_internal            = gs_file-value
          EXCEPTIONS
            date_external_is_invalid = 1
            OTHERS                   = 2.
          MOVE gs_file-value TO gs_out-tarih.
        WHEN '0002'.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = gs_file-value
            IMPORTING
              output = gs_out-matnr.
          MOVE gs_file-value TO gs_out-matnr.
        WHEN '0003'.
          REPLACE ',' IN gs_file-value WITH '.'.
          REPLACE '%' IN gs_file-value WITH ''.
          IF gs_file-value NA '0123456789'.
          ELSE.
            MOVE gs_file-value TO gs_out-menge.
          ENDIF.
        WHEN '0004'.
          CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
            EXPORTING
              input          = gs_file-value
            IMPORTING
              output         = gs_file-value
            EXCEPTIONS
              unit_not_found = 1
              OTHERS         = 2. "Adet dönüşümü yapan fonksiyon
          MOVE gs_file-value TO gs_out-meins.
        WHEN '0005'.
          MOVE gs_file-value TO gs_out-werks.
        WHEN '0006'.
          MOVE gs_file-value TO gs_out-lgort.
        WHEN '0007'.
          MOVE gs_file-value TO gs_out-charg.
        WHEN '0008'.
          MOVE gs_file-value TO gs_out-kostl.
        WHEN '0009'.
          MOVE gs_file-value TO gs_out-mblnr.
        WHEN '0010'.
          MOVE gs_file-value TO gs_out-mjahr.
      ENDCASE.
      AT END OF row.
        APPEND gs_out TO gt_out.
        CLEAR: gs_out, gs_file.
      ENDAT.
    ENDLOOP.
  ENDIF.
  IF gt_out IS INITIAL.
    gv_error = 'X'.
    MESSAGE s125(zmm) WITH 'Dosya okunamadı' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.                    " EXCEL_UPLOAD

*&---------------------------------------------------------------------*
*&      Form  fieldcatalog
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM fieldcatalog .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
*     I_BUFFER_ACTIVE        =
      i_structure_name       = 'ZMM_S_MASRAF_CIKIS'
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
      WHEN 'MESSAGE'.
        gs_fieldcat-scrtext_s = 'Mesaj'.
        gs_fieldcat-scrtext_m = 'Mesaj Metni'.
        gs_fieldcat-scrtext_l = 'Mesaj Metni'.
        gs_fieldcat-colddictxt = 'M'.
        gs_fieldcat-col_pos   = 14.
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
*&      Form  show_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
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
*&---------------------------------------------------------------------*
*&      Form  excel_download_sample
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
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

  CONCATENATE 'Tarih'
              'Malzeme'
              'Miktar'
              'Birim'
              'Üretim Yeri'
              'Depo Yeri'
              'Parti'
              'Masraf Yeri'
              INTO wa_tab SEPARATED BY w_deli.
  APPEND wa_tab TO it_tab1.

* Downloading header details to first sheet
  PERFORM download_sheet TABLES it_tab1 USING 1 'Header Details'.

  GET PROPERTY OF w_excel 'ActiveSheet' = w_worksheet.

ENDFORM.                    "excel_download_sample

*&---------------------------------------------------------------------*
*&      Form  download_sheet
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TAB      text
*      -->P_SHEET    text
*      -->P_NAME     text
*----------------------------------------------------------------------*
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
*  SET PROPERTY OF w_int 'ColorIndex' = 6.
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

ENDFORM.                    "download_sheet
*&---------------------------------------------------------------------*
*&      Form  EXCEL_CONTROL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM excel_control .
  DATA lv_extention(10) TYPE c.
  CASE sy-ucomm.
    WHEN 'ONLI'.
      IF p_file IS INITIAL.
        MESSAGE e121(zmm) WITH 'Lütfen dosya yolu giriniz.'
        DISPLAY LIKE 'E'.
      ENDIF.
      CALL FUNCTION 'TRINT_FILE_GET_EXTENSION'
        EXPORTING
          filename  = p_file
        IMPORTING
          extension = lv_extention.
      IF lv_extention = 'XLS' OR lv_extention = 'XLSX'.
      ELSE.
        MESSAGE e122(zmm) WITH 'XLS uzantılı bir dosya yükleyiniz'
        DISPLAY LIKE 'E'.
      ENDIF.
  ENDCASE.
ENDFORM.                    " EXCEL_CONTROL
*&---------------------------------------------------------------------*
*&      Form  CONTROLS
*&---------------------------------------------------------------------*

FORM controls .

  DATA: lv_count TYPE i.
  DATA: lv_hata TYPE string.
  DATA: ls_out2 TYPE zmm_s_masraf_cıkıs.

  LOOP AT gt_out INTO gs_out.
    CLEAR: lv_count, lv_hata, gt_hatalar.

*    IF gt_hatalar IS NOT INITIAL.
*      LOOP AT gt_hatalar INTO gs_hatalar.
*        CONCATENATE lv_hata  gs_hatalar INTO lv_hata  SEPARATED BY ' /'.
*      ENDLOOP.
*      gs_out-message = lv_hata.
*      gs_out-color = 'C310'.
*    ENDIF.
*    MODIFY gt_out FROM gs_out TRANSPORTING message color.
*    CLEAR: lv_count, lv_hata, gt_hatalar.
*
*    IF ls_out2-matnr = gs_out-matnr.
*        gs_hatalar-hata = 'Dublicate kayıt giremezsiniz!'.
*      APPEND gs_hatalar TO gt_hatalar.
*      gs_out-kontrol = 'X'.
*      MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
*    ENDIF.
*
* Tarih alan kontrolü
    IF gs_out-tarih IS INITIAL.
      gs_hatalar-hata = 'Tarih alanı boş girilemez!'.
      APPEND gs_hatalar TO gt_hatalar.
      gs_out-kontrol = 'X'.
      MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
    ENDIF.

* Malzeme alan kontrolü
    IF gs_out-matnr IS INITIAL.
      gs_hatalar-hata = 'Malzeme alanı boş girilemez!'.
      APPEND gs_hatalar TO gt_hatalar.
      gs_out-kontrol = 'X'.
      MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
    else.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = gs_out-matnr
        IMPORTING
          output = gs_out-matnr.
      SELECT COUNT(*) FROM mara WHERE matnr = gs_out-matnr.
     IF sy-subrc NE 0.
        gs_hatalar-hata = 'Malzeme Numarası geçersiz!'.
        APPEND gs_hatalar TO gt_hatalar.
        gs_out-kontrol = 'X'.
        MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
      ENDIF.
    ENDIF.

*Miktar alan kontrolü
    IF gs_out-menge IS INITIAL.
      gs_hatalar-hata = 'Miktar alanı boş girilemez!'.
      APPEND gs_hatalar TO gt_hatalar.
      gs_out-kontrol = 'X'.
      MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
    ENDIF.

*Birim alan kontrolü
    IF gs_out-meins IS INITIAL.
          gs_hatalar-hata = 'Birim alanı boş girilemez!'.
      APPEND gs_hatalar TO gt_hatalar.
      gs_out-kontrol = 'X'.
      MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
    ENDIF.

*Üretim Yeri alan kontrolü
    IF gs_out-werks IS INITIAL.
     gs_hatalar-hata = 'Üretim Yeri alanı boş girilemez!'.
      APPEND gs_hatalar TO gt_hatalar.
      gs_out-kontrol = 'X'.
      MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
    ELSE.
     SELECT COUNT(*) FROM mard WHERE werks = gs_out-werks.
      IF sy-subrc NE 0.
        gs_hatalar-hata = 'Üretim Yeri geçersiz!'.
        APPEND gs_hatalar TO gt_hatalar.
        gs_out-kontrol = 'X'.
        MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
      ENDIF.
    ENDIF.

*Depo Yeri alan kontrolü
    IF gs_out-lgort IS INITIAL.
     gs_hatalar-hata = 'Depo Yeri alanı boş girilemez!'.
      APPEND gs_hatalar TO gt_hatalar.
      gs_out-kontrol = 'X'.
      MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
    ELSE.
    SELECT COUNT(*) FROM mard WHERE werks = gs_out-werks
                                and lgort = gs_out-lgort.
      IF sy-subrc NE 0.
        gs_hatalar-hata = 'Depo Yeri geçersiz!'.
        APPEND gs_hatalar TO gt_hatalar.
        gs_out-kontrol = 'X'.
        MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
      ENDIF.
    ENDIF.

*Parti alan kontrolü
    IF gs_out-charg IS INITIAL.
     gs_hatalar-hata = 'Parti alanı boş girilemez!'.
      APPEND gs_hatalar TO gt_hatalar.
      gs_out-kontrol = 'X'.
      MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
    ENDIF.

*Masraf Yeri alan kontrolü
    IF gs_out-kostl IS INITIAL.
      gs_hatalar-hata = 'Masraf Yeri alanı boş girilemez!'.
      APPEND gs_hatalar TO gt_hatalar.
      gs_out-kontrol = 'X'.
      MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
    ELSEIF gs_out-kostl NE 'SG6006'.
      gs_hatalar-hata = 'Masraf Yeri alanı SG6006 dışında girilemez!'.
      APPEND gs_hatalar TO gt_hatalar.
      gs_out-kontrol = 'X'.
      MODIFY gt_out FROM gs_out TRANSPORTING kontrol.
    ENDIF.

* hata mesajları
    IF gt_hatalar IS NOT INITIAL.
      LOOP AT gt_hatalar INTO gs_hatalar.
        CONCATENATE lv_hata  gs_hatalar INTO lv_hata  SEPARATED BY ' /'.
      ENDLOOP.
      CONCATENATE  'Detayları görmek için çift tıklayınız ' lv_hata
  INTO lv_hata SEPARATED BY ' - '.
      gs_out-message = lv_hata.
      gs_out-color = 'C600'.
    ENDIF.

    MODIFY gt_out FROM gs_out TRANSPORTING message color.
    MOVE gs_out-matnr to ls_out2-matnr.
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
*    MESSAGE ID 'ZMM' TYPE 'I' NUMBER ''.
    gv_hata = 'X'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  KAYDET
*&---------------------------------------------------------------------*

FORM kaydet .
  DATA: lv_hata TYPE string.

  DATA: ls_goodsmvt_header      TYPE bapi2017_gm_head_01,
        lt_goodsmvt_item        TYPE TABLE OF  bapi2017_gm_item_create,
        ls_goodsmvt_item        TYPE bapi2017_gm_item_create,
        ls_bapi2017_gm_head_ret TYPE bapi2017_gm_head_ret,
        lv_materialdocument     TYPE bapi2017_gm_head_ret-mat_doc,
        lv_matdocumentyear      TYPE bapi2017_gm_head_ret-doc_year,
        ls_goodsmvt_code        TYPE bapi2017_gm_code,
        lt_return               TYPE  TABLE OF bapiret2,
        ls_return               TYPE  bapiret2.



  ls_goodsmvt_header-pstng_date = sy-datum.
  ls_goodsmvt_header-doc_date   = sy-datum .
  ls_goodsmvt_header-ref_doc_no = 'MAL CIKIS'.
  ls_goodsmvt_code-gm_code      = '03'.

  LOOP AT gt_row_no INTO gs_row_no.
    READ TABLE gt_out INTO gs_out INDEX gs_row_no-row_id.
    IF sy-subrc EQ 0.

       CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = gs_out-matnr
        IMPORTING
          output = gs_out-matnr.

      ls_goodsmvt_item-material      = gs_out-matnr.
      ls_goodsmvt_item-plant         = '2425'.
      ls_goodsmvt_item-stge_loc      = 'D001'.
      ls_goodsmvt_item-batch         = gs_out-charg.
      ls_goodsmvt_item-move_type     = '201'.
      ls_goodsmvt_item-entry_qnt     = gs_out-menge.
      ls_goodsmvt_item-entry_uom     = 'ST'.
      ls_goodsmvt_item-costcenter    = 'SG6006'.
      APPEND ls_goodsmvt_item TO lt_goodsmvt_item.



      CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
        EXPORTING
          goodsmvt_header  = ls_goodsmvt_header
          goodsmvt_code    = ls_goodsmvt_code-gm_code
        IMPORTING
*         goodsmvt_headret = ls_goodsmvt_headret
          materialdocument = lv_materialdocument
          matdocumentyear  = lv_matdocumentyear
        TABLES
          goodsmvt_item    = lt_goodsmvt_item
          return           = lt_return.

      LOOP AT lt_return TRANSPORTING NO FIELDS WHERE type CA 'EAX'.
        EXIT.
      ENDLOOP.
      IF sy-subrc NE 0.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.
        gs_out-color = 'C500'.
        gs_out-mblnr = lv_materialdocument.
        gs_out-mjahr = lv_matdocumentyear.
        gs_out-message = 'Mal çıkışı gerçekleşti.'.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

        LOOP AT lt_return INTO ls_return.
          CONCATENATE lv_hata  ls_return-message INTO lv_hata  SEPARATED BY ' / '.
        ENDLOOP.
        CONCATENATE text-003 lv_hata INTO lv_hata SEPARATED BY ' - '."Detayları görmek için çift tıklayınız
        gs_out-message = lv_hata.
        gs_out-color = 'C600'.
        gs_out-durum = 'E'.
      ENDIF.

      MODIFY gt_out FROM gs_out INDEX gs_row_no-row_id TRANSPORTING message color durum mblnr mjahr.
      CLEAR: lv_hata, ls_return, lt_return, gs_out, ls_goodsmvt_item, lt_goodsmvt_item, lv_materialdocument, lv_matdocumentyear.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " KAYDET

*&---------------------------------------------------------------------*
*&      Form  get_onay
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TEXT     text
*----------------------------------------------------------------------*
FORM get_onay  USING p_text TYPE itex132.

  CLEAR:gv_onay.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      text_question         = p_text
      text_button_1         = 'Evet'
      text_button_2         = 'Hayır'
      default_button        = '1'
      display_cancel_button = 'X'
    IMPORTING
      answer                = gv_onay.

ENDFORM .                    "get_onay
