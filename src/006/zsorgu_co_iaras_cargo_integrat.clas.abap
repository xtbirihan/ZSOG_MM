class ZSORGU_CO_IARAS_CARGO_INTEGRAT definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods CALL_COURIER
    importing
      !INPUT type ZCGQRY_IARAS_CARGO_INTEGRATI10
    exporting
      !OUTPUT type ZCGQRY_IARAS_CARGO_INTEGRATIO9
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods CONSTRUCTOR
    importing
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    raising
      CX_AI_SYSTEM_FAULT .
  methods GET_QUERY_DS
    importing
      !INPUT type ZCGQRY_IARAS_CARGO_INTEGRATIO8
    exporting
      !OUTPUT type ZCGQRY_IARAS_CARGO_INTEGRATIO7
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_QUERY_JSON
    importing
      !INPUT type ZCGQRY_IARAS_CARGO_INTEGRATIO6
    exporting
      !OUTPUT type ZCGQRY_IARAS_CARGO_INTEGRATIO5
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_QUERY_XML
    importing
      !INPUT type ZCGQRY_IARAS_CARGO_INTEGRATIO4
    exporting
      !OUTPUT type ZCGQRY_IARAS_CARGO_INTEGRATIO3
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods SET_DATA_XML
    importing
      !INPUT type ZCGQRY_IARAS_CARGO_INTEGRATIO2
    exporting
      !OUTPUT type ZCGQRY_IARAS_CARGO_INTEGRATIO1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZSORGU_CO_IARAS_CARGO_INTEGRAT IMPLEMENTATION.


method CALL_COURIER.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'CALL_COURIER'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZSORGU_CO_IARAS_CARGO_INTEGRAT'
    logical_port_name   = logical_port_name
  ).

endmethod.


method GET_QUERY_DS.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_QUERY_DS'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_QUERY_JSON.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_QUERY_JSON'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_QUERY_XML.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_QUERY_XML'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method SET_DATA_XML.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'SET_DATA_XML'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.
ENDCLASS.
