************************************************************************
*        Datenteil SAPFM06P                                            *
************************************************************************
PROGRAM SAPFM06P MESSAGE-ID ME.
TYPE-POOLS:   ADDI, meein,
              MMPUR.
INCLUDE RVADTABL.

INCLUDE FM06P_CONST.
*INCLUDE FM06PFVD.
*- Tabellen -----------------------------------------------------------*
*TABLES: " CPKME,
*        EKVKP,
*        EKKO,
*        PEKKO,
*        RM06P,
*        EKPO,
*        PEKPO,
*        PEKPOV,
*        PEKPOS,
*        EKET,
*        EKEK,
*        EKES,
*        EKEH,
*        EKKN,
*        EKPA,
*        EKBE,
*        EINE, *EINE,
*        LFA1,
*        LIKP,
*       *LFA1,
*        KNA1,
*        KOMK,
*        KOMP,
*        KOMVD,
*        EKOMD,
*        ECONF_OUT,
*        THEAD, *THEAD,
*        SADR,
*        MDPA,
*        MDPM,
*        MKPF,
*        TINCT,
*        TTXIT,
*        TMSI2,
*        TQ05,
*        TQ05T,
*        T001,
*        T001W,
*        T006, *T006,
*        T006A, *T006A,
*        T024,
*        T024E,
*        T027A,
*        T027B,
*        T052,
*        T161N,
*        T163D,
*        T163P,           "release creation profile, note 384808
*        T166A,
*        T165P,
*        T166C,
*        T166K,
*        T166P,
*        T166T,
*        T166U,
*        T165M,
*        T165A,
*        TMAMT,
*       *MARA,                        "HTN 4.0C
*        MARA,
*        MARC,
*        MT06E,
*        MAKT,
*        VBAK,
*        VBKD,
*       *VBKD,
*        VBAP.
*TABLES: DRAD,
*        DRAT.
*TABLES: ADDR1_SEL,
*        ADDR1_VAL.
*TABLES: V_HTNM, RAMPL,TMPPF.     "HTN-Abwicklung

*TABLES: STXH.             "schnellerer Zugriff auf Texte Dienstleistung

*TABLES: T161.             "Abgebotskennzeichen für Dienstleistung

*- INTERNE TABELLEN ---------------------------------------------------*
*- Tabelle der Positionen ---------------------------------------------*
*DATA: BEGIN OF XEKPO OCCURS 10.
*            INCLUDE STRUCTURE EKPO.
*DATA:     BSMNG LIKE EKES-MENGE,
*      END OF XEKPO.

*- Key für xekpo ------------------------------------------------------*
*DATA: BEGIN OF XEKPOKEY,
*         MANDT LIKE EKPO-MANDT,
*         EBELN LIKE EKPO-EBELN,
*         EBELP LIKE EKPO-EBELP,
*      END OF XEKPOKEY.

*- Tabelle der Einteilungen -------------------------------------------*
*DATA: BEGIN OF XEKET OCCURS 10.
*            INCLUDE STRUCTURE EKET.
*DATA:     FZETE LIKE PEKPO-WEMNG,
*      END OF XEKET.

*- Tabelle der Einteilungen temporär ----------------------------------*
*DATA: BEGIN OF TEKET OCCURS 10.
*            INCLUDE STRUCTURE BEKET.
*DATA: END OF TEKET.

*DATA: BEGIN OF ZEKET.
*         INCLUDE STRUCTURE EKET.
*DATA:  END OF ZEKET.

ENHANCEMENT-POINT FM06PTOP_01 SPOTS ES_FM06PTOP STATIC INCLUDE BOUND.
*- Tabelle der Positionszusatzdaten -----------------------------------*
*DATA: BEGIN OF XPEKPO OCCURS 10.
*            INCLUDE STRUCTURE PEKPO.
*DATA: END OF XPEKPO.

*- Tabelle der Positionszusatzdaten -----------------------------------*
*DATA: BEGIN OF XPEKPOV OCCURS 10.
*            INCLUDE STRUCTURE PEKPOV.
*DATA: END OF XPEKPOV.

*- Tabelle der Zahlungbedingungen--------------------------------------*
*DATA: BEGIN OF ZBTXT OCCURS 5,
*         LINE(50),
*      END OF ZBTXT.

*- Tabelle der Merkmalsausprägungen -----------------------------------*
*DATA: BEGIN OF TCONF_OUT OCCURS 50.
*        INCLUDE STRUCTURE ECONF_OUT.
*DATA: END OF TCONF_OUT.

*- Tabelle der Konditionen --------------------------------------------*
*DATA: BEGIN OF TKOMV OCCURS 50.
*        INCLUDE STRUCTURE KOMV.
*DATA: END OF TKOMV.

*DATA: BEGIN OF TKOMK OCCURS 1.
*        INCLUDE STRUCTURE KOMK.
*DATA: END OF TKOMK.

*DATA: BEGIN OF TKOMVD OCCURS 50.     "Belegkonditionen
*        INCLUDE STRUCTURE KOMVD.
*DATA: END OF TKOMVD.

*DATA: BEGIN OF TEKOMD OCCURS 50.     "Stammkonditionen
*        INCLUDE STRUCTURE EKOMD.
*DATA: END OF TEKOMD.

*- Tabelle der Bestellentwicklung -------------------------------------*
*DATA: BEGIN OF XEKBE OCCURS 10.
*            INCLUDE STRUCTURE EKBE.
*DATA: END OF XEKBE.

*- Tabelle der Bezugsnebenkosten --------------------------------------*
*DATA: BEGIN OF XEKBZ OCCURS 10.
*            INCLUDE STRUCTURE EKBZ.
*DATA: END OF XEKBZ.

*- Tabelle der WE/RE-Zuordnung ----------------------------------------*
*DATA: BEGIN OF XEKBEZ OCCURS 10.
*            INCLUDE STRUCTURE EKBEZ.
*DATA: END OF XEKBEZ.

*- Tabelle der Positionssummen der Bestellentwicklung -----------------*
*DATA: BEGIN OF TEKBES OCCURS 10.
*            INCLUDE STRUCTURE EKBES.
*DATA: END OF TEKBES.

*- Tabelle der Bezugsnebenkosten der Bestandsführung ------------------*
*DATA: BEGIN OF XEKBNK OCCURS 10.
*            INCLUDE STRUCTURE EKBNK.
*DATA: END OF XEKBNK.

*- Tabelle für Kopieren Positionstexte (hier wegen Infobestelltext) ---*
*DATA: BEGIN OF XT165P OCCURS 10.
*            INCLUDE STRUCTURE T165P.
*DATA: END OF XT165P.

*- Tabelle der Kopftexte ----------------------------------------------*
*DATA: BEGIN OF XT166K OCCURS 10.
*            INCLUDE STRUCTURE T166K.
*DATA: END OF XT166K.

*- Tabelle der Positionstexte -----------------------------------------*
*DATA: BEGIN OF XT166P OCCURS 10.
*            INCLUDE STRUCTURE T166P.
*DATA: END OF XT166P.

*- Tabelle der Anahngstexte -------------------------------------------*
*DATA: BEGIN OF XT166A OCCURS 10.
*            INCLUDE STRUCTURE T166A.
*DATA: END OF XT166A.

*- Tabelle der Textheader ---------------------------------------------*
*DATA: BEGIN OF XTHEAD OCCURS 10.
*            INCLUDE STRUCTURE THEAD.
*DATA: END OF XTHEAD.

*DATA: BEGIN OF XTHEADKEY,
*         TDOBJECT LIKE THEAD-TDOBJECT,
*         TDNAME LIKE THEAD-TDNAME,
*         TDID LIKE THEAD-TDID,
*      END OF XTHEADKEY.

*DATA: BEGIN OF QM_TEXT_KEY OCCURS 5,
*         TDOBJECT LIKE THEAD-TDOBJECT,
*         TDNAME LIKE THEAD-TDNAME,
*         TDID LIKE THEAD-TDID,
*         TDTEXT LIKE TTXIT-TDTEXT,
*      END OF QM_TEXT_KEY.

*- Tabelle der Nachrichten alt/neu ------------------------------------*
*DATA: BEGIN OF XNAST OCCURS 10.
*            INCLUDE STRUCTURE NAST.
*DATA: END OF XNAST.

*DATA: BEGIN OF YNAST OCCURS 10.
*            INCLUDE STRUCTURE NAST.
*DATA: END OF YNAST.

*------ Struktur zur Übergabe der Adressdaten --------------------------
*DATA:    BEGIN OF ADDR_FIELDS.
*            INCLUDE STRUCTURE SADRFIELDS.
*DATA:    END OF ADDR_FIELDS.

*------ Struktur zur Übergabe der Adressreferenz -----------------------
*DATA:    BEGIN OF ADDR_REFERENCE.
*            INCLUDE STRUCTURE ADDR_REF.
*DATA:    END OF ADDR_REFERENCE.

*------ Tabelle zur Übergabe der Fehler -------------------------------
*DATA:    BEGIN OF ERROR_TABLE OCCURS 10.
*            INCLUDE STRUCTURE ADDR_ERROR.
*DATA:    END OF ERROR_TABLE.

*------ Tabelle zur Übergabe der Adressgruppen ------------------------
*DATA:    BEGIN OF ADDR_GROUPS OCCURS 3.
*            INCLUDE STRUCTURE ADAGROUPS.
*DATA:    END OF ADDR_GROUPS.

*- Tabelle der Aenderungsbescheibungen --------------------------------*
*DATA: BEGIN OF XAEND OCCURS 10,
*         EBELP LIKE EKPO-EBELP,
*         ZEKKN LIKE EKKN-ZEKKN,
*         ETENR LIKE EKET-ETENR,
*         CTXNR LIKE T166C-CTXNR,
*         ROUNR LIKE T166C-ROUNR,
*         INSERT,
*         FLAG_ADRNR,
*      END OF XAEND.

*DATA: BEGIN OF XAENDKEY,
*         EBELP LIKE EKPO-EBELP,
*         ZEKKN LIKE EKKN-ZEKKN,
*         ETENR LIKE EKET-ETENR,
*         CTXNR LIKE T166C-CTXNR,
*         ROUNR LIKE T166C-ROUNR,
*         INSERT,
*         FLAG_ADRNR,
*      END OF XAENDKEY.

*- Tabelle der Textänderungen -----------------------------------------*
*DATA: BEGIN OF XAETX OCCURS 10,
*         EBELP LIKE EKPO-EBELP,
*         TEXTART LIKE CDSHW-TEXTART,
*         CHNGIND LIKE CDSHW-CHNGIND,
*      END OF XAETX.

*- Tabelle der geänderten Adressen ------------------------------------*
*DATA: BEGIN OF XADRNR OCCURS 5,
*         ADRNR LIKE SADR-ADRNR,
*         TNAME LIKE CDSHW-TABNAME,
*         FNAME LIKE CDSHW-FNAME,
*      END OF XADRNR.

*- Tabelle der gerade bearbeiteten aktive Komponenten -----------------*
*DATA BEGIN OF MDPMX OCCURS 10.
*        INCLUDE STRUCTURE MDPM.
*DATA END OF MDPMX.

*- Tabelle der gerade bearbeiteten Sekundärbedarfe --------------------*
*DATA BEGIN OF MDSBX OCCURS 10.
*        INCLUDE STRUCTURE MDSB.
*DATA END OF MDSBX.

*- Struktur des Archivobjekts -----------------------------------------*
*DATA: BEGIN OF XOBJID,
*        OBJKY  LIKE NAST-OBJKY,
*        ARCNR  LIKE NAST-OPTARCNR,
*      END OF XOBJID.

* Struktur für zugehörigen Sammelartikel
*DATA: BEGIN OF SEKPO.
*        INCLUDE STRUCTURE EKPO.
*DATA:   FIRST_VARPOS,
*      END OF SEKPO.

*- Struktur für Ausgabeergebnis zB Spoolauftragsnummer ----------------*
*DATA: BEGIN OF RESULT.
*       INCLUDE STRUCTURE ITCPP.
*DATA: END OF RESULT.

*- Struktur für Internet NAST -----------------------------------------*
*DATA: BEGIN OF INTNAST.
*       INCLUDE STRUCTURE SNAST.
*DATA: END OF INTNAST.

*- HTN-Abwicklung
*DATA: BEGIN OF HTNMAT OCCURS 0.
*       INCLUDE STRUCTURE V_HTNM.
*DATA:  REVLV LIKE RAMPL-REVLV,
*      END OF HTNMAT.

*DATA  HTNAMP LIKE RAMPL  OCCURS 0 WITH HEADER LINE.

*- Hilfsfelder --------------------------------------------------------*
*DATA: HADRNR(8),                       "Key TSADR
*      ELEMENTN(30),                    "Name des Elements
*      SAVE_EL(30),                     "Rettfeld für Element
*      RETCO LIKE SY-SUBRC,             "Returncode Druck
*      INSERT,                          "Kz. neue Position
*      H-IND LIKE SY-TABIX,             "Hilfsfeld Index
*      H-IND1 LIKE SY-TABIX,            "Hilfsfeld Index
*      F1 TYPE F,                       "Rechenfeld
*      H-MENGE LIKE EKPO-MENGE,         "Hilfsfeld Mengenumrechnung
*      H-MENG1 LIKE EKPO-MENGE,         "Hilfsfeld Mengenumrechnung
*      H-MENG2 LIKE EKPO-MENGE,         "Hilfsfeld Mengenumrechnung
*      AB-MENGE LIKE EKES-MENGE,        "Hilfsfeld bestätigte Menge
*      KZBZG LIKE KONP-KZBZG,           "Staffeln vorhanden?
*      HDATUM LIKE EKET-EINDT,          "Hilfsfeld Datum
*      HMAHNZ LIKE EKPO-MAHNZ,          "Hilfsfeld Mahnung
*      ADDRESSNUM LIKE EKPO-ADRN2,      "Hilfsfeld Adressnummer
*      TABLINES LIKE SY-TABIX,          "Zähler Tabelleneinträge
*      ENTRIES  LIKE SY-TFILL,          "Zähler Tabelleneinträge
*      HSTAP,                           "statistische Position
*      HSAMM,                           "Positionen mit Sammelartikel
*      HLOEP,                           "Gelöschte Positionen im Spiel
*      HKPOS,                           "Kondition zu löschen
*      KOPFKOND,                        "Kopfkonditionen vorhanden
*      NO_ZERO_LINE,                    "keine Nullzeilen
*      XDRFLG LIKE T166P-DRFLG,         "Hilfsfeld Textdruck
*      XPROTECT,                        "Kz. protect erfolgt
*      ARCHIV_OBJECT LIKE TOA_DARA-AR_OBJECT, "für opt. Archivierung
*      TEXTFLAG,                        "Kz. druckrel. Positionstexte
*      FLAG,                            "allgemeines Kennzeichen
*      SPOOLID(10),                     "Spoolidnummer
*      XPROGRAM LIKE SY-REPID,          "Programm
*      LVS_RECIPIENT LIKE SWOTOBJID,    "Internet
*      LVS_SENDER LIKE SWOTOBJID,       "Internet
*      TIMEFLAG,                        "Kz. Uhrzeit bei mind. 1 Eint.
*     DUNWITHEKET TYPE XFELD,          "Dunning with EKET    Note 384808
*      H_VBELN LIKE VBAK-VBELN,
*      H_VBELP LIKE VBAP-POSNR.

*- Drucksteuerung -----------------------------------------------------*
*DATA: AENDERNSRV.
*DATA: XDRUVO.                          "Druckvorgang
DATA: NEU  VALUE '1',                  "Neudruck
      AEND VALUE '2',                  "Änderungsdruck
      MAHN VALUE '3',                  "Mahnung
      ABSA VALUE '4',                  "Absage
      LPET VALUE '5',                  "Lieferplaneinteilung
      LPMA VALUE '6',                  "Mahnung Lieferplaneinteilung
      AUFB VALUE '7',                  "Auftragsbestätigung
      LPAE VALUE '8',                  "Änderung Lieferplaneinteilung
      LPHE VALUE '9',                  "Historisierte Einteilungen
      PREISDRUCK,                      "Kz. Gesamtpreis drucken
      KONTRAKT_PREIS,                  "Kz. Kontraktpreise drucken
      WE   VALUE 'E'.                  "Wareneingangswert

* sending output vai mail
DATA  pdf_content        TYPE solix_tab.
DATA  lvs_recipient      LIKE swotobjid.

*- Hilfsfelder Lieferplaneinteilung -----------------------------------*
*DATA:
*      XLPET,                           "Lieferplaneinteilung
*      XFZ,                             "Fortschrittszahlendarstellung
*      XOFFEN,                          "offene WE-Menge
*      XLMAHN,                           "Lieferplaneinteilungsmahnung
*      FZFLAG,                          "KZ. Abstimmdatum erreicht
*      XNOAEND,                       "keine Änderungsbelege da  LPET
*      XETDRK,                        "Druckrelevante Positionen da LPET
*      XETEFZ LIKE EKET-MENGE,          "Einteilungsfortschrittszahl
*      XWEMFZ LIKE EKET-MENGE,          "Lieferfortschrittszahl
*      XABRUF LIKE EKEK-ABRUF,          "Alter Abruf
*      P_ABART LIKE EKEK-ABART.         "Abrufart

*data: sum-euro-price like komk-fkwrt.                       "302203
*data: sum-euro-price like komk-fkwrt_euro.                   "302203
*data: euro-price like ekpo-effwr.

*- Hilfsfelder für Ausgabemedium --------------------------------------*
*DATA: XDIALOG,                         "Kz. POP-UP
*      XSCREEN,                         "Kz. Probeausgabe
*      XFORMULAR LIKE TNAPR-FONAM,      "Formular
*      XDEVICE(10).                     "Ausgabemedium

*- Hilfsfelder für QM -------------------------------------------------*
*DATA: QV_TEXT_I LIKE TQ09T-KURZTEXT,   "Bezeichnung Qualitätsvereinb.
*      TL_TEXT_I LIKE TQ09T-KURZTEXT,   "Bezeichnung Technische Lieferb.
*      ZG_KZ.                           "Zeugnis erforderlich

*- Hilfsfelder für Änderungsbeleg -------------------------------------*
*INCLUDE FM06ECDF.

*- Common-Part für Änderungsbeleg -------------------------------------*
*INCLUDE FM06LCCD.

*- Direktwerte --------------------------------------------------------*
*INCLUDE FMMEXDIR.

* Datendefinitionen für Dienstleistungen
*TABLES: ESLH,
*        ESLL,
*        ML_ESLL,
*        RM11P.

*DATA  BEGIN OF GLIEDERUNG OCCURS 50.
*         INCLUDE STRUCTURE ML_ESLL.
*DATA  END   OF GLIEDERUNG.

*DATA  BEGIN OF LEISTUNG OCCURS 50.
*         INCLUDE STRUCTURE ML_ESLL.
*DATA  END   OF LEISTUNG.

*DATA  RETURN.

*- interne Tabelle für Abrufköpfe -------------------------------------*
*DATA: BEGIN OF XEKEK          OCCURS 20.
*        INCLUDE STRUCTURE IEKEK.
*DATA: END OF XEKEK.

*- interne Tabelle für Abrufköpfe alt----------------------------------*
*DATA: BEGIN OF PEKEK          OCCURS 20.
*        INCLUDE STRUCTURE IEKEK.
*DATA: END OF PEKEK.

*- interne Tabelle für Abrufeinteilungen ------------------------------*
*DATA: BEGIN OF XEKEH          OCCURS 20.
*        INCLUDE STRUCTURE IEKEH.
*DATA: END OF XEKEH.

*- interne Tabelle für Abrufeinteilungen ------------------------------*
*DATA: BEGIN OF TEKEH          OCCURS 20.
*        INCLUDE STRUCTURE IEKEH.
*DATA: END OF TEKEH.

*- Zusatztabelle Abruf nicht vorhanden XEKPO---------------------------*
*DATA: BEGIN OF XEKPOABR OCCURS 20,
*         MANDT LIKE EKPO-MANDT,
*         EBELN LIKE EKPO-EBELN,
*         EBELP LIKE EKPO-EBELP,
*      END OF XEKPOABR.

*-- Daten Hinweis 39234 -----------------------------------------------*
*- Hilfstabelle Einteilungen ------------------------------------------*
*DATA: BEGIN OF HEKET OCCURS 10.
*            INCLUDE STRUCTURE EKET.
*DATA:       TFLAG LIKE SY-CALLD,
*      END OF HEKET.

*- Key für HEKET ------------------------------------------------------*
*DATA: BEGIN OF HEKETKEY,
*         MANDT LIKE EKET-MANDT,
*         EBELN LIKE EKET-EBELN,
*         EBELP LIKE EKET-EBELP,
*         ETENR LIKE EKET-ETENR,
*      END OF HEKETKEY.

*DATA: H_SUBRC LIKE SY-SUBRC,
*      H_TABIX LIKE SY-TABIX,
*      H_FIELD LIKE CDSHW-F_OLD,
*      H_EINDT LIKE RVDAT-EXTDATUM.
*DATA  Z TYPE I.

* Defintionen für Formeln

*TYPE-POOLS MSFO.

*DATA: VARIABLEN TYPE MSFO_TAB_VARIABLEN WITH HEADER LINE.

*DATA: FORMEL TYPE MSFO_FORMEL.

* Definition für Rechnungsplan

*DATA: TFPLTDR LIKE FPLTDR OCCURS 0 WITH HEADER LINE.

*DATA: FPLTDR LIKE FPLTDR.

* Definiton Defaultschema für Dienstleistung

*CONSTANTS: DEFAULT_KALSM LIKE T683-KALSM VALUE 'MS0000',
*           DEFAULT_KALSM_STAMM LIKE T683-KALSM VALUE 'MS0001'.

*data: bstyp like ekko-bstyp,
*      bsart like ekko-bsart.


*DATA DKOMK LIKE KOMK.

* Defintion für Wartungsplan
*TABLES: RMIPM.

*DATA: MPOS_TAB LIKE MPOS OCCURS 0 WITH HEADER LINE,
*      ZYKL_TAB LIKE MMPT OCCURS 0 WITH HEADER LINE.

*DATA: PRINT_SCHEDULE.

*DATA: BEGIN OF D_TKOMVD OCCURS 50.
*        INCLUDE STRUCTURE KOMVD.
*DATA: END OF D_TKOMVD.
*DATA: BEGIN OF D_TKOMV OCCURS 50.
*        INCLUDE STRUCTURE KOMV.
*DATA: END OF D_TKOMV.


* Definition Drucktabellen blockweises Lesen

*DATA: LEISTUNG_THEAD LIKE STXH OCCURS 1 WITH HEADER LINE.
*DATA:GLIEDERUNG_THEAD LIKE STXH OCCURS 1 WITH HEADER LINE.          "HS

*DATA: BEGIN OF THEAD_KEY,
*        MANDT    LIKE SY-MANDT,
*        TDOBJECT LIKE STXH-TDOBJECT,
*        TDNAME   LIKE STXH-TDNAME,
*        TDID     LIKE STXH-TDID,
*        TDSPRAS  LIKE STXH-TDSPRAS.
*DATA: END OF THEAD_KEY.

*RANGES: R1_TDNAME FOR STXH-TDNAME,
*        R2_TDNAME FOR STXH-TDNAME.

*DATA: BEGIN OF DOKTAB OCCURS 0.
*      INCLUDE STRUCTURE DRAD.
*DATA  DKTXT LIKE DRAT-DKTXT.
*DATA: END OF DOKTAB.

*  Additionals Tabelle (CvB/4.0c)
*DATA: L_ADDIS_IN_ORDERS TYPE LINE OF ADDI_BUYING_PRINT_ITAB
*                                        OCCURS 0 WITH HEADER LINE.
*  Die Additionals-Strukturen müssen bekannt sein
*TABLES: WTAD_BUYING_PRINT_ADDI, WTAD_BUYING_PRINT_EXTRA_TEXT.
