*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_009_KARGO_O01
*&---------------------------------------------------------------------*

MODULE status_0100 OUTPUT.
  DATA: lv_lines TYPE int4,
        lv_char  TYPE string.

  DESCRIBE TABLE gt_alv LINES lv_lines.
  lv_char = lv_lines.

  SET PF-STATUS 'SCREEN'.
  SET TITLEBAR 'KARGO RAPORU' WITH lv_char.
  PERFORM show_data.

ENDMODULE.                    "status_0100 OUTPUT
