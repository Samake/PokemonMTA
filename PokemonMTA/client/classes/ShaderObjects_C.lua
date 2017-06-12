ShaderObjects_C = inherit(Class)

function ShaderObjects_C:constructor()

	self:initShader()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("ShaderObjects_C was started.")
	end
end


function ShaderObjects_C:initShader()
	
	if (not self.pedShader) then
		self.pedShader = dxCreateShader("res/shader/shader_objects.hlsl", 0, Settings.shaderObjectDrawdistance, false, "object")
	end
	
	self.isLoaded = self.pedShader
	
	if (self.isLoaded) then
		self.pedShader:applyToWorldTexture("*")
	else
		outputChatBox("ERROR: Ped shader were NOT created! Use /debugscript 3 for further details.")
	end
end


function ShaderObjects_C:update(delta)
	if (self.isLoaded) then
		local lightDirection = ShaderManager_C:getSingleton():getLightDirection()
		
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
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("ShaderObjects_C was deleted.")
	end
end
