ShaderNull_C = inherit(Class)

function ShaderNull_C:constructor()

	self.nullTextures = { "shad_car" }
	
	self:initShader()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("ShaderNull_C was started.")
	end
end


function ShaderNull_C:initShader()
	
	if (not self.nullShader) then
		self.nullShader = dxCreateShader("res/shader/shader_null.hlsl", 0, Settings.shaderNullDrawdistance, false, "world,ped,object,vehicle")
	end
	
	self.isLoaded = self.nullShader
	
	if (self.isLoaded) then
		for index, texture in pairs(self.nullTextures) do
			if (texture) then
				self.nullShader:applyToWorldTexture(texture)
			end
		end
	else
		outputChatBox("ERROR: Null shader were NOT created! Use /debugscript 3 for further details.")
	end
end


function ShaderNull_C:update(delta)
	if (self.isLoaded) then

	end
end


function ShaderNull_C:clear()
	if (self.nullShader) then
		self.nullShader:destroy()
		self.nullShader = nil
	end
end


function ShaderNull_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("ShaderNull_C was deleted.")
	end
end
