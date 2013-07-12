rule headers {

  #notify backend about SSL using X-Forwarded-SSL http header
  #if there is client certificate put common name into X-Common-Name-SSL http header
  #if not make sure X-Common-Name-SSL header is not set
  when HTTP_REQUEST {
    HTTP::header insert X-Forwarded-SSL true
    HTTP::header remove X-Common-Name-SSL

    if { [SSL::cert count] > 0 } {
      set ssl_cert [SSL::cert 0]
      set subject [X509::subject $ssl_cert]
      set cn ""
      foreach { label value } [split $subject ",="] {
        set label [string toupper [string trim $label]]
        set value [string trim $value]

        if { $label == "CN" } {
          set cn "$value"
          break
        }
      }

      HTTP::header insert X-Common-Name-SSL "$cn"
    }
  }

}
