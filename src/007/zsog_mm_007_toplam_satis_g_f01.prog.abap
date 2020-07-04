*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_007_TOPLAM_SATIS_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  FILL_TOTALS
*&---------------------------------------------------------------------*
FORM fill_totals .

  DATA: lt_satis      TYPE TABLE OF zsg_t_015,
        lt_satis2     TYPE TABLE OF zsg_t_015,
        ls_satis      TYPE zsg_t_015,
        ls_satis2     TYPE zsg_t_015.
  DATA: lt_total      TYPE TABLE OF zsg_t_027,
        ls_total      TYPE zsg_t_027,
        lt_total2     TYPE TABLE OF zsg_t_028,
        ls_total2     TYPE zsg_t_028,
        lv_date       TYPE sy-datum,
        ls_date_range TYPE date_range,
        lr_date_range TYPE date_t_range.
  DATA: lv_file_date  TYPE sy-datum.


  SELECT MAX( max_date ) FROM zsg_t_027 INTO lv_date.
  IF sy-subrc EQ 0.
    ls_date_range-sign = 'I'.
    ls_date_range-option = 'GT'.
    ls_date_range-low = lv_date.
    APPEND ls_date_range TO lr_date_range.
  ENDIF.

  SELECT * INTO TABLE lt_satis FROM zsg_t_015
                                WHERE file_date IN lr_date_range
                                ORDER BY file_date.

  SELECT * INTO TABLE lt_satis2 FROM zsg_t_015.

  LOOP AT lt_satis2 INTO ls_satis2.
    MOVE-CORRESPONDING ls_satis2 TO ls_total2.
    COLLECT ls_total2 INTO lt_total2.
    CLEAR : ls_total2,ls_satis2.
  ENDLOOP.

  IF lt_satis IS INITIAL .
    LEAVE LIST-PROCESSING.
  ENDIF.

  SORT lt_satis BY file_date DESCENDING.

  READ TABLE lt_satis INTO ls_satis INDEX 1.

  SELECT * INTO TABLE lt_total FROM zsg_t_027.

*  LOOP AT lt_satis INTO ls_satis.


  IF lt_total IS NOT INITIAL.
    ls_total-max_date =  ls_satis-file_date.
*      ls_total-max_date =  ls_satis-file_date.
    MODIFY lt_total FROM ls_total TRANSPORTING max_date WHERE max_date IS NOT INITIAL.
  ENDIF.
  lv_file_date =  ls_satis-file_date.

  CLEAR : ls_satis.

  LOOP AT lt_satis INTO ls_satis.
    ls_total-mandt                       = sy-mandt.
    ls_total-retailer_no                 = ls_satis-retailer_no                .
    ls_total-game_no                     = ls_satis-game_no                    .
    ls_total-max_date                    = lv_file_date                        .
*    ls_total-max_date                    = ls_satis-file_date                 .
    ls_total-sales_amount                = ls_satis-sales_amount               .
    ls_total-no_of_sold_playslips        = ls_satis-no_of_sold_playslips       .
    ls_total-no_of_sold_bets             = ls_satis-no_of_sold_bets            .
    ls_total-cancelled_sales_amount      = ls_satis-cancelled_sales_amount     .
    ls_total-no_of_cancelled_playslips   = ls_satis-no_of_cancelled_playslips  .
    ls_total-no_of_cancelled_bets        = ls_satis-no_of_cancelled_bets       .
    COLLECT ls_total INTO lt_total.
    CLEAR: ls_total.
  ENDLOOP.

  IF lt_total IS NOT INITIAL.
    MODIFY zsg_t_027 FROM TABLE lt_total.
    COMMIT WORK AND WAIT.
    MESSAGE s009(zsg). " kayıtlar başarıyla güncellendi!
  ENDIF.
  IF lt_total2 IS NOT INITIAL.
    MODIFY zsg_t_028 FROM TABLE lt_total2.
    COMMIT WORK AND WAIT.
    MESSAGE s009(zsg). " kayıtlar başarıyla güncellendi!
  ENDIF.

ENDFORM.                    " FILL_TOTALS
