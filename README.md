# Introduction

**TesTcl** is a Tcl framework for testing [iRules](https://devcentral.f5.com/HotTopics/iRules/tabid/1082202/Default.aspx) which 
are used when configuring [F5 BigIP](http://www.f5.com/products/big-ip/) devices.
In particular, the goal of this framework is to be able to unit test iRules used when load balancing HTTP traffic.

This work is still undergoing quite some development - expect breaking changes

## Example

Have a look at _test_advanced_irule_it.tcl_ 

## Todos

- Some kind of describe command
- Implement Tcl package
- Documentation
- Implement irule extensions to Tcl (operators like starts_with etc)
