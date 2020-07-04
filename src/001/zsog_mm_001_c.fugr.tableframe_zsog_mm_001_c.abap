*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZSOG_MM_001_C
*   generation date: 07.08.2019 at 16:27:26 by user XOSAHIN
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZSOG_MM_001_C      .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
