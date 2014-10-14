source src/on.tcl
source src/assert.tcl
source src/onirule.tcl
source src/irulehttp.tcl
source src/it.tcl
source src/table.tcl
namespace import ::testcl::*

before {
  table reset
  run irules/table-data.tcl table-data
  run irules/table.tcl table
}

it "add tuples on connect" {
  on IP::client_addr return 172.18.200.20

  trigger CLIENT_ACCEPTED
  trigger CLIENT_ACCEPTED
  trigger CLIENT_ACCEPTED
  trigger CLIENT_ACCEPTED

  verify "connection count" 4 eq { table keys -subtable "connlimit:foo" -count }
}

it "limits the connections from a range" {
  on reject return ""

  on IP::client_addr return 10.176.49.90
  trigger CLIENT_ACCEPTED

  on IP::client_addr return 10.176.49.91
  trigger CLIENT_ACCEPTED

  on IP::client_addr return 10.176.49.92
  trigger CLIENT_ACCEPTED

  verify "connection count" 2 eq { table keys -subtable "connlimit:bar" -count }
}

stats
