*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_019_QUERYSHIPMENT_C01
*&---------------------------------------------------------------------*
CLASS lcl_event_receiver DEFINITION.
 PUBLIC SECTION.
  METHODS:
    handle_toolbar      FOR EVENT toolbar      OF cl_gui_alv_grid
                        IMPORTING e_object e_interactive,
    handle_user_command FOR EVENT user_command OF cl_gui_alv_grid
                        IMPORTING e_ucomm.
ENDCLASS.

CLASS lcl_event_receiver IMPLEMENTATION.
 METHOD handle_toolbar.
    PERFORM handle_toolbar USING e_object.
  ENDMETHOD .
  METHOD handle_user_command.
    PERFORM handle_user_command USING e_ucomm .
  ENDMETHOD .
ENDCLASS.
