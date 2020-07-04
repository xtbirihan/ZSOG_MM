*&---------------------------------------------------------------------*
*& Report  ZSOG_MM_006_CARGO_QRY
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZSOG_MM_006_CARGO_QRY.

INCLUDE: ZSOG_MM_006_CARGO_QRY_SS,
         ZSOG_MM_006_CARGO_QRY_TOP,
         ZSOG_MM_006_CARGO_QRY_F01.

START-OF-SELECTION.
PERFORM get_data.
