package require -exact testcl 1.0.5
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
# jtcl examples/example_irule_simple_chain.tcl
#
##

# Comment out to suppress logging
log::lvSuppressLE info 0

#it "should run just fine even if origin port is missing" {
#  event HTTP_REQUEST
#  run irules/simple_chain_irule.tcl simple_chain
#}


it "should insert x-forwarded-port" {
  event HTTP_REQUEST
  set orig_port "julenissen"
  run irules/simple_chain_irule.tcl simple_chain
}



stats
