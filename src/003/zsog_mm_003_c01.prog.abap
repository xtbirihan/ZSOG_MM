*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_003_C01
*&---------------------------------------------------------------------*
CLASS lcl_event_receiver DEFINITION DEFERRED.
*CLASS cl_gui_container DEFINITION LOAD.
DATA: go_eventreceiver    TYPE REF TO lcl_event_receiver.
*----------------------------------------------------------------------

*       CLASS lcl_event_receiver DEFINITION
*----------------------------------------------------------------------

CLASS lcl_event_receiver DEFINITION.
  PUBLIC SECTION.
    METHODS:

*      handle_data_changed
*                    FOR EVENT data_changed OF cl_gui_alv_grid
*        IMPORTING er_data_changed e_onf4 e_ucomm sender,
"     Deal with user action
      handle_user_command
                    FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm sender,
*     Link click
      hotspot_click
                    FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id e_column_id es_row_no,
*      handle_double_click
*                    FOR EVENT double_click OF cl_gui_alv_grid
*        IMPORTING e_row e_column,
     handle_toolbar
                    FOR EVENT toolbar      OF cl_gui_alv_grid
        IMPORTING e_object e_interactive.


  PRIVATE SECTION.
    DATA: dialogbox_status TYPE c.  "'X': does exist, SPACE: does not ex.
ENDCLASS.                    "lcl_event_receiver DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_event_receiver IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_event_receiver IMPLEMENTATION.

  METHOD hotspot_click.
    CHECK e_row_id IS NOT INITIAL.
*****--> Kalem ALV
    READ TABLE gt_out INTO gs_out INDEX e_row_id-index.
    PERFORM get_item_hotspt.

*****<-- Kalem ALV
    PERFORM check_changed_data    USING go_grid2 .
    PERFORM refresh_table_display USING go_grid2 .
*****<-- Kalem ALV


  ENDMETHOD.                    "hotspot_click                      .

  METHOD handle_user_command.

    CASE e_ucomm.
      WHEN 'PDF_D'.
        PERFORM pdf_indir.
    ENDCASE.
  ENDMETHOD.                           "handle_user_command
* METHOD handle_data_changed.
*
*    DATA: ls_good        TYPE lvc_s_modi, "C
*          lv_error       TYPE c,
*          lv_matnr       LIKE gs_out-matnr,
*          lv_length      TYPE i,
*          lv_type        TYPE dd01v-datatype. " numeric control.
*
*    "C
*    LOOP AT er_data_changed->mt_mod_cells INTO ls_good.
*      CLEAR lv_error.
*
*      CASE ls_good-fieldname.
*        WHEN 'MATNR'.
*          CLEAR: gs_out, lv_length.
*          READ TABLE gt_out INTO gs_out INDEX ls_good-row_id.
*          IF sy-subrc = 0.
*            "C
*            CLEAR lv_matnr.
*
*            CALL METHOD er_data_changed->get_cell_value
*              EXPORTING
*                i_row_id    = ls_good-row_id
*                i_fieldname = ls_good-fieldname
*              IMPORTING
*                e_value     = lv_matnr.
*
*            gs_out-matnr = lv_matnr.
*
*            lv_length = strlen( gs_out-matnr ).
*            SELECT SINGLE COUNT(*)
*              FROM  mara
*              WHERE matnr = gs_out-matnr.
*            IF sy-subrc <> 0.
*              lv_error = 'X'.
*            ENDIF.
*
*            IF lv_error = 'X'.
*              CALL METHOD er_data_changed->add_protocol_entry
*                EXPORTING
*                  i_msgid     = 'ZMM'
*                  i_msgty     = 'E'
*                  i_msgno     = '023'
*                  i_fieldname = ls_good-fieldname
*                  i_row_id    = ls_good-row_id
*                  i_tabix     = ls_good-tabix.
*              CLEAR gs_out-matnr.
*            ELSEIF lv_length <> 18.
*              CALL METHOD er_data_changed->add_protocol_entry
*                EXPORTING
*                  i_msgid     = 'ZMM'
*                  i_msgty     = 'E'
*                  i_msgno     = '003'
*                  i_fieldname = ls_good-fieldname
*                  i_row_id    = ls_good-row_id
*                  i_tabix     = ls_good-tabix.
*              CLEAR gs_out-matnr.
*            ENDIF.
*
*            MODIFY gt_out FROM gs_out INDEX ls_good-row_id TRANSPORTING
* matnr.
*            IF lv_error = 'X'.
*              EXIT.
*            ENDIF.
*          ENDIF.
*
*
*      ENDCASE.
*    ENDLOOP.
*    IF lv_error = 'X'.
*      CALL METHOD er_data_changed->display_protocol.
*    ENDIF.
*    PERFORM refresh_table_display USING go_grid .
***
***            CALL METHOD er_data_changed->modify_cell
***              EXPORTING
***                i_row_id    = ls_good-row_id
***                i_fieldname = ls_good-fieldname
***                i_value     = lv_value.
*
*
*  ENDMETHOD.
  METHOD handle_toolbar.

    DATA: ls_toolbar  TYPE stb_button.

* append a separator to normal toolbar
    CLEAR ls_toolbar.
    MOVE 3 TO ls_toolbar-butn_type.
    APPEND ls_toolbar TO e_object->mt_toolbar.
* append an icon to show booking table
    CLEAR ls_toolbar.
    MOVE 'PDF_D'          TO ls_toolbar-function.
    MOVE 'PDF İndir'(111) TO ls_toolbar-quickinfo.
    MOVE 'PDF İndir'(112) TO ls_toolbar-text.
    MOVE icon_pdf         TO ls_toolbar-icon.
    MOVE ' '           TO ls_toolbar-disabled.
    APPEND ls_toolbar  TO e_object->mt_toolbar.

  ENDMETHOD.                    "handle_toolbar

ENDCLASS.                    "lcl_event_receiver IMPLEMENTATION
*
