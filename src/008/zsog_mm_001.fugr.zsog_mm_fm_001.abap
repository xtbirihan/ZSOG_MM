FUNCTION zsog_mm_fm_001.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_CUST_NO) TYPE  KUNNR OPTIONAL
*"     VALUE(I_BEGIN_DATE) TYPE  ZBEGIN_DATE OPTIONAL
*"     VALUE(I_END_DATE) TYPE  ZEND_DATE OPTIONAL
*"  EXPORTING
*"     VALUE(ET_REQUEST_INFO) TYPE  ZMM_TT_001
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  TYPES: BEGIN OF ltt_data1,
    afnam TYPE eban-afnam,
    banfn TYPE eban-banfn,
    bnfpo TYPE eban-bnfpo,
    badat TYPE eban-badat,
    ebeln TYPE eket-ebeln,
    ebelp TYPE eket-ebelp,
    bedat TYPE eket-bedat,
    matnr TYPE eban-matnr,
    txz01 TYPE eban-txz01,
    menge_q TYPE eban-menge,
    meins_u TYPE eban-meins,
    menge TYPE eket-menge,
    meins TYPE eban-meins,
    sat_loekz TYPE eban-loekz,
    sas_loekz TYPE ekko-loekz,
*    musteri_codu TYPE char50,  " commented by ilknurnac 07042020
*    invoice_key TYPE zsog_mm_019_t_03-invoice_key, " Added by ilknurnac 07042020
    cargo_key   TYPE zsog_mm_019_t_03-cargo_key, " Added by ilknurnac 07042020
    END OF ltt_data1.

  DATA: lt_data1 TYPE TABLE OF ltt_data1,
        ls_data1 TYPE ltt_data1.

  TYPES: BEGIN OF ltt_data2,
*   musteri_ozel_kodu TYPE zsog_mm_006_t_03-musteri_ozel_kodu," commented by ilknurnacar 0704020
*   irsaliye_numara   TYPE zsog_mm_006_t_03-irsaliye_numara,
*   gonderici         TYPE zsog_mm_006_t_03-gonderici,
*   alici             TYPE zsog_mm_006_t_03-alici,
*   kargo_takip_no    TYPE zsog_mm_006_t_03-kargo_takip_no,
*   durum_kodu        TYPE zsog_mm_006_t_03-durum_kodu,
*   durumu            TYPE zsog_mm_006_t_03-durumu,
*   teslim_alan       TYPE zsog_mm_006_t_03-teslim_alan,
*   teslim_tarihi     TYPE zsog_mm_006_t_03-teslim_tarihi,
*   teslim_saati      TYPE zsog_mm_006_t_03-teslim_saati,      " end of commented by ilknurnacar 0704020
    cargo_key          TYPE zsog_mm_019_t_03-cargo_key,        " added by ilknurnacar 0704020
    invoice_key        TYPE zsog_mm_019_t_03-invoice_key,
    gonderici          TYPE zsog_mm_019_t_02-name1,
    alici              TYPE zsog_mm_019_t_02-afnam,
    kargo_takip_no     TYPE zsog_mm_019_t_03-doc_id,
    operation_code     TYPE zsog_mm_019_t_03-operation_code,
    operation_message  TYPE zsog_mm_019_t_03-operation_message,
    receiver_info      TYPE zsog_mm_019_t_03-receiver_info,
    delivery_date      TYPE zsog_mm_019_t_03-delivery_date,
    delivery_time      TYPE zsog_mm_019_t_03-delivery_time,    " end of added by ilknurnacar 0704020
   END OF ltt_data2.

  DATA: lt_data2 TYPE TABLE OF ltt_data2,
        ls_data2 TYPE ltt_data2.

  DATA: ls_alv TYPE zmm_s_003.

  DATA : lt_return       TYPE TABLE OF bapiret2,
         ls_return       TYPE bapiret2.
  DATA : lv_error        TYPE c,
         lv_dummy        TYPE c.
  DATA : lv_kunnr        TYPE kna1-kunnr.


  CONCATENATE i_begin_date+4(4)
  i_begin_date+2(2) i_begin_date+0(2)
  INTO i_begin_date.

  CONCATENATE i_end_date+4(4)
i_end_date+2(2) i_end_date+0(2)
INTO i_end_date.

* alanların kontrolü
  IF i_begin_date IS INITIAL.
    MESSAGE e116(zmm) INTO lv_dummy.
    PERFORM get_message_text CHANGING ls_return-message.
    ls_return-type   = 'E'.
    ls_return-id     = 'ZMM'.
    ls_return-number = '116'.
    APPEND ls_return TO et_return[].
  ELSEIF i_begin_date GT sy-datum.
    MESSAGE e117(zmm) INTO lv_dummy.
    PERFORM get_message_text CHANGING ls_return-message.
    ls_return-type   = 'E'.
    ls_return-id     = 'ZMM'.
    ls_return-number = '117'.
    APPEND ls_return TO et_return[].
  ENDIF.

  IF i_end_date IS INITIAL .
    i_end_date = sy-datum.
  ENDIF.

  SELECT SINGLE kunnr
    FROM kna1
    INTO lv_kunnr
   WHERE kunnr EQ i_cust_no.


  IF i_cust_no IS INITIAL.
    MESSAGE e118(zmm) INTO lv_dummy.
    PERFORM get_message_text CHANGING ls_return-message.
    ls_return-type   = 'E'.
    ls_return-id     = 'ZMM'.
    ls_return-number = '118'.
    APPEND ls_return TO et_return[].

  ELSEIF lv_kunnr IS INITIAL.
    MESSAGE e119(zmm) INTO lv_dummy.
    PERFORM get_message_text CHANGING ls_return-message.
    ls_return-type   = 'E'.
    ls_return-id     = 'ZMM'.
    ls_return-number = '119'.
    APPEND ls_return TO et_return[].
  ENDIF.

  IF et_return IS INITIAL.
*Veri Çekim
    SELECT e~afnam e~banfn e~bnfpo e~badat ek~ebeln ek~ebelp ek~bedat
       e~matnr e~txz01 e~menge AS menge_q e~meins AS meins_u ek~menge e~meins e~loekz "ekk~loekz
    FROM eban AS e
      LEFT OUTER JOIN eket AS ek ON ek~banfn EQ e~banfn
                                AND ek~bnfpo EQ e~bnfpo
*      INNER JOIN ekko AS ekk ON ekk~ebeln EQ ek~ebeln
*                           and ep~ebelp eq ek~ebelp
     INNER JOIN kna1 AS k  ON k~kunnr  EQ e~afnam
      INTO TABLE lt_data1"et_request_info
      WHERE e~badat GE i_begin_date
        AND e~badat LE i_end_date
        AND k~kunnr EQ i_cust_no.

*    SORT et_request_info BY matno.

*    LOOP AT lt_data1 INTO ls_data1.
*      CONCATENATE ls_data1-banfn ls_data1-bnfpo ls_data1-afnam INTO ls_data1-cargo_key.
*      MODIFY lt_data1 FROM ls_data1 TRANSPORTING  cargokey.
*    ENDLOOP.

    IF lt_data1 IS NOT INITIAL.
      SELECT a~cargo_key
             a~invoice_key
             b~name1
             b~afnam
             a~doc_id
             a~operation_code
             a~operation_message
             a~receiver_info
             a~delivery_date
             a~delivery_time
*        z3~musteri_ozel_kodu z3~irsaliye_numara z3~gonderici z3~alici
*         z3~kargo_takip_no z3~durum_kodu z3~durumu z3~teslim_alan
*         z3~teslim_tarihi z3~teslim_saati
*        FROM zsog_mm_006_t_03 AS z3  "commented by ilknurnacar
        FROM zsog_mm_019_t_03 AS a   "added by ilknurnacar
        INNER JOIN zsog_mm_019_t_02 AS b ON  b~cargo_key   = a~cargo_key
                                         AND b~invoice_key = a~invoice_key
        INTO TABLE lt_data2
        FOR ALL ENTRIES IN lt_data1
        WHERE a~invoice_key EQ lt_data1-ebeln.
    ENDIF.


*  SORT lt_data2 BY musteri_ozel_kodu.

    LOOP AT lt_data1 INTO ls_data1.
      CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
        EXPORTING
          input          = ls_data1-meins_u
        IMPORTING
          output         = ls_data1-meins_u
        EXCEPTIONS
          unit_not_found = 1
          OTHERS         = 2.

      ls_alv-custno          = ls_data1-afnam.
      ls_alv-prno            = ls_data1-banfn.
      ls_alv-pritemno        = ls_data1-bnfpo.
      ls_alv-prdate          = ls_data1-badat.
      ls_alv-pono            = ls_data1-ebeln.
      ls_alv-poitemno        = ls_data1-ebelp.
      ls_alv-podate          = ls_data1-bedat.
      ls_alv-matno           = ls_data1-matnr.
      ls_alv-matdesc         = ls_data1-txz01.
      ls_alv-quantity        = ls_data1-menge_q.
      ls_alv-unit_of_measure = ls_data1-meins_u.
      ls_alv-matquant        = ls_data1-menge.
      ls_alv-matmeas         = ls_data1-meins.
      ls_alv-sat_delind      = ls_data1-sat_loekz.
      ls_alv-sas_delind      = ls_data1-sas_loekz.

      READ TABLE lt_data2 INTO ls_data2
                          WITH KEY invoice_key = ls_data1-ebeln.
*                                                                         BINARY SEARCH.
      IF sy-subrc EQ 0.
        ls_alv-cargo_sbmt_no   = ls_data2-cargo_key  .
        ls_alv-cargo_waybill   = ls_data2-invoice_key.
        ls_alv-cargo_sender    = ls_data2-gonderici  .
        ls_alv-cargo_reciever  = ls_data2-alici      .
        ls_alv-cargo_no        = ls_data2-kargo_takip_no.
        ls_alv-cargo_stat_code = ls_data2-operation_code.
        ls_alv-cargo_status    = ls_data2-operation_message.
        ls_alv-delied          = ls_data2-receiver_info.
        ls_alv-deli_date       = ls_data2-delivery_date.
        ls_alv-deli_time       = ls_data2-delivery_time.
      ENDIF.
      APPEND ls_alv TO et_request_info.
      CLEAR: ls_alv, ls_data1, ls_data2.
    ENDLOOP.
  ENDIF.

  IF et_request_info IS INITIAL.
    MESSAGE e109(zmm) INTO lv_dummy.
    PERFORM get_message_text CHANGING ls_return-message.
    ls_return-type   = 'E'.
    ls_return-id     = 'ZMM'.
    ls_return-number = '109'.
    APPEND ls_return TO et_return[].
  ENDIF.

ENDFUNCTION.
