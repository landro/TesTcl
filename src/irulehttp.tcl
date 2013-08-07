package provide testcl 0.9
package require log

namespace eval ::testcl::HTTP {
  variable headers
  variable lws
  variable uri
  #variable version
  #variable method
  #variable user
  #variable password
  #variable status

  #namespace export class
  #namespace export close
  #namespace export collect
  #namespace export cookie
  #namespace export disable
  #namespace export enable
  #namespace export fallback
  namespace export header
  #namespace export host
  #namespace export is_keepalive
  #namespace export is_redirect
  #namespace export method
  #namespace export password
  namespace export path
  #namespace export payload
  #namespace export query
  #namespace export redirect
  #namespace export release
  #namespace export request
  #namespace export request_num
  #namespace export respond
  #namespace export retry
  #namespace export status
  namespace export uri
  #namespace export username
  #namespace export version
}

# testcl::HTTP::header --
#
# stub for the iRule HTTP::header
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

  set cmdargs [concat HTTP::header $cmd $args]
  #set rc [catch { return [::testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval ::testcl::expected $cmdargs] } res]
  if {$rc != 1100} {
    log::log debug "skipping HTTP::header method evaluation - expectation found for $cmdargs"
    return $res
  }
  
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

# testcl::HTTP::uri --
#
# stub for the iRule HTTP::uri
#
# Arguments:
# optional new uri string
#
# Side Effects:
# None.
#
# Results:
# current uri string
#
# Usage syntax:
# HTTP::uri [<string>]
#
proc ::testcl::HTTP::uri {args} {
  log::log debug "HTTP::uri $args invoked"

  set cmdargs [concat HTTP::uri $args]
  #set rc [catch { return [::testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval ::testcl::expected $cmdargs] } res]
  if {$rc != 1100} {
    log::log debug "skipping HTTP::uri method evaluation - expectation found for $cmdargs"
    return $res
  }
  
  variable uri
  if { ![info exists uri] } {
    set uri /
  }

  if { [llength $args] == 0 } {
    log::log debug "return HTTP::uri $uri"
    return $uri
  }
  if { [llength $args] == 1 } {
    set uri [lindex $args 0]
    log::log debug "HTTP::uri set: $uri"
  } else {
    error "incorrect number of arguments for HTTP::uri : [llength $args]"
  }
}

# testcl::HTTP::path --
#
# stub for the iRule HTTP::path
#
# Arguments:
# optional new path string
#
# Side Effects:
# None.
#
# Results:
# current path string
#
# Usage syntax:
# HTTP::path [<string>]
#
proc ::testcl::HTTP::path {args} {
  log::log debug "HTTP::path $args invoked"

  set cmdargs [concat HTTP::path $args]
  #set rc [catch { return [::testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval ::testcl::expected $cmdargs] } res]
  if {$rc != 1100} {
    log::log debug "skipping HTTP::path method evaluation - expectation found for $cmdargs"
    return $res
  }
  
  variable uri
  if { ![info exists uri] } {
    set uri /
  }

  if { ![regexp {^([A-z]+://[^/]+)(.*)} $uri match host pathquery] } {
    set host ""
    set pathquery $uri
  }
  if { ![regexp {^([^?]*)(.*)} $pathquery match path query] } {
    set path $pathquery
    set query ""
  }

  if { [llength $args] == 0 } {
    log::log debug "return HTTP::path $path"
    return $path
  }
  if { [llength $args] == 1 } {
    set path [lindex $args 0]
    set uri "$host$path$query"
    log::log debug "HTTP::path set: $path, uri after update: $uri"
  } else {
    error "incorrect number of arguments for HTTP::path : [llength $args]"
  }
}
