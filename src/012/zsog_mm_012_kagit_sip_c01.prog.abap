*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_012_KAGIT_SIP_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZST_ALV_C01
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
    ls_toolbar-function  = 'BAPI'.
    ls_toolbar-icon      = ICON_SYSTEM_SAVE.
    ls_toolbar-butn_type = 0.
    ls_toolbar-text      = 'KAYDET'.
    ls_toolbar-quickinfo = 'KAYDET'.
    APPEND ls_toolbar TO e_object->mt_toolbar.

  ENDMETHOD.                    "handle_toolbar
  METHOD handle_user_command.
    CASE e_ucomm.
      WHEN 'BAPI'.

        PERFORM kaydet.
    ENDCASE.

  ENDMETHOD.                    "handle_user_command

ENDCLASS.                    "lcl_event_receiver IMPLEMENTATION
