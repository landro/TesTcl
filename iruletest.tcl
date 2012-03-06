source tclprocmock/on.tcl
source tclprocmock/onirule.tcl

set debugOn true

on HTTP::uri return "/foo/admin"

endstate pool bar

source tclprocmock/irule.tcl