*&---------------------------------------------------------------------*
*& Report  ZSOG_MM_003
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZSOG_MM_003.

INCLUDE ZSOG_MM_003_top.
INCLUDE ZSOG_MM_003_c01.
INCLUDE ZSOG_MM_003_o01.
INCLUDE ZSOG_MM_003_i01.
INCLUDE ZSOG_MM_003_f01.

START-OF-SELECTION.
  PERFORM get_data.

END-OF-SELECTION.
  PERFORM show_data.
