FUNCTION ZJS_FLIGHT_TRAVEL_ADJ_NUMBERS.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(ET_TRAVEL_MAPPING) TYPE
*"        ZJS_IF_FLIGHT_LEGACY=>TT_LN_TRAVEL_MAPPING
*"     REFERENCE(ET_BOOKING_MAPPING) TYPE
*"        ZJS_IF_FLIGHT_LEGACY=>TT_LN_BOOKING_MAPPING
*"     REFERENCE(ET_BOOKINGSUPPL_MAPPING) TYPE
*"        ZJS_IF_FLIGHT_LEGACY=>TT_LN_BOOKINGSUPPL_MAPPING
*"----------------------------------------------------------------------
  zjs_cl_flight_legacy=>get_instance( )->adjust_numbers(
    IMPORTING
      et_travel_mapping       = et_travel_mapping
      et_booking_mapping      = et_booking_mapping
      et_bookingsuppl_mapping = et_bookingsuppl_mapping ).


ENDFUNCTION.
