*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_011_TOP
*&---------------------------------------------------------------------*
TABLES: lfa1.
DATA: gr_alvgrid             TYPE REF TO cl_gui_alv_grid,
      gc_custom_control_name TYPE scrfname VALUE 'SCREEN',
      gr_container           TYPE REF TO cl_gui_custom_container,
      gt_fieldcat            TYPE lvc_t_fcat,
      gs_fieldcat            TYPE lvc_s_fcat,
      gs_layout              TYPE lvc_s_layo,
      r_alv            TYPE REF TO cl_salv_table,
      gs_row_no              TYPE lvc_s_roid,
      gt_row_no              TYPE lvc_t_roid,
      gt_exclude             TYPE ui_functions,
      ok_code                TYPE sy-ucomm,
      gv_hata(1).
DATA: gt_out TYPE TABLE OF zmm_s_ithalat_kapama,
      gs_out TYPE zmm_s_ithalat_kapama.


SELECTION-SCREEN BEGIN OF BLOCK b102 WITH FRAME TITLE text-001 .
SELECTION-SCREEN FUNCTION KEY 1.
SELECT-OPTIONS s_lifnr FOR lfa1-lifnr OBLIGATORY NO-EXTENSION
NO INTERVALS .
SELECTION-SCREEN END OF BLOCK b102.
