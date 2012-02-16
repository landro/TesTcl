#proc stub {cmd argumentlist returnvalue} {
#  global stubslist
#  lappend stubslist [list $cmd $argumentlist $returnvalue]
#}

rename unknown ::tcl::unknown

set stubsInitialised 0

proc initialiseStubs {} {
  global stubsInitialised
  set stubsInitialised 1
}

proc unknown {args} {
  puts "Unknown called: $args"
  puts Length[llength $args]

  global stubslist

  global stubsInitialised
  if {$stubsInitialised == 0} {
    # Set up stubs
    lappend stubslist $args
    return

  } else {
    # Replay stubs

    if { [info exists stubslist] == 1} {
      # TODO shaky code

      puts "stubs found .. try replaying"
      foreach stub $stubslist {

        set section  0
        foreach word $stub {
          if {$section == 0 && $word ne "should_return"} {
            lappend stubcall $word
          } elseif {$section == 0 && $word eq "should_return"} {
            set section 1
          } else {
            set stubreturn $word
          }
        }

        puts "Stubcall $stubcall"
        if { $stubcall == $args} {
          puts "Found stub call"
          return $stubreturn
        } else {
          set stubcall [list]
          set stubreturn [list]
        }

      }

    }

  }
  uplevel ::tcl::unknown $args
}

