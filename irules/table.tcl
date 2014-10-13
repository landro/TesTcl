rule table {
  when CLIENT_ACCEPTED {
    set tbl "connlimit:$lab"

    set count [table keys -subtable $tbl -count]

    set key "[IP::client_addr]:$count"
    if { $count >= $lmt } {
      event CLIENT_CLOSED disable
      log local0. "$tbl connection limit $lmt - rejected [IP::client_addr]"
      reject
    } else {
      table set -subtable $tbl $key "ignored" 180
      set timer [after 60000 -periodic { table lookup -subtable $tbl $key }]
    }
  }

  when CLIENT_CLOSED {
    table delete -subtable $tbl $key
    after cancel $timer
  }
}
