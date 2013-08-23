# The following web-page documents which Tcl commands are disabled in iRules
# https://devcentral.f5.com/wiki/iRules.DisabledTclCommands.ashx

proc saferename {from to} {
  if {[info procs $from] eq $from || [info commands $from] eq $from} {
    rename $from $to
  }
}

# Consider disabling if running old version
# after (enabled in 10.x)
# saferename after ::tcl::after

# Commands not found in JTcl
################################################

#saferename auto_mkindex ::tcl::auto_mkindex
#saferename auto_mkindex_old ::tcl::auto_mkindex_old
#saferename auto_reset ::tcl::auto_reset
#saferename bgerror ::tcl::bgerror
#saferename http ::tcl::http
#saferename load ::tcl::load
#saferename memory ::tcl::memory
#saferename pkg::create ::tcl::pkg::create
#saferename pkg_mkIndex ::tcl::pkg_mkIndex
#saferename tcl_findLibrary ::tcl::tcl_findLibrary
#saferename filename ::tcl::filename

#  Commnands used by JTcl internally 
################################################

#saferename file ::tcl::file
#saferename interp ::tcl::interp

# Commands used by TesTcl
################################################

#saferename namespace ::tcl::namespace
#saferename package ::tcl::package
#saferename proc ::tcl::proc
#saferename source ::tcl::source
#saferename unknown ::tcl::unknown
#saferename rename ::tcl::rename

# Commands used by log package
################################################

#saferename flush ::tcl::flush

# Disabled commands
################################################

saferename auto_execok ::tcl::auto_execok
saferename auto_import ::tcl::auto_import
saferename auto_load ::tcl::auto_load
saferename auto_qualify ::tcl::auto_qualify
saferename cd ::tcl::cd
saferename close ::tcl::close
saferename dict ::tcl::dict
saferename eof ::tcl::eof
saferename encoding ::tcl::encoding
saferename exec ::tcl::exec
saferename exit ::tcl::exit
saferename fblocked ::tcl::fblocked
saferename fconfigure ::tcl::fconfigure
saferename fcopy ::tcl::fcopy
saferename fileevent ::tcl::fileevent
saferename gets ::tcl::gets
saferename glob ::tcl::glob
saferename lrepeat ::tcl::lrepeat
saferename lreverse ::tcl::lreverse
saferename open ::tcl::open
saferename pid ::tcl::pid
saferename pwd ::tcl::pwd
saferename seek ::tcl::seek
saferename socket ::tcl::socket
saferename tell ::tcl::tell
saferename time ::tcl::time
saferename update ::tcl::update
saferename uplevel ::tcl::uplevel
saferename upvar ::tcl::upvar
saferename vwait ::tcl::vwait

rename saferename {}
