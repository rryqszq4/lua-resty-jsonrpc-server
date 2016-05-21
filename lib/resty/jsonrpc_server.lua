-- Copyright (c) 2015, rryqszq4
-- All rights reserved.
-- curl -d "{\"method\":\"addition\", \"params\":[1,3]}" http://localhost/lua-jsonrpc-server

local cjson = require "cjson"

local _M = {
	_VERSION = '0.0.1'
}

local mt = { __index = _M }

function _M.new(self)
	local payload
	local callbacks
	local classes

	payload = nil
	callbacks = {}
	classes = {}
	
	return 
	setmetatable({
		payload = payload,
		callbacks = callbacks,
		classes = classes
	}, mt)
end

function _M.register(self, procedure, closure)
	
	self.callbacks[procedure] = closure 

end

function _M.bind(self, procedure, classname, method)

	self.classes[procedure] = 
	{
		classname = classname,
		method = method
	}

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

function _M.execute_procedure(self, payload_method, payload_params)

	if type(self.callbacks[payload_method]) ~= "nil" then

		return self:execute_callback(payload_method, payload_params)	

	elseif type(self.classes[payload_method]) ~= "nil" then
		
		return self:execute_method(payload_method, payload_params)

	else

		return self:rpc_error(-32601, "Method not found")

	end
	
end

function _M.execute_callback(self, method, params)
	local method = self.callbacks[method]
	local success, result = pcall(method, unpack(params))
	return self:get_response(result)
end

function _M.execute_method(self, method, params)
	
	local classname = self.classes[method]["classname"]
	local method = self.classes[method]["method"]
	local success, result = pcall(classname[method], unpack(params))

	return self:get_response(result)
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

	return self:execute_procedure(self.payload.method, self.payload.params)

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

return _M

