#!/bin/bash
for f in examples/example_*.tcl
do
    if [ 'tclsh' == "$1" ] ; then tclsh "$f";
    elif [ 'jtcl' == "$1" ] ; then jtcl "$f";
    else echo "Usage: ./examples.sh [jtcl|tclsh]"; exit 1;
    fi
done
