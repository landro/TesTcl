rename unknown ::tcl::unknown

proc assertString {expected actual} {
  if {$expected ne $actual} {
    error "Expected $expected, got $actual"
  }
}

proc assertNumber {expected actual} {
  if {$expected != $actual} {
    error "Expected $expected, got $actual"
  }
}

proc on {args} {
  puts "on called with the following [llength $args] arguments: $args"
  
  global expectations
  lappend expectations $args
  
}

proc unknown {args} {

  global expectations

  if { [info exists expectations] == 1} {

    foreach expectation $expectations {

      set proccall [lrange $expectation 0 end-2]
      set procreturn [lindex $expectation end]

      if { $proccall == $args} {
        puts "Returning value $procreturn for $proccall"
        return $procreturn
      } else {
        set proccall [list]
        set procreturn [list]
      }

    }

  }

  uplevel ::tcl::unknown $args
}

