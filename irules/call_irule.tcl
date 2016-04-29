rule call {

  proc Redirect {url} {
    
    HTTP::redirect $url

  }

  when HTTP_REQUEST {

    set lowerUri [string tolower [HTTP::uri]]
    set lowerHost [string tolower [HTTP::host]]

    call Redirect https://$lowerHost$lowerUri
	  
  }
    
}