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

function _M.jsonformat()
end

function _M.rpcformat()
end

function _M.executeprocedure()
end

function _M.executecallback()
end

function _M.executemethod()
end

function _M.getresponse()
end

function _M.execute(self)

	local method = self.callbacks[self.payload.method]
	local success, ret = pcall(method, unpack(self.payload.params))
	return ret
end

function _M.destroy()
end

return _M

