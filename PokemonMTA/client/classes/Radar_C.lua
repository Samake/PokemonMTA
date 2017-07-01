Radar_C = inherit(Class)

function Radar_C:constructor()
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.player = getLocalPlayer()
	
	self.drawDistance = 255
	self.gtaMapSize = 6000
	self.size = self.screenHeight * 0.26
	self.x = self.screenWidth - self.size
	self.y = 0
	
	self.zoom = 0.65
	self.minZoom = 0.15
	self.maxZoom = 0.95
	self.zoomStep = 0.025
	
	self.blipSize = self.size * 0.15
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Radar_C was started.")
	end
end


function Radar_C:init()
	
	if (not self.renderTargetMapFull) then
		self.renderTargetMapFull = dxCreateRenderTarget(self.gtaMapSize, self.gtaMapSize, true)
	end
	
	if (not self.renderTargetRadar) then
		self.renderTargetRadar = dxCreateRenderTarget(self.size, self.size, true)
	end
	
	if (not self.renderTargetFinal) then
		self.renderTargetFinal = dxCreateRenderTarget(self.size, self.size, true)
	end
	
	if (not self.maskShader) then
		self.maskShader = dxCreateShader("res/shader/shader_mask.hlsl")
	end
	
	self.m_ZoomIn = bind(self.zoomIn, self)
	self.m_ZoomOut = bind(self.zoomOut, self)
	
	bindKey(Bindings["MAPZOOMIN"], "down", self.m_ZoomIn)
	bindKey(Bindings["MAPZOOMOUT"], "down", self.m_ZoomOut)
	
	self.isLoaded = Textures["radar"].radarMask and Textures["radar"].radarMaskBG and Textures["radar"].radarFrame and self.renderTargetMapFull and self.renderTargetRadar and self.renderTargetFinal and self.maskShader
end


function Radar_C:zoomIn()
	if (self.zoom < self.maxZoom) then
		self.zoom = self.zoom + self.zoomStep
		
		if (self.zoom > self.maxZoom) then
			self.zoom = self.maxZoom
		end
	end
end


function Radar_C:zoomOut()
	if (self.zoom > self.minZoom) then
		self.zoom = self.zoom - self.zoomStep
		
		if (self.zoom < self.minZoom) then
			self.zoom = self.minZoom
		end
	end
end


function Radar_C:update(delta, renderTarget)
	if (renderTarget) and (self.isLoaded) and (isElement(self.player)) then
		
		self.playerPos = self.player:getPosition()
		self.playerRot = self.player:getRotation()
		
		self:drawGTAMap()
		self:drawBlips()
		self:drawRadar()
		self:drawPlayer()
		self:drawFinalRadar()
		--self:drawZoneName()
		
		-- // draw on hud rendertarget // --
		dxSetRenderTarget(renderTarget, false)
		dxDrawImage(self.x, self.y, self.size, self.size, self.renderTargetFinal, 0, 0, 0, tocolor(255, 255, 255, 255))
	end
end


function Radar_C:drawGTAMap()
	dxSetRenderTarget(self.renderTargetMapFull, true)
	dxDrawImage(0, 0, self.gtaMapSize, self.gtaMapSize, Textures["radar"].radarBG , 0, 0, 0, tocolor(200, 185, 165, 255))
	dxSetRenderTarget()
end


function Radar_C:drawBlips()
	dxSetRenderTarget(self.renderTargetMapFull, false)
	dxSetBlendMode("modulate_add")
	
	for index, pokespawn in pairs(getElementsByType("POKESPAWN")) do
		if (isElement(pokespawn)) then
			local pos = pokespawn:getPosition()
			local distance = getDistanceBetweenPoints2D(self.playerPos.x, self.playerPos.y, pos.x, pos.y)
			
			if (distance < self.drawDistance) then
				local alpha = (self.drawDistance - distance) / 3
				local x = pos.x / (self.gtaMapSize / self.gtaMapSize)  + self.gtaMapSize / 2
				local y = pos.y / (-self.gtaMapSize / self.gtaMapSize) + self.gtaMapSize / 2
				
				dxDrawImage(x - (self.blipSize * 4), y - (self.blipSize * 4), self.blipSize * 8, self.blipSize * 8, Textures["radar"].defaultBlip, 0, 0, 0, tocolor(255, 90, 90, (alpha)%255))
			end
		end
	end
	
	for index, pokemon in pairs(getElementsByType("POKEMON")) do
		if (isElement(pokemon)) then
			local pos = pokemon:getPosition()
			local distance = getDistanceBetweenPoints2D(self.playerPos.x, self.playerPos.y, pos.x, pos.y)
			
			if (distance < self.drawDistance) then
				local alpha = self.drawDistance - distance
				local x = pos.x / (self.gtaMapSize / self.gtaMapSize)  + self.gtaMapSize / 2
				local y = pos.y / (-self.gtaMapSize / self.gtaMapSize) + self.gtaMapSize / 2
				
				dxDrawImage(x - (self.blipSize / 3), y - (self.blipSize / 3), self.blipSize / 1.5, self.blipSize / 1.5, Textures["radar"].defaultBlip, 0, 0, 0, tocolor(90, 255, 90, (alpha)%255))
			end
		end
	end
	
	for index, chest in pairs(getElementsByType("CHEST")) do
		if (isElement(chest)) then
			local pos = chest:getPosition()
			local distance = getDistanceBetweenPoints2D(self.playerPos.x, self.playerPos.y, pos.x, pos.y)
			
			if (distance < self.drawDistance) then
				local alpha = self.drawDistance - distance
				local x = pos.x / (self.gtaMapSize / self.gtaMapSize)  + self.gtaMapSize / 2
				local y = pos.y / (-self.gtaMapSize / self.gtaMapSize) + self.gtaMapSize / 2
				
				dxDrawImage(x - (self.blipSize / 2), y - (self.blipSize / 2), self.blipSize, self.blipSize, Textures["radar"].defaultBlip, 0, 0, 0, tocolor(255, 145, 90, (alpha)%255))
			end
		end
	end
	
	for index, npc in pairs(getElementsByType("NPC")) do
		if (isElement(npc)) then
			local pos = npc:getPosition()
			local distance = getDistanceBetweenPoints2D(self.playerPos.x, self.playerPos.y, pos.x, pos.y)
			
			if (distance < self.drawDistance) then
				local alpha = self.drawDistance - distance
				local x = pos.x / (self.gtaMapSize / self.gtaMapSize)  + self.gtaMapSize / 2
				local y = pos.y / (-self.gtaMapSize / self.gtaMapSize) + self.gtaMapSize / 2
				
				dxDrawImage(x - (self.blipSize / 2), y - (self.blipSize / 2), self.blipSize, self.blipSize, Textures["radar"].defaultBlip, 0, 0, 0, tocolor(90, 145, 255, (alpha)%255))
			end
		end
	end
	
	dxSetBlendMode("blend")
	dxSetRenderTarget()
end


function Radar_C:drawRadar()
	dxSetRenderTarget(self.renderTargetRadar, true)
	
	local playerPos = self.player:getPosition()
	local mapX = playerPos.x / (self.gtaMapSize / self.gtaMapSize)  + self.gtaMapSize / 2  - self.size / self.zoom / 2
	local mapY = playerPos.y / (-self.gtaMapSize / self.gtaMapSize) + self.gtaMapSize / 2 - self.size / self.zoom / 2
		
	dxDrawImageSection(0, 0, self.size, self.size, mapX, mapY, self.size / self.zoom, self.size / self.zoom, self.renderTargetMapFull, self.playerRot.z, 0, 0, tocolor(255, 255, 255, 255))

	dxSetRenderTarget()
end

function Radar_C:drawPlayer()
	dxSetRenderTarget(self.renderTargetRadar, false)
	dxSetBlendMode("modulate_add")
	
	dxDrawImage((self.size / 2) - (self.blipSize / 2), (self.size / 2) - (self.blipSize / 2), self.blipSize, self.blipSize, Textures["radar"].playerBlip, 0, 0, 0, tocolor(255, 255, 255, 255))

	dxSetBlendMode("blend")
	dxSetRenderTarget()
end


function Radar_C:drawFinalRadar()
	dxSetRenderTarget(self.renderTargetFinal, true)
	dxSetBlendMode("modulate_add")
	
	self.maskShader:setValue("bgTexture", Textures["radar"].radarMaskBG)
	self.maskShader:setValue("inTexture", self.renderTargetRadar)
	self.maskShader:setValue("maskTexture", Textures["radar"].radarMask)
	
	dxDrawImage(0, 0, self.size, self.size, Textures["radar"].radarMaskBG)
	dxDrawImage(10, 10, self.size - 20, self.size - 20, self.maskShader)
	dxDrawImage(0, 0, self.size, self.size, Textures["radar"].radarFrame, 0, 0, 0, tocolor(200, 200, 200, 255))
	
	dxSetBlendMode("blend")
	dxSetRenderTarget()
end


function Radar_C:drawZoneName()
	self.zoneName = getZoneName(self.playerPos.x, self.playerPos.y, self.playerPos.z, false)

	if (self.zoneName) then
		dxSetRenderTarget(self.renderTargetFinal, false)
		dxSetBlendMode("modulate_add")
		
		local fontScale = 0.65
		local fontheight = dxGetFontHeight(self.fontScale, Fonts["pokemon_gb_8_bold"])
		local x = self.size * 0.5
		local y = self.size * 0.375
		
		dxDrawText(self.zoneName, x, y, x, y, tocolor(80, 80, 80, 255), fontScale, Fonts["pokemon_gb_8_bold"], "center", "center", false, false, false, true, true)
		
		dxSetBlendMode("blend")
		dxSetRenderTarget()
	end
end



function Radar_C:clear()
	
	unbindKey(Bindings["MAPZOOMIN"], "down", self.m_ZoomIn)
	unbindKey(Bindings["MAPZOOMOUT"], "down", self.m_ZoomOut)
	
	if (self.renderTargetMapFull) then
		self.renderTargetMapFull:destroy()
		self.renderTargetMapFull = nil
	end
	
	if (self.renderTargetRadar) then
		self.renderTargetRadar:destroy()
		self.renderTargetRadar = nil
	end
	
	if (self.renderTargetFinal) then
		self.renderTargetFinal:destroy()
		self.renderTargetFinal = nil
	end
	
	if (self.maskShader) then
		self.maskShader:destroy()
		self.maskShader = nil
	end
end


function Radar_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Radar_C was deleted.")
	end
end