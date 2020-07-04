*&---------------------------------------------------------------------*
*& Report  ZSOG_MM_019_QUERYSHIPMENT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zsog_mm_019_queryshipment.


INCLUDE zsog_mm_019_queryshipment_top.
INCLUDE zsog_mm_019_queryshipment_c01.
INCLUDE zsog_mm_019_queryshipment_f01.
INCLUDE zsog_mm_019_queryshipment_o01.
INCLUDE zsog_mm_019_queryshipment_i01.

START-OF-SELECTION.
  PERFORM get_data.
