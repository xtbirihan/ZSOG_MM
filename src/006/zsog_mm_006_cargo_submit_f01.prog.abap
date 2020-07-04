*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_006_CARGO_SUBMIT_F01
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM entry_neu USING ent_retco ent_screen.

  TABLES : nast.

  DATA: l_druvo   LIKE t166k-druvo,
        l_nast    LIKE nast,
        l_from_memory,
        l_doc     TYPE meein_purchase_doc_print,
        lv_objkey TYPE nast-objky.

  CLEAR ent_retco.

  CLEAR : lv_objkey.

  lv_objkey = nast-objky.

*{   ->>> Commented by Prodea Ozan Şahin - 19.11.2019 17:46:52
*  RANGES seltab FOR int.
*  CLEAR : gs_rspar.
*  gs_rspar-selname = 'CH1'.
*  gs_rspar-kind    = 'S'.
*  gs_rspar-sign    = 'I'.
*  gs_rspar-option  = 'EQ'.
*  gs_rspar-low     = 'X'.
*  APPEND gs_rspar TO gt_rspar.
*  CLEAR : gs_rspar.
*  gs_rspar-selname = 'S_EBELN'.
*  gs_rspar-kind    = 'S'.
*  gs_rspar-sign    = 'I'.
*  gs_rspar-option  = 'EQ'.
*  gs_rspar-low     = lv_objkey.
*  APPEND gs_rspar TO gt_rspar.
*
*  SUBMIT zsog_mm_006_cargo VIA SELECTION-SCREEN
*             WITH SELECTION-TABLE gt_rspar
*                  AND RETURN.
*}     <<<- End of  Commented - 19.11.2019 17:46:52


*{   ->>> Added by Prodea Ozan Şahin - 19.11.2019 17:42:07
  DATA: lr_ebeln LIKE RANGE OF ekko-ebeln WITH HEADER LINE.
  DATA: lv_ch1   TYPE c.
  lr_ebeln-low    = lv_objkey.
  lr_ebeln-high   = ''.
  lr_ebeln-sign   = 'I'.
  lr_ebeln-option = 'EQ'.
  APPEND lr_ebeln.


  SUBMIT ZSOG_MM_019_CREATESHIPMENT
  WITH s_ebeln IN lr_ebeln
*  WITH ch1     EQ lv_ch1
  EXPORTING LIST TO MEMORY
  AND RETURN.

******Aras kargo ent. devre dışı bırakılmıştır.
*  lv_ch1 = 'X'.
*  SUBMIT zsog_mm_006_cargo
*  WITH s_ebeln IN lr_ebeln
*  WITH ch1     EQ lv_ch1
*  EXPORTING LIST TO MEMORY
*  AND RETURN.
******Aras kargo ent. devre dışı bırakılmıştır.
*}     <<<- End of  Added - 19.11.2019 17:42:07

ENDFORM.                    "entry_neu
