source src/on.tcl
source src/assert.tcl
source src/onirule.tcl
source src/it.tcl
source src/irulehttp.tcl
namespace import ::testcl::*

# Comment out to suppress logging
log::lvSuppressLE info 0

before {
  event HTTP_REQUEST
}

it "should endstate with pool bar using mock value for HTTP::uri" {
  on HTTP::uri return "/bar"
  endstate pool bar
  run irules/simple_irule.tcl simple
}

it "should set uri with stub - full url with protocol and host as provided to proxy servers" {
  HTTP::uri "http://www.example.com:8080/main/index.jsp?user=test&login=check"
  verify "HTTP::uri value is set" "http://www.example.com:8080/main/index.jsp?user=test&login=check" eq {HTTP::uri}
  verify "HTTP::path value is set from uri" "/main/index.jsp" eq {HTTP::path}
  endstate pool bar
  run irules/simple_irule.tcl simple
}

it "should set uri with stub - without host" {
  HTTP::uri "/main/index.jsp?user=test&login=check"
  verify "HTTP::uri value is set" "/main/index.jsp?user=test&login=check" eq {HTTP::uri}
  verify "HTTP::path value is set from uri" "/main/index.jsp" eq {HTTP::path}
  endstate pool bar
  run irules/simple_irule.tcl simple
}

it "should set uri with stub - full url with protocol and host as provided to proxy servers, with session_id in path" {
  HTTP::uri "http://www.example.com:8080/main/index.jsp;session_id=abcdefgh?user=test&login=check"
  verify "HTTP::path value is set from uri with session_id part" "/main/index.jsp;session_id=abcdefgh" eq {HTTP::path}
  endstate pool bar
  run irules/simple_irule.tcl simple
}

it "should set uri with stub - without host, with session_id in path" {
  HTTP::uri "/main/index.jsp;session_id=abcdefgh?user=test&login=check"
  verify "HTTP::path value is set from uri with session_id part" "/main/index.jsp;session_id=abcdefgh" eq {HTTP::path}
  endstate pool bar
  run irules/simple_irule.tcl simple
}

it "should set uri and update path part with stub" {
  HTTP::uri "http://www.example.com:8080/main/index.jsp?user=test&login=check"
  HTTP::path "/secondary/index.jsp"
  verify "HTTP::uri value has updated path" "http://www.example.com:8080/secondary/index.jsp?user=test&login=check" eq {HTTP::uri}
  verify "HTTP::path value is updated" "/secondary/index.jsp" eq {HTTP::path}
  endstate pool bar
  run irules/simple_irule.tcl simple
}

stats
