lua-resty-jsonrpc-server
========================

lua-resty-jsonrpc-server -- JsonRPC 2.0 server for ngx_lua

Table of Contents
=================

* [Name](#name)
* [Description](#description)
* [Synopsis](#synopsis)
* [Methods](#methods)
	* [new](#new)
	* [register](#register)
	* [bind](#bind)
	* [json_format](#json_format)
	* [rpc_format](#rpc_format)
	* [execute_procedure](#execute_procedure)
	* [execute_callback](#execute_callback)
	* [execute_method](#execute_method)
	* [get_response](#get_response)
	* [execute](#execute)
	* [rpc_error](#rpc_error)
* [Jsonrpc 2.0 error](#jsonrpc-2.0-error)
* [Author](#author)
* [Copyright and License](#copyright-and-license)


Description
===========

This Lua library is a JsonRPC 2.0 server for the ngx_lua nginx module.


Synopsis
========

```lua
lua_package_path "/path/to/lua-resty-jsonrpc-server/lib/?.lua;;";

server {
	location /lua-jsonrpc-server {
		default_type "application/json";

		content_by_lua '
	        local jsonrpc_server = require "resty.jsonrpc_server"
	        local jsonrpc_demo = require "resty.jsonrpc_demo"

	        local server = jsonrpc_server:new()

	        local add1 = function(a, b)
	                return a + b
	        end

	        local register = server:register([[addition]], add1)

	        local binder = server:bind([[addition1]], jsonrpc_demo, [[add1]])

	        local result = server:execute()
	        
	        ngx.say(result);

		';
	}
}

```

Methods
=======

new
---

register
--------

bind
----

json_format
-----------

rpc_format
----------

execute_procedure
-----------------

execute_callback
----------------

execute_method
--------------

get_response
------------

execute
-------

rpc_error
---------

Jsonrpc 2.0 error
=================

```javascript
// Parse error
{"jsonrpc":"2.0","id":null,"error":{"code":-32700,"message":"Parse error"}}

// Invalid Request
{"jsonrpc":"2.0","id":null,"error":{"code":-32600,"message":"Invalid Request"}}

// Method not found
{"jsonrpc":"2.0","id":null,"error":{"code":-32601,"message":"Method not found"}}

// Invalid params
{"jsonrpc":"2.0","id":null,"error":{"code":-32602,"message":"Invalid params"}}
```

Author
======

rryqszq4 <memwared@gmail.com>.

Copyright and License
=====================

Copyright (c) 2015, rryqszq4
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
















