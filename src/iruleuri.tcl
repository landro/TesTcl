package provide testcl 1.0.9
package require log

package require base64

namespace eval ::testcl::URI {
	
  namespace export encode 
  namespace export host
  namespace export basename
  namespace export port
  namespace export protocol
  namespace export query
	
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
      } else {
        log::log critical "Not converting char $char - to be implemented in iruleuri.tcl"    
        append encodedString "$char"		  		      	            
      }
	      
  }
	
  return $encodedString
	
}

proc ::testcl::URI::host {uri} {
  log::log debug "URI::host $uri invoked"

  set host ""
  regexp {^.+:\/\/([^:/]+)(?::\d+)?\/.*} $uri -> host

  log::log debug "URI::host returning $host"
  return $host
}

proc ::testcl::URI::basename {uri} {
  log::log debug "URI::basename $uri invoked"

  regexp {([^?]+)(?:\?.*)?} $uri -> withoutquery
  set basename [lindex [split $withoutquery "/"] end]

  log::log debug "URI::basename returning $basename"
  return basename
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
  regexp {^([a-z0-9+\-.]+):\/\/(?:.*)} $uri -> proto

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

