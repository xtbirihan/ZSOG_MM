*&---------------------------------------------------------------------*
*& Report  ZSOG_MM_016_STOK_RAPORU
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*  ABAP Name     :
*  Author        : Anıl Yıldırım & Mustafa Faruk Akbaş
*  e-mail        : anil.yildirim@prodea.com.tr &
*                  mustafa.akbas@prodea.com.tr
*  GMP relevant  :
*  Date          : 11.09.2019 18:28:54
*  Açıklama      :
*----------------------------------------------------------------------*
*  Changes                                                             *
*----------------------------------------------------------------------*
*  Date      Name      No.   Description                               *
*----------------------------------------------------------------------*

REPORT ZSOG_MM_016_STOK_RAPORU.

INCLUDE ZSOG_MM_016_STOK_RAPORU_top.
INCLUDE ZSOG_MM_016_STOK_RAPORU_c01.
INCLUDE ZSOG_MM_016_STOK_RAPORU_f01.
INCLUDE ZSOG_MM_016_STOK_RAPORU_o01.
INCLUDE ZSOG_MM_016_STOK_RAPORU_i01.

START-OF-SELECTION.
  PERFORM get_data.

END-OF-SELECTION.
  PERFORM show_data.
