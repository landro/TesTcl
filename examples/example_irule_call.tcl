package require -exact testcl 1.0.12
namespace import ::testcl::*

# Comment in to enable logging
#log::lvSuppressLE info 0

it "should redirect to the same url but using https" {
  event HTTP_REQUEST
  on HTTP::uri return "/bar"
  on HTTP::host return "www.foo.com"
  endstate HTTP::redirect https://www.foo.com/bar
  run irules/call_irule.tcl call
}

stats
