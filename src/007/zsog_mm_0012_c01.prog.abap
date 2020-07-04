*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_0012_C01
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS:
    handle_toolbar      FOR EVENT toolbar OF cl_gui_alv_grid
                        IMPORTING e_object e_interactive,
    handle_user_command FOR EVENT user_command OF cl_gui_alv_grid
                        IMPORTING e_ucomm.
ENDCLASS.                    "lcl_event_handler DEFINITION
*----------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD handle_toolbar.
    PERFORM handle_toolbar USING e_object.
  ENDMETHOD .                    "handle_toolbar
  METHOD handle_user_command.
    PERFORM handle_user_command USING e_ucomm .
 ENDMETHOD .                    "handle_user_command
ENDCLASS.
