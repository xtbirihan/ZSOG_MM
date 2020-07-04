*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_012_KAGIT_SIP_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*

FORM GET_DATA .

  data : BEGIN OF ls_mseg,
         ebeln TYPE ekko-ebeln,
         ebelp TYPE ekpo-ebelp,
         END OF ls_mseg,
         lt_mseg LIKE TABLE OF ls_mseg.

  DATA : lt_out LIKE gt_out,
         ls_out LIKE gs_out.

  SELECT ekko~ebeln
         ekpo~ebelp
         makt~matnr
         makt~maktx
         t001w~werks
         t001w~name1
         t001l~lgort
         t001l~lgobe
         eban~afnam
         eban~menge
         eban~meins
         eban~banfn
         eban~bnfpo
         ekko~bedat
      FROM ekko

      INNER JOIN ekpo on ekko~ebeln = ekpo~ebeln
                     and ekpo~loekz = ''
      INNER JOIN eket on ekpo~ebeln = eket~ebeln
                     and ekpo~ebelp = eket~ebelp
      inner JOIN eban on eban~banfn = eket~banfn
                          and eban~bnfpo = eket~bnfpo
      left OUTER JOIN t001w on t001w~werks = ekpo~werks
      LEFT OUTER JOIN makt on makt~matnr = ekpo~matnr
                          and makt~spras = sy-langu
      INNER JOIN mara on mara~matnr = makt~matnr
      LEFT OUTER JOIN t001l on t001l~werks = ekpo~werks
                           and t001l~lgort = ekpo~lgort
      into TABLE lt_out
      WHERE ekko~ebeln in s_ebeln
        and ekpo~matnr in s_matnr
        and eban~afnam in s_kunnr.

*  IF lt_out is NOT INITIAL.
*
*    SELECT ebeln ebelp
*        FROM mseg
*        into TABLE lt_mseg
*        FOR ALL ENTRIES IN lt_out
*        WHERE mseg~ebeln = lt_out-ebeln
*          and mseg~ebelp = lt_out-ebelp.
*
*  ENDIF.

  CLEAR : ls_out,ls_mseg.
  LOOP AT lt_out INTO ls_out.
    CLEAR : gs_out.
    READ TABLE lt_mseg INTO ls_mseg
                       with KEY ebeln = ls_out-ebeln
                                ebelp = ls_out-ebelp.
    IF sy-subrc ne 0.

      MOVE-CORRESPONDING ls_out to gs_out.
      APPEND gs_out to gt_out.

    ENDIF.
  ENDLOOP.

  IF ch1 = 'X'.
    CLEAR gs_out.
    LOOP AT gt_out INTO gs_out.
      gs_out-ch1 = 'X'.
      MODIFY gt_out FROM gs_out TRANSPORTING ch1.
    ENDLOOP.
    data : lt_ch1 like gt_out,
           ls_ch1 LIKE gs_out.
    LOOP AT gt_out INTO gs_out WHERE ch1 = 'X'.

      MOVE-CORRESPONDING gs_out to ls_ch1.
      APPEND ls_ch1 to lt_ch1.

    ENDLOOP.

    PERFORM KAYDET2 TABLES lt_ch1.

  ENDIF.

ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      Form  SHOW_DATA
*&---------------------------------------------------------------------*

FORM SHOW_DATA .
  call SCREEN 0100.
ENDFORM.                    " SHOW_DATA
*&---------------------------------------------------------------------*
*&      Form  SHOW_ALV
*&---------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SHOW_ALV .

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

**-Alv Event
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

    CALL METHOD go_grid->set_toolbar_interactive.

    CALL METHOD go_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified.


*-Register event
*    PERFORM register_event.
  ELSE .
    PERFORM check_changed_data    USING go_grid .
    PERFORM refresh_table_display USING go_grid .
  ENDIF.


ENDFORM.                    " SHOW_ALV
*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BUILD_LAYOUT .

  CLEAR gs_layo100.
  gs_layo100-zebra      = 'X'."ilk satır koyu ikinci satır açık
  gs_layo100-cwidth_opt = 'X'."kolonların uzunluklarını optimize et
  gs_layo100-sel_mode   = 'A'."hücrelerin seçilebilme kriteri
  gs_variant-report     = sy-repid .
*  gs_layo100-stylefname = 'FIELD_STYLE'."opsiyonel
*  gs_layo100-info_fname = 'LINECOLOR'.  "opsiyonel

ENDFORM.                    " BUILD_LAYOUT
*&---------------------------------------------------------------------*
*&      Form  BUILD_FCAT
*&---------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BUILD_FCAT .

  Clear : gt_fcat  , gs_fcat.
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZSOG_MM_012_S_001'
    CHANGING
      ct_fieldcat            = gt_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      others                 = 3.
  if sy-subrc <> 0.
  endif.

  LOOP AT gt_fcat INTO gs_fcat.
    CASE gs_fcat-fieldname.
      WHEN 'BAPI_FLAG'.
        gs_fcat-no_out = 'X'.
    ENDCASE.
    MODIFY gt_fcat FROM gs_fcat.
  ENDLOOP.

ENDFORM.                    " BUILD_FCAT
*&---------------------------------------------------------------------*
*&      Form  EXCLUDE_BUTTON
*&---------------------------------------------------------------------*
*      <--P_GT_EXCLUDE  text
*----------------------------------------------------------------------*
FORM EXCLUDE_BUTTON  CHANGING et_exclude TYPE ui_functions..

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
*&      Form  EVENT_HANDLER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM EVENT_HANDLER .
  DATA: lcl_alv_event TYPE REF TO lcl_event_receiver.
  CREATE OBJECT lcl_alv_event.

  SET HANDLER lcl_alv_event->handle_toolbar      FOR go_grid.
  SET HANDLER lcl_alv_event->handle_user_command FOR go_grid.
ENDFORM.                    " EVENT_HANDLER
*&---------------------------------------------------------------------*
*&      Form  CHECK_CHANGED_DATA
*&---------------------------------------------------------------------*
*      -->P_GO_GRID  text
*----------------------------------------------------------------------*
FORM CHECK_CHANGED_DATA  USING    P_GO_GRID TYPE REF TO
cl_gui_alv_grid ..

  DATA: lv_valid TYPE c.

  CALL METHOD P_GO_GRID->check_changed_data
    IMPORTING
      e_valid = lv_valid.

ENDFORM.                    " CHECK_CHANGED_DATA
*&---------------------------------------------------------------------*
*&      Form  REFRESH_TABLE_DISPLAY
*&---------------------------------------------------------------------*
*      -->P_GO_GRID  text
*----------------------------------------------------------------------*
FORM REFRESH_TABLE_DISPLAY  USING GO_GRID TYPE REF TO
cl_gui_alv_grid.
  DATA : ls_stable TYPE lvc_s_stbl .

  ls_stable-row = 'X'.
  ls_stable-col = 'X'.
  CALL METHOD go_grid->refresh_table_display
    EXPORTING
      is_stable      = ls_stable
      i_soft_refresh = 'X'
    EXCEPTIONS
      finished       = 1
      OTHERS         = 2.

ENDFORM.                    " REFRESH_TABLE_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  BAPI_OLUSTUR
*&---------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM KAYDET.
*-Alv güncellemek için data tanımamaları
  DATA : lt_out like gt_out,
         ls_out LIKE gs_out.

  ""Bapi DATA
  DATA: ls_header    TYPE bapi2017_gm_head_01,
        ls_code      TYPE bapi2017_gm_code,
        ls_mdocument TYPE bapi2017_gm_head_ret-mat_doc,
        ls_mdyear    TYPE bapi2017_gm_head_ret-doc_year,
        ls_item      TYPE bapi2017_gm_item_create,
        lt_item      TYPE TABLE OF bapi2017_gm_item_create,
        ls_return    TYPE bapiret2,
        lt_return    TYPE TABLE OF bapiret2.

  DATA: lt_rows      TYPE lvc_t_row,
        ls_rows      TYPE lvc_s_row,
        lt_campos    LIKE TABLE OF sval,
        ls_campos    LIKE LINE OF lt_campos.

  PERFORM secim_tespit.
  CHECK gv_hata eq ''.

  ls_header-pstng_date = sy-datum.
  ls_header-doc_date   = sy-datum.
  ls_header-ref_doc_no = 'MAL GIRIS'.
  ls_code-gm_code = '01'.

  LOOP AT gt_row_no INTO gs_row_no-index.
    READ TABLE gt_out INTO gs_out INDEX gs_row_no-index.
    IF sy-subrc = 0.
      ls_item-material  = gs_out-matnr.
      ls_item-plant     = gs_out-werks.
      ls_item-stge_loc  = 'D001'.
      ls_item-batch     = gs_out-afnam.
      ls_item-move_type = '101'.
      ls_item-entry_qnt = gs_out-menge.
      ls_item-entry_uom = gs_out-meins.
      ls_item-po_number = gs_out-ebeln.
      ls_item-po_item   = gs_out-ebelp.
      ls_item-mvt_ind   = 'B'.

      APPEND ls_item TO lt_item.
      CLEAR: ls_item.
    endif.
  endloop.

  CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
    EXPORTING
      goodsmvt_header  = ls_header
      goodsmvt_code    = ls_code
    IMPORTING
      materialdocument = ls_mdocument
      matdocumentyear  = ls_mdyear
    TABLES
      goodsmvt_item    = lt_item
      return           = lt_return.

  LOOP AT lt_return INTO ls_return WHERE type CA 'EAX'.
    EXIT.
  ENDLOOP.
  " hata yoksa
  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

    READ TABLE lt_campos INTO ls_campos INDEX 1.
    MESSAGE s104(zmm) INTO gv_dummy
     WITH ls_mdocument 'numaralı belge oluştu'.
    PERFORM f_sys_add_bapiret2.

    CLEAR : ls_out.
    "Bapi eğer çalıştıysa alv güncellemek için flag ile X'ledim.
    LOOP AT gt_row_no INTO gs_row_no.
      READ TABLE gt_out INTO gs_out INDEX gs_row_no-index.
      IF sy-subrc = 0.
        gs_out-bapi_flag = 'X'.
        MOVE-CORRESPONDING gs_out to ls_out.
        APPEND ls_out to lt_out.
      ENDIF.
    ENDLOOP.


  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    LOOP AT lt_return INTO ls_return WHERE type CA 'EAX'.
      MESSAGE ID ls_return-id
            TYPE ls_return-type
          NUMBER ls_return-number
            WITH ls_return-message_v1
                 ls_return-message_v2
                 ls_return-message_v3
                 ls_return-message
            INTO gv_dummy.
      PERFORM f_sys_add_bapiret2.
    ENDLOOP.
 MESSAGE s104(zmm) WITH 'BAPI Verileri Hatalı Çalıştı' DISPLAY LIKE 'E'.
  ENDIF.

  IF lt_out is NOT INITIAL.
    LOOP AT gt_out INTO gs_out.
      READ TABLE lt_out INTO ls_out with key ebeln = gs_out-ebeln
                                             ebelp = gs_out-ebelp.
      IF sy-subrc = 0.

        MODIFY gt_out FROM ls_out TRANSPORTING bapi_flag.

      ENDIF.
    ENDLOOP.
  ENDIF.

  delete gt_out WHERE bapi_flag = 'X'.

  PERFORM bastir  CHANGING gt_message.
  PERFORM refresh_table_display USING go_grid.

ENDFORM.                    " BAPI_OLUSTUR
*&---------------------------------------------------------------------*
*&      Form  SECIM_TESPIT
*&---------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SECIM_TESPIT .

  CALL METHOD go_grid->get_selected_rows
    IMPORTING
      et_index_rows = gt_row_no.
*      et_row_no     = gt_row_no.

  CLEAR : gv_hata.

  IF gt_row_no IS INITIAL.
    gv_hata = 'X'.
    MESSAGE s110(zmm).
  ENDIF.

ENDFORM.                    " SECIM_TESPIT
*&---------------------------------------------------------------------*
*&      Form  BASTIR
*&---------------------------------------------------------------------*
*      <--P_GT_MESSAGE  text
*----------------------------------------------------------------------*
FORM BASTIR  CHANGING P_GT_MESSAGE TYPE bapiret2_t.

  CHECK p_gt_message[] IS NOT INITIAL .

  CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
    EXPORTING
      it_message = p_gt_message[].

  CLEAR : p_gt_message, p_gt_message[].

ENDFORM.                    " BASTIR
*&---------------------------------------------------------------------*
*&      Form  F_SYS_ADD_BAPIRET2
*&---------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_SYS_ADD_BAPIRET2 .

  DATA : ls_return TYPE bapiret2.
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
*&---------------------------------------------------------------------*
*&      Form  KAYDET2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_CH1  text
*----------------------------------------------------------------------*
FORM KAYDET2  TABLES LT_CH1 STRUCTURE ZSOG_MM_012_S_001.

*-Alv güncellemek için data tanımamaları
  DATA : lt_out type TABLE OF ZSOG_MM_012_S_001,
         ls_out TYPE ZSOG_MM_012_S_001.

  data : ls_ch1 TYPE ZSOG_MM_012_S_001.
  ""Bapi DATA
  DATA: ls_header    TYPE bapi2017_gm_head_01,
        ls_code      TYPE bapi2017_gm_code,
        ls_mdocument TYPE bapi2017_gm_head_ret-mat_doc,
        ls_mdyear    TYPE bapi2017_gm_head_ret-doc_year,
        ls_item      TYPE bapi2017_gm_item_create,
        lt_item      TYPE TABLE OF bapi2017_gm_item_create,
        ls_return    TYPE bapiret2,
        lt_return    TYPE TABLE OF bapiret2.

  DATA: lt_rows      TYPE lvc_t_row,
        ls_rows      TYPE lvc_s_row,
        lt_campos    LIKE TABLE OF sval,
        ls_campos    LIKE LINE OF lt_campos.

  ls_header-pstng_date = sy-datum.
  ls_header-doc_date   = sy-datum.
  ls_header-ref_doc_no = 'MAL GIRIS'.
  ls_code-gm_code = '01'.

  LOOP AT LT_CH1 INTO ls_ch1.
    ls_item-material  = ls_ch1-matnr.
    ls_item-plant     = ls_ch1-werks.
    ls_item-stge_loc  = 'D001'.
    ls_item-batch     = ls_ch1-afnam.
    ls_item-move_type = '101'.
    ls_item-entry_qnt = ls_ch1-menge.
    ls_item-entry_uom = ls_ch1-meins.
    ls_item-po_number = ls_ch1-ebeln.
    ls_item-po_item   = ls_ch1-ebelp.
    ls_item-mvt_ind   = 'B'.

    APPEND ls_item TO lt_item.
    CLEAR: ls_item.
  endloop.

  CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
    EXPORTING
      goodsmvt_header  = ls_header
      goodsmvt_code    = ls_code
    IMPORTING
      materialdocument = ls_mdocument
      matdocumentyear  = ls_mdyear
    TABLES
      goodsmvt_item    = lt_item
      return           = lt_return.

  LOOP AT lt_return INTO ls_return WHERE type CA 'EAX'.
    EXIT.
  ENDLOOP.
  " hata yoksa
  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

    READ TABLE lt_campos INTO ls_campos INDEX 1.
    MESSAGE s104(zmm) INTO gv_dummy
     WITH ls_mdocument 'numaralı belge oluştu'.
    PERFORM f_sys_add_bapiret2.

    CLEAR : ls_out.
    "Bapi eğer çalıştıysa alv güncellemek için flag ile X'ledim.
    LOOP AT lt_ch1 INTO ls_ch1.
      ls_ch1-bapi_flag = 'X'.
      MOVE-CORRESPONDING ls_ch1 to ls_out.
      APPEND ls_out to lt_out.
    ENDLOOP.


  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    LOOP AT lt_return INTO ls_return WHERE type CA 'EAX'.
      MESSAGE ID ls_return-id
            TYPE ls_return-type
          NUMBER ls_return-number
            WITH ls_return-message_v1
                 ls_return-message_v2
                 ls_return-message_v3
                 ls_return-message
            INTO gv_dummy.
      PERFORM f_sys_add_bapiret2.
    ENDLOOP.
 MESSAGE s104(zmm) WITH 'BAPI Verileri Hatalı Çalıştı' DISPLAY LIKE 'E'.
  ENDIF.

  IF lt_out is NOT INITIAL.
    LOOP AT gt_out INTO gs_out.
      READ TABLE lt_out INTO ls_out with key ebeln = gs_out-ebeln
                                             ebelp = gs_out-ebelp.
      IF sy-subrc = 0.

        MODIFY gt_out FROM ls_out TRANSPORTING bapi_flag.

      ENDIF.
    ENDLOOP.
  ENDIF.

  delete gt_out WHERE bapi_flag = 'X'.

  PERFORM bastir  CHANGING gt_message.
*  PERFORM refresh_table_display USING go_grid.

ENDFORM.                    " KAYDET2
