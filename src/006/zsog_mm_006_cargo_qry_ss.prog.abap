*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_006_CARGO_QRY_SS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_006_CARGO_SS
*&---------------------------------------------------------------------*
TABLES: ekko, eban, lfa1.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: s_bedat FOR ekko-bedat OBLIGATORY.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.
PARAMETERS: ch1 AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF BLOCK b1.
