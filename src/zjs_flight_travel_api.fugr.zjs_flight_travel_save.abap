"! API for Saving the Transactional Buffer of the Travel API
"!
FUNCTION zjs_flight_travel_save.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"----------------------------------------------------------------------
  zjs_cl_flight_legacy=>get_instance( )->save( ).
ENDFUNCTION.
