--[[
	Filename: Bindings_C.lua
	Authors: Sam@ke
--]]

Bindings = {}

local keyShader = "M"

function Bindings:getShaderKey()
	return keyShader
end

-- // DEV SRUFF // -- 

local keyDebug = "L"

function Bindings:getDebugKey()
	return keyDebug
end
