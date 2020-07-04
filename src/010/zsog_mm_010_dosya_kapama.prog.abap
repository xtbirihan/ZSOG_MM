*&---------------------------------------------------------------------*
*& Report  ZSOG_MM_010_DOSYA_KAPAMA
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zsog_mm_010_dosya_kapama.

INCLUDE: zsog_mm_010_dosya_kapama_scr,
         zsog_mm_010_dosya_kapama_top,
         zsog_mm_010_dosya_kapama_f01.

START-OF-SELECTION.

  IF sy-batch NE 'X'.
    PERFORM get_data.
  ELSE.
    PERFORM get_data.
    PERFORM create_invoce.
  ENDIF.
