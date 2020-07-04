*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 28.06.2019 at 11:33:19 by user XTBIRIHAN
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZSOG_MM_007_T_04................................*
DATA:  BEGIN OF STATUS_ZSOG_MM_007_T_04              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSOG_MM_007_T_04              .
CONTROLS: TCTRL_ZSOG_MM_007_T_04
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZSOG_MM_007_T_04              .
TABLES: ZSOG_MM_007_T_04               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
