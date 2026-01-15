FUNCTION zjs_flight_travel_create.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IS_TRAVEL) TYPE  ZJS_ST_TRAVEL_IN
*"     REFERENCE(IT_BOOKING) TYPE  ZJS_TT_BOOKING_IN OPTIONAL
*"     REFERENCE(IT_BOOKING_SUPPLEMENT) TYPE
*"        ZJS_TT_BOOKING_SUPPLEMENT_IN OPTIONAL
*"     REFERENCE(IV_NUMBERING_MODE) TYPE
*"        ZJS_IF_FLIGHT_LEGACY=>T_NUMBERING_MODE OPTIONAL
*"  EXPORTING
*"     REFERENCE(ES_TRAVEL) TYPE  ZJS_TRAVEL
*"     REFERENCE(ET_BOOKING) TYPE  ZJS_TT_BOOKING
*"     REFERENCE(ET_BOOKING_SUPPLEMENT) TYPE  ZJS_TT_BOOKING_SUPPLEMENT
*"     REFERENCE(ET_MESSAGES) TYPE  ZJS_TT_MESSAGE
*"----------------------------------------------------------------------
  DATA: lv_numbering_mode TYPE zjs_if_flight_legacy=>t_numbering_mode.
  IF iv_numbering_mode IS INITIAL.
    lv_numbering_mode = zjs_if_flight_legacy=>numbering_mode-early.
  ELSE.
    lv_numbering_mode = iv_numbering_mode.
  ENDIF.

  CLEAR es_travel.
  CLEAR et_booking.
  CLEAR et_booking_supplement.
  CLEAR et_messages.

  zjs_cl_flight_legacy=>get_instance( )->create_travel(  EXPORTING is_travel             = is_travel
                                                                   it_booking            = it_booking
                                                                   it_booking_supplement = it_booking_supplement
                                                                   iv_numbering_mode     = lv_numbering_mode
                                                         IMPORTING es_travel             = es_travel
                                                                   et_booking            = et_booking
                                                                   et_booking_supplement = et_booking_supplement
                                                                   et_messages           = DATA(lt_messages) ).

  zjs_cl_flight_legacy=>get_instance( )->convert_messages( EXPORTING it_messages = lt_messages
                                                            IMPORTING et_messages = et_messages ).
ENDFUNCTION.
