package provide testcl 1.0.9
package require log

package require base64

namespace eval ::testcl::URI {
	
  namespace export encode 
  namespace export host
	
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

