#!/bin/bash

# __CONTROLLER__
_19e43645be79af86() {
    printf "Consumet controller $1\n"
}

# __EXEC__ 
_e781a6fb565c7a1b() {
    eval "$1"
}

# Initialize the plugin
__INIT__() {
    components["$1:controller:gogoanime"]=_19e43645be79af86
    components["$1:eval:exec"]=_e781a6fb565c7a1b
}
