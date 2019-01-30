package require -exact testcl 1.0.13
namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

before {
  event HTTP_REQUEST

  class configure foo-datagroup {
      "some.host.com" "go_to_bar"
  }

  on LB::server pool return fallback
}

it "should set the right pool when available" {

  given_pools fallback go_to_bar

  HTTP::header insert Host "some.host.com"

  verify "Final pool is the expected one after a match" "go_to_bar" eq { endstate_pool }
  
  run irules/advanced_pool_verification_irule.tcl advanced_pools
}

it "should fallback to default LB::server default pool if nothing matches" {

  given_pools fallback go_to_bar

  on HTTP::uri return "http://wont.match/admin"

  verify "Final pool should be defaults" "fallback" eq { endstate_pool }
  
  run irules/advanced_pool_verification_irule.tcl advanced_pools
}
