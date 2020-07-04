FUNCTION zsog_mm_fm_003.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_FILE_DATE) TYPE  ZFILE_DATE OPTIONAL
*"     VALUE(I_MONTH) TYPE  ZMONTH OPTIONAL
*"     VALUE(I_YEAR) TYPE  ZYEAR OPTIONAL
*"     VALUE(I_CUST_NO) TYPE  ZSG_D_RETAILER_NO OPTIONAL
*"  EXPORTING
*"     VALUE(ET_COMISACC_INFO) TYPE  ZMM_TT_007
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA : lt_return       TYPE TABLE OF bapiret2,
          ls_return       TYPE bapiret2.
  DATA : lv_error        TYPE c,
         lv_dummy        TYPE c.
  DATA : lr_file_date TYPE RANGE OF zsg_t_003-file_date
        WITH HEADER LINE,
         lr_cust_no TYPE RANGE OF char10 WITH
         HEADER LINE,
         lr_year TYPE RANGE OF zsg_t_003-gjahr
        WITH HEADER LINE,
         lr_month TYPE RANGE OF zsg_t_003-monat WITH
         HEADER LINE.
  DATA : lt_data TYPE TABLE OF zsg_t_003,
         ls_data TYPE zsg_t_003,
         ls_comisacc_info TYPE zmm_s_007.

  IF i_file_date IS NOT INITIAL.

    CONCATENATE i_file_date+4(4)
    i_file_date+2(2) i_file_date+0(2)
    INTO i_file_date.

    lr_file_date = 'IEQ'.
    lr_file_date-low = i_file_date.
    COLLECT lr_file_date.
  ENDIF.

  IF i_cust_no IS NOT INITIAL.
    lr_cust_no = 'IEQ'.
    lr_cust_no-low = i_cust_no.
    SHIFT lr_cust_no-low LEFT DELETING LEADING '0'.
    CONDENSE lr_cust_no-low NO-GAPS.
    COLLECT lr_cust_no.
  ENDIF.

  IF i_month IS NOT INITIAL.
    lr_month = 'IEQ'.
    lr_month-low = i_month.
    COLLECT lr_month.
  ENDIF.
  IF i_year IS NOT INITIAL.
    lr_year = 'IEQ'.
    lr_year-low = i_year.
    COLLECT lr_year.
  ENDIF.

  IF lr_file_date IS INITIAL.
    IF lr_month IS INITIAL.
      MESSAGE e132(zmm) INTO lv_dummy.
      PERFORM get_message_text CHANGING ls_return-message.
      ls_return-type   = 'E'.
      ls_return-id     = 'ZMM'.
      ls_return-number = '132'.
      APPEND ls_return TO et_return[].
    ENDIF.
    IF lr_year IS INITIAL.
      MESSAGE e133(zmm) INTO lv_dummy.
      PERFORM get_message_text CHANGING ls_return-message.
      ls_return-type   = 'E'.
      ls_return-id     = 'ZMM'.
      ls_return-number = '133'.
      APPEND ls_return TO et_return[].
    ENDIF.
    IF lr_cust_no IS INITIAL.
      MESSAGE e134(zmm) INTO lv_dummy.
      PERFORM get_message_text CHANGING ls_return-message.
      ls_return-type   = 'E'.
      ls_return-id     = 'ZMM'.
      ls_return-number = '134'.
      APPEND ls_return TO et_return[].
    ENDIF.


  ENDIF.
**  IF lr_cust_no-low+0(2) EQ 'SG'.
**    lr_cust_no = lr_cust_no-low+2(8).
**  ELSEIF lr_cust_no IS NOT INITIAL.
**    MESSAGE e131(zmm) INTO lv_dummy.
**    PERFORM get_message_text CHANGING ls_return-message.
**    ls_return-type   = 'E'.
**    ls_return-id     = 'ZMM'.
**    ls_return-number = '131'.
**    APPEND ls_return TO et_return[].
**  ENDIF.

  IF et_return IS INITIAL.

    SELECT * FROM zsg_t_003
      INTO CORRESPONDING FIELDS OF TABLE lt_data
      WHERE file_date IN lr_file_date
        AND monat IN lr_month
        AND gjahr IN lr_year
        AND retailer_no IN lr_cust_no.
  ENDIF.

  LOOP AT lt_data INTO ls_data.
    MOVE-CORRESPONDING ls_data TO ls_comisacc_info.
    APPEND ls_comisacc_info TO et_comisacc_info.
    CLEAR : ls_comisacc_info,ls_data.
  ENDLOOP.

  IF et_comisacc_info IS INITIAL.
    MESSAGE e109(zmm) INTO lv_dummy.
    PERFORM get_message_text CHANGING ls_return-message.
    ls_return-type   = 'E'.
    ls_return-id     = 'ZMM'.
    ls_return-number = '109'.
    APPEND ls_return TO et_return[].
  ENDIF.


ENDFUNCTION.
