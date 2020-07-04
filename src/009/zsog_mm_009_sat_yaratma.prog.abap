*&---------------------------------------------------------------------*
*& Report  ZSOG_MM_009_SAT_YARATMA
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZSOG_MM_009_SAT_YARATMA.

INCLUDE ZSOG_MM_009_TOP.
INCLUDE ZSOG_MM_009_C01.
INCLUDE ZSOG_MM_009_F01.
INCLUDE ZSOG_MM_009_001.
INCLUDE ZSOG_MM_009_I01.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f4_open_file.

AT SELECTION-SCREEN.
  PERFORM excel_control.
  IF sy-ucomm = 'CL1'.
    PERFORM excel_download_sample.
  ENDIF.

START-OF-SELECTION.
  PERFORM excel_upload.
  CHECK gv_error IS INITIAL.
  PERFORM controls.

  CALL SCREEN 0100.
