rule simple {

  when HTTP_REQUEST {
    #starts_with "/foo" 
    if { [regexp {^/foo} [HTTP::uri]] } {
      pool foo
    } else {
      set encodedUri [URI::encode [HTTP::uri]]
      pool bar
    }
  }

  when HTTP_RESPONSE {
    HTTP::header remove "Vary"
    HTTP::header insert Vary "Accept-Encoding"
  }

}
