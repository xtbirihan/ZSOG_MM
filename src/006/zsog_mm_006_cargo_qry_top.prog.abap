*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_006_CARGO_QRY_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_006_CARGO_TOP
*&---------------------------------------------------------------------*
DATA: BEGIN OF gs_scr_1903.
DATA: alv              TYPE TABLE OF ZSOG_MM_006_T_03.
DATA: r_alv            TYPE REF TO cl_salv_table.
DATA: r_columns        TYPE REF TO cl_salv_columns_table.
DATA: r_column         TYPE REF TO cl_salv_column.
DATA: r_events         TYPE REF TO cl_salv_events_table.
DATA: r_selections     TYPE REF TO cl_salv_selections.
DATA: mal_kabul        TYPE TABLE OF zsog_mm_006_t_02.
*DATA: grid1            TYPE REF TO cl_gui_alv_grid.
DATA: END OF gs_scr_1903.
*----------------------------------------------------------------------*
*       CLASS lcl_handle_events DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.
    METHODS: on_link_click   FOR EVENT link_click
                  OF cl_salv_events_table
      IMPORTING row column,

      on_user_command FOR EVENT added_function OF cl_salv_events
        IMPORTING e_salv_function.
ENDCLASS.                    "lcl_handle_events DEFINITION

DATA: event_handler TYPE REF TO lcl_handle_events.
*----------------------------------------------------------------------*
*       CLASS lcl_handle_events IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_handle_events IMPLEMENTATION.
  METHOD on_link_click.

  ENDMETHOD.                    "on_link_click

  METHOD on_user_command.

    PERFORM handle_user_command USING e_salv_function.
  ENDMETHOD.                    "on_user_command
ENDCLASS.                    "lcl_handle_events IMPLEMENTATION
