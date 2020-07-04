*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_012_KAGIT_SIP_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*

MODULE USER_COMMAND_0100 INPUT.

  CLEAR ok_code.
  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'BACK' OR 'EXIT'.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.                 " USER_COMMAND_0100  INPUT
