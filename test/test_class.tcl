source src/on.tcl
source src/assert.tcl
source src/classes.tcl
namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

class configure server {
  "server1" "192.168.0.1"
  "server2" "192.168.0.2"
}

class configure protocols {
  "http" "http://"
  "mailto" "mailto:"
  "ftp" "ftp://"
}

if { $::tcl_platform(platform) eq "java" } {
  assertStringEquals [class search -value server ends_with "r1"] "192.168.0.1"
  assertStringEquals [class search -name server ends_with "r2"] "server2"
  assertStringEquals [class match -element "http://localhost" starts_with protocols] [list "http" "http://"]
  assertNumberEquals [class match -index "ftp://locahost" starts_with protocols] 2	
  assertNumberEquals [class match -value "server1" eq server] "192.168.0.1"
}
assertNumberEquals [class search server eq "server1"] 1
assertNumberEquals [class search server eq "doesn't exist"] 0
assertNumberEquals [class search doesnt_exist eq "server1"] 0
assertStringEquals [class -value search server eq "doesn't exist"] ""
assertStringEquals [class -name search doesnt_exist eq "server1"] ""
assertNumberEquals [class size protocols] 3
assertNumberEquals [class size doesnt_exist] 0
assertStringEquals [class element 2 protocols] [list "ftp" "ftp://"]
assertStringEquals [class element -name 1 protocols] "mailto"
assertStringEquals [class element -value 0 protocols] "http://"
assertNumberEquals [class exists server] 1
assertNumberEquals [class exists doesnt_exist] 0

