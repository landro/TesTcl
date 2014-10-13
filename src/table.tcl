package provide testcl 1.0.6

namespace eval ::testcl::table {
  namespace export keys set delete reset
  namespace ensemble create
  variable subtables [dict create]
}

proc ::testcl::table::keys {x name args} {
  variable subtables
  if { [dict exists $subtables $name] } {
    ::set subtable [dict get $subtables $name]
    dict size $subtable
  } else {
    expr 0
  }
}

proc ::testcl::table::set {x name key value timeout} {
  variable subtables
  if { [dict exists $subtables $name] } {
    ::set subtable [dict get $subtables $name]
  } else {
    ::set subtable [dict create]
  }
  dict set subtable $key $value
  dict set subtables $name $subtable
}

proc ::testcl::table::reset {} {
  variable subtables
  ::set subtables [dict create]
}

proc ::testcl::table::delete {x name key} {
  variable subtables
  if { [dict exists $subtables $name] } {
    ::set subtable [dict get $subtables $name]
    dict unset subtable $key
    dict set subtables $name $subtable
  }
}
