method HANDLEIN .
endmethod.

method ONACTIONDISPLAY .

  data l_config_key type wdy_config_key.
  data l_config_node type ref to if_wd_context_node.
  data l_component type ref to if_wd_component.
  data l_ex type ref to cx_wd_config_tool.
  data lo_api_controller     type ref to if_wd_controller.
  data lo_message_manager    type ref to if_wd_message_manager.
  data l_data_table type wd_this->elements_config_data.
  data l_node type ref to if_wd_context_node.
  data l_output_data type wd_this->element_output_data.
  data l_appl_params type wdy_cfg_chgtool_appl_par_table.

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
    wd_this->config_tool->load( ).
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

*  l_node = wd_context->get_child_node( wd_this->wdctx_output_data ).
*  l_component_name = wd_this->config_reader->get_component_name( ).
*  l_node->set_attribute( name = 'COMPONENT_NAME' value = l_component_name ).

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

  l_node = wd_context->get_child_node( wd_This->wdctx_output_data ).

  l_output_data-config_id = l_config_key-config_id.
  l_output_data-application_name = wd_this->config_reader->get_application_name( ).
  l_output_data-description = wd_this->config_reader->get_description( ).
  l_node->set_static_attributes( l_output_data ).

  l_node = wd_context->get_child_node( wd_this->wdctx_config_params ).
  l_appl_params = wd_this->config_reader->get_parameters( ).
  l_node->bind_table( l_appl_params ).
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

