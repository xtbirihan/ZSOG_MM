*&---------------------------------------------------------------------*
*& Report  ZSOG_MM_018_SAT_ONAY_HATIRLAT
*&
*&---------------------------------------------------------------------*
*  ABAP Name     : ZSOG_MM_018_SAT_ONAY_HATIRLAT
*  Author        : Damla Öztürk
*  e-mail        : damla.polat@prodea.com.tr
*  GMP relevant  :
*  Date          : 01.04.2020
*  Explanation   : SAT Onay Mail Hatırlatma
*&---------------------------------------------------------------------*

REPORT ZSOG_MM_018_SAT_ONAY_HATIRLAT.

 INCLUDE ZSOG_MM_018_TOP.
 INCLUDE ZSOG_MM_018_C01.
 INCLUDE ZSOG_MM_018_O01.
 INCLUDE ZSOG_MM_018_I01.
 INCLUDE ZSOG_MM_018_F01.

 START-OF-SELECTION.
   PERFORM get_data.
  IF sy-batch NE 'X'.
    CALL SCREEN 0100.
  ELSE.
 IF p_onay IS INITIAL.
      "SAT'lar için onaycılarına hatırlatma maili gönder
  perform prepare_and_send_mail.     "" onaylanmamış ~ SAT
 ELSE.
      "Onaylanan SAT'lar için Satınalma Departmanına Mail Gönder
  perform prepare_and_send_mail_pd2. "" onaylanmış tüm talepler
 ENDIF.
 ENDIF.
