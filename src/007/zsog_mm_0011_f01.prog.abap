*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_0011_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data .
  CONSTANTS lv_charg TYPE c VALUE IS INITIAL.
  DATA lv_201 TYPE mseg-menge.
  DATA lv_202 TYPE mseg-menge.
*{   ->>> Added by Prodea Sefa Taşkent - 26.12.2019 10:45:24
DATA : lv_sf TYPE i.
*  }     <<<- End of  Added - 26.12.2019 10:45:24

  DATA: BEGIN OF ls_mseg,
    mblnr LIKE mseg-mblnr,
    mjahr LIKE mseg-mjahr,
    zeile LIKE mseg-zeile,
    matnr LIKE mseg-matnr,
    bwart LIKE mseg-bwart,
    menge LIKE mseg-menge,
    charg LIKE mseg-charg,
    END OF ls_mseg,
    lt_mseg LIKE TABLE OF ls_mseg.
  DATA : lt_mseg2 LIKE TABLE OF ls_mseg.

  DATA: BEGIN OF ls_mlz,
    matnr       LIKE mseg-matnr,
    END OF ls_mlz,
    lt_mlz LIKE TABLE OF ls_mlz.

IF sy-sysid EQ 'DHP'.
  ls_mlz-matnr = '000000000005045041'.
  APPEND ls_mlz TO lt_mlz.
  ls_mlz-matnr = '000000000005045043'.
  APPEND ls_mlz TO lt_mlz.
  ELSE.
  ls_mlz-matnr = '000000000005044977'.
  APPEND ls_mlz TO lt_mlz.
  ls_mlz-matnr = '000000000005044984'.
  APPEND ls_mlz TO lt_mlz.
  ENDIF.

*  ls_mlz-matnr = '000000000005044977'.
*  APPEND ls_mlz TO lt_mlz.
*  ls_mlz-matnr = '000000000005044984'.
*  APPEND ls_mlz TO lt_mlz.


  SELECT
    z07~matnr
    z13~game_no
    z13~retailer_no
    z13~no_of_sold_wagers
    z07~fire
    FROM zsg_t_013 AS z13
    INNER JOIN zsog_mm_007_t_01 AS z07 ON z13~game_no = z07~game_no
      INTO TABLE gt_out
    WHERE z13~game_no     IN s_gm_no
      AND z13~retailer_no IN s_rtl_no
      AND z13~max_date    IN s_max_d.

LOOP AT gt_out INTO gs_out.

  gs_out-fireli_satis = ( gs_out-no_of_sold_wagers / ( ( 100 - gs_out-fire ) / 100 ) ) - gs_out-no_of_sold_wagers.
  gs_out-fireli_satis = gs_out-fireli_satis + gs_out-no_of_sold_wagers.

  lv_sf = gs_out-fireli_satis.
  CLEAR gs_out-fireli_satis.
  gs_out-fireli_satis = lv_sf .

  MODIFY gt_out FROM gs_out TRANSPORTING fireli_satis.

ENDLOOP.


  SELECT mblnr mjahr mjahr matnr bwart menge charg
    FROM mseg
    INTO TABLE lt_mseg
    FOR ALL ENTRIES IN lt_mlz
    WHERE mjahr = sy-datum+0(4)
      AND ( bwart = '201' OR bwart = '202' )
      AND charg IN s_rtl_no
      AND werks = '2425'
      AND matnr = lt_mlz-matnr
       .

  CLEAR: gs_out, ls_mseg.
  LOOP AT gt_out INTO gs_out.

    LOOP AT lt_mseg INTO ls_mseg.
      IF gs_out-matnr = ls_mseg-matnr
        AND gs_out-retailer_no = ls_mseg-charg
        AND ls_mseg-bwart = '201'.
        lv_201 = lv_201 + ls_mseg-menge.
      ELSEIF gs_out-matnr = ls_mseg-matnr
     AND gs_out-retailer_no = ls_mseg-charg
     AND ls_mseg-bwart = '202'.
        lv_202 = lv_202 + ls_mseg-menge.
      ENDIF.
    ENDLOOP.

    gs_out-menge = lv_201 - lv_202.
    gs_out-fark  = gs_out-fireli_satis - gs_out-menge.
    MODIFY gt_out FROM gs_out TRANSPORTING menge fark.
    CLEAR: lv_201, lv_202.
  ENDLOOP.

ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      Form  SHOW_DATA
*&---------------------------------------------------------------------*
FORM show_data .
  CALL SCREEN 0100.
ENDFORM.                    " SHOW_DATA
*&---------------------------------------------------------------------*
*&      Form  SHOW_ALV
*&---------------------------------------------------------------------*
FORM show_alv .

  IF go_custom_container IS INITIAL.
    CREATE OBJECT go_custom_container
      EXPORTING
        container_name = go_container.

    CREATE OBJECT go_grid
      EXPORTING
        i_parent = go_custom_container.

*-Layout
    PERFORM build_layout.

*- Fieldcatalog
    PERFORM build_fcat .

*- Exclude Buttons
    PERFORM exclude_button CHANGING gt_exclude .

*-Alv Event
    PERFORM event_handler.

    CALL METHOD go_grid->set_table_for_first_display
      EXPORTING
        is_layout            = gs_layo100
        it_toolbar_excluding = gt_exclude
        is_variant           = gs_variant
        i_save               = 'A'
      CHANGING
        it_outtab            = gt_out[]
        it_fieldcatalog      = gt_fcat[].

**-Register event
    PERFORM register_event.
  ELSE .
    PERFORM check_changed_data    USING go_grid .
    PERFORM refresh_table_display USING go_grid .
  ENDIF.

ENDFORM.                    " SHOW_ALV
*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
FORM build_layout .

  CLEAR gs_layo100.
  gs_layo100-zebra      = 'X'.
  gs_layo100-cwidth_opt = 'X'.
  gs_layo100-sel_mode   = 'A'.
  gs_layo100-stylefname = 'FIELD_STYLE'.
  gs_layo100-info_fname = 'LINECOLOR'.
  gs_variant-report     = sy-repid .

ENDFORM.                    " BUILD_LAYOUT
*&---------------------------------------------------------------------*
*&      Form  BUILD_FCAT
*&---------------------------------------------------------------------*
FORM build_fcat .

  DATA:
      lt_kkblo_fieldcat TYPE kkblo_t_fieldcat,
      lv_repid          TYPE sy-repid.

  lv_repid = sy-repid.

*LVC_TRANSFER_FROM_SLIS
*REUSE_ALV_FIELDCATALOG_MERGE

  CALL FUNCTION 'K_KKB_FIELDCAT_MERGE'
    EXPORTING
      i_callback_program     = lv_repid
      i_tabname              = 'GS_OUT'
      i_inclname             = lv_repid
    CHANGING
      ct_fieldcat            = lt_kkblo_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      OTHERS                 = 2.
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE 'A' NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CLEAR gt_fcat[].
  CALL FUNCTION 'LVC_TRANSFER_FROM_KKBLO'
    EXPORTING
      it_fieldcat_kkblo = lt_kkblo_fieldcat
    IMPORTING
      et_fieldcat_lvc   = gt_fcat[]
    EXCEPTIONS
      it_data_missing   = 1
      OTHERS            = 2.
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE 'A' NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT gt_fcat INTO gs_fcat.
    gs_fcat-key = ' '.
    CASE gs_fcat-fieldname .
      WHEN 'RETAILER_NO'.
        gs_fcat-key  = ' '.
    ENDCASE.
    MODIFY gt_fcat FROM gs_fcat.
*    TRANSPORTING col_pos hotspot ....
  ENDLOOP.
ENDFORM.                    " BUILD_FCAT
*&---------------------------------------------------------------------*
*&      Form  EXCLUDE_BUTTON
*&---------------------------------------------------------------------*
FORM exclude_button CHANGING et_exclude TYPE ui_functions.

  DATA: ls_exclude LIKE LINE OF et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_detail.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy_row.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_delete_row.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_append_row.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_insert_row.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_move_row.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_cut.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_paste.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_paste_new_row.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_undo.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_print.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_check.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_views.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_graph.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_maintain_variant.
  APPEND ls_exclude TO et_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_refresh.
  APPEND ls_exclude TO et_exclude.

ENDFORM.                    " EXCLUDE_BUTTON
*&---------------------------------------------------------------------*
*&      Form  REGISTER_EVENT
*&---------------------------------------------------------------------*
FORM register_event .

  CALL METHOD go_grid->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_enter.

  CALL METHOD go_grid->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_modified.


ENDFORM.                    " REGISTER_EVENT
*&---------------------------------------------------------------------*
*&      Form  CHECK_CHANGED_DATA
*&---------------------------------------------------------------------*
FORM check_changed_data USING io_grid TYPE REF TO cl_gui_alv_grid .

  DATA: lv_valid TYPE c.

  CALL METHOD io_grid->check_changed_data
    IMPORTING
      e_valid = lv_valid.

ENDFORM.                    " CHECK_CHANGED_DATA
*&---------------------------------------------------------------------*
*&      Form  REFRESH_TABLE_DISPLAY
*&---------------------------------------------------------------------*
FORM refresh_table_display USING p_grid TYPE REF TO cl_gui_alv_grid.

  DATA : ls_stable TYPE lvc_s_stbl .

  ls_stable-row = 'X'.
  ls_stable-col = 'X'.
  CALL METHOD p_grid->refresh_table_display
    EXPORTING
      is_stable      = ls_stable
      i_soft_refresh = 'X'
    EXCEPTIONS
      finished       = 1
      OTHERS         = 2.

ENDFORM.                    " REFRESH_TABLE_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  EVENT_HANDLER
*&---------------------------------------------------------------------*
FORM event_handler .
  DATA: lcl_alv_event TYPE REF TO lcl_event_receiver.
  CREATE OBJECT lcl_alv_event.

  SET HANDLER lcl_alv_event->handle_toolbar      FOR go_grid.
  SET HANDLER lcl_alv_event->handle_user_command FOR go_grid.

ENDFORM.                    " EVENT_HANDLER
*&---------------------------------------------------------------------*
*&      Form  GONDER
*&---------------------------------------------------------------------*
FORM gonder .
*Bapi Data
  DATA: ls_goodsmvt_header  TYPE bapi2017_gm_head_01,
        ls_goodsmvt_code    TYPE bapi2017_gm_code,
        ls_goodsmvt_item    TYPE bapi2017_gm_item_create,
        lt_goodsmvt_item    TYPE TABLE OF bapi2017_gm_item_create,
        ls_return           TYPE  bapiret2,
        lt_return           TYPE TABLE OF bapiret2,
        ls_materialdocument TYPE bapi2017_gm_head_ret-mat_doc.

  DATA: BEGIN OF ls_out,
          matnr             LIKE mseg-matnr,
          game_no           LIKE zsg_t_013-game_no,
          retailer_no       LIKE zsg_t_013-retailer_no,
          no_of_sold_wagers LIKE zsg_t_013-no_of_sold_wagers,
          fire              LIKE zsog_mm_007_t_01-fire,
          fireli_satis      LIKE zsg_t_013-no_of_sold_wagers,
          menge             LIKE mseg-menge,
          fark              LIKE zsg_t_013-no_of_sold_wagers,
        END OF ls_out,
        lt_out LIKE TABLE OF ls_out.

  DATA: lt_rows TYPE lvc_t_row,
        ls_rows TYPE lvc_s_row.

  CALL METHOD go_grid->get_selected_rows
    IMPORTING
      et_index_rows = lt_rows.
  IF lt_rows IS INITIAL.
    MESSAGE s000(zay) WITH 'Satır seç' DISPLAY LIKE 'E'.
  ELSE.
    CLEAR: ls_goodsmvt_header, ls_goodsmvt_code.
    ls_goodsmvt_header-pstng_date = sy-datum.
    ls_goodsmvt_header-doc_date = sy-datum.
    ls_goodsmvt_header-ref_doc_no = 'SATIS-FIRE CIKIS'.
    ls_goodsmvt_code-gm_code   = '03'.

    LOOP AT lt_rows INTO ls_rows.
      CLEAR ls_out.
      READ TABLE gt_out INTO ls_out INDEX ls_rows-index.
      IF ls_out-fark <= 0.
        MESSAGE s104(mm) WITH 'Negatif tutar taşınamaz.'
         DISPLAY LIKE 'E'.
      ELSE.
        APPEND ls_out TO lt_out.
      ENDIF.

    ENDLOOP.

    CLEAR ls_out.
    LOOP AT lt_out INTO ls_out.
      CLEAR: lt_goodsmvt_item, ls_goodsmvt_item.
      ls_goodsmvt_item-material   = ls_out-matnr.
      ls_goodsmvt_item-plant      = '2425'.
      ls_goodsmvt_item-stge_loc   = 'D001'.
      ls_goodsmvt_item-batch      = ls_out-retailer_no.
      ls_goodsmvt_item-move_type  = '201'.
      ls_goodsmvt_item-entry_qnt  = ls_out-fark .
      ls_goodsmvt_item-entry_uom  = 'ST'.
      ls_goodsmvt_item-costcenter = '1002425001'.
      APPEND ls_goodsmvt_item TO lt_goodsmvt_item.


      CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
        EXPORTING
          goodsmvt_header  = ls_goodsmvt_header
          goodsmvt_code    = ls_goodsmvt_code
        IMPORTING
          materialdocument = ls_materialdocument
        TABLES
          goodsmvt_item    = lt_goodsmvt_item
          return           = lt_return.
      LOOP AT lt_return INTO ls_return WHERE type CA 'EAX'.
        EXIT.
      ENDLOOP.

      "hata yoksa
      IF sy-subrc NE 0.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.
        MESSAGE e104(zmm) WITH ls_out-retailer_no
        ' için BAPI Verileri Hatalı Çalıştı' INTO gv_dummy.
        PERFORM f_sys_add_bapiret2.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
        LOOP AT lt_return INTO ls_return WHERE type CA 'EAX'.
          MESSAGE ID ls_return-id
          TYPE    ls_return-type
          NUMBER  ls_return-number
          WITH
          ls_return-message_v1
          ls_return-message_v2
          ls_return-message_v3
          ls_return-message
          INTO gv_dummy.
          PERFORM f_sys_add_bapiret2.
        ENDLOOP.
        MESSAGE e104(zmm) WITH ls_out-retailer_no
        ' için BAPI Verileri Hatalı Çalıştı' INTO gv_dummy.
        PERFORM f_sys_add_bapiret2.
      ENDIF.
    ENDLOOP.
  ENDIF.

  PERFORM bastir CHANGING gt_message.
ENDFORM.                    " GONDER
*&---------------------------------------------------------------------*
*&      Form  BASTIR
*&---------------------------------------------------------------------*
FORM bastir CHANGING p_gt_message TYPE bapiret2_t.

  CHECK p_gt_message[] IS NOT INITIAL.
  CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
    EXPORTING
      it_message = p_gt_message[].

  CLEAR: p_gt_message, p_gt_message[].

ENDFORM.                    " BASTIR
*&---------------------------------------------------------------------*
*&      Form  F_SYS_ADD_BAPIRET2
*&---------------------------------------------------------------------*
FORM f_sys_add_bapiret2 .

  DATA: ls_return TYPE bapiret2.
  CALL FUNCTION 'FS_BAPI_BAPIRET2_FILL'
    EXPORTING
      type   = sy-msgty
      cl     = sy-msgid
      number = sy-msgno
      par1   = sy-msgv1
      par2   = sy-msgv2
      par3   = sy-msgv3
      par4   = sy-msgv4
    IMPORTING
      return = ls_return.
  APPEND ls_return TO gt_message.

ENDFORM.                    " F_SYS_ADD_BAPIRET2
