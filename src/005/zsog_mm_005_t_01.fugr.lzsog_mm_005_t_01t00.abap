*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 28.08.2019 at 11:00:47 by user XSTASKENT
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZSOG_MM_005_T_01................................*
DATA:  BEGIN OF STATUS_ZSOG_MM_005_T_01              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSOG_MM_005_T_01              .
CONTROLS: TCTRL_ZSOG_MM_005_T_01
            TYPE TABLEVIEW USING SCREEN '0003'.
*.........table declarations:.................................*
TABLES: *ZSOG_MM_005_T_01              .
TABLES: ZSOG_MM_005_T_01               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
