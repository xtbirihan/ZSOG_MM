*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZSOG_MM_006_T_01
*   generation date: 31.07.2019 at 14:02:17 by user XTBIRIHAN
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZSOG_MM_006_T_01   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
