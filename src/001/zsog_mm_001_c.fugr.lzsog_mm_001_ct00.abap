*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 07.08.2019 at 16:27:27 by user XOSAHIN
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZSOG_MM_001_C...................................*
DATA:  BEGIN OF STATUS_ZSOG_MM_001_C                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSOG_MM_001_C                 .
CONTROLS: TCTRL_ZSOG_MM_001_C
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZSOG_MM_001_C                 .
TABLES: ZSOG_MM_001_C                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
