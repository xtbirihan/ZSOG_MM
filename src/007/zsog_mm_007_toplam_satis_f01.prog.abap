*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_007_TOPLAM_SATIS_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  FILL_TOTALS
*&---------------------------------------------------------------------*
FORM fill_totals .

  DATA: lt_satis  TYPE TABLE OF zsg_t_001,
        lt_satis2 TYPE TABLE OF zsg_t_001,
        ls_satis  TYPE zsg_t_001,
        ls_satis2 TYPE zsg_t_001.
  DATA: lt_total TYPE TABLE OF zsg_t_013,
        ls_total TYPE zsg_t_013,
        lv_date  TYPE sy-datum,
        ls_date_range TYPE date_range,
        lr_date_range TYPE date_t_range.

  SELECT MAX( max_date ) FROM zsg_t_013 INTO lv_date.
  IF sy-subrc EQ 0.
    ls_date_range-sign = 'I'.
    ls_date_range-option = 'GT'.
    ls_date_range-low = lv_date.
    APPEND ls_date_range TO lr_date_range.
  ENDIF.

  SELECT * INTO TABLE lt_satis FROM zsg_t_001
                                WHERE file_date IN lr_date_range
                                ORDER BY file_date.
  IF lt_satis IS INITIAL .
    LEAVE LIST-PROCESSING.
  ENDIF.

  lt_satis2 = lt_satis.
  SORT lt_satis2 BY file_date DESCENDING.

  READ TABLE lt_satis2 INTO ls_satis2 INDEX 1.

  SELECT * INTO TABLE lt_total FROM zsg_t_013.

  IF lt_total IS NOT INITIAL.
    ls_total-max_date =  ls_satis2-file_date.
    MODIFY lt_total FROM ls_total TRANSPORTING max_date WHERE max_date IS NOT INITIAL.
  ENDIF.

  LOOP AT lt_satis INTO ls_satis.
    ls_total-mandt                       = sy-mandt.
    ls_total-retailer_no                 = ls_satis-retailer_no             .
    ls_total-game_no                     = ls_satis-game_no                 .
    ls_total-max_date                    = ls_satis2-file_date              .
    ls_total-sales_amount                = ls_satis-sales_amount            .
    ls_total-no_of_sold_wagers           = ls_satis-no_of_sold_wagers       .
    ls_total-no_of_sold_bets             = ls_satis-no_of_sold_bets         .
    ls_total-cancelled_sales_amount      = ls_satis-cancelled_sales_amount  .
    ls_total-no_of_cancelled_wagers      = ls_satis-no_of_cancelled_wagers  .
    COLLECT ls_total INTO lt_total.
  ENDLOOP.

  IF lt_total IS NOT INITIAL.
    MODIFY zsg_t_013 FROM TABLE lt_total.
    COMMIT WORK AND WAIT.
    MESSAGE S009(ZSG). " kayıtlar başarıyla güncellendi!
  ENDIF.
ENDFORM.                    " FILL_TOTALS
