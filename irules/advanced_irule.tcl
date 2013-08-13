rule advanced {

  when HTTP_REQUEST {

    HTTP::header insert X-Forwarded-SSL true

    if { [HTTP::uri] eq "/admin" } {
      if { ([HTTP::username] eq "admin") && ([HTTP::password] eq "password") } {
        set newuri [string map {/admin/ /} [HTTP::uri]]
        HTTP::uri $newuri
        pool pool_admin_application
      } else {
        HTTP::respond 401 WWW-Authenticate "Basic realm=\"Restricted Area\""
      }
    } elseif { [HTTP::uri] eq "/blocked" } {
      HTTP::respond 403
    } elseif { [HTTP::uri] eq "/app"} {
      if { [active_members pool_application] == 0 } {
        if { [HTTP::header User-Agent] eq "Apache HTTP Client" } {
          HTTP::respond 503
        } else {
          HTTP::redirect "http://fallback.com"
        }
      } else {
        set newuri [string map {/app/ /} [HTTP::uri]]
        HTTP::uri $newuri
        pool pool_application
      }
    } else {
      HTTP::respond 404
    }
  }


  when HTTP_RESPONSE {
    HTTP::header remove "Vary"
    HTTP::header insert Vary "Accept-Encoding"
  }

}
