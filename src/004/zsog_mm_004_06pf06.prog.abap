*-------------------------------------------------------------------
***INCLUDE FM06PF06 .
*-------------------------------------------------------------------

*&---------------------------------------------------------------------*
*&      Form  PRINT_MAINTANCE_SCHEDULE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PRINT_MAINTANCE_SCHEDULE.

  DATA: P_SI_UNIT LIKE T006-MSEHI,
        P_ZYKL1   LIKE MMPT-ZYKL1,
        P_PACKNO  LIKE EKPO-PACKNO.

  PRINT_SCHEDULE = 'X'.
  LOOP AT ZYKL_TAB.
    CLEAR: RMIPM-OFFS1, RMIPM-ZYKL1.
    IF NOT ZYKL_TAB-ZEIEH IS INITIAL.
      IF NOT ZYKL_TAB-ZYKL1 IS INITIAL.
        CALL FUNCTION 'FLTP_CHAR_CONVERSION_FROM_SI'
             EXPORTING
                  CHAR_UNIT       = ZYKL_TAB-ZEIEH
                  DECIMALS        = 0
                  EXPONENT        = 0
                  FLTP_VALUE_SI   = ZYKL_TAB-ZYKL1
                  INDICATOR_VALUE = 'X'
                  MASC_SYMBOL     = ' '
             IMPORTING
                  CHAR_VALUE      = RMIPM-ZYKL1.
      ENDIF.


      IF NOT ZYKL_TAB-OFFSET IS INITIAL.
        CALL FUNCTION 'FLTP_CHAR_CONVERSION_FROM_SI'
             EXPORTING
                  CHAR_UNIT       = ZYKL_TAB-ZEIEH
                  DECIMALS        = 0
                  EXPONENT        = 0
                  FLTP_VALUE_SI   = ZYKL_TAB-OFFSET
                  INDICATOR_VALUE = 'X'
                  MASC_SYMBOL     = ' '
             IMPORTING
                  CHAR_VALUE      = RMIPM-OFFS1.
      ENDIF.
    ENDIF.


    CALL FUNCTION 'WRITE_FORM'
         EXPORTING
              ELEMENT = 'MAINTANCE_SCHED_HEADER'
         EXCEPTIONS
              OTHERS  = 01.
    LOOP AT MPOS_TAB WHERE WARPL EQ ZYKL_TAB-WARPL.
      CALL FUNCTION 'WRITE_FORM'
           EXPORTING
                ELEMENT = 'MAINTANCE_SCHED_POS'
           EXCEPTIONS
                OTHERS  = 01.
      IF NOT MPOS_TAB-PACKNO IS INITIAL.
        MOVE MPOS_TAB-PACKNO TO EKPO-PACKNO.
        PERFORM SELECT_SERVICES.
      ENDIF.
    ENDLOOP.
  ENDLOOP.
  CLEAR PRINT_SCHEDULE.
ENDFORM.                               " PRINT_MAINTANCE_SCHEDULE
