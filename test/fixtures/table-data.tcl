rule table-data {
  when CLIENT_ACCEPTED {
    switch [IP::client_addr] {
      172.18.200.20 {
        set lmt 35
        set lab foo
      }

      10.176.49.90 {
        set lmt 2
        set lab bar
      }

      10.176.49.91 {
        set lmt 2
        set lab bar
      }

      10.176.49.92 {
        set lmt 2
        set lab bar
      }

      default {
        set lmt 1000
        set lab other
      }
    }
  }
}
