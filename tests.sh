#!/bin/bash

function run_test() {
    if [ 'tclsh' == "$1" ] ; then tclsh "$2";
    elif [ 'jtcl' == "$1" ] ; then jtcl "$2";
    else echo "Usage: ./tests.sh [jtcl|tclsh]"; exit 1;
    fi
}

failures=()

for file in test/test_*.tcl
do
    run_test "$1" "$file"
    if [ $? -gt 0 ] ; then
        failures+=($file)
    fi
done

echo "Test Summary"
echo "============"
if [ ${#failures[@]} -gt 0 ] ; then
    echo ${#failures[@]} " tests failed:"
    for failure in ${failures[@]} ; do
        echo "    ${failure}"
    done
    exit ${#failures[@]}
else
    echo "All tests successful"
    exit 0
fi
