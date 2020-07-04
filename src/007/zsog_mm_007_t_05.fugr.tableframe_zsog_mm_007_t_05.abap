*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZSOG_MM_007_T_05
*   generation date: 30.07.2019 at 15:02:25 by user XTBIRIHAN
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZSOG_MM_007_T_05   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
