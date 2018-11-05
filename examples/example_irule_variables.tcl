package require -exact testcl 1.0.12
namespace import ::testcl::*

##
# Example demonstrating how to use TesTcl
# This is how you should write your tests
# 
# To run example
#
# export TCLLIBPATH=/parent/dir/of/this/file
#
# and run the following command from /parent/dir/of/this/file
#
# jtcl examples/example_irule_variables.tcl
#
##

# Comment out to suppress logging
#log::lvSuppressLE info 0

before {
    event HTTP_REQUEST
}

it "should set pool to foo when status is 1" {
    endstate pool foo
    array set variables { status 1 }
    run irules/variables_irule.tcl simple variables
}

it "should set pool to bar when status is 0" {
    endstate pool bar
    array set variables { status 0 }
    run irules/variables_irule.tcl simple variables
}


stats
