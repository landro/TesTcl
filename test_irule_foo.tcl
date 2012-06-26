source on.tcl
source assert.tcl
source onirule.tcl
namespace import ::testcl::*

# Comment out to suppress logging
log::lvSuppressLE info 0

event HTTP_REQUEST

on HTTP::uri return "/foo/admin"

endstate pool foo

set rc [catch {source irule.tcl} result]

assertStringEquals "rule irule" $result
assertNumberEquals 0 $rc