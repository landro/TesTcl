proc when {condition body} {
   puts "when $condition"
   set rc [catch $body result]
   puts "when $condition finished, return code: $rc  result: $result"
}