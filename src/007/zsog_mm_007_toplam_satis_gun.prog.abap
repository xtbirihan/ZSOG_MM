*&---------------------------------------------------------------------*
*& Report  ZSOG_MM_007_TOPLAM_SATIS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zsog_mm_007_toplam_satis_gun.

INCLUDE zsog_mm_007_toplam_satis_g_ss.
INCLUDE zsog_mm_007_toplam_satis_g_f01.

START-OF-SELECTION.
  PERFORM fill_totals.
