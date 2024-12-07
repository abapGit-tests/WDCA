method ONACTIONCOPY_AND_CHANGE .
    wd_this->fire_show_copy_and_change_plg(
    ).
endmethod.

method ONACTIONCOPY_APPL .
    wd_this->fire_show_copy_appl_plg(
    ).
endmethod.

method ONACTIONCOPY_COMP .
    wd_this->fire_show_copy_comp_plg(
    ).
endmethod.

method ONACTIONDISPLAY_APPL .
    wd_this->fire_show_display_appl_plg(
    ).
endmethod.

method ONACTIONDISPLAY_COMP .
    wd_this->fire_show_display_comp_plg(
    ).

endmethod.

method WDDOAFTERACTION .
endmethod.

method WDDOBEFOREACTION .
*  data lo_api_controller type ref to if_wd_view_controller.
*  data lo_action         type ref to if_wd_action.

*  lo_api_controller = wd_this->wd_get_api( ).
*  lo_action = lo_api_controller->get_current_action( ).

*  if lo_action is bound.
*    case lo_action->name.
*      when '...'.

*    endcase.
*  endif.
endmethod.

method WDDOEXIT .
endmethod.

method WDDOINIT .
endmethod.

method WDDOMODIFYVIEW .
endmethod.

method WDDOONCONTEXTMENU .
endmethod.

