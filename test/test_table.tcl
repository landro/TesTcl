source src/on.tcl
source src/assert.tcl
source src/onirule.tcl
source src/irulehttp.tcl
source src/it.tcl
source src/table.tcl
namespace import ::testcl::*

before {
  table reset
}

it "add tuples on connect" {
  on IP::client_addr return 172.18.200.20

  run irules/table-data.tcl table-data
  run irules/table.tcl table

  trigger CLIENT_ACCEPTED
  trigger CLIENT_ACCEPTED
  trigger CLIENT_ACCEPTED
  trigger CLIENT_ACCEPTED

  verify "connection count" 4 eq { table keys -subtable "connlimit:foo" -count }
}

stats
