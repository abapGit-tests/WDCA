method ENABLE_CHANGE_LOG .

    data: context type ref to if_wd_context.
    context = wd_context->get_context( ).
    context->enable_context_change_log( ).


endmethod.

method GET_DATA_CHANGES .

    data: context type ref to if_wd_context.
    context = wd_context->get_context( ).
    changes = context->get_context_change_log( and_reset = abap_false ).

endmethod.

method HANDLEIN .

endmethod.

method ONACTIONCOPY .
    data l_config_key type wdy_config_key.
    data l_second_key type wdy_config_key.
    data l_config_node type ref to if_wd_context_node.
    data l_component type ref to if_wd_component.
    data l_ex type ref to cx_wd_config_tool.
    data lo_api_controller     type ref to if_wd_controller.
    data lo_message_manager    type ref to if_wd_message_manager.
    data l_data_table type wd_this->elements_config_data.
    data l_node type ref to if_wd_context_node.

    lo_api_controller ?= wd_this->wd_get_api( ).
    lo_message_manager = lo_api_controller->get_message_manager( ).

    l_config_node = wd_context->get_child_node( wd_this->wdctx_config_key ).
    l_config_node->get_static_attributes( importing static_attributes = l_config_key ).
    l_component = wd_comp_controller->wd_get_api( ).
    try.
        wd_this->config_tool = cl_wd_config_factory=>get_appl_config_tool(
          config_key = l_config_key
          calling_component = l_component ).
      catch cx_wd_config_tool into l_ex.
        lo_message_manager->report_exception(
            message_object            = l_ex
               ).
        return.
    endtry.

    try.
        wd_this->config_tool->create( ).
      catch cx_wd_config_tool into l_ex.
        lo_message_manager->report_exception(
            message_object            = l_ex
               ).
        return.
    endtry.
    wd_assist->register_eventhandlers(
    change_tool     = wd_this->config_tool
    message_manager = lo_message_manager
       ).
    l_node = wd_context->get_child_node( wd_this->wdctx_second_key ).
    l_node->get_static_attributes( importing static_attributes = l_second_key ).
    try.
        wd_this->config_tool->import( l_second_key ).
      catch cx_wd_config_tool into l_ex.
        lo_message_manager->report_exception(
            message_object            = l_ex
               ).
        return.
    endtry.
    try.
        wd_this->config_reader = wd_this->config_tool->get_reader( ).
      catch cx_wd_config_tool into l_ex.
        lo_message_manager->report_exception(
            message_object            = l_ex
               ).
        return.
    endtry.

    try.
        l_data_table = wd_this->config_reader->get_hierarchy_list( ).
      catch cx_wd_config_tool into l_ex.
        lo_message_manager->report_exception(
            message_object            = l_ex
               ).
        return.
    endtry.

    l_node = wd_context->get_child_node( wd_this->wdctx_config_data ).
    l_node->bind_table( l_data_table ).

    l_node = wd_context->get_child_node( wd_this->wdctx_output_data ).
    data l_output_data type wd_this->element_output_data.
    l_output_data-description = wd_this->config_reader->get_description( ).
    l_output_data-component_name = wd_this->config_reader->get_application_name( ).
    l_node->set_static_attributes( l_output_data ).

    wd_this->enable_change_log( ).

endmethod.

method ONACTIONSAVE .
*  if there are changes in the data, pass them to the change tool
    data l_changes    type wdr_context_change_list.
    data l_change     type wdr_context_change.
    data l_config_key type wdy_config_key.
    data l_usage      type string.
    data l_modifier   type ref to if_wd_config_appl_modifier.

    l_changes = wd_this->get_data_changes( ).

    if l_changes is not initial.
      try.

          l_modifier = wd_this->config_tool->get_modifier( ).
*         send attribute changes to change tool
          loop at l_changes into l_change where node_name = wd_this->wdctx_config_data and
            ( attribute_name = 'CONFIG_ID' or
              attribute_name = 'CONFIG_VAR' ).
            l_change-node->get_attribute(
              exporting
                index = l_change-element_index
                name = 'USAGE_PATH'
              importing
                value = l_usage ).
            l_change-node->get_static_attributes(
              exporting
                index = l_change-element_index
              importing
                static_attributes = l_config_key
                ).
            l_modifier->set_config_key(
                usage_path = l_usage
                config_key = l_config_key ).
          endloop.

*         send description change to change tool
          read table l_changes
            with key node_name = wd_this->wdctx_output_data
                     attribute_name = 'DESCRIPTION'
            into l_change.
          if sy-subrc = 0.
            field-symbols <value> type any.
            data l_description type string.
            assign l_change-new_value->* to <value>.
            l_description = <value>.
            l_modifier->set_description( l_description ).
          endif.
        catch cx_wd_config_tool.
      endtry.
    endif.
    wd_this->reset_change_log( ).
  wd_this->config_tool->save( keep_locked = ABAP_true ).

endmethod.

method RESET_CHANGE_LOG .
    data: context type ref to if_wd_context.
    context = wd_context->get_context( ).
    context->reset_context_change_log( ).

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

