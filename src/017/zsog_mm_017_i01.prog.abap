*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_017_I01
*&---------------------------------------------------------------------*

MODULE user_command_0100 INPUT.

  DATA lv_okcode TYPE sy-ucomm.

  lv_okcode = ok_code.
  CLEAR ok_code.
  CASE lv_okcode.
    WHEN 'BACK' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'KAYDET'.
     READ TABLE gt_out WITH KEY color = 'C600' TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        MESSAGE ID 'ZMM' TYPE 'I' NUMBER '124'.
        EXIT.
      ELSE.
      PERFORM get_onay USING text-004 .
      CHECK gv_onay = '1' .
      PERFORM secim_tespit.
      PERFORM kaydet.
     ENDIF.
  ENDCASE.
  CLEAR lv_okcode.
ENDMODULE.                    "user_command_0100 INPUT
