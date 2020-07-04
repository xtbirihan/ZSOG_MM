************************************************************************
*        Datenbeschaffung fuer Einkaufsbelegdruck                      *
************************************************************************
* 72307 09.04.1997 3.1H CF
* 82403 10.10.1997 3.1I CF
* 88301 14.01.1998 3.1I RB

*  INCLUDE FM06PF01_LESEN .  " LESEN
  INCLUDE zfm06pf01_lesen .  " LESEN

  INCLUDE fm06pf01_lesen_kopf_druck .  " LESEN_KOPF_DRUCK

  INCLUDE fm06pf01_lesen_aenderungen .  " LESEN_AENDERUNGEN

  INCLUDE zfm06pf01_pos_zusatzdaten .  " POS_ZUSATZDATEN

  INCLUDE fm06pf01_lesen_ttxit .  " LESEN_TTXIT

  INCLUDE fm06pf01_lesen_qm_documents .  " LESEN_QM_DOCUMENTS


  INCLUDE fm06pf01_varianten_daten .  " VARIANTEN_DATEN

  INCLUDE fm06pf01_tmsi2_lesen .  " TMSI2_LESEN

  INCLUDE fm06pf01_pos_ausgeben .  " POS_AUSGEBEN
  INCLUDE fm06pf01_eket_ekes_abmischen .  " EKET_EKES_ABMISCHEN
