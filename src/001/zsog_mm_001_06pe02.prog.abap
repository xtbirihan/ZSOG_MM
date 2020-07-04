*----------------------------------------------------------------------*
*   INCLUDE FM06PE02                                                   *
*----------------------------------------------------------------------*
FORM entry_neu USING ent_retco ent_screen.

  DATA: l_druvo LIKE t166k-druvo,
        l_nast  LIKE nast,
        l_from_memory,
        l_doc   TYPE meein_purchase_doc_print.

  CLEAR ent_retco.
*  IF nast-aende EQ space.
*    l_druvo = '1'.
*  ELSE.
*    l_druvo = '2'.
*  ENDIF.

  DATA: ls_header TYPE zmm_st_001,
        ls_footer TYPE zmm_st_003,
        ls_table  TYPE zmm_st_002,
        lt_table  TYPE TABLE OF zmm_st_002.

  DATA: lv_ebeln     LIKE ekko-ebeln. "nast-objkey
  DATA: lv_text      LIKE ekko-ebeln. "nast-objkey
  DATA: lv_menge_top TYPE ekpo-menge.
  DATA: lv_netwr_top TYPE ekpo-netwr.

  DATA: BEGIN OF ls_ekpo,
          ebeln LIKE ekko-ebeln,
          ebelp LIKE ekpo-ebelp,
          txz01 LIKE ekpo-txz01,
        END OF ls_ekpo,
       lt_ekpo LIKE TABLE OF ls_ekpo.

  FIELD-SYMBOLS: <fs_table> TYPE zmm_st_002.

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
  DATA: lt_toplam TYPE TABLE OF zmm_st_002,
        ls_toplam TYPE zmm_st_002.
  FIELD-SYMBOLS : <ls_toplam> TYPE zmm_st_002.
  DATA: lv_hata   TYPE c.
  DATA: lv_subrc  TYPE c.
  DATA: lv_mail_suc TYPE c.
  DATA: lv_sas_text TYPE zmm_st_001-sas_text.
  DATA: lv_menge(20),
       lv_menge1(20).

*{   ->>> Added by Prodea Ozan Şahin - 17.10.2019 17:50:28
  DATA: ls_mm007 TYPE zsog_mm_007_t_05.
  DATA: lt_mm007 TYPE TABLE OF zsog_mm_007_t_05.
*}     <<<- End of  Added - 17.10.2019 17:50:28

  CLEAR: ls_header, ls_table, lt_table, lv_ebeln, lv_formname,
         lv_hata, lv_menge_top, lv_netwr_top, lv_subrc, lv_sas_text,
         lt_ekpo.

  CLEAR: lv_bin_filesize, lv_bin_file, pdf_tab, lv_tddest, lt_otf,
         job_output_options, job_output_info, lv_mail_suc.

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

  SELECT
   ep~matnr
   mk~maktx
   ep~menge
*   ep~meins
   z5~olcu_kodu
   z5~mlzme_miktar
   ep~netpr
   ep~peinh
   ek~waers
   ep~netwr
   ep~ebeln
   ep~ebelp
  FROM ekko AS ek
  INNER JOIN ekpo AS ep ON ek~ebeln = ep~ebeln
*  INNER JOIN eket AS et ON et~ebeln = ep~ebeln
*                       AND et~ebelp = ep~ebelp
*  INNER JOIN eban AS eb ON eb~banfn = et~banfn
*                       AND eb~bnfpo = et~bnfpo
  LEFT OUTER JOIN makt AS mk ON mk~matnr = ep~matnr
                       AND mk~spras = sy-langu
  INNER JOIN zsog_mm_007_t_05 AS z5 ON z5~malzeme = ep~matnr
                                   AND z5~olcu_birimi = ep~meins
  INTO TABLE lt_table
  WHERE ek~ebeln = lv_ebeln.

  IF sy-subrc <> 0.
    lv_hata = 'X'.
*    ent_retco = 1.
  ENDIF.

  LOOP AT lt_table INTO ls_table.
*    ls_table-menge = ls_table-menge / ls_table-mlzme_miktar.
*    MODIFY lt_table FROM ls_table TRANSPORTING menge.
    MOVE-CORRESPONDING ls_table TO ls_toplam.
    CLEAR : ls_toplam-mlzme_miktar, ls_toplam-netpr, ls_toplam-netwr .

*    ls_toplam-matnr = ls_table-matnr.
*    ls_toplam-menge = ls_table-menge.
*    ls_toplam-olcu_kodu = ls_table-olcu_kodu.
*    ls_toplam-netwr = ls_table-netwr.
    COLLECT ls_toplam INTO lt_toplam.
    CLEAR: ls_table.
  ENDLOOP.

  LOOP AT lt_toplam ASSIGNING <ls_toplam>.
*    READ TABLE lt_table INTO ls_table WITH KEY matnr = <ls_toplam>-matnr. "commented by ozans 17.10.2019
    READ TABLE lt_table INTO ls_table WITH KEY matnr = <ls_toplam>-matnr
                                               olcu_kodu = <ls_toplam>-olcu_kodu . "added by ozans 17.10.2019
    <ls_toplam>-netpr = ls_table-netpr.
    <ls_toplam>-netwr = ls_table-netwr.
  ENDLOOP.

  MOVE lt_toplam TO lt_table.

  CHECK lv_hata IS  INITIAL.

  SELECT ebeln ebelp txz01
   FROM ekpo
   INTO TABLE lt_ekpo
   WHERE ebeln = lv_ebeln.

*{   ->>> Added by Prodea Ozan Şahin - 17.10.2019 17:53:51
  SELECT * FROM zsog_mm_007_t_05 INTO  TABLE lt_mm007.
  SORT lt_mm007 BY olcu_kodu.
*}     <<<- End of  Added - 17.10.2019 17:53:51


  LOOP AT lt_table ASSIGNING <fs_table>.
    lv_menge_top = lv_menge_top + <fs_table>-menge.
    lv_netwr_top = lv_netwr_top + <fs_table>-netwr.
    IF <fs_table>-matnr IS INITIAL.
      READ TABLE lt_ekpo INTO ls_ekpo WITH KEY ebeln = <fs_table>-ebeln.
      IF sy-subrc = 0.
        <fs_table>-maktx = ls_ekpo-txz01.
        MODIFY lt_table FROM <fs_table> TRANSPORTING maktx.
      ENDIF.
    ENDIF.
*{   ->>> Added by Prodea Anıl YILDIRIM - 13.09.2019 14:17:02

    lv_menge = <fs_table>-menge.
    SPLIT lv_menge AT '.' INTO <fs_table>-menge_sf lv_menge1.
    CONDENSE <fs_table>-menge_sf.

*    }    <<<- End of  Added - 13.09.2019 14:17:02
*{   ->>> Added by Prodea Ozan Şahin - 17.10.2019 17:54:29
      clear ls_mm007.
      READ TABLE lt_mm007 INTO ls_mm007 with key olcu_kodu = <fs_table>-olcu_kodu
                                                 BINARY SEARCH.
      IF sy-subrc = 0 and ( ls_mm007-olcu_kodu = 'D1' or ls_mm007-olcu_kodu = 'D2').
        <fs_table>-netpr = <fs_table>-netpr * ( ls_mm007-mlzme_miktar / <fs_table>-peinh ).
      ENDIF.
*   }  	 <<<- End of  Added - 17.10.2019 17:54:29
  ENDLOOP.

  ls_footer-menge = lv_menge_top.
  ls_footer-netwr = lv_netwr_top.

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
  ls_control_param-preview    = 'X'.
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
    lv_hata = 'X'.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


  CHECK job_output_info-otfdata[] IS NOT INITIAL.
  lt_otf[] = job_output_info-otfdata[].

  CALL FUNCTION 'CONVERT_OTF'
    EXPORTING
      format                = 'PDF'
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
      gs_footer            = ls_footer
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
    lv_sender        TYPE adr6-smtp_addr, " VALUE 'muhasebe@sansgirisim.com',
    lv_objdes        TYPE sood-objdes VALUE 'SOG_SATINALMA_SIPARISI',
    ls_address       TYPE bapiaddr3.

  DATA:
    lt_otf            TYPE TABLE OF itcoo,
    lt_binary_content TYPE solix_tab.

  DATA: BEGIN OF ls_adres,
         ebeln LIKE ekko-ebeln,
         name1 LIKE lfa1-name1,
         name2 LIKE lfa1-name2,
         smtp_addr LIKE adr6-smtp_addr,
       END OF ls_adres,
       lt_adres LIKE TABLE OF ls_adres.

  DATA: lv_ebeln TYPE ekko-ebeln.
  DATA: lv_error TYPE c.

  DATA: ls_zsog_mm_001_c TYPE zsog_mm_001_c. "gönderen mail adresi bakım tablosu
*  DATA: lt_ZSOG_MM_001_C TYPE TABLE OF ZSOG_MM_001_C.

  SELECT SINGLE * FROM zsog_mm_001_c INTO ls_zsog_mm_001_c
    WHERE cikti_turu = nast-kschl.
  IF sy-subrc = 0.
    lv_sender = ls_zsog_mm_001_c-mail_adres.
  ELSE.
    lv_error = 'X'.
    MESSAGE s130(zmm) DISPLAY LIKE 'E'.
  ENDIF.

  CHECK lv_error IS INITIAL.

*  DATA:  lv_smtp_addr TYPE adr6-smtp_addr VALUE 'ozan.sahin@prodea.com.tr'.
  CONCATENATE 'SOG Satınalma Siparişi' nast-objky
              INTO lv_subject SEPARATED BY space.

  CLEAR: ls_adres, lv_ebeln, lv_error.
  lv_ebeln = nast-objky.

  SELECT ek~ebeln l1~name1 l1~name2 a6~smtp_addr
   FROM ekko AS ek
    INNER JOIN lfa1 AS l1 ON l1~lifnr = ek~lifnr
    INNER JOIN adr6 AS a6 ON a6~addrnumber = l1~adrnr
   INTO TABLE lt_adres
   WHERE ek~ebeln = lv_ebeln.
  IF sy-subrc = 0.
    LOOP AT lt_adres INTO ls_adres WHERE smtp_addr IS NOT INITIAL.
      EXIT.
    ENDLOOP.
    IF sy-subrc <> 0.
      lv_error = 'X'.
      MESSAGE s106(zmm) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.

*  IF ls_adres-smtp_addr IS INITIAL.
*    lv_error = 'X'.
*    MESSAGE s106(zmm) DISPLAY LIKE 'E'.
*  ENDIF.

  CHECK lv_error IS INITIAL.

  lv_recipient =  ls_adres-smtp_addr.
  lt_binary_content = et_binary_content.
  TRY.
      "Create send request
      lr_send_request = cl_bcs=>create_persistent( ).
      "Email FROM...
      lr_sender_mail  = cl_cam_address_bcs=>create_internet_address( lv_sender ).
      "Set Sender
      lr_send_request->set_sender( lr_sender_mail ).
      "Email TO...

      LOOP AT lt_adres INTO ls_adres WHERE smtp_addr IS NOT INITIAL.
        CLEAR lv_recipient.
        lv_recipient = ls_adres-smtp_addr.
        lr_recipient = cl_cam_address_bcs=>create_internet_address( lv_recipient )."lv_recipient

        "Add recipient to send request

        CALL METHOD lr_send_request->add_recipient
          EXPORTING
            i_recipient = lr_recipient
            i_express   = 'X'.

      ENDLOOP.

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
*      COMMIT WORK AND WAIT.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
*        IMPORTING
*          RETURN        =


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
                  | Konuya ilişkin dönüşünüzü rica ediyoruz. | .
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
