*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_0012_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*----------------------------------------------------------------------*
module USER_COMMAND_0100 input.
CASE gv_ok_code.
  WHEN 'BACK' OR 'EXIT'.
    LEAVE TO SCREEN 0.
  WHEN 'CANCEL'.
    LEAVE PROGRAM.
   WHEN OTHERS.
ENDCASE.
endmodule.                 " USER_COMMAND_0100  INPUT
