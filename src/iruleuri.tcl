package provide testcl 1.0.10
package require log

package require base64

namespace eval ::testcl::URI {

  namespace export encode
  namespace export decode
  namespace export host
  namespace export basename
  namespace export port
  namespace export protocol
  namespace export query
  namespace export path
  namespace export compare

}

# TODO Incomplete
# https://devcentral.f5.com/wiki/iRules.URI__encode.ashx
# https://en.wikipedia.org/wiki/Percent-encoding
proc ::testcl::URI::encode {uri} {

  log::log debug "Encoding $uri"

  set utf8_uri [encoding convertto utf-8 $uri]

  set encodedString ""

  for {set i 0} {$i < [string length $utf8_uri]} {incr i} {

    set char [string index $utf8_uri $i]

      if { "A" <= $char && $char <= "Z" } {
        log::log debug " - Keeping uppercase A-Z $char"
        append encodedString $char
      } elseif {"a" <= $char && $char <= "z" } {
        log::log debug " - Keeping lowercase a-z char $char"
        append encodedString $char
      } elseif { "0" <= $char && $char <= "9" } {
        log::log debug " - Keeping numeric char $char"
        append encodedString $char
      } elseif { " " eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%20"
      } elseif { "!" eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%21"
      } elseif { "#" eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%23"
      } elseif { "$" eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%24"
      } elseif { "%" eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%25"
      } elseif { "&" eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%26"
      } elseif { "'" eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%27"
      } elseif { "(" eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%28"
      } elseif { ")" eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%29"
      } elseif { "*" eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%2a"
      } elseif { "+" eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%2b"
      } elseif { "," eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%2c"
      } elseif { "/" eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%2f"
      } elseif { ":" eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%3a"
      } elseif { ";" eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%3b"
      } elseif { "=" eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%3d"
      } elseif { "?" eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%3f"
      } elseif { "@" eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%40"
      } elseif { "\[" eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%5b"
      } elseif { "]" eq $char } {
        log::log debug " - Converting reserved char $char"
        append encodedString "%5d"
      } else {
        log::log critical "Not converting char $char - to be implemented in iruleuri.tcl"
        append encodedString "$char"
      }

  }

  return $encodedString

}

# Not complete, but matches URI::encode
proc ::testcl::URI::decode {uri} {

  log::log debug "Decoding $uri"

  set decodedString ""

  for {set i 0} {$i < [string length $uri]} {incr i} {

    set char [string index $uri $i]

      if { $char ne "%" } {
        log::log debug " - Keeping not encoded char $char"
	append decodedString $char
      } else {
	set char [string tolower [string range $uri $i [expr {$i + 2}]]]
	incr i 2

        if { "%20" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString " "
        } elseif { "%21" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString "!"
        } elseif { "%23" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString "#"
        } elseif { "%24" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString "$"
        } elseif { "%25" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString "%"
        } elseif { "%26" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString "&"
        } elseif { "%27" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString "'"
        } elseif { "%28" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString "("
        } elseif { "%29" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString ")"
        } elseif { "%2a" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString "*"
        } elseif { "%2b" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString "+"
        } elseif { "%2c" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString ","
        } elseif { "%2f" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString "/"
        } elseif { "%3a" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString ":"
        } elseif { "%3b" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString ";"
        } elseif { "%3d" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString "="
        } elseif { "%3f" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString "?"
        } elseif { "%40" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString "@"
        } elseif { "%5b" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString "\["
        } elseif { "%5d" eq $char } {
          log::log debug " - Converting encoded char $char"
          append decodedString "]"
        } else {
          log::log critical "Not converting char $char - to be implemented in iruleuri.tcl"
          append decodedString "$char"
        }
     }
  }

  return $decodedString

}

proc ::testcl::URI::host {uri} {
  log::log debug "URI::host $uri invoked"

  set host ""
  regexp {^.+:\/\/([^:/]+):?(?:\d+)?(?:\/.*)?} $uri -> host

  log::log debug "URI::host returning $host"
  return $host
}

proc ::testcl::URI::basename {uri} {
  log::log debug "URI::basename $uri invoked"

  regexp {([^?]+)(?:\?.*)?} $uri -> withoutquery
  set basename [lindex [split $withoutquery "/"] end]

  log::log debug "URI::basename returning $basename"
  return $basename
}

proc ::testcl::URI::port {uri} {
  log::log debug "URI::port $uri invoked"

  regexp {^([a-z][a-z0-9+\-.]+):\/\/(?:[^:/]+):?(\d+)?(?:\/.*)?} [string tolower $uri] -> proto port

  if { ![info exists proto] } {
    #This is a bit strange, but it seems to be what the F5 does
    log::log debug "URI::port could not parse URI. Returning 80"
    return 80
  }

  if { $port ne "" } {
    log::log debug "URI::port returning $port. Was specified in URI"
    return $port
  }

  switch $proto {
    "http" { set port 80 }
    "https" { set port 443 }
    "ftp" { set port 21 }
    "ldap" { set port 389 }
    "sip" { set port 5060 }
    default { set port 0 }
  }

  log::log debug "URI::port returning port $port for protocol $proto"
  return $port
}

proc ::testcl::URI::protocol {uri} {
  log::log debug "URI::protocol $uri invoked"

  set proto ""
  regexp {^([A-Za-z0-9+\-.]+):\/\/(?:.*)} $uri -> proto

  log::log debug "URI::protocol returning $proto"
  return $proto
}

proc ::testcl::URI::query {uri {param ""}} {
  log::log debug "URI::query $uri $param invoked"

  set query ""
  regexp {^.*\?(.+).*} $uri -> query

  if { $param eq "" } {
    log::log debug "URI::query returning whole query string: $query"
    return $query
  }

  foreach parameter [split $query "&"] {
    set splittedparam [split $parameter "="]
    if { [lindex $splittedparam 0] eq $param } {
      set result [lindex $splittedparam 1]
      log::log debug "URI::query returning value of parameter $param: $result"
      return $result
    }
  }

  log::log debug "URI::query did not find a value for $param. Returning blank"
  return ""
}

proc ::testcl::URI::path {uri {start ""} {end ""}} {
  log::log debug "URI::path $uri $start $end invoked"

  regexp {^(?:.+:\/\/[^:/]+)?(?::\d+)?([^?]+)} $uri -> fullpath
  set splitted [lrange [split $fullpath "/"] 0 end-1]

  if { [llength $splitted] eq 0 } {
    log::log debug "URI::path returning blank as no /"
    return ""
  }

  if { $start eq "depth" } {
    set length [expr [llength $splitted] - 1]
    log::log debug "URI::path returning depth $length"
    return $length
  }

  if { $start eq 0 } {
    error {"0 is not a valid start"}
  }
  if { $start eq "" } {
    set start 0
  }
  if { $end eq "" } {
    set end "end"
  }
  if { $start > $end } {
    error {end value not greater than start value}
  }

  set pathelements [lrange $splitted $start $end]
  set path [join $pathelements "/"]/

  if { $start > 0 } {
    set path "/$path"
  }

  set path [string map {// /} $path]

  log::log debug "URI::path returning $path"

  return $path
}

proc ::testcl::URI::compare {uri1 uri2} {
  log::log debug "URI::compare $uri1 $uri2 invoked"

  if { [string tolower [protocol $uri1]] ne [string tolower [protocol $uri2]] } {
    log::log debug "URI::compare returning false because the protocols do not match"
    return 0
  } elseif { [string tolower [host $uri1]] ne [string tolower [host $uri2]] } {
    log::log debug "URI::compare returning false because the hosts do not match"
    return 0
  } elseif { [port $uri1] ne [port $uri2] } {
    log::log debug "URI::compare returning false because the ports do not match"
    return 0
  } elseif { [path $uri1] ne [path $uri2] } {
    log::log debug "URI::compare returning false because the paths do not match"
    return 0
  } elseif { [basename $uri1] ne [basename $uri2] } {
    log::log debug "URI::compare returning false because the basenames do not match"
    return 0
  } elseif { [query $uri1] ne [query $uri2] } {
    log::log debug "URI::compare returning false because the query strings do not match"
    return 0
  } else {
    log::log debug "URI::compare returning true, as all the checks passed"
    return 1
  }
}

