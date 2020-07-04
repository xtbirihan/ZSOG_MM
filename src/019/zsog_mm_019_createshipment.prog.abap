*&---------------------------------------------------------------------*
*& Report  ZSOG_MM_019_CREATESHIPMENT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zsog_mm_019_createshipment.


INCLUDE zsog_mm_019_createshipment_top.
INCLUDE zsog_mm_019_createshipment_c01.
INCLUDE zsog_mm_019_createshipment_f01.
INCLUDE zsog_mm_019_createshipment_o01.
INCLUDE zsog_mm_019_createshipment_i01.

START-OF-SELECTION.
  PERFORM get_data.
