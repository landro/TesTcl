when HTTP_REQUEST {
  #starts_with "/foo" 
  if { [regexp {^/foo} [HTTP::uri]] } {
    pool foo
  } else {
    pool bar
  }
}