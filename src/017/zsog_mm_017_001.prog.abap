*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_017_001
*&---------------------------------------------------------------------*


MODULE status_0100 OUTPUT.
   DATA: lv_lines TYPE int4,
         lv_char  TYPE string.

  DESCRIBE TABLE gt_out LINES lv_lines.
  lv_char = lv_lines.

  SET PF-STATUS 'SCREEN'.
  SET TITLEBAR 'MASRAF CIKIS' WITH lv_char.
  PERFORM show_data.
ENDMODULE.
