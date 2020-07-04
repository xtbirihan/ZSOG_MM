FUNCTION zsog_mm_007_genios.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_OBJECTIVE_RIGHTHANDSIDE) TYPE  GENIOS_FLOAT
*"  EXPORTING
*"     VALUE(ES_RETURN) TYPE  ZSOG_MM_007_GENIOS_RETURN
*"----------------------------------------------------------------------
  CLEAR:  gt_constraint_left ,
          gt_constraint_right ,
          lt_solution, ls_intial_solution_l, ls_intial_solution_u.
  PERFORM calculate_objective USING iv_objective_righthandside CHANGING ES_RETURN.

ENDFUNCTION.
*&---------------------------------------------------------------------*
*&      Form  calculate_objective
*&---------------------------------------------------------------------*
FORM calculate_objective USING iv_objective_righthandside TYPE  genios_float
                         CHANGING es_RETURN STRUCTURE ZSOG_MM_007_GENIOS_RETURN.
  DATA: ls_node_protype TYPE ltt_node_protype.
*  DATA: ls_node TYPE ltt_node.
  DATA: ls_intial_solution TYPE ltt_intial_solution.
  DATA: ls_intial_solution2 TYPE ltt_intial_solution.
  DATA: ls_solution TYPE ltt_intial_solution.
*  DATA: lt_solution  TYPE TABLE OF ltt_intial_solution.
  "SolverID TYPE genios_solverid VALUE 'SIMP'.
  DATA: lo_env TYPE REF TO cl_genios_environment,
        lx_env TYPE REF TO cx_genios_environment,
        lv_msg TYPE string.

  DATA: lo_obj    TYPE REF TO cl_genios_objective.

  DATA: lo_x TYPE REF TO cl_genios_variable,
        lo_y TYPE REF TO cl_genios_variable.

  DATA: lv_x TYPE genios_float VALUE '6000',
        lv_y TYPE genios_float VALUE '10000'.

  DATA: lo_solver TYPE REF TO cl_genios_solver,
        lx_solver TYPE REF TO cx_genios_solver.

  DATA: lo_lin TYPE REF TO cl_genios_linearconstraint.

  DATA: lt_variables TYPE geniost_variable,
        ls_variable TYPE genioss_variable,
        lv_primalvalue TYPE genios_float,
        lv_name  TYPE string,
        lv_index TYPE string.

  DATA: v_int TYPE i.
  DATA: ls_result TYPE genioss_solver_result.
  DATA: lo_model TYPE REF TO cl_genios_model.
* 1) create a genios environment object
  lo_env = cl_genios_environment=>get_environment( ).

  TRY.
* 2) create a genios model (with a context-unique name)
      lo_model = lo_env->create_model( lc_modelname ).
    CATCH cx_genios_environment INTO lx_env.
      lv_msg = lx_env->get_text( ).
      WRITE: lv_msg, /.
      EXIT.
  ENDTRY.

* 3) fill the model with data
* 3.1) create the objective object
  lo_obj = lo_model->create_objective( if_genios_model_c=>gc_obj_minimization ).

* 3.2) create the needed variables
  lo_x = lo_model->create_variable( iv_name = 'X' iv_type = if_genios_model_c=>gc_var_continuous ).
  lo_y = lo_model->create_variable( iv_name = 'Y' iv_type = if_genios_model_c=>gc_var_continuous ).

* 3.3) add the monom for the objective function
*      this is the coefficient for each variable in the objective function
  lo_obj->add_monom( io_variable = lo_x iv_coefficient = lv_x ).
  lo_obj->add_monom( io_variable = lo_y iv_coefficient = lv_y ).

* 3.4) add the linear constraints with their monomes (coefficients for the variables
  lo_lin = lo_model->create_linearconstraint( iv_name = 'FIXED' iv_type = if_genios_model_c=>gc_con_greaterorequal iv_righthandside = iv_objective_righthandside ).
  lo_lin->add_monom( io_variable = lo_x iv_coefficient = 6000 ).
  lo_lin->add_monom( io_variable = lo_y iv_coefficient = 10000 ).

*  lo_lin = lo_model->create_linearconstraint( iv_name = 'CONS' iv_type = if_genios_model_c=>gc_con_lessorequal iv_righthandside = 1 ).
*  lo_lin->add_monom( io_variable = lo_y iv_coefficient = 1 ).

* 4) as the model is filled, we now create a solver with a ID out of tx genios_solver (in this case, the default SIMPLEX solver)
  TRY.
      lo_solver ?= lo_env->create_solver( solverid ).
    CATCH cx_genios_environment INTO lx_env.
      lv_msg = lx_env->get_text( ).
      WRITE: lv_msg, /.
      EXIT.
  ENDTRY.
* 4.1) load the model into the solver and solve it

  TRY.
      lo_solver->load_model( lo_model ).
      ls_result = lo_solver->solve( ).
    CATCH cx_genios_solver INTO lx_solver.
      lv_msg = lx_solver->get_text( ).
      WRITE: lv_msg, /.
      EXIT.
  ENDTRY.

* 4.2) evaluate the results
  IF ( ls_result-solution_status = if_genios_solver_result_c=>gc_optimal
     OR ls_result-solution_status = if_genios_solver_result_c=>gc_abortfeasible ).
* 4.3) found a solution => output the objective value as well as the variable values
*    lv_primalvalue = lo_obj->get_value( ).
    ls_intial_solution-objective =  lo_obj->get_value( ).
*    WRITE: /,'Objective value: ',lv_primalvalue.            "#EC NOTEXT
    lt_variables = lo_model->get_variables( ).
    LOOP AT lt_variables INTO ls_variable.
      lv_primalvalue = 0.
      lv_name = ls_variable-variable_ref->gv_name.
      lv_index = ls_variable-variable_index.
*      lv_primalvalue = ls_variable-variable_ref->get_primalvalue( ).
*      WRITE: /,lv_name,'[',lv_index,'] = ',lv_primalvalue.
      IF lv_name EQ 'X'.
        ls_intial_solution-xvalue = ls_variable-variable_ref->get_primalvalue( ).
        v_int = trunc( ls_intial_solution-xvalue  ).
        IF v_int = ls_intial_solution-xvalue.
          ls_intial_solution-is_xinteger   = 'Y'.
          ls_intial_solution-is_xcandidate = 'N'.
          IF  ls_intial_solution-xvalue EQ 0 .
            ls_intial_solution-is_xzero = 'Y'.
          ENDIF.
        ELSE.
          ls_intial_solution-is_xinteger   = 'N'.
          ls_intial_solution-is_xcandidate = 'Y'.
          ls_intial_solution-is_xzero      = 'N'.
          ls_intial_solution-lowerbound_ofx = v_int.
          ls_intial_solution-upperbound_ofx = v_int + 1.
        ENDIF.
      ENDIF.

      IF lv_name EQ 'Y'.
        ls_intial_solution-yvalue = ls_variable-variable_ref->get_primalvalue( ).
        v_int = trunc( ls_intial_solution-yvalue  ).
        IF v_int = ls_intial_solution-yvalue.
          ls_intial_solution-is_yinteger   = 'Y'.
          ls_intial_solution-is_ycandidate = 'N'.
          IF  ls_intial_solution-yvalue EQ 0 .
            ls_intial_solution-is_yzero = 'Y'.
          ENDIF.
*        WRITE: ' Number has no floating point '.
        ELSE.
          ls_intial_solution-is_yinteger   = 'N'.
          ls_intial_solution-is_ycandidate = 'Y'.
          ls_intial_solution-is_yzero      = 'N'.
          ls_intial_solution-lowerbound_ofy = v_int.
          ls_intial_solution-upperbound_ofy = v_int + 1.
*        WRITE: ' Number has floating point '.
        ENDIF.
      ENDIF.

      CLEAR: v_int.
    ENDLOOP.
  ENDIF.

  IF ls_intial_solution-is_xinteger EQ 'Y' AND ls_intial_solution-is_yinteger EQ 'Y'.
    ls_intial_solution-selected_cadidate = 'O'. "" not candidate variable solution feasible and optimal.
  ENDIF.

  IF ls_intial_solution-is_yzero EQ 'Y' AND ls_intial_solution-is_xzero EQ 'Y'.
    ls_intial_solution-selected_cadidate = 'N'. "" not candidate variable solution infeasible.
  ENDIF.

  IF ls_intial_solution-selected_cadidate NE 'N' AND ls_intial_solution-selected_cadidate NE 'O'.
    IF ls_intial_solution-is_xinteger EQ 'N'.
      ls_intial_solution-selected_cadidate = 'X'.
    ELSEIF ls_intial_solution-is_yinteger EQ 'N'.
      ls_intial_solution-selected_cadidate = 'Y'.
    ENDIF.
  ENDIF.
* 5) some cleanup
  IF ( lo_env IS BOUND ).
    lo_env->destroy_solver( solverid ).
    lo_env->destroy_model( lc_modelname ).
  ENDIF.

*  DATA: lv_iteration TYPE char30 VALUE 0.
*  DATA: lv_string TYPE string.

  APPEND ls_intial_solution TO lt_solution.
  ls_intial_solution2 = ls_intial_solution.

  PERFORM repeat_solution USING ls_intial_solution iv_objective_righthandside.

  PERFORM repeat_solution_right USING ls_intial_solution2 iv_objective_righthandside.
  DELETE lt_solution WHERE selected_cadidate ne 'O'.
  SORT lt_solution by objective yvalue DESCENDING.
  IF lt_solution IS NOT INITIAL.
    READ TABLE lt_solution INTO es_return INDEX 1.
  ENDIF.

ENDFORM.                    "calculate_objective
*&---------------------------------------------------------------------*
*&      Form  solve_model
*&---------------------------------------------------------------------*
FORM solve_model TABLES gt_constraints TYPE STANDARD TABLE
                  USING iv_objective_righthandside TYPE  genios_float
                         pv_cont  TYPE char1
                 CHANGING ls_intial_solution TYPE ltt_intial_solution
                          lv_flag  TYPE char1.


*  DATA: ls_node TYPE ltt_node.
*  DATA: ls_intial_solution TYPE ltt_intial_solution.
  DATA: lo_env TYPE REF TO cl_genios_environment,
        lx_env TYPE REF TO cx_genios_environment,
        lv_msg TYPE string.

  DATA: lo_obj    TYPE REF TO cl_genios_objective.

  DATA: lo_x TYPE REF TO cl_genios_variable,
        lo_y TYPE REF TO cl_genios_variable.

  DATA: lv_x TYPE genios_float VALUE '6000',
        lv_y TYPE genios_float VALUE '10000'.

  DATA: lo_solver TYPE REF TO cl_genios_solver,
        lx_solver TYPE REF TO cx_genios_solver.

  DATA: lo_lin TYPE REF TO cl_genios_linearconstraint.

  DATA: lt_variables TYPE geniost_variable,
        ls_variable TYPE genioss_variable,
        lv_primalvalue TYPE genios_float,
        lv_name  TYPE string,
        lv_index TYPE string.

  DATA: v_int TYPE i.
  DATA: ls_result TYPE genioss_solver_result.
  DATA: lo_model TYPE REF TO cl_genios_model.

  FIELD-SYMBOLS: <fs_name>       TYPE any ,
                 <type>          TYPE any,
                 <righthandside> TYPE any,
                 <coefficient>   TYPE any,
                 <variable>      TYPE any.

* 1) create a genios environment object
  lo_env = cl_genios_environment=>get_environment( ).

  TRY.
* 2) create a genios model (with a context-unique name)
      lo_model = lo_env->create_model( lc_modelname ).
    CATCH cx_genios_environment INTO lx_env.
      lv_msg = lx_env->get_text( ).
      WRITE: lv_msg, /.
      EXIT.
  ENDTRY.

* 3) fill the model with data
* 3.1) create the objective object
  lo_obj = lo_model->create_objective( if_genios_model_c=>gc_obj_minimization ).

* 3.2) create the needed variables
  lo_x = lo_model->create_variable( iv_name = 'X' iv_type = if_genios_model_c=>gc_var_continuous ).
  lo_y = lo_model->create_variable( iv_name = 'Y' iv_type = if_genios_model_c=>gc_var_continuous ).

* 3.3) add the monom for the objective function
*      this is the coefficient for each variable in the objective function
  lo_obj->add_monom( io_variable = lo_x iv_coefficient = lv_x ).
  lo_obj->add_monom( io_variable = lo_y iv_coefficient = lv_y ).

* 3.4) add the linear constraints with their monomes (coefficients for the variables
  lo_lin = lo_model->create_linearconstraint( iv_name = 'FIXED' iv_type = if_genios_model_c=>gc_con_greaterorequal iv_righthandside = iv_objective_righthandside ).
  lo_lin->add_monom( io_variable = lo_x iv_coefficient = 6000 ).
  lo_lin->add_monom( io_variable = lo_y iv_coefficient = 10000 ).

  LOOP AT gt_constraints.
    ASSIGN COMPONENT 'NAME' OF STRUCTURE gt_constraints TO <fs_name>.
    ASSIGN COMPONENT 'TYPE' OF STRUCTURE gt_constraints TO <type>.
    ASSIGN COMPONENT 'RIGHTHANDSIDE' OF STRUCTURE gt_constraints TO <righthandside>.
    ASSIGN COMPONENT 'COEFFICIENT' OF STRUCTURE gt_constraints TO <coefficient>.
    ASSIGN COMPONENT 'VARIABLE' OF STRUCTURE gt_constraints TO <variable>.
    lo_lin = lo_model->create_linearconstraint( iv_name = <fs_name> iv_type = <type> iv_righthandside = <righthandside> ).
    IF <variable> EQ 'Y'.
      lo_lin->add_monom( io_variable = lo_y iv_coefficient = <coefficient> ).
    ELSEIF <variable> EQ 'X'.
      lo_lin->add_monom( io_variable = lo_x iv_coefficient = <coefficient> ).
    ENDIF.

  ENDLOOP.
* 4) as the model is filled, we now create a solver with a ID out of tx genios_solver (in this case, the default SIMPLEX solver)
  TRY.
      lo_solver ?= lo_env->create_solver( solverid ).
    CATCH cx_genios_environment INTO lx_env.
      lv_msg = lx_env->get_text( ).
      WRITE: lv_msg, /.
      EXIT.
  ENDTRY.
* 4.1) load the model into the solver and solve it

  TRY.
      lo_solver->load_model( lo_model ).
      ls_result = lo_solver->solve( ).
    CATCH cx_genios_solver INTO lx_solver.
      lv_msg = lx_solver->get_text( ).
      WRITE: lv_msg, /.
      EXIT.
  ENDTRY.

  IF pv_cont IS INITIAL.


    lv_flag = 'N'.
* 4.2) evaluate the results
    IF ( ls_result-solution_status = if_genios_solver_result_c=>gc_optimal
       OR ls_result-solution_status = if_genios_solver_result_c=>gc_abortfeasible ).
* 4.3) found a solution => output the objective value as well as the variable values
*    lv_primalvalue = lo_obj->get_value( ).
      lv_flag = 'Y'.
      ls_intial_solution-objective =  lo_obj->get_value( ).
*    WRITE: /,'Objective value: ',lv_primalvalue.            "#EC NOTEXT
      lt_variables = lo_model->get_variables( ).
      LOOP AT lt_variables INTO ls_variable.
        lv_primalvalue = 0.
        lv_name = ls_variable-variable_ref->gv_name.
        lv_index = ls_variable-variable_index.
*      lv_primalvalue = ls_variable-variable_ref->get_primalvalue( ).
*      WRITE: /,lv_name,'[',lv_index,'] = ',lv_primalvalue.
        IF lv_name EQ 'X'.
          ls_intial_solution-xvalue = ls_variable-variable_ref->get_primalvalue( ).
          v_int = trunc( ls_intial_solution-xvalue  ).
          IF v_int = ls_intial_solution-xvalue.
            ls_intial_solution-is_xinteger   = 'Y'.
            ls_intial_solution-is_xcandidate = 'N'.
            IF  ls_intial_solution-xvalue EQ 0 .
              ls_intial_solution-is_xzero = 'Y'.
            ENDIF.
          ELSE.
            ls_intial_solution-is_xinteger   = 'N'.
            ls_intial_solution-is_xcandidate = 'Y'.
            ls_intial_solution-is_xzero      = 'N'.
            ls_intial_solution-lowerbound_ofx = v_int.
            ls_intial_solution-upperbound_ofx = v_int + 1.
          ENDIF.
        ENDIF.

        IF lv_name EQ 'Y'.
          ls_intial_solution-yvalue = ls_variable-variable_ref->get_primalvalue( ).
          v_int = trunc( ls_intial_solution-yvalue  ).
          IF v_int = ls_intial_solution-yvalue.
            ls_intial_solution-is_yinteger   = 'Y'.
            ls_intial_solution-is_ycandidate = 'N'.
            IF  ls_intial_solution-yvalue EQ 0 .
              ls_intial_solution-is_yzero = 'Y'.
            ENDIF.
*        WRITE: ' Number has no floating point '.
          ELSE.
            ls_intial_solution-is_yinteger   = 'N'.
            ls_intial_solution-is_ycandidate = 'Y'.
            ls_intial_solution-is_yzero      = 'N'.
            ls_intial_solution-lowerbound_ofy = v_int.
            ls_intial_solution-upperbound_ofy = v_int + 1.
*        WRITE: ' Number has floating point '.
          ENDIF.
        ENDIF.

        CLEAR: v_int.
      ENDLOOP.
    ENDIF.

    IF ls_intial_solution-is_xinteger EQ 'Y' AND ls_intial_solution-is_yinteger EQ 'Y'.
      ls_intial_solution-selected_cadidate = 'O'. "" not candidate variable solution feasible and optimal.
    ENDIF.

    IF ls_intial_solution-is_yzero EQ 'Y' AND ls_intial_solution-is_xzero EQ 'Y'.
      ls_intial_solution-selected_cadidate = 'N'. "" not candidate variable solution infeasible.
    ENDIF.

    IF ls_intial_solution-selected_cadidate NE 'N' AND ls_intial_solution-selected_cadidate NE 'O'.
      IF ls_intial_solution-is_xinteger EQ 'N'.
        ls_intial_solution-selected_cadidate = 'X'.
      ELSEIF ls_intial_solution-is_yinteger EQ 'N'.
        ls_intial_solution-selected_cadidate = 'Y'.
      ENDIF.
    ENDIF.

  ELSEIF pv_cont EQ 'X'.

    lv_flag = 'N'.
* 4.2) evaluate the results
    IF ( ls_result-solution_status = if_genios_solver_result_c=>gc_optimal
       OR ls_result-solution_status = if_genios_solver_result_c=>gc_abortfeasible ).
* 4.3) found a solution => output the objective value as well as the variable values
*    lv_primalvalue = lo_obj->get_value( ).
      lv_flag = 'Y'.
      ls_intial_solution_l-objective =  lo_obj->get_value( ).
*    WRITE: /,'Objective value: ',lv_primalvalue.            "#EC NOTEXT
      lt_variables = lo_model->get_variables( ).
      LOOP AT lt_variables INTO ls_variable.
        lv_primalvalue = 0.
        lv_name = ls_variable-variable_ref->gv_name.
        lv_index = ls_variable-variable_index.
*      lv_primalvalue = ls_variable-variable_ref->get_primalvalue( ).
*      WRITE: /,lv_name,'[',lv_index,'] = ',lv_primalvalue.
        IF lv_name EQ 'X'.
          ls_intial_solution_l-xvalue = ls_variable-variable_ref->get_primalvalue( ).
          v_int = trunc( ls_intial_solution_l-xvalue  ).
          IF v_int = ls_intial_solution_l-xvalue.
            ls_intial_solution_l-is_xinteger   = 'Y'.
            ls_intial_solution_l-is_xcandidate = 'N'.
            IF  ls_intial_solution_l-xvalue EQ 0 .
              ls_intial_solution_l-is_xzero = 'Y'.
            ENDIF.
          ELSE.
            ls_intial_solution_l-is_xinteger   = 'N'.
            ls_intial_solution_l-is_xcandidate = 'Y'.
            ls_intial_solution_l-is_xzero      = 'N'.
            ls_intial_solution_l-lowerbound_ofx = v_int.
            ls_intial_solution_l-upperbound_ofx = v_int + 1.
          ENDIF.
        ENDIF.

        IF lv_name EQ 'Y'.
          ls_intial_solution_l-yvalue = ls_variable-variable_ref->get_primalvalue( ).
          v_int = trunc( ls_intial_solution_l-yvalue  ).
          IF v_int = ls_intial_solution_l-yvalue.
            ls_intial_solution_l-is_yinteger   = 'Y'.
            ls_intial_solution_l-is_ycandidate = 'N'.
            IF  ls_intial_solution_l-yvalue EQ 0 .
              ls_intial_solution_l-is_yzero = 'Y'.
            ENDIF.
*        WRITE: ' Number has no floating point '.
          ELSE.
            ls_intial_solution_l-is_yinteger   = 'N'.
            ls_intial_solution_l-is_ycandidate = 'Y'.
            ls_intial_solution_l-is_yzero      = 'N'.
            ls_intial_solution_l-lowerbound_ofy = v_int.
            ls_intial_solution_l-upperbound_ofy = v_int + 1.
*        WRITE: ' Number has floating point '.
          ENDIF.
        ENDIF.

        CLEAR: v_int.
      ENDLOOP.
    ENDIF.

    IF ls_intial_solution_l-is_xinteger EQ 'Y' AND ls_intial_solution_l-is_yinteger EQ 'Y'.
      ls_intial_solution_l-selected_cadidate = 'O'. "" not candidate variable solution feasible and optimal.
    ENDIF.

    IF ls_intial_solution_l-is_yzero EQ 'Y' AND ls_intial_solution_l-is_xzero EQ 'Y'.
      ls_intial_solution_l-selected_cadidate = 'N'. "" not candidate variable solution infeasible.
    ENDIF.

    IF ls_intial_solution_l-selected_cadidate NE 'N' AND ls_intial_solution_l-selected_cadidate NE 'O'.
      IF ls_intial_solution_l-is_xinteger EQ 'N'.
        ls_intial_solution_l-selected_cadidate = 'X'.
      ELSEIF ls_intial_solution_l-is_yinteger EQ 'N'.
        ls_intial_solution_l-selected_cadidate = 'Y'.
      ENDIF.
    ENDIF.


  ENDIF.

* 5) some cleanup
  IF ( lo_env IS BOUND ).
    lo_env->destroy_solver( solverid ).
    lo_env->destroy_model( lc_modelname ).
  ENDIF.
ENDFORM.                    "solve_model
*&---------------------------------------------------------------------*
*&      Form  repeat_solution
*&---------------------------------------------------------------------*
FORM repeat_solution USING ls_intial_solution TYPE ltt_intial_solution  iv_objective_righthandside TYPE  genios_float.

  DATA: ls_constraint    TYPE ltt_node_protype,
        ls_constraint_l  TYPE ltt_node_protype,
        ls_constraint_u  TYPE ltt_node_protype,
        lv_line        TYPE i,
        lv_chr         TYPE char10.
  DATA: lo_x TYPE REF TO cl_genios_variable,
        lo_y TYPE REF TO cl_genios_variable,
        lv_flag TYPE char1.

  DATA : lt_temp TYPE TABLE OF ltt_node_protype.
  CLEAR: ls_intial_solution_l.

  IF ls_intial_solution-selected_cadidate NE 'X' AND ls_intial_solution-selected_cadidate NE 'Y'.
    EXIT.
  ENDIF.

  IF ls_intial_solution-selected_cadidate = 'Y'.

    IF ls_intial_solution-is_xinteger EQ 'Y'.

      lt_temp = gt_constraint_left[].
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'X'.
      ls_constraint_l-righthandside = ls_intial_solution-xvalue.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .

      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'Y' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'Y'.
      ls_constraint_l-righthandside = ls_intial_solution-lowerbound_ofy.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .
      PERFORM solve_model TABLES lt_temp USING iv_objective_righthandside 'X' CHANGING ls_intial_solution_l lv_flag .
      IF lv_flag EQ 'Y'.
        APPEND ls_intial_solution_l TO lt_solution.
      ENDIF.


      lt_temp = gt_constraint_left[].
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'X'.
      ls_constraint_l-righthandside = ls_intial_solution-xvalue.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .

      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'Y' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'Y'.
      ls_constraint_l-righthandside = ls_intial_solution-upperbound_ofy.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .
      PERFORM solve_model TABLES lt_temp USING iv_objective_righthandside 'X' CHANGING ls_intial_solution_l lv_flag .
      IF lv_flag EQ 'Y'.
        APPEND ls_intial_solution_l TO lt_solution.
      ENDIF.
    ENDIF.

    ls_constraint-coefficient = 1.
    lv_line = lines( gt_constraint_left ) .
    lv_chr = lv_line.
    CONDENSE lv_chr.
    CONCATENATE 'NODE' lv_chr '1' 'Y' INTO ls_constraint-name.
    CONDENSE ls_constraint-name.
    ls_constraint-coefficient   = 1.
    ls_constraint-variable      = 'Y'.
    ls_constraint-righthandside = ls_intial_solution-lowerbound_ofy.
    ls_constraint-type = 'L'.
    APPEND ls_constraint TO gt_constraint_left .
    PERFORM solve_model TABLES gt_constraint_left USING iv_objective_righthandside '' CHANGING ls_intial_solution lv_flag .
    IF lv_flag EQ 'Y'.
      APPEND ls_intial_solution TO lt_solution.
      PERFORM repeat_solution USING ls_intial_solution  iv_objective_righthandside.
    ELSEIF lv_flag EQ 'N'.
      lv_line = lines( gt_constraint_left ) .
      DELETE gt_constraint_left INDEX lv_line.
    ENDIF.

    IF ls_intial_solution-is_xinteger EQ 'Y'.

      lt_temp = gt_constraint_left[].
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'X'.
      ls_constraint_l-righthandside = ls_intial_solution-xvalue.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .


      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'Y' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'Y'.
      ls_constraint_l-righthandside = ls_intial_solution-lowerbound_ofy.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .
      PERFORM solve_model TABLES lt_temp USING iv_objective_righthandside 'X' CHANGING ls_intial_solution_l lv_flag .
      IF lv_flag EQ 'Y'.
        APPEND ls_intial_solution_l TO lt_solution.
        CLEAR: ls_intial_solution_l.
      ENDIF.

      lt_temp = gt_constraint_left[].
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'X'.
      ls_constraint_l-righthandside = ls_intial_solution-xvalue.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .


      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'X'.
      ls_constraint_l-righthandside = ls_intial_solution-upperbound_ofx.
      ls_constraint_l-type = 'G'.
      APPEND ls_constraint_l TO lt_temp .
      PERFORM solve_model TABLES lt_temp USING iv_objective_righthandside 'X' CHANGING ls_intial_solution_l lv_flag .
      IF lv_flag EQ 'Y'.
        APPEND ls_intial_solution_l TO lt_solution.
        CLEAR: ls_intial_solution_l.
      ENDIF.
    ENDIF.


    ls_constraint-coefficient = 1.
    lv_line = lines( gt_constraint_left ) .
    lv_chr = lv_line.
    CONDENSE lv_chr.
    CONCATENATE 'NODE' lv_chr '2' 'Y' INTO ls_constraint-name.
    CONDENSE ls_constraint-name.
    ls_constraint-coefficient   = 1.
    ls_constraint-variable      = 'Y'.
    ls_constraint-righthandside = ls_intial_solution-upperbound_ofy.
    ls_constraint-type = 'G'.
    APPEND ls_constraint TO gt_constraint_left.

    PERFORM solve_model TABLES gt_constraint_left  USING iv_objective_righthandside '' CHANGING ls_intial_solution lv_flag .
    IF lv_flag EQ 'Y'.
      APPEND ls_intial_solution TO lt_solution.
      PERFORM repeat_solution USING ls_intial_solution  iv_objective_righthandside.
    ELSEIF lv_flag EQ 'N'.
      lv_line = lines( gt_constraint_left ) .
      DELETE gt_constraint_left INDEX lv_line.
    ENDIF.
  ENDIF.


  IF ls_intial_solution-selected_cadidate = 'X'.
    IF ls_intial_solution-is_yinteger EQ 'Y'.

      lt_temp = gt_constraint_left[].
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'Y' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'Y'.
      ls_constraint_l-righthandside = ls_intial_solution-yvalue.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .

      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'X'.
      ls_constraint_l-righthandside = ls_intial_solution-lowerbound_ofx.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .
      PERFORM solve_model TABLES lt_temp USING iv_objective_righthandside 'X' CHANGING ls_intial_solution_l lv_flag .
      IF lv_flag EQ 'Y'.
        APPEND ls_intial_solution_l TO lt_solution.
        CLEAR: ls_intial_solution_l.
      ENDIF.


      lt_temp = gt_constraint_left[].
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'Y' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'Y'.
      ls_constraint_l-righthandside = ls_intial_solution-yvalue.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'X'.
      ls_constraint_l-righthandside = ls_intial_solution-upperbound_ofx.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .
      PERFORM solve_model TABLES lt_temp USING iv_objective_righthandside 'X' CHANGING ls_intial_solution_l lv_flag .
      IF lv_flag EQ 'Y'.
        APPEND ls_intial_solution_l TO lt_solution.
        CLEAR: ls_intial_solution_l.
      ENDIF.
    ENDIF.

    ls_constraint-coefficient = 1.
    lv_line = lines( gt_constraint_left ) .
    lv_chr = lv_line.
    CONDENSE lv_chr.
    CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint-name.
    CONDENSE ls_constraint-name.
    ls_constraint-coefficient   = 1.
    ls_constraint-variable      = 'X'.
    ls_constraint-righthandside = ls_intial_solution-lowerbound_ofx.
    ls_constraint-type = 'L'.
    APPEND ls_constraint TO gt_constraint_left .

    PERFORM solve_model TABLES gt_constraint_left USING iv_objective_righthandside '' CHANGING ls_intial_solution lv_flag .
    IF lv_flag EQ 'Y'.
      APPEND ls_intial_solution TO lt_solution.
      PERFORM repeat_solution USING ls_intial_solution  iv_objective_righthandside.
    ELSEIF lv_flag EQ 'N'.
      lv_line = lines( gt_constraint_left ) .
      DELETE gt_constraint_left INDEX lv_line.
    ENDIF.

    IF ls_intial_solution-is_yinteger EQ 'Y'.
      lt_temp = gt_constraint_left[].
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'Y' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'Y'.
      ls_constraint_l-righthandside = ls_intial_solution-yvalue.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .


      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'X'.
      ls_constraint_l-righthandside = ls_intial_solution-lowerbound_ofx.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .
      PERFORM solve_model TABLES lt_temp USING iv_objective_righthandside 'X' CHANGING ls_intial_solution_l lv_flag .
      IF lv_flag EQ 'Y'.
        APPEND ls_intial_solution_l TO lt_solution.
        CLEAR: ls_intial_solution_l.
      ENDIF.


      lt_temp = gt_constraint_left[].
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'Y' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'Y'.
      ls_constraint_l-righthandside = ls_intial_solution-yvalue.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'X'.
      ls_constraint_l-righthandside = ls_intial_solution-upperbound_ofx.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .
      PERFORM solve_model TABLES lt_temp USING iv_objective_righthandside 'X' CHANGING ls_intial_solution_l lv_flag .
      IF lv_flag EQ 'Y'.
        APPEND ls_intial_solution_l TO lt_solution.
        CLEAR: ls_intial_solution_l.
      ENDIF.
    ENDIF.


    ls_constraint-coefficient = 1.
    lv_line = lines( gt_constraint_left ) .
    lv_chr = lv_line.
    CONDENSE lv_chr.
    CONCATENATE 'NODE' lv_chr '2' 'X' INTO ls_constraint-name.
    CONDENSE ls_constraint-name.
    ls_constraint-coefficient   = 1.
    ls_constraint-variable      = 'X'.
    ls_constraint-righthandside = ls_intial_solution-upperbound_ofx.
    ls_constraint-type = 'G'.
    APPEND ls_constraint TO gt_constraint_left.

    PERFORM solve_model TABLES gt_constraint_left  USING iv_objective_righthandside '' CHANGING ls_intial_solution lv_flag .
    IF lv_flag EQ 'Y'.
      APPEND ls_intial_solution TO lt_solution.
      PERFORM repeat_solution USING ls_intial_solution  iv_objective_righthandside.
    ELSEIF lv_flag EQ 'N'.
      lv_line = lines( gt_constraint_left ) .
      DELETE gt_constraint_left INDEX lv_line.
    ENDIF.
  ENDIF.

ENDFORM.                    "repeat_solution
*&---------------------------------------------------------------------*
*&      Form  repeat_solution
*&---------------------------------------------------------------------*
FORM repeat_solution_right USING ls_intial_solution TYPE ltt_intial_solution  iv_objective_righthandside TYPE  genios_float.

  DATA: ls_constraint    TYPE ltt_node_protype,
        lv_line          TYPE i,
        ls_constraint_l  TYPE ltt_node_protype,
        ls_constraint_u  TYPE ltt_node_protype,
        lv_chr         TYPE char10.
  DATA: lo_x TYPE REF TO cl_genios_variable,
        lo_y TYPE REF TO cl_genios_variable,
        lv_flag TYPE char1.

  DATA:  lt_temp TYPE TABLE OF ltt_node_protype.
  CLEAR: ls_intial_solution_l.

  IF ls_intial_solution-selected_cadidate NE 'X' AND ls_intial_solution-selected_cadidate NE 'Y'.
    EXIT.
  ENDIF.

  IF ls_intial_solution-selected_cadidate = 'Y'.

    IF ls_intial_solution-is_xinteger EQ 'Y'.

      lt_temp = gt_constraint_left[].
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'X'.
      ls_constraint_l-righthandside = ls_intial_solution-xvalue.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .

      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'Y' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'Y'.
      ls_constraint_l-righthandside = ls_intial_solution-lowerbound_ofy.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .
      PERFORM solve_model TABLES lt_temp USING iv_objective_righthandside 'X' CHANGING ls_intial_solution_l lv_flag .
      IF lv_flag EQ 'Y'.
        APPEND ls_intial_solution_l TO lt_solution.
      ENDIF.


      lt_temp = gt_constraint_left[].
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'X'.
      ls_constraint_l-righthandside = ls_intial_solution-xvalue.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .

      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'Y' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'Y'.
      ls_constraint_l-righthandside = ls_intial_solution-upperbound_ofy.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .
      PERFORM solve_model TABLES lt_temp USING iv_objective_righthandside 'X' CHANGING ls_intial_solution_l lv_flag .
      IF lv_flag EQ 'Y'.
        APPEND ls_intial_solution_l TO lt_solution.
      ENDIF.
    ENDIF.

    ls_constraint-coefficient = 1.
    lv_line = lines( gt_constraint_right ) .
    lv_chr = lv_line.
    CONDENSE lv_chr.
    CONCATENATE 'NODE' lv_chr '2' 'Y' INTO ls_constraint-name.
    CONDENSE ls_constraint-name.
    ls_constraint-coefficient   = 1.
    ls_constraint-variable      = 'Y'.
    ls_constraint-righthandside = ls_intial_solution-upperbound_ofy.
    ls_constraint-type = 'G'.
    APPEND ls_constraint TO gt_constraint_right.

    PERFORM solve_model TABLES gt_constraint_right  USING iv_objective_righthandside '' CHANGING ls_intial_solution lv_flag.
    IF lv_flag EQ 'Y'.
      APPEND ls_intial_solution TO lt_solution.
      PERFORM repeat_solution USING ls_intial_solution  iv_objective_righthandside.
    ELSEIF lv_flag EQ 'N'.
      lv_line = lines( gt_constraint_right ) .
      DELETE gt_constraint_right INDEX lv_line.
    ENDIF.

    IF ls_intial_solution-is_xinteger EQ 'Y'.

      lt_temp = gt_constraint_left[].
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'X'.
      ls_constraint_l-righthandside = ls_intial_solution-xvalue.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .


      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'Y' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'Y'.
      ls_constraint_l-righthandside = ls_intial_solution-lowerbound_ofy.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .
      PERFORM solve_model TABLES lt_temp USING iv_objective_righthandside 'X' CHANGING ls_intial_solution_l lv_flag .
      IF lv_flag EQ 'Y'.
        APPEND ls_intial_solution_l TO lt_solution.
        CLEAR: ls_intial_solution_l.
      ENDIF.

      lt_temp = gt_constraint_left[].
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'X'.
      ls_constraint_l-righthandside = ls_intial_solution-xvalue.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .


      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'X'.
      ls_constraint_l-righthandside = ls_intial_solution-upperbound_ofx.
      ls_constraint_l-type = 'G'.
      APPEND ls_constraint_l TO lt_temp .
      PERFORM solve_model TABLES lt_temp USING iv_objective_righthandside 'X' CHANGING ls_intial_solution_l lv_flag .
      IF lv_flag EQ 'Y'.
        APPEND ls_intial_solution_l TO lt_solution.
        CLEAR: ls_intial_solution_l.
      ENDIF.
    ENDIF.

    ls_constraint-coefficient = 1.
    lv_line = lines( gt_constraint_right ) .
    lv_chr = lv_line.
    CONDENSE lv_chr.
    CONCATENATE 'NODE' lv_chr '1' 'Y' INTO ls_constraint-name.
    CONDENSE ls_constraint-name.
    ls_constraint-coefficient   = 1.
    ls_constraint-variable      = 'Y'.
    ls_constraint-righthandside = ls_intial_solution-lowerbound_ofy.
    ls_constraint-type = 'L'.
    APPEND ls_constraint TO gt_constraint_right .

    PERFORM solve_model TABLES gt_constraint_right USING iv_objective_righthandside  '' CHANGING ls_intial_solution lv_flag.
    IF lv_flag EQ 'Y'.
      APPEND ls_intial_solution TO lt_solution.
      PERFORM repeat_solution USING ls_intial_solution  iv_objective_righthandside.
    ELSEIF lv_flag EQ 'N'.
      lv_line = lines( gt_constraint_right ) .
      DELETE gt_constraint_right INDEX lv_line.
    ENDIF.

  ENDIF.


  IF ls_intial_solution-selected_cadidate = 'X'.
    IF ls_intial_solution-is_yinteger EQ 'Y'.

      lt_temp = gt_constraint_left[].
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'Y' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'Y'.
      ls_constraint_l-righthandside = ls_intial_solution-yvalue.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .

      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'X'.
      ls_constraint_l-righthandside = ls_intial_solution-lowerbound_ofx.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .
      PERFORM solve_model TABLES lt_temp USING iv_objective_righthandside 'X' CHANGING ls_intial_solution_l lv_flag .
      IF lv_flag EQ 'Y'.
        APPEND ls_intial_solution_l TO lt_solution.
        CLEAR: ls_intial_solution_l.
      ENDIF.


      lt_temp = gt_constraint_left[].
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'Y' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'Y'.
      ls_constraint_l-righthandside = ls_intial_solution-yvalue.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'X'.
      ls_constraint_l-righthandside = ls_intial_solution-upperbound_ofx.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .
      PERFORM solve_model TABLES lt_temp USING iv_objective_righthandside 'X' CHANGING ls_intial_solution_l lv_flag .
      IF lv_flag EQ 'Y'.
        APPEND ls_intial_solution_l TO lt_solution.
        CLEAR: ls_intial_solution_l.
      ENDIF.
    ENDIF.

    ls_constraint-coefficient = 1.
    lv_line = lines( gt_constraint_right ) .
    lv_chr = lv_line.
    CONDENSE lv_chr.
    CONCATENATE 'NODE' lv_chr '2' 'X' INTO ls_constraint-name.
    CONDENSE ls_constraint-name.
    ls_constraint-coefficient   = 1.
    ls_constraint-variable      = 'X'.
    ls_constraint-righthandside = ls_intial_solution-upperbound_ofx.
    ls_constraint-type = 'G'.
    APPEND ls_constraint TO gt_constraint_right.

    PERFORM solve_model TABLES gt_constraint_right  USING iv_objective_righthandside '' CHANGING ls_intial_solution lv_flag.
    IF lv_flag EQ 'Y'.
      APPEND ls_intial_solution TO lt_solution.
      PERFORM repeat_solution USING ls_intial_solution  iv_objective_righthandside.
    ELSEIF lv_flag EQ 'N'.
      lv_line = lines( gt_constraint_right ) .
      DELETE gt_constraint_right INDEX lv_line.
    ENDIF.

    IF ls_intial_solution-is_yinteger EQ 'Y'.
      lt_temp = gt_constraint_left[].
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'Y' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'Y'.
      ls_constraint_l-righthandside = ls_intial_solution-yvalue.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .


      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'X'.
      ls_constraint_l-righthandside = ls_intial_solution-lowerbound_ofx.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .
      PERFORM solve_model TABLES lt_temp USING iv_objective_righthandside 'X' CHANGING ls_intial_solution_l lv_flag .
      IF lv_flag EQ 'Y'.
        APPEND ls_intial_solution_l TO lt_solution.
        CLEAR: ls_intial_solution_l.
      ENDIF.


      lt_temp = gt_constraint_left[].
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'Y' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'Y'.
      ls_constraint_l-righthandside = ls_intial_solution-yvalue.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .
      ls_constraint_l-coefficient = 1.
      lv_line = lines( lt_temp ) .
      lv_chr = lv_line.
      CONDENSE lv_chr.
      CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint_l-name.
      CONDENSE ls_constraint-name.
      ls_constraint_l-coefficient   = 1.
      ls_constraint_l-variable      = 'X'.
      ls_constraint_l-righthandside = ls_intial_solution-upperbound_ofx.
      ls_constraint_l-type = 'E'.
      APPEND ls_constraint_l TO lt_temp .
      PERFORM solve_model TABLES lt_temp USING iv_objective_righthandside 'X' CHANGING ls_intial_solution_l lv_flag .
      IF lv_flag EQ 'Y'.
        APPEND ls_intial_solution_l TO lt_solution.
        CLEAR: ls_intial_solution_l.
      ENDIF.
    ENDIF.

    ls_constraint-coefficient = 1.
    lv_line = lines( gt_constraint_right ) .
    lv_chr = lv_line.
    CONDENSE lv_chr.
    CONCATENATE 'NODE' lv_chr '1' 'X' INTO ls_constraint-name.
    CONDENSE ls_constraint-name.
    ls_constraint-coefficient   = 1.
    ls_constraint-variable      = 'X'.
    ls_constraint-righthandside = ls_intial_solution-lowerbound_ofx.
    ls_constraint-type = 'L'.
    APPEND ls_constraint TO gt_constraint_right .

    PERFORM solve_model TABLES gt_constraint_right USING iv_objective_righthandside '' CHANGING ls_intial_solution lv_flag.
    IF lv_flag EQ 'Y'.
      APPEND ls_intial_solution TO lt_solution.
      PERFORM repeat_solution USING ls_intial_solution  iv_objective_righthandside.
    ELSEIF lv_flag EQ 'N'.
      lv_line = lines( gt_constraint_right ) .
      DELETE gt_constraint_right INDEX lv_line.
    ENDIF.
  ENDIF.

ENDFORM.                    "repeat_solution
