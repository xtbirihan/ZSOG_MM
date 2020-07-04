*&---------------------------------------------------------------------*
*& Report  ZSOG_MM_0011
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZSOG_MM_0011.

INCLUDE ZSOG_MM_0011_top.
INCLUDE ZSOG_MM_0011_c01.
INCLUDE ZSOG_MM_0011_f01.
INCLUDE ZSOG_MM_0011_o01.
INCLUDE ZSOG_MM_0011_i01.

START-OF-SELECTION.
  PERFORM get_data.

END-OF-SELECTION.
  PERFORM show_data.
