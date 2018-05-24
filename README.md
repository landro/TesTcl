# Introduction

**TesTcl** is a [Tcl](http://en.wikipedia.org/wiki/Tcl) library for unit testing
[iRules](https://devcentral.f5.com/HotTopics/iRules/tabid/1082202/Default.aspx) which 
are used when configuring [F5 BIG-IP](http://www.f5.com/products/big-ip/) devices.

## News
- 23rd March 2017 - Version [1.0.10](https://github.com/landro/TesTcl/releases) released
- 29th April 2016 - Version [1.0.9](https://github.com/landro/TesTcl/releases) released
- 16th December 2015 - Version [1.0.8](https://github.com/landro/TesTcl/releases) released
- 7th August 2015 - Version [1.0.7](https://github.com/landro/TesTcl/releases) released
- 2nd September 2014 - Version [1.0.6](https://github.com/landro/TesTcl/releases) released

## Getting started

If you're familiar with unit testing and [mocking](http://en.wikipedia.org/wiki/Mock_object) in particular,
using TesTcl should't be to hard. Check out the examples below:

### Simple example

Let's say you want to test the following simple iRule found in *simple_irule.tcl*:

```tcl
rule simple {

  when HTTP_REQUEST {
    if { [HTTP::uri] starts_with "/foo" } {
      pool foo
    } else {
      pool bar
    }
  }

  when HTTP_RESPONSE {
    HTTP::header remove "Vary"
    HTTP::header insert Vary "Accept-Encoding"
  }

}
```

Now, create a file called *test_simple_irule.tcl* containing the following lines:

```tcl
package require -exact testcl 1.0.11
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

it "should replace existing Vary http response headers with Accept-Encoding value" {
  event HTTP_RESPONSE
  verify "there should be only one Vary header" 1 == {HTTP::header count vary}
  verify "there should be Accept-Encoding value in Vary header" "Accept-Encoding" eq {HTTP::header Vary}
  HTTP::header insert Vary "dummy value"
  HTTP::header insert Vary "another dummy value"
  run irules/simple_irule.tcl simple
}
```

#### Installing JTcl including jtcl-irule extensions

##### Install JTcl
Download [JTcl](https://jtcl-project.github.io/jtcl/), unzip it and add it to your path.

##### Add jtcl-irule to your JTcl installation
Add the [jtcl-irule](http://landro.github.com/jtcl-irule/) extension to JTcl. If you don't have the time to build it yourself, you can download the 
jar artifact from the [downloads](https://bintray.com/landro/maven/TesTcl) section or you can use the direct [link](https://bintray.com/landro/maven/download_file?file_path=com/testcl/jtcl-irule/0.9/jtcl-irule-0.9.jar).
Next, copy the jar file into the directory where you installed JTcl.
Add jtcl-irule to the classpath in _jtcl_ or _jtcl.bat_.
**IMPORTANT!** Make sure you place the _jtcl-irule-0.9.jar_ on the classpath **before** the standard jtcl-<version>.jar

###### MacOS X and Linux

On MacOs X and Linux, this can be achieved by putting the following line just above the last line in the jtcl shell script

    export CLASSPATH=$dir/jtcl-irule-0.9.jar:$CLASSPATH
    
###### Windows

On Windows, modify the following line in jtcl.bat from 

    set cp="%dir%\jtcl-%jtclver%.jar;%CLASSPATH%"

to

    set cp="%dir%\jtcl-irule-0.9.jar;%dir%\jtcl-%jtclver%.jar;%CLASSPATH%"

##### Verify installation

Create a script file named *test_jtcl_irule.tcl* containing the following lines 

```tcl
if {"aa" starts_with "a"} {
  puts "The jtcl-irule extension has successfully been installed"
}
```

and execute it using 

    jtcl test_jtcl_irule.tcl

You should get a success message. 
If you get a message saying *syntax error in expression ""aa" starts_with "a"": variable references require preceding $*, jtcl-irule is not on the classpath **before** the standard jtcl-<version>.jar. Please review instructions above.

##### Add the testcl library to your library path
Download latest [TesTcl distribution](https://github.com/landro/TesTcl/releases) from github containing all the files (including examples) found in the project.
Unzip, and add unzipped directory to the [TCLLIBPATH](http://jtcl.kenai.com/gettingstarted.html) environment variable:

    export TCLLIBPATH=whereever/TesTcl-1.0.11

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

    **************************************************************************
    * it should replace existing Vary http response headers with Accept-Encoding value
    **************************************************************************
    verification of 'there should be only one Vary header' done.
    verification of 'there should be Accept-Encoding value in Vary header' done.
    -> Test ok

#### Explanations

- Require the **testcl** package and import the commands and variables found in the **testcl** namespace to use it.
- Enable or disable logging
- Add the specification tests
  - Describe every _it_ statement as precisely as possible. It serves as documentation.
  - Add an _event_ . **This is mandatory.**
  - Add one or several _on_ statements to setup expectations/mocks. If you don't care about the return value, return "".
  - Add an _endstate_. This could be a _pool_, _HTTP::respond_, _HTTP::redirect_ or any other function call (see [link](https://devcentral.f5.com/tech-tips/articles/-the101-irules-101-routing#.UW0OwoLfeN4)).
  - Add a _verify_. The verifications will be run immediately after the iRule execution. Describe every verification as precisely as possible, add as many *verification*s as needed in your particular test scenario.
  - Add an HTTP::header initialization if you are testing modification of HTTP headers (stubs/mocks are provided for all commands in HTTP namespace).
  - Add a _run_ statement in order to actually run the Tcl script file containing your iRule. **This is mandatory.**

##### A word on the TesTcl commands #####

- _it_ statement takes two arguments, description and code block to execute as test case.
- _event_ statement takes a single argument - event type. Supported values are [all standard HTTP, TCP and IP events .](https://devcentral.f5.com/wiki/irules.Events.ashx)
- _on_ statement has the following syntax: _on_ ... (return|error) result
- _endstate_ statement accepts 2 to 5 arguments which are matched with command to stop processing iRule with success in test case evaluation.
- _verify_ statement takes four arguments. Syntax: _verify_ "DESCRIPTION" value _CONDITION_ {verification code}
  - _description_ is displayed during verification execution
  - _value_ is expected result of verification code
  - _condition_ is operator used during comparison of _value_ with code result (ex. ==, !=, eq).
  - _verification_code_ is code to evaluate after iRule execution
- _run_ statement takes two arguments, file name of iRule source and name of iRule to execute

##### A word on stubs or mockups (you choose what to call 'em)#####

###### HTTP namespace ######
Most of the other commands in the HTTP namespace have been implemented. We've done our best, but might have missed some details. Look at the sourcecode if 
you wonder what is going on in the mocks.
In particular, the [HTTP::header](https://devcentral.f5.com/wiki/irules.HTTP__header.ashx) mockup implementation should work as expected.
However _insert_modssl_fields_ subcommand is not supported in current version.

###### URI namespace ######
Everything should be supported, with the exception of:

 - [URI::encode](https://devcentral.f5.com/wiki/iRules.URI__encode.ashx)
 - [URI::decode](https://devcentral.f5.com/wiki/iRules.URI__decode.ashx)

which is only partially supported.

###### GLOBAL namespace ######
Support for

 - [getfield](https://devcentral.f5.com/wiki/iRules.getfield.ashx)
 - [log](https://devcentral.f5.com/wiki/iRules.log.ashx) 

#### Avoiding code duplication using the before command

In order to avoid code duplication, one can use the _before_ command.
The argument passed to the _before_ command will be executed _before_ the following _it_ specifications.

NB! Be carefull with using _on_ commands in _before_. If there will be another definition of the same expectation in _it_ statement, only first one will be in use (this one set in _before_).

Using the _before_ command, *test_simple_irule.tcl* can be rewritten as:

```tcl
package require -exact testcl 1.0.11
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

it "should replace existing Vary http response headers with Accept-Encoding value" {
  # NB! override event type set in before
  event HTTP_RESPONSE

  verify "there should be only one Vary header" 1 == {HTTP::header count vary}
  verify "there should be Accept-Encoding value in Vary header" "Accept-Encoding" eq {HTTP::header Vary}
  HTTP::header insert Vary "dummy value"
  HTTP::header insert Vary "another dummy value"
  run irules/simple_irule.tcl simple
}
```

On a side note, it's worth mentioning that there is no _after_ command, since we're always dealing with mocks.

### Advanced example

Let's have a look at a more advanced iRule (advanced_irule.tcl):

```tcl
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
    } elseif { [HTTP::uri] starts_with "/app"} {
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
```

The specs for this iRule would look like this:

```tcl
package require -exact testcl 1.0.11
namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

before {
  event HTTP_REQUEST
}

it "should handle admin request using pool admin when credentials are valid" {
  HTTP::uri "/admin"
  on HTTP::username return "admin"
  on HTTP::password return "password"
  endstate pool pool_admin_application
  run irules/advanced_irule.tcl advanced
}

it "should ask for credentials when admin request with incorrect credentials" {
  HTTP::uri "/admin"
  HTTP::header insert Authorization "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ=="
  verify "user Aladdin" "Aladdin" eq {HTTP::username}
  verify "password 'open sesame'" "open sesame" eq {HTTP::password}
  verify "WWW-Authenticate header is 'Basic realm=\"Restricted Area\"'" "Basic realm=\"Restricted Area\"" eq {HTTP::header "WWW-Authenticate"}
  verify "response status code is 401" 401 eq {HTTP::status}
  run irules/advanced_irule.tcl advanced
}

it "should ask for credentials when admin request without credentials" {
  HTTP::uri "/admin"
  verify "WWW-Authenticate header is 'Basic realm=\"Restricted Area\"'" "Basic realm=\"Restricted Area\"" eq {HTTP::header "WWW-Authenticate"}
  verify "response status code is 401" 401 eq {HTTP::status}
  run irules/advanced_irule.tcl advanced
}

it "should block access to uri /blocked" {
  HTTP::uri "/blocked"
  endstate HTTP::respond 403
  run irules/advanced_irule.tcl advanced
}

it "should give apache http client a correct error code when app pool is down" {
  HTTP::uri "/app"
  on active_members pool_application return 0
  HTTP::header insert User-Agent "Apache HTTP Client"
  endstate HTTP::respond 503
  run irules/advanced_irule.tcl advanced
}

it "should give other clients then apache http client redirect to fallback when app pool is down" {
  HTTP::uri "/app"
  on active_members pool_application return 0
  HTTP::header insert User-Agent "Firefox 13.0.1"
  verify "response status code is 302" 302 eq {HTTP::status}
  verify "Location header is 'http://fallback.com'" "http://fallback.com" eq {HTTP::header Location}
  run irules/advanced_irule.tcl advanced
}

it "should give handle app request using app pool when app pool is up" {
  HTTP::uri "/app/form?test=query"
  on active_members pool_application return 2
  endstate pool pool_application
  verify "result uri is /form?test=query" "/form?test=query" eq {HTTP::uri}
  verify "result path is /form" "/form" eq {HTTP::path}
  verify "result query is test=query" "test=query" eq {HTTP::query}
  run irules/advanced_irule.tcl advanced
}

it "should give 404 when request cannot be handled" {
  HTTP::uri "/cannot_be_handled"
  endstate HTTP::respond 404
  run irules/advanced_irule.tcl advanced
}

stats
```

### Modification of HTTP headers example

Let's have a look at another iRule (headers_irule.tcl):

```tcl    
rule headers {

  #notify backend about SSL using X-Forwarded-SSL http header
  #if there is client certificate put common name into X-Common-Name-SSL http header
  #if not make sure X-Common-Name-SSL header is not set
  when HTTP_REQUEST {
    HTTP::header insert X-Forwarded-SSL true
    HTTP::header remove X-Common-Name-SSL
    
    if { [SSL::cert count] > 0 } {
      set ssl_cert [SSL::cert 0]
      set subject [X509::subject $ssl_cert]
      set cn ""
      foreach { label value } [split $subject ",="] {
        set label [string toupper [string trim $label]]
        set value [string trim $value]
        
        if { $label == "CN" } {
          set cn "$value"
          break
        }
      }
    
      HTTP::header insert X-Common-Name-SSL "$cn"
    }
  }

}
```

The example specs for this iRule would look like this:

```tcl
package require -exact testcl 1.0.11
namespace import ::testcl::*

# Comment out to suppress logging
#log::lvSuppressLE info 0

before {
  event HTTP_REQUEST
  verify "There should be always set HTTP header X-Forwarded-SSL to true" true eq {HTTP::header X-Forwarded-SSL}
}

it "should remove X-Common-Name-SSL header from request if there was no client SSL certificate" {
  HTTP::header insert X-Common-Name-SSL "testCommonName"
  on SSL::cert count return 0
  verify "There should be no X-Common-Name-SSL" 0 == {HTTP::header exists X-Common-Name-SSL}
  run irules/headers_irule.tcl headers
}

it "should add X-Common-Name-SSL with Common Name from client SSL certificate if it was available" {
  on SSL::cert count return 1
  on SSL::cert 0 return {}
  on X509::subject [SSL::cert 0] return "CN=testCommonName,DN=abc.de.fg"
  verify "X-Common-Name-SSL HTTP header value is the same as CN" "testCommonName" eq {HTTP::header X-Common-Name-SSL}
  run irules/headers_irule.tcl headers
}
```

### Classes Example

TesTcl has partial support for the `class` command. For example, we could test the following rule:

```tcl
rule classes {
  when HTTP_REQUEST {
    if { [class match [IP::remote_addr] eq blacklist] } {
      drop
    } else {
      pool main-pool
    }
  }
}
```

with code that looks like this

```tcl
package require -exact testcl 1.0.11
namespace import testcl::*

before {
  event HTTP_REQUEST
  class configure blacklist {
    "blacklisted" "192.168.6.66"
  }
}

it "should drop blacklisted addresses" {
  on IP::remote_addr return "192.168.6.66"
  endstate drop
  run irules/classes.tcl classes
}

it "should drop blacklisted addresses" {
  on IP::remote_addr return "192.168.0.1"
  endstate pool main-pool
  run irules/classes.tcl classes
}
```

## How stable is this code?
This work is quite stable, but you can expect minor breaking changes.

## Why I created this project

Configuring BIG-IP devices is no trivial task, and typically falls in under a DevOps kind of role.
In order to make your system perform the best it can, you need:

- In-depth knowledge about the BIG-IP system (typically requiring at least a [$2,000 3-day course](https://f5.com/education/training))
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
- Development roundtrip-time is forever, since deployment to BIG-IP sometimes can take several minutes

Clearly, **manual** testing is not the way forward!

## Test matrix and compatibility

|               | Mac Os X | Windows| Cygwin |
| ------------- |----------|--------|--------|
| JTcl  2.4.0   | yes      | yes    | yes    |
| JTcl  2.5.0   | yes      | yes    | yes    |
| JTcl  2.6.0   | yes      | yes    | yes    |
| JTcl  2.7.0   | yes      | yes    | yes    |
| JTcl  2.8.0   | yes      | yes    | yes    |
| Tclsh 8.6     | yes*     | yes*   | ?      |

The * indicates support only for standard Tcl commands

If you use TesTcl on a different platform, please let us know

## Getting help

Post questions to the group at [TesTcl user group](https://groups.google.com/forum/?fromgroups#!forum/testcl-user)  
File bugs over at [github](https://github.com/landro/TesTcl)

## Contributing code

Contributions are very welcomed. There are just a few things to remember:

 - Run tests against JTcl since the custom iRule extensions have only been implemented in that Tcl implementation
    - Run _examples.sh_ and _tests.sh_ or their Windows equivalents, and verify output
 - Please follow existing coding style and indentation (2 spaces for tabs)
 - Add new example or test when appropriate
 - Add or update documentation when necessary and make sure it is correct (as in test it)

## Who uses it?

Well, I can't really tell you, but according to Google Analytics, this site gets around 10 hits per day.

## License

Just like JTcl, TesTcl is licensed under a BSD-style license. 

## Please please please

Drop me a line if you use this library and find it useful: stefan.landro **you know what** gmail.com

You can also check out [my LinkedIn profile](http://no.linkedin.com/in/landro) or 
[my Google+ profile](https://plus.google.com/114497086993236232709?rel=author), or 
even [my twitter account - follow it for TesTcl releases](https://twitter.com/landro)
