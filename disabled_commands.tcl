# The following web-page documents which Tcl commands are disabled in iRules
# https://devcentral.f5.com/wiki/iRules.DisabledTclCommands.ashx

# Consider disabling if running old version
# after (enabled in 10.x)
# rename after ::tcl::after

# Commands not found in JTcl
################################################

#rename auto_mkindex ::tcl::auto_mkindex
#rename auto_mkindex_old ::tcl::auto_mkindex_old
#rename auto_reset ::tcl::auto_reset
#rename bgerror ::tcl::bgerror
#rename http ::tcl::http
#rename load ::tcl::load
#rename memory ::tcl::memory
#rename pkg::create ::tcl::pkg::create
#rename pkg_mkIndex ::tcl::pkg_mkIndex
#rename tcl_findLibrary ::tcl::tcl_findLibrary
#rename filename ::tcl::filename

#  Commnands used by JTcl internally 
################################################

#rename file ::tcl::file
#rename interp ::tcl::interp

# Commands used by TesTcl
################################################

#rename namespace ::tcl::namespace
#rename package ::tcl::package
#rename proc ::tcl::proc
#rename source ::tcl::source
#rename unknown ::tcl::unknown
#rename rename ::tcl::rename

# Commands used by log package
################################################

#rename flush ::tcl::flush

# Disabled commands
################################################

rename auto_execok ::tcl::auto_execok
rename auto_import ::tcl::auto_import
rename auto_load ::tcl::auto_load
rename auto_qualify ::tcl::auto_qualify
rename cd ::tcl::cd
rename close ::tcl::close
rename dict ::tcl::dict
rename eof ::tcl::eof
rename encoding ::tcl::encoding
rename exec ::tcl::exec
rename exit ::tcl::exit
rename fblocked ::tcl::fblocked
rename fconfigure ::tcl::fconfigure
rename fcopy ::tcl::fcopy
rename fileevent ::tcl::fileevent
rename gets ::tcl::gets
rename glob ::tcl::glob
rename lrepeat ::tcl::lrepeat
rename lreverse ::tcl::lreverse
rename open ::tcl::open
rename pid ::tcl::pid
rename pwd ::tcl::pwd
rename seek ::tcl::seek
rename socket ::tcl::socket
rename tell ::tcl::tell
rename time ::tcl::time
rename update ::tcl::update
rename uplevel ::tcl::uplevel
rename upvar ::tcl::upvar
rename vwait ::tcl::vwait