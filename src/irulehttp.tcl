package provide testcl 1.0.11
package require log

package require base64

namespace eval ::testcl::HTTP {
  variable sent
  variable headers
  variable lws
  variable uri
  variable status_code
  variable version
  variable payload

  #namespace export class - deprecated from BIG-IP 11.4.0
  #namespace export close - Closes the HTTP connection - should be used with "on" or "endstate"
  #namespace export collect - Collects an amount of HTTP body data that you specify - should be used with "on"
#TODO
  namespace export cookie
  #namespace export disable - Changes the HTTP filter from full parsing to passthrough mode - should be used with "on" or "endstate"
  #namespace export enable - Changes the HTTP filter from passthrough to full parsing mode - should be used with "on" or "endstate"
  #namespace export fallback - Specifies or overrides a fallback host specified in the HTTP profile - should be used with "on" or "endstate"
  namespace export header
  namespace export host
  namespace export is_keepalive
  namespace export is_redirect
  namespace export method
  namespace export password
  namespace export path
  namespace export payload
  namespace export query
  namespace export redirect
  #namespace export release - Releases the data collected via HTTP::collect - should be used with "on" or "endstate"
  namespace export request
  #namespace export request_num - Returns the number of HTTP requests that a client made on the connection - should be used with "on"
  namespace export respond
  #namespace export retry - Resends a request to a server - should be used with "on" or "endstate" (syntax: HTTP::retry <request>)
  namespace export status
  namespace export uri
  namespace export username
  namespace export version

#DEBUG
  #namespace export debug
}


# testcl::HTTP::cookie -- !!! TODO !!!
#
# stub for the iRule HTTP::cookie - Queries for or manipulates cookies in HTTP requests and responses
#
# Arguments:
# optional ??
#
# Side Effects:
# None.
#
# Results:
# ??
#
# Usage syntax:
# HTTP::cookie names
# HTTP::cookie count
# HTTP::cookie [value] <name> [<string>]
# HTTP::cookie version <name> [version]
# HTTP::cookie path <name> [path]
# HTTP::cookie domain <name> [domain]
# HTTP::cookie ports <name> [portlist]
# HTTP::cookie insert name <name> value <value> [path <path>] [domain <domain>] [version <0 | 1 | 2>]
# HTTP::cookie remove <name>
# HTTP::cookie sanitize <name> [attribute]+
# HTTP::cookie exists <name>
# HTTP::cookie maxage <name> [seconds]
# HTTP::cookie expires <name> [seconds] [absolute | relative]
# HTTP::cookie comment <name> [comment]
# HTTP::cookie secure <name> [enable|disable]
# HTTP::cookie commenturl <name> [commenturl]
# HTTP::cookie encrypt <name> <pass phrase> ["128" | "192" | "256"]
# HTTP::cookie decrypt <name> <pass phrase> ["128" | "192" | "256"]
# HTTP::cookie httponly <name> [enable|disable]
# HTTP::cookie sanitize <-attributes|-names>
#
proc ::testcl::HTTP::cookie {args} {
  log::log debug "HTTP::cookie $args invoked"

  set cmdargs [concat HTTP::cookie $args]
  #set rc [catch { return [testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval testcl::expected $cmdargs] } res]
  if {$rc != 1500} {
    log::log debug "skipping HTTP::cookie method evaluation - expectation found for $cmdargs"
    if {$rc < 1000} {
      return $res
    }
    return -code $rc $res
  }
  error "HTTP::cookie command is not implemented - use on HTTP::cookie..."
  TODO !important: should reuse headers
}


# testcl::HTTP::header --
#
# stub for the iRule HTTP::header - Queries or modifies HTTP headers
#
# Arguments:
# cmd The command to execute on header or name of header to read
# args Any argument depending on command used
#
# Side Effects:
# None.
#
# Results:
# Depends on command used - see HTTP::header documentation:
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
  #set rc [catch { return [testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval testcl::expected $cmdargs] } res]
  if {$rc != 1500} {
    log::log debug "skipping HTTP::header method evaluation - expectation found for $cmdargs"
    if {$rc < 1000} {
      return $res
    }
    return -code $rc $res
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
        log::log debug "there is no value for header: $name"
        return {}
      }
      set v [lindex $headers($name) end]
      log::log debug "header '$name' last value is: $v"
      return $v
    }
    values {
      # HTTP::header values <name>
      if { ![info exists headers($name)] } {
        log::log debug "there is no value for header: $name"
        return {}
      }
      log::log debug "header '$name' values are: $headers($name)"
      return $headers($name)
    }
    names {
      # HTTP::header names
      set res {}
      foreach l [array names headers] {
        lappend res [lrepeat [llength $headers($l)] $l]
      }
      log::log debug "header names: $res"
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
        log::log debug "number of all headers: $res"
        return $res
      }
      if { ![info exists headers($name)] } {
        log::log debug "number of headers with name '$name': 0"
        return 0
      }
      set cnt [llength $headers($name)]
      log::log debug "number of headers with name '$name': $cnt"
      return $cnt
    }
    at {
      # HTTP::header at <index>
      set index [lindex $args 0]
      #validate index
      incr index 0
      set cnt 0
      foreach n [array names headers] {
        set oldcnt $cnt
        incr cnt [llength $headers($n)]
        if { $index < $cnt } {
          set res [lindex $headers($n) [expr $index - $oldcnt]]
          log::log debug "header at index $index: '$n: $res'"
          return "$n: $res"
        }
      }
      log::log debug "header at index $index not found"
      return {}
    }
    exists {
      # HTTP::header exists <name>
      set res [info exists headers($name)]
      log::log debug "header '$name' exists: $res"
      return $res
    }
    insert {
      # HTTP::header insert ["lws"] [<name> <value>]+
      variable sent
      if { [info exists sent] } {
        error "response to client was already sent - HTTP::header insert call not allowed (sent: $sent)"
      }
      if { $name eq "lws" } {
        variable lws
        set lws 1
        set args [lreplace $args [set $args {}] 0]
      }
      foreach {n v} $args {
        set n [string tolower $n]
        log::log debug "appending header '$n' value: $v"
        lappend headers($n) $v
      }
    }
    lws {
      # HTTP::header lws
      variable lws
      if { [info exists lws] } {
        return $lws
      }
      return 0
    }
    is_keepalive {
      # HTTP::header is_keepalive
      return [testcl::HTTP::is_keepalive]
    }
    is_redirect {
      # HTTP::header is_redirect
      return [testcl::HTTP::is_redirect]
    }
    replace {
      # HTTP::header replace <name> [<string>]
      variable sent
      if { [info exists sent] } {
        error "response to client was already sent - HTTP::header replace call not allowed"
      }
      set v [lindex $args 1]
      if { [info exists headers($name)] } {
        log::log debug "replace header '$name' with value: $v"
        set headers($name) [lreplace $headers($name)[set headers($name) {}] end end $v]
      } else {
        log::log debug "append header '$name' with value: $v"
        lappend headers($name) $v
      }
    }
    remove {
      # HTTP::header remove <name>
      variable sent
      if { [info exists sent] } {
        error "response to client was already sent - HTTP::header remove call not allowed"
      }
      if { $name eq "" } {
        array unset headers
        variable lws
        set lws 0
        log::log debug "all headers removed"
      } else {
        array unset headers $name
        log::log debug "removed header '$name'"
      }
    }
    insert_modssl_fields {
      # HTTP::header insert_modssl_fields <addr port | addr addr addr | port port port>
      variable sent
      if { [info exists sent] } {
        error "response to client was already sent - HTTP::header insert_modssl_fields call not allowed"
      }
      error "unimplemented command - use 'on HTTP::header insert_modssl_fields ... return ...'"
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
      variable sent
      if { [info exists sent] } {
        error "response to client was already sent - HTTP::header sanitize call not allowed"
      }
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
        log::log debug "there is no value for header: $name"
        return {}
      }
      set v [lindex $headers($name) end]
      log::log debug "header '$name' last value is: $v"
      return $v
    }
  }
  return {}
}


# testcl::HTTP::host --
#
# stub for the iRule HTTP::host - Returns the value of the HTTP Host header
#
# Arguments:
# None
#
# Side Effects:
# None.
#
# Results:
# host name or ip address (with or without port) as provided in request Host header
#
# Usage syntax:
# HTTP::host
#
proc ::testcl::HTTP::host {args} {
  log::log debug "HTTP::host $args invoked"

  set cmdargs [concat HTTP::host $args]
  #set rc [catch { return [testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval testcl::expected $cmdargs] } res]
  if {$rc != 1500} {
    log::log debug "skipping HTTP::host method evaluation - expectation found for $cmdargs"
    if {$rc < 1000} {
      return $res
    }
    return -code $rc $res
  }

  if { [llength $args] > 0 } {
    error "incorrect number of arguments for HTTP::host : [llength $args]"
  }

  log::log debug "reading host from HTTP header"
  variable headers
  if { ![array exists headers] } {
    array set headers {}
  }
  if { ![info exists headers(host)] } {
    return {}
  }
  return [lindex $headers(host) end]
}


# testcl::HTTP::is_keepalive --
#
# stub for the iRule HTTP::is_keepalive - Returns a true value if this is a Keep-Alive connection
#
# Arguments:
# None.
#
# Side Effects:
# None.
#
# Results:
# true or false according to Connection header value or default for protocol version
#
# Usage syntax:
# HTTP::is_keepalive
#
proc ::testcl::HTTP::is_keepalive {args} {
  log::log debug "HTTP::is_keepalive $args invoked"

  set cmdargs [concat HTTP::is_keepalive $args]
  #set rc [catch { return [testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval testcl::expected $cmdargs] } res]
  if {$rc != 1500} {
    log::log debug "skipping HTTP::is_keepalive method evaluation - expectation found for $cmdargs"
    if {$rc < 1000} {
      return $res
    }
    return -code $rc $res
  }

  if { [llength $args] > 0 } {
    error "incorrect number of arguments for HTTP::is_keepalive : [llength $args]"
  }

  log::log debug "reading keep alive state from HTTP Connection header"
  variable headers
  if { ![array exists headers] } {
    array set headers {}
  }
  if { [info exists headers(connection)] } {
    set c [lindex $headers(connection) end]
    log::log debug "HTTP Connection header value: $c"
    set c [string tolower $c]
    if { $c eq "keep-alive" } {
      return 1
    }
    #there is no Keep-Alive in Connection header, but header is available - assuming Close
    return 0
  }
  #there was no Connection header in request
  log::log debug "there was no Connection header in request, use default for protocol version"
  set v [testcl::HTTP::version]
  if { $v < 1.1 } {
    log::log debug "protocol version older than 1.1 : $v"
    return 0
  }
  log::log debug "protocol version 1.1 or newer"
  return 1
}


# testcl::HTTP::is_redirect --
#
# stub for the iRule HTTP::is_redirect - Returns a true value if the response is a redirect
#
# Arguments:
# None.
#
# Side Effects:
# None.
#
# Results:
# true or false according to Location http header and response status code from set 301, 302, 303, 305, 307
#
# Usage syntax:
# HTTP::is_redirect
#
proc ::testcl::HTTP::is_redirect {args} {
  log::log debug "HTTP::is_redirect $args invoked"

  set cmdargs [concat HTTP::is_redirect $args]
  #set rc [catch { return [testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval testcl::expected $cmdargs] } res]
  if {$rc != 1500} {
    log::log debug "skipping HTTP::is_redirect method evaluation - expectation found for $cmdargs"
    if {$rc < 1000} {
      return $res
    }
    return -code $rc $res
  }

  if { [llength $args] > 0 } {
    error "incorrect number of arguments for HTTP::is_redirect : [llength $args]"
  }

  variable headers
  if { ![array exists headers] } {
    array set headers {}
  }

  if { [info exists headers(location)] } {
    set l [lindex $headers(location) end]
    log::log debug "HTTP Location header value: $l"
    variable status_code
    if { ![info exists status_code] } {
      log::log debug "status code not set - it is not redirect"
      return 0
    }
    if { [lsearch {301 302 303 305 307} $status_code] < 0 } {
      log::log debug "not redirect status code: $status_code"
      return 0
    }
    return 1
  }
  return 0
}

# testcl::HTTP::method --
#
# stub for the iRule HTTP::method - Returns the type of HTTP request method - should be used with "on"
#
# Arguments:
# None.
#
# Side Effects:
# None.
#
# Results:
# string GET if not defined with on syntax, if you need other value use for example: on HTTP::method return POST
#
# Usage syntax:
# HTTP::method
#
proc ::testcl::HTTP::method {args} {
  log::log debug "HTTP::method $args invoked"

  set cmdargs [concat HTTP::method $args]
  #set rc [catch { return [testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval testcl::expected $cmdargs] } res]
  if {$rc != 1500} {
    log::log debug "skipping HTTP::method method evaluation - expectation found for $cmdargs"
    if {$rc < 1000} {
      return $res
    }
    return -code $rc $res
  }
  if { [llength $args] > 0 } {
    error "incorrect number of arguments for HTTP::method : [llength $args]"
  }
  log::log info "using default HTTP::method value: GET (use on statement to replace it with required value ex: 'on HTTP::method return POST')"
  return "GET"
}


# testcl::HTTP::password --
#
# stub for the iRule HTTP::password - Returns the password part of HTTP basic authentication - can be used with "on" or will be retrieved from Authorization header if available
#
# Arguments:
# None.
#
# Side Effects:
# None.
#
# Results:
# password decoded from Authorization header (as described in RFC2617)
#
# Usage syntax:
# HTTP::password
#
proc ::testcl::HTTP::password {args} {
  log::log debug "HTTP::password $args invoked"

  set cmdargs [concat HTTP::password $args]
  #set rc [catch { return [testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval testcl::expected $cmdargs] } res]
  if {$rc != 1500} {
    log::log debug "skipping HTTP::password method evaluation - expectation found for $cmdargs"
    if {$rc < 1000} {
      return $res
    }
    return -code $rc $res
  }

  if { [llength $args] > 0 } {
    error "incorrect number of arguments for HTTP::password : [llength $args]"
  }
  
  variable headers
  if { ![array exists headers] } {
    array set headers {}
  }

  if { ![info exists headers(authorization)] } {
    log::log debug "no Authorication header available"
    return {}
  }
  set auth [lindex $headers(authorization) end]
  log::log debug "HTTP Authorization header value: $auth"
  if { ![string equal -length 6 $auth "Basic "] } {
    log::log debug "it is not Basic authorization scheme"
    return {}
  }
  set auth [string range $auth 6 end]
  log::log debug "base64 encoded credentials: $auth"
  set auth [::base64::decode $auth]
  log::log debug "decoded credentials: $auth"
  set colon [string first : $auth]
  if { $colon < 0 } {
    log::log debug "there is no ':' separator in credentials"
    return {}
  }
  set pswd [string range $auth [expr $colon + 1] end]
  log::log debug "password from credentials: $pswd"
  return $pswd
}


# testcl::HTTP::path --
#
# stub for the iRule HTTP::path - Returns or sets the path part of the HTTP request
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
  #set rc [catch { return [testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval testcl::expected $cmdargs] } res]
  if {$rc != 1500} {
    log::log debug "skipping HTTP::path method evaluation - expectation found for $cmdargs"
    if {$rc < 1000} {
      return $res
    }
    return -code $rc $res
  }
  
  variable uri
  if { ![info exists uri] } {
    set uri [HTTP::uri]
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
  return {}
}


# testcl::HTTP::payload
#
# stub for the iRule HTTP::payload - Queries for or manipulates HTTP payload information - should be used with "on"
# Documentation: https://devcentral.f5.com/wiki/iRules.http__payload.ashx
#
# Arguments:
# Depends on command used - see HTTP::payload documentation.
#
# Side Effects:
# None.
#
# Results:
# Depends on command used - see HTTP::payload documentation.
#
# Usage syntax:
# HTTP::payload [<length>]
# HTTP::payload <offset> <length>
# HTTP::payload length
# HTTP::payload replace <offset> <length> <string>
#
#unimplemented commands:
# HTTP::payload rechunk
# HTTP::payload unchunk
#
proc ::testcl::HTTP::payload {args} {
  log::log debug "HTTP::payload $args invoked"

  set cmdargs [concat HTTP::payload $args]
  #set rc [catch { return [testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval testcl::expected $cmdargs] } res]
  if {$rc != 1500} {
    log::log debug "skipping HTTP::payload method evaluation - expectation found for $cmdargs"
    if {$rc < 1000} {
      return $res
    }
    return -code $rc $res
  }
  variable payload
  if { ![info exists payload] } {
    set payload ""
  }
  if { [llength $args] == 0 } {
    # HTTP::payload
    log::log debug "providing all collected payload: $payload"
    return $payload
  }
  switch [lindex $args 0] {
    length {
      # HTTP::payload length
      if { [llength $args] > 1 } {
        error "incorrect number of arguments for HTTP::payload length : [llength $args]"
      }
      set len [string bytelength $payload]
      log::log debug "HTTP::payload length returns: $len"
      return $len
    }
    replace {
      # HTTP::payload replace <offset> <length> <string>
      if { [llength $args] < 4 } {
        error "incorrect number of arguments for HTTP::payload replace: [llength $args]"
      }
      log::log debug "HTTP::payload replace - before: $payload"
      set replacement [lindex $args 3]
      if {[string length $payload] == 0} {
        set payload $replacement
      } else {
        set offset [lindex $args 1]
        set len [lindex $args 2]
        set first $offset
        set last [expr $offset + $len - 1]
        set payload [string replace $payload $first $last $replacement]
        log::log debug "HTTP::payload replace - offset: $offset, length: $len, first: $first, last: $last, replacements: $replacement"
      }
      log::log debug "HTTP::payload replace - after: $payload"
      testcl::HTTP::header replace "Content-Length" [string bytelength $payload]
      log::log debug "HTTP::payload replace executed"
      return {}
    }
    default {
      if { [llength $args] == 1 } {
        # HTTP::payload <length>
        set len [lindex $args 0]
        set last [expr $len - 1]
        set res [string range $payload 0 $last]
        log::log debug "HTTP::payload $len returns: $res"
        return $res
      }
      if { [llength $args] == 2 } {
        # HTTP::payload <offset> <length>
        set ofs [lindex $args 0]
        set len [lindex $args 1]
        set last [expr $ofs + $len - 1]
        set res [string range $payload $ofs $last]
        log::log debug "HTTP::payload $ofs $len returns: $res"
        return $res
      }
      if { [llength $args] > 2 } {
        error "incorrect number of arguments for HTTP::payload : [llength $args]"
      }
    }
  }
  error "HTTP::payload [lindex $args 0] is not implemented - usage of 'on' statement is required"
}


# testcl::HTTP::query --
#
# stub for the iRule HTTP::query - Returns the query part of the HTTP request
#
# Arguments:
# None.
#
# Side Effects:
# None.
#
# Results:
# query part of the url
#
# Usage syntax:
# HTTP::query
#
proc ::testcl::HTTP::query {args} {
  log::log debug "HTTP::query $args invoked"

  set cmdargs [concat HTTP::query $args]
  #set rc [catch { return [testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval testcl::expected $cmdargs] } res]
  if {$rc != 1500} {
    log::log debug "skipping HTTP::query method evaluation - expectation found for $cmdargs"
    if {$rc < 1000} {
      return $res
    }
    return -code $rc $res
  }

  if { [llength $args] > 0 } {
    error "incorrect number of arguments for HTTP::query : [llength $args]"
  }

  variable uri
  if { ![info exists uri] } {
    set uri /
  }

  set query ""

  if { ![regexp {^([A-z]+://[^/]+)(.*)} $uri match host pathquery] } {
    set pathquery $uri
  }
  regexp {^([^?]*)\?(.*)} $pathquery match path query

  log::log debug "return HTTP::query $query"
  return $query
}


# testcl::HTTP::redirect --
#
# stub for the iRule HTTP::redirect - Redirects an HTTP request or response to the specified URL - ustawia nagłówek Location oraz status 301 lub inny
#
# Arguments:
# url to redirect to
#
# Side Effects:
# Immediately sends response to client. No other commands related to response header or content modification can be used after this one.
#
# Results:
# None.
#
# Usage syntax:
# HTTP::redirect <url>
#
proc ::testcl::HTTP::redirect {args} {
  log::log debug "HTTP::redirect $args invoked"

  log::log debug "verify if response is already sent"
  variable sent
  if { [info exists sent] } {
    error "response to client was already sent - HTTP::redirect call not allowed"
  }
  log::log debug "mark response as sent to client"
  set sent 1
  
  set cmdargs [concat HTTP::redirect $args]
  #set rc [catch { return [testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval testcl::expected $cmdargs] } res]
  if {$rc != 1500} {
    log::log debug "skipping HTTP::redirect method evaluation - expectation found for $cmdargs"
    if {$rc < 1000} {
      return $res
    }
    return -code $rc $res
  }
  
  if { [llength $args] != 1 } {
    error "incorrect number of arguments for HTTP::redirect : [llength $args]"
  }

  log::log debug "set response status code to 302"
  variable status_code
  set status_code 302

  variable headers
  if { ![array exists headers] } {
    array set headers {}
  }

  set loc [lindex $args 0]
  log::log debug "set Location header to $loc"
  if { [info exists headers(location)] } {
    set headers(location) [lreplace $headers(location)[set headers(location) {}] end end $loc]
  } else {
    lappend headers(location) $loc
  }
  return {}
}


# testcl::HTTP::request --
#
# stub for the iRule HTTP::request - Returns the raw HTTP request headers - should be used with "on"
#
# Arguments:
# None.
#
# Side Effects:
# None.
#
# Results:
# Raw HTTP headers as a string
#
# Usage syntax:
# HTTP::request
#
proc ::testcl::HTTP::request {args} {
  log::log debug "HTTP::request $args invoked"

  set cmdargs [concat HTTP::request $args]
  #set rc [catch { return [testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval testcl::expected $cmdargs] } res]
  if {$rc != 1500} {
    log::log debug "skipping HTTP::request method evaluation - expectation found for $cmdargs"
    if {$rc < 1000} {
      return $res
    }
    return -code $rc $res
  }
  if { [llength $args] > 0 } {
    error "incorrect number of arguments for HTTP::request : [llength $args]"
  }

  variable headers
  if { ![array exists headers] } {
    array set headers {}
  }

  set lines {}
  foreach name [array names headers] {
    set values $headers($name)
    foreach value $headers($name) {
      lappend lines "$name: $value"
    }
  }
  return "[join $lines \r\n]\r\n\r\n"
}


# testcl::HTTP::respond --
#
# stub for the iRule HTTP::respond - Generates a response to the client as if it came from the server
#
# Arguments:
# status code
# optional protocol version
# optional content
# optional noserver flag to skip adding BIG-IP Server header
# optional headers
#
# Side Effects:
# Marks response as send to client. Adds header Server: BIG-IP. Content-length is replaced with value calculated from provided content.
#
# Results:
# None.
#
# Usage syntax:
# HTTP::respond <status code> [-version [1.0|1.1]] [content <content Value>] [noserver] [<Header name> <Header Value>]+
#
proc ::testcl::HTTP::respond {args} {
  log::log debug "HTTP::respond $args invoked"

  variable sent
  if { [info exists sent] } {
    error "response to client was already sent - HTTP::respond call not allowed"
  }
  log::log debug "mark response as sent to client"
  set sent 1
  
  set cmdargs [concat HTTP::respond $args]
  #set rc [catch { return [testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval testcl::expected $cmdargs] } res]
  if {$rc != 1500} {
    log::log debug "skipping HTTP::respond method evaluation - expectation found for $cmdargs - return code: $rc"
    if {$rc < 1000} {
      return $res
    }
    return -code $rc $res
  }
  
  if {[llength $args] < 1} {
    error "incorrect number of arguments for HTTP::respond : [llength $args]"
  }

  set code [lindex $args 0]
  log::log debug "set response status code to $code"
  variable status_code
  set status_code $code
  #remove status code from args
  set args [lreplace $args [set args 0] 0]
  log::log debug "args after removal of status code: $args"

  #prepare default values
  variable headers
  if { ![array exists headers] } {
    array set headers {}
  }

  #process http version param
  variable version
  if { ![info exists version] } {
    set version 1.0
  }
  if {[llength $args] > 0} {
    set arg [lindex $args 0]
    if { $arg eq "-version" } {
      if {[llength $args] > 1} {
        set v [lindex $args 1]
        if { $v eq "1.0" || $v eq "1.1" } {
          log::log debug "version set to $v"
          set version $v
          #remove version param and value from args
          set args [lreplace $args [set args 0] 1]
        } else {
          error "HTTP::respond - incorrect protocol version param (allowed values 1.0 or 1.1): $v"
        }
      } else {
        error "HTTP::respond - incorrect syntax - no value for -version parameter"
      }
    }
  }
  log::log debug "args after processing -version flag: $args"

  #process content param
  set content ""
  set content_length 0
  if {[llength $args] > 0} {
    set arg [lindex $args 0]
    if { $arg eq "content" } {
      if {[llength $args] > 1} {
        set content [lindex $args 1]
        set content_length [string bytelength $content]
        log::log debug "content set - content length: content_length"
        #remove content param and value from args
        set args [lreplace $args [set args 0] 1]
      } else {
        error "HTTP::respond - incorrect syntax - no value for content parameter"
      }
    }
  }
  log::log debug "args after processing of content params: $args"

  #process noserver param
  set noserver 0
  if {[llength $args] > 0} {
    set arg [lindex $args 0]
    if { $arg eq "noserver" } {
      set noserver 1
      #remove noserver param from args
      set args [lreplace $args [set args 0] 0]
    }
  }
  log::log debug "args after processing of noserver param: $args"

  #process headers
  foreach {hn hv} $args {
    log::log debug "set $hn header to $hv"
    set n [string tolower $hn]
    lappend headers($n) $hv
  }

  log::log debug "set Content-Length header to $content_length"
  if { [info exists headers(content-length)] } {
    set headers(content-length) [lreplace $headers(content-length)[set headers(content-length) {}] end end $content_length]
  } else {
    lappend headers(content-length) $content_length
  }

  if { $noserver == 0 } {
    log::log debug "set Server header to BIG-IP"
    if { [info exists headers(server)] } {
      set headers(server) [lreplace $headers(server)[set headers(server) {}] end end "BIG-IP"]
    } else {
      lappend headers(server) "BIG-IP"
    }
  }
  return {}
}


# testcl::HTTP::status --
#
# stub for the iRule HTTP::status - Returns the response status code - should be used with "on"
#
# Arguments:
# None.
#
# Side Effects:
# None.
#
# Results:
# Response status code as set with respond, redirect or other method
#
# Usage syntax:
# HTTP::status
#
proc ::testcl::HTTP::status {args} {
  log::log debug "HTTP::status $args invoked"

  set cmdargs [concat HTTP::status $args]
  #set rc [catch { return [testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval testcl::expected $cmdargs] } res]
  if {$rc != 1500} {
    log::log debug "skipping HTTP::status method evaluation - expectation found for $cmdargs"
    if {$rc < 1000} {
      return $res
    }
    return -code $rc $res
  }

  if { [llength $args] > 0 } {
    error "incorrect number of arguments for HTTP::status : [llength $args]"
  }

  variable status_code
  if { ![info exists status_code] } {
    return {}
  }
  return $status_code
}


# testcl::HTTP::uri --
#
# stub for the iRule HTTP::uri - Returns or sets the URI part of the HTTP request
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
  #set rc [catch { return [testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval testcl::expected $cmdargs] } res]
  if {$rc != 1500} {
    log::log debug "skipping HTTP::uri method evaluation - expectation found for $cmdargs"
    if {$rc < 1000} {
      return $res
    }
    return -code $rc $res
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
  return {}
}


# testcl::HTTP::username --
#
# stub for the iRule HTTP::username - Returns the username part of HTTP basic authentication - can be used with "on" or will be retrieved from Authorization header if available
#
# Arguments:
# None.
#
# Side Effects:
# None.
#
# Results:
# user name decoded from Authorization header (as described in RFC2617)
#
# Usage syntax:
# HTTP::username
#
proc ::testcl::HTTP::username {args} {
  log::log debug "HTTP::username $args invoked"

  set cmdargs [concat HTTP::username $args]
  #set rc [catch { return [testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval testcl::expected $cmdargs] } res]
  if {$rc != 1500} {
    log::log debug "skipping HTTP::username method evaluation - expectation found for $cmdargs"
    if {$rc < 1000} {
      return $res
    }
    return -code $rc $res
  }

  if { [llength $args] > 0 } {
    error "incorrect number of arguments for HTTP::username : [llength $args]"
  }

  variable headers
  if { ![array exists headers] } {
    array set headers {}
  }

  if { ![info exists headers(authorization)] } {
    log::log debug "no Authorication header available"
    return {}
  }
  set auth [lindex $headers(authorization) end]
  log::log debug "HTTP Authorization header value: $auth"
  if { ![string equal -length 6 $auth "Basic "] } {
    log::log debug "it is not Basic authorization scheme"
    return {}
  }
  set auth [string range $auth 6 end]
  log::log debug "base64 encoded credentials: $auth"
  set auth [::base64::decode $auth]
  log::log debug "decoded credentials: $auth"
  set colon [string first : $auth]
  if { $colon < 0 } {
    log::log debug "there is no ':' separator in credentials"
    return {}
  }
  set username [string range $auth 0 [expr $colon - 1]]
  log::log debug "user name from credentials: $username"
  return $username
}


# testcl::HTTP::version --
#
# stub for the iRule HTTP::version - Returns or sets the HTTP version of the request or response
#
# Arguments:
# optional required version number
#
# Side Effects:
# None.
#
# Results:
# Version number
#
# Usage syntax:
# HTTP::version ["0.9" | "1.0" | "1.1"]
#
proc ::testcl::HTTP::version {args} {
  log::log debug "HTTP::version $args invoked"

  set cmdargs [concat HTTP::version $args]
  #set rc [catch { return [testcl::expected {*}$cmdargs] } res]
  set rc [catch { return [eval testcl::expected $cmdargs] } res]
  if {$rc != 1500} {
    log::log debug "skipping HTTP::version method evaluation - expectation found for $cmdargs"
    if {$rc < 1000} {
      return $res
    }
    return -code $rc $res
  }
  variable version
  if { ![info exists version] } {
    #modern clients are using 1.1 version by default
    set version 1.1
  }

  if { [llength $args] == 0 } {
    log::log debug "return HTTP::version $version"
    return $version
  }
  if { [llength $args] == 1 } {
    if { $version eq [lindex $args 0] } {
      log::log debug "there is no change in HTTP::version : $version"
      return {}
    }
    variable sent
    if { [info exists sent] } {
      error "response to client was already sent - HTTP::version with new version parameter call not allowed"
    }
    set version [lindex $args 0]
    log::log debug "HTTP::version set: $version"
  } else {
    error "incorrect number of arguments for HTTP::version : [llength $args]"
  }
  return {}
}


# ######################################## #
# DEBUG dump of all http package variables #
# ######################################## #
# proc ::testcl::HTTP::debug {} {
  # variable sent
  # if { [info exists sent] } { puts "sent: $sent" } else { puts "sent not set" }
  # variable headers
  # if { [info exists headers] } {
    # puts "headers:"
    # foreach h [array names headers] {
      # puts "$h -> $headers($h)"
    # }
  # } else { puts "headers not set" }
  # variable lws
  # if { [info exists lws] } { puts "lws: $lws" } else { puts "lws not set" }
  # variable uri
  # if { [info exists uri] } { puts "uri: $uri" } else { puts "uri not set" }
  # variable status_code
  # if { [info exists status_code] } { puts "status_code: $status_code" } else { puts "status_code not set" }
  # variable version
  # if { [info exists version] } { puts "version: $version" } else { puts "version not set" }
  # variable payload
  # if { [info exists payload] } { puts "payload: $payload" } else { puts "payload not set" }
# }
