rule cookie {
  when HTTP_REQUEST {
    set c [HTTP::cookie "testcookie"]
    switch -- c {
      pos {
        pool pos
      }
      named {
        pool named
      }
      directive {
        pool directive
      }
    }
  }
}
