*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_019_CREATESHIPMENT_TOP
*&---------------------------------------------------------------------*
TABLES: ekko,eban,lfa1, lvc_s_fcat.

TYPE-POOLS: slis.

DATA : gs_data                TYPE zsog_mm_019_yi_cargo_02,
       gt_data                TYPE TABLE OF zsog_mm_019_yi_cargo_02.

DATA : gr_alvgrid             TYPE  REF TO cl_gui_alv_grid,
       gr_custom_container    TYPE REF TO cl_gui_custom_container,
       gr_custom_control_name TYPE scrfname VALUE 'CC_ALV'.

DATA : gt_rows                TYPE lvc_t_row,
       gs_fieldcat            TYPE lvc_s_fcat,
       gt_fieldcat            TYPE lvc_t_fcat,
       gs_layout              TYPE lvc_s_layo,
       gt_exclude             TYPE ui_functions,
       gt_sort                TYPE lvc_t_sort,
       gt_filt                TYPE lvc_t_filt,
       gv_ok_code             TYPE sy-ucomm,
       gt_hype_link           TYPE lvc_t_hype.
CLASS: lcl_event_receiver     DEFINITION DEFERRED.
DATA : gr_event_receiver      TYPE REF TO lcl_event_receiver.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: s_bedat       FOR ekko-bedat,
                s_ebeln       FOR ekko-ebeln.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.
PARAMETERS: r_data   RADIOBUTTON GROUP rb1 DEFAULT 'X'  MODIF ID m1,
            r_grecpt RADIOBUTTON GROUP rb1 MODIF ID m1.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF BLOCK b1.
