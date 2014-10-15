package require testcl
namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

on add 2 2 return 4
on add 2 3 return 5
on add {2 3 2} return 7
on substract 2 1 return 1
on add {{item 1} {item 2} {item 3}} return 3

assertNumberEquals 4 [add 2 2]
assertNumberEquals 5 [add 2 3]
assertNumberEquals 7 [add {2 3 2}]
assertNumberEquals 1 [substract 2 1]
assertNumberEquals 3 [add [split "item 1.item 2.item 3" "."]]
