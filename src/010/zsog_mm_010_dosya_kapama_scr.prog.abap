*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_010_DOSYA_KAPAMA_SCR
*&---------------------------------------------------------------------*
TABLES: lfa1, bsik.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: s_lifnr  FOR lfa1-lifnr NO-EXTENSION NO INTERVALS OBLIGATORY,
                s_budat  FOR bsik-budat NO-EXTENSION NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b1.
