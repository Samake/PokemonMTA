--[[
	Filename: ShaderPlayer_C.lua
	Authors: Sam@ke
--]]

ShaderPlayer_C = {}

function ShaderPlayer_C:constructor(parent)

	self.shaderManager = parent
	self.player = getLocalPlayer()
	
	self.effectRange = 250
	
	self:init()
	
	mainOutput("ShaderPlayer_C was started.")
end


function ShaderPlayer_C:init()
	
	if (not self.pedShader) then
		self.pedShader = dxCreateShader("res/shader/shader_player.hlsl", 0, self.effectRange, false, "ped")
	end
	
	self.isLoaded = self.shaderManager and self.pedShader and self.player
	
	if (self.isLoaded) then
		self.pedShader:applyToWorldTexture("*", self.player)
	else
		outputChatBox("ERROR: Ped shader were NOT created! Use /debugscript 3 for further details.")
	end
end


function ShaderPlayer_C:update(delta)
	if (self.isLoaded) then

	end
end


function ShaderPlayer_C:clear()
	if (self.pedShader) then
		self.pedShader:destroy()
		self.pedShader = nil
	end
end


function ShaderPlayer_C:destructor()
	self:clear()
	
	mainOutput("ShaderPlayer_C was deleted.")
end
