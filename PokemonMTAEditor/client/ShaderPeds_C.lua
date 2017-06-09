--[[
	Filename: ShaderPeds_C.lua
	Authors: Sam@ke
--]]

ShaderPeds_C = {}

function ShaderPeds_C:constructor(parent)

	self.shaderManager = parent
	self.player = getLocalPlayer()
	
	self.effectRange = 250
	
	self:init()
	
	mainOutput("ShaderPeds_C was started.")
end


function ShaderPeds_C:init()
	
	if (not self.pedShader) then
		self.pedShader = dxCreateShader("res/shader/shader_peds.hlsl", 0, self.effectRange, false, "ped")
	end
	
	self.isLoaded = self.shaderManager and self.pedShader and self.player
	
	if (self.isLoaded) then
		self.pedShader:applyToWorldTexture("*")
	else
		outputChatBox("ERROR: Ped shader were NOT created! Use /debugscript 3 for further details.")
	end
end


function ShaderPeds_C:update(delta)
	if (self.isLoaded) then
		self.pedShader:removeFromWorldTexture("*", self.player)
		
		local lightDirection = self.shaderManager:geLightDirection()
		
		if (lightDirection) then
			if (lightDirection.x) and (lightDirection.y) and (lightDirection.z) then
				self.pedShader:setValue("lightDirection", {lightDirection.x, lightDirection.y, lightDirection.z})
			end
		end
	end
end


function ShaderPeds_C:clear()
	if (self.pedShader) then
		self.pedShader:destroy()
		self.pedShader = nil
	end
end


function ShaderPeds_C:destructor()
	self:clear()
	
	mainOutput("ShaderPeds_C was deleted.")
end
