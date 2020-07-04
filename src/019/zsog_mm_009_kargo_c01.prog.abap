*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_009_KARGO_C01
*&---------------------------------------------------------------------*

CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS:
      handle_user_command FOR EVENT user_command OF cl_gui_alv_grid
    IMPORTING e_ucomm.
ENDCLASS.                    "lcl_event_handler DEFINITION
*----------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
*Handle User command
  METHOD handle_user_command.
    PERFORM handle_user_command USING e_ucomm .
  ENDMETHOD .                    "handle_user_command
ENDCLASS.                    "lcl_event_handler IMPLEMENTATION
