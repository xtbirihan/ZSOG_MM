************************************************************************
*        Druckausgabe Einkaufsbelege                                   *
************************************************************************
*  89494  ??.??.1997  3.1I  TK  Probedruck: Nicht optisch archivieren!
*  91419  22.12.1997  3.1I  CF  Probedruck: Anzahl Kopien = 1
*  88301  26.01.1998  3.1I  RB  Geänderten Liefertermin auf Position
*  99282  24.03.1998  4.0C  CF  Immer neuer Spoolauftrag

  INCLUDE FM06PF02_AUSGABE_KOPF .  " AUSGABE_KOPF

  INCLUDE FM06PF02_AUSGABE_POS_UEB .  " AUSGABE_POS_UEB

*  INCLUDE FM06PF02_AUSGABE_POS .  " AUSGABE_POS
  INCLUDE zFM06PF02_AUSGABE_POS .  " AUSGABE_POS

*  INCLUDE FM06PF02_AUSGABE_EINT .  " AUSGABE_EINT
  INCLUDE ZFM06PF02_AUSGABE_EINT .  " AUSGABE_EINT
*  INCLUDE FM06PF02_AUSGABE_ANHANG .  " AUSGABE_ANHANG
  INCLUDE ZFM06PF02_AUSGABE_ANHANG .  " AUSGABE_ANHANG

  INCLUDE FM06PF02_ENDE .  " ENDE

*  INCLUDE FM06PF02_AUSGABE_STAMMKONDITIO .  " AUSGABE_STAMMKONDITIONEN
  INCLUDE ZFM06PF02_AUSGABE_STAMMKONDITI .  " AUSGABE_STAMMKONDITIONEN

  INCLUDE FM06PF02_AUSGABE_COMP .  " AUSGABE_COMP
