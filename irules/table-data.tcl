rule table-data {
  when CLIENT_ACCEPTED {
    switch [IP::client_addr] {
      172.18.200.20 {
        set lmt 35
        set lab foo
      }

      default {
        set lmt 1000
        set lab other
      }
    }
  }
}
