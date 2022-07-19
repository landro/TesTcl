source src/global.tcl
source src/assert.tcl

namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

assertStringEquals [getfield "foo:bar" "|" 0] ""
assertStringEquals [getfield "foo:bar" ":" 0] ""
assertStringEquals [getfield "foo:bar" ":" 1] "foo"
assertStringEquals [getfield "foo:bar" ":" 2] "bar"
assertStringEquals [getfield "foo:bar" ":" 3] ""

assertStringEquals [getfield "st-str-ts" "str" -1] ""
assertStringEquals [getfield "st-str-ts" "str" 0] ""
assertStringEquals [getfield "st-str-ts" "str" 1] "st-"
assertStringEquals [getfield "st-str-ts" "str" 2] "-ts"
assertStringEquals [getfield "st-str-ts" "str" 3] ""
assertStringEquals [getfield "st-str-ts" "str" 42] ""

assertStringEquals [getfield "st-str-ts-str-foo" "str" 3] "-foo"