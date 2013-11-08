#!/bin/bash
for f in test/test_*.tcl
do
    if [ 'tclsh' == "$1" ] ; then tclsh "$f";
    elif [ 'jtcl' == "$1" ] ; then jtcl "$f";
    else echo "Usage: ./tests.sh [jtcl|tclsh]"; exit 1;
    fi
done
