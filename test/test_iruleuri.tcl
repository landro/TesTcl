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
#assertStringEquals "%25" [encode "%"] 
assertStringEquals "%26" [encode "&"] 
assertStringEquals "%27" [encode "'"] 
assertStringEquals "%28" [encode "("] 
assertStringEquals "%29" [encode ")"] 
#assertStringEquals "%2A" [encode "*"] 
#assertStringEquals "%2B" [encode "+"] 
#assertStringEquals "%2C" [encode ","]
#assertStringEquals "%2D" [encode "-"]
#assertStringEquals "%2E" [encode "."]
#assertStringEquals "%2F" [encode "/"] 
#assertStringEquals "%3A" [encode ":"] 
#assertStringEquals "%3B" [encode ";"]
#assertStringEquals "%3C" [encode "<"]
#assertStringEquals "%3D" [encode "="]
#assertStringEquals "%3E" [encode ">"] 
#assertStringEquals "%3F" [encode "?"] 
#assertStringEquals "%40" [encode "@"]  
#assertStringEquals "%5B" [encode "\["]
#assertStringEquals "%5C" [encode "\\"]
#assertStringEquals "%5D" [encode "\]"]
#assertStringEquals "%5E" [encode "^"]
#assertStringEquals "%5F" [encode "_"]
#assertStringEquals "%60" [encode "`"]
#assertStringEquals "%7B" [encode "{"]
#assertStringEquals "%7C" [encode "|"]
#assertStringEquals "%7D" [encode "}"]
#assertStringEquals "%7E" [encode "~"]




