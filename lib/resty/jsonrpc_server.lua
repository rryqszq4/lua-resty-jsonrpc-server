-- Copyright (c) 2015, rryqszq4
-- All rights reserved.
-- curl -d "{\"method\":\"addition\", \"params\":[1,3]}" http://192.168.80.140/lua-jsonrpc-server

local cjson = require "cjson"

local _M = {
	_VERSION = '0.0.1'
}

local mt = { __index = _M }

function _M.new(self)
	local payload
	local callbacks
	local classes

	--ngx.say(ngx.var.request_body);
	--payload = cjson.decode(ngx.var.request_body)
	payload = nil
	callbacks = {}
	
	return 
	setmetatable({
		payload = payload,
		callbacks = callbacks,
	}, mt)
end

function _M.register(self, name, closure)
	
	self.callbacks[name] = closure 

end

function _M.bind()
end

function _M.json_format(self)
	if self.payload == nil then
		ngx.req.read_body()
		self.payload = ngx.var.request_body
	end

	if type(self.payload) ==  "string" then
		self.payload = cjson.decode(self.payload)
	end

	if type(self.payload) == "table" then
		return true
	else
		return false
	end
end

function _M.rpc_format(self)
	if type(self.payload) ~= "table" then
		return {
			-32600, 
			"Invalid Request"
		}
	end

	if self.payload["jsonrpc"] == nil or self.payload["jsonrpc"] ~= "2.0" then
		return {
			-32600,
			"Invalid Request"
		}
	end

	if self.payload["method"] == nil or type(self.payload["method"]) ~= "string" then
		return {
			-32601,
			"Method not found"
		}
	end

	if self.payload["params"] == nil or type(self.payload["params"]) ~= "table" then
		return {
			-32602,
			"Invalid params"
		}
	end

	return nil
end

function _M.execute_procedure()
end

function _M.execute_callback(self)
	local method = self.callbacks[self.payload.method]
	if method ~= nil then
		local success, result = pcall(method, unpack(self.payload.params))
		return self:get_response(result)
	else 
		return self:rpc_error(-32601, "Method not found")
	end
end

function _M.execute_method()
end

function _M.get_response(self, data)
	return cjson.encode({
		jsonrpc = "2.0",
		id = "null",
		result = data
	})
end

function _M.execute(self)
	local result

	result = self:json_format()
	if result ~= true then
		return self:rpc_error(-32700, "Parse error")
	end

	result = self:rpc_format()
	if result ~= nil then
		return self:rpc_error(result[1], result[2])
	end

	result = self:execute_callback()
	ngx.say(result)

	--local result = self:execute_callback()
	--return result
end

function _M.rpc_error(self, code, message)
	return cjson.encode({
		jsonrpc = "2.0",
		error = {
			code = code,
			message = message
		},
		id = "null"
	})
end

function _M.destroy()
end

return _M

