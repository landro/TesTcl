source src/on.tcl
source src/assert.tcl
source src/onirule.tcl
source src/it.tcl
source src/irulehttp.tcl
source src/pool.tcl
namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

before {
  run irules/simple_irule.tcl simple
}

it "should endstate with pool bar using mock value for HTTP::uri" {
  on HTTP::uri return "/bar"
  trigger HTTP_REQUEST
  endstate pool bar
}

it "should set uri with stub - full url with protocol and host as provided to proxy servers" {
  HTTP::uri "http://www.example.com:8080/main/index.jsp?user=test&login=check"
  trigger HTTP_REQUEST
  verify "HTTP::uri value is set" "http://www.example.com:8080/main/index.jsp?user=test&login=check" eq {HTTP::uri}
  verify "HTTP::path value is set from uri" "/main/index.jsp" eq {HTTP::path}
  endstate pool bar
}

it "should set uri with stub - without host" {
  HTTP::uri "/main/index.jsp?user=test&login=check"
  trigger HTTP_REQUEST
  verify "HTTP::uri value is set" "/main/index.jsp?user=test&login=check" eq {HTTP::uri}
  verify "HTTP::path value is set from uri" "/main/index.jsp" eq {HTTP::path}
  endstate pool bar
}

it "should set uri with stub - full url with protocol and host as provided to proxy servers, with session_id in path" {
  HTTP::uri "http://www.example.com:8080/main/index.jsp;session_id=abcdefgh?user=test&login=check"
  trigger HTTP_REQUEST
  verify "HTTP::path value is set from uri with session_id part" "/main/index.jsp;session_id=abcdefgh" eq {HTTP::path}
  endstate pool bar
}

it "should set uri with stub - without host, with session_id in path" {
  HTTP::uri "/main/index.jsp;session_id=abcdefgh?user=test&login=check"
  trigger HTTP_REQUEST
  verify "HTTP::path value is set from uri with session_id part" "/main/index.jsp;session_id=abcdefgh" eq {HTTP::path}
  endstate pool bar
}

it "should set uri and update path part with stub" {
  HTTP::uri "http://www.example.com:8080/main/index.jsp?user=test&login=check"
  HTTP::path "/secondary/index.jsp"
  trigger HTTP_REQUEST
  verify "HTTP::uri value has updated path" "http://www.example.com:8080/secondary/index.jsp?user=test&login=check" eq {HTTP::uri}
  verify "HTTP::path value is updated" "/secondary/index.jsp" eq {HTTP::path}
  endstate pool bar
}

it "should verify dummy payload modification" {
  HTTP::payload replace 0 0 "test http request body payload"
  HTTP::payload length
  HTTP::payload replace 5 4 "'HTTP'"
  HTTP::payload length
  trigger HTTP_REQUEST
  verify "HTTP::payload starts with 'test'" "test" eq {HTTP::payload 4}
  verify "HTTP::payload 6 chars from index 5 are 'HTTP'" "'HTTP'" eq {HTTP::payload 5 6}

  #just to make test case processing
  on pool bar return ""
}

stats
