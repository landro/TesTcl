rule advanced_pools {

  when HTTP_REQUEST priority 100 {
      
      set new_pool ""
      set hostname [string tolower [getfield [HTTP::host] ":" 1]]      

      if { ! [ catch { set next_step [class match -value -- $hostname equals "foo-datagroup"] } ] } {
          if { $next_step ne "" } {
              set new_pool $next_step
          }
      }

      if { [catch { pool $new_pool } ] } {
          log local0. "Failed to find pool '$new_pool', sending to '[LB::server pool]'"
          pool [LB::server pool]
      }      
  }
}
