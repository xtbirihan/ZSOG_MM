*&---------------------------------------------------------------------*
*& Report  ZSOG_MM_017_MASRAF_CIKIS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZSOG_MM_017_MASRAF_CIKIS.

INCLUDE: ZSOG_MM_017_TOP,
         ZSOG_MM_017_C01,
         ZSOG_MM_017_F01,
         ZSOG_MM_017_001,
         ZSOG_MM_017_I01.


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
END-OF-SELECTION.
  CALL SCREEN 0100.
