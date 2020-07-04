*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 09.04.2020 at 11:29:07 by user XINACAR
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZSOG_MM_019_T_01................................*
DATA:  BEGIN OF STATUS_ZSOG_MM_019_T_01              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSOG_MM_019_T_01              .
CONTROLS: TCTRL_ZSOG_MM_019_T_01
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZSOG_MM_019_T_01              .
TABLES: ZSOG_MM_019_T_01               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
