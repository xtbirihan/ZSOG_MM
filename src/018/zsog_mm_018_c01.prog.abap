*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_018_C01
*&---------------------------------------------------------------------*

class lcl_event_handler definition.

  public section.

    methods:
*To add new functional buttons to the ALV toolbar
    handle_toolbar for event toolbar of cl_gui_alv_grid
    importing e_object e_interactive,
*To implement user commands
      handle_user_command for event user_command of cl_gui_alv_grid
    importing e_ucomm,

 handle_hotspot_click for event hotspot_click of cl_gui_alv_grid
    importing e_row_id e_column_id es_row_no.

endclass.                    "lcl_event_handler DEFINITION
*----------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_event_handler implementation.
*Handle Toolbar
  method handle_toolbar.
    perform handle_toolbar using e_object.
  endmethod .                    "handle_toolbar

*Handle User command
  method handle_user_command.
    perform handle_user_command using e_ucomm .
  endmethod .                    "handle_user_command

*Hotspot control.
  method handle_hotspot_click .
    perform handle_hotspot_click using e_row_id e_column_id es_row_no .
  endmethod .                    "handle_hotspot_click

endclass.                    "lcl_event_handler IMPLEMENTATION
