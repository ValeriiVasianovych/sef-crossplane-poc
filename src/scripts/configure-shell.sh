#!/bin/bash

#########################################################################
#                                                                       #
#                      Copyright (c) 2022, Nokia                        #
#                                                                       #
#                        All Rights Reserved                            #
#                                                                       #
#        This is unpublished proprietary source code of Nokia.          #
#       The copyright notice above does not evidence any actual         #
#             or intended publication of such source code.              #
#                                                                       #
#########################################################################

#source ~/.bashrc

function exitErr() {
 
    local ret="$1"
    shift
    echo -e "\nExiting - rc=${ret}, errorMsg=\"$*\"\n"
 
    exit $ret
 }
 
function printInfo {
    local msg=${1}
    local dateFormat="%Y-%m-%d %H:%M:%S"
 
    echo -e INFO - $(date +"${dateFormat}") - ${msg}
 
    return 0
}

function printDebug {
    local msg=${1}
    local dateFormat="%Y-%m-%d %H:%M:%S"
 
    if [ "${debug_mode}" == "TRUE" ]; then
        echo -e DEBUG - $(date +"${dateFormat}") - ${msg}
    fi
 
    return 0
}
debug_mode=${DEBUG_MODE^^}

if [ "${debug_mode}" == "TRUE" ]; then
    printInfo "+++ Enable debug mode. +++"
    set -xe
else
    set -e
fi