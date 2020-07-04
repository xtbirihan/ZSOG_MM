*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_007_TALEP_TAHMIN_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_1903  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_1903 OUTPUT.
  PERFORM status_1903.
ENDMODULE.                    "status_1903 OUTPUT
*&---------------------------------------------------------------------*
*&      Form  STATUS_1903
*&---------------------------------------------------------------------*
FORM status_1903 .
  DATA: lv_structure_name TYPE dd02l-tabname.
  IF rb2 EQ 'X'.
    SET TITLEBAR 'TITLE_100' OF PROGRAM sy-repid WITH text-003.
*    SET TITLEBAR 'TITLE_100'.
    lv_structure_name = 'ZSOG_MM_007_S_001'.
  ELSEIF rb3 EQ 'X'.
    SET TITLEBAR 'TITLE_100' OF PROGRAM sy-repid WITH text-005.
    lv_structure_name = 'ZSOG_MM_007_T_03'.
  ELSEIF rb5 EQ 'X'.
    SET TITLEBAR 'TITLE_100' OF PROGRAM sy-repid WITH text-008.
    lv_structure_name = 'ZSOG_MM_007_S_004'.
  ENDIF.
  PERFORM set_fieldcat USING lv_structure_name.
  PERFORM exclude_tb_functions CHANGING gs_scr-1903-exclude.
  SET PF-STATUS 'STANDARD_FULLSCREEN'.
  PERFORM display_alv_grid USING lv_structure_name .
ENDFORM.                    "status_1903
