*&---------------------------------------------------------------------*
*& Report  ZSOG_MM_011_ITHLT_DOSYA_KAPAMA
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZSOG_MM_011_ITHLT_DOSYA_KAPAMA.

INCLUDE ZSOG_MM_011_TOP.
INCLUDE ZSOG_MM_011_F01.
INCLUDE ZSOG_MM_011_I01.
INCLUDE ZSOG_MM_011_O01.


START-OF-SELECTION.
PERFORM GET_DATA.

CALL SCREEN 0100.
