*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_009_KARGO_I01
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
  ENDCASE.
  CLEAR lv_okcode.

ENDMODULE.
