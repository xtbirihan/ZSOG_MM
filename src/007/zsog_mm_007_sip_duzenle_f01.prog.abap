*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_007_TALEP_TAHMIN_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  MODIFY_SCREEN
*&---------------------------------------------------------------------*
FORM modify_screen .
  DATA : lv_job   TYPE c,
         lv_mhsb  TYPE c,
         lv_oprsn TYPE c.
  AUTHORITY-CHECK OBJECT 'ZSOG_JOB'
           ID 'ACTVT' FIELD '01'.
  IF sy-subrc = 0.
    lv_job = 'X'.
  ENDIF.

  AUTHORITY-CHECK OBJECT 'ZSOG_MHSB'
         ID 'ACTVT' FIELD '01'.
  IF sy-subrc = 0.
    lv_mhsb = 'X'.
  ENDIF.

  AUTHORITY-CHECK OBJECT 'ZSOG_OPRSN'
       ID 'ACTVT' FIELD '01'.
  IF sy-subrc = 0.
    lv_oprsn = 'X'.
  ENDIF.

  IF lv_job = 'X' AND lv_mhsb = 'X' AND lv_oprsn = 'X'.
    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'M4'.
          screen-invisible = 0.
          screen-active = 1.
          MODIFY SCREEN.
        WHEN 'M5'.
          screen-invisible = 0.
          screen-active = 1.
          MODIFY SCREEN.
        WHEN 'M6'.
          screen-invisible = 0.
          screen-active = 1.
          MODIFY SCREEN.
        WHEN 'M7'.
          screen-invisible = 0.
          screen-active = 1.
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.
  ELSEIF lv_job = 'X' AND lv_mhsb = 'X' AND lv_oprsn = ''.
    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'M4'.
          screen-invisible = 0.
          screen-active = 1.
          MODIFY SCREEN.
        WHEN 'M5'.
          screen-invisible = 1.
          screen-active = 0.
          MODIFY SCREEN.
        WHEN 'M6'.
          screen-invisible = 0.
          screen-active = 1.
          MODIFY SCREEN.
        WHEN 'M7'.
          screen-invisible = 0.
          screen-active = 1.
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.
  ELSEIF lv_job = 'X' AND lv_mhsb = '' AND lv_oprsn = 'X'.
    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'M4'.
          screen-invisible = 0.
          screen-active = 1.
          MODIFY SCREEN.
        WHEN 'M5'.
          screen-invisible = 0.
          screen-active = 1.
          MODIFY SCREEN.
        WHEN 'M6'.
          screen-invisible = 1.
          screen-active = 0.
          MODIFY SCREEN.
        WHEN 'M7'.
          screen-invisible = 0.
          screen-active = 1.
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.
  ELSEIF lv_job = 'X' AND lv_mhsb = '' AND lv_oprsn = ''.
    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'M4'.
          screen-invisible = 0.
          screen-active = 1.
          MODIFY SCREEN.
        WHEN 'M5'.
          screen-invisible = 1.
          screen-active = 0.
          MODIFY SCREEN.
        WHEN 'M6'.
          screen-invisible = 1.
          screen-active = 0.
          MODIFY SCREEN.
        WHEN 'M7'.
          screen-invisible = 1.
          screen-active = 0.
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.
  ELSEIF lv_job = '' AND lv_mhsb = 'X' AND lv_oprsn = ''.
    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'M4'.
          screen-invisible = 1.
          screen-active = 0.
          MODIFY SCREEN.
        WHEN 'M5'.
          screen-invisible = 1.
          screen-active = 0.
          MODIFY SCREEN.
        WHEN 'M6'.
          screen-invisible = 0.
          screen-active = 1.
          MODIFY SCREEN.
        WHEN 'M7'.
          screen-invisible = 0.
          screen-active = 1.
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.
  ELSEIF lv_job = '' AND lv_mhsb = 'X' AND lv_oprsn = 'X'.
    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'M4'.
          screen-invisible = 1.
          screen-active = 0.
          MODIFY SCREEN.
        WHEN 'M5'.
          screen-invisible = 0.
          screen-active = 1.
          MODIFY SCREEN.
        WHEN 'M6'.
          screen-invisible = 0.
          screen-active = 1.
          MODIFY SCREEN.
        WHEN 'M7'.
          screen-invisible = 0.
          screen-active = 1.
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.
  ELSEIF lv_job = '' AND lv_mhsb = '' AND lv_oprsn = 'X'.
    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'M4'.
          screen-invisible = 1.
          screen-active = 0.
          MODIFY SCREEN.
        WHEN 'M5'.
          screen-invisible = 0.
          screen-active = 1.
          MODIFY SCREEN.
        WHEN 'M6'.
          screen-invisible = 1.
          screen-active = 0.
          MODIFY SCREEN.
        WHEN 'M7'.
          screen-invisible = 0.
          screen-active = 1.
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.
  ELSEIF lv_job = '' AND lv_mhsb = '' AND lv_oprsn = ''.
    gv_error = 'X'.
    MESSAGE 'Program Erişim Yetkiniz Yoktur !' TYPE 'I'.
    LEAVE TO SCREEN 0.

  ENDIF.

  IF rb1 = 'X' OR rb5 = 'X'.
    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'M1'.
          screen-invisible = 1.
          screen-active = 0.
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.
  ENDIF.

  IF rb3 = 'X' .
    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'M2'.
          screen-invisible = 1.
          screen-active = 0.
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.
  ENDIF.

  IF rb4 NE 'X' .
    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'M3'.
          screen-invisible = 1.
          screen-active = 0.
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.
  ENDIF.

  CLEAR : lv_job,lv_mhsb,lv_oprsn.
ENDFORM.                    " MODIFY_SCREEN
*&---------------------------------------------------------------------*
*&      Form  SAT_OLUSTUR
*&---------------------------------------------------------------------*
FORM sat_olustur .
  TYPES: BEGIN OF ltt_eban,
         banfn TYPE eban-banfn,
         bnfpo TYPE eban-bnfpo,
         matnr TYPE eban-matnr,
         afnam TYPE eban-afnam,
         ebeln TYPE eban-ebeln,
         bsart TYPE eban-bsart,
         END OF ltt_eban .

  TYPES: BEGIN OF ltt_kargo,
*         mus_ozel TYPE char50,                       "commented by ilknurnacar 06042020
         cargo_key TYPE zsog_mm_019_t_02-cargo_key, "added by ilknurnacar 06042020
         matnr    TYPE eban-matnr,
         banfn    TYPE eban-banfn,
         bnfpo    TYPE eban-bnfpo,
         afnam    TYPE eban-afnam,
    END OF ltt_kargo.

  DATA: lt_eban TYPE TABLE OF ltt_eban,
        ls_eban TYPE ltt_eban.

  DATA: lt_talep  TYPE TABLE OF zsog_mm_007_s_talep,
        ls_talep  TYPE zsog_mm_007_s_talep.

*  DATA: lt_kargo1  TYPE TABLE OF zsog_mm_006_t_02,                        " commented by ilknurnacar -06042020
*        ls_kargo1  TYPE zsog_mm_006_t_02.
*
*  DATA: lt_kargo2  TYPE TABLE OF ltt_kargo,
*        ls_kargo2  TYPE ltt_kargo.

*  DATA: lr_mus_ozel TYPE RANGE OF zsog_mm_006_t_03-musteri_ozel_kodu
*        WITH HEADER LINE.
  DATA: "lv_mus_ozel TYPE string,                                      " end of commented by ilknurnacar -06042020
        lv_matnr    TYPE char18,
        lv_afnam    TYPE char10.
*   DATA: lt_kargo TYPE TABLE OF zsog_mm_006_t_03,                      " commented by ilknurnacar -06042020
*        ls_kargo TYPE zsog_mm_006_t_03.                                " commented by ilknurnacar -06042020

  DATA: lt_kargo1  TYPE TABLE OF zsog_mm_019_t_02,
       ls_kargo1  TYPE zsog_mm_019_t_02.

  DATA: lt_kargo2  TYPE TABLE OF ltt_kargo,
        ls_kargo2  TYPE ltt_kargo.
  DATA: lr_cargo_key TYPE RANGE OF zsog_mm_019_t_03-cargo_key  " added by ilknurnacar -06042020
        WITH HEADER LINE,
        lv_cargo_key TYPE string.                                    " added by ilknurnacar -06042020

  DATA: lr_bedat TYPE RANGE OF ekko-bedat WITH HEADER LINE.

  DATA: lt_kargo TYPE TABLE OF zsog_mm_019_t_03,                     " added by ilknurnacar -06042020
        ls_kargo TYPE zsog_mm_019_t_03.                             " added by ilknurnacar -06042020

  FIELD-SYMBOLS: <ls_talep> TYPE zsog_mm_007_s_talep.

  SELECT t1~file_date t1~retailer_no AS kunnr  "t2~kunnr
         t3~matnr t3~hkont
    FROM zsg_t_012 AS t1
*    INNER JOIN zsog_mm_007_t_02 AS t2
*            ON t1~retailer_no = t2~retailer_no
*           AND t2~aktive = 'X'
    INNER JOIN zsog_mm_007_t_01 AS t3
            ON t1~article_product_id = t3~article_product_id
           AND t3~aktive = 'X'
    INTO TABLE lt_talep
    WHERE t1~file_date IN s_badat.
  IF sy-subrc NE 0.
    MESSAGE i013(zsg) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  IF lt_talep IS NOT INITIAL.
    SELECT banfn
           bnfpo
           matnr
           afnam
           ebeln
           bsart
           FROM eban
           INTO TABLE lt_eban
           FOR ALL ENTRIES IN lt_talep
           WHERE matnr = lt_talep-matnr
             AND afnam = lt_talep-kunnr
             AND bsart = 'ZSG1'
             AND loekz = ''
             AND ebeln = ''.
  ENDIF.
  SORT lt_talep BY matnr kunnr sil.
  SORT lt_eban  BY matnr afnam.
  DELETE ADJACENT DUPLICATES FROM lt_talep COMPARING matnr kunnr.
  DELETE ADJACENT DUPLICATES FROM lt_eban  COMPARING matnr afnam.
  LOOP AT lt_eban INTO ls_eban.
    READ TABLE lt_talep INTO ls_talep
      WITH KEY matnr = ls_eban-matnr
               kunnr = ls_eban-afnam
               sil   = '' BINARY SEARCH.
    IF sy-subrc EQ 0.
      ls_talep-sil = 'X'.
      MODIFY lt_talep FROM ls_talep TRANSPORTING sil
       WHERE matnr = ls_eban-matnr
         AND kunnr = ls_eban-afnam.
    ENDIF.
    CLEAR: ls_talep.
  ENDLOOP.
  DELETE lt_talep WHERE sil = 'X'.
  "Kargo statüsü için gerekli veriler alınıyor
  IF lt_talep[] IS NOT INITIAL.

    lr_bedat = 'IBT'.
    lr_bedat-low = sy-datum - 7 .
    lr_bedat-high = sy-datum.
    APPEND lr_bedat.
    CLEAR lr_bedat.
* " commented by ilknurnacar -06042020
*    SELECT * FROM zsog_mm_006_t_02 AS a
*       INTO TABLE lt_kargo1
*       FOR ALL ENTRIES IN lt_talep
*            WHERE matnr = lt_talep-matnr
*              AND afnam = lt_talep-kunnr
*              AND bedat IN lr_bedat.
* end of commented by ilknurnacar -06042020
* " added by ilknurnacar -06042020
    SELECT * FROM zsog_mm_019_t_02 AS a
          INTO TABLE lt_kargo1
          FOR ALL ENTRIES IN lt_talep
               WHERE matnr = lt_talep-matnr
                 AND afnam = lt_talep-kunnr
                 AND bedat IN lr_bedat.
* end of added by ilknurnacar -06042020
  ENDIF.

  LOOP AT lt_kargo1 INTO ls_kargo1.
* " commented by ilknurnacar -06042020
*    CONCATENATE ls_kargo1-banfn ls_kargo1-bnfpo ls_kargo1-afnam
*           INTO lv_mus_ozel.
*    IF lv_mus_ozel IS NOT INITIAL.
*      lr_mus_ozel = 'IEQ'.
*      lr_mus_ozel-low = lv_mus_ozel.
*      COLLECT lr_mus_ozel.
*
*      MOVE-CORRESPONDING ls_kargo1 TO ls_kargo2.
*      ls_kargo2-mus_ozel = lv_mus_ozel.
*      APPEND ls_kargo2 TO lt_kargo2.
*
*      CLEAR: lr_mus_ozel,ls_kargo1,ls_kargo2.
*    ENDIF.
*    end of commented by ilknurnacar -06042020
*    added by ilknurnacar -06042020
    lv_cargo_key = ls_kargo1-cargo_key.
    IF lv_cargo_key IS NOT INITIAL.
      lr_cargo_key = 'IEQ'.
      lr_cargo_key-low = lv_cargo_key.
      COLLECT lr_cargo_key.

      MOVE-CORRESPONDING ls_kargo1 TO ls_kargo2.
      ls_kargo2-cargo_key = lv_cargo_key.
      APPEND ls_kargo2 TO lt_kargo2.

      CLEAR: lr_cargo_key,ls_kargo1,ls_kargo2.
    ENDIF.
*   end of added by ilknurnacar -06042020
  ENDLOOP.
* " commented by ilknurnacar -06042020
*  SELECT * FROM zsog_mm_006_t_03 AS a
*     INTO TABLE lt_kargo
*          WHERE a~musteri_ozel_kodu IN lr_mus_ozel
*            AND a~durum_kodu NE '6'.
* end of commented by ilknurnacar -06042020"
* added by ilknurnacar -06042020"
  SELECT * FROM zsog_mm_019_t_03 AS a
    INTO TABLE lt_kargo
         WHERE a~cargo_key IN lr_cargo_key
           AND a~operation_code NE '5'.
  SORT lt_kargo  BY cargo_key.
  SORT lt_kargo2 BY cargo_key.
  SORT lt_talep  BY matnr kunnr sil.
* end of added by ilknurnacar -06042020"
  LOOP AT lt_kargo INTO ls_kargo.

*    READ TABLE lt_kargo2 INTO ls_kargo2
*    WITH KEY mus_ozel = ls_kargo-musteri_ozel_kodu.  * commented by ilknurnacar -06042020"
    CLEAR ls_kargo2.
    READ TABLE lt_kargo2 INTO ls_kargo2                 " added by ilknurnacar -06042020"
                         WITH KEY cargo_key = ls_kargo-cargo_key .
    IF sy-subrc = 0.
      lv_matnr = ls_kargo2-matnr.
      lv_afnam = ls_kargo2-afnam.

      CLEAR ls_talep.
      READ TABLE lt_talep INTO ls_talep
                          WITH KEY matnr = lv_matnr
                                   kunnr = lv_afnam
                                   sil   = '' BINARY SEARCH.
      IF sy-subrc EQ 0.
        ls_talep-sil = 'X'.
        MODIFY lt_talep FROM ls_talep TRANSPORTING sil
                                      WHERE matnr = lv_matnr
                                        AND kunnr = lv_afnam.
      ENDIF.
    ENDIF.
    CLEAR: ls_talep,lv_matnr,lv_afnam.
  ENDLOOP.
  DELETE lt_talep WHERE sil = 'X'.

  IF lt_talep IS INITIAL.
    MESSAGE i013(zsg) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  PERFORM fill_bapi_sat TABLES lt_talep.
ENDFORM.                    " SAT_OLUSTUR
*&---------------------------------------------------------------------*
*&      Form  SIPARIS_HESAPLA_DUZENLE
*&---------------------------------------------------------------------*
FORM siparis_hesapla_duzenle .
  TYPES:BEGIN OF ltt_talep_eden_malzeme,
         afnam TYPE eban-afnam,
         matnr TYPE eban-matnr,
         name1 TYPE kna1-name1,
         maktx TYPE makt-maktx,
         badat TYPE eban-badat,"xmustafao
         banfn TYPE	eban-banfn,
         bnfpo TYPE eban-bnfpo,
         menge TYPE eban-menge,
         meins TYPE eban-meins,
        END OF ltt_talep_eden_malzeme.
  DATA: lt_talep_eden_malzeme TYPE TABLE OF ltt_talep_eden_malzeme,
        ls_talep_eden_malzeme TYPE ltt_talep_eden_malzeme.

  TYPES: BEGIN OF ltt_hesap,
           matnr                    TYPE eban-matnr,
           afnam                    TYPE eban-afnam,
           badat                    TYPE eban-badat,
           bsart                    TYPE eban-bsart,
           werks                    TYPE eban-werks,
           ebeln                    TYPE eban-ebeln,
           ebelp                    TYPE eban-ebelp,
           emeins                   TYPE eban-meins,"damlap ekledi
           banfn                    TYPE eket-banfn,
           bnfpo                    TYPE eket-bnfpo,
           menge                    TYPE eket-menge,
           meins                    TYPE ekpo-meins,
           fire                     TYPE zsog_mm_007_t_01-fire      ,
           game_no                  TYPE zsog_mm_007_t_01-game_no   ,
           retailer_no              TYPE zsog_mm_007_t_02-retailer_no,
           lgort                    TYPE mchb-lgort,
           charg                    TYPE mchb-charg,
           clabs                    TYPE mchb-clabs,
         END OF ltt_hesap.
  DATA: lt_hesap    TYPE TABLE OF ltt_hesap,
        ls_hesap    TYPE  ltt_hesap.

  TYPES:BEGIN OF ltt_marm,
       matnr TYPE marm-matnr,
       meinh TYPE marm-meinh,
       umrez TYPE marm-umrez,
       zolcu_kodu TYPE zsog_mm_007_t_05-olcu_kodu,
      END OF ltt_marm.
  DATA: lt_birim TYPE TABLE OF ltt_marm,
        ls_birim TYPE ltt_marm.
  DATA: ls_grid_alv TYPE  zsog_mm_007_s_001.

  TYPES: BEGIN OF ltt_siparis_miktari ,
         afnam TYPE eban-afnam,
         matnr TYPE eban-matnr,
         menge TYPE eket-menge,
         meins TYPE ekpo-meins,
         emeins TYPE eban-meins,"damlap ekledi
         END OF ltt_siparis_miktari.
  DATA: lt_siparis_miktari TYPE TABLE OF ltt_siparis_miktari,
        ls_siparis_miktari TYPE ltt_siparis_miktari.

  TYPES: BEGIN OF ltt_fire,
          matnr TYPE eban-matnr,
          fire  TYPE zsog_mm_007_t_01-fire,
         END OF ltt_fire.
  DATA: lt_fire TYPE STANDARD TABLE OF ltt_fire WITH NON-UNIQUE KEY
  matnr,
        ls_fire TYPE ltt_fire.

  TYPES: BEGIN OF ltt_satis_miktari,
         afnam TYPE eban-afnam,
         matnr TYPE eban-matnr,
*         no_of_sold_wagers TYPE zsg_t_001-no_of_sold_wagers       ,"burcua 191119
         no_of_sold_playslips TYPE zsg_t_001-no_of_sold_wagers     ,
         END OF ltt_satis_miktari.
  DATA: lt_satis_miktari TYPE SORTED TABLE OF ltt_satis_miktari WITH
  UNIQUE KEY afnam matnr,
        ls_satis_miktari TYPE ltt_satis_miktari.

  DATA: lt_satis_miktr_hafta TYPE SORTED TABLE OF ltt_satis_miktari WITH  "011219 burcua
  UNIQUE KEY afnam matnr,
        ls_satis_miktr_hafta TYPE ltt_satis_miktari.
  DATA: lv_index TYPE sy-index.
  DATA: lv_begin_date TYPE datum.

  TYPES: BEGIN OF ltt_tahmini_stok,
         afnam TYPE eban-afnam,
         matnr TYPE eban-matnr,
         clabs TYPE mchb-clabs,
         END OF ltt_tahmini_stok.
  DATA: lt_tahmini_stok TYPE SORTED TABLE OF ltt_tahmini_stok WITH
  UNIQUE KEY afnam matnr,
        ls_tahmini_stok TYPE ltt_tahmini_stok.

  """ZSG_T_013 ZSG_T_027 ile değiştirildi . 19112019 burcua
*  TYPES: BEGIN OF ltt_sbs_total,
*          retailer_no            TYPE zsg_t_013-retailer_no           ,
*          game_no                TYPE zsg_t_013-game_no               ,
*          max_date               TYPE zsg_t_013-max_date              ,
*          sales_amount           TYPE zsg_t_013-sales_amount          ,
*          no_of_sold_wagers      TYPE zsg_t_013-no_of_sold_wagers     ,
*          no_of_sold_bets        TYPE zsg_t_013-no_of_sold_bets       ,
*          cancelled_sales_amount TYPE zsg_t_013-cancelled_sales_amount,
*          no_of_cancelled_wagers TYPE zsg_t_013-no_of_cancelled_wagers,
*         END OF ltt_sbs_total.

  TYPES: BEGIN OF ltt_sbs_total,
          retailer_no               TYPE zsg_t_027-retailer_no              ,
          game_no                   TYPE zsg_t_027-game_no                  ,
          max_date                  TYPE zsg_t_027-max_date                 ,
          sales_amount              TYPE zsg_t_027-sales_amount             ,
          no_of_sold_playslips      TYPE zsg_t_027-no_of_sold_playslips     ,
          no_of_sold_bets           TYPE zsg_t_027-no_of_sold_bets          ,
          cancelled_sales_amount    TYPE zsg_t_027-cancelled_sales_amount   ,
          no_of_cancelled_playslips TYPE zsg_t_027-no_of_cancelled_playslips,
          no_of_cancelled_bets      TYPE zsg_t_027-no_of_cancelled_bets,
         END OF ltt_sbs_total.

  TYPES: BEGIN OF ltt_sbs_total2,
        retailer_no               TYPE zsg_t_028-retailer_no              ,
        game_no                   TYPE zsg_t_028-game_no                  ,
        file_date                 TYPE zsg_t_028-file_date                 ,
        sales_amount              TYPE zsg_t_028-sales_amount             ,
        no_of_sold_playslips      TYPE zsg_t_028-no_of_sold_playslips     ,
        no_of_sold_bets           TYPE zsg_t_028-no_of_sold_bets          ,
        cancelled_sales_amount    TYPE zsg_t_028-cancelled_sales_amount   ,
        no_of_cancelled_playslips TYPE zsg_t_028-no_of_cancelled_playslips,
        no_of_cancelled_bets      TYPE zsg_t_028-no_of_cancelled_bets,
       END OF ltt_sbs_total2.

  DATA: lt_sbs_total TYPE HASHED TABLE OF ltt_sbs_total WITH UNIQUE KEY
        retailer_no game_no,
        ls_sbs_total TYPE ltt_sbs_total.
  DATA: lt_sbs_total2 TYPE HASHED TABLE OF ltt_sbs_total2 WITH UNIQUE KEY
        retailer_no game_no file_date,
        ls_sbs_total2 TYPE ltt_sbs_total2.
  DATA: lt_sbs_total3 TYPE TABLE OF ltt_sbs_total2,
        ls_sbs_total3 TYPE ltt_sbs_total2.

  DATA: lt_sasa_giden TYPE TABLE OF zsog_mm_007_t_03,
        ls_sasa_giden TYPE zsog_mm_007_t_03.

  TYPES: BEGIN OF ltt_matnr,
      matnr  TYPE zsog_mm_007_t_01-matnr,
  END OF ltt_matnr.

  DATA: lt_matnr TYPE TABLE OF ltt_matnr,
        ls_matnr TYPE ltt_matnr.
  DATA: lr_matnr TYPE RANGE OF zsog_mm_007_t_01-matnr,
        ls_r_matnr LIKE LINE OF lr_matnr.
  DATA: lv_sonuc TYPE char5.
  DATA: ls_color TYPE lvc_s_scol,
        lt_color TYPE lvc_t_scol.
  DATA: lc_date TYPE sy-datum.
  DATA: lt_malzeme_ob  TYPE TABLE OF zsog_mm_007_t_05,
        ls_malzeme_ob  TYPE zsog_mm_007_t_05.

  DATA: lv_objective_righthandside TYPE genios_float.
  DATA: ls_return TYPE zsog_mm_007_genios_return.

  IF sy-sysid EQ 'DHP'.
    lc_date = '20190828'.
  ELSE.
    lc_date = sy-datum - 3.
  ENDIF.

  lv_begin_date = sy-datum - 14.

*  lc_date = sy-datum - 3.

  DATA : lv_retailer_no TYPE char12.

  FIELD-SYMBOLS : <ls_hesap> TYPE ltt_hesap.

**   damlap 25.07.2019 ----> başlangıç
  SELECT matnr
    FROM zsog_mm_007_t_01
     INTO TABLE lt_matnr
          WHERE matnr IN s_matnr.
*
  LOOP AT lt_matnr INTO ls_matnr.
    ls_r_matnr-sign   = 'I'.
    ls_r_matnr-option = 'EQ'.
    ls_r_matnr-low    = ls_matnr-matnr.
    COLLECT ls_r_matnr INTO lr_matnr .
    CLEAR: ls_r_matnr.
  ENDLOOP.

  SELECT  e~afnam
          e~matnr
          k~name1
          t~maktx
          e~badat "xmustafao
          e~banfn
          e~bnfpo
          e~menge
          e~meins
         INTO TABLE lt_talep_eden_malzeme
         FROM eban AS e
         INNER JOIN kna1 AS k ON e~afnam = k~kunnr
         INNER JOIN makt AS t ON e~matnr = t~matnr
                             AND t~spras = sy-langu
         WHERE e~badat IN s_badat
           AND e~afnam IN s_kunnr
           AND e~matnr IN lr_matnr
           AND e~loekz = ''
           AND e~ebeln = ''
           AND e~bsart = 'ZSG1'
           AND e~werks = '2425'
         GROUP BY e~afnam
                  e~matnr
                  k~name1
                  t~maktx
                  e~badat "xmustafao
                  e~banfn
                  e~bnfpo
                  e~menge
                  e~meins.

  IF sy-subrc NE 0.
    MESSAGE i010(zsg) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  IF lt_talep_eden_malzeme IS NOT INITIAL.
    SELECT * FROM zsog_mm_007_t_03 INTO TABLE lt_sasa_giden
             FOR ALL ENTRIES IN lt_talep_eden_malzeme
             WHERE kunnr = lt_talep_eden_malzeme-afnam
               AND matnr = lt_talep_eden_malzeme-matnr
               AND ebeln = ''.

    SORT lt_sasa_giden BY kunnr matnr.

  ENDIF.

  SELECT e~matnr
         e~afnam
         e~badat
         e~bsart
         e~werks
         e~ebeln
         e~ebelp
         e~meins
         ek~banfn
         ek~bnfpo
         ek~menge
         p~meins
         m1~fire
         m1~game_no
         e~afnam AS retailer_no  "xbaltunbas 200819
         b~lgort
         b~charg
         b~clabs
         INTO CORRESPONDING FIELDS OF TABLE lt_hesap
         FROM eban AS e
         INNER JOIN zsog_mm_007_t_01 AS m1 ON m1~matnr = e~matnr
                                          AND m1~aktive = 'X'
*         INNER JOIN zsog_mm_007_t_02 AS m2 ON m2~kunnr = e~afnam
    "xbaltunbas 200819
*                                          AND m2~aktive = 'X'
         LEFT OUTER JOIN mchb AS b ON b~werks = e~werks
                                  AND b~matnr = e~matnr
                                  AND b~charg = e~afnam
                                  AND b~lgort = 'D001'
         LEFT OUTER JOIN eket AS ek ON e~ebeln = ek~ebeln
                                   AND e~ebelp = ek~ebelp
                                   AND e~banfn = ek~banfn
                                   AND e~bnfpo = ek~bnfpo
         LEFT OUTER JOIN ekpo AS p ON  e~ebeln = p~ebeln
                                   AND e~ebelp = p~ebelp
*           WHERE e~badat IN s_badat "damlap kapattı.
           WHERE e~afnam IN s_kunnr
             AND e~matnr IN lr_matnr
*           AND p~loekz = ''
             AND e~ebeln <> ''
             AND e~bsart = 'ZSG1'
             AND e~werks = '2425'
             AND e~loekz = ''.

  IF lt_hesap IS NOT INITIAL.

    SELECT retailer_no
           game_no
           max_date
           sales_amount
           no_of_sold_playslips
           no_of_sold_bets
           cancelled_sales_amount
           no_of_cancelled_playslips
           no_of_cancelled_bets
       FROM zsg_t_027 INTO TABLE lt_sbs_total
       FOR ALL ENTRIES IN lt_hesap
       WHERE retailer_no = lt_hesap-retailer_no
         AND game_no     = lt_hesap-game_no.


    SELECT retailer_no
     game_no
     file_date
     sales_amount
     no_of_sold_playslips
     no_of_sold_bets
     cancelled_sales_amount
     no_of_cancelled_playslips
     no_of_cancelled_bets
 FROM zsg_t_028 INTO TABLE lt_sbs_total2
  FOR ALL ENTRIES IN lt_hesap
       WHERE retailer_no = lt_hesap-retailer_no
         AND game_no     = lt_hesap-game_no
         AND file_date   > lv_begin_date .

  ENDIF.




  SELECT malzeme
         olcu_birimi
         mlzme_miktar
         olcu_kodu
    FROM zsog_mm_007_t_05
    INTO TABLE lt_birim
    FOR ALL ENTRIES IN lt_hesap
    WHERE malzeme = lt_hesap-matnr.


  SELECT * FROM zsog_mm_007_t_05 INTO TABLE lt_malzeme_ob.
  SORT lt_malzeme_ob BY malzeme.

  LOOP AT lt_hesap INTO ls_hesap.
    ls_siparis_miktari-afnam = ls_hesap-afnam.
    ls_siparis_miktari-matnr = ls_hesap-matnr.
    ls_siparis_miktari-menge = ls_hesap-menge.
    ls_siparis_miktari-meins = ls_hesap-meins.
    ls_siparis_miktari-emeins = ls_hesap-emeins."damlap ekledi
    COLLECT ls_siparis_miktari INTO lt_siparis_miktari.

    ls_fire-matnr = ls_hesap-matnr.
    ls_fire-fire  = ls_hesap-fire.
    APPEND ls_fire TO lt_fire.


    READ TABLE lt_tahmini_stok TRANSPORTING NO FIELDS WITH KEY afnam = ls_hesap-afnam
                                                               matnr = ls_hesap-matnr.
    IF sy-subrc NE 0.
      CLEAR ls_tahmini_stok.
      ls_tahmini_stok-afnam = ls_hesap-afnam.
      ls_tahmini_stok-matnr = ls_hesap-matnr.
      ls_tahmini_stok-clabs = ls_hesap-clabs.
      INSERT ls_tahmini_stok INTO TABLE lt_tahmini_stok.

*    COLLECT ls_tahmini_stok INTO lt_tahmini_stok.  "mustafao
    ENDIF.
    CLEAR: ls_siparis_miktari, ls_fire, ls_tahmini_stok.
  ENDLOOP.

  ""
  LOOP AT lt_sbs_total2 INTO ls_sbs_total2 WHERE file_date > lv_begin_date
                                              AND file_date <= sy-datum.

    MOVE-CORRESPONDING ls_sbs_total2 TO ls_sbs_total3.
    CLEAR : ls_sbs_total3-file_date.
    COLLECT ls_sbs_total3 INTO lt_sbs_total3.
    CLEAR: ls_sbs_total3,ls_sbs_total2.
  ENDLOOP.
  ""

  SORT lt_hesap BY afnam matnr.
  DELETE ADJACENT DUPLICATES FROM lt_hesap COMPARING afnam matnr.
  LOOP AT lt_hesap INTO ls_hesap.
    READ TABLE lt_sbs_total INTO ls_sbs_total
    WITH TABLE KEY retailer_no = ls_hesap-retailer_no
                       game_no = ls_hesap-game_no.
    IF sy-subrc EQ 0.
      ls_satis_miktari-afnam = ls_hesap-afnam.
      ls_satis_miktari-matnr = ls_hesap-matnr.
      "191119 burcua
*      ls_satis_miktari-no_of_sold_wagers =
*      ls_sbs_total-no_of_sold_wagers.

      ls_satis_miktari-no_of_sold_playslips =
      ls_sbs_total-no_of_sold_playslips.

      COLLECT ls_satis_miktari INTO lt_satis_miktari.

    ENDIF.
    CLEAR: ls_satis_miktari, ls_sbs_total.

    READ TABLE lt_sbs_total3 INTO ls_sbs_total3
    WITH KEY retailer_no = ls_hesap-retailer_no
             game_no = ls_hesap-game_no.
    IF sy-subrc EQ 0.
      ls_satis_miktr_hafta-afnam = ls_hesap-afnam.
      ls_satis_miktr_hafta-matnr = ls_hesap-matnr.
      "191119 burcua
*      ls_satis_miktari-no_of_sold_wagers =
*      ls_sbs_total-no_of_sold_wagers.

      ls_satis_miktr_hafta-no_of_sold_playslips =
      ls_sbs_total3-no_of_sold_playslips.

      COLLECT ls_satis_miktr_hafta INTO lt_satis_miktr_hafta.

    ENDIF.


    CLEAR: ls_satis_miktari, ls_sbs_total,ls_sbs_total3, ls_satis_miktr_hafta.
  ENDLOOP.

  DELETE ADJACENT DUPLICATES FROM lt_fire COMPARING matnr.
  DELETE ADJACENT DUPLICATES FROM lt_tahmini_stok COMPARING afnam matnr.  "mustafao
  SORT lt_siparis_miktari BY afnam matnr.

  LOOP AT lt_talep_eden_malzeme INTO ls_talep_eden_malzeme.
    READ TABLE lt_sasa_giden INTO ls_sasa_giden
      WITH KEY kunnr = ls_talep_eden_malzeme-afnam
               matnr = ls_talep_eden_malzeme-matnr
      BINARY SEARCH.
    IF sy-subrc EQ 0.
      CONTINUE.
    ENDIF.

    ls_grid_alv-kunnr = ls_talep_eden_malzeme-afnam.
    ls_grid_alv-matnr = ls_talep_eden_malzeme-matnr.
    ls_grid_alv-name1 = ls_talep_eden_malzeme-name1.
    ls_grid_alv-maktx = ls_talep_eden_malzeme-maktx.
    ls_grid_alv-badat = ls_talep_eden_malzeme-badat.  "xmustafao
    ls_grid_alv-banfn = ls_talep_eden_malzeme-banfn.
    ls_grid_alv-bnfpo = ls_talep_eden_malzeme-bnfpo.




    READ TABLE lt_siparis_miktari INTO ls_siparis_miktari
    WITH KEY afnam = ls_talep_eden_malzeme-afnam
             matnr = ls_talep_eden_malzeme-matnr
    BINARY SEARCH.
    ls_grid_alv-toplam_siparis_miktari = ls_siparis_miktari-menge.
    ls_grid_alv-toplam_siparis_meins   = ls_siparis_miktari-meins.
    ls_grid_alv-meins                  = ls_siparis_miktari-emeins.
    "damla ekledi

    READ TABLE lt_fire INTO ls_fire
    WITH KEY matnr = ls_talep_eden_malzeme-matnr.

    ls_grid_alv-fire = ls_fire-fire.


    READ TABLE lt_satis_miktari INTO ls_satis_miktari
    WITH KEY  afnam = ls_talep_eden_malzeme-afnam
              matnr = ls_talep_eden_malzeme-matnr.

    READ TABLE lt_satis_miktr_hafta INTO ls_satis_miktr_hafta
    WITH KEY  afnam = ls_talep_eden_malzeme-afnam
              matnr = ls_talep_eden_malzeme-matnr.


*    ls_grid_alv-no_of_sold_wagers = ls_satis_miktari-no_of_sold_playslips.  "burcua comment 021219
    ls_grid_alv-no_of_sold_wagers = ls_satis_miktari-no_of_sold_playslips.  "burcua 021219
    ls_grid_alv-fire_miktari = ( ls_grid_alv-no_of_sold_wagers / ( ( 100 -
    ls_grid_alv-fire ) / 100 ) ) - ls_grid_alv-no_of_sold_wagers.

    READ TABLE lt_tahmini_stok INTO ls_tahmini_stok
     WITH KEY  afnam = ls_talep_eden_malzeme-afnam
               matnr = ls_talep_eden_malzeme-matnr.

    ls_grid_alv-clabs = ls_tahmini_stok-clabs.
*    ls_grid_alv-ort_gunluk_satis_miktari = ls_grid_alv-no_of_sold_wagers  "burcua comment 021219
*    / ( sy-datum - lc_date ).
    ls_grid_alv-ort_gunluk_satis_miktari = ls_satis_miktr_hafta-no_of_sold_playslips / 2 .
    ls_grid_alv-tahmin_siparis_miktari =
    ls_grid_alv-ort_gunluk_satis_miktari - ls_grid_alv-clabs.
    ls_grid_alv-siparis_miktari = ls_grid_alv-tahmin_siparis_miktari +
                                  ( ls_grid_alv-tahmin_siparis_miktari *
                                  ls_grid_alv-fire  ) / 100.
*    ls_grid_alv-siparis_miktari = ls_grid_alv-ihtiyac_mik +
*                                  ( ls_grid_alv-ihtiyac_mik *
*                                  ls_grid_alv-fire  ) / 100.

    IF ls_grid_alv-siparis_miktari < 0.
      ls_color-color-col = 6.
      ls_color-color-int = 0.
      ls_color-color-inv = 0.
      APPEND ls_color TO ls_grid_alv-cellcolor.
    ELSEIF ls_grid_alv-siparis_miktari EQ 0.
      ls_grid_alv-siparis_miktari = ls_talep_eden_malzeme-menge.
*      ls_grid_alv-siparis_meins   = ls_talep_eden_malzeme-meins.
*      ls_grid_alv-meins                  = ls_siparis_miktari-emeins.
    ENDIF.

    ls_grid_alv-ihtiyac_mik =  ls_grid_alv-siparis_miktari.
    READ TABLE lt_malzeme_ob INTO ls_malzeme_ob WITH KEY malzeme =
    ls_grid_alv-matnr BINARY SEARCH.
    IF ls_grid_alv-ihtiyac_mik > 0.
      IF ls_malzeme_ob-counter EQ '1'.
        IF ls_malzeme_ob-mlzme_miktar EQ '3000'.

          ls_grid_alv-mikt_3000        = ceil(
          ls_grid_alv-siparis_miktari / 3000 ).
          ls_grid_alv-ob_3000          = ls_malzeme_ob-olcu_birimi.
          ls_grid_alv-onerilen_sip     =  ls_grid_alv-mikt_3000  * 3000
          .
          ls_grid_alv-siparis_miktari  = ls_grid_alv-onerilen_sip.

        ELSEIF ls_malzeme_ob-mlzme_miktar EQ '1000'.

          ls_grid_alv-mikt_1000       = ceil(
          ls_grid_alv-siparis_miktari / 1000 ).
          ls_grid_alv-ob_1000         = ls_malzeme_ob-olcu_birimi.
          ls_grid_alv-onerilen_sip    =  ls_grid_alv-mikt_1000  * 1000 .
          ls_grid_alv-siparis_miktari = ls_grid_alv-onerilen_sip.

        ELSEIF ls_malzeme_ob-mlzme_miktar EQ '4'.

          ls_grid_alv-mikt_4           = ceil(
          ls_grid_alv-siparis_miktari / 4 ).
          ls_grid_alv-ob_4             = ls_malzeme_ob-olcu_birimi.
          ls_grid_alv-onerilen_sip     = ls_grid_alv-mikt_4  * 4 .
          ls_grid_alv-siparis_miktari  = ls_grid_alv-onerilen_sip.

        ENDIF.
      ELSEIF ls_malzeme_ob-counter EQ '2'.
        lv_objective_righthandside = ls_grid_alv-siparis_miktari.
        IF ls_grid_alv-siparis_miktari > 6000.


          CALL FUNCTION 'ZSOG_MM_007_GENIOS'
            EXPORTING
              iv_objective_righthandside = lv_objective_righthandside
            IMPORTING
              es_return                  = ls_return.
          ls_grid_alv-mikt_6000   = ls_return-xvalue.
          ls_grid_alv-mikt_10000  = ls_return-yvalue.

        ELSE.
          ls_grid_alv-mikt_6000   = 1.
        ENDIF.

        LOOP AT lt_malzeme_ob INTO ls_malzeme_ob WHERE malzeme =
        ls_grid_alv-matnr.
          IF ls_malzeme_ob-mlzme_miktar EQ '6000'.
            ls_grid_alv-ob_6000  = ls_malzeme_ob-olcu_birimi.
          ELSEIF ls_malzeme_ob-mlzme_miktar EQ '10000'.
            ls_grid_alv-ob_10000 = ls_malzeme_ob-olcu_birimi.
          ENDIF.
        ENDLOOP.

        ls_grid_alv-onerilen_sip =  ls_grid_alv-mikt_6000  * 6000 +
                                    ls_grid_alv-mikt_10000 * 10000.
        ls_grid_alv-siparis_miktari = ls_grid_alv-onerilen_sip.
      ENDIF.
    ENDIF.

    APPEND ls_grid_alv TO <grid_alv>.
    CLEAR: ls_grid_alv, ls_siparis_miktari, ls_fire, ls_satis_miktari,
           ls_color, lv_sonuc,ls_malzeme_ob, ls_return, lv_objective_righthandside,
           ls_satis_miktari,ls_satis_miktr_hafta,ls_tahmini_stok.
  ENDLOOP.

  CALL SCREEN 1903.
ENDFORM.                    " SIPARIS_HESAPLA_DUZENLE
*&---------------------------------------------------------------------*
*&      Form  SAS_OLUSTUR
*&---------------------------------------------------------------------*
FORM sas_olustur .
  DATA: lt_sasa_giden TYPE TABLE OF zsog_mm_007_t_03,
        ls_sasa_giden TYPE zsog_mm_007_t_03.

  SELECT * FROM zsog_mm_007_t_03 INTO TABLE <grid_alv>
                                      WHERE kunnr IN s_kunnr
                                        AND matnr IN s_matnr
                                        AND ebeln EQ ''.
  IF sy-subrc NE 0.
    MESSAGE i013(zsg) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  CALL SCREEN 1903.
ENDFORM.                    " SAS_OLUSTUR
*&---------------------------------------------------------------------*
*&      Form  SIPARIS_DURUM_RAPORU
*&---------------------------------------------------------------------*
FORM siparis_durum_raporu .
  TYPES: BEGIN OF ltt_eban,
         banfn TYPE eban-banfn,
         bnfpo TYPE eban-bnfpo,
         badat TYPE eban-badat,
         matnr TYPE eban-matnr,
         menge TYPE eban-menge,
         meins TYPE eban-meins,
         maktx TYPE makt-maktx,
         afnam TYPE eban-afnam,
         ebeln TYPE eban-ebeln,
         ebelp TYPE eban-ebelp,
         bsart TYPE eban-bsart,
         name1 TYPE kna1-name1,
         kunnr TYPE kna1-kunnr,
         loekz TYPE eban-loekz,
         ernam TYPE eban-ernam,    """""added by Prodea Anıl YILDIRIM - 10.09.2019 16:53:51
         END OF ltt_eban .
  DATA: lt_eban   TYPE TABLE OF ltt_eban,
        lt_eban2 TYPE TABLE OF ltt_eban,
        ls_eban TYPE ltt_eban.

  TYPES: BEGIN OF ltt_siparis,
         ebeln TYPE ekko-ebeln,
         ebelp TYPE ekpo-ebelp,
         werks TYPE ekpo-werks,
         name1 TYPE t001w-name1,
         bedat TYPE ekko-bedat ,
         menge TYPE eket-menge,
         meins TYPE ekpo-meins,
         banfn TYPE eket-banfn,
         bnfpo TYPE eket-bnfpo,
        END OF ltt_siparis.
  DATA: lt_siparis TYPE TABLE OF ltt_siparis,
        ls_siparis TYPE ltt_siparis.

  TYPES: BEGIN OF ltt_mseg,
          mblnr       TYPE  mseg-mblnr     ,
          mjahr       TYPE  mseg-mjahr     ,
          zeile       TYPE  mseg-zeile     ,
          ebeln       TYPE  mseg-ebeln     ,
          ebelp       TYPE  mseg-ebelp     ,
          charg       TYPE  mseg-charg     ,
          budat_mkpf  TYPE  mseg-budat_mkpf,
          menge       TYPE  mseg-menge     ,   """""added by Prodea Anıl YILDIRIM - 10.09.2019 16:53:51
          meins       TYPE  mseg-meins     ,   """""added by Prodea Anıl YILDIRIM - 10.09.2019 16:53:51
         END OF ltt_mseg.
  DATA: lt_mseg TYPE TABLE OF ltt_mseg,
        ls_mseg TYPE ltt_mseg.

  TYPES: BEGIN OF ltt_cargo,
        ebeln   TYPE  zsog_mm_019_t_02-ebeln,     " zsog_mm_006_t_02 tablosu zsog_mm_019_t_02 e çevrildi
        ebelp   TYPE  zsog_mm_019_t_02-ebelp,     " changed by ilknurnacar 06042020
        afnam   TYPE  zsog_mm_019_t_02-afnam,
        banfn   TYPE  zsog_mm_019_t_02-banfn,
        bnfpo   TYPE  zsog_mm_019_t_02-bnfpo,
        err_code  TYPE  zsog_mm_019_t_02-err_code, " added by ilknurnacar 06042020
*        durum   TYPE  zsog_mm_006_t_02-durum,
*        musteri_ozel_kodu   TYPE  zsog_mm_006_t_03-musteri_ozel_kodu,
*        durumu          TYPE zsog_mm_006_t_03-durumu,
*        kargo_kodu      TYPE zsog_mm_006_t_03-kargo_kodu,
*        teslim_alan     TYPE zsog_mm_006_t_03-teslim_alan,
*        teslim_tarihi   TYPE zsog_mm_006_t_03-teslim_tarihi,
*        teslim_saati    TYPE zsog_mm_006_t_03-teslim_saati,
       END OF ltt_cargo.
  DATA: lt_cargo TYPE TABLE OF ltt_cargo,
        ls_cargo TYPE ltt_cargo.

  TYPES: BEGIN OF ltt_teslimat,
         err_code  TYPE  zsog_mm_019_t_02-err_code, "" added by ilknurnacar 06042020
*        durumu            TYPE  zsog_mm_006_t_03-durumu,      "   commented by ilknurnacar 06042020
*        kargo_kodu        TYPE  zsog_mm_006_t_03-kargo_kodu,  "
*        teslim_alan       TYPE  zsog_mm_006_t_03-teslim_alan,
*        teslim_tarihi     TYPE  zsog_mm_006_t_03-teslim_tarihi,
*        teslim_saati      TYPE  zsog_mm_006_t_03-teslim_saati,
*        musteri_ozel_kodu TYPE  zsog_mm_006_t_03-musteri_ozel_kodu, "end of commented by ilknurnacar 06042020
       END OF ltt_teslimat.
  DATA: lt_teslimat_bilgisi TYPE TABLE OF ltt_teslimat,
        ls_teslimat_bilgisi TYPE ltt_teslimat.

  DATA: ls_alv TYPE zsog_mm_007_s_002.
*  IF cb2 IS NOT INITIAL.
*    SELECT
*         e~banfn
*         e~bnfpo
*         e~badat
*         e~matnr
*         e~menge
*         e~meins
*         t~maktx
*         e~afnam
*         e~ebeln
*         e~ebelp
*         e~bsart
*         k~name1
*         k~kunnr
*         e~loekz
*    INTO TABLE lt_eban
*    FROM eban AS e
*    INNER JOIN makt AS t ON t~matnr = e~matnr
*                        AND t~spras = sy-langu
*    INNER JOIN kna1 AS k ON e~afnam = k~kunnr
*            WHERE e~badat  IN s_badat
*             AND  e~afnam  IN s_kunnr
*             AND  e~matnr  IN s_matnr
*             AND  e~bsart  = 'ZSG1'
*             AND  e~werks  = '2425'
*             AND  e~loekz  = ' '.
*    IF sy-subrc NE 0.
*      MESSAGE i010(zsg) DISPLAY LIKE 'E'.
*      LEAVE LIST-PROCESSING.
*    ENDIF.
*  ELSE.
  SELECT
   e~banfn
   e~bnfpo
   e~badat
   e~matnr
   e~menge
   e~meins
   e~ernam       """""added by Prodea Anıl YILDIRIM - 10.09.2019 16:53:51
   t~maktx
   e~afnam
   e~ebeln
   e~ebelp
   e~bsart
   k~name1
   k~kunnr
INTO CORRESPONDING FIELDS OF TABLE lt_eban
FROM eban AS e
INNER JOIN makt AS t ON t~matnr = e~matnr
                  AND t~spras = sy-langu
INNER JOIN kna1 AS k ON e~afnam = k~kunnr
      WHERE e~badat  IN s_badat
       AND  e~afnam  IN s_kunnr
       AND  e~matnr  IN s_matnr
       AND  e~bsart  = 'ZSG1'
       AND  e~werks  = '2425'.
  IF sy-subrc NE 0.
    MESSAGE i010(zsg) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.
*  ENDIF.

  IF lt_eban IS NOT INITIAL.
    SELECT
      k~ebeln
      p~ebelp
      p~werks
      w~name1
      k~bedat
      t~menge
      p~meins
      t~banfn
      t~bnfpo
      INTO TABLE lt_siparis
      FROM ekko AS k
      INNER JOIN ekpo AS p ON k~ebeln = p~ebeln
      INNER JOIN eket AS t ON p~ebeln = t~ebeln
                          AND p~ebelp = t~ebelp
      INNER JOIN t001w AS w ON p~werks = w~werks
      FOR ALL ENTRIES IN lt_eban
      WHERE k~ebeln = lt_eban-ebeln
        AND t~banfn = lt_eban-banfn
        AND t~bnfpo = lt_eban-bnfpo .

    lt_eban2 = lt_eban.
    DELETE lt_eban2 WHERE ebeln IS INITIAL.

*{   ->>> Commented by Prodea Anıl YILDIRIM - 10.09.2019 16:53:51

*    IF lt_siparis IS NOT INITIAL.
*      SELECT ebeln
*             ebelp
*             afnam
*             banfn
*             bnfpo
*             durum
*        FROM zsog_mm_006_t_02 AS z2
*        INTO CORRESPONDING FIELDS OF TABLE lt_cargo
*        FOR ALL ENTRIES IN lt_siparis
*        WHERE ebeln = lt_siparis-ebeln
*          AND ebelp = lt_siparis-ebelp
*          AND banfn = lt_siparis-banfn
*          AND bnfpo = lt_siparis-bnfpo .
*
*    ENDIF.
*
*    LOOP AT lt_cargo INTO ls_cargo WHERE durum EQ '1'.
*      CONCATENATE ls_cargo-banfn ls_cargo-afnam INTO ls_cargo-musteri_ozel_kodu.
*      MODIFY lt_cargo FROM ls_cargo TRANSPORTING musteri_ozel_kodu.
*      CLEAR: ls_cargo.
*    ENDLOOP.
*
*    SELECT durumu
*           kargo_kodu
*           teslim_alan
*           teslim_tarihi
*           teslim_saati
*           musteri_ozel_kodu
*      FROM zsog_mm_006_t_03
*      INTO TABLE lt_teslimat_bilgisi
*      FOR ALL ENTRIES IN lt_cargo
*      WHERE musteri_ozel_kodu = lt_cargo-musteri_ozel_kodu.
*
*    LOOP AT lt_cargo INTO ls_cargo WHERE durum EQ '1'.
*      READ TABLE lt_teslimat_bilgisi INTO ls_teslimat_bilgisi
*                             WITH KEY musteri_ozel_kodu = ls_cargo-musteri_ozel_kodu
*                                 BINARY SEARCH.
*      ls_cargo-durumu        = ls_teslimat_bilgisi-durumu.
*      ls_cargo-kargo_kodu    = ls_teslimat_bilgisi-kargo_kodu.
*      ls_cargo-teslim_alan   = ls_teslimat_bilgisi-teslim_alan.
*      ls_cargo-teslim_tarihi = ls_teslimat_bilgisi-teslim_tarihi.
*      ls_cargo-teslim_saati  = ls_teslimat_bilgisi-teslim_saati.
*      MODIFY lt_cargo FROM ls_cargo TRANSPORTING durumu kargo_kodu teslim_alan teslim_tarihi teslim_saati.
*    ENDLOOP.

*}    <<<- End of  Commented - 10.09.2019 16:53:51

    IF lt_eban2 IS NOT INITIAL.
*      IF cb1 IS NOT INITIAL.
*        SELECT mblnr
*               mjahr
*               zeile
*               ebeln
*               ebelp
*               charg
*               budat_mkpf
*          FROM mseg INTO TABLE lt_mseg
*          FOR ALL ENTRIES IN lt_eban2
*          WHERE ebeln = lt_eban2-ebeln
*            AND ebelp = lt_eban2-ebelp
*            AND charg = lt_eban2-kunnr
*            AND mblnr = ''.
*      ELSE.

      SELECT mblnr
             mjahr
             zeile
             ebeln
             ebelp
             charg
             budat_mkpf
             menge        """""added by Prodea Anıl YILDIRIM - 10.09.2019 16:53:51
             meins        """""added by Prodea Anıl YILDIRIM - 10.09.2019 16:53:51
        FROM mseg INTO TABLE lt_mseg
        FOR ALL ENTRIES IN lt_eban2
        WHERE ebeln = lt_eban2-ebeln
          AND ebelp = lt_eban2-ebelp
          AND charg = lt_eban2-kunnr.
*      ENDIF.

    ENDIF.
  ENDIF.
  SORT lt_eban BY banfn bnfpo.
  SORT lt_siparis BY ebeln ebelp.
  SORT lt_mseg BY ebeln ebelp charg.
  SORT lt_cargo BY ebeln ebelp banfn bnfpo.

  LOOP AT lt_eban INTO ls_eban.

    ls_alv-banfn        = ls_eban-banfn.
    ls_alv-bnfpo        = ls_eban-bnfpo.
    ls_alv-matnr        = ls_eban-matnr.
    ls_alv-maktx        = ls_eban-maktx.
    ls_alv-badat        = ls_eban-badat.
    ls_alv-sat_menge    = ls_eban-menge.
    ls_alv-sat_meins    = ls_eban-meins.
    ls_alv-kunnr        = ls_eban-afnam.
    ls_alv-name1        = ls_eban-name1.
*{   ->>> Added by Prodea Anıl YILDIRIM - 10.09.2019 18:12:06
    ls_alv-ernam        = ls_eban-ernam.
*    }    <<<- End of  Added - 10.09.2019 18:12:06
    READ TABLE lt_siparis INTO ls_siparis WITH KEY ebeln = ls_eban-ebeln
                                                   ebelp = ls_eban-ebelp
                                                   BINARY SEARCH.
    ls_alv-ebeln         = ls_siparis-ebeln.
    ls_alv-ebelp         = ls_siparis-ebelp.
    ls_alv-bedat         = ls_siparis-bedat.
    ls_alv-termin_menge  = ls_siparis-menge.
    ls_alv-termin_meins  = ls_siparis-meins.
"burada sorun var lt_cargo okunmamış!!! ilknurnacar
    READ TABLE lt_cargo INTO ls_cargo WITH KEY ebeln = ls_eban-ebeln
                                               ebelp = ls_eban-ebelp
                                                   BINARY SEARCH.
    IF sy-subrc EQ '0'.
*      IF ls_cargo-durum EQ '2'.                              "commented by ilknurnacar 06042020
*        ls_alv-cargo_durumu = 'Sipariş Kargoya iletilmedi'.
*      ELSEIF ls_cargo-durum EQ '1'.
*        ls_alv-cargo_durumu = 'Sipariş Kargoya iletildi'.
*        ls_alv-durumu        = ls_cargo-durumu.
*        ls_alv-kargo_kodu    = ls_cargo-kargo_kodu.
*        ls_alv-teslim_alan   = ls_cargo-teslim_alan.
*        ls_alv-teslim_tarihi = ls_cargo-teslim_tarihi.
*        ls_alv-teslim_saati  = ls_cargo-teslim_saati.          "end of commented by ilknurnacar 06042020
*      ENDIF.
*      IF ls_cargo-cargo_result_code EQ '0'.                              "added by ilknurnacar 06042020
*        ls_alv-cargo_durumu = 'Sipariş Kargoya iletildi'.
*        ls_alv-cargo_result_code        = ls_cargo-cargo_result_code.
*      ELSEIF ls_cargo-cargo_result_code EQ '1' OR ls_cargo-cargo_result_code EQ '2'.
*        ls_alv-cargo_durumu = 'Sipariş Kargoya iletilmedi'."added by ilknurnacar 06042020
*      ENDIF.
    ENDIF.
    READ TABLE lt_mseg INTO ls_mseg WITH KEY ebeln = ls_eban-ebeln
                                             ebelp = ls_eban-ebelp
                                             charg =  ls_eban-kunnr
                                             BINARY SEARCH.

    ls_alv-mblnr    = ls_mseg-mblnr.
    ls_alv-mjahr    = ls_mseg-mjahr.
    ls_alv-zeile    = ls_mseg-zeile.
    ls_alv-budat_mkpf = ls_mseg-budat_mkpf.
    ls_alv-mg_menge     = ls_mseg-menge.
    ls_alv-mg_meins     = ls_mseg-meins.
    ls_alv-werks        = ls_siparis-werks.
    ls_alv-werks_name1  = ls_siparis-name1.

    APPEND ls_alv TO gs_scr-1903-alv.
    CLEAR: ls_alv, ls_siparis, ls_mseg, ls_cargo.
  ENDLOOP.
  SORT gs_scr-1903-alv BY banfn bnfpo.

  PERFORM initialize_alv.
  PERFORM display_alv.
ENDFORM.                    " SIPARIS_DURUM_RAPORU
*&---------------------------------------------------------------------*
*&      Form  msg_display_error_table
*&---------------------------------------------------------------------*
FORM msg_display_error_table TABLES pt_return STRUCTURE bapiret2.
  CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
    EXPORTING
      it_message = pt_return[].
ENDFORM.                    "msg_display_error_table
*&---------------------------------------------------------------------*
*&      Form  BAPI_COMMIT_DESTINATION
*&---------------------------------------------------------------------*
FORM bapi_commit_destination .
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' DESTINATION 'NONE'
    EXPORTING
      wait = 'X'.
ENDFORM.                    "bapi_commit_destination
*&---------------------------------------------------------------------*
*&      Form  BAPI_ROLLBACK_DESTINATION
*&---------------------------------------------------------------------*
FORM bapi_rollback_destination .
  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK' DESTINATION 'NONE'.
ENDFORM.                    "bapi_rollback_destination
*&---------------------------------------------------------------------*
*&      Form  GRID_REFRESH
*&---------------------------------------------------------------------*
FORM grid_refresh  USING  pv_grid   TYPE REF TO cl_gui_alv_grid
                          ps_stable TYPE lvc_s_stbl.
  CALL METHOD pv_grid->refresh_table_display
    EXPORTING
      is_stable = ps_stable   " With Stable Rows/Columns
    EXCEPTIONS
      finished  = 1
      OTHERS    = 2.
ENDFORM.                    "grid_refresh
*&---------------------------------------------------------------------*
*&      Form  handle_user_command
*&---------------------------------------------------------------------*
FORM handle_user_command USING i_ucomm TYPE salv_de_function.
  CASE i_ucomm.
    WHEN '&YENI'.
      gs_scr-1903-ucomm_first_alv = '&YENI'.
*      CALL SCREEN 1903.
    WHEN '&DEGISTIR'.
      gs_scr-1903-ucomm_first_alv = '&DEGISTIR'.
*      PERFORM kayit_degistir.
  ENDCASE.
ENDFORM.                    "handle_user_command
*&---------------------------------------------------------------------*
*&      Form  INITIALIZE_ALV
*&---------------------------------------------------------------------*
FORM initialize_alv .
  DATA message   TYPE REF TO cx_salv_msg.

  TRY.
      cl_salv_table=>factory(
      IMPORTING
        r_salv_table = gs_scr-1903-r_alv
      CHANGING
        t_table      = gs_scr-1903-alv ).

      gs_scr-1903-r_columns = gs_scr-1903-r_alv->get_columns( ).

      PERFORM enable_layout_settings.
      PERFORM optimize_column_width.
      PERFORM hide_client_column.
      PERFORM set_column_names.
      PERFORM set_toolbar.
      PERFORM display_settings.
      PERFORM set_hotspot_click.

      " ...
      " PERFORM setting_n.
    CATCH cx_salv_msg INTO message.
      " error handling
  ENDTRY.
ENDFORM.                    "initialize_alv
*&---------------------------------------------------------------------*
*&      Form  enable_layout_settings
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM enable_layout_settings.
*&---------------------------------------------------------------------*
  DATA layout_settings TYPE REF TO cl_salv_layout.
  DATA layout_key      TYPE salv_s_layout_key.


  layout_settings = gs_scr-1903-r_alv->get_layout( ).
  layout_key-report = sy-repid.
  layout_settings->set_key( layout_key ).
  layout_settings->set_save_restriction( if_salv_c_layout=>restrict_none
  ).

  DATA: lr_selections TYPE REF TO cl_salv_selections.
  lr_selections = gs_scr-1903-r_alv->get_selections( ).
  lr_selections->set_selection_mode(
  if_salv_c_selection_mode=>row_column ).

ENDFORM.                    "ENABLE_LAYOUT_SETTINGS

*&---------------------------------------------------------------------*
FORM optimize_column_width.
*&---------------------------------------------------------------------*
  gs_scr-1903-r_columns->set_optimize( ).
ENDFORM.                    "OPTIMIZE_COLUMN_WIDTH

*&---------------------------------------------------------------------*
FORM hide_client_column.
*&---------------------------------------------------------------------*
  DATA not_found TYPE REF TO cx_salv_not_found.

  TRY.
      gs_scr-1903-r_column = gs_scr-1903-r_columns->get_column(
      'CELLTAB' ).
      gs_scr-1903-r_column->set_visible( if_salv_c_bool_sap=>false ).
    CATCH cx_salv_not_found INTO not_found.
      " error handling
  ENDTRY.

  TRY.
      gs_scr-1903-r_column = gs_scr-1903-r_columns->get_column( 'SIL' ).
      gs_scr-1903-r_column->set_visible( if_salv_c_bool_sap=>false ).
    CATCH cx_salv_not_found INTO not_found.
      " error handling
  ENDTRY.


*{   ->>> Added by Prodea Anıl YILDIRIM - 10.09.2019 17:23:32

  TRY.
      gs_scr-1903-r_column = gs_scr-1903-r_columns->get_column(
      'CARGO_DURUMU' ).
      gs_scr-1903-r_column->set_visible( if_salv_c_bool_sap=>false ).
    CATCH cx_salv_not_found INTO not_found.
      " error handling
  ENDTRY.

  TRY.
      gs_scr-1903-r_column = gs_scr-1903-r_columns->get_column(
      'DURUMU' ).
      gs_scr-1903-r_column->set_visible( if_salv_c_bool_sap=>false ).
    CATCH cx_salv_not_found INTO not_found.
      " error handling
  ENDTRY.

  TRY.
      gs_scr-1903-r_column = gs_scr-1903-r_columns->get_column(
      'KARGO_KODU' ).
      gs_scr-1903-r_column->set_visible( if_salv_c_bool_sap=>false ).
    CATCH cx_salv_not_found INTO not_found.
      " error handling
  ENDTRY.

  TRY.
      gs_scr-1903-r_column = gs_scr-1903-r_columns->get_column(
      'TESLIM_ALAN' ).
      gs_scr-1903-r_column->set_visible( if_salv_c_bool_sap=>false ).
    CATCH cx_salv_not_found INTO not_found.
      " error handling
  ENDTRY.

  TRY.
      gs_scr-1903-r_column = gs_scr-1903-r_columns->get_column(
      'TESLIM_TARIHI' ).
      gs_scr-1903-r_column->set_visible( if_salv_c_bool_sap=>false ).
    CATCH cx_salv_not_found INTO not_found.
      " error handling
  ENDTRY.

  TRY.
      gs_scr-1903-r_column = gs_scr-1903-r_columns->get_column(
      'TESLIM_SAATI' ).
      gs_scr-1903-r_column->set_visible( if_salv_c_bool_sap=>false ).
    CATCH cx_salv_not_found INTO not_found.
      " error handling
  ENDTRY.

  TRY.
      gs_scr-1903-r_column = gs_scr-1903-r_columns->get_column(
      'TERMIN_MENGE' ).
      gs_scr-1903-r_column->set_visible( if_salv_c_bool_sap=>false ).
    CATCH cx_salv_not_found INTO not_found.
      " error handling
  ENDTRY.

  TRY.
      gs_scr-1903-r_column = gs_scr-1903-r_columns->get_column(
      'TERMIN_MEINS' ).
      gs_scr-1903-r_column->set_visible( if_salv_c_bool_sap=>false ).
    CATCH cx_salv_not_found INTO not_found.
      " error handling
  ENDTRY.

*}    <<<- End of  Added - 10.09.2019 17:23:32

ENDFORM.                    " HIDE_CLIENT_COLUMN

*&---------------------------------------------------------------------*
FORM set_column_names.
*&---------------------------------------------------------------------*
*  DATA not_found TYPE REF TO cx_salv_not_found.
*
*  TRY.
*      gr_column = gr_columns->get_column( 'WAVWR' ).
*      gr_column->set_short_text( 'Maliyet' ).
*      gr_column->set_medium_text( 'Maliyet' ).
*      gr_column->set_long_text( 'Maliyet' ).
*    CATCH cx_salv_not_found INTO not_found.
*      " error handling
*  ENDTRY.
ENDFORM.                    " SET_DEPARTURE_COUNTRY_COLUMN

*&---------------------------------------------------------------------*
FORM set_toolbar.
*&---------------------------------------------------------------------*
  DATA functions TYPE REF TO cl_salv_functions_list.
  functions = gs_scr-1903-r_alv->get_functions( ).
  functions->set_all( ).

  gs_scr-1903-r_alv->set_screen_status(
    pfstatus      = 'STANDARD'
    report        = sy-repid
    set_functions = gs_scr-1903-r_alv->c_functions_all ).
ENDFORM.                    " SET_TOOLBAR
*&---------------------------------------------------------------------*
FORM display_settings.
*&---------------------------------------------------------------------*
  DATA display_settings TYPE REF TO cl_salv_display_settings.
  DATA: lv_tanim TYPE text70.
  DATA: lv_line TYPE i.
  lv_line  = lines( gs_scr-1903-alv ).
  lv_tanim = |Sipariş Durum Raporu | && |--> | && |{ lv_line }| &&
  |Kayıt Bulundu|.

  display_settings = gs_scr-1903-r_alv->get_display_settings( ).
  display_settings->set_striped_pattern( if_salv_c_bool_sap=>true ).
  display_settings->set_list_header( lv_tanim ).
ENDFORM.                    "display_settings
*&---------------------------------------------------------------------*
*&      Form  SET_HOTSPOT_CLICK
*&---------------------------------------------------------------------*
FORM set_hotspot_click .
*-- events
  gs_scr-1903-r_events = gs_scr-1903-r_alv->get_event( ).
  CREATE OBJECT event_handler.
*  SET HANDLER event_handler->on_link_click   FOR gr_events.
  SET HANDLER event_handler->on_user_command FOR gs_scr-1903-r_events.
ENDFORM.                    "set_hotspot_click
*&---------------------------------------------------------------------*
FORM display_alv.
*&---------------------------------------------------------------------*
  gs_scr-1903-r_alv->display( ).
ENDFORM.                    " DISPLAY_ALV
*&---------------------------------------------------------------------*
*&      Form  1903_EXIT_CODES
*&---------------------------------------------------------------------*
FORM 1903_exit_codes .
  CASE gs_scr-1903-ucomm.
    WHEN '&F03' OR '&F15' OR '&F12' OR 'EXT'.
      CALL METHOD gs_scr-1903-custom_container->free.
      CLEAR: <grid_alv>,
             gs_scr-1903-ucomm_first_alv,
             gs_scr-1903-grid1,
             gs_scr-1903-custom_container.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "1903_exit_codes
*&      Form  SET_FIELDCAT
*&---------------------------------------------------------------------*
FORM set_fieldcat USING lv_structure_name TYPE dd02l-tabname.
  CLEAR:  gs_scr-1903-fieldcat.

  DATA:  ls_fieldcat TYPE lvc_s_fcat.
  CLEAR: ls_fieldcat.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = lv_structure_name
      i_client_never_display = 'X'
      i_bypassing_buffer     = 'X'
    CHANGING
      ct_fieldcat            = gs_scr-1903-fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

*  IF gs_scr-1903-ucomm_first_alv EQ '&YENI'.
  ls_fieldcat-edit = 'X'.
  MODIFY gs_scr-1903-fieldcat FROM ls_fieldcat TRANSPORTING edit
                               WHERE fieldname = 'SIPARIS_MIKTARI'.

  ls_fieldcat-tech = 'X'.
  MODIFY gs_scr-1903-fieldcat FROM ls_fieldcat TRANSPORTING tech
                               WHERE fieldname = 'SIL'.
  ls_fieldcat-tech = 'X'.
  MODIFY gs_scr-1903-fieldcat FROM ls_fieldcat TRANSPORTING tech
                               WHERE fieldname = 'CELLCOLOR'.





*  ELSEIF gs_scr-1903-ucomm_first_alv EQ '&DEGISTIR'.
*    "olur da bir şey eklenirse
*  ENDIF.
*  ls_fieldcat-tech = 'X'.
*  MODIFY gs_scr-1903-fieldcat FROM ls_fieldcat TRANSPORTING tech
*                               WHERE fieldname = 'CELLTAB'
*                                  OR fieldname = 'SIL'.
ENDFORM.                    "set_fieldcat
*&---------------------------------------------------------------------*
*&      Form  EXCLUDE_TB_FUNCTIONS
*&---------------------------------------------------------------------*
FORM exclude_tb_functions  CHANGING pt_exclude TYPE ui_functions.
  CLEAR: pt_exclude.
  DATA ls_exclude TYPE ui_func.

*  ls_exclude =  cl_gui_alv_grid=>mc_fc_excl_all.
*  APPEND ls_exclude TO pt_exclude.
*  CLEAR: ls_exclude.
*  ls_exclude =  cl_gui_alv_grid=>mc_fg_edit.
*  APPEND ls_exclude TO pt_exclude.
*  CLEAR: ls_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_subtot .
*  APPEND ls_exclude TO pt_exclude.
*  CLEAR: ls_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_sum  .
*  APPEND ls_exclude TO pt_exclude.
*  CLEAR: ls_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_print.
*  APPEND ls_exclude TO pt_exclude.
*  CLEAR: ls_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_print_back.
*  APPEND ls_exclude TO pt_exclude.
*  CLEAR: ls_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_print_prev.
*  APPEND ls_exclude TO pt_exclude.
*  CLEAR: ls_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_mb_export.
*  APPEND ls_exclude TO pt_exclude.
*  CLEAR: ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_mb_paste.
  APPEND ls_exclude TO pt_exclude.
  CLEAR: ls_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_mb_subtot.
*  APPEND ls_exclude TO pt_exclude.
*  CLEAR: ls_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_mb_sum.
*  APPEND ls_exclude TO pt_exclude.
*  CLEAR: ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_mb_variant.
  APPEND ls_exclude TO pt_exclude.
  CLEAR: ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_mb_view.
  APPEND ls_exclude TO pt_exclude.
  CLEAR: ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_detail.
  APPEND ls_exclude TO pt_exclude.
  CLEAR: ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_graph.
  APPEND ls_exclude TO pt_exclude.
  CLEAR: ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_help.
  APPEND ls_exclude TO pt_exclude.
  CLEAR: ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_info.

  CLEAR: ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_cut.
  APPEND ls_exclude TO pt_exclude.

  CLEAR: ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy.
  APPEND ls_exclude TO pt_exclude.

  CLEAR: ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy_row.
  APPEND ls_exclude TO pt_exclude.

  CLEAR: ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_delete_row.
  APPEND ls_exclude TO pt_exclude.

  CLEAR: ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_insert_row.
  APPEND ls_exclude TO pt_exclude.

  CLEAR: ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_append_row.
  APPEND ls_exclude TO pt_exclude.

ENDFORM.                    " EXCLUDE_TB_FUNCTIONS
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV_GRID
*&---------------------------------------------------------------------*
FORM display_alv_grid USING lv_structure_name TYPE dd02l-tabname.
  DATA: ls_stable TYPE lvc_s_stbl.
  ls_stable-row = 'X'.
  ls_stable-col = 'X'.

  gs_scr-1903-layout-zebra      = 'X'.
  gs_scr-1903-layout-cwidth_opt = 'X'.
  IF rb5 IS INITIAL.
    gs_scr-1903-layout-sel_mode   = 'D'.
  ELSE.
    gs_scr-1903-layout-no_rowmark   = 'X'.
  ENDIF.
  IF rb2 IS NOT INITIAL.
    gs_scr-1903-layout-stylefname = 'CELLTAB'.
    gs_scr-1903-layout-ctab_fname = 'CELLCOLOR'.
  ENDIF.

  IF gs_scr-1903-custom_container IS INITIAL.
    CREATE OBJECT gs_scr-1903-custom_container
      EXPORTING
        container_name = gs_scr-1903-container.


    IF rb2 IS NOT INITIAL.
      PERFORM set_header_for_po.
      CREATE OBJECT gs_scr-1903-grid1
        EXPORTING
          i_parent = dg_parent_grid.
    ELSE.
      CREATE OBJECT gs_scr-1903-grid1
        EXPORTING
          i_parent = gs_scr-1903-custom_container.
    ENDIF.
**    CREATE OBJECT gs_scr-1903-grid1
**      EXPORTING
**        i_parent = gs_scr-1903-custom_container.
*
*    CREATE OBJECT gs_scr-1903-grid1
*      EXPORTING
*        i_parent = dg_parent_grid.


    CREATE OBJECT gr_alv_event_ref.
    SET HANDLER gr_alv_event_ref->handle_hotspot_click FOR
    gs_scr-1903-grid1.
    SET HANDLER gr_alv_event_ref->handle_toolbar       FOR
    gs_scr-1903-grid1.
    SET HANDLER gr_alv_event_ref->handle_user_command  FOR
    gs_scr-1903-grid1.
    SET HANDLER gr_alv_event_ref->handle_data_changed  FOR
    gs_scr-1903-grid1.
    IF rb2 IS NOT INITIAL.
      SET HANDLER gr_alv_event_ref->top_of_page          FOR
      gs_scr-1903-grid1.
    ENDIF.

*SET HANDLER gr_alv_event_ref->onf4                 FOR
*gs_scr-1903-grid1.
    CALL METHOD gs_scr-1903-grid1->set_table_for_first_display
      EXPORTING
        it_toolbar_excluding = gs_scr-1903-exclude
        i_structure_name     = lv_structure_name
        is_layout            = gs_scr-1903-layout
      CHANGING
        it_outtab            = <grid_alv>
        it_fieldcatalog      = gs_scr-1903-fieldcat.

    CALL METHOD gs_scr-1903-grid1->set_toolbar_interactive.

    CALL METHOD gs_scr-1903-grid1->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified.

    CALL METHOD gs_scr-1903-grid1->set_ready_for_input
      EXPORTING
        i_ready_for_input = 1.


    IF rb2 IS NOT INITIAL.
      CALL METHOD dg_dyndoc_id->initialize_document.
* Processing events
      CALL METHOD gs_scr-1903-grid1->list_processing_events
        EXPORTING
          i_event_name = 'TOP_OF_PAGE'
          i_dyndoc_id  = dg_dyndoc_id.
    ENDIF.

  ELSE.
    PERFORM grid_refresh  USING  gs_scr-1903-grid1
                                 ls_stable.
  ENDIF.
ENDFORM.                    "display_alv_grid
*&---------------------------------------------------------------------*
*&      Form  KAYIT_1903
*&---------------------------------------------------------------------*
FORM kayit_1903 .
  DATA: lt_sat      TYPE TABLE OF zsog_mm_007_t_03,
        ls_sat      TYPE zsog_mm_007_t_03.
  DATA: lt_return   TYPE STANDARD TABLE OF bapiret2,
        ls_return   TYPE  bapiret2,
        lt_return2  TYPE STANDARD TABLE OF bapiret2.
  DATA: lt_pritem   TYPE STANDARD TABLE OF bapimereqitemimp,
        ls_pritem   TYPE  bapimereqitemimp.
  DATA: lt_pritemx  TYPE STANDARD TABLE OF bapimereqitemx,
        ls_pritemx  TYPE bapimereqitemx.

  DATA: lt_praccount  TYPE TABLE OF  bapimereqaccount ,
        ls_praccount  TYPE  bapimereqaccount .
  DATA: lt_praccountx TYPE TABLE OF bapimereqaccountx ,
        ls_praccountx TYPE  bapimereqaccountx .

  DATA: lt_mm_007_t_01 TYPE TABLE OF zsog_mm_007_t_01,
        ls_mm_007_t_01 TYPE zsog_mm_007_t_01.

  DATA: lt_rowindex TYPE lvc_t_row,
        ls_rowindex TYPE lvc_s_row.
  FIELD-SYMBOLS: <fs_alv> TYPE zsog_mm_007_s_001.
  DATA ls_ui_popup_text TYPE wfcsr_ui_popup_text.
  DATA lv_answer        TYPE wfcst_char1.
  DATA: lt_siparis      TYPE TABLE OF zsog_mm_007_t_03,
        ls_siparis      TYPE zsog_mm_007_t_03,
        lv_string       TYPE string.
  DATA: lv_sil TYPE char5,
        lv_x   TYPE char3.
  FIELD-SYMBOLS: <fs_sil> TYPE zsog_mm_007_s_001-sil .

  ls_ui_popup_text-titlebar = 'Kaydet!'.
  ls_ui_popup_text-question =
  'Kayıtlar Sipariş Oluşturma Ekranına Gidecektir! Onaylıyor musunuz?'.

  CALL METHOD gs_scr-1903-grid1->get_selected_rows
    IMPORTING
      et_index_rows = lt_rowindex.
  IF lt_rowindex IS INITIAL.
    MESSAGE i000(zsg) WITH text-004.
    RETURN.
  ENDIF.

  PERFORM ask_question USING ls_ui_popup_text  CHANGING lv_answer.
  IF lv_answer EQ '1'.
    LOOP AT lt_rowindex INTO ls_rowindex.
      READ TABLE <grid_alv> ASSIGNING <fs_alv> INDEX ls_rowindex-index.
      <fs_alv>-sil = 'X'.
      MOVE-CORRESPONDING <fs_alv> TO ls_siparis.
      ls_siparis-mandt = sy-mandt.
      ls_siparis-sil = ''.
      APPEND ls_siparis TO lt_siparis.

      CLEAR: ls_siparis.
    ENDLOOP.
  ENDIF.

  SELECT * FROM zsog_mm_007_t_01 INTO TABLE lt_mm_007_t_01.
  SORT lt_mm_007_t_01 BY matnr.

  LOOP AT lt_siparis INTO ls_siparis WHERE  siparis_miktari <= 0.
    EXIT.
  ENDLOOP.
  IF sy-subrc EQ 0.
*    MESSAGE i000(zsg) WITH text-007.
*    RETURN.
  ENDIF.

  lt_sat = lt_siparis.
  SORT  lt_sat BY banfn.
  DELETE ADJACENT DUPLICATES FROM  lt_sat COMPARING banfn.

  LOOP AT lt_sat INTO ls_sat.
    LOOP AT lt_siparis INTO ls_siparis WHERE banfn = ls_sat-banfn.

      READ TABLE lt_mm_007_t_01 INTO ls_mm_007_t_01
        WITH KEY matnr = ls_siparis-matnr
        BINARY SEARCH.
      " boş gelme olasılığı olmadığı söylendiği için kontol koymadım

      ls_pritem-preq_item  = ls_siparis-bnfpo.
*      ls_pritem-short_text = ls_siparis-maktx.
*      ls_pritem-quantity   = ls_siparis-siparis_miktari.
      ls_pritem-quantity   = '1'.
      ls_pritem-unit       = 'ST'.
      ls_pritem-preq_price = '1'.  "fiyat bulamadığı zaman güncellemiyor.

      ls_praccount-preq_item    = ls_siparis-bnfpo.
      ls_praccount-serial_no    = '01'.
      ls_praccount-gl_account   = ls_mm_007_t_01-hkont.
      ls_praccount-costcenter   = 'SG6006'.

      ls_pritemx-preq_item  = ls_siparis-bnfpo.
*      ls_pritemx-short_text = 'X'.
      ls_pritemx-quantity   = 'X'.
      ls_pritemx-unit       = 'X'.
      ls_pritemx-preq_price = 'X'.

      ls_praccountx-preq_item              =  ls_siparis-bnfpo.
      ls_praccountx-preq_itemx             =  'X' .
      ls_praccountx-serial_no              =  '01'.
      ls_praccountx-serial_nox             =  'X'.
      ls_praccountx-gl_account             =  'X'.
      ls_praccountx-costcenter             =  'X'.


      APPEND ls_pritemx TO lt_pritemx.
      APPEND ls_pritem TO lt_pritem.
      APPEND ls_praccount TO lt_praccount.
      APPEND ls_praccountx TO lt_praccountx.
      CLEAR: ls_pritem, ls_pritemx ,ls_mm_007_t_01 ,ls_praccount,ls_praccountx.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM call_bapi_pr_change TABLES lt_return  lt_pritem
      lt_pritemx lt_praccount lt_praccountx USING ls_sat-banfn.
      LOOP AT lt_return INTO ls_return WHERE type CA 'EAX'.
        EXIT.
      ENDLOOP.
      IF sy-subrc EQ 0.
        PERFORM bapi_rollback_destination.
*        RETURN.
      ELSE.
        PERFORM bapi_commit_destination.
      ENDIF.
      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO lt_return2.
      ENDIF.
    ENDIF.
    CLEAR: lt_return, lt_pritem, lt_pritemx.
  ENDLOOP.

*  IF lt_siparis IS NOT INITIAL.
*    CONCATENATE '''' 'SIL' ''''  INTO  lv_sil.
*    CONCATENATE '''' 'X' ''''    INTO  lv_x.
*    CONCATENATE lv_sil 'EQ' lv_x INTO lv_string SEPARATED BY space.
*    CONDENSE lv_string.
*    DELETE <grid_alv> WHERE (lv_string).
*    MODIFY zsog_mm_007_t_03 FROM TABLE lt_siparis.
*    COMMIT WORK AND WAIT.
*    MESSAGE i009(zsg) DISPLAY LIKE 'S'.
*  ENDIF.

  IF lt_return2 IS NOT INITIAL .
    PERFORM msg_display_error_table TABLES lt_return2.
  ENDIF.
ENDFORM.                    " KAYIT_1903
*&---------------------------------------------------------------------*
*&      Form  ASK_QUESTION
*&---------------------------------------------------------------------*
FORM ask_question  USING    ls_ui_popup_text
                   CHANGING lv_answer.

  CALL FUNCTION 'WFCS_POPUP_YES_NO'
    EXPORTING
      pi_ui_popup_text  = ls_ui_popup_text
    CHANGING
      pe_answer         = lv_answer
    EXCEPTIONS
      error_using_popup = 1
      OTHERS            = 2.

ENDFORM.                    " ASK_QUESTION
*&---------------------------------------------------------------------*
*&      Form  SIPARIS_1903
*&---------------------------------------------------------------------*
FORM siparis_1903 .
  DATA: lt_rowindex TYPE lvc_t_row,
        ls_rowindex TYPE lvc_s_row.
  FIELD-SYMBOLS: <fs_alv> TYPE zsog_mm_007_t_03.
  DATA ls_ui_popup_text TYPE wfcsr_ui_popup_text.
  DATA lv_answer        TYPE wfcst_char1.
  DATA: lt_siparis      TYPE TABLE OF zsog_mm_007_t_03,
        ls_siparis      TYPE zsog_mm_007_t_03.

  DATA: lv_sil          TYPE char5,
        lv_x            TYPE char3,
        lv_string       TYPE string.
  DATA: lv_exppurchaseorder   TYPE bapimepoheader-po_number.
  ls_ui_popup_text-titlebar = 'Sipariş Oluştur!'.
  ls_ui_popup_text-question =
  'Seçilen Kayıtlar İçin Sipariş Oluşturulacaktır! Onaylıyor musunuz?'.

  CALL METHOD gs_scr-1903-grid1->get_selected_rows
    IMPORTING
      et_index_rows = lt_rowindex.
  IF lt_rowindex IS INITIAL.
    MESSAGE i000(zsg) WITH text-004.
    RETURN.
  ENDIF.

  PERFORM ask_question USING ls_ui_popup_text  CHANGING lv_answer.
  IF lv_answer EQ '1'.
    LOOP AT lt_rowindex INTO ls_rowindex.
      READ TABLE <grid_alv> ASSIGNING <fs_alv> INDEX ls_rowindex-index.
      <fs_alv>-sil = 'X'.
      MOVE-CORRESPONDING <fs_alv> TO ls_siparis.
      ls_siparis-mandt = sy-mandt.
*      ls_siparis-aktive = 'X'.
      APPEND ls_siparis TO lt_siparis.
      CLEAR: ls_siparis.
    ENDLOOP.
  ENDIF.

  LOOP AT lt_siparis INTO ls_siparis WHERE ebeln IS NOT INITIAL.
    EXIT.
  ENDLOOP.
  IF sy-subrc EQ 0.
    MESSAGE i000(zsg) WITH text-006.
    RETURN.
  ENDIF.

  IF lt_siparis IS NOT INITIAL.

    PERFORM call_sas_bapi TABLES lt_siparis CHANGING lv_exppurchaseorder
    .
*    ls_siparis-ebeln = lv_exppurchaseorder.
    LOOP AT lt_rowindex INTO ls_rowindex.
      READ TABLE <grid_alv> ASSIGNING <fs_alv> INDEX ls_rowindex-index.
      <fs_alv>-ebeln = lv_exppurchaseorder.
    ENDLOOP.
*MODIFY <grid_alv> FROM ls_siparis TRANSPORTING ebeln WHERE ebeln Is
*INITIAL .
*    CONCATENATE '''' 'SIL' ''''  INTO  lv_sil.
*    CONCATENATE '''' 'X' ''''    INTO  lv_x.
*    CONCATENATE lv_sil 'EQ' lv_x INTO lv_string SEPARATED BY space.
*    CONDENSE lv_string.
*    DELETE <grid_alv> WHERE (lv_string).
*    DELETE zsog_mm_007_t_03 FROM TABLE lt_siparis.
*    COMMIT WORK AND WAIT.
*    MESSAGE i009(zsg) DISPLAY LIKE 'S'.
  ENDIF.
ENDFORM.                    " SIPARIS_1903
*&---------------------------------------------------------------------*
*&      Form  GERIAL_1903
*&---------------------------------------------------------------------*
FORM gerial_1903 .
  DATA: lt_rowindex TYPE lvc_t_row,
        ls_rowindex TYPE lvc_s_row.
  FIELD-SYMBOLS: <fs_alv> TYPE zsog_mm_007_t_03.
  DATA ls_ui_popup_text TYPE wfcsr_ui_popup_text.
  DATA lv_answer        TYPE wfcst_char1.
  DATA: lt_siparis      TYPE TABLE OF zsog_mm_007_t_03,
        ls_siparis      TYPE zsog_mm_007_t_03,
        lv_err          TYPE xfeld.

  DATA: lv_sil          TYPE char5,
        lv_x            TYPE char3,
        lv_string       TYPE string.

  ls_ui_popup_text-titlebar = 'Geri Al!'.
  ls_ui_popup_text-question =
  'Kayıtlar Sipariş Düzenleme Ekranına Gidecektir! Onaylıyor musunuz?'.

  CALL METHOD gs_scr-1903-grid1->get_selected_rows
    IMPORTING
      et_index_rows = lt_rowindex.
  IF lt_rowindex IS INITIAL.
    MESSAGE i000(zsg) WITH text-004.
    RETURN.
  ENDIF.

  PERFORM ask_question USING ls_ui_popup_text  CHANGING lv_answer.
  IF lv_answer EQ '1'.
    LOOP AT lt_rowindex INTO ls_rowindex.
      READ TABLE <grid_alv> ASSIGNING <fs_alv> INDEX ls_rowindex-index.
      <fs_alv>-sil = 'X'.
      IF <fs_alv>-ebeln IS NOT INITIAL.
        lv_err = 'X'.
        EXIT.
      ENDIF.
      MOVE-CORRESPONDING <fs_alv> TO ls_siparis.
      ls_siparis-mandt = sy-mandt.
*      ls_siparis-aktive = 'X'.
      APPEND ls_siparis TO lt_siparis.
      CLEAR: ls_siparis.
    ENDLOOP.
  ENDIF.
  IF lv_err IS NOT INITIAL.
    MESSAGE i009(zsg) DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  IF lt_siparis IS NOT INITIAL.
    CONCATENATE '''' 'SIL' ''''  INTO  lv_sil.
    CONCATENATE '''' 'X' ''''    INTO  lv_x.
    CONCATENATE lv_sil 'EQ' lv_x INTO lv_string SEPARATED BY space.
    CONDENSE lv_string.
    DELETE <grid_alv> WHERE (lv_string).
    DELETE zsog_mm_007_t_03 FROM TABLE lt_siparis.
    COMMIT WORK AND WAIT.
    MESSAGE i009(zsg) DISPLAY LIKE 'S'.
  ENDIF.

ENDFORM.                    " GERIAL_1903
*&---------------------------------------------------------------------*
*&      Form  CREATE_DYNAMIC_TABLE
*&---------------------------------------------------------------------*
FORM create_dynamic_table USING lv_structure_name TYPE dd02l-tabname.
  DATA: lo_struct   TYPE REF TO cl_abap_structdescr,
        lo_new_type TYPE REF TO cl_abap_structdescr,
        lo_new_tab  TYPE REF TO cl_abap_tabledescr,
        lo_data     TYPE REF TO data,
        lt_comp     TYPE cl_abap_structdescr=>component_table,
        lt_tot_comp TYPE cl_abap_structdescr=>component_table,
        lo_dref     TYPE REF TO data.
  DATA: co_tab      TYPE REF TO data ,
        co_line     TYPE REF TO data.

* 1. Create Table Line
  CREATE DATA co_line TYPE (lv_structure_name).
*  ASSIGN lo_dref->* TO <f_line> .

* 2. Type Descr.
  lo_struct ?= cl_abap_typedescr=>describe_by_name( lv_structure_name ).
  lt_comp  = lo_struct->get_components( ).
  APPEND LINES OF lt_comp TO lt_tot_comp.

* 3. Create a New Type
  lo_new_type = cl_abap_structdescr=>create( lt_tot_comp ).

* 4. New Table type
  lo_new_tab = cl_abap_tabledescr=>create(
                  p_line_type  = lo_new_type
                  p_table_kind = cl_abap_tabledescr=>tablekind_std
                  p_unique     = abap_false ).

* 5. data to handle the new table type
  CREATE DATA co_tab  TYPE HANDLE lo_new_tab.
*  ASSIGN
  ASSIGN co_tab->* TO <grid_alv>.
  ASSIGN co_line->*   TO <grid_line>.
ENDFORM.                    " CREATE_DYNAMIC_TABLE
*&---------------------------------------------------------------------*
*&      Form  CALL_SAS_BAPI
*&---------------------------------------------------------------------*
FORM call_sas_bapi  TABLES pt_siparis STRUCTURE zsog_mm_007_t_03
                    CHANGING lv_exppurchaseorder   TYPE
                    bapimepoheader-po_number.

  DATA ls_poheader     TYPE                   bapimepoheader.
  DATA ls_poheaderx    TYPE                   bapimepoheaderx.
  DATA lt_poitem       TYPE STANDARD TABLE OF bapimepoitem.
  DATA lt_poitemx      TYPE STANDARD TABLE OF bapimepoitemx.
  DATA lt_poschedule   TYPE STANDARD TABLE OF bapimeposchedule.
  DATA lt_poschedulex  TYPE STANDARD TABLE OF bapimeposchedulx.
  DATA lt_poaccount    TYPE STANDARD TABLE OF bapimepoaccount.
  DATA lt_poaccountx   TYPE STANDARD TABLE OF bapimepoaccountx.
  DATA lt_return       TYPE STANDARD TABLE OF bapiret2.
  DATA ls_return       TYPE                   bapiret2.
*  DATA lv_exppurchaseorder   TYPE bapimepoheader-po_number.
  DATA ls_expheader          TYPE bapimepoheader.
  DATA ls_exppoexpimpheader  TYPE bapieikp.

  DATA: ls_bakim       TYPE zsog_mm_007_t_04,
        ls_siparis     TYPE zsog_mm_007_t_03,
        lv_po_item     TYPE bapimepoitem-po_item,
        lv_sched_line  TYPE bapimeposchedule-sched_line,
        lv_sched_line2 TYPE bapimeposchedule-sched_line,
        lt_malzeme     TYPE TABLE OF zsog_mm_007_t_03,
        ls_malzeme     TYPE zsog_mm_007_t_03.

*  TYPES: BEGIN OF ltt_malzeme_olcu,
*         matnr TYPE mara-matnr,
*         ob    TYPE meins,
*         END OF ltt_malzeme_olcu.
  DATA: lt_malzeme_olcu TYPE TABLE OF zsog_mm_007_s_003,
        ls_malzeme_olcu TYPE zsog_mm_007_s_003.
*        ls_siparis TYPE zsog_mm_007_t_03.

  FIELD-SYMBOLS:<fs_siparis> TYPE any.


*
*MIKT_3000
*OB_3000
*MIKT_1000
*OB_1000
*MIKT_4
*OB_4



  LOOP AT pt_siparis INTO ls_siparis.

    PERFORM collect_malzeme_olcu TABLES  lt_malzeme_olcu USING
    ls_siparis 'MIKT_6000'
'OB_6000'.

    PERFORM collect_malzeme_olcu TABLES  lt_malzeme_olcu USING
    ls_siparis 'MIKT_10000'
'OB_10000'.

    PERFORM collect_malzeme_olcu TABLES  lt_malzeme_olcu USING
    ls_siparis 'MIKT_3000'
'OB_3000'.

    PERFORM collect_malzeme_olcu TABLES  lt_malzeme_olcu USING
    ls_siparis 'MIKT_1000'
'OB_1000'.

    PERFORM collect_malzeme_olcu TABLES  lt_malzeme_olcu USING
    ls_siparis 'MIKT_4'
'OB_4'.

  ENDLOOP.

  SELECT SINGLE * FROM zsog_mm_007_t_04 INTO ls_bakim WHERE islem_tipi =
  'PO'.

  PERFORM fill_poheader USING ls_bakim CHANGING ls_poheader ls_poheaderx
  .
  lt_malzeme = pt_siparis[].
  SORT lt_malzeme BY matnr.
  DELETE ADJACENT DUPLICATES FROM lt_malzeme COMPARING matnr.

  LOOP AT lt_malzeme_olcu INTO ls_malzeme_olcu.
    lv_po_item = lv_po_item + '00010'.
    PERFORM fill_poitem TABLES lt_poitem  lt_poitemx USING ls_bakim
    ls_malzeme_olcu lv_po_item.
    PERFORM fill_poaccount TABLES lt_poaccount lt_poaccountx USING
    ls_bakim ls_malzeme_olcu lv_po_item.
    ls_malzeme_olcu-po_item = lv_po_item.
    MODIFY lt_malzeme_olcu FROM ls_malzeme_olcu.
  ENDLOOP.

  DATA: lv_string TYPE string.
  CLEAR:  lv_po_item.

  DATA: lro_structdescr TYPE REF TO cl_abap_structdescr,
        lt_components   TYPE cl_abap_structdescr=>component_table,
        ls_components   LIKE LINE OF lt_components.
  FIELD-SYMBOLS: <ls_comp> LIKE LINE OF lt_components,
                 <fs_field> TYPE any.

  READ TABLE pt_siparis ASSIGNING <fs_siparis> INDEX 1.
  IF lt_components IS INITIAL.  "get columns' names only once.
    lro_structdescr ?= cl_abap_typedescr=>describe_by_data( <fs_siparis>
    ).
    lt_components = lro_structdescr->get_components( ).
  ENDIF.

  SORT lt_malzeme_olcu BY matnr.

  LOOP AT lt_malzeme_olcu INTO ls_malzeme_olcu .

    lv_sched_line  = lv_sched_line + '0001'.

    LOOP AT lt_components INTO ls_components WHERE name =
    ls_malzeme_olcu-column.
      LOOP AT pt_siparis INTO ls_siparis WHERE matnr =
      ls_malzeme_olcu-matnr.

        PERFORM fill_po_poschedule TABLES lt_poschedule lt_poschedulex
                                    USING ls_bakim ls_siparis lv_po_item
                                    lv_sched_line
                                          ls_malzeme_olcu-column2
                                          ls_malzeme_olcu-column
                                          ls_malzeme_olcu
                                    CHANGING lv_sched_line2.
      ENDLOOP.
      CLEAR: lv_sched_line2.
    ENDLOOP.
    CLEAR: lv_sched_line2.
    CLEAR: lv_sched_line, lv_sched_line2.
  ENDLOOP.
  SORT: lt_poschedule BY po_item sched_line,
        lt_poschedulex  BY po_item sched_line.

  CALL FUNCTION 'BAPI_PO_CREATE1' DESTINATION 'NONE'
    EXPORTING
      poheader          = ls_poheader
      poheaderx         = ls_poheaderx
    IMPORTING
      exppurchaseorder  = lv_exppurchaseorder
      expheader         = ls_expheader
      exppoexpimpheader = ls_exppoexpimpheader
    TABLES
      return            = lt_return
      poitem            = lt_poitem
      poitemx           = lt_poitemx
      poschedule        = lt_poschedule
      poschedulex       = lt_poschedulex
      poaccount         = lt_poaccount
      poaccountx        = lt_poaccountx.

  LOOP AT lt_return INTO ls_return WHERE type CA 'EAX'.
    EXIT.
  ENDLOOP.
  IF sy-subrc EQ 0.
    PERFORM bapi_rollback_destination.
    PERFORM msg_display_error_table TABLES lt_return.
    RETURN.
  ELSE.
    PERFORM bapi_commit_destination.
    PERFORM msg_display_error_table TABLES lt_return.
    DELETE zsog_mm_007_t_03 FROM TABLE pt_siparis[].
    COMMIT WORK AND WAIT.
    ls_siparis-ebeln = lv_exppurchaseorder.
    MODIFY pt_siparis[] FROM  ls_siparis TRANSPORTING ebeln WHERE ebeln
    IS INITIAL.

    MODIFY zsog_mm_007_t_03 FROM TABLE pt_siparis[].
    COMMIT WORK AND WAIT.
  ENDIF.


ENDFORM.                    " CALL_SAS_BAPI
*&---------------------------------------------------------------------*
*&      Form  FILL_POHEADER
*&---------------------------------------------------------------------*
FORM fill_poheader USING ps_bakim     STRUCTURE zsog_mm_007_t_04
                CHANGING ps_poheader  STRUCTURE bapimepoheader
                         ps_poheaderx STRUCTURE bapimepoheaderx.


  ps_poheader-doc_type   = ps_bakim-bsart.
  ps_poheader-vendor     = ps_bakim-lifnr.
  ps_poheader-purch_org  = ps_bakim-ekorg.
  ps_poheader-pur_group  = ps_bakim-ekgrp.
  ps_poheader-doc_date   = sy-datum.

  ps_poheaderx-doc_type	 = 'X'.
  ps_poheaderx-vendor	   = 'X'.
  ps_poheaderx-purch_org = 'X'.
  ps_poheaderx-pur_group = 'X'.
  ps_poheaderx-doc_date	 = 'X'.

ENDFORM.                    " FILL_POHEADER
*&---------------------------------------------------------------------*
*&      Form  FILL_POITEM
*&---------------------------------------------------------------------*
FORM fill_poitem  TABLES   pt_poitem  STRUCTURE bapimepoitem
                           pt_poitemx STRUCTURE bapimepoitemx
                  USING    ps_bakim   STRUCTURE zsog_mm_007_t_04
                           ps_malzeme_olcu STRUCTURE zsog_mm_007_s_003
                           pv_po_item TYPE bapimepoitem-po_item.

  pt_poitem-po_item    = pv_po_item.
  pt_poitem-material   = ps_malzeme_olcu-matnr.
  pt_poitem-plant      = '2425'.
  pt_poitem-stge_loc   = 'D001'.
  pt_poitem-acctasscat = 'K'.
  pt_poitem-preq_name  = sy-uname.
  pt_poitem-gr_basediv  = ''.
  pt_poitem-po_unit  = ps_malzeme_olcu-ob.


  pt_poitemx-po_item    = pv_po_item.
  pt_poitemx-material   = 'X'.
  pt_poitemx-plant      = 'X'.
  pt_poitemx-stge_loc   = 'X'.
  pt_poitemx-acctasscat = 'X'.
  pt_poitemx-gr_basediv = 'X'.
  pt_poitemx-preq_name  = 'X'.
  pt_poitemx-po_unit    = 'X'.


  APPEND pt_poitem.
  APPEND pt_poitemx.

ENDFORM.                    " FILL_POITEM
*&---------------------------------------------------------------------*
*&      Form  FILL_PO_POSCHEDULE
*&---------------------------------------------------------------------*
FORM fill_po_poschedule  TABLES pt_poschedule  STRUCTURE
bapimeposchedule
                                pt_poschedulex STRUCTURE
                                bapimeposchedulx
                         USING  ps_bakim       STRUCTURE
                         zsog_mm_007_t_04
                                ps_siparis     STRUCTURE
                                zsog_mm_007_t_03
                                pv_po_item     TYPE bapimepoitem-po_item
                                pv_sched_line  TYPE
                                bapimeposchedule-sched_line
                                pv_miktar
                                pv_ob
                                ps_malzeme_olcu STRUCTURE
                                zsog_mm_007_s_003
                       CHANGING pv_sched_line2 TYPE
                       bapimeposchedule-sched_line.

  FIELD-SYMBOLS: <fs_ob>     TYPE any,
                 <fs_miktar> TYPE any.
  DATA: ls_malzeme_olcu TYPE zsog_mm_007_s_003.

  ASSIGN COMPONENT pv_miktar OF STRUCTURE ps_siparis TO <fs_miktar>.
  IF <fs_miktar> IS ASSIGNED.
    ASSIGN COMPONENT pv_ob OF STRUCTURE ps_siparis TO <fs_ob>.
    IF <fs_ob> IS ASSIGNED.
      IF <fs_miktar> IS NOT INITIAL.
        pv_sched_line2 = pv_sched_line2 + 1.
      ELSE.
        RETURN.
      ENDIF.
*      UNASSIGN <fs_ob>.
    ELSE.
      RETURN.
    ENDIF.
*    UNASSIGN <fs_miktar>.
  ELSE.
    RETURN.
  ENDIF.


  pt_poschedule-po_item     = ps_malzeme_olcu-po_item.
  pt_poschedule-sched_line  = pv_sched_line2.
  pt_poschedule-quantity    = <fs_miktar>."ps_siparis-siparis_miktari.
  pt_poschedule-preq_no     = ps_siparis-banfn.
  pt_poschedule-preq_item   = ps_siparis-bnfpo.

  pt_poschedulex-po_item    = ps_malzeme_olcu-po_item.
  pt_poschedulex-sched_line = pv_sched_line2.
  pt_poschedulex-quantity   = 'X'.
  pt_poschedulex-preq_no    = 'X'.
  pt_poschedulex-preq_item  = 'X'.

  APPEND pt_poschedule.
  APPEND pt_poschedulex.
  IF <fs_ob> IS  ASSIGNED .
    UNASSIGN <fs_ob>.
  ENDIF.

  IF <fs_miktar> IS  ASSIGNED .
    UNASSIGN <fs_miktar>.
  ENDIF.


ENDFORM.                    " FILL_PO_POSCHEDULE
*&---------------------------------------------------------------------*
*&      Form  FILL_POACCOUNT
*&---------------------------------------------------------------------*
FORM fill_poaccount  TABLES   pt_poaccount  STRUCTURE bapimepoaccount
                              pt_poaccountx STRUCTURE bapimepoaccountx
                     USING    ps_bakim      STRUCTURE zsog_mm_007_t_04
                              ps_malzeme_olcu STRUCTURE
                              zsog_mm_007_s_003
                              pv_po_item      TYPE bapimepoitem-po_item.

  DATA: ls_mm_007_t_01 TYPE zsog_mm_007_t_01.

  SELECT SINGLE * FROM zsog_mm_007_t_01 INTO ls_mm_007_t_01 WHERE matnr = ps_malzeme_olcu-matnr.

  pt_poaccount-po_item    = pv_po_item.
*  pt_poaccount-gl_account  = ps_bakim-hkont.
  pt_poaccount-gl_account  = ls_mm_007_t_01-hkont.
  pt_poaccount-costcenter	= ps_bakim-kostl.

  pt_poaccountx-po_item     = pv_po_item.
  pt_poaccountx-gl_account  = 'X'.
  pt_poaccountx-costcenter  = 'X'.

  APPEND pt_poaccount.
  APPEND pt_poaccountx.
  CLEAR :ls_mm_007_t_01.

ENDFORM.                    " FILL_POACCOUNT
*&---------------------------------------------------------------------*
*&      Form  FILL_BAPI_SAT
*&---------------------------------------------------------------------*
FORM fill_bapi_sat  TABLES pt_talep STRUCTURE zsog_mm_007_s_talep.


  DATA  lv_number                         TYPE bapiebanc-preq_no.
  DATA  lt_requisition_items              TYPE STANDARD TABLE OF
  bapiebanc.
  DATA  lt_account_assignment             TYPE STANDARD TABLE OF
  bapiebkn.
  DATA  lt_return                         TYPE STANDARD TABLE OF
  bapireturn.
  DATA  ls_return                         TYPE bapireturn.
  DATA  lt_bapiret                        TYPE TABLE OF bapiret2.
  DATA  ls_bapiret                        TYPE bapiret2.
  DATA: lv_preq_item                      TYPE bapiebkn-preq_item.

  LOOP AT pt_talep.
    lv_preq_item = lv_preq_item + '0010'.

    PERFORM fill_requisition_items         TABLES lt_requisition_items
                                            USING pt_talep lv_preq_item.
    PERFORM requisition_account_assignment TABLES lt_account_assignment
    USING pt_talep lv_preq_item.

  ENDLOOP.

  CALL FUNCTION 'BAPI_REQUISITION_CREATE' DESTINATION 'NONE'
    IMPORTING
      number                         = lv_number
    TABLES
      requisition_items              = lt_requisition_items
      requisition_account_assignment = lt_account_assignment
      return                         = lt_return.
  LOOP AT lt_return INTO ls_return.
    ls_bapiret-type        = ls_return-type.
    ls_bapiret-id          = ls_return-code(2).
    ls_bapiret-number      = ls_return-code+2(3).
    ls_bapiret-message     = ls_return-message.
    ls_bapiret-log_no      = ls_return-log_no.
    ls_bapiret-log_msg_no  = ls_return-log_msg_no.
    ls_bapiret-message_v1  = ls_return-message_v1.
    ls_bapiret-message_v2  = ls_return-message_v2.
    ls_bapiret-message_v3  = ls_return-message_v3.
    ls_bapiret-message_v4  = ls_return-message_v4.

    APPEND ls_bapiret TO lt_bapiret.
    CLEAR: ls_bapiret.
  ENDLOOP.
  LOOP AT lt_return INTO ls_return WHERE type CA 'EAX'.
    EXIT.
  ENDLOOP.
  IF sy-subrc EQ 0.
    PERFORM bapi_rollback_destination.
    RETURN.
  ELSE.
    PERFORM bapi_commit_destination.
  ENDIF.
  IF lt_bapiret IS NOT INITIAL.
    PERFORM msg_display_error_table TABLES lt_bapiret.
  ENDIF.
ENDFORM.                    " FILL_BAPI_SAT
*&---------------------------------------------------------------------*
*&      Form  FILL_REQUISITION_ITEMS
*&---------------------------------------------------------------------*
FORM fill_requisition_items  TABLES pt_requisition_items STRUCTURE
bapiebanc
                              USING ps_talep     STRUCTURE
                              zsog_mm_007_s_talep
                                    pv_preq_item TYPE bapiebkn-preq_item
                                    .

  pt_requisition_items-preq_item = pv_preq_item.
  pt_requisition_items-doc_type  = 'ZSG1'.
  pt_requisition_items-pur_group = 'SG1'.
  pt_requisition_items-preq_name = ps_talep-kunnr.
  pt_requisition_items-preq_date = sy-datum.
  pt_requisition_items-material  = ps_talep-matnr.
  pt_requisition_items-plant     = '2425'.
  pt_requisition_items-store_loc = 'D001'.
  pt_requisition_items-quantity  = 1.
  pt_requisition_items-unit       = 'ST'.
  pt_requisition_items-deliv_date = sy-datum.
  pt_requisition_items-acctasscat = 'K'.

  APPEND pt_requisition_items.
ENDFORM.                    " FILL_REQUISITION_ITEMS
*&---------------------------------------------------------------------*
*&      Form  REQUISITION_ACCOUNT_ASSIGNMENT
*&---------------------------------------------------------------------*
FORM requisition_account_assignment  TABLES  pt_account_assignment
STRUCTURE bapiebkn
                                     USING ps_talep     STRUCTURE  zsog_mm_007_s_talep
                                           pv_preq_item TYPE bapiebkn-preq_item.
  pt_account_assignment-preq_item = pv_preq_item.
*  pt_account_assignment-g_l_acct  = '7400012002'.
  pt_account_assignment-g_l_acct  = ps_talep-hkont.
*  pt_account_assignment-cost_ctr  = '2425000001'.
  pt_account_assignment-cost_ctr  = 'SG6006'.
  APPEND pt_account_assignment.
ENDFORM.                    " REQUISITION_ACCOUNT_ASSIGNMENT
*&---------------------------------------------------------------------*
*&      Form  EVENT_TOP_OF_PAGE
*&---------------------------------------------------------------------*
FORM event_top_of_page USING dg_dyndoc_id TYPE REF TO cl_dd_document.

  DATA: s_tab  TYPE sdydo_text_table,
        c_area TYPE REF TO cl_dd_area,
        text   TYPE sdydo_text_element.

  DATA: lt_tab        TYPE REF TO cl_dd_table_element,
        ld_col1       TYPE REF TO cl_dd_area,
        ld_col2       TYPE REF TO cl_dd_area,
        ld_col3       TYPE REF TO cl_dd_area,
        ld_col4       TYPE REF TO cl_dd_area,
        ld_text       TYPE sdydo_text_element,
        ld_per1(3)    TYPE c,
        ld_per2(3)    TYPE c,
        ld_settext_ks LIKE kmas_d-settxt_kst,
        ld_settext_bp LIKE kmas_d-settxt_prz.
  DATA: lt_alv TYPE TABLE OF zsog_mm_007_s_001,
        lv_line TYPE i.


  CALL METHOD dg_dyndoc_id->add_table
    EXPORTING
      no_of_columns = 2
      border        = '0'
    IMPORTING
      table         = lt_tab.

  CALL METHOD lt_tab->add_column
    EXPORTING
      width  = '50%'
    IMPORTING
      column = ld_col1.

  CALL METHOD lt_tab->add_column
    EXPORTING
      width  = '50%'
    IMPORTING
      column = ld_col2.

  ld_text  = 'Toplam talepte bulunan bayi sayısı:'.

  CALL METHOD ld_col1->add_text
    EXPORTING
      text         = ld_text
      sap_color    = 'SAP_EMPHASIS'
      sap_emphasis = 'STRONG'.

  lt_alv = <grid_alv>.
  SORT lt_alv BY kunnr.
  DELETE ADJACENT DUPLICATES FROM lt_alv COMPARING kunnr.
  CLEAR: ld_text.
  lv_line = lines( lt_alv ).
  ld_text = lv_line.

  CALL METHOD ld_col2->add_text
    EXPORTING
      text         = ld_text
      sap_color    = 'SAP_EMPHASIS'
      sap_emphasis = 'STRONG'.

  CLEAR: ld_text.
  ld_text = 'Gönderilmesi gereken bayi sayısı'.

  CALL METHOD lt_tab->new_row.

  CALL METHOD ld_col1->add_text
    EXPORTING
      text         = ld_text
      sap_color    = 'SAP_EMPHASIS'
      sap_emphasis = 'STRONG'.

  CLEAR: ld_text, lv_line.
  lt_alv = <grid_alv>.
  DELETE lt_alv WHERE siparis_miktari < 0.
  lv_line = lines( lt_alv ).
  ld_text = lv_line.


  CALL METHOD ld_col2->add_text
    EXPORTING
      text         = ld_text
      sap_color    = 'SAP_EMPHASIS'
      sap_emphasis = 'STRONG'.

  CALL METHOD lt_tab->new_row.

  CLEAR: ld_text.
  ld_text = 'Talebi bekleyebilir bayi sayısı'.

  CALL METHOD ld_col1->add_text
    EXPORTING
      text         = ld_text
      sap_color    = 'SAP_EMPHASIS'
      sap_emphasis = 'STRONG'.

  CLEAR: ld_text, lv_line.
  lt_alv = <grid_alv>.
  DELETE lt_alv WHERE siparis_miktari >= 0.
  lv_line = lines( lt_alv ).
  ld_text = lv_line.

  CALL METHOD ld_col2->add_text
    EXPORTING
      text         = ld_text
      sap_color    = 'SAP_EMPHASIS'
      sap_emphasis = 'STRONG'.

  CALL METHOD lt_tab->new_row.

  CLEAR: ld_text.
  ld_text = 'Tarih'.

  CALL METHOD ld_col1->add_text
    EXPORTING
      text         = ld_text
      sap_color    = 'SAP_EMPHASIS'
      sap_emphasis = 'STRONG'.

  CLEAR: ld_text.
  CONCATENATE  sy-datum+6(2) '.' sy-datum+4(2) '.' sy-datum+0(4) INTO
  ld_text.

  CALL METHOD ld_col2->add_text
    EXPORTING
      text         = ld_text
      sap_color    = 'SAP_EMPHASIS'
      sap_emphasis = 'STRONG'.

  CALL METHOD lt_tab->new_row.


*  "this is more clear.....check it
*  "first add text, then pass it to comentry write fm
*  DATA : dl_text(255) TYPE c.  "Text
** Populating header to top-of-page
*  CALL METHOD dg_dyndoc_id->add_text
*    EXPORTING
*      text      = 'Sipariş Düzenleme Ekranı'
*      sap_style = cl_dd_area=>heading.
** Add new-line
*  CALL METHOD dg_dyndoc_id->new_line.
*
*  CLEAR : dl_text.
** Move User ID
*CONCATENATE 'Kullanıcı Adı :' sy-uname INTO dl_text SEPARATED BY space
*.
** Add User ID to Document
*  PERFORM add_text USING dl_text.
** Add new-line
*  CALL METHOD DG_DYNDOC_ID->NEW_LINE.
*
*  CLEAR : DL_TEXT.
*
** Move date
*  WRITE SY-DATUM TO DL_TEXT.
*  CONCATENATE 'Date :' DL_TEXT INTO DL_TEXT SEPARATED BY SPACE.
** Add Date to Document
*  PERFORM ADD_TEXT USING DL_TEXT.
** Add new-line
*  CALL METHOD DG_DYNDOC_ID->NEW_LINE.
*
*  CLEAR : DL_TEXT.
** Move time
*  WRITE SY-UZEIT TO DL_TEXT.
*  CONCATENATE 'Time :' DL_TEXT INTO DL_TEXT SEPARATED BY SPACE.
** Add Time to Document
*  PERFORM ADD_TEXT USING DL_TEXT.
** Add new-line
*  CALL METHOD DG_DYNDOC_ID->NEW_LINE.
* Populating data to html control
  PERFORM html.
ENDFORM.                    "EVENT_TOP_OF_PAGE
*&---------------------------------------------------------------------*
*&      Form  ADD_TEXT
*&---------------------------------------------------------------------*
FORM add_text USING p_text TYPE sdydo_text_element.
* Adding text
  CALL METHOD dg_dyndoc_id->add_text
    EXPORTING
      text         = p_text
      sap_emphasis = cl_dd_area=>heading.
ENDFORM.                    " ADD_TEXT
*&---------------------------------------------------------------------*
*&      Form  HTML
*&---------------------------------------------------------------------*
FORM html.
  DATA : dl_length  TYPE i,                           " Length
         dl_background_id TYPE sdydo_key VALUE space. " Background_id

* Creating html control
  IF dg_html_cntrl IS INITIAL.
    CREATE OBJECT dg_html_cntrl
      EXPORTING
        parent = dg_parent_html.
  ENDIF.
* Reuse_alv_grid_commentary_set
  CALL FUNCTION 'REUSE_ALV_GRID_COMMENTARY_SET'
    EXPORTING
      document = dg_dyndoc_id
      bottom   = space
    IMPORTING
      length   = dl_length.
* Get TOP->HTML_TABLE ready
  CALL METHOD dg_dyndoc_id->merge_document.
* Set wallpaper
  CALL METHOD dg_dyndoc_id->set_document_background
    EXPORTING
      picture_id = dl_background_id.
* Connect TOP document to HTML-Control
  dg_dyndoc_id->html_control = dg_html_cntrl.
* Display TOP document
  CALL METHOD dg_dyndoc_id->display_document
    EXPORTING
      reuse_control      = 'X'
      parent             = dg_parent_html
    EXCEPTIONS
      html_display_error = 1.
  IF sy-subrc NE 0.
*    MESSAGE I999 WITH 'Error in displaying top-of-page'(036).
  ENDIF.

ENDFORM.                    " HTML
*&---------------------------------------------------------------------*
*&      Form  SET_HEADER_FOR_PO
*&---------------------------------------------------------------------*
FORM set_header_for_po .
  CREATE OBJECT dg_dyndoc_id
    EXPORTING
      style = 'ALV_GRID'.

* Create Splitter for custom_container
  CREATE OBJECT dg_splitter
    EXPORTING
      parent  = gs_scr-1903-custom_container
      rows    = 2
      columns = 1.
* Split the custom_container to two containers and move the reference
* to receiving containers g_parent_html and g_parent_grid
  "i am allocating the space for grid and top of page
  CALL METHOD dg_splitter->get_container
    EXPORTING
      row       = 1
      column    = 1
    RECEIVING
      container = dg_parent_html.
  CALL METHOD dg_splitter->get_container
    EXPORTING
      row       = 2
      column    = 1
    RECEIVING
      container = dg_parent_grid.

  "you can set the height of it
* Set height for g_parent_html
  CALL METHOD dg_splitter->set_row_height
    EXPORTING
      id     = 1
      height = 15.
ENDFORM.                    " SET_HEADER_FOR_PO
*&---------------------------------------------------------------------*
*&      Form  CALL_BAPI_PR_CHANGE
*&---------------------------------------------------------------------*
FORM call_bapi_pr_change  TABLES   pt_return     STRUCTURE bapiret2
                                   pt_pritem     STRUCTURE bapimereqitemimp
                                   pt_pritemx    STRUCTURE bapimereqitemx
                                   pt_praccount  STRUCTURE bapimereqaccount
                                   pt_praccountx STRUCTURE bapimereqaccountx
                          USING    pv_number  TYPE
                          bapimereqheader-preq_no.
  CALL FUNCTION 'BAPI_PR_CHANGE' DESTINATION 'NONE'
    EXPORTING
      number     = pv_number
    TABLES
      return     = pt_return
      pritem     = pt_pritem
      pritemx    = pt_pritemx
      praccount  = pt_praccount
      praccountx = pt_praccountx.


ENDFORM.                    " CALL_BAPI_PR_CHANGE
*&---------------------------------------------------------------------*
*&      Form  SATIS_VE_FIRE_MASRAF_CIKIS
*&---------------------------------------------------------------------*
FORM satis_ve_fire_masraf_cikis .


  TYPES: BEGIN OF ltt_matnr,
       matnr  TYPE zsog_mm_007_t_01-matnr,
   END OF ltt_matnr.

*   types: BEGIN OF ltt_fire,
*     file_date             type  zsg_t_001-file_date,
*     gjahr                 type  zsg_t_001-gjahr,
*     monat                 type  zsg_t_001-monat,
*     item_no               type  zsg_t_001-item_no,
*     record_type           type  zsg_t_001-record_type,
*     retailer_no           type  zsg_t_001-retailer_no,
*     kunnr                 type  zsg_t_001-retailer_no,
*     name1                 type  kna1-name1,
*     game_no               type  zsg_t_001-game_no,
*     matnr                 type  zsog_mm_007_t_01-matnr,
*     maktx                 type  makt-maktx,
*     no_of_sold_wagers     type  zsg_t_001-no_of_sold_wagers,
*     fire                  type  zsog_mm_007_t_01-fire,
*     END OF ltt_fire.

  DATA: lt_kayit1 TYPE TABLE OF zsog_mm_007_t_06 ,
        ls_kayit1 TYPE zsog_mm_007_t_06,
        lt_kayit2 TYPE TABLE OF zsog_mm_007_t_06 ,
        ls_kayit2 TYPE zsog_mm_007_t_06.

  DATA: lt_mchb TYPE TABLE OF mchb,
        ls_mchb TYPE mchb.

  DATA: lv_tabix TYPE sy-tabix.
  DATA: lt_matnr TYPE TABLE OF ltt_matnr,
        ls_matnr TYPE ltt_matnr.
  DATA: lv_fire  TYPE string. "Added BurcuA 050819
  DATA: lr_matnr TYPE RANGE OF zsog_mm_007_t_01-matnr WITH HEADER LINE.
*  Data: lv_playslips_fark type zsog_mm_007_s_004-no_of_sold_playslips.

  TYPES: BEGIN OF ltt_mkpf,
       file_date  TYPE mkpf-budat,
       gjahr   TYPE mkpf-mjahr,
       monat   TYPE zsg_t_001-monat,
       item_no TYPE zsg_t_001-item_no,
       record_type TYPE zsg_t_001-record_type,
       retailer_no TYPE zsg_t_001-retailer_no,
       kunnr   TYPE mseg-charg,
       name1 TYPE kna1-name1,
       game_no TYPE zsg_t_001-game_no,
       matnr TYPE mseg-matnr,
       maktx TYPE makt-maktx,
       no_of_sold_playslips TYPE zsog_mm_007_s_004-no_of_sold_playslips,
       no_of_cancelled_playslips TYPE zsog_mm_007_s_004-no_of_cancelled_playslips,
*       no_of_sold_playslips TYPE mseg-menge,
       fire TYPE zsog_mm_007_t_01-fire,
       no_of_sold_playslips_fire TYPE zsog_mm_007_s_004-no_of_sold_playslips,
   END OF ltt_mkpf.

  DATA: lt_mkpf TYPE TABLE OF ltt_mkpf,
        ls_mkpf TYPE ltt_mkpf.

  SELECT matnr
  FROM zsog_mm_007_t_01
   INTO TABLE lt_matnr.

  LOOP AT lt_matnr INTO ls_matnr.
    lr_matnr-sign   = 'I'.
    lr_matnr-option = 'EQ'.
    lr_matnr-low    = ls_matnr-matnr.
    COLLECT lr_matnr INTO lr_matnr .
  ENDLOOP.

  SELECT
  z1~file_date
*  z1~gjahr
*  z1~monat
*  z1~item_no
*  z1~record_type
  z1~retailer_no
  z1~retailer_no AS kunnr
*  z2~kunnr "xbaltunbas 200819
  k~name1  "xbaltunbas 200819
  z1~game_no
  z3~matnr
  t~maktx
*  z1~no_of_sold_wagers " burcua 191119
  z1~no_of_sold_playslips
  z1~no_of_cancelled_playslips
  z3~fire
  INTO CORRESPONDING FIELDS OF TABLE <grid_alv>
*  FROM zsg_t_001 AS z1 "burcua commented 191119
*  FROM zsg_t_015 AS z1
  FROM zsg_t_028 AS z1
  INNER JOIN kna1 AS k ON z1~retailer_no = k~kunnr
  INNER JOIN zsog_mm_007_t_01 AS z3 ON z1~game_no = z3~game_no
                                   AND z3~aktive = 'X'
  INNER JOIN makt AS t ON t~matnr = z3~matnr
                      AND t~spras = sy-langu
  WHERE file_date IN s_badat.


  SELECT *
  FROM mchb
  INTO TABLE lt_mchb
  WHERE werks = '2425'
    AND lgort = 'D001'.

  SELECT *
  FROM zsog_mm_007_t_06
  INTO TABLE lt_kayit1
  WHERE mchb = ''.

  SORT lt_mchb BY matnr charg.
  SORT lt_kayit1 BY file_date kunnr matnr.


  LOOP AT <grid_alv> INTO ls_mkpf.
    lv_tabix = sy-tabix.
*    ls_mkpf-no_of_sold_wagers = ( ls_mkpf-no_of_sold_wagers *
*    ls_mkpf-game_no ) / 100.
*    lv_playslips_fark =
*    ls_mkpf-no_of_sold_playslips - ls_mkpf-no_of_cancelled_playslips.
*    lv_fire =  ls_mkpf-no_of_sold_playslips * ( ls_mkpf-fire / 100 ) ."burcua comment 281119
    ls_mkpf-no_of_sold_playslips_fire =  ls_mkpf-no_of_sold_playslips / ( ( 100 - ls_mkpf-fire ) / 100 ) .

*{   ->>> Added by Prodea Anıl YILDIRIM & Mustafa F. AKBAS  - 01.10.2019 13:39:49
    DATA: lv_fire1(20) TYPE c,
          lv_fire2(20) TYPE c.

    IF lv_fire MOD 1  NE 0.
      SPLIT lv_fire AT '.' INTO lv_fire1 lv_fire2.
      lv_fire = lv_fire1 + 1.
    ENDIF.
*    }    <<<- End of  Added - 01.10.2019 13:39:49

*    ls_mkpf-no_of_sold_playslips_fire = ls_mkpf-no_of_sold_playslips + lv_fire"burcua comment 281119
    .
    MODIFY <grid_alv> FROM ls_mkpf ."TRANSPORTING no_of_sold_wagers.
    APPEND ls_mkpf TO lt_mkpf.                              "071219

*** xbaltunbas 06.09.2019
    READ TABLE lt_mchb INTO ls_mchb
      WITH KEY matnr = ls_mkpf-matnr
               charg = ls_mkpf-kunnr BINARY SEARCH.
    IF sy-subrc = 0.

      IF ls_mchb-clabs < ls_mkpf-no_of_sold_playslips_fire.

        DELETE <grid_alv> INDEX lv_tabix.

        MOVE-CORRESPONDING ls_mkpf TO ls_kayit2.
        MOVE ls_mkpf-no_of_sold_playslips_fire TO ls_kayit2-no_of_sold_playslips_fire.
        APPEND ls_kayit2 TO lt_kayit2.
*        COLLECT ls_kayit2 INTO lt_kayit2.
        CLEAR : ls_kayit2.

      ENDIF.
    ELSE.

      DELETE <grid_alv> INDEX lv_tabix.

      MOVE-CORRESPONDING ls_mkpf TO ls_kayit2.
      APPEND ls_kayit2 TO lt_kayit2.
*      COLLECT ls_kayit2 INTO lt_kayit2.
      CLEAR : ls_kayit2.
    ENDIF.
*** xbaltunbas 06.09.2019

    CLEAR: ls_mkpf,lv_fire,ls_kayit1,ls_kayit2,lv_tabix,ls_mchb.
  ENDLOOP.

  " Önceden Atılamayan Kayıtların şu anda kullanılabilir
  "olup olmadığının kontrolü için
  LOOP AT lt_kayit1 INTO ls_kayit1.

    READ TABLE lt_mchb INTO ls_mchb
      WITH KEY matnr = ls_kayit1-matnr
               charg = ls_kayit1-kunnr BINARY SEARCH.
    IF sy-subrc = 0.
      READ TABLE lt_mkpf INTO ls_mkpf
        WITH KEY matnr = ls_mchb-matnr
                 kunnr = ls_mchb-charg.

      IF ls_mchb-clabs >= ls_mkpf-no_of_sold_playslips_fire.

        MOVE-CORRESPONDING ls_kayit1 TO ls_mkpf.
        APPEND ls_mkpf TO <grid_alv> .

        MOVE ls_kayit1 TO ls_kayit2.
        ls_kayit2-mchb = 'X'.
        COLLECT ls_kayit2 INTO lt_kayit2.

      ENDIF.
    ENDIF.
    CLEAR : ls_mchb,ls_kayit1,ls_kayit2,ls_mkpf.
  ENDLOOP.


*** xbaltunbas 06.09.2019
  IF lt_kayit2 IS NOT INITIAL.
    MODIFY zsog_mm_007_t_06 FROM TABLE lt_kayit2.
    COMMIT WORK AND WAIT.
  ENDIF.
*** xbaltunbas 06.09.2019

  IF <grid_alv> IS INITIAL.
    MESSAGE i013(zsg) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.
  IF sy-batch IS NOT INITIAL.
    break: xmozuari,xbaltunbas.
    PERFORM bapi_goodsmvt_create.
  ELSE.
    CALL SCREEN 1903.
  ENDIF.

ENDFORM.                    " SATIS_VE_FIRE_MASRAF_CIKIS
*&---------------------------------------------------------------------*
*&      Form  BAPI_GOODSMVT_CREATE
*&---------------------------------------------------------------------*
FORM bapi_goodsmvt_create .

  DATA:   ls_goodsmvt_header  TYPE  bapi2017_gm_head_01,
          ls_goodsmvt_code    TYPE  bapi2017_gm_code,
          lt_item             TYPE TABLE OF bapi2017_gm_item_create,
          ls_item             TYPE bapi2017_gm_item_create,
          ls_goodsmvt_headret TYPE  bapi2017_gm_head_ret,
          lv_materialdocument TYPE  bapi2017_gm_head_ret-mat_doc,
          lv_matdocumentyear  TYPE  bapi2017_gm_head_ret-doc_year,
          lt_return           TYPE  TABLE OF bapiret2,
          ls_return           TYPE  bapiret2,
          ls_alv TYPE zsog_mm_007_s_004.

  ls_goodsmvt_header-pstng_date = sy-datum.
  ls_goodsmvt_header-doc_date   = sy-datum .
  ls_goodsmvt_header-ref_doc_no = 'SATIS FIRE CIKIS'.
  ls_goodsmvt_code-gm_code      = '03'.

  "Mustafa Faruk Akbaş 'ın isteğiyle eklendi - BurcuA - 050819

  LOOP AT <grid_alv> INTO ls_alv.

    ls_item-material      = ls_alv-matnr.
    ls_item-plant         = '2425'.
    ls_item-stge_loc      = 'D001'.
    ls_item-batch         = ls_alv-kunnr.
    ls_item-move_type     = '201'.
*ls_item-entry_qnt     = ls_alv-no_of_sold_wagers.`"comment Burcua
*050819
    ls_item-entry_qnt     = ls_alv-no_of_sold_playslips_fire.
    ls_item-entry_uom     = 'ST'.
    ls_item-costcenter    = '2425000001'.

    IF ls_alv-no_of_sold_playslips_fire NE 0.    """ Added by Prodea Anıl YILDIRIM - 10.09.2019 20:35:40
      APPEND ls_item TO lt_item.              """ 0 gelen alanla dump alınıyor.
    ENDIF.
    CLEAR: ls_item.
  ENDLOOP.

  CALL FUNCTION 'BAPI_GOODSMVT_CREATE' DESTINATION 'NONE'
    EXPORTING
      goodsmvt_header  = ls_goodsmvt_header
      goodsmvt_code    = ls_goodsmvt_code-gm_code
    IMPORTING
      goodsmvt_headret = ls_goodsmvt_headret
      materialdocument = lv_materialdocument
      matdocumentyear  = lv_matdocumentyear
    TABLES
      goodsmvt_item    = lt_item
      return           = lt_return.

  IF lv_materialdocument IS NOT INITIAL.
    PERFORM bapi_commit_destination.
    LOOP AT <grid_alv> INTO ls_alv.
      ls_alv-mat_doc = lv_materialdocument.
      ls_alv-doc_year = lv_matdocumentyear.
      MODIFY <grid_alv> FROM ls_alv.
    ENDLOOP.
  ELSE.
    PERFORM bapi_rollback_destination.
    IF lt_return IS NOT INITIAL .
      PERFORM msg_display_error_table TABLES lt_return.
    ENDIF.
  ENDIF.
ENDFORM.                    " BAPI_GOODSMVT_CREATE
*&---------------------------------------------------------------------*
*&      Form  COLLECT_MALZEME_OLCU
*&---------------------------------------------------------------------*
FORM collect_malzeme_olcu  TABLES pt_malzeme_olcu STRUCTURE
zsog_mm_007_s_003
                           USING  ps_siparis STRUCTURE zsog_mm_007_t_03
                                  pv_miktar
                                  pv_ob.
  FIELD-SYMBOLS: <fs_ob>     TYPE any,
                 <fs_miktar> TYPE any.
  DATA: ls_malzeme_olcu TYPE zsog_mm_007_s_003.

  ASSIGN COMPONENT pv_miktar OF STRUCTURE ps_siparis TO <fs_miktar>.
  IF <fs_miktar> IS ASSIGNED.
    ASSIGN COMPONENT pv_ob OF STRUCTURE ps_siparis TO <fs_ob>.
    IF <fs_ob> IS ASSIGNED.
      IF <fs_miktar> IS NOT INITIAL.
        ls_malzeme_olcu-matnr = ps_siparis-matnr.
        ls_malzeme_olcu-ob    = <fs_ob>.
        ls_malzeme_olcu-column  = pv_ob.
        ls_malzeme_olcu-column2  = pv_miktar.

        COLLECT ls_malzeme_olcu INTO pt_malzeme_olcu[].
        CLEAR: ls_malzeme_olcu.
      ENDIF.
      UNASSIGN <fs_ob>.
    ENDIF.
    UNASSIGN <fs_miktar>.
  ENDIF.

ENDFORM.                    " COLLECT_MALZEME_OLCU
