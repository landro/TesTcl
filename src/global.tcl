package provide testcl 1.0.14
package require log

namespace eval ::testcl {
    variable availablePools [list]
    variable currentPool
  # namespace export accumulate
  # namespace export active_members
  # namespace export active_nodes
  # namespace export after
  # namespace export b64decode
  # namespace export b64encode
  # namespace export call
  # namespace export CATEGORY::lookup
  # namespace export class
  # namespace export client_addr
  # namespace export client_port
  # namespace export clientside
  # namespace export clone
  # namespace export cpu
  # namespace export crc32
  # namespace export decode_uri
  # namespace export DEMANGLE::disable
  # namespace export DEMANGLE::enable
  # namespace export discard
  # namespace export domain
  # namespace export drop
  # namespace export event
  # namespace export findclass
  # namespace export findstr
  # namespace export forward
  # namespace export FTP::port
  namespace export getfield
  # namespace export HA::status
  # namespace export htonl
  # namespace export htons
  # namespace export http_cookie
  # namespace export http_header
  # namespace export http_host
  # namespace export http_method
  # namespace export http_uri
  # namespace export http_version
  # namespace export iFile
  # namespace export imid
  # namespace export ip_protocol
  # namespace export ip_tos
  # namespace export ip_ttl
  # namespace export lasthop
  # namespace export link_qos
  # namespace export listen
  # namespace export llookup
  # namespace export local_addr
  namespace export log
  # namespace export matchclass
  # namespace export md5
  # namespace export members
  # namespace export nexthop
  # namespace export node
  # namespace export nodes
  # namespace export ntohl
  # namespace export ntohs
  # namespace export Operators
  # namespace export peer
  # namespace export persist
   namespace export pool
  # namespace export priority
  # namespace export rateclass
  # namespace export redirect
  # namespace export reject
  # namespace export relate_client
  # namespace export relate_server
  # namespace export remote_addr
  # namespace export RESOLV::lookup
  # namespace export return
  # namespace export rmd160
  # namespace export server_addr
  # namespace export server_port
  # namespace export serverside
  # namespace export session
  # namespace export sha1
  # namespace export sha256
  # namespace export sha384
  # namespace export sha512
  # namespace export sharedvar
  # namespace export SMTPS::disable
  # namespace export SMTPS::enable
  # namespace export snat
  # namespace export snatpool
  # namespace export substr
  # namespace export table
  # namespace export tcl_platform
  # namespace export timing
  # namespace export TMM::cmp_count
  # namespace export TMM::cmp_group
  # namespace export TMM::cmp_unit
  # namespace export traffic_group
  # namespace export translate
  # namespace export urlcatquery
  # namespace export use
  # namespace export virtual
  # namespace export vlan_id
  # namespace export when
  # namespace export whereis
}


# testcl::getfield --
#
# stub for the iRule GLOBAL::getfield - Splits a string on a character or string. and returns the string corresponding to the specific field.
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
proc ::testcl::getfield { str delim ind } {
  log::log debug "GLOBAL::getfield $str $delim $ind invoked"

  if { [string len $delim] == 1 } {
    return [lindex [split $str $delim] [expr {$ind - 1}]]	  	  
  }
  # See https://gist.github.com/ncimino/5526288
  set mc \x00
  return [lindex [split [string map [list $delim $mc] $str] $mc] [expr {$ind - 1}]]
}

# testcl::log --
#
# stub for the iRule GLOBAL::log - Generates and logs a message to the syslog-ng utility.
#
# Arguments:
# facility.level  - facility is ignored, level is passed through to the underlying test logger
# msg             - the message to log
#
# Side Effects:
# None.
#
# Usage syntax:
# log [-noname] <facility>.<level> <message>
#
proc ::testcl::log { faclvl msg } {
    set level [lindex [split $faclvl "."] 1]

    if { $level eq "" } {
        set level "info"
    }

    log::log $level $msg
}

proc ::testcl::pool { name } {

   variable availablePools
   variable currentPool

   log::log debug "Available pools  => $availablePools"
   log::log debug "Target pool name  => $name"

   set rc [catch {lsearch -exact $availablePools $name} found]

   log::log debug "rc=$rc found=$found"

   if { $found >= 0} {

       set currentPool $name

       log::log debug "Current pool is now => $currentPool"
       
       return -code 0 "pool $name"
   }
   
   return -code 1000 "pool $name"

}
