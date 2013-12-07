# Use this script to verify that your jtcl installation has been 
# patched correctly to support iRule tcl extensions
if {"abcdefg" starts_with "ab"} { puts "starts_with works as expected" }
if {"abcdefg" ends_with "efg"} { puts "ends_with works as expected" }
if {"abcdefg" contains "cde"} { puts "contains works as expected" }
if {"abcdefg" matches_glob "ab*efg"} { puts "matches_glob works as expected" }
if {"abcdefg" matches_regex "a.cde.*"} { puts "matches_regex works as expected" }

if {"abcdefg" equals "abcdefg"} { puts "equals works as expected" }
if { 1 and 1 } { puts "and works as expected" }
if { 1 or 0 } { puts "or works as expected" }
if { not false } { puts "not works as expected" }
