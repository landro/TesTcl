package require -exact testcl 1.0.12
namespace import ::testcl::*

before {
  event HTTP_REQUEST
  class configure blacklist {
    "192.168.6.66" "blacklisted"
  }
}

it "should drop blacklisted addresses" {
  on IP::remote_addr return "192.168.6.66"
  endstate drop
  run irules/classes_irule.tcl classes
}

it "should not drop adresses that are not blacklisted" {
  on IP::remote_addr return "192.168.0.1"
  endstate pool main-pool
  run irules/classes_irule.tcl classes
}
