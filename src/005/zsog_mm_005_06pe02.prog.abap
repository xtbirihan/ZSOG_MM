*----------------------------------------------------------------------*
*   INCLUDE FM06PE02                                                   *
*----------------------------------------------------------------------*
FORM entry_neu USING ent_retco ent_screen.

  DATA: l_druvo LIKE t166k-druvo,
        l_nast  LIKE nast,
        l_from_memory,
        l_doc   TYPE meein_purchase_doc_print.

  CLEAR ent_retco.
  IF nast-aende EQ space.
    l_druvo = '1'.
  ELSE.
    l_druvo = '2'.
  ENDIF.

  DATA: ls_header TYPE zmm_st_012,
        ls_top    TYPE zmm_st_011,
        lt_top    TYPE TABLE OF zmm_st_011,
        ls_table  TYPE zmm_st_010,
        ls_table2  TYPE zmm_st_010,
        lt_table  TYPE TABLE OF zmm_st_010,
        lt_table2  TYPE TABLE OF zmm_st_010.

  DATA: lv_ebeln     LIKE ekko-ebeln. "nast-objkey
  DATA: lv_text      LIKE ekko-ebeln. "nast-objkey
  DATA: lv_menge_top TYPE ekpo-menge.
  DATA: ls_top_2 LIKE ls_top.
  DATA: lt_top_2 LIKE lt_top.

  FIELD-SYMBOLS: <fs_table> TYPE zmm_st_010.
  FIELD-SYMBOLS: <fs_table2> TYPE zmm_st_010.
  FIELD-SYMBOLS: <fs_top>   TYPE zmm_st_011.

***** ----> Form Data
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
  DATA: lv_hata   TYPE c.
  DATA: lv_subrc  TYPE c.
  DATA: lv_mail_suc TYPE c.
  DATA: lv_sas_text TYPE zmm_st_012-sas_text.

  DATA: lv_menge(20),
        lv_menge2(20).
  DATA : lv_banfn TYPE ekpo-banfn. " added by ilknurnacar 10042020
  CLEAR: ls_header, ls_table, lt_table, lt_top, lv_ebeln, lv_formname,
         lv_hata, lv_menge_top, lv_subrc, lv_sas_text.

  CLEAR: lv_bin_filesize, lv_bin_file, pdf_tab, lv_tddest, lt_otf,
         job_output_options, job_output_info, lv_mail_suc.

  break xosahin.
*  break xmakbas.

  lv_formname = tnapr-fonam.
  lv_ebeln    = nast-objky.

  "Açıklama textini al
  PERFORM f_read_text CHANGING lv_subrc lv_sas_text.
  IF lv_subrc = 0.
    ls_header-sas_text = lv_sas_text.
  ENDIF.

  SELECT SINGLE
   ek~ebeln
   ad~name1 "adrc-name1
   ek~aedat
   ad~name_co
   ad~str_suppl1
   ad~mc_city1
   ad~tel_number
   ad~fax_number
   l1~name1 " lfa1-name1
   l1~stras
   l1~adrnr
   l1~telf1
   l1~telf2
   l1~stcd1
   l1~stcd2
  FROM ekko AS ek
  INNER JOIN ekpo AS ep ON ep~ebeln = ek~ebeln
  INNER JOIN lfa1 AS l1 ON l1~lifnr = ek~lifnr
  INNER JOIN t001 AS t1 ON t1~bukrs = ek~bukrs
  INNER JOIN adrc AS ad ON ad~addrnumber = t1~adrnr
  INTO ls_header
  WHERE ek~ebeln = lv_ebeln.
  IF sy-subrc <> 0 .
    lv_hata = 'X'.
*    ent_retco = 1.
  ENDIF.

  CHECK lv_hata IS INITIAL.
* -------> damlap 08.07.2019 -------> başlangıç
  SELECT
   eb~banfn
   ep~matnr
   mk~maktx
   eb~afnam
   eb~bnfpo
   k1~name1
   k1~stras
   k1~ort01
   et~menge
   z5~olcu_kodu
   z5~mlzme_miktar
  FROM ekko AS ek
  INNER JOIN ekpo AS ep ON ek~ebeln = ep~ebeln
  INNER JOIN eket AS et ON et~ebeln = ep~ebeln
                       AND et~ebelp = ep~ebelp
  INNER JOIN eban AS eb ON eb~banfn = et~banfn
                       AND eb~bnfpo = et~bnfpo
  INNER JOIN kna1 AS k1 ON k1~kunnr = eb~afnam
  LEFT OUTER JOIN makt AS mk ON mk~matnr = ep~matnr
                       AND mk~spras = sy-langu
  INNER JOIN zsog_mm_007_t_05 AS z5 ON  z5~malzeme = ep~matnr
                                    AND z5~olcu_birimi = ep~meins
  INTO CORRESPONDING FIELDS OF TABLE lt_table
  WHERE ek~ebeln = lv_ebeln.
***********************************----> bitiş
**  SELECT
**   eb~banfn
**   eb~matnr
**   et~menge
**   eb~meins
**   eb~afnam
**   k1~name1
**   k1~stras
**   z5~olcu_kodu
**  FROM eban AS eb
**  INNER JOIN eket AS et ON et~banfn = eb~banfn
**                       AND et~bnfpo = eb~bnfpo
**  INNER JOIN ekko AS ek ON ek~ebeln = et~ebeln
**  INNER JOIN ekpo AS ep ON ek~ebeln = ep~ebeln
**  INNER JOIN kna1 AS k1 ON k1~kunnr = eb~afnam
***{   ->>> Added by Prodea Ozan Şahin - 07.08.2019 17:05:42
***  INNER JOIN ekpo AS ep ON ep~ebeln = ek~ebeln
****                       and ep~ebelp = ek~ebelph
**  INNER JOIN zsog_mm_007_t_05 AS z5 ON z5~malzeme = eb~matnr
**                                    AND z5~olcu_birimi = ep~meins
***                                   AND z5~olcu_birimi = eb~meins
***    }     <<<- End of  Added - 07.08.2019 17:05:42
**  INTO CORRESPONDING FIELDS OF TABLE lt_table
**  WHERE ek~ebeln = lv_ebeln.

*DELETE ADJACENT DUPLICATES FROM lt_table COMPARING ALL FIELDS.

  LOOP AT lt_table INTO ls_table.
*    ls_table-menge = ls_table-menge / ls_table-mlzme_miktar.
*    added by ilknurnacar 10042020
*    yurtiçi kargo entegrasyonunda banfn başındaki 0'lar silinerek gönderi oluşturuluyor
*    bu nedenle burada da 0'lar silinmiştir
    CLEAR lv_banfn.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = ls_table-banfn
      IMPORTING
        output = lv_banfn.
* end of added by ilknurnacar 10042020
    CONCATENATE lv_banfn ls_table-bnfpo ls_table-afnam+2(6) INTO ls_table-gonderiid.
    ls_table-barkod = ls_table-gonderiid.

*{   ->>> Added by Prodea Anıl YILDIRIM - 12.09.2019 17:36:53

    lv_menge = ls_table-menge.

    SPLIT lv_menge AT '.' INTO ls_table-menge_sf lv_menge2.
    CONDENSE ls_table-menge_sf.
*    }    <<<- End of  Added - 12.09.2019 17:36:53

    MODIFY lt_table FROM ls_table TRANSPORTING gonderiid barkod menge menge_sf.
    CLEAR: ls_table, lv_menge, lv_menge2.
  ENDLOOP.

  SORT lt_table BY gonderiid.
  MOVE lt_table TO lt_table2.
  DELETE ADJACENT DUPLICATES FROM lt_table2 COMPARING gonderiid.

*  IF sy-subrc <> 0.
*    lv_hata = 'X'.
**    ent_retco = 1.
*  ENDIF.

  CHECK lv_hata IS  INITIAL.


  SORT lt_table BY gonderiid.
  LOOP AT lt_table ASSIGNING <fs_table>.
*    lv_menge_top = lv_menge_top + <fs_table>-menge.

    ON CHANGE OF <fs_table>-gonderiid.
      <fs_table>-new_page_flag = 'X'.
      MODIFY lt_table FROM <fs_table> TRANSPORTING new_page_flag.

*      ls_top-top_menge = lv_menge_top.
      ls_top-gonderiid     = <fs_table>-gonderiid.
*      ls_top-maktx     = <fs_table>-maktx."damlap
      APPEND ls_top TO lt_top.
    ENDON.
  ENDLOOP.


*DATA: w_index TYPE sy-tabix.
*
*  SORT lt_table2 by gonderiId.
*  SORT lt_table by gonderiId.
*
*  LOOP AT lt_table INTO ls_table.
**      LOOP AT lt_table INTO ls_table.
*    READ TABLE lt_table2 INTO ls_table2
*    WITH KEY gonderiId = ls_table-gonderiId
*    BINARY SEARCH.
*    IF sy-subrc EQ 0.
*      w_index = sy-tabix.
*      LOOP AT lt_table2 INTO ls_table2 FROM w_index.
*        IF ls_table-gonderiId <> ls_table2-gonderiId .
*          ls_table-line_flag = 'X'.
*          MODIFY lt_table FROM ls_table TRANSPORTING line_flag.
*        ENDIF.
*      ENDLOOP.
*    ENDIF.
*  ENDLOOP.





***  LOOP AT lt_table ASSIGNING <fs_table>.
***    ON CHANGE OF <fs_table>-gonderiId.
***      <fs_table>-line_flag = 'X'.
***      MODIFY lt_table FROM <fs_table> TRANSPORTING line_flag.
***    ENDON.
***  ENDLOOP.


  " topla üstü bilgileri "damlap kapattım.
*  IF lt_top IS NOT INITIAL.
*    SELECT
*      matnr
*      menge AS top_menge
*      meins AS top_meins
*     FROM ekpo
*     INTO CORRESPONDING FIELDS OF TABLE lt_top_2
*     FOR ALL ENTRIES IN lt_top
*     WHERE ebeln = lv_ebeln
*       AND matnr = lt_top-matnr.
*    IF sy-subrc = 0.
*      SORT lt_top BY matnr.
*      SORT lt_top_2 BY matnr.
*      LOOP AT lt_top ASSIGNING <fs_top>.
*        READ TABLE lt_top_2 INTO ls_top_2
*                  WITH KEY matnr = <fs_top>-matnr BINARY SEARCH.
*        IF sy-subrc = 0.
*          <fs_top>-top_menge = ls_top_2-top_menge.
*          <fs_top>-top_meins = ls_top_2-top_meins.
*          MODIFY lt_top FROM <fs_top> TRANSPORTING top_menge top_meins.
*        ENDIF.
*      ENDLOOP.
*    ENDIF.
*  ENDIF.



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
    lv_hata = 'X'.
*    ent_retco = 1.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

****************************************
  ls_control_param-preview   = 'X'.
  ls_control_param-no_dialog = 'X'.
  ls_control_param-getotf    = 'X'.
  ls_control_param-langu     = sy-langu.

  ls_output_param-tdimmed     = 'X'.
  ls_output_param-tddest     = 'LP01'.

****************************************

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
      gt_top               = lt_top
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
    lv_hata = 'X'.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


  CHECK job_output_info-otfdata[] IS NOT INITIAL.
  lt_otf[] = job_output_info-otfdata[].

  CALL FUNCTION 'CONVERT_OTF'
    EXPORTING
      format                = 'PDF'
*     format                = 'BIN'
    IMPORTING
      bin_file              = lv_bin_file
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

  lt_binary_content[] = cl_document_bcs=>xstring_to_solix( lv_bin_file ).
*

  CHECK lv_hata IS INITIAL.

  "mail gönder
  PERFORM f_ucomm_mail USING lt_binary_content lv_mail_suc.

  CLEAR ls_control_param-getotf.

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
      gt_top               = lt_top
*    IMPORTING
*     DOCUMENT_OUTPUT_INFO =
*      job_output_info      = job_output_info
*      job_output_options   = job_output_options
    EXCEPTIONS
      formatting_error     = 1
      internal_error       = 2
      send_error           = 3
      user_canceled        = 4
      OTHERS               = 5.
  IF sy-subrc <> 0.
*    ent_retco = 2.
    lv_hata = 'X'.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  break xosahin.

*  CALL FUNCTION 'ZME_READ_PO_FOR_PRINTING'
*    EXPORTING
*      ix_nast        = nast
*      ix_screen      = ent_screen
*    IMPORTING
*      ex_retco       = ent_retco
*      ex_nast        = l_nast
*      doc            = l_doc
*    CHANGING
*      cx_druvo       = l_druvo
*      cx_from_memory = l_from_memory.
*  CHECK ent_retco EQ 0.
*
*  CALL FUNCTION 'ZME_PRINT_PO'
*    EXPORTING
*      ix_nast        = l_nast
*      ix_druvo       = l_druvo
*      doc            = l_doc
*      ix_screen      = ent_screen
*      ix_from_memory = l_from_memory
*      ix_toa_dara    = toa_dara
*      ix_arc_params  = arc_params
*      ix_fonam       = tnapr-fonam                          "HW 214570
*    IMPORTING
*      ex_retco       = ent_retco.
ENDFORM.                    "entry_neu
*&---------------------------------------------------------------------*
*&      Form  f_read_text
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->EV_SUBRC   text
*----------------------------------------------------------------------*
FORM f_read_text CHANGING ev_subrc ev_sas_text.
  DATA: lv_client   TYPE sy-mandt,
        lv_id       TYPE thead-tdid,
        lv_language TYPE thead-tdspras,
        lv_name     TYPE thead-tdname,
        lv_object   TYPE thead-tdobject.

  DATA: ls_lines TYPE tline,
        lt_lines TYPE TABLE OF tline.

  CLEAR: lv_client, lv_id,     lv_language,
         lv_name,   lv_object, ls_lines,
         lt_lines.


  lv_client   = sy-mandt.
  lv_id       = 'F01'.
  lv_language = sy-langu.
  lv_name     = nast-objky.
  lv_object   = 'EKKO'.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      client                        = lv_client
      id                            = lv_id
      language                      = lv_language
      name                          = lv_name
      object                        = lv_object
      archive_handle                = 0
*   LOCAL_CAT                     = ' '
* IMPORTING
*   HEADER                        =
*   OLD_LINE_COUNTER              =
    TABLES
      lines                         = lt_lines
   EXCEPTIONS
     id                            = 1
     language                      = 2
     name                          = 3
     not_found                     = 4
     object                        = 5
     reference_check               = 6
     wrong_access_to_archive       = 7
     OTHERS                        = 8
            .
  IF sy-subrc = 0.
    LOOP AT lt_lines INTO ls_lines WHERE tdline IS NOT INITIAL.
      CONCATENATE ev_sas_text ls_lines-tdline INTO ev_sas_text
                                              SEPARATED BY space.
    ENDLOOP.
  ENDIF.
  ev_subrc = sy-subrc.

ENDFORM.                    "f_read_text
*----------------------------------------------------------------------*
*  Send Mail                              *
*----------------------------------------------------------------------*
FORM f_ucomm_mail USING et_binary_content ev_mail_suc.
  CONSTANTS:
*    lc_subject TYPE so_obj_des VALUE 'SOG Satınalma Siparişi',
    lc_raw     TYPE char03 VALUE 'RAW'.

  DATA: lv_subject TYPE so_obj_des.

  DATA:
    lr_send_request  TYPE REF TO cl_bcs,
    lr_sender_mail   TYPE REF TO cl_cam_address_bcs,
    lr_recipient     TYPE REF TO if_recipient_bcs,
    lr_recipient_cc  TYPE REF TO if_recipient_bcs, "** ozans
    lr_document      TYPE REF TO cl_document_bcs,
    lr_bcs_exception TYPE REF TO cx_bcs,
    lv_sent_to_all   TYPE os_boolean,
    lt_text          TYPE bcsy_text,
    ls_text          TYPE LINE OF bcsy_text,
    lv_recipient     TYPE adr6-smtp_addr,
    lv_recipient_cc  TYPE adr6-smtp_addr, "** ozans
    lv_sender        TYPE adr6-smtp_addr ," VALUE 'ozan.sahin@prodea.com.tr',
    lv_objdes        TYPE sood-objdes VALUE 'SOG_KAGIT_SATINALMA',
    ls_address       TYPE bapiaddr3.

  DATA:
    lt_otf            TYPE TABLE OF itcoo,
    lt_binary_content TYPE solix_tab.

*  DATA:  lv_smtp_addr TYPE adr6-smtp_addr VALUE 'ozan.sahin@prodea.com.tr'.
  CONCATENATE 'SOG Kağıt Satınalma' nast-objky
              INTO lv_subject SEPARATED BY space.

  DATA: BEGIN OF ls_adres,
           ebeln LIKE ekko-ebeln,
           name1 LIKE lfa1-name1,
           name2 LIKE lfa1-name2,
           param2 LIKE zsog_mm_005_t_01-param2, "added by xstaskent
         END OF ls_adres,
         lt_adres LIKE TABLE OF ls_adres.



  DATA: lv_ebeln TYPE ekko-ebeln.
  DATA: lv_error TYPE c.

  DATA: ls_zsog_mm_001_c TYPE zsog_mm_001_c. "gönderen mail adresi bakım tablosu

  CLEAR: ls_adres, lv_ebeln, lv_error.
  lv_ebeln = nast-objky.

*{   ->>> Added by Prodea Ozan Şahin - 07.08.2019 16:56:29
  SELECT SINGLE * FROM zsog_mm_001_c INTO ls_zsog_mm_001_c
    WHERE cikti_turu = nast-kschl.
  IF sy-subrc = 0.
    lv_sender = ls_zsog_mm_001_c-mail_adres.
  ELSE.
    lv_error = 'X'.
    MESSAGE s130(zmm) DISPLAY LIKE 'E'.
  ENDIF.

  CHECK lv_error IS INITIAL.
*}     <<<- End of  Added - 07.08.2019 16:56:29

*{   ->>> Commented by Prodea Ozan Şahin - 07.08.2019 16:57:00
*  SELECT SINGLE ek~ebeln l1~name1 l1~name2 a6~smtp_addr
*   FROM ekko AS ek
*    INNER JOIN lfa1 AS l1 ON l1~lifnr = ek~lifnr
*    INNER JOIN adr6 AS a6 ON a6~addrnumber = l1~adrnr
*   INTO ls_adres
*   WHERE ek~ebeln = lv_ebeln.
*  IF ls_adres-smtp_addr IS INITIAL.
*    lv_error = 'X'.
*    MESSAGE s106(zmm) DISPLAY LIKE 'E'.
*  ENDIF.
*}     <<<- End of  Commented - 07.08.2019 16:57:00

*{   ->>> Added by Prodea Ozan Şahin - 07.08.2019 16:57:08
  "geçici olarak yazıldı, bakım tablosuna alınacak.

*{   ->>> Commented by Prodea Sefa Taşkent - 28.08.2019 11:12:49

*  ls_adres-smtp_addr = 'emrahgul@araskargo.com.tr'.
*  APPEND ls_adres TO lt_adres.
*  ls_adres-smtp_addr = 'oguzengin@sube.araskargo.com.tr'.
*  APPEND ls_adres TO lt_adres.
*  ls_adres-smtp_addr = 'velimese@sube.araskargo.com.tr'.
*  APPEND ls_adres TO lt_adres.
*  ls_adres-smtp_addr = 'ebruacar@sube.araskargo.com.tr'.
*  APPEND ls_adres TO lt_adres.

*  }    <<<- End of  Commented  - 28.08.2019 11:12:49

*{   ->>> Added by Prodea Sefa Taşkent - 28.08.2019 11:14:31

  SELECT param2
     FROM zsog_mm_005_t_01
    INTO CORRESPONDING FIELDS OF TABLE lt_adres
    WHERE param1 = 'YURTICI_KARGO'.

*}    <<<- End of  Added - 28.08.2019 11:14:31


*}     <<<- End of  Added - 07.08.2019 16:57:08

  CHECK lv_error IS INITIAL.

  lv_recipient =  ls_adres-param2. " added xstaskent
  lt_binary_content = et_binary_content.
  TRY.
      "Create send request
      lr_send_request = cl_bcs=>create_persistent( ).
      "Email FROM...
      lr_sender_mail  = cl_cam_address_bcs=>create_internet_address( lv_sender ).
      "Set Sender
      lr_send_request->set_sender( lr_sender_mail ).
      "Email TO...

*{   ->>> Commented by Prodea Ozan Şahin - 07.08.2019 16:58:05
*      lr_recipient = cl_cam_address_bcs=>create_internet_address( lv_recipient )."lv_recipient
*
*      "Add recipient to send request
*
*      CALL METHOD lr_send_request->add_recipient
*        EXPORTING
*          i_recipient = lr_recipient
*          i_express   = 'X'.
*}     <<<- End of  Commented - 07.08.2019 16:58:05

*{   ->>> Added by Prodea Ozan Şahin - 07.08.2019 16:58:09
      LOOP AT lt_adres INTO ls_adres WHERE param2 IS NOT INITIAL. "added by xstaskent
        CLEAR lv_recipient.
        lv_recipient = ls_adres-param2. "added by xstaskent
        lr_recipient = cl_cam_address_bcs=>create_internet_address( lv_recipient )."lv_recipient

        "Add recipient to send request

        CALL METHOD lr_send_request->add_recipient
          EXPORTING
            i_recipient = lr_recipient
            i_express   = 'X'.

      ENDLOOP.
*}     <<<- End of  Added - 07.08.2019 16:58:09


*      CLEAR: lv_recipient_cc, lr_recipient_cc.
*      lv_recipient_cc = 'mustafa.akbas@prodea.com.tr'.
*      lr_recipient_cc = cl_cam_address_bcs=>create_internet_address( lv_recipient_cc )."lv_recipient
*      "Add recipient to send request
*      CALL METHOD lr_send_request->add_recipient
*        EXPORTING
*          i_recipient = lr_recipient_cc
*          i_copy      = 'X'.


      CALL METHOD lr_send_request->set_message_subject
        EXPORTING
          ip_subject = 'Satınalma Siparişi'.

      PERFORM f_set_text_mail USING ls_adres CHANGING lt_text .

      lr_document = cl_document_bcs=>create_document(
                      i_type    = 'RAW'
                      i_text    = lt_text
                      i_subject = lv_subject ).
      "Add document to send request
      CALL METHOD lr_send_request->set_document( lr_document ).


      IF lt_binary_content IS NOT INITIAL.

        lv_objdes = lv_objdes && sy-datum && sy-uzeit.

        TRY.
            CALL METHOD lr_document->add_attachment
              EXPORTING
                i_attachment_type     = 'PDF'
                i_attachment_subject  = lv_objdes
                i_attachment_language = sy-langu
                i_att_content_hex     = lt_binary_content[].
          CATCH cx_document_bcs .
        ENDTRY.
      ENDIF.

      CALL METHOD lr_send_request->set_document( lr_document ).

      "Send email
      CALL METHOD lr_send_request->send(
        EXPORTING
          i_with_error_screen = 'X'
        RECEIVING
          result              = lv_sent_to_all ).

      "Commit to send email
*      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*        EXPORTING
*          wait = 'X'.

      COMMIT WORK AND WAIT.
      IF lv_sent_to_all = 'X'.
*        WRITE 'Email gönderildi!'.
        MESSAGE s107(zmm).
        ev_mail_suc = 'X'.
      ENDIF.

    CATCH cx_bcs INTO lr_bcs_exception.
      WRITE: 'Hata!', 'Hata nedeni:', lr_bcs_exception->error_type.
  ENDTRY.


ENDFORM.                    "f_ucomm_mail
*----------------------------------------------------------------------*
*      -->P_IT_MAIL  text
*      <--P_LT_TEXT  text
*----------------------------------------------------------------------*
FORM f_set_text_mail USING es_adres CHANGING et_text TYPE bcsy_text.
  DATA:
    lt_text   TYPE bcsy_text,
    ls_text   LIKE LINE OF lt_text,
    lt_return TYPE TABLE OF bapiret2.

  DATA: BEGIN OF ls_adres,
         ebeln LIKE ekko-ebeln,
         name1 LIKE lfa1-name1,
         name2 LIKE lfa1-name2,
         smtp_addr LIKE adr6-smtp_addr,
       END OF ls_adres.

  DATA: lv_ebeln TYPE ekko-ebeln.
  DATA: lv_error TYPE c.

  CLEAR: ls_adres, lv_ebeln, lv_error.
  lv_ebeln = nast-objky.

  ls_adres = es_adres.

*  SELECT SINGLE ek~ebeln l1~name1 l1~name2 a6~smtp_addr
*   FROM ekko AS ek
*    INNER JOIN lfa1 AS l1 ON l1~lifnr = ek~lifnr
*    INNER JOIN adr6 AS a6 ON a6~addrnumber = l1~adrnr
*   INTO ls_adres
*   WHERE ek~ebeln = lv_ebeln.
*  IF ls_adres-smtp_addr IS INITIAL.
*    lv_error = 'X'.
*    MESSAGE s106(zmm) DISPLAY LIKE 'E'.
*  ENDIF.

*  CHECK lv_error IS INITIAL.

  CLEAR ls_text.
  ls_text-line =  |Sn. | &&
                      ls_adres-name1 &&
*
                  | | &&
                      ls_adres-name2 &&
                  |,|.


  APPEND ls_text TO lt_text. CLEAR ls_text .

  APPEND ls_text TO lt_text. CLEAR ls_text .

  ls_text-line =
                  | Şirketimiz ekte bulunan dosyadaki şekli| &&
                  | saklı kalmak üzere | &&
                      ls_adres-ebeln &&
                  | No'lu Satınalma siparişini oluşturmuştur. | &&
                  | Bayilere dağıtılacak olan malzeme bilgisi | &&
                  | ve bayi adresleri ektedi dosyada yer almaktadır. |.
  APPEND ls_text TO lt_text. CLEAR ls_text .
  ls_text-line =
                  | Bilginize sunarız.|.
  APPEND ls_text TO lt_text. CLEAR ls_text .

  ls_text-line =
                  | Teşekkürler.|.
  APPEND ls_text TO lt_text. CLEAR ls_text .

  et_text[] = lt_text[].
ENDFORM.                    " F_SET_TEXT_MAIL

*eject
*----------------------------------------------------------------------*
* Umlagerungsbestellung,  Hinweis 670912                               *
*----------------------------------------------------------------------*
FORM entry_neu_sto USING ent_retco ent_screen.

  DATA: l_druvo LIKE t166k-druvo,
        l_nast  LIKE nast,
        l_from_memory,
        l_doc   TYPE meein_purchase_doc_print,
        f_sto.                                              "670912


  CLEAR ent_retco.
  IF nast-aende EQ space.
    l_druvo = '1'.
  ELSE.
    l_druvo = '2'.
  ENDIF.

  f_sto = 'X'.                                              "670912

*18.08.05--------------------------------------------------------*
  DATA : BEGIN OF ufuktab OCCURS 0,
          txt(25) VALUE 'tanju colak' TYPE c,
         END OF ufuktab.
*18.08.05--------------------------------------------------------*


  CALL FUNCTION 'ME_READ_PO_FOR_PRINTING'
    EXPORTING
      ix_nast        = nast
      ix_screen      = ent_screen
    IMPORTING
      ex_retco       = ent_retco
      ex_nast        = l_nast
      doc            = l_doc
    CHANGING
      cx_druvo       = l_druvo
      cx_from_memory = l_from_memory.
  CHECK ent_retco EQ 0.
  CALL FUNCTION 'ME_PRINT_PO'
    EXPORTING
      ix_nast        = l_nast
      ix_druvo       = l_druvo
      doc            = l_doc
      ix_screen      = ent_screen
      ix_from_memory = l_from_memory
      ix_toa_dara    = toa_dara
      ix_arc_params  = arc_params
      ix_fonam       = tnapr-fonam                          "HW 214570
      ix_sto         = f_sto                                "670912
    IMPORTING
      ex_retco       = ent_retco.
ENDFORM.                    "entry_neu_sto


*eject
*----------------------------------------------------------------------*
* Mahnung
*----------------------------------------------------------------------*
FORM entry_mahn USING ent_retco ent_screen.

  DATA: l_druvo LIKE t166k-druvo,
        l_nast  LIKE nast,
        l_from_memory,
        l_doc   TYPE meein_purchase_doc_print.

  CLEAR ent_retco.
  l_druvo = '3'.

*18.08.05--------------------------------------------------------*
  DATA : BEGIN OF ufuktab OCCURS 0,
          txt(25) VALUE 'tanju colak' TYPE c,
         END OF ufuktab.
*18.08.05--------------------------------------------------------*

  CALL FUNCTION 'ME_READ_PO_FOR_PRINTING'
    EXPORTING
      ix_nast        = nast
      ix_screen      = ent_screen
    IMPORTING
      ex_retco       = ent_retco
      ex_nast        = l_nast
      doc            = l_doc
    CHANGING
      cx_druvo       = l_druvo
      cx_from_memory = l_from_memory.
  CHECK ent_retco EQ 0.
  CALL FUNCTION 'ME_PRINT_PO'
    EXPORTING
      ix_nast        = l_nast
      ix_druvo       = l_druvo
      doc            = l_doc
      ix_screen      = ent_screen
      ix_from_memory = l_from_memory
      ix_toa_dara    = toa_dara
      ix_arc_params  = arc_params
      ix_fonam       = tnapr-fonam                          "HW 214570
    IMPORTING
      ex_retco       = ent_retco.
ENDFORM.                    "entry_mahn

*eject
*----------------------------------------------------------------------*
* Auftragsbestätigungsmahnung
*----------------------------------------------------------------------*
FORM entry_aufb USING ent_retco ent_screen.

  DATA: l_druvo LIKE t166k-druvo,
        l_nast  LIKE nast,
        l_from_memory,
        l_doc   TYPE meein_purchase_doc_print.

  CLEAR ent_retco.
  l_druvo = '7'.

*18.08.05--------------------------------------------------------*
  DATA : BEGIN OF ufuktab OCCURS 0,
          txt(25) VALUE 'tanju colak' TYPE c,
         END OF ufuktab.
*18.08.05--------------------------------------------------------*


  CALL FUNCTION 'ME_READ_PO_FOR_PRINTING'
    EXPORTING
      ix_nast        = nast
      ix_screen      = ent_screen
    IMPORTING
      ex_retco       = ent_retco
      ex_nast        = l_nast
      doc            = l_doc
    CHANGING
      cx_druvo       = l_druvo
      cx_from_memory = l_from_memory.
  CHECK ent_retco EQ 0.
  CALL FUNCTION 'ME_PRINT_PO'
    EXPORTING
      ix_nast        = l_nast
      ix_druvo       = l_druvo
      doc            = l_doc
      ix_screen      = ent_screen
      ix_from_memory = l_from_memory
      ix_toa_dara    = toa_dara
      ix_arc_params  = arc_params
      ix_fonam       = tnapr-fonam                          "HW 214570
    IMPORTING
      ex_retco       = ent_retco.
ENDFORM.                    "entry_aufb
*eject
*----------------------------------------------------------------------*
* Lieferabrufdruck für Formular MEDRUCK mit Fortschrittszahlen
*----------------------------------------------------------------------*
FORM entry_lphe USING ent_retco ent_screen.

  DATA: l_druvo LIKE t166k-druvo,
        l_nast  LIKE nast,
        l_from_memory,
        l_xfz,
        l_doc   TYPE meein_purchase_doc_print.

  CLEAR ent_retco.
  l_druvo = '9'.
  l_xfz = 'X'.

*18.08.05--------------------------------------------------------*
  DATA : BEGIN OF ufuktab OCCURS 0,
          txt(25) VALUE 'tanju colak' TYPE c,
         END OF ufuktab.
*18.08.05--------------------------------------------------------*

  CALL FUNCTION 'ME_READ_PO_FOR_PRINTING'
    EXPORTING
      ix_nast        = nast
      ix_screen      = ent_screen
    IMPORTING
      ex_retco       = ent_retco
      ex_nast        = l_nast
      doc            = l_doc
    CHANGING
      cx_druvo       = l_druvo
      cx_from_memory = l_from_memory.
  CHECK ent_retco EQ 0.
  CALL FUNCTION 'ME_PRINT_PO'
    EXPORTING
      ix_nast        = l_nast
      ix_druvo       = l_druvo
      doc            = l_doc
      ix_xfz         = l_xfz
      ix_screen      = ent_screen
      ix_from_memory = l_from_memory
      ix_toa_dara    = toa_dara
      ix_arc_params  = arc_params
      ix_fonam       = tnapr-fonam                          "HW 214570
    IMPORTING
      ex_retco       = ent_retco.
ENDFORM.                    "entry_lphe
*eject
*----------------------------------------------------------------------*
* Lieferabrufdruck für Formular MEDRUCK ohne Fortschrittszahlen
*----------------------------------------------------------------------*
FORM entry_lphe_cd USING ent_retco ent_screen.

  DATA: l_druvo LIKE t166k-druvo,
        l_nast  LIKE nast,
        l_from_memory,
        l_doc   TYPE meein_purchase_doc_print.

  CLEAR ent_retco.
  l_druvo = '9'.

*18.08.05--------------------------------------------------------*
  DATA : BEGIN OF ufuktab OCCURS 0,
          txt(25) VALUE 'tanju colak' TYPE c,
         END OF ufuktab.
*18.08.05--------------------------------------------------------*

  CALL FUNCTION 'ME_READ_PO_FOR_PRINTING'
    EXPORTING
      ix_nast        = nast
      ix_screen      = ent_screen
    IMPORTING
      ex_retco       = ent_retco
      ex_nast        = l_nast
      doc            = l_doc
    CHANGING
      cx_druvo       = l_druvo
      cx_from_memory = l_from_memory.
  CHECK ent_retco EQ 0.
  CALL FUNCTION 'ME_PRINT_PO'
    EXPORTING
      ix_nast        = l_nast
      ix_druvo       = l_druvo
      doc            = l_doc
      ix_screen      = ent_screen
      ix_from_memory = l_from_memory
      ix_toa_dara    = toa_dara
      ix_arc_params  = arc_params
      ix_fonam       = tnapr-fonam                          "HW 214570
    IMPORTING
      ex_retco       = ent_retco.
ENDFORM.                    "entry_lphe_cd
*eject
*----------------------------------------------------------------------*
* Feinabrufdruck für Formular MEDRUCK mit Fortschrittszahlen
*----------------------------------------------------------------------*
FORM entry_lpje USING ent_retco ent_screen.

  DATA: l_druvo LIKE t166k-druvo,
        l_nast  LIKE nast,
        l_from_memory,
        l_xfz,
        l_doc   TYPE meein_purchase_doc_print.

  CLEAR ent_retco.
  l_druvo = 'A'.
  l_xfz = 'X'.

*18.08.05--------------------------------------------------------*
  DATA : BEGIN OF ufuktab OCCURS 0,
          txt(25) VALUE 'tanju colak' TYPE c,
         END OF ufuktab.
*18.08.05--------------------------------------------------------*


  CALL FUNCTION 'ME_READ_PO_FOR_PRINTING'
    EXPORTING
      ix_nast        = nast
      ix_screen      = ent_screen
    IMPORTING
      ex_retco       = ent_retco
      ex_nast        = l_nast
      doc            = l_doc
    CHANGING
      cx_druvo       = l_druvo
      cx_from_memory = l_from_memory.
  CHECK ent_retco EQ 0.
  CALL FUNCTION 'ME_PRINT_PO'
    EXPORTING
      ix_nast        = l_nast
      ix_druvo       = l_druvo
      doc            = l_doc
      ix_xfz         = l_xfz
      ix_screen      = ent_screen
      ix_from_memory = l_from_memory
      ix_toa_dara    = toa_dara
      ix_arc_params  = arc_params
      ix_fonam       = tnapr-fonam                          "HW 214570
    IMPORTING
      ex_retco       = ent_retco.
ENDFORM.                    "entry_lpje
*eject
*----------------------------------------------------------------------*
* Feinabrufdruck für Formular MEDRUCK ohne Fortschrittszahlen
*----------------------------------------------------------------------*
FORM entry_lpje_cd USING ent_retco ent_screen.

  DATA: l_druvo LIKE t166k-druvo,
        l_nast  LIKE nast,
        l_from_memory,
        l_doc   TYPE meein_purchase_doc_print.

  CLEAR ent_retco.
  l_druvo = 'A'.

*18.08.05--------------------------------------------------------*
  DATA : BEGIN OF ufuktab OCCURS 0,
          txt(25) VALUE 'tanju colak' TYPE c,
         END OF ufuktab.
*18.08.05--------------------------------------------------------*

  CALL FUNCTION 'ME_READ_PO_FOR_PRINTING'
    EXPORTING
      ix_nast        = nast
      ix_screen      = ent_screen
    IMPORTING
      ex_retco       = ent_retco
      ex_nast        = l_nast
      doc            = l_doc
    CHANGING
      cx_druvo       = l_druvo
      cx_from_memory = l_from_memory.
  CHECK ent_retco EQ 0.
  CALL FUNCTION 'ME_PRINT_PO'
    EXPORTING
      ix_nast        = l_nast
      ix_druvo       = l_druvo
      doc            = l_doc
      ix_screen      = ent_screen
      ix_from_memory = l_from_memory
      ix_toa_dara    = toa_dara
      ix_arc_params  = arc_params
      ix_fonam       = tnapr-fonam                          "HW 214570
    IMPORTING
      ex_retco       = ent_retco.
ENDFORM.                    "entry_lpje_cd
*eject
*----------------------------------------------------------------------*
*   INCLUDE FM06PE02                                                   *
*----------------------------------------------------------------------*
FORM entry_neu_matrix USING ent_retco ent_screen.

  DATA: l_druvo LIKE t166k-druvo,
        l_nast  LIKE nast,
        l_from_memory,
        l_doc   TYPE meein_purchase_doc_print.

  CLEAR ent_retco.
  IF nast-aende EQ space.
    l_druvo = '1'.
  ELSE.
    l_druvo = '2'.
  ENDIF.

*18.08.05--------------------------------------------------------*
  DATA : BEGIN OF ufuktab OCCURS 0,
          txt(25) VALUE 'tanju colak' TYPE c,
         END OF ufuktab.
*18.08.05--------------------------------------------------------*

  CALL FUNCTION 'ME_READ_PO_FOR_PRINTING'
    EXPORTING
      ix_nast        = nast
      ix_screen      = ent_screen
    IMPORTING
      ex_retco       = ent_retco
      ex_nast        = l_nast
      doc            = l_doc
    CHANGING
      cx_druvo       = l_druvo
      cx_from_memory = l_from_memory.
  CHECK ent_retco EQ 0.
  CALL FUNCTION 'ME_PRINT_PO'
    EXPORTING
      ix_nast        = l_nast
      ix_druvo       = l_druvo
      doc            = l_doc
      ix_screen      = ent_screen
      ix_from_memory = l_from_memory
      ix_mflag       = 'X'
      ix_toa_dara    = toa_dara
      ix_arc_params  = arc_params
      ix_fonam       = tnapr-fonam                          "HW 214570
    IMPORTING
      ex_retco       = ent_retco.
ENDFORM.                    "entry_neu_matrix
*eject
*----------------------------------------------------------------------*
* Angebotsabsage
*----------------------------------------------------------------------*
FORM entry_absa USING ent_retco ent_screen.

  DATA: l_druvo LIKE t166k-druvo,
        l_nast  LIKE nast,
        l_from_memory,
        l_doc   TYPE meein_purchase_doc_print.

  l_druvo = '4'.
  CLEAR ent_retco.
*18.08.05--------------------------------------------------------*
  DATA : BEGIN OF ufuktab OCCURS 0,
          txt(25) VALUE 'tanju colak' TYPE c,
         END OF ufuktab.
*18.08.05--------------------------------------------------------*

  CALL FUNCTION 'ME_READ_PO_FOR_PRINTING'
    EXPORTING
      ix_nast        = nast
      ix_screen      = ent_screen
    IMPORTING
      ex_retco       = ent_retco
      ex_nast        = l_nast
      doc            = l_doc
    CHANGING
      cx_druvo       = l_druvo
      cx_from_memory = l_from_memory.
  CHECK ent_retco EQ 0.
  CALL FUNCTION 'ME_PRINT_PO'
    EXPORTING
      ix_nast        = l_nast
      ix_druvo       = l_druvo
      doc            = l_doc
      ix_screen      = ent_screen
      ix_from_memory = l_from_memory
      ix_toa_dara    = toa_dara
      ix_arc_params  = arc_params
      ix_fonam       = tnapr-fonam                          "HW 214570
    IMPORTING
      ex_retco       = ent_retco.
ENDFORM.                    "entry_absa
*eject
*----------------------------------------------------------------------*
* Lieferplaneinteilung
*----------------------------------------------------------------------*
FORM entry_lpet USING ent_retco ent_screen.

  DATA: l_druvo LIKE t166k-druvo,
        l_nast  LIKE nast,
        l_from_memory,
        l_doc   TYPE meein_purchase_doc_print.

  CLEAR ent_retco.
  IF nast-aende EQ space.
    l_druvo = '5'.
  ELSE.
    l_druvo = '8'.
  ENDIF.

*18.08.05--------------------------------------------------------*
  DATA : BEGIN OF ufuktab OCCURS 0,
          txt(25) VALUE 'tanju colak' TYPE c,
         END OF ufuktab.
*18.08.05--------------------------------------------------------*


  CALL FUNCTION 'ME_READ_PO_FOR_PRINTING'
    EXPORTING
      ix_nast        = nast
      ix_screen      = ent_screen
    IMPORTING
      ex_retco       = ent_retco
      ex_nast        = l_nast
      doc            = l_doc
    CHANGING
      cx_druvo       = l_druvo
      cx_from_memory = l_from_memory.
  CHECK ent_retco EQ 0.
  CALL FUNCTION 'ME_PRINT_PO'
    EXPORTING
      ix_nast        = l_nast
      ix_druvo       = l_druvo
      doc            = l_doc
      ix_screen      = ent_screen
      ix_from_memory = l_from_memory
      ix_toa_dara    = toa_dara
      ix_arc_params  = arc_params
      ix_fonam       = tnapr-fonam                          "HW 214570
    IMPORTING
      ex_retco       = ent_retco.
ENDFORM.                    "entry_lpet
*eject
*----------------------------------------------------------------------*
* Lieferplaneinteilung
*----------------------------------------------------------------------*
FORM entry_lpfz USING ent_retco ent_screen.

  DATA: l_druvo LIKE t166k-druvo,
        l_nast  LIKE nast,
        l_from_memory,
        l_doc   TYPE meein_purchase_doc_print.

  CLEAR ent_retco.
  IF nast-aende EQ space.
    l_druvo = '5'.
  ELSE.
    l_druvo = '8'.
  ENDIF.

*18.08.05--------------------------------------------------------*
  DATA : BEGIN OF ufuktab OCCURS 0,
          txt(25) VALUE 'tanju colak' TYPE c,
         END OF ufuktab.
*18.08.05--------------------------------------------------------*


  CALL FUNCTION 'ME_READ_PO_FOR_PRINTING'
    EXPORTING
      ix_nast        = nast
      ix_screen      = ent_screen
    IMPORTING
      ex_retco       = ent_retco
      ex_nast        = l_nast
      doc            = l_doc
    CHANGING
      cx_druvo       = l_druvo
      cx_from_memory = l_from_memory.
  CHECK ent_retco EQ 0.
  CALL FUNCTION 'ME_PRINT_PO'
    EXPORTING
      ix_nast        = l_nast
      ix_druvo       = l_druvo
      doc            = l_doc
      ix_screen      = ent_screen
      ix_from_memory = l_from_memory
      ix_xfz         = 'X'
      ix_toa_dara    = toa_dara
      ix_arc_params  = arc_params
      ix_fonam       = tnapr-fonam                          "HW 214570
    IMPORTING
      ex_retco       = ent_retco.
ENDFORM.                    "entry_lpfz
*eject
*----------------------------------------------------------------------*
* Mahnung
*----------------------------------------------------------------------*
FORM entry_lpma USING ent_retco ent_screen.

  DATA: l_druvo LIKE t166k-druvo,
        l_nast  LIKE nast,
        l_from_memory,
        l_doc   TYPE meein_purchase_doc_print.

  CLEAR ent_retco.
  l_druvo = '6'.

*18.08.05--------------------------------------------------------*
  DATA : BEGIN OF ufuktab OCCURS 0,
          txt(25) VALUE 'tanju colak' TYPE c,
         END OF ufuktab.
*18.08.05--------------------------------------------------------*


  CALL FUNCTION 'ME_READ_PO_FOR_PRINTING'
    EXPORTING
      ix_nast        = nast
      ix_screen      = ent_screen
    IMPORTING
      ex_retco       = ent_retco
      ex_nast        = l_nast
      doc            = l_doc
    CHANGING
      cx_druvo       = l_druvo
      cx_from_memory = l_from_memory.
  CHECK ent_retco EQ 0.
  CALL FUNCTION 'ME_PRINT_PO'
    EXPORTING
      ix_nast        = l_nast
      ix_druvo       = l_druvo
      doc            = l_doc
      ix_screen      = ent_screen
      ix_from_memory = l_from_memory
      ix_toa_dara    = toa_dara
      ix_arc_params  = arc_params
      ix_fonam       = tnapr-fonam                          "HW 214570
    IMPORTING
      ex_retco       = ent_retco.
ENDFORM.                    "entry_lpma
