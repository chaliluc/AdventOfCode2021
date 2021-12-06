*&---------------------------------------------------------------------*
*& Report ZLC_ADVENT21_DAY4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlc_advent21_day4.

types yt_i_table type standard table of i.

class yc_day4 definition inheriting from zcl_lc_adv2021.
  public section.
    types: begin of ys_board,
             board_number type i,
             row          type i,
             col          type i,
             value        type i,
             checked      type abap_bool,
           end of ys_board.
    types yt_board type standard table of ys_board.

    methods get_random_numbers importing it_data        type yt_string_table
                               exporting et_numbers     type yt_i_table
                               returning value(r_subrc) type i.
    methods make_boards importing it_data        type yt_string_table optional
                                    preferred parameter it_data
                        returning value(r_subrc) type i.
    methods run_numbers importing it_numbers               type yt_i_table optional
                                  i_return_on_first_winner type abap_bool default abap_true
                                    preferred parameter it_numbers
                        returning value(r_winning_board)   type i.
    methods get_board_score importing i_board_number type i optional preferred parameter i_board_number
                            returning value(r_score) type i.
    methods get_winning_number returning value(r_number) type i.
    methods reset_boards.

  private section.
    data pt_board type yt_board.
    data p_number_of_boards type i.
    data p_winning_number type i.
    data pth_winning_boards type hashed table of i with unique key table_line.
    data pt_winning_boards type standard table of i.
    methods check_for_bingo importing i_return_on_first_winner type abap_bool default abap_true
                            returning value(r_winning_board)   type i.
    methods is_winning_board importing i_board_no       type i optional
                                         preferred parameter i_board_no
                             returning value(r_winning) type abap_bool.
    methods get_last_winning_board returning value(r_last_winning) type i.
    methods insert_winning_board importing i_board_no type i optional preferred parameter i_board_no.

endclass.


*&---------------------------------------------------------------------*
data l_winning_board type i.
data l_winning_score type i.
data l_winning_number type i.
data l_board_score type i.
data l_input_filename type string.
data lr_day4 type ref to yc_day4.
data lt_input type yc_day4=>yt_string_table.
data lt_random_numbers type standard table of i.

create object lr_day4.
l_input_filename = lr_day4->get_input_filename( ).
check l_input_filename <> space.

check lr_day4->import_data( exporting i_filename = l_input_filename importing et_data = lt_input ) = 0.
check lines( lt_input ) > 0.

check lr_day4->get_random_numbers( exporting it_data = lt_input importing et_numbers = lt_random_numbers ) = 0.
check lr_day4->make_boards( lt_input ) = 0.

l_winning_board = lr_day4->run_numbers( lt_random_numbers ).
if l_winning_board <> 0.
  l_winning_number = lr_day4->get_winning_number( ).
  l_winning_score = lr_day4->get_board_score( l_winning_board ) * l_winning_number.
  write: / 'Winning board', l_winning_board.
  write: / 'Winning number', l_winning_number.
  write: / 'Winning board score', l_winning_score.
else.
  write: / 'No winning boards'.
endif.

lr_day4->reset_boards( ).
l_winning_board = lr_day4->run_numbers( it_numbers = lt_random_numbers i_return_on_first_winner = abap_false ).
if l_winning_board <> 0.
  l_winning_number = lr_day4->get_winning_number( ).
  l_winning_score = lr_day4->get_board_score( l_winning_board ) * l_winning_number.
  skip 1.
  write: / 'Last winning board', l_winning_board.
  write: / 'Last winning number', l_winning_number.
  write: / 'Last winning board score', l_winning_score.
endif.

*&---------------------------------------------------------------------*


class yc_day4 implementation.
  method get_random_numbers.
    data l_numbers type string.
    data lt_numbers type standard table of string.
    data l_number type i.
    r_subrc = 0.
    read table it_data into l_numbers index 1.
    split l_numbers at ',' into table lt_numbers.
    loop at lt_numbers into l_number.
      append l_number to et_numbers.
    endloop.
  endmethod.


  method make_boards.
    data l_data type string.
    data ls_board type ys_board.
    data lt_col type standard table of string.
    data l_value type string..
    r_subrc = 0.
    loop at it_data from 2 into l_data.
      condense l_data.
      if l_data = space.
        ls_board-board_number = ls_board-board_number + 1.
        ls_board-row = 0.
      else.
        ls_board-row = ls_board-row + 1.
        split l_data at space into table lt_col.
        loop at lt_col into l_value.
          ls_board-col = sy-tabix.
          ls_board-value = l_value.
          append ls_board to pt_board.
        endloop.
      endif.
    endloop.
    p_number_of_boards = ls_board-board_number.
  endmethod.


  method run_numbers.
    data l_number type i.
    data l_at_least_one type abap_bool.
    field-symbols <ls_board> type ys_board.
    r_winning_board = 0.
    loop at it_numbers into l_number.
      clear l_at_least_one.
      loop at pt_board assigning <ls_board> where value = l_number.
        check is_winning_board( <ls_board>-board_number ) = abap_false.
        l_at_least_one = <ls_board>-checked = abap_true.
      endloop.
      if l_at_least_one = abap_true.
        r_winning_board = check_for_bingo( i_return_on_first_winner = i_return_on_first_winner ).
        if r_winning_board <> 0.
          p_winning_number = l_number.
          if i_return_on_first_winner = abap_true.
            return.
          endif.
        endif.
      endif.
    endloop.

    r_winning_board = get_last_winning_board( ).

  endmethod.


  method check_for_bingo.
    data l_board_number type i.
    data l_check type string.
    field-symbols <ls_board> type ys_board.
    r_winning_board = 0.
    do p_number_of_boards times.
      l_board_number = sy-index.

      "Don't check again for boards that won already
      check is_winning_board( l_board_number ) = abap_false.

      "Check rows
      do 5 times.
        clear l_check.
        loop at pt_board assigning <ls_board> where board_number = l_board_number and row = sy-index.
          l_check = |{ l_check }{ <ls_board>-checked }|.
        endloop.
        if l_check = 'XXXXX'.
          if i_return_on_first_winner = abap_true.
            r_winning_board = <ls_board>-board_number.
            return.
          else.
            insert_winning_board( <ls_board>-board_number ).
          endif.
        endif.
      enddo.

      "Check columns
      do 5 times.
        clear l_check.
        loop at pt_board assigning <ls_board> where board_number = l_board_number and col = sy-index.
          l_check = |{ l_check }{ <ls_board>-checked }|.
        endloop.
        if l_check = 'XXXXX'.
          if i_return_on_first_winner = abap_true.
            r_winning_board = <ls_board>-board_number.
            return.
          else.
            insert_winning_board( <ls_board>-board_number ).
          endif.
        endif.
      enddo.
    enddo.

    r_winning_board = get_last_winning_board( ).

  endmethod.


  method get_board_score.
    field-symbols <ls_board> type ys_board.
    r_score = 0.
    loop at pt_board assigning <ls_board> where board_number = i_board_number and checked = abap_false.
      r_score = r_score + <ls_board>-value.
    endloop.
  endmethod.


  method get_winning_number.
    r_number = p_winning_number.
  endmethod.


  method reset_boards.
    field-symbols <ls_board> type ys_board.
    clear p_winning_number.
    clear pth_winning_boards.
    loop at pt_board assigning <ls_board>.
      <ls_board>-checked = abap_false.
    endloop.
  endmethod.


  method is_winning_board.
    read table pth_winning_boards transporting no fields with table key table_line = i_board_no.
    r_winning = cond #( when sy-subrc = 0 then abap_true else abap_false ).
  endmethod.


  method get_last_winning_board.
    read table pt_winning_boards into r_last_winning index lines( pt_winning_boards ).
  endmethod.


  method insert_winning_board.
    insert i_board_no into table pth_winning_boards.
    if sy-subrc = 0.
      append i_board_no to pt_winning_boards.
    endif.
  endmethod.

endclass.
