*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_007_TALEP_TAHMIN_SCR
*&---------------------------------------------------------------------*
TABLES: eban, kna1, mara.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: s_badat FOR eban-badat MODIF ID m2,
                s_kunnr FOR kna1-kunnr MODIF ID m1,
                s_matnr FOR mara-matnr MODIF ID m1.
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME  TITLE text-002.
PARAMETERS : rb1 RADIOBUTTON GROUP g1 "DEFAULT 'X'
             USER-COMMAND rb
             MODIF ID m4,
             rb2 RADIOBUTTON GROUP g1 MODIF ID m5,
             rb3 RADIOBUTTON GROUP g1 MODIF ID m6,
             rb4 RADIOBUTTON GROUP g1 MODIF ID m7,
             rb5 RADIOBUTTON GROUP g1 MODIF ID m4.
SELECTION-SCREEN SKIP 1.
*PARAMETERS cb1  AS CHECKBOX MODIF ID M3.
*PARAMETERS cb2  AS CHECKBOX MODIF ID M3.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF BLOCK b1.
