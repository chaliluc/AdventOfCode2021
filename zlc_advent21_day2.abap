*&---------------------------------------------------------------------*
*& Report ZLC_ADVENT21_DAY2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlc_advent21_day2.

class yc_day2 definition inheriting from zcl_lc_adv2021.
  public section.
    methods get_final_position importing it_data           type yt_string_table optional preferred parameter it_data
                               returning value(r_position) type i.
    methods get_final_position_with_aim importing it_data           type yt_string_table optional preferred parameter it_data
                                        returning value(r_position) type i.

endclass.


*&---------------------------------------------------------------------*

data l_input_filename type string.
data l_final_position type p.
data lr_day2 type ref to yc_day2.
data lt_input type yc_day2=>yt_string_table.

create object lr_day2.
l_input_filename = lr_day2->get_input_filename( ).
check l_input_filename <> space.

check lr_day2->import_data( exporting i_filename = l_input_filename importing et_data = lt_input ) = 0.
check lines( lt_input ) > 0.

l_final_position = lr_day2->get_final_position( lt_input ).
write: / 'Final position', l_final_position.

l_final_position = lr_day2->get_final_position_with_aim( lt_input ).
write: / 'Final position with aim', l_final_position .

*&---------------------------------------------------------------------*


class yc_day2 implementation.
  method get_final_position.
    data l_command type string.
    data l_entry type string.
    data l_forward type i.
    data l_depth type i.
    data l_value type string.

    r_position = 0.
    loop at it_data into l_entry.
      split l_entry at space into l_command l_value.
      case l_command.
        when 'forward'.
          l_forward = l_forward + l_value.
        when 'up'.
          l_depth = l_depth - l_value.
        when 'down'.
          l_depth = l_depth + l_value.
        when others.
          "do nothing
      endcase.
    endloop.

    r_position = l_forward * l_depth.
  endmethod.


  method get_final_position_with_aim.
    data l_command type string.
    data l_entry type string.
    data l_forward type i.
    data l_depth type i.
    data l_aim type i.
    data l_value type string.

    r_position = 0.
    loop at it_data into l_entry.
      split l_entry at space into l_command l_value.
      case l_command.
        when 'forward'.
          l_forward = l_forward + l_value.
          l_depth = l_depth + ( l_value * l_aim ).
        when 'up'.
          l_aim = l_aim - l_value.
        when 'down'.
          l_aim = l_aim + l_value.
        when others.
          "do nothing
      endcase.
    endloop.

    r_position = l_forward * l_depth.
  endmethod.

endclass.
