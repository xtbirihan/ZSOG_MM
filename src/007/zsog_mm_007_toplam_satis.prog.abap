*&---------------------------------------------------------------------*
*& Report  ZSOG_MM_007_TOPLAM_SATIS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zsog_mm_007_toplam_satis.

INCLUDE: zsog_mm_007_toplam_satis_ss,
         zsog_mm_007_toplam_satis_f01.

START-OF-SELECTION.
  PERFORM fill_totals.
