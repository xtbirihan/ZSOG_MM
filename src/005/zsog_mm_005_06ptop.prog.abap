************************************************************************
*        Datenteil SAPFM06P                                            *
************************************************************************
PROGRAM sapfm06p MESSAGE-ID me.
TYPE-POOLS:   addi, meein,
              mmpur.
INCLUDE rvadtabl.
INCLUDE fm06pfvd.
*- Tabellen -----------------------------------------------------------*
TABLES: cpkme,
        ekvkp,
        ekko,
        pekko,
        rm06p,
        ekpo,
        pekpo,
        pekpov,
        pekpos,
        eket,
        ekek,
        ekes,
        ekeh,
        ekkn,
        ekpa,
        ekbe,
        eine, *eine,
        lfa1,
        likp,
       *lfa1,
        kna1,
        komk,
        komp,
        komvd,
        ekomd,
        econf_out,
        thead, *thead,
        sadr,
        mdpa,
        mdpm,
        mkpf,
        tinct,
        ttxit,
        tmsi2,
        tq05,
        tq05t,
        t001,
        t001w,
        t006, *t006,
        t006a, *t006a,
        t024,
        t024e,
        t027a,
        t027b,
        t052,
        t161n,
        t163d,
        t163p,           "release creation profile, note 384808
        t166a,
        t165p,
        t166c,
        t166k,
        t166p,
        t166t,
        t166u,
        t165m,
        t165a,
        tmamt,
       *mara,                                               "HTN 4.0C
        mara,
        marc,
        mt06e,
        makt,
        vbak,
        vbkd,
       *vbkd,
        vbap.
TABLES: drad,
        drat.
TABLES: addr1_sel,
        addr1_val.
TABLES: v_htnm, rampl,tmppf.           "HTN-Abwicklung

TABLES: stxh.              "schnellerer Zugriff auf Texte Dienstleistung

TABLES: t161.              "Abgebotskennzeichen für Dienstleistung

*- INTERNE TABELLEN ---------------------------------------------------*
*- Tabelle der Positionen ---------------------------------------------*
DATA: BEGIN OF xekpo OCCURS 10.
        INCLUDE STRUCTURE ekpo.
DATA:     bsmng LIKE ekes-menge,
      END OF xekpo.

*18.08.05--------------------------------------------------------*
DATA : BEGIN OF ufuktab OCCURS 0,
        txt(25) VALUE 'tanju colak' TYPE c,
       END OF ufuktab.
*18.08.05--------------------------------------------------------*

*- Key für xekpo ------------------------------------------------------*
DATA: BEGIN OF xekpokey,
         mandt LIKE ekpo-mandt,
         ebeln LIKE ekpo-ebeln,
         ebelp LIKE ekpo-ebelp,
      END OF xekpokey.

*- Tabelle der Einteilungen -------------------------------------------*
DATA: BEGIN OF xeket OCCURS 10.
        INCLUDE STRUCTURE eket.
DATA:     fzete LIKE pekpo-wemng,
      END OF xeket.

*- Tabelle der Einteilungen temporär ----------------------------------*
DATA: BEGIN OF teket OCCURS 10.
        INCLUDE STRUCTURE beket.
DATA: END OF teket.

DATA: BEGIN OF zeket.
        INCLUDE STRUCTURE eket.
DATA:  END OF zeket.

*- Tabelle der Positionszusatzdaten -----------------------------------*
DATA: BEGIN OF xpekpo OCCURS 10.
        INCLUDE STRUCTURE pekpo.
DATA: END OF xpekpo.

*- Tabelle der Positionszusatzdaten -----------------------------------*
DATA: BEGIN OF xpekpov OCCURS 10.
        INCLUDE STRUCTURE pekpov.
DATA: END OF xpekpov.

*- Tabelle der Zahlungbedingungen--------------------------------------*
DATA: BEGIN OF zbtxt OCCURS 5,
         line(50),
      END OF zbtxt.

*- Tabelle der Merkmalsausprägungen -----------------------------------*
DATA: BEGIN OF tconf_out OCCURS 50.
        INCLUDE STRUCTURE econf_out.
DATA: END OF tconf_out.

*- Tabelle der Konditionen --------------------------------------------*
DATA: BEGIN OF tkomv OCCURS 50.
        INCLUDE STRUCTURE komv.
DATA: END OF tkomv.

DATA: BEGIN OF tkomk OCCURS 1.
        INCLUDE STRUCTURE komk.
DATA: END OF tkomk.

DATA: BEGIN OF tkomvd OCCURS 50.       "Belegkonditionen
        INCLUDE STRUCTURE komvd.
DATA: END OF tkomvd.

DATA: BEGIN OF tekomd OCCURS 50.       "Stammkonditionen
        INCLUDE STRUCTURE ekomd.
DATA: END OF tekomd.

*- Tabelle der Bestellentwicklung -------------------------------------*
DATA: BEGIN OF xekbe OCCURS 10.
        INCLUDE STRUCTURE ekbe.
DATA: END OF xekbe.

*- Tabelle der Bezugsnebenkosten --------------------------------------*
DATA: BEGIN OF xekbz OCCURS 10.
        INCLUDE STRUCTURE ekbz.
DATA: END OF xekbz.

*- Tabelle der WE/RE-Zuordnung ----------------------------------------*
DATA: BEGIN OF xekbez OCCURS 10.
        INCLUDE STRUCTURE ekbez.
DATA: END OF xekbez.

*- Tabelle der Positionssummen der Bestellentwicklung -----------------*
DATA: BEGIN OF tekbes OCCURS 10.
        INCLUDE STRUCTURE ekbes.
DATA: END OF tekbes.

*- Tabelle der Bezugsnebenkosten der Bestandsführung ------------------*
DATA: BEGIN OF xekbnk OCCURS 10.
        INCLUDE STRUCTURE ekbnk.
DATA: END OF xekbnk.

*- Tabelle für Kopieren Positionstexte (hier wegen Infobestelltext) ---*
DATA: BEGIN OF xt165p OCCURS 10.
        INCLUDE STRUCTURE t165p.
DATA: END OF xt165p.

*- Tabelle der Kopftexte ----------------------------------------------*
DATA: BEGIN OF xt166k OCCURS 10.
        INCLUDE STRUCTURE t166k.
DATA: END OF xt166k.

*- Tabelle der Positionstexte -----------------------------------------*
DATA: BEGIN OF xt166p OCCURS 10.
        INCLUDE STRUCTURE t166p.
DATA: END OF xt166p.

*- Tabelle der Anahngstexte -------------------------------------------*
DATA: BEGIN OF xt166a OCCURS 10.
        INCLUDE STRUCTURE t166a.
DATA: END OF xt166a.

*- Tabelle der Textheader ---------------------------------------------*
DATA: BEGIN OF xthead OCCURS 10.
        INCLUDE STRUCTURE thead.
DATA: END OF xthead.

DATA: BEGIN OF xtheadkey,
         tdobject LIKE thead-tdobject,
         tdname LIKE thead-tdname,
         tdid LIKE thead-tdid,
      END OF xtheadkey.

DATA: BEGIN OF qm_text_key OCCURS 5,
         tdobject LIKE thead-tdobject,
         tdname LIKE thead-tdname,
         tdid LIKE thead-tdid,
         tdtext LIKE ttxit-tdtext,
      END OF qm_text_key.

*- Tabelle der Nachrichten alt/neu ------------------------------------*
DATA: BEGIN OF xnast OCCURS 10.
        INCLUDE STRUCTURE nast.
DATA: END OF xnast.

DATA: BEGIN OF ynast OCCURS 10.
        INCLUDE STRUCTURE nast.
DATA: END OF ynast.

*------ Struktur zur Übergabe der Adressdaten --------------------------
DATA:    BEGIN OF addr_fields.
        INCLUDE STRUCTURE sadrfields.
DATA:    END OF addr_fields.

*------ Struktur zur Übergabe der Adressreferenz -----------------------
DATA:    BEGIN OF addr_reference.
        INCLUDE STRUCTURE addr_ref.
DATA:    END OF addr_reference.

*------ Tabelle zur Übergabe der Fehler -------------------------------
DATA:    BEGIN OF error_table OCCURS 10.
        INCLUDE STRUCTURE addr_error.
DATA:    END OF error_table.

*------ Tabelle zur Übergabe der Adressgruppen ------------------------
DATA:    BEGIN OF addr_groups OCCURS 3.
        INCLUDE STRUCTURE adagroups.
DATA:    END OF addr_groups.

*- Tabelle der Aenderungsbescheibungen --------------------------------*
DATA: BEGIN OF xaend OCCURS 10,
         ebelp LIKE ekpo-ebelp,
         zekkn LIKE ekkn-zekkn,
         etenr LIKE eket-etenr,
         ctxnr LIKE t166c-ctxnr,
         rounr LIKE t166c-rounr,
         insert,
         flag_adrnr,
      END OF xaend.

DATA: BEGIN OF xaendkey,
         ebelp LIKE ekpo-ebelp,
         zekkn LIKE ekkn-zekkn,
         etenr LIKE eket-etenr,
         ctxnr LIKE t166c-ctxnr,
         rounr LIKE t166c-rounr,
         insert,
         flag_adrnr,
      END OF xaendkey.

*- Tabelle der Textänderungen -----------------------------------------*
DATA: BEGIN OF xaetx OCCURS 10,
         ebelp LIKE ekpo-ebelp,
         textart LIKE cdshw-textart,
         chngind LIKE cdshw-chngind,
      END OF xaetx.

*- Tabelle der geänderten Adressen ------------------------------------*
DATA: BEGIN OF xadrnr OCCURS 5,
         adrnr LIKE sadr-adrnr,
         tname LIKE cdshw-tabname,
         fname LIKE cdshw-fname,
      END OF xadrnr.

*- Tabelle der gerade bearbeiteten aktive Komponenten -----------------*
DATA BEGIN OF mdpmx OCCURS 10.
        INCLUDE STRUCTURE mdpm.
DATA END OF mdpmx.

*- Tabelle der gerade bearbeiteten Sekundärbedarfe --------------------*
DATA BEGIN OF mdsbx OCCURS 10.
        INCLUDE STRUCTURE mdsb.
DATA END OF mdsbx.

*- Struktur des Archivobjekts -----------------------------------------*
DATA: BEGIN OF xobjid,
        objky  LIKE nast-objky,
        arcnr  LIKE nast-optarcnr,
      END OF xobjid.

* Struktur für zugehörigen Sammelartikel
DATA: BEGIN OF sekpo.
        INCLUDE STRUCTURE ekpo.
DATA:   first_varpos,
      END OF sekpo.

*- Struktur für Ausgabeergebnis zB Spoolauftragsnummer ----------------*
DATA: BEGIN OF result.
        INCLUDE STRUCTURE itcpp.
DATA: END OF result.

*- Struktur für Internet NAST -----------------------------------------*
DATA: BEGIN OF intnast.
        INCLUDE STRUCTURE snast.
DATA: END OF intnast.

*- HTN-Abwicklung
DATA: BEGIN OF htnmat OCCURS 0.
        INCLUDE STRUCTURE v_htnm.
DATA:  revlv LIKE rampl-revlv,
      END OF htnmat.

DATA  htnamp LIKE rampl  OCCURS 0 WITH HEADER LINE.

*- Hilfsfelder --------------------------------------------------------*
DATA: hadrnr(8),                       "Key TSADR
      elementn(30),                    "Name des Elements
      save_el(30),                     "Rettfeld für Element
      retco LIKE sy-subrc,             "Returncode Druck
      insert,                          "Kz. neue Position
      h-ind LIKE sy-tabix,             "Hilfsfeld Index
      h-ind1 LIKE sy-tabix,            "Hilfsfeld Index
      f1 TYPE f,                       "Rechenfeld
      h-menge LIKE ekpo-menge,         "Hilfsfeld Mengenumrechnung
      h-meng1 LIKE ekpo-menge,         "Hilfsfeld Mengenumrechnung
      h-meng2 LIKE ekpo-menge,         "Hilfsfeld Mengenumrechnung
      ab-menge LIKE ekes-menge,        "Hilfsfeld bestätigte Menge
      kzbzg LIKE konp-kzbzg,           "Staffeln vorhanden?
      hdatum LIKE eket-eindt,          "Hilfsfeld Datum
      hmahnz LIKE ekpo-mahnz,          "Hilfsfeld Mahnung
      addressnum LIKE ekpo-adrn2,      "Hilfsfeld Adressnummer
      tablines LIKE sy-tabix,          "Zähler Tabelleneinträge
      entries  LIKE sy-tfill,          "Zähler Tabelleneinträge
      hstap,                           "statistische Position
      hsamm,                           "Positionen mit Sammelartikel
      hloep,                           "Gelöschte Positionen im Spiel
      hkpos,                           "Kondition zu löschen
      kopfkond,                        "Kopfkonditionen vorhanden
      no_zero_line,                    "keine Nullzeilen
      xdrflg LIKE t166p-drflg,         "Hilfsfeld Textdruck
      xprotect,                        "Kz. protect erfolgt
      archiv_object LIKE toa_dara-ar_object, "für opt. Archivierung
      textflag,                        "Kz. druckrel. Positionstexte
      flag,                            "allgemeines Kennzeichen
      spoolid(10),                     "Spoolidnummer
      xprogram LIKE sy-repid,          "Programm
      lvs_recipient LIKE swotobjid,    "Internet
      lvs_sender LIKE swotobjid,       "Internet
      timeflag,                        "Kz. Uhrzeit bei mind. 1 Eint.
      dunwitheket TYPE xfeld,          "Dunning with EKET    Note 384808
      h_vbeln LIKE vbak-vbeln,
      h_vbelp LIKE vbap-posnr.

*- Drucksteuerung -----------------------------------------------------*
DATA: aendernsrv.
DATA: xdruvo.                          "Druckvorgang
DATA: neu  VALUE '1',                  "Neudruck
      aend VALUE '2',                  "Änderungsdruck
      mahn VALUE '3',                  "Mahnung
      absa VALUE '4',                  "Absage
      lpet VALUE '5',                  "Lieferplaneinteilung
      lpma VALUE '6',                  "Mahnung Lieferplaneinteilung
      aufb VALUE '7',                  "Auftragsbestätigung
      lpae VALUE '8',                  "Änderung Lieferplaneinteilung
      lphe VALUE '9',                  "Historisierte Einteilungen
      preisdruck,                      "Kz. Gesamtpreis drucken
      kontrakt_preis,                  "Kz. Kontraktpreise drucken
      we   VALUE 'E'.                  "Wareneingangswert

*- Hilfsfelder Lieferplaneinteilung -----------------------------------*
DATA:
      xlpet,                           "Lieferplaneinteilung
      xfz,                             "Fortschrittszahlendarstellung
      xoffen,                          "offene WE-Menge
      xlmahn,                          "Lieferplaneinteilungsmahnung
      fzflag,                          "KZ. Abstimmdatum erreicht
      xnoaend,                         "keine Änderungsbelege da  LPET
      xetdrk,                        "Druckrelevante Positionen da LPET
      xetefz LIKE eket-menge,          "Einteilungsfortschrittszahl
      xwemfz LIKE eket-menge,          "Lieferfortschrittszahl
      xabruf LIKE ekek-abruf,          "Alter Abruf
      p_abart LIKE ekek-abart.         "Abrufart

*data: sum-euro-price like komk-fkwrt.                       "302203
DATA: sum-euro-price LIKE komk-fkwrt_euro.                  "302203
DATA: euro-price LIKE ekpo-effwr.

*- Hilfsfelder für Ausgabemedium --------------------------------------*
DATA: xdialog,                         "Kz. POP-UP
      xscreen,                         "Kz. Probeausgabe
      xformular LIKE tnapr-fonam,      "Formular
      xdevice(10).                     "Ausgabemedium

*- Hilfsfelder für QM -------------------------------------------------*
DATA: qv_text_i LIKE tq09t-kurztext,   "Bezeichnung Qualitätsvereinb.
      tl_text_i LIKE tq09t-kurztext,   "Bezeichnung Technische Lieferb.
      zg_kz.                           "Zeugnis erforderlich

*- Hilfsfelder für Änderungsbeleg -------------------------------------*
INCLUDE fm06ecdf.

*- Common-Part für Änderungsbeleg -------------------------------------*
INCLUDE fm06lccd.

*- Direktwerte --------------------------------------------------------*
INCLUDE fmmexdir.

* Datendefinitionen für Dienstleistungen
TABLES: eslh,
        esll,
        ml_esll,
        rm11p.

DATA  BEGIN OF gliederung OCCURS 50.
        INCLUDE STRUCTURE ml_esll.
DATA  END   OF gliederung.

DATA  BEGIN OF leistung OCCURS 50.
        INCLUDE STRUCTURE ml_esll.
DATA  END   OF leistung.

DATA  return.

*- interne Tabelle für Abrufköpfe -------------------------------------*
DATA: BEGIN OF xekek          OCCURS 20.
        INCLUDE STRUCTURE iekek.
DATA: END OF xekek.

*- interne Tabelle für Abrufköpfe alt----------------------------------*
DATA: BEGIN OF pekek          OCCURS 20.
        INCLUDE STRUCTURE iekek.
DATA: END OF pekek.

*- interne Tabelle für Abrufeinteilungen ------------------------------*
DATA: BEGIN OF xekeh          OCCURS 20.
        INCLUDE STRUCTURE iekeh.
DATA: END OF xekeh.

*- interne Tabelle für Abrufeinteilungen ------------------------------*
DATA: BEGIN OF tekeh          OCCURS 20.
        INCLUDE STRUCTURE iekeh.
DATA: END OF tekeh.

*- Zusatztabelle Abruf nicht vorhanden XEKPO---------------------------*
DATA: BEGIN OF xekpoabr OCCURS 20,
         mandt LIKE ekpo-mandt,
         ebeln LIKE ekpo-ebeln,
         ebelp LIKE ekpo-ebelp,
      END OF xekpoabr.

*-- Daten Hinweis 39234 -----------------------------------------------*
*- Hilfstabelle Einteilungen ------------------------------------------*
DATA: BEGIN OF heket OCCURS 10.
        INCLUDE STRUCTURE eket.
DATA:       tflag LIKE sy-calld,
      END OF heket.

*- Key für HEKET ------------------------------------------------------*
DATA: BEGIN OF heketkey,
         mandt LIKE eket-mandt,
         ebeln LIKE eket-ebeln,
         ebelp LIKE eket-ebelp,
         etenr LIKE eket-etenr,
      END OF heketkey.

DATA: h_subrc LIKE sy-subrc,
      h_tabix LIKE sy-tabix,
      h_field LIKE cdshw-f_old,
      h_eindt LIKE rvdat-extdatum.
DATA  z TYPE i.

* Defintionen für Formeln

TYPE-POOLS msfo.

DATA: variablen TYPE msfo_tab_variablen WITH HEADER LINE.

DATA: formel TYPE msfo_formel.

* Definition für Rechnungsplan

DATA: tfpltdr LIKE fpltdr OCCURS 0 WITH HEADER LINE.

DATA: fpltdr LIKE fpltdr.

* Definiton Defaultschema für Dienstleistung

CONSTANTS: default_kalsm LIKE t683-kalsm VALUE 'MS0000',
           default_kalsm_stamm LIKE t683-kalsm VALUE 'MS0001'.

DATA: bstyp LIKE ekko-bstyp,
      bsart LIKE ekko-bsart.


DATA dkomk LIKE komk.

* Defintion für Wartungsplan
TABLES: rmipm.

DATA: mpos_tab LIKE mpos OCCURS 0 WITH HEADER LINE,
      zykl_tab LIKE mmpt OCCURS 0 WITH HEADER LINE.

DATA: print_schedule.

DATA: BEGIN OF d_tkomvd OCCURS 50.
        INCLUDE STRUCTURE komvd.
DATA: END OF d_tkomvd.
DATA: BEGIN OF d_tkomv OCCURS 50.
        INCLUDE STRUCTURE komv.
DATA: END OF d_tkomv.


* Definition Drucktabellen blockweises Lesen

DATA: leistung_thead LIKE stxh OCCURS 1 WITH HEADER LINE.
DATA: gliederung_thead LIKE stxh OCCURS 1 WITH HEADER LINE. "HS

DATA: BEGIN OF thead_key,
        mandt    LIKE sy-mandt,
        tdobject LIKE stxh-tdobject,
        tdname   LIKE stxh-tdname,
        tdid     LIKE stxh-tdid,
        tdspras  LIKE stxh-tdspras.
DATA: END OF thead_key.

RANGES: r1_tdname FOR stxh-tdname,
        r2_tdname FOR stxh-tdname.

DATA: BEGIN OF doktab OCCURS 0.
        INCLUDE STRUCTURE drad.
DATA  dktxt LIKE drat-dktxt.
DATA: END OF doktab.

*  Additionals Tabelle (CvB/4.0c)
DATA: l_addis_in_orders TYPE LINE OF addi_buying_print_itab
                                        OCCURS 0 WITH HEADER LINE.
*  Die Additionals-Strukturen müssen bekannt sein
TABLES: wtad_buying_print_addi, wtad_buying_print_extra_text.
