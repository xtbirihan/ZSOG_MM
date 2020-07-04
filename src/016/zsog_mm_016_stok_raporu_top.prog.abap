*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_016_STOK_RAPORU_TOP
*&---------------------------------------------------------------------*
TABLES: kna1, mara.
DATA ok_code TYPE sy-ucomm.

DATA: gt_out TYPE TABLE OF zsog_mm_s_016,
      gs_out TYPE zsog_mm_s_016.

*-data alv tanimlamalari
DATA:
go_container        TYPE scrfname VALUE 'CONT100',
go_grid             TYPE REF TO cl_gui_alv_grid,
go_custom_container TYPE REF TO cl_gui_custom_container,
gs_layo100          TYPE lvc_s_layo,   "layout
gt_fcat             TYPE lvc_t_fcat,   "fieldcatalog
gs_fcat             TYPE lvc_s_fcat,   "fieldcatalog
gt_exclude          TYPE ui_functions, "alv toolbardaki butonlar için
gs_exclude          TYPE ui_func,      "alv toolbardaki butonlar için
gs_variant          TYPE disvariant.   "alv datasının varyantlıgelmesi için

DATA gv_title TYPE string.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

SELECT-OPTIONS: s_kunnr FOR kna1-kunnr,
                s_matnr FOR mara-matnr.

SELECTION-SCREEN END OF BLOCK b1.
