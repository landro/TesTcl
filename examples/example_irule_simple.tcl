package require -exact testcl 0.9
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
# jtcl examples/example_irule_simple.tcl
#
##

# Comment out to suppress logging
#log::lvSuppressLE info 0

before {
  event HTTP_REQUEST
}

it "should handle request using pool bar" {
  on HTTP::uri return "/bar"
  endstate pool bar
  run irules/simple_irule.tcl simple
}

it "should handle request using pool foo" {
  on HTTP::uri return "/foo/admin"
  endstate pool foo
  run irules/simple_irule.tcl simple
}

stats