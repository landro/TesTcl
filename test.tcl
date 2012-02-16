source tclprocmock/mock.tcl

puts "##### setup stubs"

add 2 2 should_return 4
substract 2 1 should_return 1

puts "##### initialise stubs"
initialiseStubs

puts $stubslist

puts length[llength $stubslist]

puts "##### exercise"

puts [expr [add 2 2] == 4]
puts [expr [substract 2 1] == 1]
