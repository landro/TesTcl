package require -exact testcl 1.0.11
namespace import ::testcl::*

before {
  event HTTP_REQUEST
  class configure blacklist {
    "blacklisted" "192.168.6.66"
  }
}

it "should drop blacklisted addresses" {
  on IP::remote_addr return "192.168.6.66"
  endstate drop
  run irules/classes_irule.tcl classes
}

it "should drop blacklisted addresses" {
  on IP::remote_addr return "192.168.0.1"
  endstate pool main-pool
  run irules/classes_irule.tcl classes
}
