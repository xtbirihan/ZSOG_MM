*&---------------------------------------------------------------------*
*  ABAP Name     : ZSOG_MM_015_KARGO_MAL_GIRISI
*  Job-Name      :
*  Author        : Burcu Hilal Altunbaş
*  e-mail        : burcu.altunbas@prodea.com.tr
*  GMP relevant  : Mustafa Özüarı
*  Date          : 30.08.2019
*  Description   : Teslim Edilen Kargo Mal Girişi
*&---------------------------------------------------------------------*
REPORT zsog_mm_015_kargo_mal_girisi.

INCLUDE zsog_mm_015_kargo_mg_t01.
INCLUDE zsog_mm_015_kargo_mg_f01.
INCLUDE zsog_mm_015_kargo_mg_o01.
INCLUDE zsog_mm_015_kargo_mg_i01.

initialization.

start-of-selection.
perform get_data.
call screen 0100.
