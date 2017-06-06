--[[
	Filename: ShaderObjects_C.lua
	Authors: Sam@ke
--]]

ShaderObjects_C = {}

function ShaderObjects_C:constructor(parent)

	self.shaderManager = parent
	
	self.effectRange = 250
	
	self:init()
	
	mainOutput("ShaderObjects_C was started.")
end


function ShaderObjects_C:init()
	
	if (not self.pedShader) then
		self.pedShader = dxCreateShader("res/shader/shader_objects.hlsl", 0, self.effectRange, false, "object")
	end
	
	self.isLoaded = self.shaderManager and self.pedShader
	
	if (self.isLoaded) then
		self.pedShader:applyToWorldTexture("*")
	else
		outputChatBox("ERROR: Ped shader were NOT created! Use /debugscript 3 for further details.")
	end
end


function ShaderObjects_C:update(delta)
	if (self.isLoaded) then
		local lightDirection = self.shaderManager:geLightDirection()
		
		if (lightDirection) then
			if (lightDirection.x) and (lightDirection.y) and (lightDirection.z) then
				self.pedShader:setValue("lightDirection", {lightDirection.x, lightDirection.y, lightDirection.z})
			end
		end
	end
end


function ShaderObjects_C:clear()
	if (self.pedShader) then
		self.pedShader:destroy()
		self.pedShader = nil
	end
end


function ShaderObjects_C:destructor()
	self:clear()
	
	mainOutput("ShaderObjects_C was deleted.")
end
