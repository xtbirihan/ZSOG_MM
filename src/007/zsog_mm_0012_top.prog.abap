*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_0012_TOP
*&---------------------------------------------------------------------*
TABLES: ekko,ekpo, lvc_s_fcat.
CONSTANTS:gc_green TYPE char4 VALUe 'C500'.
CONSTANTS:gc_RED TYPE char4   VALUe 'C600'.

TYPE-POOLS: slis.
TYPES:BEGIN OF ty_group,
      ebeln TYPE ekpo-ebeln,
      END OF ty_group,
      tt_group TYPE TABLE of ty_group.
DATA : gt_data TYPE TABLE OF zsog_mm_007_s_009.

DATA : gr_alvgrid             TYPE  REF TO cl_gui_alv_grid,
       gr_custom_container    TYPE REF TO cl_gui_custom_container,
       gr_custom_control_name TYPE scrfname VALUE 'CC_ALV'.

DATA : gt_rows     TYPE lvc_t_row,
       gs_fieldcat TYPE lvc_s_fcat,
       gt_fieldcat TYPE lvc_t_fcat,
       gs_layout   TYPE lvc_s_layo,
       gt_exclude  TYPE ui_functions,
       gt_sort     TYPE lvc_t_sort,
       gt_filt     TYPE lvc_t_filt,
       gv_ok_code  TYPE sy-ucomm.

CLASS :lcl_event_handler DEFINITION DEFERRED.
DATA  :gr_event_handler  TYPE REF TO lcl_event_handler.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
SELECT-OPTIONS : s_ebeln FOR ekko-ebeln OBLIGATORY NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b1.
