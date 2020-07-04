*&---------------------------------------------------------------------*
*& Report  ZSOG_MM_0010
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZSOG_MM_0010.

 TABLES: ZSG_T_015.

 SELECT-OPTIONS : s_date  FOR zsg_t_015-file_date OBLIGATORY,
                  s_bayi  FOR zsg_t_015-retailer_no.

 START-OF-SELECTION.

 DELETE FROM ZSG_T_015
  WHERE retailer_no IN s_bayi
    AND file_date IN s_date.

  COMMIT WORK.

END-OF-SELECTION.
