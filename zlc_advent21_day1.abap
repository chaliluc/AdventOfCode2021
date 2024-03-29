*&---------------------------------------------------------------------*
*& Report ZLC_ADVENT21_DAY1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlc_advent21_day1.

class yc_day1 definition inheriting from zcl_lc_adv2021.
  public section.
    methods get_number_of_increase importing it_data           type yt_string_table optional preferred parameter it_data
                                   returning value(r_increase) type i.
    methods get_number_of_agr_increase importing it_data           type yt_string_table optional preferred parameter it_data
                                       returning value(r_increase) type i.

endclass.


*&---------------------------------------------------------------------*
data l_increase type i.
data l_input_filename type string.
data lr_day1 type ref to yc_day1.
data lt_input type yc_day1=>yt_string_table.

create object lr_day1.
l_input_filename = lr_day1->get_input_filename( ).
check l_input_filename <> space.

check lr_day1->import_data( exporting i_filename = l_input_filename importing et_data = lt_input ) = 0.
check lines( lt_input ) > 0.

l_increase = lr_day1->get_number_of_increase( lt_input ).
write: / 'Number of single increases', l_increase.

l_increase = lr_day1->get_number_of_agr_increase( lt_input ).
write: / 'Number of aggregated increases', l_increase.

*&---------------------------------------------------------------------*


class yc_day1 implementation.
  method get_number_of_increase.
    data l_new_val type i.
    data l_old_val type i.

    r_increase = 0.
    read table it_data index 1 into l_old_val.
    loop at it_data into l_new_val.
      if l_new_val > l_old_val.
        r_increase = r_increase + 1.
      endif.
      l_old_val = l_new_val.
    endloop.

  endmethod.

  method get_number_of_agr_increase.
    data l_value type i.
    data l_agr_value type i.
    data l_tabix type i.
    data lt_agr_data type yt_string_table.

    loop at it_data into l_value from 1 to lines( it_data ) - 2.
      l_tabix = sy-tabix.
      l_agr_value = l_value.
      read table it_data index l_tabix + 1 into l_value.
      l_agr_value = l_agr_value + l_value.
      read table it_data index l_tabix + 2 into l_value.
      l_agr_value = l_agr_value + l_value.
      append l_agr_value to lt_agr_data.
    endloop.

    r_increase = get_number_of_increase( lt_agr_data ).

  endmethod.

endclass.
