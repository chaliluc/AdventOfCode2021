*&---------------------------------------------------------------------*
*& Report ZLC_ADVENT21_DAY7
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlc_advent21_day7.

class yc_day7 definition inheriting from zcl_lc_adv2021.
  public section.
    methods build_position_table importing it_input type yt_string_table.
    methods calculate_fuel returning value(r_fuel) type i.
    methods calculate_incremental_fuel returning value(r_fuel) type i.

  private section.
    data pt_position type standard table of i.
    data p_smallest type i.
    data p_largest type i.
    data p_steps type i.

endclass.


*&---------------------------------------------------------------------*
data l_input_filename type string.
data lr_day7 type ref to yc_day7.
data lt_input type yc_day7=>yt_string_table.
data l_total_fuel type int8.

create object lr_day7.
l_input_filename = lr_day7->get_input_filename( ).
check l_input_filename <> space.

check lr_day7->import_data( exporting i_filename = l_input_filename importing et_data = lt_input ) = 0.
check lines( lt_input ) > 0.

lr_day7->build_position_table( lt_input ).
l_total_fuel = lr_day7->calculate_fuel( ).
write: / 'Most efficient position takes', l_total_fuel.

l_total_fuel = lr_day7->calculate_incremental_fuel( ).
write: / 'Most efficient position takes', l_total_fuel.
*&---------------------------------------------------------------------*


class yc_day7 implementation.
  method build_position_table.
    data l_input type string.
    data lt_data type yt_string_table.
    loop at it_input into l_input.
      split l_input at ',' into table lt_data.
      append lines of lt_data to pt_position.
    endloop.
    sort pt_position.
    read table pt_position into p_smallest index 1.
    read table pt_position into p_largest index lines( pt_position ).
    p_steps = p_largest - p_smallest + 1.
  endmethod.


  method calculate_fuel.
    data l_fuel type i.
    data l_position type i.
    data l_new_position type i.
    data lt_fuel type standard table of i.

    r_fuel = 0.
    do p_steps times.
      l_fuel = 0.
      l_new_position = sy-index - 1.
      loop at pt_position into l_position.
        l_fuel = l_fuel + abs( l_position - sy-index ).
      endloop.
      append l_fuel to lt_fuel.
    enddo.
    sort lt_fuel.
    read table lt_fuel index 1 into r_fuel.
  endmethod.


  method calculate_incremental_fuel.
    data l_fuel type i.
    data l_calculated_fuel type float.
    data l_position type i.
    data l_new_position type i.
    data lt_fuel type standard table of i.

    r_fuel = 0.
    do p_steps times.
      l_fuel = 0.
      l_new_position = sy-index - 1.
      loop at pt_position into l_position.
        l_calculated_fuel = abs( l_position - l_new_position ).
        l_calculated_fuel = ( l_calculated_fuel / 2 ) * ( 1 + l_calculated_fuel ).
        l_fuel = l_fuel + l_calculated_fuel.
      endloop.
      append l_fuel to lt_fuel.
    enddo.
    sort lt_fuel.
    read table lt_fuel index 1 into r_fuel.
  endmethod.

endclass.
