method FILL_ATTRIBUTES .
  DATA ls_parent_attributes TYPE wd_this->element_meta_data.
  parent_element->get_static_attributes(
    IMPORTING
      static_attributes = ls_parent_attributes ).
*
** data declaration
  DATA lt_attr_info TYPE wd_this->Elements_attr_info.
*  DATA ls_attr_info LIKE LINE OF lt_attr_info.
** @TODO compute values
** e.g. call a data providing FuBa
  lt_attr_info = ls_parent_attributes-attributes.
*
** bind all the elements
  node->bind_table(
    new_items            =  lt_attr_info
    set_initial_elements = abap_true ).
*
endmethod.

method FILL_ATTR_DATA .

  DATA ls_parent_attributes TYPE wd_this->element_config_data.
  parent_element->get_static_attributes(
    IMPORTING
      static_attributes = ls_parent_attributes ).

  data lt_attr type cl_wdr_test_config_tool=>tt_config_attr.
  lt_attr = wd_assist->build_attr_list_for_node(
    config_reader = wd_this->config_reader
    node_id       = ls_parent_attributes-node_id
    index         = ls_parent_attributes-index
    node_name     = ls_parent_attributes-name
       ).

** bind all the elements
  node->bind_table(
    new_items            =  lt_attr
    set_initial_elements = abap_true ).
*
endmethod.

method FILL_DATA .
  data l_node type ref to if_wd_context_node.
  data l_item type wd_this->element_config_data.
  data l_table type cl_wdr_test_config_tool=>tt_config_node.

  l_node = wd_context->get_child_node( wd_this->wdctx_config_data ).

  l_table = wd_assist->build_config_data_table( config_reader = wd_this->config_reader  ).
  l_node->bind_table( l_table ).

  if l_table is not initial.
    wd_context->set_attribute( name = 'CONFIGDATA_FILLED' value = abap_true ).
  else.
    wd_context->set_attribute( name = 'CONFIGDATA_FILLED' value = abap_false ).
  endif.
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
  data l_children type WDY_CFG_CHGTOOL_CHILDREN.
  data l_nodeinfos type wd_this->elements_meta_data.
  data l_metadata_map type WDY_CFG_CHGTOOL_NODE_INFO_MAP.
  data l_node type ref to if_wd_context_node.
  data l_component_name type wdy_conf_comp_name.
  lo_api_controller ?= wd_this->wd_get_api( ).
  lo_message_manager = lo_api_controller->get_message_manager( ).

  l_config_node = wd_context->get_child_node( wd_this->wdctx_config_key ).
  l_config_node->get_static_attributes( importing static_attributes = l_config_key ).
  l_config_node->get_attribute( exporting name = 'COMPONENT_NAME' importing value = l_component_name ).
  l_component = wd_comp_controller->wd_get_api( ).
  try.
    wd_this->config_tool = cl_wd_config_factory=>get_comp_config_tool(
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

  l_node = wd_context->get_child_node( wd_This->wdctx_second_key ).
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

  l_node = wd_context->get_child_node( wd_this->wdctx_output_data ).
  l_component_name = wd_this->config_reader->get_component_name( ).
  l_node->set_attribute( name = 'COMPONENT_NAME' value = l_component_name ).
  l_metadata_map = wd_this->config_reader->get_metadata( ).

  l_nodeinfos = l_metadata_map.

  l_node = wd_context->get_child_node( wd_this->wdctx_meta_data ).
  l_node->bind_table( l_nodeinfos ).

  if l_nodeinfos is not initial.
    wd_context->set_attribute( name = 'METADATA_FILLED' value = abap_true ).
  else.
    wd_context->set_attribute( name = 'METADATA_FILLED' value = abap_false ).
  endif.

  wd_this->fill_data( ).
endmethod.

method ONACTIONSAVE .
  wd_this->config_tool->save( keep_locked = ABAP_true ).
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

