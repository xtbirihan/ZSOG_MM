*----------------------------------------------------------------------*
***INCLUDE FM06PF09 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_VENDOR_ADDRESS
*&---------------------------------------------------------------------*
FORM GET_VENDOR_ADDRESS USING    P_EMLIF LIKE LFA1-LIFNR
                        CHANGING P_ADRNR.
* parameter P_ADRNR without type since there are several address
* fields with different domains

  DATA: L_LFA1 LIKE LFA1.

  CHECK NOT P_EMLIF IS INITIAL.
  CALL FUNCTION 'VENDOR_MASTER_DATA_SELECT_00'
       EXPORTING
            I_LFA1_LIFNR     = P_EMLIF
            I_DATA           = 'X'
            I_PARTNER        = ' '
       IMPORTING
            A_LFA1           = L_LFA1
       EXCEPTIONS
            VENDOR_NOT_FOUND = 1.
  IF SY-SUBRC EQ 0.
    P_ADRNR = L_LFA1-ADRNR.
  ELSE.
    CLEAR P_ADRNR.
  ENDIF.

ENDFORM.                    " GET_VENDOR_ADDRESS
