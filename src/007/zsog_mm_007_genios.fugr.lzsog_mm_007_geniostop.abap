FUNCTION-POOL zsog_mm_007_genios.           "MESSAGE-ID ..

* INCLUDE LZSOG_MM_007_GENIOSD...            " Local class definition
TYPES: BEGIN OF ltt_intial_protype,
      xvalue         TYPE genios_float,
      yvalue         TYPE genios_float,
      objective      TYPE genios_float,
      is_xinteger    TYPE xfeld,
      is_yinteger    TYPE xfeld,
      is_xcandidate  TYPE xfeld,
      is_ycandidate  TYPE xfeld,
      is_xzero       TYPE xfeld,
      is_yzero       TYPE xfeld,
      lowerbound_ofx TYPE i,
      upperbound_ofx TYPE i,
      lowerbound_ofy TYPE i,
      upperbound_ofy TYPE i,
      selected_cadidate  TYPE char1,
      END OF ltt_intial_protype.

TYPES: BEGIN OF ltt_node_protype,
        type            TYPE char1                    ,
        righthandside   TYPE genios_float              ,
        name            TYPE genios_name               ,
        coefficient	    TYPE genios_float              ,
        variable        TYPE char1 ,
       END OF ltt_node_protype.

DATA: gt_constraint_left TYPE TABLE OF ltt_node_protype,
      gt_constraint_right TYPE TABLE OF ltt_node_protype.


TYPES: BEGIN OF ltt_intial_solution,
       xvalue            TYPE genios_float,
       yvalue            TYPE genios_float,
       objective         TYPE genios_float,
       is_xinteger       TYPE xfeld,
       is_yinteger       TYPE xfeld,
       is_xcandidate     TYPE xfeld,
       is_ycandidate     TYPE xfeld,
       is_xzero          TYPE xfeld,
       is_yzero          TYPE xfeld,
       lowerbound_ofx    TYPE i,
       upperbound_ofx    TYPE i,
       lowerbound_ofy    TYPE i,
       upperbound_ofy    TYPE i,
       selected_cadidate TYPE char1,
       END OF ltt_intial_solution.

CONSTANTS: solverid     TYPE genios_solverid VALUE 'SIMP'.
CONSTANTS: lc_modelname TYPE genios_name     VALUE 'OPTIMAL ORDER'.

DATA: lt_solution          TYPE TABLE OF ltt_intial_solution,
      ls_intial_solution_l TYPE ltt_intial_solution,
      ls_intial_solution_u TYPE ltt_intial_solution.
