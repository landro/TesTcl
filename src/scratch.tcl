# Demo of how code can be upleveled

proc when { body } {
  set rc [catch { uplevel 1 $body } result] 		
}

when {
 set a 5
}

when {
 puts $a
}


