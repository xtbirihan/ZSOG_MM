*&---------------------------------------------------------------------*
*&  Include           ZSOG_MM_018_I01
*&---------------------------------------------------------------------*
module USER_COMMAND_0100 input.
CASE ok_code.
  WHEN 'BACK' OR 'EXIT'.
    LEAVE TO SCREEN 0.
  WHEN 'CANC'.
    LEAVE PROGRAM.
  WHEN OTHERS.
ENDCASE.
endmodule.                 " USER_COMMAND_0100  INPUT
