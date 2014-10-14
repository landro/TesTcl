package require testcl
namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

before {
  run test/fixtures/headers_irule.tcl headers
  verify "There should be always set HTTP header X-Forwarded-SSL to true" true eq {HTTP::header X-Forwarded-SSL}
}

it "should remove X-Common-Name-SSL header from request if there was no client SSL certificate" {
  HTTP::header insert X-Common-Name-SSL "testCommonName"
  on SSL::cert count return 0
  trigger HTTP_REQUEST
  verify "There should be no X-Common-Name-SSL" 0 == {HTTP::header exists X-Common-Name-SSL}
}

it "should add X-Common-Name-SSL with Common Name from client SSL certificate if it was available" {
  on SSL::cert count return 1
  on SSL::cert 0 return {}
  on X509::subject [SSL::cert 0] return "CN=testCommonName,DN=abc.de.fg"
  trigger HTTP_REQUEST
  verify "X-Common-Name-SSL HTTP header value is the same as CN" "testCommonName" eq {HTTP::header X-Common-Name-SSL}
}

stats
