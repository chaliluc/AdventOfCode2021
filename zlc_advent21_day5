*&---------------------------------------------------------------------*
*& Report ZLC_ADVENT21_DAY5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlc_advent21_day5.

class yc_day5 definition inheriting from zcl_lc_adv2021.
  public section.
    types:
      begin of ys_line,
        x1 type i,
        y1 type i,
        x2 type i,
        y2 type i,
        hv type char1,
      end of ys_line.
    types yt_line type standard table of ys_line.
    methods build_lines_table importing it_data type yt_string_table optional preferred parameter it_data.
    methods build_matrix importing i_hv_only type abap_bool default abap_true preferred parameter i_hv_only.
    methods get_dangerous_points returning value(r_dangerous_points) type i.
    methods reset_matrix.

  private section.
    data pt_lines type yt_line.
    data p_max_x type i.
    data p_max_y type i.
    data pt_matrix type yt_string_table.
    methods get_number importing i_data          type string
                                 i_number        type i
                       returning value(r_number) type i.
    methods get_hv importing is_line     type ys_line optional
                               preferred parameter is_line
                   returning value(r_hv) type char1.
    methods update_matrix_h importing is_line type ys_line optional preferred parameter is_line.
    methods update_matrix_v importing is_line type ys_line optional preferred parameter is_line.
    methods update_matrix_x importing is_line type ys_line optional preferred parameter is_line.

endclass.


*&---------------------------------------------------------------------*
data l_input_filename type string.
data lr_day5 type ref to yc_day5.
data lt_input type yc_day5=>yt_string_table.
data l_dangerous_points type i.

create object lr_day5.
l_input_filename = lr_day5->get_input_filename( ).
check l_input_filename <> space.

check lr_day5->import_data( exporting i_filename = l_input_filename importing et_data = lt_input ) = 0.
check lines( lt_input ) > 0.

lr_day5->build_lines_table( lt_input ).
lr_day5->build_matrix( ).
l_dangerous_points = lr_day5->get_dangerous_points( ).
write: / 'Dangerous points for HV matrix', l_dangerous_points.

lr_day5->reset_matrix( ).
lr_day5->build_matrix( i_hv_only = abap_false ).
l_dangerous_points = lr_day5->get_dangerous_points( ).
write: / 'Dangerous points XHV matrix', l_dangerous_points.
*&---------------------------------------------------------------------*


class yc_day5 implementation.
  method build_lines_table.
    data l_data type string.
    data ls_line type ys_line.

    loop at it_data into l_data.
      ls_line-x1 = get_number( i_data = l_data i_number = 1 ).
      ls_line-y1 = get_number( i_data = l_data i_number = 2 ).
      ls_line-x2 = get_number( i_data = l_data i_number = 3 ).
      ls_line-y2 = get_number( i_data = l_data i_number = 4 ).
      ls_line-hv = get_hv( ls_line ).
      append ls_line to pt_lines.
      p_max_x = nmax( val1 = p_max_x val2 = ls_line-x1 val3 = ls_line-x2 ).
      p_max_y = nmax( val1 = p_max_y val2 = ls_line-y1 val3 = ls_line-y2 ).
    endloop.
  endmethod.


  method get_number.
    data l_value type string.
    case i_number.
      when 1.
        find first occurrence of regex '(\d*)(?>,\d* -> \d*,\d*)' in i_data in character mode submatches l_value.
      when 2.
        find first occurrence of regex '(?>\d*,)(\d*)(?> -> \d*,\d*)' in i_data in character mode submatches l_value.
      when 3.
        find first occurrence of regex '(?>\d*,\d*) -> (\d*)(?>,\d*)' in i_data in character mode submatches l_value.
      when 4.
        find first occurrence of regex '(?>\d*,\d* -> \d*,)(\d*)' in i_data in character mode submatches l_value.
      when others.
    endcase.
    r_number = l_value.
  endmethod.


  method get_hv.
    if is_line-x1 = is_line-x2.
      r_hv = 'V'.
    elseif is_line-y1 = is_line-y2.
      r_hv = 'H'.
    else.
      r_hv = 'X'.
    endif.
  endmethod.


  method build_matrix.
    data l_matrix_line type string.
    data ls_line type ys_line.
    do p_max_x + 1 times.
      l_matrix_line = |{ l_matrix_line }.|.
    enddo.
    do p_max_y + 1 times.
      append l_matrix_line to pt_matrix.
    enddo.
    loop at pt_lines into ls_line.
      if ls_line-hv = 'H'.
        update_matrix_h( ls_line ).
      endif.
      if ls_line-hv = 'V'.
        update_matrix_v( ls_line ).
      endif.
      if ls_line-hv = 'X' and i_hv_only = abap_false.
        update_matrix_x( ls_line ).
      endif.
    endloop.
  endmethod.


  method get_dangerous_points.
    data l_line type string.
    data lt_matches type match_result_tab.
    r_dangerous_points = 0.
    loop at pt_matrix into l_line.
      find all occurrences of regex '(?:[2-9])' in l_line in character mode results lt_matches.
      r_dangerous_points = r_dangerous_points + lines( lt_matches ).
    endloop.
  endmethod.


  method update_matrix_h.
    data l_from type i.
    data l_to type i.
    data l_pos type i.
    data l_danger type i.
    data l_value type c.
    field-symbols <l_line> type csequence.
    read table pt_matrix index is_line-y1 + 1 assigning <l_line>.
    l_from = nmin( val1 = is_line-x1 val2 = is_line-x2 ).
    l_to = nmax( val1 = is_line-x1 val2 = is_line-x2 ).
    do l_to - l_from + 1 times.
      l_pos = l_from + sy-index - 1.
      l_value = <l_line>+l_pos(1).
      if l_value = '.'.
        l_value = '1'.
      else.
        l_danger = l_value + 1.
        l_value = l_danger.
      endif.
      replace section offset l_pos length 1 of <l_line> with l_value in character mode.
    enddo.
  endmethod.


  method update_matrix_v.
    data l_from type i.
    data l_to type i.
    data l_pos type i.
    data l_danger type i.
    data l_value type c.
    field-symbols <l_line> type csequence.
    l_from = nmin( val1 = is_line-y1 val2 = is_line-y2 ).
    l_to = nmax( val1 = is_line-y1 val2 = is_line-y2 ).
    do l_to - l_from + 1 times.
      l_pos = l_from + sy-index.
      read table pt_matrix index l_pos assigning <l_line>.
      l_value = <l_line>+is_line-x1(1).
      if l_value = '.'.
        l_value = '1'.
      else.
        l_danger = l_value + 1.
        l_value = l_danger.
      endif.
      replace section offset is_line-x1 length 1 of <l_line> with l_value in character mode.
    enddo.
  endmethod.


  method update_matrix_x.
    "No fancy logic is necessary based on the assumption that all X updates
    "are at a 45 degrees angle. We fabricate fake ys_line entries and use them to
    "call UPDATE_MATRIX_H
    data l_steps type i.
    data l_step_x type c.
    data l_step_y type c.
    data ls_line type ys_line.
    l_steps = abs( is_line-x1 - is_line-x2 ) + 1.
    l_step_x = cond #( when is_line-x1 < is_line-x2 then '+' else '-' ).
    l_step_y = cond #( when is_line-y1 < is_line-y2 then '+' else '-' ).
    do l_steps times.
      ls_line-x1 = ls_line-x2 = is_line-x1 + ( sy-index - 1 ) * cond #( when l_step_x = '-' then -1 else 1 ).
      ls_line-y1 = ls_line-y2 = is_line-y1 + ( sy-index - 1 ) * cond #( when l_step_y = '-' then -1 else 1 ).
      update_matrix_h( ls_line ).
    enddo.
  endmethod.


  method reset_matrix.
    clear pt_matrix.
  endmethod.

endclass.
