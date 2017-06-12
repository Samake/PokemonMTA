Class = {}

function Class:new(...)
	return new(self, ...)
end

function Class:delete(...)
	return delete(self, ...)
end

Class.__call = Class.new
setmetatable(Class, {__call = Class.__call})