*&---------------------------------------------------------------------*
*& Include ZSOG_MM_018_TOP
*&
*&---------------------------------------------------------------------*
TABLES: eban.
TYPE-POOLS: slis.

TYPES: BEGIN OF ty_eban_check,
        banfn TYPE eban-banfn,
        bnfpo TYPE eban-bnfpo,
       END OF ty_eban_check.
DATA: gt_eban_ck TYPE TABLE OF ty_eban_check,
      gs_eban_ck LIKE LINE OF  gt_eban_ck.

DATA: t_objpack  TYPE TABLE OF sopcklsti1,
      t_objhead  TYPE TABLE OF solisti1,
      t_objtxt   TYPE TABLE OF solisti1,
      t_reclist  TYPE TABLE OF somlreci1,
      gv_sender  TYPE soextreci1-receiver.

DATA: wa_docdata TYPE sodocchgi1,   " Document data
      wa_objtxt  TYPE solisti1,     " Message body
      wa_objbin  TYPE solix,     " Attachment data
      wa_objpack TYPE sopcklsti1,   " Packing list
      wa_reclist TYPE somlreci1,    " Receipient list
      wa_objhead TYPE solisti1.

DATA: w_tab_lines TYPE i.

DATA: gt_alv                 TYPE TABLE OF ZSOG_MM_018_S,
      gs_alv                 LIKE LINE OF  gt_alv,
      gr_alvgrid             TYPE REF TO cl_gui_alv_grid,
      gr_custom_control_name TYPE scrfname VALUE 'CC_ALV'.
*
**--- Custom container referans örneği
DATA gr_custom_container TYPE REF TO cl_gui_custom_container.
DATA: ok_code TYPE sy-ucomm,
      gt_rows TYPE lvc_t_row.
*--- Field catalog tablosu
DATA: gt_fieldcat TYPE lvc_t_fcat,
      gs_fieldcat TYPE lvc_s_fcat.
*--- Layout structure
DATA gs_layout TYPE lvc_s_layo.
CLASS lcl_event_handler DEFINITION DEFERRED.
DATA gv_error.
DATA gr_event_handler TYPE REF TO lcl_event_handler.
*--- Button excluding
DATA gt_exclude TYPE ui_functions.
"--- Sort için
DATA gt_sort TYPE lvc_t_sort.
"--- Filter için
DATA gt_filt TYPE lvc_t_filt.

 DATA: gt_message TYPE TABLE OF bapiret2.

***********************************Attach*****************
DATA: t_objbin   TYPE STANDARD TABLE OF solix.   " Attachment data

DATA t_excel LIKE solisti1   OCCURS 0 WITH HEADER LINE.

DATA: gv_loctext(100).

DATA: it_data TYPE TABLE OF ZSOG_MM_018_S.
"XML DATA TANIMLAMALARI
DATA: l_ixml            TYPE REF TO if_ixml,
      l_streamfactory   TYPE REF TO if_ixml_stream_factory,
      l_ostream         TYPE REF TO if_ixml_ostream,
      l_renderer        TYPE REF TO if_ixml_renderer,
      l_document        TYPE REF TO if_ixml_document.

DATA: l_element_root        TYPE REF TO if_ixml_element,
      ns_attribute          TYPE REF TO if_ixml_attribute,
      r_element_properties  TYPE REF TO if_ixml_element,
      r_element             TYPE REF TO if_ixml_element,
      r_worksheet           TYPE REF TO if_ixml_element,
      r_table               TYPE REF TO if_ixml_element,
      r_column              TYPE REF TO if_ixml_element,
      r_row                 TYPE REF TO if_ixml_element,
      r_cell                TYPE REF TO if_ixml_element,
      r_data                TYPE REF TO if_ixml_element,
      l_value               TYPE string,
      l_type                TYPE string,
      l_text(100)           TYPE c,
      r_styles              TYPE REF TO if_ixml_element,
      r_style               TYPE REF TO if_ixml_element,
      r_style1              TYPE REF TO if_ixml_element,
      r_format              TYPE REF TO if_ixml_element,
      r_border              TYPE REF TO if_ixml_element,
      num_rows              TYPE i.

TYPES: BEGIN OF xml_line,
        data(255) TYPE x,
       END OF xml_line.

DATA: l_xml_table       TYPE TABLE OF xml_line,
      wa_xml            TYPE xml_line,
      l_xml_size        TYPE i,
      l_rc              TYPE i.

DATA: gt_aciklama TYPE ddfields,
      gs_aciklama TYPE dfies.

  FIELD-SYMBOLS : <fs_data> TYPE any,
                  <fs_value> TYPE any.

***  FIELD-SYMBOLS: <dyn_table> TYPE TABLE OF zmm_sat_onay_s.

  DATA: gv_value TYPE string,
        gv_length TYPE ddleng,
        gv_text(50),
        gv_xls(50),
        gv_date(10).


  DATA:
  gr_send_request  TYPE REF TO cl_bcs,
  gr_sender_mail   TYPE REF TO cl_cam_address_bcs,
  gr_recipient     TYPE REF TO if_recipient_bcs,
  gr_document      TYPE REF TO cl_document_bcs,
  gv_sent_to_all   TYPE os_boolean.

***********************************Attach*****************

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME.
select-options: s_banfn FOR eban-banfn,
                s_bnfpo FOR eban-bnfpo,
                s_badat for eban-badat.
PARAMETERS: p_onay AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK bl1.


  DEFINE clear_global_variables .
        CLEAR: t_objpack,
               t_objhead,
               t_objbin,
               t_objtxt,
               t_reclist,
               wa_docdata,
               wa_objbin,
               wa_objtxt,
               wa_objhead,
               wa_objpack,
               w_tab_lines,
               gt_eban_ck.
        CLEAR: "xml_line,
               l_ixml              ,
               l_streamfactory     ,
               l_ostream           ,
               l_renderer          ,
               l_document          ,

               l_element_root      ,
               ns_attribute        ,
               r_element_properties,
               r_element           ,
               r_worksheet         ,
               r_table             ,
               r_column            ,
               r_row               ,
               r_cell              ,
               r_data              ,
               l_value             ,
               l_type              ,
               l_text              ,
               r_styles            ,
               r_style             ,
               r_style1            ,
               r_format            ,
               r_border            ,
               num_rows            ,
               l_xml_table       ,
               l_xml_table       ,
               wa_xml            ,
               l_xml_size        ,
               l_rc              .
  END-OF-DEFINITION.
