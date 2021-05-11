CLASS zcl_btp_ml_predict_consumption DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !is_data TYPE zbtp_ml_srv_consumption_req . "your data request-structure to predict consumption-data
    METHODS get_consumption
      RETURNING
        VALUE(result) TYPE int4 .
  PROTECTED SECTION.

    DATA ms_request_data TYPE zbtp_ml_srv_consumption_req . "your data request-structure to predict consumption-data
    DATA mr_ml_service_request TYPE REF TO if_http_client .

    METHODS prepare_request .
  PRIVATE SECTION.

    TYPES:
      BEGIN OF l_json_result_intern,
        results TYPE int4,
      END OF l_json_result_intern .
    TYPES:
      BEGIN OF l_json_result,
        results TYPE l_json_result_intern,
      END OF l_json_result .

    DATA mc_btp_ml_destination TYPE rfcdest VALUE '<YOUR_DESTINATION>' ##NO_TEXT.
    DATA mv_response_code TYPE i .
ENDCLASS.



CLASS ZCL_BTP_ML_PREDICT_CONSUMPTION IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BTP_ML_PREDICT_CONSUMPTION->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_DATA                        TYPE        ZBTP_ML_SRV_CONSUMPTION_REQ
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.

    ms_request_data = is_data.

    cl_http_client=>create_by_destination(
      EXPORTING
        destination              = mc_btp_ml_destination
      IMPORTING
        client                   = mr_ml_service_request ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BTP_ML_PREDICT_CONSUMPTION->GET_CONSUMPTION
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RESULT                         TYPE        INT4
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_consumption.

    DATA ls_json_result TYPE l_json_result.

    prepare_request( ).
    mr_ml_service_request->send( ).
    mr_ml_service_request->receive( ).

    DATA(lv_json_response) = mr_ml_service_request->response->get_cdata( ).

    IF  lv_json_response IS NOT INITIAL.
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response CHANGING data = ls_json_result ).
    ELSE.
      mr_ml_service_request->response->get_status( IMPORTING code = mv_response_code ).
    ENDIF.

    result = ls_json_result-results-results.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_BTP_ML_PREDICT_CONSUMPTION->PREPARE_REQUEST
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD prepare_request.

    CONSTANTS c_post_method     TYPE string VALUE 'POST'.
    CONSTANTS c_appl_type_json  TYPE string VALUE 'application/json'.


    DATA(lv_json_request) = /ui2/cl_json=>serialize( ms_request_data ).
    mr_ml_service_request->request->set_method( c_post_method ).
    mr_ml_service_request->request->set_cdata( data = lv_json_request length = strlen( lv_json_request ) ).
    mr_ml_service_request->request->set_content_type( c_appl_type_json ).

  ENDMETHOD.
ENDCLASS.