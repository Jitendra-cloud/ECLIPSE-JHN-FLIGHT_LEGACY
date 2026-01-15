FUNCTION ZJS_FLIGHT_TRAVEL_CALC_PRICE.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_FLIGHT) TYPE  ZJS_TT_FLIGHT OPTIONAL
*"----------------------------------------------------------------------

  TYPES BEGIN OF ty_seats_occupied.
  INCLUDE TYPE zjs_flight.
  TYPES   distance       TYPE zjs_connection-distance.
  TYPES   distance_unit  TYPE zjs_connection-distance_unit.
  TYPES END OF ty_seats_occupied.

  TYPES: tt_flight TYPE STANDARD TABLE OF zjs_flight WITH KEY client carrier_id connection_id flight_date.

  DATA: lt_seats_occupied          TYPE TABLE OF ty_seats_occupied.

  IF it_flight IS SUPPLIED.
    SELECT FROM zjs_booking AS booking
      JOIN     zjs_connection AS connection
                 ON  booking~carrier_id    = connection~carrier_id
                 AND booking~connection_id = connection~connection_id
      JOIN     zjs_flight AS flight
                 ON  booking~carrier_id    = flight~carrier_id
                 AND booking~connection_id = flight~connection_id
                 AND booking~flight_date   = flight~flight_date
      JOIN     @it_flight AS t
                 ON  booking~carrier_id    = t~carrier_id
                 AND booking~connection_id = t~connection_id
      FIELDS   booking~carrier_id, booking~connection_id, booking~flight_date, COUNT(*) AS seats_occupied,
               connection~distance, connection~distance_unit,
               flight~currency_code, flight~plane_type_id, flight~seats_max, flight~seats_occupied
      GROUP BY booking~carrier_id, booking~connection_id, booking~flight_date,
               connection~distance, connection~distance_unit,
               flight~currency_code, flight~plane_type_id, flight~seats_max, flight~seats_occupied
      INTO CORRESPONDING FIELDS OF TABLE @lt_seats_occupied.
  ELSE.
    SELECT FROM zjs_booking AS booking
      JOIN     zjs_connection AS connection
                 ON  booking~carrier_id    = connection~carrier_id
                 AND booking~connection_id = connection~connection_id
      JOIN     zjs_flight AS flight
                 ON  booking~carrier_id    = flight~carrier_id
                 AND booking~connection_id = flight~connection_id
                 AND booking~flight_date   = flight~flight_date
      FIELDS   booking~carrier_id, booking~connection_id, booking~flight_date, COUNT(*) AS seats_occupied,
               connection~distance, connection~distance_unit,
               flight~currency_code, flight~plane_type_id, flight~seats_max, flight~seats_occupied
      GROUP BY booking~carrier_id, booking~connection_id, booking~flight_date,
               connection~distance, connection~distance_unit,
               flight~currency_code, flight~plane_type_id, flight~seats_max, flight~seats_occupied
      INTO CORRESPONDING FIELDS OF TABLE @lt_seats_occupied.
  ENDIF.

  LOOP AT lt_seats_occupied ASSIGNING FIELD-SYMBOL(<seats_occupied>).
    <seats_occupied>-price = ( ( 3 * ( <seats_occupied>-seats_occupied * 100 DIV <seats_occupied>-seats_max ) ** 2 DIV 400 ) + 25 ) * <seats_occupied>-distance DIV 100.
  ENDLOOP.

  UPDATE zjs_flight
    FROM TABLE @(
        CORRESPONDING tt_flight(
          lt_seats_occupied MAPPING
            carrier_id     = carrier_id
            connection_id  = connection_id
            flight_date    = flight_date
            price          = price
            currency_code  = currency_code
            plane_type_id  = plane_type_id
            seats_max      = seats_max
            seats_occupied = seats_occupied
          )
      ).

ENDFUNCTION.
