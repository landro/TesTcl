# Introduction

**TesTcl** is a [Tcl](http://en.wikipedia.org/wiki/Tcl) framework for unit testing 
[iRules](https://devcentral.f5.com/HotTopics/iRules/tabid/1082202/Default.aspx) which 
are used when configuring [F5 BigIP](http://www.f5.com/products/big-ip/) devices.
The goal of this framework is to make it easy to unit test iRules used when load balancing HTTP traffic.

## The challenge

Configuring BigIP devices is no trivial task, and typically falls in under a DevOps kind of role.
In order to make your system perform the best it can, you need:

- In-depth knowledge about the BigIP system (typically requiring at least a [$1,995 3-day course](http://www.f5.com/services/global-training/course-descriptions/big-ip-ltm-essentials.html))
- In-depth knowledge about the web application being load balanced 
- The Tcl language and the iRule extensions
- And finally: _A way to test your iRule (knowing that a BigIP device costs big money)_

## The solution

Most shops test iRules [manually](http://en.wikipedia.org/wiki/Manual_testing), the procedure typically being:

- Create/edit iRule
- Push iRule to staging/qa environment
- Bring backend servers up and down **manually** as required to test fallback scenarios
    - Inspect HTTP-traffic between a browser and your application **manually**, and verify **manually** everything works as expected
- Push iRule to production environment
    - Verify **manually** everything works as expected 

## Example

Have a look at _test_advanced_irule_it.tcl_ 

## How stable is this code?
This work is still undergoing quite some development so you can expect minor breaking changes.

## Todos

- Some kind of describe command to avoid code duplication
- Implement Tcl package to make code easier to use
- Documentation
- Implement irule extensions to Tcl (operators like starts_with etc)
