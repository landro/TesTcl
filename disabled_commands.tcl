# The following web-page documents which Tcl commands are disabled in iRules
# https://devcentral.f5.com/wiki/iRules.DisabledTclCommands.ashx

# after (enabled in 10.x)
# rename after ::tcl::after

rename auto_execok ::tcl::auto_execok
rename auto_import ::tcl::auto_import
rename auto_load ::tcl::auto_load
rename auto_mkindex ::tcl::auto_mkindex
rename auto_mkindex_old ::tcl::auto_mkindex_old
rename auto_qualify ::tcl::auto_qualify
rename auto_reset ::tcl::auto_reset
rename bgerror ::tcl::bgerror
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
rename file ::tcl::file
rename fileevent ::tcl::fileevent
rename filename ::tcl::filename
rename flush ::tcl::flush
rename gets ::tcl::gets
rename glob ::tcl::glob
rename http ::tcl::http
rename interp ::tcl::interp
rename load ::tcl::load
rename lrepeat ::tcl::lrepeat
rename lreverse ::tcl::lreverse
rename memory ::tcl::memory
rename namespace ::tcl::namespace
rename open ::tcl::open
rename package ::tcl::package
rename pid ::tcl::pid
rename pkg::create ::tcl::pkg::create
rename pkg_mkIndex ::tcl::pkg_mkIndex
rename proc ::tcl::proc
rename pwd ::tcl::pwd
rename seek ::tcl::seek
rename socket ::tcl::socket
rename source ::tcl::source
rename tcl_findLibrary ::tcl::tcl_findLibrary
rename tell ::tcl::tell
rename time ::tcl::time
rename unknown ::tcl::unknown
rename update ::tcl::update
rename uplevel ::tcl::uplevel
rename upvar ::tcl::upvar
rename vwait ::tcl::vwait
rename rename ::tcl::rename