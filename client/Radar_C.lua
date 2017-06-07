--[[
	Filename: Radar_C.lua
	Author: Sam@ke
--]]

local Instance = nil

Radar_C = {}

function Radar_C:constructor(parent)
	
	self.hud = parent
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.player = getLocalPlayer()
	
	self.drawDistance = 255
	self.gtaMapSize = 6000
	self.size = self.screenHeight * 0.35
	self.x = self.screenWidth - self.size
	self.y = 0
	
	self.zoom = 0.45
	self.blipSize = self.size * 0.12
	
	self:init()
	
	mainOutput("Radar_C was loaded.")
end


function Radar_C:init()

	if (not self.textureMap) then
		self.textureMap = dxCreateTexture("res/textures/radar_bg.png", "argb")
	end
	
	if (not self.textureDefaultBlip) then
		self.textureDefaultBlip = dxCreateTexture("res/textures/default_blip.png", "argb")
	end
	
	if (not self.texturePlayerBlip) then
		self.texturePlayerBlip = dxCreateTexture("res/textures/player_blip.png", "argb")
	end
	
	if (not self.textureMask) then
		self.textureMask = dxCreateTexture("res/textures/radar_mask.png", "argb")
	end
	
	if (not self.textureMaskBG) then
		self.textureMaskBG = dxCreateTexture("res/textures/radar_mask_bg.png", "argb")
	end
	
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
	
	self.isLoaded = self.textureMap and self.textureDefaultBlip and self.texturePlayerBlip and self.textureMask and self.textureMaskBG and self.renderTargetMapFull and self.renderTargetRadar and self.renderTargetFinal and self.maskShader
end


function Radar_C:update(delta, renderTarget)
	if (renderTarget) and (self.hud) and (self.isLoaded) and (isElement(self.player)) then
		
		self.playerPos = self.player:getPosition()
		self.playerRot = self.player:getRotation()
		
		self:drawGTAMap()
		self:drawBlips()
		self:drawRadar()
		self:drawPlayer()
		self:drawFinalRadar()
		self:drawZoneName()
		
		-- // draw on hud rendertarget // --
		dxSetRenderTarget(renderTarget, false)
		dxDrawImage(self.x, self.y, self.size, self.size, self.renderTargetFinal, 0, 0, 0, tocolor(255, 255, 255, 255))
	end
end


function Radar_C:drawGTAMap()
	dxSetRenderTarget(self.renderTargetMapFull, true)
	dxDrawImage(0, 0, self.gtaMapSize, self.gtaMapSize, self.textureMap, 0, 0, 0, tocolor(190, 190, 190, 255))
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
				
				dxDrawImage(x - (self.blipSize * 4), y - (self.blipSize * 4), self.blipSize * 8, self.blipSize * 8, self.textureDefaultBlip, 0, 0, 0, tocolor(255, 90, 90, (alpha)%255))
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
				
				dxDrawImage(x - (self.blipSize / 2), y - (self.blipSize / 2), self.blipSize, self.blipSize, self.textureDefaultBlip, 0, 0, 0, tocolor(90, 255, 90, (alpha)%255))
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
				
				dxDrawImage(x - (self.blipSize / 2), y - (self.blipSize / 2), self.blipSize, self.blipSize, self.textureDefaultBlip, 0, 0, 0, tocolor(255, 145, 90, (alpha)%255))
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
				
				dxDrawImage(x - self.blipSize, y - self.blipSize, self.blipSize * 2, self.blipSize * 2, self.textureDefaultBlip, 0, 0, 0, tocolor(90, 145, 255, (alpha)%255))
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
	
	dxDrawImage((self.size / 2) - (self.blipSize / 2), (self.size / 2) - (self.blipSize / 2), self.blipSize, self.blipSize, self.texturePlayerBlip, 0, 0, 0, tocolor(255, 255, 255, 255))

	dxSetBlendMode("blend")
	dxSetRenderTarget()
end


function Radar_C:drawFinalRadar()
	dxSetRenderTarget(self.renderTargetFinal, true)
	
	self.maskShader:setValue("inTexture", self.renderTargetRadar)
	self.maskShader:setValue("maskTexture", self.textureMask)

	dxDrawImage(0, 0, self.size, self.size, self.textureMaskBG)
	dxDrawImage(10, 10, self.size - 20, self.size - 20, self.maskShader)
	
	dxSetRenderTarget()
end


function Radar_C:drawZoneName()
	self.zoneName = getZoneName(self.playerPos.x, self.playerPos.y, self.playerPos.z, false)

	if (self.zoneName) then
		dxSetRenderTarget(self.renderTargetFinal, false)
		
		local shadowOffset = 2
		local fontScale = 0.8
		local fontheight = dxGetFontHeight(self.fontScale, self.hud.fontBold)
		local x = self.size / 2
		local y = fontheight - 5
		
		dxDrawText(self.zoneName, x - 1, y - 1, x - 1, y - 1, tocolor(220, 220, 220, 255), fontScale, self.hud.fontBold, "center", "center", false, false, false, true, true)
		dxDrawText(self.zoneName, x + shadowOffset, y + shadowOffset, x + shadowOffset, y + shadowOffset, tocolor(0, 0, 0, 255), fontScale, self.hud.fontBold, "center", "center", false, false, false, true, true)
		dxDrawText(self.zoneName, x, y, x, y, tocolor(90, 220, 180, 255), fontScale, self.hud.fontBold, "center", "center", false, false, false, true, true)
		
		dxSetRenderTarget()
		
	end
end



function Radar_C:clear()
	if (self.textureMap) then
		self.textureMap:destroy()
		self.textureMap = nil
	end
	
	if (self.textureDefaultBlip) then
		self.textureDefaultBlip:destroy()
		self.textureDefaultBlip = nil
	end
	
	if (self.texturePlayerBlip) then
		self.texturePlayerBlip:destroy()
		self.texturePlayerBlip = nil
	end
	
	if (self.textureMask) then
		self.textureMask:destroy()
		self.textureMask = nil
	end
	
	if (self.textureMaskBG) then
		self.textureMaskBG:destroy()
		self.textureMaskBG = nil
	end
	
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

	mainOutput("Radar_C was stoppoke.")
end