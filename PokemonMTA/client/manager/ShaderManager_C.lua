ShaderManager_C = inherit(Singleton)

function ShaderManager_C:constructor()

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.lightDirections = {}
	self.lightDirections[0] = {x = -0.019183, y = 0.994869, z =	-0.099336}
	self.lightDirections[1] = {x = -0.019183, y = 0.994869, z =	-0.099336}
	self.lightDirections[2] = {x = -0.019183, y = 0.994869, z =	-0.099336}
	self.lightDirections[3] = {x = -0.019183, y = 0.994869, z =	-0.099336}
	self.lightDirections[4] = {x = -0.019183, y = 0.994869, z =	-0.099336}
	self.lightDirections[5] = {x = -0.019183, y = 0.994869, z =	-0.099336}
	self.lightDirections[6] = {x = -0.914400, y = 0.377530, z =	-0.146093}
	self.lightDirections[7] = {x = -0.891344, y = 0.377265, z =	-0.251386}
	self.lightDirections[8] = {x = -0.891344, y = 0.377265, z =	-0.251386}
	self.lightDirections[9] = {x = -0.891344, y = 0.377265, z =	-0.251386}
	self.lightDirections[10] = {x = -0.678627, y = 0.405156, z = -0.612628}
	self.lightDirections[11] = {x = -0.678627, y = 0.405156, z = -0.612628}
	self.lightDirections[12] = {x = -0.678627, y = 0.405156, z = -0.612628}
	self.lightDirections[13] = {x = -0.303948, y = 0.490790, z = -0.816542}
	self.lightDirections[14] = {x = -0.303948, y = 0.490790, z = -0.816542}
	self.lightDirections[15] = {x = -0.303948, y = 0.490790, z = -0.816542}
	self.lightDirections[16] = {x = 0.169642, y = 0.707262, z =	-0.686296}
	self.lightDirections[17] = {x = 0.169642, y = 0.707262, z =	-0.686296}
	self.lightDirections[18] = {x = 0.380167, y = 0.893543, z =	-0.238859}
	self.lightDirections[19] = {x = 0.360288, y = 0.932817, z =	-0.238859}
	self.lightDirections[20] = {x = 0.360288, y = 0.932817, z =	-0.612628}
	self.lightDirections[21] = {x = 0.360288, y = 0.932817, z =	-0.612628}
	self.lightDirections[22] = {x = 0.360288, y = 0.932817, z =	-0.612628}
	self.lightDirections[23] = {x = -0.744331, y = 0.663288, z = -0.077591}
	
	self.shadersEnabled = "true"
			
	self:initManager()
	
	if (Settings.showManagerDebugInfo == true) then
		mainOutput("ShaderManager_C was started.")
	end
end


function ShaderManager_C:initManager()
	
	self.screenSource = dxCreateScreenSource(self.screenWidth, self.screenHeight)
	
	self.m_ToggleShaders = bind(self.toggleShaders, self)
	
	bindKey(Bindings["TOGGLESHADER"], "down", self.m_ToggleShaders)
	
	if (self.shadersEnabled == "true") then
		self:createShaders()
	end
	
	if (not self.renderer) then
		self.renderer = Renderer_C:new()
	end
	
	self.isLoaded = self.screenSource
end


function ShaderManager_C:toggleShaders()
	if (self.shadersEnabled == "true") then
		self.shadersEnabled = "false"
		
		self:deleteShaders()
	else
		self.shadersEnabled = "true"
		
		self:createShaders()
	end
end


function ShaderManager_C:createShaders()
	if (not self.pedShader) then
		self.pedShader = ShaderPeds_C:new()
	end
	
	if (not self.objectShader) then
		self.objectShader = ShaderObjects_C:new()
	end
	
	mainOutput("CLIENT || Shaders enabled.")
end


function ShaderManager_C:update(delta)
	if (self.isLoaded) then
		self.hour, self.minutes = getTime()
		self.screenSource:update()
		
		if (self.pedShader) then
			self.pedShader:update(delta)
		end
		
		if (self.objectShader) then
			self.objectShader:update(delta)
		end
		
		if (self.renderer) then
			self.renderer:update(delta)
		end
	end
end


function ShaderManager_C:getScreenSource()
	return self.screenSource
end


function ShaderManager_C:getLightDirection()
	return self.lightDirections[self.hour]
end


function ShaderManager_C:deleteShaders()
	if (self.pedShader) then
		self.pedShader:delete()
		self.pedShader = nil
	end
	
	if (self.objectShader) then
		self.objectShader:delete()
		self.objectShader = nil
	end
	
	mainOutput("CLIENT || Shaders disabled.")
end


function ShaderManager_C:clear()
	unbindKey(Bindings["TOGGLESHADER"], "down", self.m_ToggleShaders)
	
	if (self.renderer) then
		self.renderer:delete()
		self.renderer = nil
	end
	
	if (self.screenSource) then
		self.screenSource:destroy()
		self.screenSource = nil
	end
	
	self:deleteShaders()
end


function ShaderManager_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		mainOutput("ShaderManager_C was deleted.")
	end
end
