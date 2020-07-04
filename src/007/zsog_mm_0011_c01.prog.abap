*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_0011_C01
*&---------------------------------------------------------------------*
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
        IMPORTING e_ucomm sender.
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
    ls_toolbar-function  = 'GONDER'.
*    ls_toolbar-icon      = icon_select_all.
    ls_toolbar-butn_type = 0.
    ls_toolbar-text      = 'GONDER'.
    ls_toolbar-quickinfo = 'GONDER'.
    APPEND ls_toolbar TO e_object->mt_toolbar.

  ENDMETHOD.                    "handle_toolbar

  METHOD handle_user_command.
    CASE e_ucomm.
      WHEN 'GONDER'.
        PERFORM gonder.
    ENDCASE.
  ENDMETHOD.                    "handle_user_command

ENDCLASS.                    "lcl_event_receiver IMPLEMENTATION
