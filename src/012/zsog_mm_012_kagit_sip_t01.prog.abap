*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_012_KAGIT_SIP_T01
*&---------------------------------------------------------------------*

TABLES : ekko, kna1, mara.

*-Alv tablosu
DATA : gs_out type ZSOG_MM_012_S_001,
       gt_out TYPE TABLE OF ZSOG_MM_012_S_001.

*-Bapi mesajları tanımlamaları
DATA : gt_message TYPE bapiret2_t.
DATA : gv_dummy TYPE c.

*-Data Alv tanımlamaları
DATA:
  go_container        TYPE scrfname VALUE 'CONT100',
  go_grid             TYPE REF TO cl_gui_alv_grid,
  go_custom_container TYPE REF TO cl_gui_custom_container,
  gs_layo100          TYPE lvc_s_layo,
  gt_fcat             TYPE lvc_t_fcat,
  gs_fcat             TYPE lvc_s_fcat,
  gt_exclude          TYPE ui_functions,
  gs_exclude          TYPE ui_func,
  gs_variant          TYPE disvariant,
  gs_row_no           type lvc_s_row,
  gt_row_no           type lvc_t_row,
  gv_hata(1).
DATA ok_code TYPE sy-ucomm.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.

SELECT-OPTIONS : s_ebeln for ekko-ebeln OBLIGATORY.
SELECT-OPTIONS : s_kunnr for kna1-kunnr.
SELECT-OPTIONS : s_matnr for mara-matnr.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.
PARAMETERS: ch1 AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF BLOCK b1.
