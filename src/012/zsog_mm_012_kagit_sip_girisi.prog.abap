*&---------------------------------------------------------------------*
*  ABAP Name     : ZSOG_MM_012_KAGIT_SIP_GIRISI
*  Job-Name      :
*  Author        : Sefa Taşkent
*  e-mail        : sefa.taskent@prodea.com.tr
*  GMP relevant  : Fırat Okçuoğlu
*  Date          : 23.08.2019
*  Description   : Kağıt Sipariş Mal Girişi Programı
*&---------------------------------------------------------------------*

REPORT zsog_mm_012_kagit_sip_girisi.

INCLUDE zsog_mm_012_kagit_sip_t01.
INCLUDE zsog_mm_012_kagit_sip_c01.
INCLUDE zsog_mm_012_kagit_sip_f01.
INCLUDE zsog_mm_012_kagit_sip_o01.
INCLUDE zsog_mm_012_kagit_sip_i01.

INITIALIZATION.

START-OF-SELECTION.
  PERFORM get_data.
end-of-SELECTION.
  PERFORM show_data.
