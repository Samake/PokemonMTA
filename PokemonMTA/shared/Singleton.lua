Singleton = {}

function Singleton:getSingleton()
	return self:new()
end

function Singleton:new(...)
	if self.ms_Instance then
		return self.ms_Instance
	end
	local inst = new(self, ...)
	self.ms_Instance = inst
	return inst
end

function Singleton:virtual_destructor()
	for k, v in pairs(super(self)) do
		v.ms_Instance = nil
		v.new = Singleton.new
	end
end

Singleton.__call = Singleton.new
setmetatable(Singleton, {__call = Singleton.__call})