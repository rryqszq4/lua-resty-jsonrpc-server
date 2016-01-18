local _M = {}

local mt = { __index = _M }

function _M.new (self) 
    return setmetatable({ }, mt)
end

function _M.add1(a, b)
	return a+b
end

return _M