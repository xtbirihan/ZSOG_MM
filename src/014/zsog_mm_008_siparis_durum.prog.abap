*&---------------------------------------------------------------------*
*& Report  ZSOG_MM_008_SIPARIS_DURUM
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zsog_mm_008_siparis_durum.

INCLUDE zsog_mm_008_top.
INCLUDE zsog_mm_008_f01.
INCLUDE zsog_mm_008_i01.
INCLUDE zsog_mm_008_o01.

START-OF-SELECTION.

  PERFORM get_data.

  CALL SCREEN 0100.
