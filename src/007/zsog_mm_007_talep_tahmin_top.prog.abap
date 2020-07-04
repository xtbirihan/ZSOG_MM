*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_007_TALEP_TAHMIN_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZMM_TK_TANIMLAMA_TOP
*&---------------------------------------------------------------------*
  TYPES: BEGIN OF ltt_alv,
        file_date TYPE zsg_t_001-file_date  ,
        gjahr     TYPE zsg_t_001-gjahr      ,
        monat     TYPE zsg_t_001-monat      ,
        item_no   TYPE zsg_t_001-item_no    ,
        record_type TYPE zsg_t_001-record_type,
        retailer_no TYPE zsg_t_001-retailer_no,
        kunnr       TYPE zsog_mm_007_t_02-kunnr,
        name1       TYPE kna1-name1            ,
        game_no     TYPE zsg_t_001-game_no     ,
        matnr       TYPE zsog_mm_007_t_01-matnr,
        maktx       TYPE makt-maktx            ,
        no_of_sold_wagers  TYPE zsg_t_001-no_of_sold_wagers,
        matnr1  TYPE mseg-matnr,
        werks  TYPE mseg-werks,
        lgort  TYPE mseg-lgort,
        menge  TYPE mseg-menge,
        meins  TYPE mseg-meins,
        fire   TYPE zsog_mm_007_t_01-fire,
        miktar TYPE mseg-menge,
   END OF ltt_alv.
  TYPES: BEGIN OF gtt_eban,
           banfn TYPE eban-banfn,
           bnfpo TYPE eban-bnfpo,
           matnr TYPE eban-matnr,
           afnam TYPE eban-afnam,
           ebeln TYPE eban-ebeln,
           bsart TYPE eban-bsart,
         END OF gtt_eban.
  TYPES: tt_budget_data TYPE TABLE OF zsog_mm_007_s_005.
  DATA: BEGIN OF gs_budget_cntrl_data,
         ebeln  TYPE ekpo-ebeln.
          INCLUDE TYPE zsog_mm_007_s_005.
  DATA:END OF gs_budget_cntrl_data.
  TYPES:tt_budget_cntrl_data LIKE TABLE OF gs_budget_cntrl_data.
  DATA: gr_send_request TYPE REF TO cl_bcs.

  DATA: gv_error     TYPE c.
  DATA: gt_mail_data TYPE TABLE OF zsog_mm_007_s_005,
        gv_ucomm     TYPE sy-ucomm.
  DATA: BEGIN OF gs_scr.
  DATA: BEGIN OF 1903.
  DATA: ucomm            TYPE sy-ucomm.
  DATA: error            TYPE char1.
  DATA: alv              TYPE TABLE OF zsog_mm_007_s_002.
  DATA: r_alv            TYPE REF TO cl_salv_table.
  DATA: r_columns        TYPE REF TO cl_salv_columns_table.
  DATA: r_column         TYPE REF TO cl_salv_column.
  DATA: r_events         TYPE REF TO cl_salv_events_table.
  DATA: container        TYPE scrfname VALUE 'CONT1'.
  DATA: grid1            TYPE REF TO cl_gui_alv_grid.
  DATA: custom_container TYPE REF TO cl_gui_custom_container.
  DATA: layout           TYPE lvc_s_layo.
  DATA: exclude          TYPE ui_functions.
  DATA: fieldcat         TYPE lvc_t_fcat.
*DATA: sil              TYPE TABLE OF zmm_tk_tanimlama_rapor.
  DATA: ucomm_first_alv  TYPE sy-ucomm.
  DATA: END OF 1903.
  DATA: END OF gs_scr.

  DATA:
* Reference to document
         dg_dyndoc_id       TYPE REF TO cl_dd_document,
* Reference to split container
         dg_splitter          TYPE REF TO cl_gui_splitter_container,
* Reference to grid container
         dg_parent_grid     TYPE REF TO cl_gui_container,
* Reference to html container
         dg_html_cntrl        TYPE REF TO cl_gui_html_viewer,
* Reference to html container
         dg_parent_html     TYPE REF TO cl_gui_container.

  FIELD-SYMBOLS: <grid_alv>   TYPE STANDARD TABLE ,
                 <grid_line>  TYPE any.

*----------------------------------------------------------------------*
*       CLASS lcl_handle_events DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
  CLASS lcl_handle_events DEFINITION.
    PUBLIC SECTION.
      METHODS: on_link_click   FOR EVENT link_click
                    OF cl_salv_events_table
        IMPORTING row column,

        on_user_command FOR EVENT added_function OF cl_salv_events
          IMPORTING e_salv_function.
  ENDCLASS.                    "lcl_handle_events DEFINITION

  DATA: event_handler TYPE REF TO lcl_handle_events.
*----------------------------------------------------------------------*
*       CLASS lcl_handle_events IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
  CLASS lcl_handle_events IMPLEMENTATION.
    METHOD on_link_click.

    ENDMETHOD.                    "on_link_click

    METHOD on_user_command.
      PERFORM handle_user_command USING e_salv_function.
    ENDMETHOD.                    "on_user_command
  ENDCLASS.                    "lcl_handle_events IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS lcl_gui_alv_event_receiver DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
  CLASS lcl_gui_alv_event_receiver DEFINITION.
    PUBLIC SECTION.
      METHODS:
        "        Hotspot click control
        handle_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
          IMPORTING e_row_id e_column_id es_row_no.    "this will be passed each time your click on the cell

      METHODS:
        handle_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
          IMPORTING
              e_object e_interactive,
        handle_user_command FOR EVENT user_command OF cl_gui_alv_grid
          IMPORTING e_ucomm.

      METHODS:
        handle_data_changed
                      FOR EVENT data_changed OF cl_gui_alv_grid
          IMPORTING er_data_changed e_ucomm.


      METHODS: check_changed_key
        IMPORTING
          ps_good         TYPE lvc_s_modi
          pr_data_changed TYPE REF TO cl_alv_changed_data_protocol.

      METHODS: top_of_page FOR EVENT top_of_page              "event handler
                                  OF  cl_gui_alv_grid
                          IMPORTING e_dyndoc_id.


*    METHODS: onf4 FOR EVENT onf4 OF cl_gui_alv_grid
*      IMPORTING e_fieldname
*                  e_fieldvalue
*                  es_row_no
*                  er_event_data
*                  et_bad_cells
*                  e_display.

    PRIVATE SECTION.
      DATA: error_in_data TYPE c.

      METHODS: check_lifnr
        IMPORTING
          ps_good         TYPE lvc_s_modi
          pr_data_changed TYPE REF TO cl_alv_changed_data_protocol.



  ENDCLASS.                    "lcl_gui_alv_event_receiver DEFINITION
*----------------------------------------------------------------------*
*       CLASS lcl_gui_alv_event_receiver IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
  CLASS lcl_gui_alv_event_receiver IMPLEMENTATION.
    METHOD handle_hotspot_click .
*    READ TABLE gt_outtab INTO DATA(ls_outtab) INDEX es_row_no-row_id.
*    IF sy-subrc EQ 0.
*      SET PARAMETER ID 'IQM' FIELD ls_outtab-qmnum  .
*      CALL TRANSACTION 'QM02' AND SKIP FIRST SCREEN .
*    ENDIF.

    ENDMETHOD .                    "handle_hotspot_click

    METHOD handle_toolbar.
**  EVENT HANDLER METHOD FOR EVENT TOOLBAR.
      CONSTANTS:
        c_button_normal           TYPE i VALUE 0,
        c_menu_and_default_button TYPE i VALUE 1,
        c_menu                    TYPE i VALUE 2,
        c_separator               TYPE i VALUE 3,
        c_radio_button            TYPE i VALUE 4,
        c_checkbox                TYPE i VALUE 5,
        c_menu_entry              TYPE i VALUE 6.
      DATA: ls_toolbar  TYPE stb_button.
*
*    CLEAR ls_toolbar.
*    MOVE c_separator TO ls_toolbar-butn_type.
*    APPEND ls_toolbar TO e_object->mt_toolbar.
*
*    CLEAR ls_toolbar.
*    MOVE c_separator  TO ls_toolbar-butn_type.
*    APPEND ls_toolbar TO e_object->mt_toolbar.
*    CLEAR ls_toolbar.
*    MOVE 'CREATE_1903'  TO ls_toolbar-function.
*    MOVE  icon_mass_change   TO ls_toolbar-icon.
*    MOVE 'Satır Ekle'        TO ls_toolbar-quickinfo.
*    MOVE 'Satır Ekle'        TO ls_toolbar-text.
*    MOVE ' '                 TO ls_toolbar-disabled.
*    APPEND ls_toolbar        TO e_object->mt_toolbar.
*
*
*    CLEAR ls_toolbar.
*    MOVE c_separator  TO ls_toolbar-butn_type.
*    APPEND ls_toolbar TO e_object->mt_toolbar.
*    CLEAR ls_toolbar.
*    MOVE 'DELLINE_1903' TO ls_toolbar-function.
*    MOVE  icon_delete_all_attributes   TO ls_toolbar-icon.
*    MOVE 'Satırı Sil'        TO ls_toolbar-quickinfo.
*    MOVE 'Satırı Sil'        TO ls_toolbar-text.
*    MOVE ' '                 TO ls_toolbar-disabled.
*    APPEND ls_toolbar        TO e_object->mt_toolbar.
*
      IF rb2 EQ 'X'.

        CLEAR ls_toolbar.
        MOVE c_separator        TO ls_toolbar-butn_type.
        APPEND ls_toolbar       TO e_object->mt_toolbar.
        CLEAR ls_toolbar.
        MOVE 'KAYIT_1903'        TO ls_toolbar-function.
        MOVE  icon_system_save   TO ls_toolbar-icon.
        MOVE 'Kaydet'            TO ls_toolbar-quickinfo.
        MOVE 'Kaydet'            TO ls_toolbar-text.
        MOVE ' '                 TO ls_toolbar-disabled.
        APPEND ls_toolbar        TO e_object->mt_toolbar.


******** damlap 17.01.2020 **************--> başlangıç
        CLEAR ls_toolbar.
        MOVE c_separator        TO ls_toolbar-butn_type.
        APPEND ls_toolbar       TO e_object->mt_toolbar.
        CLEAR ls_toolbar.
        MOVE 'DELLINE_1903'     TO ls_toolbar-function.
        MOVE  icon_delete_all_attributes   TO ls_toolbar-icon.
        MOVE 'Satırı Sil'       TO ls_toolbar-quickinfo.
        MOVE 'Satırı Sil'       TO ls_toolbar-text.
        MOVE ' '                TO ls_toolbar-disabled.
        APPEND ls_toolbar       TO e_object->mt_toolbar.

******** damlap 17.01.2020 **************--> bitiş

      ELSEIF rb3 EQ 'X' .
        CLEAR ls_toolbar.
        MOVE c_separator  TO ls_toolbar-butn_type.
        APPEND ls_toolbar TO e_object->mt_toolbar.
        CLEAR ls_toolbar.
        MOVE 'SIPARIS_1903' TO ls_toolbar-function.
        MOVE icon_change_order   TO ls_toolbar-icon.
        MOVE 'Sipariş Oluştur'   TO ls_toolbar-quickinfo.
        MOVE 'Sipariş Oluştur'   TO ls_toolbar-text.
        MOVE ' '                 TO ls_toolbar-disabled.
        APPEND ls_toolbar        TO e_object->mt_toolbar.

        CLEAR ls_toolbar.
        MOVE c_separator       TO ls_toolbar-butn_type.
        APPEND ls_toolbar      TO e_object->mt_toolbar.
        CLEAR ls_toolbar.
        MOVE 'GERIAL_1903'       TO ls_toolbar-function.
        MOVE  icon_pdir_back   TO ls_toolbar-icon.
        MOVE 'Geri Al'         TO ls_toolbar-quickinfo.
        MOVE 'Geri Al'         TO ls_toolbar-text.
        MOVE ' '               TO ls_toolbar-disabled.
        APPEND ls_toolbar      TO e_object->mt_toolbar.

      ELSEIF rb5 EQ 'X'.
        CLEAR ls_toolbar.
        MOVE c_separator         TO ls_toolbar-butn_type.
        APPEND ls_toolbar        TO e_object->mt_toolbar.
        CLEAR ls_toolbar.
        MOVE 'SATIS_FIRE_1903'   TO ls_toolbar-function.
        MOVE  icon_change_order  TO ls_toolbar-icon.
        MOVE 'Satış Fire Çıkış'  TO ls_toolbar-quickinfo.
        MOVE 'Satış Fire Çıkış'  TO ls_toolbar-text.
        MOVE ' '                 TO ls_toolbar-disabled.
        APPEND ls_toolbar        TO e_object->mt_toolbar.

      ELSEIF rb6 EQ 'X' AND c_trans = 'X'.
        CLEAR  ls_toolbar.
        MOVE   c_separator       TO ls_toolbar-butn_type.
        APPEND ls_toolbar        TO e_object->mt_toolbar.
        CLEAR  ls_toolbar.
        MOVE 'SAVE_BUDGET'       TO ls_toolbar-function.
        MOVE  icon_system_save   TO ls_toolbar-icon.
        MOVE 'Bütçe Kaydet'      TO ls_toolbar-quickinfo.
        MOVE 'Bütçe Kaydet'      TO ls_toolbar-text.
        MOVE ' '                 TO ls_toolbar-disabled.
        APPEND ls_toolbar        TO e_object->mt_toolbar.

      ELSEIF rb6 EQ 'X' AND c_contr = 'X'.
        IF gt_mail_data[] IS NOT INITIAL.
          CLEAR ls_toolbar.
          MOVE c_separator         TO ls_toolbar-butn_type.
          APPEND ls_toolbar        TO e_object->mt_toolbar.
          MOVE c_separator         TO ls_toolbar-butn_type.
          APPEND ls_toolbar        TO e_object->mt_toolbar.

          CLEAR ls_toolbar.
          MOVE 'SEND_MAIL'         TO ls_toolbar-function.
          MOVE  icon_mail          TO ls_toolbar-icon.
          MOVE 'Mail Gönder'       TO ls_toolbar-quickinfo.
          MOVE 'Mail Gönder'       TO ls_toolbar-text.
          MOVE ' '                 TO ls_toolbar-disabled.
          APPEND ls_toolbar        TO e_object->mt_toolbar.
        ENDIF.
      ENDIF.


    ENDMETHOD.                    "handle_toolbar

    METHOD handle_user_command.
      DATA: ls_stable TYPE lvc_s_stbl.
      ls_stable-row = 'X'.
      ls_stable-col = 'X'.
      gs_scr-1903-ucomm = e_ucomm.
      CASE e_ucomm.
        WHEN 'SIPARIS_1903'.
          PERFORM siparis_1903.
        WHEN 'GERIAL_1903'.
          PERFORM gerial_1903.
*      WHEN 'DELLINE_1903'.
*        PERFORM delline_1903.
*      WHEN 'COPYLINE_1903'.
*        PERFORM copyline_1903.
        WHEN 'KAYIT_1903'.
          PERFORM kayit_1903.
        WHEN 'DELLINE_1903'.
          PERFORM delline_1903.
        WHEN 'SATIS_FIRE_1903'.
          PERFORM bapi_goodsmvt_create.
        WHEN 'SAVE_BUDGET'.
          PERFORM save_budget.
        WHEN 'SEND_MAIL'.
          PERFORM send_budget_mail.
      ENDCASE.
      CLEAR: gs_scr-1903-ucomm .

      IF gs_scr-1903-grid1 IS BOUND .
        PERFORM grid_refresh USING gs_scr-1903-grid1 ls_stable.
      ENDIF.
    ENDMETHOD.                    "handle_user_command
    METHOD handle_data_changed.

      DATA: ls_stable TYPE lvc_s_stbl.
      DATA: lv_lifnr TYPE lfa1-lifnr.
      DATA : ls_good TYPE lvc_s_modi.
*      DATA: ls_alv TYPE zosit_s_yeni_giris.
      ls_stable-row = 'X'.
      ls_stable-col = 'X'.
      FIELD-SYMBOLS: <fs_alv>         TYPE any ,
                     <fs_matnr>       TYPE mara-matnr,
                     <fs_ihtiyac_mik> TYPE any,
                     <fs_mikt_3000>   TYPE any,
                     <fs_ob_3000>     TYPE any,
*                     <fs_value>       TYPE ZSOG_MM_007_T_03-SIPARIS_MIKTARI,
                     <fs_onerilen_sip> TYPE any,
                     <fs_mikt_1000>    TYPE any,
                     <fs_ob_1000>      TYPE any,
                     <fs_mikt_4>       TYPE any,
                     <fs_ob_4>         TYPE any,
                     <fs_mikt_6000>    TYPE any,
                     <fs_ob_6000>      TYPE any,
                     <fs_mikt_10000>    TYPE any,
                     <fs_ob_10000>      TYPE any.
      DATA: lt_malzeme_ob  TYPE TABLE OF zsog_mm_007_t_05,
            ls_malzeme_ob  TYPE zsog_mm_007_t_05.

      DATA: lv_objective_righthandside TYPE genios_float.
      DATA: ls_return TYPE zsog_mm_007_genios_return.


*
      error_in_data = space.
      LOOP AT er_data_changed->mt_good_cells INTO ls_good.
        CASE ls_good-fieldname.
          WHEN 'SIPARIS_MIKTARI'.
*            ASSIGN ls_good-value to <fs_value>.
            CONDENSE ls_good-value.
            READ TABLE <grid_alv> ASSIGNING <fs_alv> INDEX ls_good-row_id.
            IF sy-subrc EQ 0.
              SELECT * FROM zsog_mm_007_t_05 INTO TABLE lt_malzeme_ob.
              SORT lt_malzeme_ob BY malzeme.

              ASSIGN COMPONENT 'MATNR'        OF STRUCTURE <fs_alv> TO <fs_matnr>       .
              ASSIGN COMPONENT 'IHTIYAC_MIK'  OF STRUCTURE <fs_alv> TO <fs_ihtiyac_mik> .
              ASSIGN COMPONENT 'MIKT_3000'    OF STRUCTURE <fs_alv> TO <fs_mikt_3000>   .
              ASSIGN COMPONENT 'OB_3000'      OF STRUCTURE <fs_alv> TO <fs_ob_3000>     .
              ASSIGN COMPONENT 'ONERILEN_SIP' OF STRUCTURE <fs_alv> TO <fs_onerilen_sip>.
              ASSIGN COMPONENT 'MIKT_1000'    OF STRUCTURE <fs_alv> TO <fs_mikt_1000>   .
              ASSIGN COMPONENT 'OB_1000'      OF STRUCTURE <fs_alv> TO <fs_ob_1000>     .
              ASSIGN COMPONENT 'MIKT_4'       OF STRUCTURE <fs_alv> TO <fs_mikt_4>     .
              ASSIGN COMPONENT 'OB_4'         OF STRUCTURE <fs_alv> TO <fs_ob_4>     .
              ASSIGN COMPONENT 'MIKT_6000'    OF STRUCTURE <fs_alv> TO  <fs_mikt_6000>  .
              ASSIGN COMPONENT 'MIKT_10000'   OF STRUCTURE <fs_alv> TO  <fs_mikt_10000>    .
              ASSIGN COMPONENT 'OB_6000'      OF STRUCTURE <fs_alv> TO  <fs_ob_6000>    .
              ASSIGN COMPONENT 'OB_10000'     OF STRUCTURE <fs_alv> TO  <fs_ob_10000>    .



              READ TABLE lt_malzeme_ob INTO ls_malzeme_ob WITH KEY malzeme = <fs_matnr> BINARY SEARCH.
              IF ls_good-value > 0.
                IF ls_malzeme_ob-counter EQ '1'.
                  IF ls_malzeme_ob-mlzme_miktar EQ '3000'.

                    <fs_mikt_3000>        = ceil( ls_good-value / 3000 ).
                    <fs_ob_3000>          = ls_malzeme_ob-olcu_birimi.
                    <fs_onerilen_sip>     =  <fs_mikt_3000>  * 3000 .

                  ELSEIF ls_malzeme_ob-mlzme_miktar EQ '1000'.

                    <fs_mikt_1000>         = ceil( ls_good-value / 1000 ).
                    <fs_ob_1000>           = ls_malzeme_ob-olcu_birimi.
                    <fs_onerilen_sip>      =  <fs_mikt_1000>  * 1000 .

                  ELSEIF ls_malzeme_ob-mlzme_miktar EQ '4'.

                    <fs_mikt_4>        = ceil( ls_good-value / 4 ).
                    <fs_ob_4>          = ls_malzeme_ob-olcu_birimi.
                    <fs_onerilen_sip>     = <fs_mikt_4> * 4 .

                  ENDIF.
                ELSEIF ls_malzeme_ob-counter EQ '2'.
                  lv_objective_righthandside = ls_good-value.
*
                  CALL FUNCTION 'ZSOG_MM_007_GENIOS'
                    EXPORTING
                      iv_objective_righthandside = lv_objective_righthandside
                    IMPORTING
                      es_return                  = ls_return.

                  <fs_mikt_6000>   = ls_return-xvalue.
                  <fs_mikt_10000>  = ls_return-yvalue.
*
                  LOOP AT lt_malzeme_ob INTO ls_malzeme_ob WHERE malzeme = <fs_matnr>.
                    IF ls_malzeme_ob-mlzme_miktar EQ '6000'.
                      <fs_ob_6000>  = ls_malzeme_ob-olcu_birimi.
                    ELSEIF ls_malzeme_ob-mlzme_miktar EQ '10000'.
                      <fs_ob_10000> = ls_malzeme_ob-olcu_birimi.
                    ENDIF.
                  ENDLOOP.
*
                  <fs_onerilen_sip> =  <fs_mikt_6000>  * 6000 +
                                       <fs_mikt_10000> * 10000.
*                  ls_grid_alv-siparis_miktari = ls_grid_alv-onerilen_sip.
                ENDIF.
              ENDIF.
            ENDIF.
*          CALL METHOD check_lifnr
*            EXPORTING
*              ps_good         = ls_good
*              pr_data_changed = er_data_changed.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
      IF gs_scr-1903-grid1 IS BOUND .
        PERFORM grid_refresh USING gs_scr-1903-grid1 ls_stable.
      ENDIF.
    ENDMETHOD.                    "handle_data_changed
    METHOD check_changed_key.
*    BREAK-POINT.
    ENDMETHOD.                    "check_changed_key
    METHOD top_of_page.                   "implementation
* Top-of-page event
      PERFORM event_top_of_page USING dg_dyndoc_id.
    ENDMETHOD.                    "TOP_OF_PAGE
    METHOD check_lifnr.

*    DATA: lv_lifnr TYPE lfa1-lifnr.
*    CALL METHOD pr_data_changed->get_cell_value
*      EXPORTING
*        i_row_id    = ps_good-row_id
*        i_fieldname = ps_good-fieldname
*      IMPORTING
*        e_value     = lv_lifnr.
*
*    lv_lifnr =  |{ lv_lifnr ALPHA = IN }|.
*    IF lv_lifnr IS INITIAL .
*      RETURN.
*    ENDIF.
*    SELECT SINGLE lifnr, name1 INTO @DATA(ls_satici)
*                FROM lfa1
*                WHERE lifnr = @lv_lifnr.
*
*    IF sy-subrc NE 0.
*      CALL METHOD pr_data_changed->add_protocol_entry
*        EXPORTING
*          i_msgid     = 'ZMM'
*          i_msgno     = '000'
*          i_msgty     = 'E'
*          i_msgv1     = lv_lifnr
*          i_msgv2     = text-008
**         i_msgv3     = text-003
*          i_fieldname = ps_good-fieldname
*          i_row_id    = ps_good-row_id.
*      CALL METHOD pr_data_changed->display_protocol( ).
*      error_in_data = 'X'.
*      EXIT. "plane does not exit, so we're finished here!
*    ELSE.
*
*    ENDIF.
*
*    READ TABLE gs_scr-1903-grid_alv INTO DATA(ls_alv) INDEX ps_good-row_id.
*
*    SELECT SINGLE k~lifnr, k~name1 AS lifnr_ad
*      FROM lfa1 AS k
*      INNER JOIN eina  AS b  ON b~lifnr = b~lifnr
*                            AND b~relif = 'X'
*                            AND b~loekz = @space
*      INNER JOIN eine  AS j ON  j~infnr = b~infnr
*                            AND j~loekz = @space
*                            AND j~ekorg = @ls_alv-ekorg
*      INTO @DATA(ls_check_satici)
*      WHERE k~lifnr = @lv_lifnr.
*    IF sy-subrc NE 0.
*      CALL METHOD pr_data_changed->add_protocol_entry
*        EXPORTING
*          i_msgid     = 'ZMM'
*          i_msgno     = '000'
*          i_msgty     = 'E'
*          i_msgv1     = lv_lifnr
*          i_msgv2     = text-020
**         i_msgv3     = text-003
*          i_fieldname = ps_good-fieldname
*          i_row_id    = ps_good-row_id.
*
*      error_in_data = 'X'.
*      CALL METHOD pr_data_changed->display_protocol( ).
*      EXIT. "plane does not exit, so we're finished here!
*    ELSE.
*
*    ENDIF.
*
*    IF error_in_data IS INITIAL.
*      ls_alv-lifnr    = ls_satici-lifnr.
*      ls_alv-lifnr_ad = ls_satici-name1.
*      MODIFY  gs_scr-1903-grid_alv FROM ls_alv INDEX  ps_good-row_id
*                                               TRANSPORTING lifnr
*                                                            lifnr_ad.
*
*    ELSE.
*
*    ENDIF.

    ENDMETHOD.                    "check_lifnr


  ENDCLASS.                    "lcl_gui_alv_event_receiver IMPLEMENTATION

  DATA: gr_alv_event_ref TYPE REF TO lcl_gui_alv_event_receiver.
