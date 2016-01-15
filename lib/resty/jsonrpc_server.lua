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

	ngx.req.read_body()

	payload = cjson.decode(ngx.var.request_body)
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

function _M.json_format()
end

function _M.rpc_format()
end

function _M.execute_procedure()
end

function _M.execute_callback(self)
	local method = self.callbacks[self.payload.method]
	local success, result = pcall(method, unpack(self.payload.params))
	return result
end

function _M.execute_method()
end

function _M.get_response()
end

function _M.execute(self)

	local result = self:execute_callback()
	return result
end

function _M.destroy()
end

return _M

