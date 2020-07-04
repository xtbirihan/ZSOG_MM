*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_009_KARGO_TOP
*&---------------------------------------------------------------------*

TABLES: eban, zsog_mm_019_t_03,zsog_mm_019_t_02.

DATA: gt_alv TYPE TABLE OF zsog_mm_007_s_010, "zsog_mm_007_s_008
      gs_alv TYPE zsog_mm_007_s_010.          "zsog_mm_007_s_008

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
SELECT-OPTIONS: s_kunnr FOR zsog_mm_019_t_02-afnam , "zsog_mm_006_t_02 -zsog_mm_019_t_02
                s_matnr FOR zsog_mm_019_t_02-matnr , "zsog_mm_003_t_03 - zsog_mm_019_t_03
                s_ebeln FOR zsog_mm_019_t_02-ebeln , " olarak değştirildi -ilknurnacar 06042020
                s_drm   FOR zsog_mm_019_t_03-operation_code.
SELECTION-SCREEN END OF BLOCK b1.
