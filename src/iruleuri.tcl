package provide testcl 1.0.6
package require log

package require base64

namespace eval ::testcl::URI {

  proc ::testcl::URI::encode {uri} {
	  
    #TODO 
    # Implement encoding
    log::log debug "Encoding $uri"
    return "encoded $uri"  
  }
	
}