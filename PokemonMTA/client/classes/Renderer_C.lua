Renderer_C = inherit(Class)

function Renderer_C:constructor()

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.tileFactor = 1
	self.minTiles = 1
	self.maxTiles = 256
	self.isTiled = "false"
	
	self.saturation = 1.3
	self.contrast = 1.3
	self.brightness = 1.05
			
	self:initRenderer()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Renderer_C was started.")
	end
end


function Renderer_C:initRenderer()
	
	self.m_StartTileFade = bind(self.startTileFade, self)
	self.m_StopTileFade = bind(self.stopTileFade, self)
	
	addEvent("CLIENTSTARTTILEFADE", true)
	addEventHandler("CLIENTSTARTTILEFADE", root, self.m_StartTileFade)
	
	addEvent("CLIENTSTOPTILEFADE", true)
	addEventHandler("CLIENTSTOPTILEFADE", root, self.m_StopTileFade)
	
	if (not self.renderTarget) then
		self.renderTarget = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)
	end
	
	if (not self.finalShader) then
		self.finalShader = dxCreateShader("res/shader/shader_pp_render.hlsl")
	end
	
	if (not self.hud) then
		self.hud = HUD_C:new()
	end
	
	self.isLoaded = self.renderTarget and self.finalShader
end


function Renderer_C:update(delta)
	if (self.isLoaded) and (ShaderManager_C:getSingleton():getScreenSource()) then
		
		dxSetRenderTarget(self.renderTarget, true)
		
		dxDrawImage(0, 0, self.screenWidth, self.screenHeight, ShaderManager_C:getSingleton():getScreenSource())
		
		if (self.hud) then
			self.hud:update(delta, self.renderTarget)
		end
		
		dxSetRenderTarget()
		
		if	(self.isTiled == "true") then
			if (self.tileFactor < self.maxTiles) then
				self.tileFactor = self.tileFactor + 1
				
				if (self.tileFactor > self.maxTiles) then
					self.tileFactor = self.maxTiles
				end
			end
		else
			if (self.tileFactor > self.minTiles) then
				self.tileFactor = self.tileFactor - 5
				
				if (self.tileFactor < self.minTiles) then
					self.tileFactor = self.minTiles
				end
			end
		end
		
		self.tiles = {self.screenWidth / self.tileFactor, self.screenHeight / self.tileFactor}
		
		self.finalShader:setValue("screenSource", self.renderTarget)
		self.finalShader:setValue("tiles", self.tiles)
		self.finalShader:setValue("tileFactor", self.tileFactor)
		self.finalShader:setValue("saturation", self.saturation)
		self.finalShader:setValue("contrast", self.contrast)
		self.finalShader:setValue("brightness", self.brightness)
		
		dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.finalShader)
	end
end


function Renderer_C:startTileFade()
	self.isTiled = "true"
end


function Renderer_C:stopTileFade()
	self.isTiled = "false"
end


function Renderer_C:clear()
	removeEventHandler("CLIENTSTARTTILEFADE", root, self.m_StartTileFade)
	removeEventHandler("CLIENTSTOPTILEFADE", root, self.m_StopTileFade)
	
	if (self.hud) then
		self.hud:delete()
		self.hud = nil
	end
	
	if (self.renderTarget) then
		self.renderTarget:destroy()
		self.renderTarget = nil
	end
	
	if (self.finalShader) then
		self.finalShader:destroy()
		self.finalShader = nil
	end
end


function Renderer_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Renderer_C was deleted.")
	end
end
