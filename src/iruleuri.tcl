package provide testcl 1.0.12
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

  set utf8_uri [encoding convertto utf-8 $uri]

  set encodedString [string map {
    " " "%20"
    "!" "%21"
    "\"" "%22"
    "#" "%23"
    "\$" "%24"
    "%" "%25"
    "&" "%26"
    "'" "%27"
    "(" "%28"
    ")" "%29"
    "*" "%2a"
    "+" "%2b"
    "," "%2c"
    "/" "%2f"
    ":" "%3a"
    ";" "%3b"
    "<" "%3c"
    "=" "%3d"
    ">" "%3e"
    "?" "%3f"
    "@" "%40"
    "\[" "%5b"
    "\\" "%5c"
    "\]" "%5d"
    "^" "%5e"
    "`" "%60"
    "\{" "%7b"
    "|" "%7c"
    "\}" "%7d"
  } $utf8_uri]

  log::log debug "Encoding $uri to $encodedString"
  return $encodedString
}

proc ::testcl::URI::decode {uri} {

  set decodedString [string map {
    "%20" " "
    "%21" "!"
    "%22" "\""
    "%23" "#"
    "%24" "\$"
    "%25" "%"
    "%26" "&"
    "%27" "'"
    "%28" "("
    "%29" ")"
    "%2A" "*" "%2a" "*"
    "%2B" "+" "%2b" "+"
    "%2C" "," "%2c" ","
    "%2D" "-" "%2d" "-"
    "%2E" "." "%2e" "."
    "%2F" "/" "%2f" "/"
    "%30" "0"
    "%31" "1"
    "%32" "2"
    "%33" "3"
    "%34" "4"
    "%35" "5"
    "%36" "6"
    "%37" "7"
    "%38" "8"
    "%39" "9"
    "%3A" ":" "%3a" ":"
    "%3B" ";" "%3b" ";"
    "%3C" "<" "%3c" "<"
    "%3D" "=" "%3d" "="
    "%3E" ">" "%3e" ">"
    "%3F" "?" "%3f" "?"
    "%40" "@"
    "%41" "A"
    "%42" "B"
    "%43" "C"
    "%44" "D"
    "%45" "E"
    "%46" "F"
    "%47" "G"
    "%48" "H"
    "%49" "I"
    "%4A" "J" "%4a" "J"
    "%4B" "K" "%4b" "K"
    "%4C" "L" "%4c" "L"
    "%4D" "M" "%4d" "M"
    "%4E" "N" "%4e" "N"
    "%4F" "O" "%4f" "O"
    "%50" "P"
    "%51" "Q"
    "%52" "R"
    "%53" "S"
    "%54" "T"
    "%55" "U"
    "%56" "V"
    "%57" "W"
    "%58" "X"
    "%59" "Y"
    "%5A" "Z" "%5a" "Z"
    "%5B" "\[" "%5b" "\["
    "%5C" "\\" "%5c" "\\"
    "%5D" "\]" "%5d" "\]"
    "%5E" "^" "%5e" "^"
    "%5F" "_" "%5f" "_"
    "%60" "`"
    "%61" "a"
    "%62" "b"
    "%63" "c"
    "%64" "d"
    "%65" "e"
    "%66" "f"
    "%67" "g"
    "%68" "h"
    "%69" "i"
    "%6A" "j" "%6a" "j"
    "%6B" "k" "%6b" "k"
    "%6C" "l" "%6c" "l"
    "%6D" "m" "%6d" "m"
    "%6E" "n" "%6e" "n"
    "%6F" "o" "%6f" "o"
    "%70" "p"
    "%71" "q"
    "%72" "r"
    "%73" "s"
    "%74" "t"
    "%75" "u"
    "%76" "v"
    "%77" "w"
    "%78" "x"
    "%79" "y"
    "%7A" "z" "%7a" "z"
    "%7B" "\{" "%7b" "\{"
    "%7C" "|" "%7c" "|"
    "%7D" "\}" "%7d" "\}"
    "%7E" "~" "%7e" "~"
  } $uri]

  log::log debug "Decoding $uri to $decodedString"
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
  set uriListToCompare "$uri1 $uri2"
  log::log debug "URI::compare $uriListToCompare invoked"

  if {[llength $uriListToCompare] != 2} {
    log::log error "URI::compare number of arguments invalid, expecting 2 but got [llength $uriListToCompare], returning false!"
    return 0
  }

  set urisToTest {}

  # Loop over URIs and produces full decoded string of <protocol>://<host>:<port><path>/<basename>?<query>
  foreach uri $uriListToCompare {
    set tempUri ""
    if {!($uri starts_with "/")} {
      append tempUri "[string tolower [protocol $uri]]://[string tolower [host $uri]]:[port $uri]"
    }

    if {[path $uri] == ""} {
      append tempUri [decode "/?[query $uri]"]
    } else {
      append tempUri [decode "[path $uri][basename $uri]?[query $uri]"]
    }
    lappend urisToTest $tempUri
  }

  if {[lindex $urisToTest 0] == [lindex $urisToTest 1]} {
    log::log debug "URI::compare returning true, [lindex $urisToTest 0] matches [lindex $urisToTest 1]"
    return 1
  } else {
    log::log debug "URI::compare returning false, [lindex $urisToTest 0] does not match [lindex $urisToTest 1]"
    return 0
  }
}
