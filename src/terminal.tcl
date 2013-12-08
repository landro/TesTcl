package provide testcl 1.0.3
package require log

namespace eval ::testcl {
  namespace export put
}

proc ::testcl::terminal_capability cap {expr {![catch {exec tput -S << $cap}]}}
proc ::testcl::terminal_color {} {expr {[terminal_capability setaf] && [terminal_capability setab]}}
proc ::testcl::terminal_foreground x {
  array set color {black 0 red 1 green 2 yellow 3 blue 4 magenta 5 cyan 6 white 7}
  exec tput -S << "setaf $color($x)" > /dev/tty
}
proc ::testcl::terminal_reset {} {exec tput sgr0 > /dev/tty}

proc ::testcl::put {color text}  {
  if {[terminal_color]} {
    terminal_foreground $color
    puts "$text"
    terminal_reset
  } else {
    puts "$text"
  }
		
}



 
