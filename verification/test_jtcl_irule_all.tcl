# Use this script to verify that your jtcl installation has been 
# patched correctly to support iRule tcl extensions
if {"aa" starts_with "a"} {
  puts "starts_with works as expected"
}
if {"a" equals "a"} {
  puts "equals works as expected"
}
if { not false } {
  puts "not works as expected"
}
if { 1 and 1} {
  puts "and works as expected"
}
if { 1 or 0} {
  puts "or works as expected"
}


