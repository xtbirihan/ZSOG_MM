*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 30.07.2019 at 15:02:25 by user XTBIRIHAN
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZSOG_MM_007_T_05................................*
DATA:  BEGIN OF STATUS_ZSOG_MM_007_T_05              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSOG_MM_007_T_05              .
CONTROLS: TCTRL_ZSOG_MM_007_T_05
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZSOG_MM_007_T_05              .
TABLES: ZSOG_MM_007_T_05               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
