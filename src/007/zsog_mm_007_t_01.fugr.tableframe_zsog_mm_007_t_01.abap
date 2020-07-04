*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZSOG_MM_007_T_01
*   generation date: 10.01.2020 at 12:04:31 by user XBALTUNBAS
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZSOG_MM_007_T_01   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
