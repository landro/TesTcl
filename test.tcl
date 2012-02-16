source tclprocmock/on.tcl

on add 2 2 return 4
on add 2 3 return 5
on add {2 3 2} return 7
on substract 2 1 return 1
on add {{item 1} {item 2} {item 3}} return 3

assertNumber [add 2 2] 4
assertNumber [add 2 3] 5
assertNumber [add {2 3 2}] 7
assertNumber [substract 2 1] 1
assertNumber [add [split "item 1.item 2.item 3" "."]] 3
