*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_0011_TOP
*&---------------------------------------------------------------------*
TABLES: zsg_t_013, zsog_mm_007_t_01.

DATA ok_code TYPE sy-ucomm.

*-Ekrana basılacak alv
DATA: BEGIN OF gs_out,
        matnr             LIKE mseg-matnr,
        game_no           LIKE zsg_t_013-game_no,
        retailer_no       LIKE zsg_t_013-retailer_no,
        no_of_sold_wagers LIKE zsg_t_013-no_of_sold_wagers,
        fire              LIKE zsog_mm_007_t_01-fire,
        fireli_satis      LIKE zsg_t_013-no_of_sold_wagers,
        menge             LIKE mseg-menge,
        fark              LIKE zsg_t_013-no_of_sold_wagers,
      END OF gs_out,
      gt_out LIKE TABLE OF gs_out.

*-Data Bapi
DATA : gt_message TYPE bapiret2_t.
DATA : gv_dummy TYPE c.

*-data alv tanimlamalari
DATA:
go_container        TYPE scrfname VALUE 'CONT100',
go_grid             TYPE REF TO cl_gui_alv_grid,
go_custom_container TYPE REF TO cl_gui_custom_container,
gs_layo100          TYPE lvc_s_layo,
gt_fcat             TYPE lvc_t_fcat,
gs_fcat             TYPE lvc_s_fcat,
gt_exclude          TYPE ui_functions,
gs_exclude          TYPE ui_func,
gs_variant          TYPE disvariant.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

SELECT-OPTIONS: s_rtl_no   FOR zsg_t_013-retailer_no,
                s_gm_no    FOR zsg_t_013-game_no,
                s_max_d    FOR zsg_t_013-max_date.

SELECTION-SCREEN END OF BLOCK b1.
