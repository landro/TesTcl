package provide testcl 1.0.11
package require log
package require cmdline

namespace eval ::testcl {
  namespace export class
  variable classes
}

# testcl::class --
# 
# stub for class command
#
# See https://devcentral.f5.com/wiki/irules.class.ashx
# 
# class match [<options>] <item> <operator> <class>
# class search [<options>] <class> <operator> <item>
# class lookup <item> <class>
# class element [<options>] <index> <class>
# class type <class>
# class exists <class>
# class size <class>
# class names [-nocase] <class> [<pattern>]
# class get [-nocase] <class> [<pattern>]
# class startsearch <class>
# class nextelement [<options>] <class> <search_id>
# class anymore <class> <search_id>
# class donesearch <class> <search_id>
# 
# For convenience, we also add an extra helper subcommand:
# class configure <class_data>
#
# Example:
# class configure servers {
#   "server1" "192.168.0.1"
#   "server2" "192.168.0.2"
# }
#
# This format bears no resemblance to the formats used in F5
# load balancers, and is simply the easiest to implement

proc ::testcl::class {cmd args} {
  variable classes
  log::log debug "class $cmd $args invoked"

  set cmdargs [concat class $cmd $args]
  set rc [catch { return [eval testcl::expected $cmdargs] } res]
  if {$rc != 1500} {
    log::log debug "skipping class method evaluation - expectation found for $cmdargs"
    if {$rc < 1000} {
      return $res
    }
    return -code $rc $res
  }
  
  set options {
      {index    "Changes the return value to be the index of the matching class element."}
      {name     "Changes the return value to be the name of the matching class element."}
      {value    "Changes the return value to be the value of the matching class element."}
      {element  "Changes the return value to be a list of the name and value of the matching class element."}
  }
  
  set return_command {
    if {$params(index)} {return $i}
    if {$params(name)} {return $element_name}
    if {$params(value)} {return $element_value}
    if {$params(element)} {return [list $element_name $element_value]}
    return 1
  }
  
  set return_failure_block {
    if {$params(index)} {return -1}
    if {$params(name)} {return ""}
    if {$params(value)} {return ""}
    if {$params(element)} {return ""}
    return 0
  }
  
  array set params [::cmdline::getoptions args $options]
  switch -- $cmd {
    configure {
      set name [lindex $args 0]
      set value [lindex $args 1]
      set classes($name) $value
    }
    search {
      set classname [lindex $args 0]
      set operator [lindex $args 1]
      set item [lindex $args 2]
      if {[expr ! [info exists classes($classname)]]} $return_failure_block
      set clazz $classes($classname)
      for {set i 0} {$i < [llength $clazz] / 2} {incr i} {
        set element_name [lindex $clazz [expr 2 * $i]]
        set element_value [lindex $clazz [expr 2 * $i + 1]]
        if "\$element_name $operator \$item" $return_command
      }
      eval $return_failure_block
    }
    match {
      set item [lindex $args 0]
      set operator [lindex $args 1]
      set classname [lindex $args 2]
      if {[expr ! [info exists classes($classname)]]} $return_failure_block
      set clazz $classes($classname)
      for {set i 0} {$i < [llength $clazz] / 2} {incr i} {
        set element_name [lindex $clazz [expr 2 * $i]]
        set element_value [lindex $clazz [expr 2 * $i + 1]]
        if "\$item $operator \$element_name" $return_command
      }
      eval $return_failure_block
    }
    lookup {
      set item [lindex $args 0]
      set classname [lindex $args 1]
      return [::testcl::class match -value $item eq $classname]
    }
    element {
      set index [lindex $args 0]
      set classname [lindex $args 1]
      set name [lindex $classes($classname) [expr 2 * $index]]
      set value [lindex $classes($classname) [expr 2 * $index + 1]]
      if {$params(name)} {
        return $name
      }
      if {$params(value)} {
        return $value
      }
      return [list $name $value]
    }
    exists {
      set classname [lindex $args 0]
      return [info exists classes($classname)]
    }
    size {
      set classname [lindex $args 0]
      if {[expr ! [info exists classes($classname)]]} {
        return 0
      } else {
        return [expr [llength $classes($classname)] / 2]
      }
    }
    type -
    names -
    get -
    startsearch -
    nextelement - 
    anymore -
    donesearch {error "Not implemented yet"}
  }
  
}
