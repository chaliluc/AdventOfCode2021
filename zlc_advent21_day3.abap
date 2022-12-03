*&---------------------------------------------------------------------*
*& Report ZLC_ADVENT21_DAY3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlc_advent21_day3.

class yc_day3 definition inheriting from zcl_lc_adv2021.
  public section.

    methods get_power importing it_data        type yt_string_table optional
                                  preferred parameter it_data
                      returning value(r_power) type int8.
    methods get_life_support_rating importing it_data         type yt_string_table optional
                                                preferred parameter it_data
                                    returning value(r_rating) type int8.

  private section.
    methods get_gamma_rate importing it_data             type yt_string_table optional
                                       preferred parameter it_data
                           returning value(r_gamma_rate) type string.
    methods get_epsilon_rate importing it_data               type yt_string_table optional
                                         preferred parameter it_data
                             returning value(r_epsilon_rate) type string.
    methods get_binary_number importing it_data         type yt_string_table
                                        i_most_common   type abap_bool
                              returning value(r_number) type string.
    methods get_oxygen_generator_rating importing it_data                type yt_string_table optional
                                                    preferred parameter it_data
                                        returning value(r_oxygen_rating) type string.
    methods get_co2_scrubber_rating importing it_data             type yt_string_table optional
                                                preferred parameter it_data
                                    returning value(r_co2_rating) type string.
    methods get_filtered_number importing it_data         type yt_string_table
                                          i_most_common   type abap_bool
                                returning value(r_number) type string.

endclass.


*&---------------------------------------------------------------------*

data l_power type p.
data l_input_filename type string.
data l_life_support_rating type p.
data lr_day3 type ref to yc_day3.
data lt_input type yc_day3=>yt_string_table.

create object lr_day3.
l_input_filename = lr_day3->get_input_filename( ).
check l_input_filename <> space.

check lr_day3->import_data( exporting i_filename = l_input_filename importing et_data = lt_input ) = 0.
check lines( lt_input ) > 0.

l_power = lr_day3->get_power( lt_input ).
write: / 'Power consumption', l_power.

l_life_support_rating = lr_day3->get_life_support_rating( lt_input ).
write: / 'Life support rating', l_life_support_rating .

*&---------------------------------------------------------------------*


class yc_day3 implementation.
  method get_power.
    data l_gamma_rate_2 type string.
    data l_gamma_rate_10 type string.
    data l_epsilon_rate_2 type string.
    data l_epsilon_rate_10 type string.

    clear r_power.
    l_gamma_rate_2 = get_gamma_rate( it_data ).
    l_epsilon_rate_2 = get_epsilon_rate( it_data ).

    l_gamma_rate_10 = /ui2/cl_number=>base_converter( number = l_gamma_rate_2 from = 2 to = 10 ).
    l_epsilon_rate_10 = /ui2/cl_number=>base_converter( number = l_epsilon_rate_2 from = 2 to = 10 ).

    r_power = l_gamma_rate_10 * l_epsilon_rate_10.
  endmethod.


  method get_life_support_rating.
    data l_oxygen_rating_2 type string.
    data l_oxygen_rating_10 type string.
    data l_co2_rating_2 type string.
    data l_co2_rating_10 type string.

    clear r_rating.
    l_oxygen_rating_2 = get_oxygen_generator_rating( it_data ).
    l_co2_rating_2 = get_co2_scrubber_rating( it_data ).

    l_oxygen_rating_10 = /ui2/cl_number=>base_converter( number = l_oxygen_rating_2 from = 2 to = 10 ).
    l_co2_rating_10 = /ui2/cl_number=>base_converter( number = l_co2_rating_2 from = 2 to = 10 ).

    r_rating = l_oxygen_rating_10 * l_co2_rating_10.
  endmethod.


  method get_gamma_rate.
    r_gamma_rate = get_binary_number( it_data = it_data i_most_common = abap_true ).
  endmethod.


  method get_epsilon_rate.
    r_epsilon_rate = get_binary_number( it_data = it_data i_most_common = abap_false ).
  endmethod.


  method get_oxygen_generator_rating.
    r_oxygen_rating = get_filtered_number( it_data = it_data i_most_common = abap_true ).
  endmethod.


  method get_co2_scrubber_rating.
    r_co2_rating = get_filtered_number( it_data = it_data i_most_common = abap_false ).
  endmethod.


  method get_binary_number.
    data l_bits type i.
    data l_data type string.
    data l_one type i.
    data l_zero type i.
    data l_position type i.

    clear r_number.
    read table it_data index 1 into l_data.
    l_bits = strlen( l_data ).
    do l_bits times.
      l_one = l_zero = 0.
      loop at it_data into l_data.
        l_position = sy-index - 1.
        if l_data+l_position(1) = '1'.
          l_one = l_one + 1.
        else.
          l_zero = l_zero + 1.
        endif.
      endloop.
      if i_most_common = abap_true.
        r_number = r_number && cond #( when l_zero > l_one then '0' else '1' ).
      else.
        r_number = r_number && cond #( when l_zero > l_one then '1' else '0' ).
      endif.
    enddo.

  endmethod.


  method get_filtered_number.
    data l_bits type i.
    data l_data type string.
    data l_position type i.
    data lt_one type standard table of string.
    data lt_zero type standard table of string.
    data lt_remaining type standard table of string.

    clear r_number.
    read table it_data index 1 into l_data.
    l_bits = strlen( l_data ).
    lt_remaining = it_data.
    do l_bits times.
      clear lt_one.
      clear lt_zero.
      loop at lt_remaining into l_data.
        l_position = sy-index - 1.
        if l_data+l_position(1) = '1'.
          append l_data to lt_one.
        else.
          append l_data to lt_zero.
        endif.
      endloop.
      if i_most_common = abap_true.
        if lines( lt_one ) >= lines( lt_zero ).
          lt_remaining = lt_one.
        else.
          lt_remaining = lt_zero.
        endif.
      else.
        if lines( lt_zero ) <= lines( lt_one ).
          lt_remaining = lt_zero.
        else.
          lt_remaining = lt_one.
        endif.
      endif.
      if lines( lt_remaining ) = 1.
        exit.
      endif.
    enddo.
    read table lt_remaining into r_number index 1.

  endmethod.
endclass.
