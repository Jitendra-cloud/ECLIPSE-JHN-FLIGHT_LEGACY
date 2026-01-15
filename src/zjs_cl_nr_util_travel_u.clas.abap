CLASS zjs_cl_nr_util_travel_u DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    CONSTANTS c_object    TYPE cl_numberrange_objects=>nr_attributes-object   VALUE 'ZJSNUM_TC'.
    CONSTANTS c_package   TYPE cl_numberrange_objects=>nr_attributes-devclass VALUE 'ZJS_PROJECT_01'.
    CONSTANTS c_transport TYPE cl_numberrange_objects=>nr_attributes-corrnr   VALUE 'TRLK903008'.

    METHODS create_number_range_object
      IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS create_number_range
      IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS read_number_range
      IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS draw_number
      IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.



CLASS ZJS_CL_NR_UTIL_TRAVEL_U IMPLEMENTATION.


  METHOD create_number_range.

    """"""""""""""Checking if Interval availble then not allow to create"""""""""""""""""""""""""""
    TRY.
        cl_numberrange_intervals=>read( EXPORTING object   = 'ZJS_NR1'
                                          nr_range_nr1 = '01'
                                          "nr_range_nr2 =
                                        IMPORTING interval = DATA(lt_interval) ).

      CATCH cx_nr_object_not_found INTO DATA(lo_js_error1).
        io_out->write( lo_js_error1 ).
      CATCH cx_number_ranges INTO DATA(lo_js_error2).
        io_out->write( lo_js_error2 ).
    ENDTRY.
    """"""""""""""Checking if Interval availble then not allow to create"""""""""""""""""""""""""""

    IF lt_interval IS INITIAL.
      TRY.
          cl_numberrange_intervals=>create(
            EXPORTING interval  = VALUE #( ( nrrangenr = '01' fromnumber = '10000000' tonumber = '89999999' procind = 'I' ) )
                      object    = 'ZJS_NR1'
            IMPORTING error     = DATA(ld_error)
                      error_inf = DATA(ls_error)
                      error_iv  = DATA(lt_error_iv)
                      warning   = DATA(ld_warning) ).

        CATCH cx_root INTO DATA(lo_error).
          io_out->write( lo_error->get_text( ) ).
      ENDTRY.
      "io_out->write( ld_error ). io_out->write( ls_error ). io_out->write( lt_error_iv ). io_out->write( ld_warning ).
      io_out->write( `Interval: '01' for NR Object: 'ZJS_NR1' ( Created Successfuly ) ` ).
    ENDIF.

    io_out->write( `Interval: '01' for NR Object: 'ZJS_NR1' ( Allready exist ) ` ).
  ENDMETHOD.


  METHOD create_number_range_object.
    TRY.
        cl_numberrange_objects=>create( EXPORTING attributes = VALUE #( object     = c_object
                                                                        domlen     = 'ZJS_DO_TLR_ID'
                                                                        percentage = 10
                                                                        devclass   = c_package
                                                                        corrnr     = c_transport )
                                                  obj_text   = VALUE #( langu    = 'E'
                                                                        object   = c_object
                                                                        txtshort = 'Timing Letter No.'
                                                                        txt      = 'Create Timing Letter Number' )
                                        IMPORTING errors     = DATA(lt_errors)
                                                  returncode = DATA(ld_return) ).
      CATCH cx_number_ranges INTO DATA(lo_error).
        io_out->write( lo_error->get_text( ) ).
    ENDTRY.

    io_out->write( lt_errors ).
    io_out->write( ld_return ).
  ENDMETHOD.


  METHOD draw_number.
    TRY.
        cl_numberrange_runtime=>number_get( EXPORTING nr_range_nr = 'T2'
                                                      object      = c_object
                                            IMPORTING number      = DATA(ld_number)
                                                      returncode  = DATA(ld_rcode) ).

      CATCH cx_root INTO DATA(lo_error).
        io_out->write( lo_error->get_text( ) ).
    ENDTRY.

    io_out->write( ld_number ).
    io_out->write( ld_rcode ).
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
*    create_number_range_object( out ).
    create_number_range( out ).
*    read_number_range( out ).
*    draw_number( out ).
  ENDMETHOD.


  METHOD read_number_range.
    TRY.
        cl_numberrange_intervals=>read(
          EXPORTING
*            nr_range_nr1 =
*            nr_range_nr2 =
            object       = '/DMO/TRAVL'
*            subobject    =
          IMPORTING
            interval     = DATA(lt_interval) ).

      CATCH cx_nr_object_not_found INTO DATA(lo_js_error1).
        io_out->write( lo_js_error1 ).
      CATCH cx_number_ranges INTO DATA(lo_js_error2).
        io_out->write( lo_js_error2 ).
    ENDTRY.
    io_out->write( lt_interval ).
  ENDMETHOD.
ENDCLASS.
