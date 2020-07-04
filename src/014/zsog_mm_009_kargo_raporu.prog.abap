*&---------------------------------------------------------------------*
*& Report  ZSOG_MM_009_KARGO_RAPORU
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zsog_mm_009_kargo_raporu.

INCLUDE zsog_mm_009_kargo_top.
INCLUDE zsog_mm_009_kargo_f01.
INCLUDE zsog_mm_009_kargo_i01.
INCLUDE zsog_mm_009_kargo_o01.



START-OF-SELECTION.

  PERFORM get_data.

   CALL SCREEN 0100.
