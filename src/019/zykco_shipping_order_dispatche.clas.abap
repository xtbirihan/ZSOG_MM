class ZYKCO_SHIPPING_ORDER_DISPATCHE definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods CANCEL_RETURN_SHIPMENT_CODE
    importing
      !INPUT type ZYKSHIPPING_ORDER_DISPATCHER13
    exporting
      !OUTPUT type ZYKSHIPPING_ORDER_DISPATCHER12
    raising
      CX_AI_SYSTEM_FAULT
      ZYKCX_YURTICIKARGO_WSEXCEPTION
      CX_AI_APPLICATION_FAULT .
  methods CANCEL_SHIPMENT
    importing
      !INPUT type ZYKSHIPPING_ORDER_DISPATCHER11
    exporting
      !OUTPUT type ZYKSHIPPING_ORDER_DISPATCHER10
    raising
      CX_AI_SYSTEM_FAULT
      ZYKCX_YURTICIKARGO_WSEXCEPTION
      CX_AI_APPLICATION_FAULT .
  methods CONSTRUCTOR
    importing
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    raising
      CX_AI_SYSTEM_FAULT .
  methods CREATE_SHIPMENT
    importing
      !INPUT type ZYKSHIPPING_ORDER_DISPATCHER_9
    exporting
      !OUTPUT type ZYKSHIPPING_ORDER_DISPATCHER_6
    raising
      CX_AI_SYSTEM_FAULT
      ZYKCX_YURTICIKARGO_WSEXCEPTION
      CX_AI_APPLICATION_FAULT .
  methods CREATE_SHIPMENT_DETAIL
    importing
      !INPUT type ZYKSHIPPING_ORDER_DISPATCHER_8
    exporting
      !OUTPUT type ZYKSHIPPING_ORDER_DISPATCHER_7
    raising
      CX_AI_SYSTEM_FAULT
      ZYKCX_YURTICIKARGO_WSEXCEPTION
      CX_AI_APPLICATION_FAULT .
  methods QUERY_SHIPMENT
    importing
      !INPUT type ZYKSHIPPING_ORDER_DISPATCHER_5
    exporting
      !OUTPUT type ZYKSHIPPING_ORDER_DISPATCHER_2
    raising
      CX_AI_SYSTEM_FAULT
      ZYKCX_YURTICIKARGO_WSEXCEPTION
      CX_AI_APPLICATION_FAULT .
  methods QUERY_SHIPMENT_DETAIL
    importing
      !INPUT type ZYKSHIPPING_ORDER_DISPATCHER_4
    exporting
      !OUTPUT type ZYKSHIPPING_ORDER_DISPATCHER_3
    raising
      CX_AI_SYSTEM_FAULT
      ZYKCX_YURTICIKARGO_WSEXCEPTION
      CX_AI_APPLICATION_FAULT .
  methods SAVE_RETURN_SHIPMENT_CODE
    importing
      !INPUT type ZYKSHIPPING_ORDER_DISPATCHER_1
    exporting
      !OUTPUT type ZYKSHIPPING_ORDER_DISPATCHER_S
    raising
      CX_AI_SYSTEM_FAULT
      ZYKCX_YURTICIKARGO_WSEXCEPTION
      CX_AI_APPLICATION_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZYKCO_SHIPPING_ORDER_DISPATCHE IMPLEMENTATION.


method CANCEL_RETURN_SHIPMENT_CODE.

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
      method_name = 'CANCEL_RETURN_SHIPMENT_CODE'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method CANCEL_SHIPMENT.

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
      method_name = 'CANCEL_SHIPMENT'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZYKCO_SHIPPING_ORDER_DISPATCHE'
    logical_port_name   = logical_port_name
  ).

endmethod.


method CREATE_SHIPMENT.

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
      method_name = 'CREATE_SHIPMENT'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method CREATE_SHIPMENT_DETAIL.

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
      method_name = 'CREATE_SHIPMENT_DETAIL'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method QUERY_SHIPMENT.

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
      method_name = 'QUERY_SHIPMENT'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method QUERY_SHIPMENT_DETAIL.

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
      method_name = 'QUERY_SHIPMENT_DETAIL'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method SAVE_RETURN_SHIPMENT_CODE.

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
      method_name = 'SAVE_RETURN_SHIPMENT_CODE'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.
ENDCLASS.
