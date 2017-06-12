-- Developer: sbx320
-- License: MIT
-- Github Repos: https://github.com/sbx320/lua_utils

--// classlib
--|| A library providing several tools to enhance OOP with MTA and Lua
--\\
SERVER = triggerServerEvent == nil
CLIENT = not SERVER
DEBUG = DEBUG or false

function enew(element, class, ...)
	-- DEBUG: Validate that we are not instantiating a class with pure virtual methods
	if DEBUG then
		for k, v in pairs(class) do
			assert(v ~= pure_virtual, "Attempted to instanciate a class with an unimplemented pure virtual method ("..tostring(k)..")")
		end
	end
	
	local instance = setmetatable( { element = element },
		{
			__index = class;
			__super = { class };
			__newindex = class.__newindex;
			__call = class.__call;
			__len = class.__len;
			__unm = class.__unm;
			__add = class.__add;
			__sub = class.__sub;
			__mul = class.__mul;
			__div = class.__div;
			__pow = class.__pow;
			__concat = class.__concat;		
		})
		
	oop.elementInfo[element] = instance
	
	local callDerivedConstructor;
	callDerivedConstructor = function(parentClasses, instance, ...)
		for k, v in pairs(parentClasses) do
			if rawget(v, "virtual_constructor") then
				rawget(v, "virtual_constructor")(instance, ...)
			end
			local s = super(v)
			if s then callDerivedConstructor(s, instance, ...) end
		end
	end
		
	callDerivedConstructor(super(instance), element, ...) 
	
	-- Call constructor
	if rawget(class, "constructor") then
		rawget(class, "constructor")(element, ...)
	end
	element.constructor = false
	
	return element
end

function new(class, ...)
	assert(type(class) == "table", "first argument provided to new is not a table")
	
	-- DEBUG: Validate that we are not instantiating a class with pure virtual methods
	if DEBUG then
		for k, v in pairs(class) do
			assert(v ~= pure_virtual, "Attempted to instanciate a class with an unimplemented pure virtual method ("..tostring(k)..")")
		end
	end
	
	local instance = setmetatable( { },
		{
			__index = class;
			__super = { class };
			__newindex = class.__newindex;
			__call = class.__call;
			__len = class.__len;
			__unm = class.__unm;
			__add = class.__add;
			__sub = class.__sub;
			__mul = class.__mul;
			__div = class.__div;
			__pow = class.__pow;
			__concat = class.__concat;		
		})
	
	-- Call derived constructors
	local callDerivedConstructor;
	callDerivedConstructor = function(self, instance, ...)
		for k, v in pairs(super(self)) do
			if rawget(v, "virtual_constructor") then
				rawget(v, "virtual_constructor")(instance, ...)
			end
			local s = super(v)
			if s then callDerivedConstructor(s, instance, ...) end
		end
	end
		
	callDerivedConstructor(class, instance, ...) 
	
	-- Call constructor
	if rawget(class, "constructor") then
		rawget(class, "constructor")(instance, ...)
	end
	instance.constructor = false

	return instance
end

function delete(self, ...)
	if self.destructor then --if rawget(self, "destructor") then
		self:destructor(...)
	end

	-- Prevent the destructor to be called twice 
	self.destructor = false
	
	local callDerivedDestructor;
	callDerivedDestructor = function(parentClasses, instance, ...)
		for k, v in pairs(parentClasses) do
			if rawget(v, "virtual_destructor") then
				rawget(v, "virtual_destructor")(instance, ...)
			end
			local s = super(v)
			if s then callDerivedDestructor(s, instance, ...) end
		end
	end
	callDerivedDestructor(super(self), self, ...)
end

function super(self)
	if isElement(self) then
		assert(oop.elementInfo[self], "Cannot get the superclass of this element") -- at least: not yet
		self = oop.elementInfo[self]
	end
	local metatable = getmetatable(self)
	if metatable then return metatable.__super 
	else 
		return {}
	end
end

function inherit(from, what)
	assert(from, "Attempt to inherit a nil table value")
	if not what then
		local classt = setmetatable({}, { __index = _inheritIndex, __super = { from } })
		if from.onInherit then
			from.onInherit(classt)
		end
		return classt
	end
	
	local metatable = getmetatable(what) or {}
	local oldsuper = metatable and metatable.__super or {}
	table.insert(oldsuper, 1, from)
	metatable.__super = oldsuper
	metatable.__index = _inheritIndex
	
	-- Inherit __call
	for k, v in ipairs(metatable.__super) do
		if v.__call then
			metatable.__call = v.__call
			break
		end
	end
	
	return setmetatable(what, metatable)
end

function _inheritIndex(self, key)
	for k, v in pairs(super(self) or {}) do
		if v[key] then return v[key] end
	end
	return nil
end

function instanceof(self, class, direct)
	for k, v in pairs(super(self)) do
		if v == class then return true end
	end
	
	if direct then return false end
		
	local check = false
	-- Check if any of 'self's base classes is inheriting from 'class'
	for k, v in pairs(super(self)) do
		check = instanceof(v, class, false)
	end	
	return check
end

function pure_virtual()
	error("Function implementation missing")
end

function bind(func, ...)
	if not func then
		if DEBUG then
			outputConsole(debug.traceback())
		end
		error("Bad function pointer @ bind. See console for more details")
	end
	
	local boundParams = {...}
	return 
		function(...) 
			local params = {}
			local boundParamSize = select("#", unpack(boundParams))
			for i = 1, boundParamSize do
				params[i] = boundParams[i]
			end
			
			local funcParams = {...}
			for i = 1, select("#", ...) do
				params[boundParamSize + i] = funcParams[i]
			end
			return func(unpack(params)) 
		end 
end

function load(class, ...)
	assert(type(class) == "table", "first argument provided to load is not a table")
	local instance = setmetatable( { },
		{
			__index = class;
			__super = { class };
			__newindex = class.__newindex;
			__call = class.__call;
		})
	
	-- Call load
	if rawget(class, "load") then
		rawget(class, "load")(instance, ...)
	end
	instance.load = false

	return instance
end

-- Magic to allow MTA elements to be used as data storage
-- e.g. localPlayer.foo = 12
oop = {}
oop.mta_metatable = {}
oop.elementInfo = setmetatable({}, { __mode = "k" })
oop.elementClasses = {}

oop.getMTATypeMetatable = function(t)
	local element = false
	if t == "player" then return debug.getmetatable(localPlayer or getRandomPlayer())
	elseif t == "vehicle" then element = createVehicle(411, 0, 0, 0)
	elseif t == "colshape" then element = createColCircle(0, 0, 1)
	elseif t == "element" then element = createElement("oopelement")
	elseif t == "marker" then element = createMarker(0, 0, 0, "ring")
	elseif t == "object" then element = createObject(1337, 0, 0, 0)
	elseif t == "ped" then element = createPed(0, 0, 0, 0)
	elseif t == "pickup" then element = createPickup(0, 0, 0, 0, 0)
	elseif t == "radarArea" then element = createRadarArea(0, 0, 1, 1)
	elseif t == "water" then element = createWater(0, 0, 0, 2, 2, 2, 4, 4, 4)
	elseif SERVER then
		if t == "team" then element = createTeam("oopteam") end
	elseif CLIENT then
		if t == "sound" then element = playSFX("feet", 1, 1) 
		elseif t == "camera" then return debug.getmetatable(getCamera())
		elseif t == "effect" then element = createEffect("fire", 0, 0, 0)
	     	elseif t == "weapon" then element = createWeapon("m4", 0, 0, 0)
			-- todo: check if GUI elements have OOP
		end
	end
		
		
	assert(element, t)
	
	local mt = debug.getmetatable(element)
	destroyElement(element)
	
	return mt
end

oop.prepareClass = function(name)
	local mt = oop.mta_metatable[name]
	
	-- Store MTA's metafunctions
	local __mtaindex = mt.__index
	local __mtanewindex = mt.__newindex
	local __set= mt.__set
	
	
	mt.__index = function(self, key)
		if not oop.handled then
			if not oop.elementInfo[self] then
				enew(self, oop.elementClasses[getElementType(self)] or {})
			end
			if oop.elementInfo[self][key] ~= nil  then
				oop.handled = false
				return oop.elementInfo[self][key]
			end
			oop.handled = true
		end
		local value = __mtaindex(self, key)
		oop.handled = false
		return value
	end
	
	mt.__newindex = function(self, key, value)
		if __set[key] ~= nil then
			__mtanewindex(self, key, value)
			return
		end
		
		if not oop.elementInfo[self] then
			enew(self, oop.elementClasses[getElementType(self)] or {})
		end
		
		oop.elementInfo[self][key] = value
	end
end

function registerElementClass(class, name) 
	oop.elementClasses[name] = class
end

oop.initClasses = function()
	oop.mta_metatable["vehicle"] = oop.getMTATypeMetatable("vehicle")
	oop.mta_metatable["colshape"] = oop.getMTATypeMetatable("colshape")
	oop.mta_metatable["element"] = oop.getMTATypeMetatable("element")
	oop.mta_metatable["marker"] = oop.getMTATypeMetatable("marker")
	oop.mta_metatable["object"] = oop.getMTATypeMetatable("object")
	oop.mta_metatable["ped"] = oop.getMTATypeMetatable("ped")
	oop.mta_metatable["pickup"] = oop.getMTATypeMetatable("pickup")
	oop.mta_metatable["radarArea"] = oop.getMTATypeMetatable("radarArea")
	oop.mta_metatable["water"] = oop.getMTATypeMetatable("water")
	
	if SERVER then
		oop.mta_metatable["team"] = oop.getMTATypeMetatable("team")
	end
	
	if CLIENT then
		oop.mta_metatable["sound"] = oop.getMTATypeMetatable("sound")
		oop.mta_metatable["camera"] = oop.getMTATypeMetatable("camera")
		oop.mta_metatable["effect"] = oop.getMTATypeMetatable("effect")
		oop.mta_metatable["weapon"] = oop.getMTATypeMetatable("weapon")
	end
	
	for k, v in pairs(oop.mta_metatable) do
		oop.prepareClass(k)
	end
	
	if SERVER then
		if getPlayerCount() >= 1 then
			oop.initPlayerClass()
		else
			addEventHandler("onPlayerConnect", root, oop.initPlayerClass)
		end
	else
		oop.initPlayerClass()
	end
end

oop.initPlayerClass = function()
	oop.mta_metatable["player"] = oop.getMTATypeMetatable("player")
	removeEventHandler("onPlayerConnect", root, oop.initPlayerClass)
	oop.prepareClass("player")
end

oop.initClasses()
