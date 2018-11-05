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
# jtcl examples/example_irule_headers.tcl
#
##

# Comment out to suppress logging
#log::lvSuppressLE info 0

before {
  event HTTP_REQUEST
  verify "There should be always set HTTP header X-Forwarded-SSL to true" true eq {HTTP::header X-Forwarded-SSL}
}

it "should remove X-Common-Name-SSL header from request if there was no client SSL certificate" {
  HTTP::header insert X-Common-Name-SSL "testCommonName"
  on SSL::cert count return 0
  verify "There should be no X-Common-Name-SSL" 0 == {HTTP::header exists X-Common-Name-SSL}
  run irules/headers_irule.tcl headers
}

it "should add X-Common-Name-SSL with Common Name from client SSL certificate if it was available" {
  on SSL::cert count return 1
  on SSL::cert 0 return {}
  on X509::subject [SSL::cert 0] return "CN=testCommonName,DN=abc.de.fg"
  verify "X-Common-Name-SSL HTTP header value is the same as CN" "testCommonName" eq {HTTP::header X-Common-Name-SSL}
  run irules/headers_irule.tcl headers
}

stats
