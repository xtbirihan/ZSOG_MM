*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_008_O01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  DATA: lv_lines TYPE int4,
        lv_char  TYPE string.

  DESCRIBE TABLE gt_alv LINES lv_lines.
  lv_char = lv_lines.

  SET PF-STATUS 'SCREEN'.
  SET TITLEBAR 'SIPARIS RAPORU' WITH lv_char.
  PERFORM show_data.

ENDMODULE.                 " STATUS_0100  OUTPUT
