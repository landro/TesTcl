package require -exact testcl 1.0.6
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
  trigger HTTP_REQUEST
}

it "should handle request using pool bar" {
  on HTTP::uri return "/bar"

  run irules/simple_irule.tcl simple

  endstate pool bar
}

it "should handle request using pool foo" {
  on HTTP::uri return "/foo/admin"
  run irules/simple_irule.tcl simple
  endstate pool foo
}

it "should replace existing Vary http response headers with Accept-Encoding value" {
  run irules/simple_irule.tcl simple

  HTTP::header insert Vary "dummy value"
  HTTP::header insert Vary "another dummy value"

  trigger HTTP_RESPONSE

  verify "there should be only one Vary header" 1 == {HTTP::header count vary}
  verify "there should be Accept-Encoding value in Vary header" "Accept-Encoding" eq {HTTP::header Vary}
}

stats
