ShaderVehicles_C = inherit(Class)

function ShaderVehicles_C:constructor()

	self:initShader()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("ShaderVehicles_C was started.")
	end
end


function ShaderVehicles_C:initShader()
	
	if (not self.vehicleShader) then
		self.vehicleShader = dxCreateShader("res/shader/shader_vehicle.hlsl", 0, Settings.shaderVehicleDrawdistance, false, "vehicle")
	end
	
	self.isLoaded = self.vehicleShader
	
	if (self.isLoaded) then
		self.vehicleShader:applyToWorldTexture("*")
	else
		outputChatBox("ERROR: Vehicle shader were NOT created! Use /debugscript 3 for further details.")
	end
end


function ShaderVehicles_C:update(delta)
	if (self.isLoaded) then
		local lightDirection = ShaderManager_C:getSingleton():getLightDirection()
		
		if (lightDirection) then
			if (lightDirection.x) and (lightDirection.y) and (lightDirection.z) then
				self.vehicleShader:setValue("lightDirection", {lightDirection.x, lightDirection.y, lightDirection.z})
			end
		end
	end
end


function ShaderVehicles_C:clear()
	if (self.vehicleShader) then
		self.vehicleShader:destroy()
		self.vehicleShader = nil
	end
end


function ShaderVehicles_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("ShaderVehicles_C was deleted.")
	end
end
