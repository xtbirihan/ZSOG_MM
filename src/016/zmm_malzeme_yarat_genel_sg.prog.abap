*&---------------------------------------------------------------------*
*& REPORT  ZMM_MALZEME_YARAT_GENEL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZMM_MALZEME_YARAT_GENEL_SG.

INCLUDE ZMM_MALZEME_YARAT_GENEL_SG_TOP.
*INCLUDE ZMM_MALZEME_YARAT_GENEL_TOP.
INCLUDE ZMM_MALZEME_YARAT_GENEL_SG_F01.
*INCLUDE ZMM_MALZEME_YARAT_GENEL_F01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
PERFORM F4_FILENAME.


START-OF-SELECTION.
PERFORM CONVERT_XLS_TO_SAP.
CHECK Gt_excel[] IS NOT INITIAL.
PERFORM MAT_CREATE.
