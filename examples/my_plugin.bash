#! /usr/bin/env bash

# The function name is in the format of <plugin_name>_c-<component_name>
# "c" is the component type, abbreviated from "controller"
# "loading" is the component name

# You can use any name you want, but it is recommended to use the format above.
# The function name is used to identify the component, so it is recommended to use the format above.
my_plugin_c-loading() {
    # The function body is the code that will be executed when the component is called.
    gum spin -s minidot --title 'Loading my_plugin' -- sleep 10
}

__INIT__() {
    # Register the controller
    # The key is in the format of <plugin_name>:<component_type>:<component_name>
    # The value is the function name

    # The controller is a type of component provided by the core, you can create your own component type.
    # The controller is used to control the flow of the program.

    components["my_plugin:controller:loading"]=my_plugin_c-loading
}
