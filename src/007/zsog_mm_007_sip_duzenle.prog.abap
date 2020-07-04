*&---------------------------------------------------------------------*
*& Report  ZSOG_MM_007_TALEP_TAHMIN
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zsog_mm_007_sip_duzenle.

INCLUDE ZSOG_MM_007_SIP_DUZENLE_SCR.
*INCLUDE: zsog_mm_007_talep_tahmin_scr,
INCLUDE ZSOG_MM_007_SIP_DUZENLE_TOP.
*         zsog_mm_007_talep_tahmin_top,
INCLUDE ZSOG_MM_007_SIP_DUZENLE_F01.
*         zsog_mm_007_talep_tahmin_f01,
INCLUDE ZSOG_MM_007_SIP_DUZENLE_I01.
*         zsog_mm_007_talep_tahmin_i01,
INCLUDE ZSOG_MM_007_SIP_DUZENLE_O01.
*         zsog_mm_007_talep_tahmin_o01.

START-OF-SELECTION.

AT SELECTION-SCREEN OUTPUT.

  PERFORM modify_screen.

START-OF-SELECTION.

  IF gv_error NE 'X'.
    IF rb1 EQ 'X'.
      PERFORM sat_olustur.
    ELSEIF rb2 EQ 'X'.
      PERFORM create_dynamic_table USING 'ZSOG_MM_007_S_001'.
      PERFORM siparis_hesapla_duzenle.
    ELSEIF rb3 EQ 'X'.
      PERFORM create_dynamic_table USING 'ZSOG_MM_007_T_03'.
      PERFORM sas_olustur.
    ELSEIF rb4 EQ 'X'.
      PERFORM siparis_durum_raporu.
    ELSEIF rb5 EQ 'X'.
      PERFORM create_dynamic_table USING 'ZSOG_MM_007_S_004'.
      PERFORM satis_ve_fire_masraf_cikis.
    ENDIF.
  ENDIF.
