source src/iruleuri.tcl
source src/assert.tcl

namespace import ::testcl::*
namespace import ::testcl::URI::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

#test encoding
assertStringEquals "abcxyz" [encode abcxyz]
assertStringEquals "ABCXYZ" [encode ABCXYZ]
assertStringEquals "0189" [encode 0189]

assertStringEquals "%20" [encode " "] 
assertStringEquals "%21" [encode "!"] 
#assertStringEquals "%22" [encode "\""] 
assertStringEquals "%23" [encode "#"] 
assertStringEquals "%24" [encode "$"] 
assertStringEquals "%25" [encode "%"] 
assertStringEquals "%26" [encode "&"] 
assertStringEquals "%27" [encode "'"] 
assertStringEquals "%28" [encode "("] 
assertStringEquals "%29" [encode ")"] 
assertStringEquals "%2a" [encode "*"] 
assertStringEquals "%2b" [encode "+"] 
assertStringEquals "%2c" [encode ","]
#assertStringEquals "%2d" [encode "-"]
#assertStringEquals "%2e" [encode "."]
assertStringEquals "%2f" [encode "/"] 
assertStringEquals "%3a" [encode ":"] 
assertStringEquals "%3b" [encode ";"]
#assertStringEquals "%3C" [encode "<"]
assertStringEquals "%3d" [encode "="]
#assertStringEquals "%3E" [encode ">"] 
assertStringEquals "%3f" [encode "?"] 
assertStringEquals "%40" [encode "@"]  
assertStringEquals "%5b" [encode "\["]
#assertStringEquals "%5C" [encode "\\"]
assertStringEquals "%5d" [encode "\]"]
#assertStringEquals "%5E" [encode "^"]
#assertStringEquals "%5F" [encode "_"]
#assertStringEquals "%60" [encode "`"]
#assertStringEquals "%7B" [encode "{"]
#assertStringEquals "%7C" [encode "|"]
#assertStringEquals "%7D" [encode "}"]
#assertStringEquals "%7E" [encode "~"]
assertStringEquals "parameter=my URL encoded parameter value with metacharacters (&*@#\[\])" [decode "parameter=my%20URL%20encoded%20parameter%20value%20with%20metacharacters%20(%26*%40%23%5b%5d)"]

assertStringEquals "testcl.com" [host "http://testcl.com/test"]
assertStringEquals "www.google.com" [host "https://www.google.com:443"]

assertStringEquals "index.jsp" [basename "/main/index.jsp?user=test&login=check"]

assertStringEquals "80" [port "http://testcl.com/test"]
assertStringEquals "8889" [port "https://testcl.com:8889/test"]
assertStringEquals "0" [port "file://testcl.com/test"]

assertStringEquals "http" [protocol "http://testcl.com"]
assertStringEquals "https" [protocol "https://testcl.com"]
assertStringEquals "ftp" [protocol "ftp://testcl.com"]
assertStringEquals "" [protocol "/test"]

assertStringEquals "value2" [query "/path/to/file.ext?param1=value1&param2=value2" "param2"]
assertStringEquals "" [query "/path/to/file.ext?param1=value1&param2=value2" "param3"]

assertStringEquals "/path/to/" [path "/path/to/file.ext?param=value"]
assertStringEquals "2" [path "/path/to/file.ext?param=value" depth]
assertStringEquals "/path/to/" [path "/path/to/file.ext?param=value" 1]
assertStringEquals "/to/" [path "/path/to/file.ext?param=value" 2]
assertStringEquals "/to/some/" [path "/path/to/some/crazy/file.ext?param=value" 2 3]

# This is probably a bug
#assertStringEquals "1" [compare "http://testcl.com" "http://testcl.com/"] 
assertStringEquals "1" [compare "http://TesTcl.com/" "http://testcl.com/"] 
assertStringEquals "1" [compare "http://TesTcl.com/" "HTTP://testcl.com/"] 


