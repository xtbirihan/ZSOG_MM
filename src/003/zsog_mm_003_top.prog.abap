*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_003_TOP
*&---------------------------------------------------------------------*
TABLES: eket, ekko.
*-Data Alv Out
DATA: BEGIN OF gs_out,
        ebeln   LIKE ekko-ebeln,
        name1   LIKE lfa1-name1,
        stcd1   LIKE lfa1-stcd1,
        stcd2   LIKE lfa1-stcd2,
        slfdt   LIKE eket-slfdt,
      END OF gs_out,
      gt_out LIKE TABLE OF gs_out.

DATA: BEGIN OF gs_kalem,
        ebeln     LIKE ekko-ebeln,
        matnr     LIKE eban-matnr,
        maktx     LIKE makt-maktx,
        menge     LIKE eket-menge,
        meins     LIKE ekpo-meins,
        name1     LIKE lfa1-name1,
        netpr     LIKE ekpo-netpr,
        waers     LIKE ekko-waers,
        slfdt     LIKE eket-slfdt,
        t_fiyat   LIKE ekpo-netpr,
        t_waers   LIKE ekko-waers,
        teklif_no TYPE i,
      END OF gs_kalem,
      gt_kalem LIKE TABLE OF gs_kalem.

*-Data Global
DATA: "gv_error TYPE c."hata kontrolleri için
      ok_code TYPE sy-ucomm.

*-Data Alv
DATA: "go_container        TYPE scrfname VALUE 'CONT100',
      go_grid             TYPE REF TO cl_gui_alv_grid,
      go_custom_container TYPE REF TO cl_gui_custom_container,
      gs_layo100          TYPE lvc_s_layo,
      gt_fcat             TYPE lvc_t_fcat,
      gs_fcat             TYPE lvc_s_fcat,
      gt_sort             TYPE lvc_t_sort,
      gs_sort             TYPE lvc_s_sort,
      gt_exclude          TYPE ui_functions,
      gs_exclude          TYPE ui_func,
      gs_variant          TYPE disvariant.

***** Kalem Alv
DATA: "go_container2        TYPE scrfname VALUE 'CONT200',
      go_grid2             TYPE REF TO cl_gui_alv_grid,
      go_custom_container2 TYPE REF TO cl_gui_custom_container,
      gs_layo200           TYPE lvc_s_layo,
      gt_fcat2             TYPE lvc_t_fcat,
      gs_fcat2             TYPE lvc_s_fcat,
      gt_sort2             TYPE lvc_t_sort,
      gs_sort2             TYPE lvc_s_sort,
      gt_exclude2          TYPE ui_functions,
      gs_exclude2          TYPE ui_func,
      gs_variant2          TYPE disvariant.

**** splitter
DATA:
  gv_repid         TYPE syst-repid,
  go_docking       TYPE REF TO cl_gui_docking_container,
  go_docking2      TYPE REF TO cl_gui_docking_container,
  go_splitter      TYPE REF TO cl_gui_splitter_container,
  go_splitter2     TYPE REF TO cl_gui_splitter_container,
  go_cell_top      TYPE REF TO cl_gui_container,
  go_cell_bottom   TYPE REF TO cl_gui_container.

DATA: gv_dummy TYPE sy-ucomm..

SELECT-OPTIONS s_ebeln  FOR eket-ebeln OBLIGATORY.
PARAMETERS:    p_bukrs TYPE ekko-bukrs OBLIGATORY.
SELECT-OPTIONS s_submi  FOR ekko-submi NO INTERVALS NO-EXTENSION OBLIGATORY.
