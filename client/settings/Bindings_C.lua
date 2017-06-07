--[[
	Filename: Bindings_C.lua
	Authors: Sam@ke
--]]

Bindings = {}

local keyShader = "M"
local keyNameTags = "N"
local keyCompanion = "1"

local keyMapZoomIn = "num_8"
local keyMapZoomOut = "num_2"

function Bindings:getCompanionKey()
	return keyCompanion
end

function Bindings:getShaderKey()
	return keyShader
end

function Bindings:getNameTagsKey()
	return keyNameTags
end

function Bindings:getKeyMapZoomIn()
	return keyMapZoomIn
end

function Bindings:getKeyMapZoomOut()
	return keyMapZoomOut
end

-- // DEV SRUFF // -- 

local keyDebug = "L"
local keyPrintLocation = "K"

function Bindings:getDebugKey()
	return keyDebug
end

function Bindings:getLocationKey()
	return keyPrintLocation
end