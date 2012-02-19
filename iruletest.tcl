source tclprocmock/on.tcl
source tclprocmock/onirule.tcl

on HTTP::uri return "/foo/admin"
on pool foo end "pool"
source tclprocmock/irule.tcl