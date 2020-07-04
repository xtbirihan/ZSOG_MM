*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_008_TOP
*&---------------------------------------------------------------------*
TABLES: eban, kna1, mara, ekpo, zsog_mm_019_t_03, ekko.

DATA: gt_alv TYPE TABLE OF zsog_mm_007_s_007,
      gs_alv TYPE zsog_mm_007_s_007.

DATA: gr_alvgrid             TYPE REF TO cl_gui_alv_grid,
      gc_custom_control_name TYPE scrfname VALUE 'SCREEN',
      gr_container           TYPE REF TO cl_gui_custom_container,
      gt_fieldcat            TYPE lvc_t_fcat,
      gs_fieldcat            TYPE lvc_s_fcat,
      gs_layout              TYPE lvc_s_layo,
      gs_row_no              TYPE lvc_s_roid,
      gt_row_no              TYPE lvc_t_roid,
      gt_exclude             TYPE ui_functions,
      ok_code                TYPE sy-ucomm,
      gt_exit(1),
      gv_hata(1).
DATA: gv_satir TYPE i.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: s_badat FOR eban-badat,
                s_kunnr FOR kna1-kunnr ,
                s_matnr FOR mara-matnr ,
                s_ebeln FOR eban-ebeln ,
                s_bedat FOR ekko-bedat .
*                s_drm FOR zsog_mm_006_t_03-durum_kodu.
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME  TITLE text-002.
PARAMETERS cb1  AS CHECKBOX MODIF ID m3.
PARAMETERS cb2  AS CHECKBOX MODIF ID m3.
*PARAMETERS cb3  AS CHECKBOX MODIF ID m3.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF BLOCK b1.
