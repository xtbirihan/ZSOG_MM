*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZSOG_MM_019_T_01
*   generation date: 09.04.2020 at 11:29:07 by user XINACAR
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZSOG_MM_019_T_01   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
