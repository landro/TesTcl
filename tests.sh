#!/bin/bash

# Set to false in order to provoke warning during package loading
export DISABLE_TESTCL_INTERPRETER_WARNING=true;

for f in test/test_*.tcl
do
    if [ 'tclsh' == "$1" ] ; then tclsh "$f";
    elif [ 'jtcl' == "$1" ] ; then jtcl "$f";
    else echo "Usage: ./tests.sh [jtcl|tclsh]"; exit 1;
    fi
done
