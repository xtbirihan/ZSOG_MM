*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_019_CREATESHIPMENT_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*----------------------------------------------------------------------*
FORM get_data .
  CONSTANTS:lc_bukrs TYPE bukrs VALUE '2425',
            lc_bsart TYPE bsart VALUE 'ZSG1'.
  TYPES: BEGIN OF ltt_data ,
          ebeln         TYPE zsog_mm_019_yi_cargo_01-ebeln       ,
          ebelp         TYPE zsog_mm_019_yi_cargo_01-ebelp       ,
          banfn         TYPE zsog_mm_019_yi_cargo_01-banfn       ,
          bnfpo         TYPE zsog_mm_019_yi_cargo_01-bnfpo       ,
          matnr         TYPE zsog_mm_019_yi_cargo_01-matnr       ,
          maktx         TYPE zsog_mm_019_yi_cargo_01-maktx       ,
          menge         TYPE zsog_mm_019_yi_cargo_01-menge       ,
          meins         TYPE zsog_mm_019_yi_cargo_01-meins       ,
          werks         TYPE zsog_mm_019_yi_cargo_01-werks       ,
          name1         TYPE zsog_mm_019_yi_cargo_01-name1       ,
          afnam         TYPE zsog_mm_019_yi_cargo_01-afnam       ,
          afnam_name1   TYPE zsog_mm_019_yi_cargo_01-afnam_name1 ,
          adrnr         TYPE kna1-adrnr                          ,
          ort02         TYPE kna1-ort02                          ,
          bedat         TYPE zsog_mm_019_yi_cargo_01-bedat       ,
          sil(1),
  END OF ltt_data.

  DATA: lt_data TYPE STANDARD TABLE OF ltt_data ,
        ls_data TYPE ltt_data.
  TYPES: BEGIN OF ltt_adrc ,
          addrnumber    TYPE adrc-addrnumber                  ,
          name_co       TYPE zsog_mm_019_yi_cargo_01-name_co     ,
          street        TYPE zsog_mm_019_yi_cargo_01-street      ,
          house_num1    TYPE zsog_mm_019_yi_cargo_01-house_num1  ,
          city2         TYPE zsog_mm_019_yi_cargo_01-city2       ,
          city1         TYPE zsog_mm_019_yi_cargo_01-city1       ,
          region        TYPE adrc-region,
          langu         TYPE adrc-langu,
          country       TYPE adrc-country,
         END OF ltt_adrc.

  DATA: ls_alv TYPE zsog_mm_019_yi_cargo_01.
  DATA: lt_adrc  TYPE HASHED TABLE OF ltt_adrc WITH UNIQUE KEY addrnumber,
        ls_adrc  TYPE ltt_adrc.
  DATA: lt_t005u TYPE SORTED TABLE OF t005u WITH UNIQUE KEY spras land1 bland,
        ls_t005u TYPE t005u.

  TYPES:  BEGIN OF ltt_adr2,
          addrnumber TYPE adr2-addrnumber,
          consnumber TYPE adr2-consnumber,
          telnr_long TYPE adr2-telnr_long,
          END OF ltt_adr2.
  DATA: lt_adr2 TYPE HASHED TABLE OF ltt_adr2 WITH UNIQUE KEY addrnumber consnumber,
        ls_adr2 TYPE ltt_adr2.

  DATA: lv_proxy     TYPE REF TO zykco_shipping_order_dispatche.
  DATA: lt_alv       TYPE TABLE OF zsog_mm_019_yi_cargo_01.
  DATA: lt_messages  TYPE bapiret2_t,
        lv_error     TYPE c.

  DATA: lt_log     TYPE TABLE OF zsog_mm_019_t_02,
        ls_log     TYPE zsog_mm_019_t_02,
        lt_address TYPE TABLE OF zsog_fi_001_t_01,
        ls_address TYPE zsog_fi_001_t_01.

  SELECT  k~ebeln
          p~ebelp
          e~banfn
          e~bnfpo
          b~matnr
          t~maktx
          b~menge
          b~meins
          p~werks
          w~name1
          b~afnam
          a~name1 AS afnam_name1
          a~adrnr
          a~ort02
          k~bedat
    FROM ekko AS k
    INNER JOIN ekpo AS p ON k~ebeln = p~ebeln
    INNER JOIN eket AS e ON p~ebeln = e~ebeln
                        AND p~ebelp = e~ebelp
    INNER JOIN eban AS b ON b~banfn = e~banfn
                        AND b~bnfpo = e~bnfpo
    INNER JOIN makt AS t ON t~matnr = b~matnr
                        AND t~spras = sy-langu
    INNER JOIN t001w AS w ON w~werks = p~werks
    INNER JOIN kna1  AS a ON a~kunnr = b~afnam
    INTO TABLE lt_data
    WHERE k~bedat IN s_bedat
      AND k~lifnr IN s_lifnr
      AND k~ebeln IN s_ebeln
      AND k~bukrs = lc_bukrs
      AND k~bsart = lc_bsart
      AND p~loekz = ''
      AND b~loekz = ''.
  IF sy-subrc NE 0.
    MESSAGE i013(zsg) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  IF lt_data IS NOT INITIAL.
    SELECT * FROM zsog_mm_019_t_02 INTO TABLE lt_log
                                   FOR ALL ENTRIES IN lt_data
                                   WHERE ebeln = lt_data-ebeln
                                     AND ebelp = lt_data-ebelp
                                     AND banfn = lt_data-banfn
                                     AND bnfpo = lt_data-bnfpo
                                     AND err_code = 0.


  ENDIF.
  SORT lt_data BY ebeln ebelp banfn bnfpo.
  LOOP AT lt_log INTO ls_log.
    READ TABLE lt_data INTO ls_data WITH KEY ebeln = ls_log-ebeln
                                             ebelp = ls_log-ebelp
                                             banfn = ls_log-banfn
                                             bnfpo = ls_log-bnfpo  BINARY SEARCH.
    IF sy-subrc EQ 0.
      ls_data-sil = 'X'.
      MODIFY lt_data FROM ls_data INDEX sy-tabix TRANSPORTING sil.
    ENDIF.
    CLEAR: ls_data.
  ENDLOOP.
  DELETE lt_data WHERE sil EQ 'X'.
  IF lt_data IS INITIAL.
    MESSAGE i013(zsg) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.
  IF lt_data IS NOT INITIAL.
*    SELECT addrnumber
*           name_co
*           street
*           house_num1
*           city2
*           city1
*           region
*           langu
*           country
*           FROM adrc
*           INTO TABLE lt_adrc
*           FOR ALL ENTRIES IN lt_data
*           WHERE addrnumber = lt_data-adrnr.

    SELECT * FROM zsog_fi_001_t_01 INTO TABLE lt_address
                                   FOR ALL ENTRIES IN lt_data
                                   WHERE retail_location_id = lt_data-afnam+0(10).
    SORT lt_address BY retail_location_id.
  ENDIF.

*  IF lt_adrc IS NOT INITIAL.
*    SELECT * FROM t005u INTO TABLE lt_t005u
*             FOR ALL ENTRIES IN lt_adrc
*             WHERE bland = lt_adrc-region
*               AND spras = lt_adrc-langu
*               AND land1 = lt_adrc-country.
*
*    SELECT addrnumber
*           consnumber
*           telnr_long
*           FROM adr2
*           INTO TABLE lt_adr2
*           FOR ALL ENTRIES IN lt_adrc
*           WHERE addrnumber = lt_adrc-addrnumber
*             AND ( consnumber EQ 001 OR  consnumber EQ 002 ).
*  ENDIF.

  LOOP AT lt_data INTO ls_data.
    MOVE-CORRESPONDING ls_data TO ls_alv.
*    READ TABLE lt_adrc INTO ls_adrc WITH TABLE KEY addrnumber = ls_data-adrnr .
*    ls_alv-name_co       = ls_adrc-name_co     .
*    ls_alv-street        = ls_adrc-street      .
*    ls_alv-house_num1    = ls_adrc-house_num1  .
*    ls_alv-city2         = ls_adrc-city2       .
*    ls_alv-city1         = ls_adrc-city1       .

*    READ TABLE lt_t005u INTO ls_t005u WITH KEY bland = ls_adrc-region
*                                               spras = ls_adrc-langu
*                                               land1 = ls_adrc-country.
*    ls_alv-bezei = ls_t005u-bezei.

*    READ TABLE lt_adr2 INTO ls_adr2 WITH TABLE KEY addrnumber = ls_data-adrnr
*                                                   consnumber = 001.
*    ls_alv-telnr_long = ls_adr2-telnr_long+2(11).
*    CLEAR: ls_adr2.
*    READ TABLE lt_adr2 INTO ls_adr2 WITH TABLE KEY addrnumber = ls_data-adrnr
*                                                   consnumber = 002.
*    ls_alv-telnr_long2 = ls_adr2-telnr_long+2(11).
    READ TABLE lt_address INTO ls_address
                          WITH KEY retail_location_id = ls_data-afnam+0(10).
    IF sy-subrc = 0.
      ls_alv-name_co       = ls_address-street          .
      ls_alv-street        = ls_address-delivery_street .
      ls_alv-house_num1    = ls_address-delivery_house_number.
      ls_alv-city1         = ls_address-delivery_city   .
      ls_alv-telnr_long    = ls_address-mobile_phone    .
      ls_alv-telnr_long2   = ls_address-phone1          .
      ls_alv-city2         = ls_data-ort02              .
    ENDIF.

    APPEND ls_alv TO gt_data.
    CLEAR: ls_alv, ls_adrc, ls_t005u, ls_adr2.
  ENDLOOP.
  SORT gt_data BY ebeln ebelp.

  IF sy-tcode EQ 'ME9F'.
    sy-batch = 'X'.
  ENDIF.


  IF sy-batch EQ 'X'.
    CLEAR: lt_alv,lv_proxy,lv_error.

    CHECK gt_data IS NOT INITIAL.
    lt_alv = gt_data.
    PERFORM get_proxy CHANGING lv_proxy
                               lv_error
                               lt_messages.

    CHECK lv_error IS INITIAL.
    CLEAR lt_messages.
    PERFORM set_and_send_orders TABLES   lt_alv
                                USING    lv_proxy
                                CHANGING lt_messages.
  ELSE.
    CALL SCREEN 0100.
  ENDIF.

ENDFORM.                    "get_data
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*----------------------------------------------------------------------*
FORM display_alv .
  IF gr_alvgrid IS INITIAL.

    CREATE OBJECT gr_custom_container
      EXPORTING
        container_name              = gr_custom_control_name
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
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    PERFORM prepare_field_catalog.
    PERFORM prepare_layout.

    CREATE OBJECT gr_event_receiver .
    SET HANDLER   gr_event_receiver->handle_user_command     FOR gr_alvgrid.
    SET HANDLER   gr_event_receiver->handle_toolbar          FOR gr_alvgrid.

    CALL METHOD gr_alvgrid->set_table_for_first_display
      EXPORTING
        i_buffer_active               = 'X'
        i_structure_name              = 'ZSOG_MM_019_YI_CARGO_01'
        is_layout                     = gs_layout
        it_toolbar_excluding          = gt_exclude[]
      CHANGING
        it_outtab                     = gt_data
        it_fieldcatalog               = gt_fieldcat
        it_sort                       = gt_sort
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
*   Implement suitable error handling here
    ENDIF.

  ELSEIF gr_alvgrid IS NOT INITIAL.
    CALL METHOD gr_alvgrid->refresh_table_display.
  ENDIF.

ENDFORM.                    "display_alv
*&---------------------------------------------------------------------*
*&      Form  PREPARE_FIELD_CATALOG
*----------------------------------------------------------------------*
FORM prepare_field_catalog .
  FIELD-SYMBOLS :<fs_fieldcat> TYPE lvc_s_fcat.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_buffer_active        = 'X'
      i_structure_name       = 'ZSOG_MM_019_YI_CARGO_01'
      i_client_never_display = 'X'
      i_bypassing_buffer     = 'X'
      i_internal_tabname     = 'GT_DATA'
    CHANGING
      ct_fieldcat            = gt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  LOOP AT gt_fieldcat ASSIGNING <fs_fieldcat>.
    CASE <fs_fieldcat>-fieldname.
      WHEN 'ROW_COLOR'.
*       gs_fieldcat-reptext   = 'Faturalama Belgesi'.
*        gs_fieldcat-scrtext_l = 'Faturalama Belgesi'.
*        gs_fieldcat-scrtext_s = 'Fat.Bel.'.
*        gs_fieldcat-scrtext_m = 'Fat.Belgesi'.
        <fs_fieldcat>-no_out     = 'X'.
      WHEN 'SIL'.
        <fs_fieldcat>-no_out     = 'X'.
    ENDCASE.
  ENDLOOP.

ENDFORM.                    "prepare_field_catalog

*&---------------------------------------------------------------------*
*&      Form  prepare_layout
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM prepare_layout.
  gs_layout-zebra = 'X'.
  gs_layout-cwidth_opt = 'X'.
  gs_layout-info_fname =  'ROW_COLOR'.
*  gs_layout-grid_title = 'ZZZ Raporu'.
  gs_layout-sel_mode = 'A'.
ENDFORM.                    "prepare_layout
*&---------------------------------------------------------------------*
*&      Form  GET_PROXY
*----------------------------------------------------------------------*
FORM get_proxy  CHANGING ev_proxy    TYPE REF TO zykco_shipping_order_dispatche
                         ev_error    TYPE c
                         et_messages TYPE bapiret2_t.
  DATA: lr_sys_fault TYPE REF TO cx_ai_system_fault.
  DATA: lv_string    TYPE string,
        lv_msg(100)  TYPE c,
        ls_messages  TYPE bapiret2.
  TRY.
      CREATE OBJECT ev_proxy
        EXPORTING
          logical_port_name = 'ZYURTICI_KARGO_LP'.
    CATCH cx_ai_system_fault  INTO lr_sys_fault.
      ev_error = 'X'.
      lv_string = lr_sys_fault->get_text( ).
      CLEAR :ls_messages,lv_msg.
      lv_msg  = lv_string.
      IF strlen( lv_msg ) > 50.
        ls_messages-message    = lv_msg+0(50).
        ls_messages-message_v1 = lv_msg+0(50).
        ls_messages-message_v2 = lv_msg+50(50).
      ELSE.
        ls_messages-message    = lv_msg.
        ls_messages-message_v1 = lv_msg.
      ENDIF.
      PERFORM convert_message_to_bapiret USING    ls_messages
                                         CHANGING et_messages.
  ENDTRY.
ENDFORM.                    " GET_PROXY
*&---------------------------------------------------------------------*
*&      Form  SET_ORDERS
*----------------------------------------------------------------------*
FORM set_and_send_orders  TABLES   it_alv      STRUCTURE   zsog_mm_019_yi_cargo_01
                          USING    iv_proxy    TYPE REF TO zykco_shipping_order_dispatche
                          CHANGING et_messages TYPE bapiret2_t.
  DATA: lr_sys_fault        TYPE REF TO cx_ai_system_fault,
        lr_appl_fault       TYPE REF TO cx_ai_application_fault,
        ls_alv              TYPE zsog_mm_019_yi_cargo_01.

  DATA: ls_input            TYPE zykshipping_order_dispatcher_9,
        ls_output           TYPE zykshipping_order_dispatcher_6.

  DATA: lt_user             TYPE TABLE OF zsog_mm_019_t_01,
        ls_user             TYPE zsog_mm_019_t_01.
  DATA: ls_log              TYPE zsog_mm_019_t_02,
        lt_log              TYPE TABLE OF zsog_mm_019_t_02.

  DATA: lt_shippingorder    TYPE zykshipping_order_vo_tab,
        ls_shippingorder    TYPE zykshipping_order_vo,
        lv_cargokey         TYPE zykshipping_order_vo-cargo_key ,
        lv_barcode          TYPE zsog_mm_019_yi_cargo_01-barcode ,
        ls_shippingdetail   TYPE zykshipping_order_detail_vo,
        ls_messages         TYPE bapiret2,
        ls_return           TYPE bapiret2,
        lv_dummy            TYPE c,
        lv_banfn            TYPE ekpo-banfn,
        lv_message          TYPE char100,
        lv_err_string       TYPE string.

  CLEAR lt_user.
  SELECT SINGLE * FROM zsog_mm_019_t_01 INTO ls_user
                             WHERE sysid = sy-sysid.
  IF sy-subrc NE 0 OR ls_user IS INITIAL.
    MESSAGE e021(zsg) INTO lv_dummy.
    PERFORM add_bapiret TABLES et_messages.
    EXIT.
  ENDIF.
  CHECK ls_user IS NOT INITIAL.

  SORT it_alv BY banfn bnfpo afnam.
  DELETE ADJACENT DUPLICATES FROM it_alv COMPARING banfn bnfpo afnam.

  CLEAR: ls_alv,lt_shippingorder[].
  LOOP AT it_alv INTO ls_alv.
    CHECK ls_alv-row_color NE 'C500'.
    CLEAR: ls_input,ls_shippingorder,ls_log,lt_shippingorder[].

    ls_input-create_shipment-ws_user_name  = ls_user-user_name.
    ls_input-create_shipment-ws_password   = ls_user-password.
    ls_input-create_shipment-user_language = ls_user-userlanguage.

*    SET INPUT STRUCTURE AND TABLE
    CLEAR lv_banfn.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = ls_alv-banfn
      IMPORTING
        output = lv_banfn.


    CLEAR lv_cargokey.
    CONCATENATE lv_banfn ls_alv-bnfpo ls_alv-afnam
                             INTO lv_cargokey.

    CLEAR lv_barcode.
    CONCATENATE lv_banfn ls_alv-bnfpo ls_alv-afnam+2(6)
                             INTO lv_barcode.


    CONDENSE lv_cargokey.
    ls_shippingorder-cargo_key           = lv_barcode.         "Kargo Anahtarı
    ls_shippingorder-invoice_key         = lv_barcode.         "Fatura Anahtarı-mustafao ekledi.
*    ls_shippingorder-invoice_key         = ls_alv-ebeln.      "Fatura Anahtarı
    ls_shippingorder-receiver_cust_name  = ls_alv-afnam_name1. "Alıcı Adı
    CONCATENATE ls_alv-street ls_alv-house_num1
                "ls_alv-city2 ls_alv-city1
               INTO ls_shippingorder-receiver_address
               SEPARATED BY space.                               "Sevk adresidir
    IF ls_alv-telnr_long IS NOT INITIAL.
      ls_shippingorder-receiver_phone1     = ls_alv-telnr_long.  "Alıcı Telefon-1 Alan kodu ile 10 adet rakamd
    ELSE.
      ls_shippingorder-receiver_phone1     = ls_alv-telnr_long2.
    ENDIF.
    ls_shippingorder-receiver_phone2     = ls_alv-telnr_long2.
*      ls_shippingorder-receiverPhone3     = ls_alv-   .
    ls_shippingorder-city_name           = ls_alv-city1.         "İl  Adı
    ls_shippingorder-town_name           = ls_alv-city2.         "İlçe Adı
*      ls_shippingorder-custProdId         = ls_alv-    .        "Ürün Kodu
*      ls_shippingorder-desi               = ls_alv-    .        "Kargo  Desi
*      ls_shippingorder-kg                 = ls_alv-    .        "Kargo  Kg
*      ls_shippingorder-cargoCount         = ls_alv-    .        "Integer (4) "Kargo Sayısı
    ls_shippingorder-waybill_no          = ls_alv-ebeln.         "char20-Sevk İrsaliye No
*      ls_shippingorder-specialField1      = ls_alv-    .        "Özel Alan – 1
*      ls_shippingorder-specialField2      = ls_alv-    .        "Özel Alan – 2
*      ls_shippingorder-specialField3      = ls_alv-    .        "Özel Alan – 3
*      ls_shippingorder-ttCollectionType   = ls_alv-    .        "Tahsilâtlı teslimat( 0 – Nakit, 1-Kredi Kartı)
*      ls_shippingorder-ttInvoiceAmount    = ls_alv-    .        "Tahsilâtlı teslimat ürünü tutar bilgisi Sep(.) olmalıdır.
*      ls_shippingorder-ttDocumentId       = ls_alv-    .        "Tahsilâtlı Teslimat Fatura No
*      ls_shippingorder-ttDocumentSaveType = ls_alv-    .        "Tahs.tesl.hizmet bedeli gönderi içerisinde mi? (0 – Aynı fatura,1 – farklı fatura)
*      ls_shippingorder-orgReceiverCustId  = ls_alv-    .        "Alıcı Müşteri Kodu
*      ls_shippingorder-description        = ls_alv-    .        "Açıklama
*      ls_shippingorder-taxNumber          = ls_alv-    .        "Vergi No (Şahıs Şirketleri için 11 , Normal Şirketler için 10 hane gönderilebilir.) Bu dolu ise doğrulama algoritmasından kontrol edilir. Hatalı veri iletilmesi durumunda servis hata
*      ls_shippingorder-taxOfficeId        = ls_alv-    .        "Vergi Dairesi Kodu
*      ls_shippingorder-taxOfficeName      = ls_alv-    .        "Vergi Dairesi Adı
*      ls_shippingorder-orgGeoCode         = ls_alv-    .        "Müşteri Adres Kodu
*      ls_shippingorder-privilegeOrder     = ls_alv-    .        "Varış merkezi öncelik sırası
*      ls_shippingorder-dcSelectedCredit   = ls_alv-    .        "Müşteri Taksit Seçimi (Taksit Sayısı)
*      ls_shippingorder-dcCreditRule       = ls_alv-    .        "Taksit Uygulama Kriteri 0: Müşteri Seçimi Zorunlu,1: Tek Çekime izin ver
*      ls_shippingorder-emailAddress       = ls_alv-    .        "Alıcı Müşteri mail adresi
    APPEND ls_shippingorder TO lt_shippingorder[].

    IF lt_shippingorder[] IS NOT INITIAL.
      APPEND LINES OF lt_shippingorder[]  TO ls_input-create_shipment-shipping_order_vo[].
    ENDIF.
    TRY.
        CLEAR ls_output.
        iv_proxy->create_shipment(
          EXPORTING
            input  = ls_input
          IMPORTING
            output = ls_output ).
      CATCH cx_ai_system_fault INTO lr_sys_fault.
        lv_err_string =  lr_sys_fault->get_text( ).
      CATCH cx_ai_application_fault.
      CATCH cx_sy_ref_is_initial.
    ENDTRY.
    IF ls_output IS INITIAL.
      ls_alv-row_color = 'C600'.
      CLEAR lv_dummy.
      MESSAGE e020(zsg) INTO lv_dummy.
      PERFORM add_bapiret TABLES et_messages.
    ELSE.

      ls_alv-out_flag = ls_output-create_shipment_response-shipping_order_result_vo-base-base-out_flag.
      " ( 0 - başarılı," 1 - 1 i başarılı," 2 - beklenmeyen hata )

      ls_alv-out_result = ls_output-create_shipment_response-shipping_order_result_vo-base-base-out_result.

      ls_alv-job_id   = ls_output-create_shipment_response-shipping_order_result_vo-job_id.
      ls_alv-shipping_count = ls_output-create_shipment_response-shipping_order_result_vo-count.

      CLEAR ls_shippingdetail.
      READ TABLE ls_output-create_shipment_response-shipping_order_result_vo-shipping_order_detail_vo
                                                                  INTO ls_shippingdetail
                                                                  WITH KEY invoice_key = lv_barcode.
      IF sy-subrc = 0.
        IF ls_shippingdetail-err_code EQ 0.
          ls_alv-row_color = 'C500'.
        ELSE.
          ls_alv-row_color = 'C600'.
        ENDIF.
        ls_alv-cargo_key               = ls_shippingdetail-cargo_key.
        ls_alv-barcode                 = lv_barcode.
        ls_alv-invoice_key             = ls_alv-ebeln. "ls_shippingdetail-invoice_key. """mustafa ekledi.
*        ls_alv-invoice_key             = ls_shippingdetail-invoice_key.

        ls_alv-err_code                = ls_shippingdetail-err_code.
        IF ls_shippingdetail-err_code EQ 0.
          MESSAGE s022(zsg) INTO ls_shippingdetail-err_message.
        ENDIF.
        ls_alv-err_message             = ls_shippingdetail-err_message.

        MOVE-CORRESPONDING ls_alv TO ls_log.
        APPEND ls_log TO lt_log.

        CLEAR ls_messages.
        ls_messages-message    = lv_barcode.
        IF strlen( ls_shippingdetail-err_message ) > 50.
          CLEAR lv_message.
          lv_message =  ls_shippingdetail-err_message.
          ls_messages-message_v1 = lv_message+0(50).
          ls_messages-message_v2 = lv_message+50(50).
        ELSE.
          ls_messages-message_v1 = ls_shippingdetail-err_message.
          CONCATENATE text-003 lv_barcode INTO ls_messages-message_v2.
        ENDIF.
        IF ls_shippingdetail-err_code EQ 0.
          ls_messages-type = 'S'.
        ELSE.
          ls_messages-type = 'E'.
        ENDIF.

        CONCATENATE text-005 ls_shippingdetail-invoice_key INTO ls_messages-message_v3.
        PERFORM convert_message_to_bapiret USING ls_messages
                                           CHANGING et_messages.
      ELSE.
        ls_alv-row_color = 'C600'.
      ENDIF.
    ENDIF.


    MODIFY gt_data FROM ls_alv TRANSPORTING out_flag         out_result
                                            shipping_count   job_id barcode
                                            cargo_key        invoice_key
                                            err_code         err_message
                                            row_color
                                WHERE ebeln = ls_alv-ebeln
                                  AND ebelp = ls_alv-ebelp
                                  AND banfn = ls_alv-banfn
                                  AND bnfpo = ls_alv-bnfpo.

    CLEAR:  ls_input, ls_output, ls_alv, ls_log , ls_shippingdetail.
  ENDLOOP.

  IF lt_log IS NOT INITIAL.
    MODIFY zsog_mm_019_t_02 FROM TABLE lt_log.
    IF sy-subrc = 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
    ELSE.
      CLEAR ls_return.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
        IMPORTING
          return = ls_return.
      CLEAR: et_messages[],lv_dummy.
      MESSAGE e020(zsg) INTO lv_dummy.
      PERFORM add_bapiret TABLES et_messages.
    ENDIF.
  ENDIF.

ENDFORM.                    " SET_ORDERS
*&---------------------------------------------------------------------*
*&                 REFRESH_TABLE_DISPLAY
*&---------------------------------------------------------------------*
FORM refresh_table_display USING ir_alvgrid TYPE REF TO cl_gui_alv_grid.
  DATA : ls_stable TYPE lvc_s_stbl .

  ls_stable-row = 'X'.
  ls_stable-col = 'X'.
  CALL METHOD ir_alvgrid->refresh_table_display
    EXPORTING
      is_stable      = ls_stable
      i_soft_refresh = 'X'
    EXCEPTIONS
      finished       = 1
      OTHERS         = 2.
ENDFORM.                    "refresh_table_display
*&---------------------------------------------------------------------*
*& Form handle_toolbar
*&---------------------------------------------------------------------*
FORM handle_toolbar  USING    e_object TYPE REF TO cl_alv_event_toolbar_set.
  CONSTANTS:c_separator               TYPE i VALUE 3.
  DATA: ls_toolbar  TYPE stb_button.

  CLEAR ls_toolbar.
  MOVE 3 TO ls_toolbar-butn_type.
  APPEND ls_toolbar TO e_object->mt_toolbar.
  CLEAR ls_toolbar.
  MOVE 'SEND'   TO ls_toolbar-function.
  MOVE text-002 TO ls_toolbar-quickinfo.
  MOVE text-002 TO ls_toolbar-text.
  MOVE icon_planning_in TO ls_toolbar-icon.
  MOVE ' ' TO ls_toolbar-disabled.
  APPEND ls_toolbar TO e_object->mt_toolbar.

ENDFORM.                    "handle_toolbar
*&---------------------------------------------------------------------*
*& Form handle_user_command
*&---------------------------------------------------------------------*
FORM handle_user_command  USING  e_ucomm TYPE  sy-ucomm.
  DATA:lt_selected_data  TYPE TABLE OF zsog_mm_019_yi_cargo_01,
       lv_error          TYPE c,
       lt_selected_rows  TYPE lvc_t_roid,
       lt_messages       TYPE bapiret2_t,
*       lv_return_code    TYPE i,
       lv_proxy          TYPE REF TO zykco_shipping_order_dispatche.
  CLEAR: lv_error,lt_selected_rows,lt_messages,
         lv_proxy.
  CASE e_ucomm.
    WHEN 'SEND'.
      CLEAR: lv_error,lt_selected_rows.
      PERFORM get_selected_rows             USING    gr_alvgrid
                                            CHANGING lv_error
                                                     lt_selected_rows.
      CHECK lv_error IS INITIAL.

      CLEAR: lt_selected_data.
      PERFORM set_selected_rows             TABLES lt_selected_data
                                            USING  lt_selected_rows.

      PERFORM get_proxy                     CHANGING  lv_proxy
                                                      lv_error
                                                      lt_messages.
      IF lv_error IS INITIAL.
        CLEAR lt_messages.
        PERFORM set_and_send_orders         TABLES   lt_selected_data
                                            USING    lv_proxy
                                            CHANGING lt_messages.

        PERFORM refresh_table_display       USING    gr_alvgrid.
      ENDIF.

      PERFORM display_messages              USING    lt_messages.
  ENDCASE.
ENDFORM.                    "handle_user_command
*&---------------------------------------------------------------------*
*& Form get_selected_rows
*&---------------------------------------------------------------------*
FORM get_selected_rows  USING    ir_alvgrid       TYPE REF TO cl_gui_alv_grid
                        CHANGING ev_error         TYPE c
                                 et_selected_rows TYPE lvc_t_roid.

  CALL METHOD ir_alvgrid->get_selected_rows
    IMPORTING
      et_row_no = et_selected_rows[].

  IF et_selected_rows[] IS INITIAL.
    MESSAGE text-004 TYPE 'I'.
    ev_error = 'X'.
  ENDIF.
ENDFORM.                    "get_selected_rows
*&---------------------------------------------------------------------*
*& Form set_selected_rows
*&---------------------------------------------------------------------*
FORM set_selected_rows  TABLES et_selected_data STRUCTURE zsog_mm_019_yi_cargo_01
                        USING  it_selected_rows TYPE lvc_t_roid.
  DATA:ls_data TYPE zsog_mm_019_yi_cargo_01,
       ls_rows TYPE lvc_s_roid.

  LOOP AT it_selected_rows[] INTO ls_rows.
    CLEAR ls_data.
    READ TABLE gt_data[] INTO ls_data INDEX ls_rows-row_id .
    IF sy-subrc = 0.
      APPEND ls_data TO et_selected_data.
    ENDIF.
  ENDLOOP.
ENDFORM.                    "set_selected_rows
*&---------------------------------------------------------------------*
*&                 FORM DISPLAY_MESSAGES
*&---------------------------------------------------------------------*
FORM display_messages USING it_messages TYPE bapiret2_t.
  IF it_messages[] IS NOT INITIAL.
    CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
      EXPORTING
        it_message = it_messages[].
  ENDIF.
ENDFORM.                    "display_messages
*&---------------------------------------------------------------------*
*& Form add_bapiret
*&---------------------------------------------------------------------*
FORM add_bapiret  TABLES et_messages STRUCTURE bapiret2.
  DATA : ls_return TYPE bapiret2.

  CALL FUNCTION 'FS_BAPI_BAPIRET2_FILL'
    EXPORTING
      type   = sy-msgty
      cl     = sy-msgid
      number = sy-msgno
      par1   = sy-msgv1
      par2   = sy-msgv2
      par3   = sy-msgv3
      par4   = sy-msgv4
    IMPORTING
      return = ls_return.
  APPEND ls_return TO et_messages.

ENDFORM.                    "add_bapiret
*&---------------------------------------------------------------------*
*&      Form  CONVERT_MESSAGE_TO_BAPIRET
*----------------------------------------------------------------------*
FORM convert_message_to_bapiret USING    is_messages TYPE bapiret2
                                CHANGING et_messages TYPE bapiret2_t.
  DATA:ls_messages TYPE bapiret2.
  CLEAR ls_messages.
  ls_messages-type       = is_messages-type.
  ls_messages-id         = 'ZSG'.
  ls_messages-number     = '000'.
  ls_messages-message    = is_messages-message.
  ls_messages-message_v1 = is_messages-message_v1.
  ls_messages-message_v2 = is_messages-message_v2.
  ls_messages-message_v3 = is_messages-message_v3.
  ls_messages-message_v4 = is_messages-message_v4.
  CONDENSE:ls_messages-message_v1,
           ls_messages-message_v2,
           ls_messages-message_v3,
           ls_messages-message_v4,
           ls_messages-message.
  APPEND ls_messages TO et_messages.
ENDFORM.                    " CONVERT_MESSAGE_TO_BAPIRET
