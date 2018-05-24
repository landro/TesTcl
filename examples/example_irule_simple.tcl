package require -exact testcl 1.0.11
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
  #in most test cases we are checking request event
  event HTTP_REQUEST
}

it "should handle request using pool bar" {
  #provide uri value to use in test case
  on HTTP::uri return "/bar"
  #define statement which will be end state in iRule execution for this test case
  endstate pool bar
  #execute iRule
  run irules/simple_irule.tcl simple
}

it "should handle request using pool foo" {
  on HTTP::uri return "/foo/admin"
  endstate pool foo
  run irules/simple_irule.tcl simple
}

it "should replace existing Vary http response headers with Accept-Encoding value" {
  #override event type set in before
  event HTTP_RESPONSE
  #define verifications
  verify "there should be only one Vary header" 1 == {HTTP::header count vary}
  verify "there should be Accept-Encoding value in Vary header" "Accept-Encoding" eq {HTTP::header Vary}
  #initialize HTTP headers
  HTTP::header insert Vary "dummy value"
  HTTP::header insert Vary "another dummy value"
  #execute iRule
  run irules/simple_irule.tcl simple
}

stats
