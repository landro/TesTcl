source tclprocmock/on.tcl
source tclprocmock/onirule.tcl

set debugOn true

on HTTP::uri return "/foo/admin"
on pool foo end "whatever"

source tclprocmock/irule.tcl