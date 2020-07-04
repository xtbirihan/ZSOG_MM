class ZARASCG_CO_SERVICE_SOAP definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods GET_PRICE_CALCULATION
    importing
      !INPUT type ZCARGO_GET_PRICE_CALCULATION_2
    exporting
      !OUTPUT type ZCARGO_GET_PRICE_CALCULATION_1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_REDIRECTION_LIST
    importing
      !INPUT type ZCARGO_GET_REDIRECTION_LIST_S2
    exporting
      !OUTPUT type ZCARGO_GET_REDIRECTION_LIST_S1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_REGIONS
    importing
      !INPUT type ZCARGO_GET_REGIONS_SOAP_IN
    exporting
      !OUTPUT type ZCARGO_GET_REGIONS_SOAP_OUT
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_SERVICE_LIST
    importing
      !INPUT type ZCARGO_GET_SERVICE_LIST_SOAP_I
    exporting
      !OUTPUT type ZCARGO_GET_SERVICE_LIST_SOAP_1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_SERVICE_TYPE
    importing
      !INPUT type ZCARGO_GET_SERVICE_TYPE_SOAP_I
    exporting
      !OUTPUT type ZCARGO_GET_SERVICE_TYPE_SOAP_1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_SORTED_CARGO_INFO
    importing
      !INPUT type ZCARGO_GET_SORTED_CARGO_INFO_2
    exporting
      !OUTPUT type ZCARGO_GET_SORTED_CARGO_INFO_1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_TOWN
    importing
      !INPUT type ZCARGO_GET_TOWN_SOAP_IN
    exporting
      !OUTPUT type ZCARGO_GET_TOWN_SOAP_OUT
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_UNDELIVERED_CARGO_SEARCH
    importing
      !INPUT type ZCARGO_GET_UNDELIVERED_CARGO_2
    exporting
      !OUTPUT type ZCARGO_GET_UNDELIVERED_CARGO_1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_UNIT
    importing
      !INPUT type ZCARGO_GET_UNIT_SOAP_IN
    exporting
      !OUTPUT type ZCARGO_GET_UNIT_SOAP_OUT
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_UNIT_ADDRESS
    importing
      !INPUT type ZCARGO_GET_UNIT_ADDRESS_SOAP_I
    exporting
      !OUTPUT type ZCARGO_GET_UNIT_ADDRESS_SOAP_1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_UNIT_BRANCH
    importing
      !INPUT type ZCARGO_GET_UNIT_BRANCH_SOAP_IN
    exporting
      !OUTPUT type ZCARGO_GET_UNIT_BRANCH_SOAP_O1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_UNIT_CARD
    importing
      !INPUT type ZCARGO_GET_UNIT_CARD_SOAP_IN
    exporting
      !OUTPUT type ZCARGO_GET_UNIT_CARD_SOAP_OUT1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_WAITING_CARGO_LIST
    importing
      !INPUT type ZCARGO_GET_WAITING_CARGO_LIST2
    exporting
      !OUTPUT type ZCARGO_GET_WAITING_CARGO_LIST1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods SAVE_ADDRESS
    importing
      !INPUT type ZCARGO_SAVE_ADDRESS_SOAP_IN
    exporting
      !OUTPUT type ZCARGO_SAVE_ADDRESS_SOAP_OUT
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods SET_ADDRESS
    importing
      !INPUT type ZCARGO_SET_ADDRESS_SOAP_IN
    exporting
      !OUTPUT type ZCARGO_SET_ADDRESS_SOAP_OUT
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods SET_CANCELED_SHIPMENT
    importing
      !INPUT type ZCARGO_SET_CANCELED_SHIPMENT_1
    exporting
      !OUTPUT type ZCARGO_SET_CANCELED_SHIPMENT_S
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods SET_CARGO_LINE_INFO
    importing
      !INPUT type ZCARGO_SET_CARGO_LINE_INFO_SO1
    exporting
      !OUTPUT type ZCARGO_SET_CARGO_LINE_INFO_SOA
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods SET_DISPATCH
    importing
      !INPUT type ZCARGO_SET_DISPATCH_SOAP_IN
    exporting
      !OUTPUT type ZCARGO_SET_DISPATCH_SOAP_OUT
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods SET_DISPATCH_XML
    importing
      !INPUT type ZCARGO_SET_DISPATCH_XMLSOAP_IN
    exporting
      !OUTPUT type ZCARGO_SET_DISPATCH_XMLSOAP_OU
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods SET_MEASUREMENT_SIMULATION
    importing
      !INPUT type ZCARGO_SET_MEASUREMENT_SIMULA1
    exporting
      !OUTPUT type ZCARGO_SET_MEASUREMENT_SIMULAT
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods SET_ORDER
    importing
      !INPUT type ZCARGO_SET_ORDER_SOAP_IN
    exporting
      !OUTPUT type ZCARGO_SET_ORDER_SOAP_OUT
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods SET_ORDER_PIECE
    importing
      !INPUT type ZCARGO_SET_ORDER_PIECE_SOAP_IN
    exporting
      !OUTPUT type ZCARGO_SET_ORDER_PIECE_SOAP_OU
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods SET_SORTED_BAG
    importing
      !INPUT type ZCARGO_SET_SORTED_BAG_SOAP_IN
    exporting
      !OUTPUT type ZCARGO_SET_SORTED_BAG_SOAP_OUT
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods SET_SORTED_BAG2
    importing
      !INPUT type ZCARGO_SET_SORTED_BAG2SOAP_IN
    exporting
      !OUTPUT type ZCARGO_SET_SORTED_BAG2SOAP_OUT
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods SET_SORTED_BAG3
    importing
      !INPUT type ZCARGO_SET_SORTED_BAG3SOAP_IN1
    exporting
      !OUTPUT type ZCARGO_SET_SORTED_BAG3SOAP_OUT
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods UPDATE_INVOICE_WAYBILL_NUMBER
    importing
      !INPUT type ZCARGO_UPDATE_INVOICE_WAYBILL1
    exporting
      !OUTPUT type ZCARGO_UPDATE_INVOICE_WAYBILL
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods UPDATE_ORDER_PIECES_VOLUME
    importing
      !INPUT type ZCARGO_UPDATE_ORDER_PIECES_VO1
    exporting
      !OUTPUT type ZCARGO_UPDATE_ORDER_PIECES_VOL
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_PARENT_UNIT_ADDRESS
    importing
      !INPUT type ZCARGO_GET_PARENT_UNIT_ADDRES2
    exporting
      !OUTPUT type ZCARGO_GET_PARENT_UNIT_ADDRES1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods CANCEL_CARGO_LINE_INFO
    importing
      !INPUT type ZCARGO_CANCEL_CARGO_LINE_INFO1
    exporting
      !OUTPUT type ZCARGO_CANCEL_CARGO_LINE_INFO
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods CANCEL_DISPATCH
    importing
      !INPUT type ZCARGO_CANCEL_DISPATCH_SOAP_IN
    exporting
      !OUTPUT type ZCARGO_CANCEL_DISPATCH_SOAP_OU
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods CONSTRUCTOR
    importing
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    raising
      CX_AI_SYSTEM_FAULT .
  methods GET_ADDRESS_LIST
    importing
      !INPUT type ZCARGO_GET_ADDRESS_LIST_SOAP_I
    exporting
      !OUTPUT type ZCARGO_GET_ADDRESS_LIST_SOAP_O
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_BACK_LIST
    importing
      !INPUT type ZCARGO_GET_BACK_LIST_SOAP_IN
    exporting
      !OUTPUT type ZCARGO_GET_BACK_LIST_SOAP_OUT1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_BARCODE
    importing
      !INPUT type ZCARGO_GET_BARCODE_SOAP_IN
    exporting
      !OUTPUT type ZCARGO_GET_BARCODE_SOAP_OUT
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_CANCEL_NEW_DOC
    importing
      !INPUT type ZCARGO_GET_CANCEL_NEW_DOC_SOA1
    exporting
      !OUTPUT type ZCARGO_GET_CANCEL_NEW_DOC_SOAP
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_CARGO_INFO
    importing
      !INPUT type ZCARGO_GET_CARGO_INFO_SOAP_IN
    exporting
      !OUTPUT type ZCARGO_GET_CARGO_INFO_SOAP_OU1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_CARGO_PIECE_LIST
    importing
      !INPUT type ZCARGO_GET_CARGO_PIECE_LIST_S2
    exporting
      !OUTPUT type ZCARGO_GET_CARGO_PIECE_LIST_S1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_CARGO_RETURN
    importing
      !INPUT type ZCARGO_GET_CARGO_RETURN_SOAP_I
    exporting
      !OUTPUT type ZCARGO_GET_CARGO_RETURN_SOAP_1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_CARGO_SEARCH
    importing
      !INPUT type ZCARGO_GET_CARGO_SEARCH_SOAP_I
    exporting
      !OUTPUT type ZCARGO_GET_CARGO_SEARCH_SOAP_1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_CARGO_SEARCH_BY_CODE
    importing
      !INPUT type ZCARGO_GET_CARGO_SEARCH_BY_CO2
    exporting
      !OUTPUT type ZCARGO_GET_CARGO_SEARCH_BY_CO1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_CARGO_SEND_LIST
    importing
      !INPUT type ZCARGO_GET_CARGO_SEND_LIST_SO2
    exporting
      !OUTPUT type ZCARGO_GET_CARGO_SEND_LIST_SO1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_CARGO_TRANSACTION
    importing
      !INPUT type ZCARGO_GET_CARGO_TRANSACTION_4
    exporting
      !OUTPUT type ZCARGO_GET_CARGO_TRANSACTION_3
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_CARGO_TRANSACTION_BY_WAYBI
    importing
      !INPUT type ZCARGO_GET_CARGO_TRANSACTION_2
    exporting
      !OUTPUT type ZCARGO_GET_CARGO_TRANSACTION_1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_CITY_LIST
    importing
      !INPUT type ZCARGO_GET_CITY_LIST_SOAP_IN
    exporting
      !OUTPUT type ZCARGO_GET_CITY_LIST_SOAP_OUT1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_DELIVERY_INFO
    importing
      !INPUT type ZCARGO_GET_DELIVERY_INFO_SOAP1
    exporting
      !OUTPUT type ZCARGO_GET_DELIVERY_INFO_SOAP
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_DELIVERY_INFODOC_ID
    importing
      !INPUT type ZCARGO_GET_DELIVERY_INFODOC_I1
    exporting
      !OUTPUT type ZCARGO_GET_DELIVERY_INFODOC_ID
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_DELIVERY_LIST
    importing
      !INPUT type ZCARGO_GET_DELIVERY_LIST_SOAP2
    exporting
      !OUTPUT type ZCARGO_GET_DELIVERY_LIST_SOAP1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_DELIVERY_LIST2
    importing
      !INPUT type ZCARGO_GET_DELIVERY_LIST2SOAP2
    exporting
      !OUTPUT type ZCARGO_GET_DELIVERY_LIST2SOAP1
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_DISPATCH
    importing
      !INPUT type ZCARGO_GET_DISPATCH_SOAP_IN
    exporting
      !OUTPUT type ZCARGO_GET_DISPATCH_SOAP_OUT
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_DISPATCH_WITH_INTEGRATION
    importing
      !INPUT type ZCARGO_GET_DISPATCH_WITH_INTE1
    exporting
      !OUTPUT type ZCARGO_GET_DISPATCH_WITH_INTEG
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_DURATION
    importing
      !INPUT type ZCARGO_GET_DURATION_SOAP_IN
    exporting
      !OUTPUT type ZCARGO_GET_DURATION_SOAP_OUT
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_INCOMING_CARGO_INFO_BARCOD
    importing
      !INPUT type ZCARGO_GET_INCOMING_CARGO_INF1
    exporting
      !OUTPUT type ZCARGO_GET_INCOMING_CARGO_INFO
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_MISSING_NEW_DOC
    importing
      !INPUT type ZCARGO_GET_MISSING_NEW_DOC_SO1
    exporting
      !OUTPUT type ZCARGO_GET_MISSING_NEW_DOC_SOA
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_ORDER
    importing
      !INPUT type ZCARGO_GET_ORDER_SOAP_IN
    exporting
      !OUTPUT type ZCARGO_GET_ORDER_SOAP_OUT
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
  methods GET_ORDER_WITH_INTEGRATION_COD
    importing
      !INPUT type ZCARGO_GET_ORDER_WITH_INTEGRA1
    exporting
      !OUTPUT type ZCARGO_GET_ORDER_WITH_INTEGRAT
    raising
      CX_AI_SYSTEM_FAULT
      CX_AI_APPLICATION_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZARASCG_CO_SERVICE_SOAP IMPLEMENTATION.


method CANCEL_CARGO_LINE_INFO.

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
      method_name = 'CANCEL_CARGO_LINE_INFO'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method CANCEL_DISPATCH.

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
      method_name = 'CANCEL_DISPATCH'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZARASCG_CO_SERVICE_SOAP'
    logical_port_name   = logical_port_name
  ).

endmethod.


method GET_ADDRESS_LIST.

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
      method_name = 'GET_ADDRESS_LIST'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_BACK_LIST.

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
      method_name = 'GET_BACK_LIST'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_BARCODE.

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
      method_name = 'GET_BARCODE'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_CANCEL_NEW_DOC.

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
      method_name = 'GET_CANCEL_NEW_DOC'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_CARGO_INFO.

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
      method_name = 'GET_CARGO_INFO'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_CARGO_PIECE_LIST.

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
      method_name = 'GET_CARGO_PIECE_LIST'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_CARGO_RETURN.

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
      method_name = 'GET_CARGO_RETURN'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_CARGO_SEARCH.

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
      method_name = 'GET_CARGO_SEARCH'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_CARGO_SEARCH_BY_CODE.

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
      method_name = 'GET_CARGO_SEARCH_BY_CODE'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_CARGO_SEND_LIST.

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
      method_name = 'GET_CARGO_SEND_LIST'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_CARGO_TRANSACTION.

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
      method_name = 'GET_CARGO_TRANSACTION'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_CARGO_TRANSACTION_BY_WAYBI.

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
      method_name = 'GET_CARGO_TRANSACTION_BY_WAYBI'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_CITY_LIST.

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
      method_name = 'GET_CITY_LIST'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_DELIVERY_INFO.

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
      method_name = 'GET_DELIVERY_INFO'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_DELIVERY_INFODOC_ID.

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
      method_name = 'GET_DELIVERY_INFODOC_ID'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_DELIVERY_LIST.

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
      method_name = 'GET_DELIVERY_LIST'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_DELIVERY_LIST2.

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
      method_name = 'GET_DELIVERY_LIST2'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_DISPATCH.

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
      method_name = 'GET_DISPATCH'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_DISPATCH_WITH_INTEGRATION.

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
      method_name = 'GET_DISPATCH_WITH_INTEGRATION'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_DURATION.

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
      method_name = 'GET_DURATION'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_INCOMING_CARGO_INFO_BARCOD.

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
      method_name = 'GET_INCOMING_CARGO_INFO_BARCOD'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_MISSING_NEW_DOC.

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
      method_name = 'GET_MISSING_NEW_DOC'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_ORDER.

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
      method_name = 'GET_ORDER'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_ORDER_WITH_INTEGRATION_COD.

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
      method_name = 'GET_ORDER_WITH_INTEGRATION_COD'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_PARENT_UNIT_ADDRESS.

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
      method_name = 'GET_PARENT_UNIT_ADDRESS'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_PRICE_CALCULATION.

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
      method_name = 'GET_PRICE_CALCULATION'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_REDIRECTION_LIST.

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
      method_name = 'GET_REDIRECTION_LIST'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_REGIONS.

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
      method_name = 'GET_REGIONS'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_SERVICE_LIST.

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
      method_name = 'GET_SERVICE_LIST'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_SERVICE_TYPE.

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
      method_name = 'GET_SERVICE_TYPE'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_SORTED_CARGO_INFO.

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
      method_name = 'GET_SORTED_CARGO_INFO'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_TOWN.

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
      method_name = 'GET_TOWN'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_UNDELIVERED_CARGO_SEARCH.

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
      method_name = 'GET_UNDELIVERED_CARGO_SEARCH'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_UNIT.

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
      method_name = 'GET_UNIT'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_UNIT_ADDRESS.

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
      method_name = 'GET_UNIT_ADDRESS'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_UNIT_BRANCH.

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
      method_name = 'GET_UNIT_BRANCH'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_UNIT_CARD.

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
      method_name = 'GET_UNIT_CARD'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method GET_WAITING_CARGO_LIST.

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
      method_name = 'GET_WAITING_CARGO_LIST'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method SAVE_ADDRESS.

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
      method_name = 'SAVE_ADDRESS'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method SET_ADDRESS.

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
      method_name = 'SET_ADDRESS'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method SET_CANCELED_SHIPMENT.

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
      method_name = 'SET_CANCELED_SHIPMENT'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method SET_CARGO_LINE_INFO.

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
      method_name = 'SET_CARGO_LINE_INFO'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method SET_DISPATCH.

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
      method_name = 'SET_DISPATCH'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method SET_DISPATCH_XML.

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
      method_name = 'SET_DISPATCH_XML'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method SET_MEASUREMENT_SIMULATION.

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
      method_name = 'SET_MEASUREMENT_SIMULATION'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method SET_ORDER.

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
      method_name = 'SET_ORDER'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method SET_ORDER_PIECE.

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
      method_name = 'SET_ORDER_PIECE'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method SET_SORTED_BAG.

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
      method_name = 'SET_SORTED_BAG'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method SET_SORTED_BAG2.

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
      method_name = 'SET_SORTED_BAG2'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method SET_SORTED_BAG3.

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
      method_name = 'SET_SORTED_BAG3'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method UPDATE_INVOICE_WAYBILL_NUMBER.

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
      method_name = 'UPDATE_INVOICE_WAYBILL_NUMBER'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.


method UPDATE_ORDER_PIECES_VOLUME.

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
      method_name = 'UPDATE_ORDER_PIECES_VOLUME'
    changing
      parmbind_tab = lt_parmbind
  ).

endmethod.
ENDCLASS.
