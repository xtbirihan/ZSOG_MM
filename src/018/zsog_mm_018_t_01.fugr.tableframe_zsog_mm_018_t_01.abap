*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZSOG_MM_018_T_01
*   generation date: 22.06.2020 at 17:08:23 by user DEMIRORENP1
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZSOG_MM_018_T_01   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
