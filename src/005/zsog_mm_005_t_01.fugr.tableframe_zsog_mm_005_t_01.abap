*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZSOG_MM_005_T_01
*   generation date: 28.08.2019 at 11:00:47 by user XSTASKENT
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZSOG_MM_005_T_01   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
