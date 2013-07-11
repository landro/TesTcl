package provide testcl 0.9
package require log

namespace eval ::testcl::HTTP {
  variable headers
  variable lws
  namespace export header
}

# testcl::HTTP::header --
#
# Override of the iRule HTTP structure
#
# Arguments:
# cmd The command to execute on header or name of header to read
# args Any argument depending on command used
#
# Side Effects:
# None.
#
# Results:
# Depending on command used - see HTTP::header documentation:
# https://devcentral.f5.com/wiki/irules.HTTP__header.ashx
#
# Usage syntax:
# HTTP::header [value] <name>
# HTTP::header values <name>
# HTTP::header names
# HTTP::header count <name>
# HTTP::header at <index>
# HTTP::header exists <name>
# HTTP::header insert ["lws"] [<name> <value>]+
# HTTP::header lws
# HTTP::header is_keepalive
# HTTP::header is_redirect
# HTTP::header replace <name> [<string>]
# HTTP::header remove <name>
# HTTP::header sanitize [header name]+
#
# unimplemented command:
# HTTP::header insert_modssl_fields <addr port | addr addr addr | port port port>
#
proc ::testcl::HTTP::header {cmd args} {
  log::log debug "HTTP::header $cmd $args invoked"
  
  variable headers
  if { ![array exists headers] } {
    array set headers {}
  }
  
  set name [string tolower [lindex $args 0]]
  
  switch $cmd {
    value {
      # HTTP::header [value] <name>
      if { ![info exists headers($name)] } {
        return {}
      }
      return [lindex $headers($name) end]
    }
    values {
      # HTTP::header values <name>
      if { ![info exists headers($name)] } {
        return {}
      }
      return $headers($name)
    }
    names {
      # HTTP::header names
      set res {}
      foreach l [array names headers] {
        lappend res [lrepeat [llength $headers($l)] $l]
      }
      return $res
    }
    count {
      # HTTP::header count <name>
      if { $name eq "" } {
        #return number of all headers
        set res 0
        foreach l [array names headers] {
          incr res [llength $headers($l)]
        }
        return $res
      }
      if { ![info exists headers($name)] } {
        return 0
      }
      #return number of headers with given name
      return [llength $headers($name)]
    }
    at {
      # HTTP::header at <index>
      set index [lindex $args 0]
      #validate index
      incr index 0
      set cnt 0
      foreach l [array names headers] {
        set oldcnt $cnt
        incr cnt [llength $headers($l)]
        if { $index < $cnt } {
          return [lindex $headers($l) [expr $index - $oldcnt]]
        }
      }
      return {}
    }
    exists {
      # HTTP::header exists <name>
      return [info exists headers($name)]
    }
    insert {
      # HTTP::header insert ["lws"] [<name> <value>]+
      if { $name eq "lws" } {
        variable lws
        set lws 1
        set args [lreplace $args [set $args {}] 0]
      }
      foreach {n v} $args {
        set n [string tolower $n]
        lappend headers($n) $v
      }
    }
    lws {
      # HTTP::header lws
      variable lws
      if { [info exists lws] } {
        return $lws
      }
      return 0;
    }
    is_keepalive {
      # HTTP::header is_keepalive
      return [HTTP::is_keepalive]
    }
    is_redirect {
      # HTTP::header is_redirect
      return [HTTP::is_redirect]
    }
    replace {
      # HTTP::header replace <name> [<string>]
      if { [info exists headers($name)] } {
        set headers($name) [lreplace $headers($name)[set headers($name) {}] end end [lindex $args 1]]
      } else {
        lappend headers($name) [lindex $args 1]
      }
    }
    remove {
      # HTTP::header remove <name>
      if { $name eq "" } {
        array unset headers
        variable lws
        set lws 0
      } else {
        array unset headers $name
      }
    }
    insert_modssl_fields {
      # HTTP::header insert_modssl_fields <addr port | addr addr addr | port port port>
      error "unimplemented command"
      #addr port | addr addr addr | port port port
      #addr port
      #lappend headers(ClientIPAddress) 1.1.1.1:443
      #addr addr addr
      #lappend headers(ClientIPAddress) 1.1.1.1
      #port port port
      #lappend headers(ClientTCPService) 443
    }
    sanitize {
      # HTTP::header sanitize [header name]+
      #[header_name]+
      array set allowed_headers {
        connection 1
        content-encoding 1
        content-length 1
        content-type 1
        proxy-connection 1
        set-cookie 1
        set-cookie2 1
        transfer-encoding 1
      }
      foreach $n $args {
        set allowed_headers([string tolower $n]) 1
      }
      foreach $n [array names headers] {
        if { ![info exists allowed_headers($n)] } {
          array unset headers $n
        }
      }
    }
    default {
      # HTTP::header [value] <name>
      #without command name
      set name [string tolower $cmd]
      if { ![info exists headers($name)] } {
        return {}
      }
      return [lindex $headers($name) end]
    }
  }
}
