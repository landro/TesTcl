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
- And finally: _A way to test your iRules_

## Testing iRules

Most shops test iRules [manually](http://en.wikipedia.org/wiki/Manual_testing), the procedure typically being a variation of the following:

- Create/edit iRule
- Add log statements that show execution path
- Push iRule to staging/QA environment
- Bring backend servers up and down **manually** as required to test fallback scenarios
- Generate HTTP-traffic using a browser and verify **manually** everything works as expected
- Verify log entries **manually**
- Remove or disable log statements
- Push iRule to production environment
- Verify **manually** everything works as expected 

There are lots of issues with this **manual** approach:

- Using log statements for testing and debugging messes up your code, and you still have to look through the logs **manually**
- Potentially using different iRules in QA and production make automated deployment procedures harder
- Bringing servers up and down to test fallback scenarios can be quite tedious
- **Manual** verification steps are prone to error
- **Manual** testing takes a lot of time
- Development roundtrip-time is forever, since deployment to BigIP sometimes can take several minutes

Clearly, **manual** testing is not the way forward!

Enough said about manual testing. Let's talk about unit testing iRules using TesTcl!

## Example

If you're familiar with unit testing and [mocking](http://en.wikipedia.org/wiki/Mock_object) in particular,
using TesTcl should't be to hard. I'll add thorough examples soon, but until then, have a look at
[test_advanced_irule_it.tcl](https://github.com/landro/TesTcl/blob/master/test_advanced_irule_it.tcl)
in the source repository.

## How stable is this code?
This work is still undergoing quite some development so you can expect minor breaking changes.

## Todos

- Some kind of describe command to avoid code duplication
- Some kind of setup / teardown to avoid code duplication
- Implement Tcl package to make code easier to use
- Documentation
- Implement irule extensions to Tcl (operators like starts_with etc)