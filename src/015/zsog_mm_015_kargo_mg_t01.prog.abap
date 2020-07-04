*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_015_KARGO_MG_T01
*&---------------------------------------------------------------------*


*-Data Alv
DATA: go_container        TYPE scrfname VALUE 'CONT100',
      go_grid             TYPE REF TO cl_gui_alv_grid,
      go_custom_container TYPE REF TO cl_gui_custom_container,
      gs_layo100          TYPE lvc_s_layo,
      gt_fcat             TYPE lvc_t_fcat,
      gs_fcat             TYPE lvc_s_fcat,
      gt_exclude          TYPE ui_functions,
      gs_exclude          TYPE ui_func,
      gs_variant          TYPE disvariant,
      gt_dropdown         TYPE lvc_t_drop.
DATA: gt_return           TYPE TABLE OF bapiret2,
      gs_return           TYPE bapiret2   .

DATA: gv_error            TYPE c.
DATA: ok_code             TYPE sy-ucomm.

DATA: gt_out              TYPE TABLE OF zsog_mm_015_t_02,  "addeed by ilknurnacar
*      gt_out              TYPE TABLE OF zsog_mm_015_t_01, commented by ilknurnacar
      gs_out              TYPE zsog_mm_015_t_02,           "addeed by ilknurnacar
*      gs_out              TYPE zsog_mm_015_t_01,           commented by ilknurnacar
      gt_selected         TYPE TABLE OF zsog_mm_015_t_02,   "addeed by ilknurnacar
*      gt_selected         TYPE TABLE OF zsog_mm_015_t_01,  commented by ilknurnacar
      gs_selected         TYPE zsog_mm_015_t_02,           "addeed by ilknurnacar
*      gs_selected         TYPE zsog_mm_015_t_01,           commented by ilknurnacar
      gt_row_no           TYPE lvc_t_roid ,
      gs_row_no           TYPE lvc_s_roid .


*********

CLASS lcl_event_receiver DEFINITION DEFERRED.
*----------------------------------------------------------------------*
*       CLASS lcl_event_receiver DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_event_receiver DEFINITION.
  PUBLIC SECTION.
    METHODS:
      handle_toolbar
                    FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object e_interactive sender,
*     Deal with user action
      handle_user_command
                    FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm sender,
*     Link click
      hotspot_click
                    FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id e_column_id es_row_no ,
*     Double click
      double_click
                    FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no ,
*     Data change
      handle_data_changed
                    FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed e_onf4 e_ucomm sender.
ENDCLASS.                    "lcl_event_receiver DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_event_receiver IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_event_receiver IMPLEMENTATION.
  METHOD handle_toolbar.
    DATA: ls_toolbar TYPE stb_button.

    CLEAR ls_toolbar.
    ls_toolbar-butn_type = 3.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR ls_toolbar.
    ls_toolbar-function  = 'KAYDET'.
    ls_toolbar-icon      = icon_system_save.
    ls_toolbar-butn_type = 0.
    ls_toolbar-text      = 'Mal Girişi'.
    ls_toolbar-quickinfo = 'Mal Girişi'.
    APPEND ls_toolbar TO e_object->mt_toolbar.
  ENDMETHOD.                    "handle_toolbar
  METHOD handle_user_command.
    CASE e_ucomm.
      WHEN 'KAYDET'.
        PERFORM secim_tespit TABLES gt_row_no.
        PERFORM mal_kabul    TABLES gt_selected.
    ENDCASE.
    PERFORM refresh_table_display USING go_grid .
  ENDMETHOD.                    "handle_user_command
  METHOD hotspot_click.

  ENDMETHOD.                    "hotspot_click
  METHOD double_click.

  ENDMETHOD.                    "double_click
  METHOD handle_data_changed.

    PERFORM refresh_table_display USING go_grid .

  ENDMETHOD.                    "handle_data_changed
ENDCLASS.                    "lcl_event_receiver IMPLEMENTATION


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001  .

SELECT-OPTIONS:
s_datum FOR sy-datum.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.
PARAMETERS:
c_job AS CHECKBOX.

SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN END OF BLOCK b1.
