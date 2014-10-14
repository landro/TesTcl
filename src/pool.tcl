package provide testcl 1.0.6

namespace eval ::testcl::_pool {
  variable currentPool ""
}

proc ::testcl::_pool::setCurrent {name} {
  variable currentPool
  set currentPool $name
}

proc ::testcl::_pool::get {} {
  variable currentPool
  return $currentPool
}

proc ::testcl::pool {name} {
  _pool::setCurrent $name
}

proc ::testcl::currentPool {} {
  return [_pool::get]
}
