#!/bin/bash

# Set to false in order to provoke warning during package loading
export DISABLE_TESTCL_INTERPRETER_WARNING=true;

function run_test() {
    if [ 'tclsh' == "$1" ] ; then tclsh "$2";
    elif [ 'jtcl' == "$1" ] ; then jtcl "$2";
    else echo "Usage: ./tests.sh [jtcl|tclsh]"; exit 1;
    fi
}

failures=()

for file in test/test_*.tcl
do
    OUTPUT=$(run_test "$1" "$file")
    if [ $? -gt 0 ] || grep -q "error" <<< "${OUTPUT}" ; then
        failures+=($file)
    fi
    echo $OUTPUT
done

echo "Test Summary"
echo "============"
if [ ${#failures[@]} -gt 0 ] ; then
    echo ${#failures[@]} " tests failed:"
    for failure in ${failures[@]} ; do
        echo "    ${failure}"
        if [ -n "${CI}" ] ; then 
            echo "::error file=${failure}::error" ; 
        fi
    done
    exit ${#failures[@]}
else
    echo "All tests successful"
    exit 0
fi
