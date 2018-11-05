package require -exact testcl 1.0.12
namespace import ::testcl::*

##
# Example demonstrating how TesTcl will generate 
# error messages helpful during development
# 
# To run example
#
# export TCLLIBPATH=/parent/dir/of/this/file
#
# and run the following command from /parent/dir/of/this/file
#
# jtcl examples/errors/error_simple.tcl
#
##

# Comment out to suppress logging
#log::lvSuppressLE info 0

it "should generate understandable error message when irule can't be found" {
  run examples/errors/non_existing_irule.tcl non_existing_irule
}


stats
