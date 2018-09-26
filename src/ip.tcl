package provide testcl 1.0.12
package require log
package require ip

namespace eval ::testcl::IP {
  namespace export addr
  # namespace export IP::client_addr
  # namespace export IP::hops
  # namespace export IP::idle_timeout
  # namespace export IP::intelligence
  # namespace export IP::local_addr
  # namespace export IP::protocol
  # namespace export IP::remote_addr
  # namespace export IP::server_addr
  # namespace export IP::stats
  # namespace export IP::tos
  # namespace export IP::ttl
  # namespace export IP::version
  # namespace export IP::reputation
}

# testcl::IP::addr --
#
# stub for the F5 function IP::addr - Performs comparison of IP address/subnet/supernet to IP address/subnet/supernet. or parses 4 binary bytes into an IPv4 dotted quad address
#
# IP::addr <addr1>[/<mask>] equals <addr2>[/<mask>]
#
# (Not yet implemented)
# IP::addr parse [-swap] <binary field> [<offset>]
# IP::addr <addr1> mask <mask>
# IP::addr parse [-ipv6|-ipv4 [-swap]] <bytearray> [<offset>]
#
proc ::testcl::IP::addr { ip1 op ip2 } {
    log::log debug "testcl::IP::addr $ip1 $op $ip2 invoked"
    if { $op eq "equals" } {
        set mask1 [ip::mask $ip1]
        set mask2 [ip::mask $ip2]

        if {$mask1 != ""} {
            set masked_ip1 $ip1
        } elseif {$mask2 != ""} {
            set masked_ip1 $ip1/$mask2
        } else {
            set masked_ip1 $ip1
        }

        if {$mask2 != ""} {
            set masked_ip2 $ip2
        } elseif {$mask1 != ""} {
            set masked_ip2 $ip2/$mask1
        } else {
            set masked_ip2 $ip2
        }

        return [ip::equal $masked_ip1 $masked_ip2]
    } else {
        return 0
    }
}
