*&---------------------------------------------------------------------*
*& Report  ZSOG_MM_0012
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zsog_mm_0012.

INCLUDE zsog_mm_0012_top.
INCLUDE zsog_mm_0012_c01.
INCLUDE zsog_mm_0012_f01.
INCLUDE zsog_mm_0012_i01.
INCLUDE zsog_mm_0012_o01.

START-OF-SELECTION.
  PERFORM get_data.
  CALL SCREEN 0100.
