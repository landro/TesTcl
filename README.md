# Introduction

**TesTcl** is a [Tcl](http://en.wikipedia.org/wiki/Tcl) library for unit testing
[iRules](https://devcentral.f5.com/HotTopics/iRules/tabid/1082202/Default.aspx) which 
are used when configuring [F5 BigIP](http://www.f5.com/products/big-ip/) devices.
The goal of this library is to make it easy to unit test iRules used when load balancing HTTP traffic.

## Getting started

If you're familiar with unit testing and [mocking](http://en.wikipedia.org/wiki/Mock_object) in particular,
using TesTcl should't be to hard. Check out the examples below:

### Simple example

Let's say you want to test the following simple iRule found in *simple_irule.tcl*:

    rule simple {

      when HTTP_REQUEST {
        if { [HTTP::uri] starts_with "/foo" } {
          pool foo
        } else {
          pool bar
        }
      }

    }

Now, create a file called *test_simple_irule.tcl* containing the following lines:

    package require -exact testcl 0.8.1
    namespace import ::testcl::*

    # Comment in to enable logging
    #log::lvSuppressLE info 0
    
    it "should handle request using pool bar" {
      event HTTP_REQUEST
      on HTTP::uri return "/bar"
      endstate pool bar
      run simple_irule.tcl simple
    }

    it "should handle request using pool foo" {
      event HTTP_REQUEST
      on HTTP::uri return "/foo/admin"
      endstate pool foo
      run simple_irule.tcl simple
    }

#### Installing JTcl including jtcl-irule extensions

##### Install JTcl
Download [JTcl](http://jtcl.kenai.com/), unzip it and add it to your path.

##### Add jtcl-irule to your JTcl installation
Add the [jtcl-irule](http://landro.github.com/jtcl-irule/) extension to JTcl. If you don't have the time to build it yourself, you can download the 
jar artifact from the [downloads](https://github.com/landro/TesTcl/downloads) section or you can use the direct [link](https://github.com/downloads/landro/TesTcl/jtcl-irule.jar).
Next, copy the jar file into the directory where you installed JTcl.
Add jtcl-irule to the classpath in _jtcl_ or _jtcl.bat_.
Put the following line just above the last line in the script

    export CLASSPATH=$dir/jtcl-irule.jar:$CLASSPATH

##### Verify installation

Create a script file named *jtcl test_jtcl_irule.tcl* containing the following lines 

    if {"aa" starts_with "a"} {
      puts "The jtcl-irule extension has successfully been installed"
    }

and execute it using 

    jtcl test_jtcl_irule.tcl

You should get a success message.

##### Add the testcl library to your library path
Download directory containing all the files found in this project (zip and tar.gz can be downloaded from this page)
Unzip, and add unzipped directory to the [TCLLIBPATH](http://jtcl.kenai.com/gettingstarted.html) environment variable:

    export TCLLIBPATH=whereever/landro-TesTcl-b93b1b4

In order to run this example, type in the following at the command-line:

    >jtcl test_simple_irule.tcl

This should give you the following output:

    **************************************************************************
    * it should handle request using pool bar
    **************************************************************************
    -> Test ok

    **************************************************************************
    * it should handle request using pool foo
    **************************************************************************
    -> Test ok

#### Explanations

- Require the **testcl** package and import the commands and variables found in the **testcl** namespace to use it.
- Enable or disable logging
- Add the specification tests
  - Describe every _it_ statement as precisely as possible.  
  - Add an _event_ . This is mandatory.
  - Add one or several _on_ statements to setup expectations/mocks. If you don't care about the return value, return "".
  - Add an _endstate_. This could be a _pool_, _HTTP::respond_ or _HTTP::redirect_ call . This is mandatory.
  - Add a _run_ statement in order to actually run the Tcl script file containing your iRule. This is mandatory.

#### Avoiding code duplication using the before command

In order to avoid code duplication, one can use the _before_ command.
The argument passed to the _before_ command will be executed _before_ the following _it_ specifications.

Using the _before_ command, *test_simple_irule.tcl* can be rewritten as:

    package require -exact testcl 0.8.1
    namespace import ::testcl::*

    # Comment in to enable logging
    #log::lvSuppressLE info 0

    before {
      event HTTP_REQUEST
    }

    it "should handle request using pool bar" {
      on HTTP::uri return "/bar"
      endstate pool bar
      run simple_irule.tcl simple
    }

    it "should handle request using pool foo" {
      on HTTP::uri return "/foo/admin"
      endstate pool foo
      run simple_irule.tcl simple
    }

On a side note, it's worth mentioning that there is no _after_ command, since we're always dealing with mocks.

### Advanced example

Let's have a look at a more advanced iRule (advanced_irule.tcl):

    rule advanced {

      when HTTP_REQUEST {

        HTTP::header insert X-Forwarded-SSL true

        if { [HTTP::uri] eq "/admin" } {
          if { ([HTTP::username] eq "admin") && ([HTTP::password] eq "password") } {
            set newuri [string map {/admin/ /} [HTTP::uri]]
            HTTP::uri $newuri
            pool pool_admin_application
          } else {
            HTTP::respond 401 WWW-Authenticate "Basic realm=\"Restricted Area\""
          }
        } elseif { [HTTP::uri] eq "/blocked" } {
          HTTP::respond 403
        } elseif { [HTTP::uri] eq "/app"} {
          if { [active_members pool_application] == 0 } {
            if { [HTTP::header User-Agent] eq "Apache HTTP Client" } {
              HTTP::respond 503
            } else {
              HTTP::redirect "http://fallback.com"
            }
          } else {
            set newuri [string map {/app/ /} [HTTP::uri]]
            HTTP::uri $newuri
            pool pool_application
          }
        } else {
          HTTP::respond 404
        }

      }

    }

The specs for this iRule would look like this:

    package require -exact testcl 0.8.1
    namespace import ::testcl::*

    # Comment out to suppress logging
    #log::lvSuppressLE info 0

    before {
      event HTTP_REQUEST
      on HTTP::header insert X-Forwarded-SSL true return ""
    }

    it "should handle admin request using pool admin when credentials are valid" {
      on HTTP::uri return "/admin"
      on HTTP::username return "admin"
      on HTTP::password return "password"
      on HTTP::uri /admin return ""
      endstate pool pool_admin_application
      run advanced_irule.tcl advanced
    }

    it "should ask for credentials when admin request without correct credentials" {
      on HTTP::uri return "/admin"
      on HTTP::username return "not_admin"
      on HTTP::password return "wrong_password"
      endstate HTTP::respond 401 WWW-Authenticate "Basic realm=\"Restricted Area\""
      run advanced_irule.tcl advanced
    }

    it "should block access to uri /blocked" {
      on HTTP::uri return "/blocked"
      endstate HTTP::respond 403
      run advanced_irule.tcl advanced
    }

    it "should give apache http client a correct error code when app pool is down" {
      on HTTP::uri return "/app"
      on active_members pool_application return 0
      on HTTP::header User-Agent return "Apache HTTP Client"
      endstate HTTP::respond 503
      run advanced_irule.tcl advanced
    }

    it "should give other clients then apache http client redirect to fallback when app pool is down" {
      on HTTP::uri return "/app"
      on active_members pool_application return 0
      on HTTP::header User-Agent return "Firefox 13.0.1"
      endstate HTTP::redirect "http://fallback.com"
      run advanced_irule.tcl advanced
    }

    it "should give handle app request using app pool when app pool is up" {
      on HTTP::uri return "/app"
      on HTTP::uri /app return ""
      on active_members pool_application return 2
      endstate pool pool_application
      run advanced_irule.tcl advanced
    }

    it "should give 404 when request cannot be handled" {
      on HTTP::uri return "/cannot_be_handled"
      endstate HTTP::respond 404
      run advanced_irule.tcl advanced
    }

## How stable is this code?
This work is quite stable, but you can expect minor breaking changes.

## Why I created this project

Configuring BigIP devices is no trivial task, and typically falls in under a DevOps kind of role.
In order to make your system perform the best it can, you need:

- In-depth knowledge about the BigIP system (typically requiring at least a [$1,995 3-day course](http://www.f5.com/services/global-training/course-descriptions/big-ip-ltm-essentials.html))
- In-depth knowledge about the web application being load balanced 
- The Tcl language and the iRule extensions
- And finally: _A way to test your iRules_

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

## License

Just like JTcl, TesTcl is licensed under a BSD-style license.

## Please please please

drop me a line if you use this library or have any issues with it: stefan.landro **you know what** gmail.com