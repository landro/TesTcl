proc when {condition body} {
   set rc [catch $body result]
   puts "when $condition finished, return code: $rc  result: $result"
  global errorInfo 
  puts $errorInfo
  global errorCode 
  puts $errorCode
  
}