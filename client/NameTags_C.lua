--[[
	Filename: NameTags_C.lua
	Author: Sam@ke
--]]

local Instance = nil

NameTags_C = {}

function NameTags_C:constructor(parent)
	
	self.hud = parent
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.player = getLocalPlayer()
	
	self.maxNameTagDistance = 75
	self.minNameTagScale = 0.5
	self.maxNameTagScale = 5.0
	self.minNameTagAlpha = 128
	self.maxNameTagAlpha = 255
	self.lifeBarWidth = 90
	self.lifeBarHeight = 10
	
	self.nameTagWidth = self.screenWidth * 0.15
	self.nameTagHeight = self.nameTagWidth * 0.3
	
	self.drawLevel = 2 -- // 0 off, 1 on, 2 debug
	self.isDebug = false
	
	self:init()
	
	mainOutput("NameTags_C was loaded.")
end


function NameTags_C:init()
	self.m_ChangeDrawLevel = bind(self.changeDrawLevel, self)
	
	bindKey(Bindings:getNameTagsKey(), "down", self.m_ChangeDrawLevel)
end


function NameTags_C:changeDrawLevel()
	self.drawLevel = self.drawLevel + 1
	
	if (self.drawLevel > 2) then
		self.drawLevel = 0
	end
end


function NameTags_C:update(delta, renderTarget)
	if (renderTarget) and (self.hud) then
		dxSetRenderTarget(renderTarget, false)
		
		self:drawPokemonNameTags()
		self:drawNPCNameTags()
	end
end


function NameTags_C:drawPokemonNameTags()
	if (self.drawLevel > 0) and (isElement(self.player)) then
		for index, ped in pairs(getElementsByType("ped")) do
			if (isElement(ped)) then
				if (ped:getDimension() == self.player:getDimension()) then
					if (ped:getData("isPokemon") == true) then
						local pokeName = ped:getData("POKEMON:NAME") or "Unknown"
						local pokeLevel = ped:getData("POKEMON:LEVEL") or "Unknown"
						local pokeSize = ped:getData("POKEMON:SIZE") or 1
						local isLegendary = ped:getData("POKEMON:LEGENDARY") or false
						local pokeJob = ped:getData("POKEMON:JOB") or "Unknown"
						local pokeState = ped:getData("POKEMON:STATE") or "Unknown"
						local pokePower = ped:getData("POKEMON:POWER") or 50
						local isCompanion = ped:getData("POKEMON:COMPANION") or "false"
					
						local cx, cy, cz, clx, cly, clz = getCameraMatrix()
						local px, py, pz = getElementPosition(ped)
						local distance = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz)
						
						if (distance <= self.maxNameTagDistance) then
							local ntx, nty = getScreenFromWorldPosition(px, py, pz + pokeSize)
							local scale = self:getNameTagScale(distance)
							local alpha = self:getNameTagAlpha(distance)
							local shadowOffset = 1.5 * scale
							local nameColor = tocolor(255, 255, 255, alpha)
				
							if (ntx) and (nty) and (isLineOfSightClear(cx, cy, cz - 1.2, px, py, pz + 1.2, true)) then
								
								if (isCompanion == "true") then
									nameColor = tocolor(0, 255, 0, alpha)
								else
									if (isLegendary == true) then
										nameColor = tocolor(255, 145, 100, alpha)
									end
								end
								
								local width = self.nameTagWidth * scale
								local height = self.nameTagHeight * scale
								ntx = ntx - width * 0.5
								
								if (Textures["gui"].pokeNameTag) and (Textures["gui"].pokeNameTagBG) then
									local x = ntx
									local y = nty
									
									-- // image bg // --
									dxDrawImage(x, y, width, height, Textures["gui"].pokeNameTagBG, 0, 0, 0, tocolor(255, 255, 255, alpha), false)
									
									-- // lifebar // --
									x = ntx + width * 0.32
									y = nty + height * 0.38
									
									local lifeWidth = ((width * 0.57) / 100) * ped:getHealth()
									local lifeHeight = height * 0.1
									
									dxDrawRectangle(x, y, lifeWidth, lifeHeight, tocolor(0, 255, 0, alpha), false, true)
									
									-- // powerbar // --
									x = ntx + width * 0.32
									y = nty + height * 0.55
									
									local powerWidth = ((width * 0.57) / 100) * pokePower
									local powerHeight = height * 0.09
									
									dxDrawRectangle(x, y, powerWidth, powerHeight, tocolor(255, 255, 0, alpha), false, true)
									
									-- // image gui // --
									x = ntx
									y = nty
									
									dxDrawImage(x, y, width, height, Textures["gui"].pokeNameTag, 0, 0, 0, tocolor(255, 255, 255, alpha), false)
									
									-- // level // --
									x = ntx + width * 0.165
									y = nty + height * 0.5
									
									dxDrawText(pokeLevel, x + shadowOffset, y + shadowOffset, x + shadowOffset, y + shadowOffset, tocolor(0, 0, 0, alpha), scale * 0.9, self.hud.fontBold, "center", "center", false, false, false, true, true)
									dxDrawText(pokeLevel, x, y, x, y, tocolor(240, 240, 55, alpha), scale * 0.9, self.hud.fontBold, "center", "center", false, false, false, true, true)
									
									-- // name // --
									x = ntx + width * 0.31
									y = nty + height * 0.13
									
									dxDrawText(pokeName, x + shadowOffset, y + shadowOffset, x + shadowOffset, y + shadowOffset, tocolor(0, 0, 0, alpha), scale * 0.8, self.hud.fontBold, "left", "center", false, false, false, true, true)
									dxDrawText(pokeName, x, y, x, y, nameColor, scale * 0.8, self.hud.fontBold, "left", "center", false, false, false, true, true)
									
									if (self.drawLevel > 1) and (self.isDebug == true) then
										-- // debug info // --
										
										x = ntx + width * 0.5
										y = nty - height * 0.2
										
										dxDrawText(pokeState .. " : " .. pokeJob, x + shadowOffset, y + shadowOffset, x + shadowOffset, y + shadowOffset, tocolor(0, 0, 0, alpha), scale * 1.5, self.hud.fontBold, "center", "center", false, false, false, true, true)
										dxDrawText(pokeState .. " : " .. pokeJob, x, y, x, y, tocolor(220, 45, 45, alpha), scale * 1.5, self.hud.fontBold, "center", "center", false, false, false, true, true)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end


function NameTags_C:drawNPCNameTags()
	if (self.drawLevel > 0) then
		for index, ped in pairs(getElementsByType("ped")) do
			if (isElement(ped)) then
				if (ped:getDimension() == self.player:getDimension()) then
					if (ped:getData("isNPC") == true) then
						local npcName = ped:getData("NPC:NAME") or "Unknown"
						local npcJob = ped:getData("NPC:JOB") or "Unknown"
						local npcState = ped:getData("NPC:STATE") or "Unknown"
					
						local cx, cy, cz, clx, cly, clz = getCameraMatrix()
						local px, py, pz = getElementPosition(ped)
						local distance = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz)
						
						if (distance <= self.maxNameTagDistance) then
							local ntx, nty = getScreenFromWorldPosition(px, py, pz + 1.5)
							local scale = self:getNameTagScale(distance)
							local alpha = self:getNameTagAlpha(distance)
							local shadowOffset = 1.5 * scale
							local nameColor = tocolor(255, 255, 255, alpha)
							
							if (ntx) and (nty) and (isLineOfSightClear(cx, cy, cz, px, py, pz + 1.5, true)) then
								
								local width = self.nameTagWidth * scale
								local height = (self.nameTagHeight / 4) * scale

								-- // name // --
								local x = ntx
								local y = nty + height
								
								dxDrawText(npcName, x + shadowOffset, y + shadowOffset, x + shadowOffset, y + shadowOffset, tocolor(0, 0, 0, alpha), scale * 1.5, self.hud.fontBold, "center", "center", false, false, false, true, true)
								dxDrawText(npcName, x, y, x, y, nameColor, scale * 1.5, self.hud.fontBold, "center", "center", false, false, false, true, true)
								
								if (self.drawLevel > 1) and (self.isDebug == true) then
									-- // debug info // --
									
									x = ntx
									y = nty - height * 0.1
									
									dxDrawText(npcState .. " : " .. npcJob, x + shadowOffset, y + shadowOffset, x + shadowOffset, y + shadowOffset, tocolor(0, 0, 0, alpha), scale * 1.5, self.hud.fontBold, "center", "center", false, false, false, true, true)
									dxDrawText(npcState .. " : " .. npcJob, x, y, x, y, tocolor(220, 45, 45, alpha), scale * 1.5, self.hud.fontBold, "center", "center", false, false, false, true, true)
								end
							end
						end
					end
				end
			end
		end
	end
end


function NameTags_C:getNameTagScale(distanceValue)
    local scaleVar = (self.maxNameTagDistance * self.minNameTagScale) / (distanceValue * self.maxNameTagScale)
    
    if (scaleVar <= self.minNameTagScale) then
        scaleVar = self.minNameTagScale
    elseif (scaleVar >= self.maxNameTagScale) then
        scaleVar = self.maxNameTagScale 
    end
	
    return scaleVar
end


function NameTags_C:getNameTagAlpha(distanceValue)
	local alphaVar = self.maxNameTagAlpha - ((self.maxNameTagAlpha/self.maxNameTagDistance) * distanceValue)
    
    if (alphaVar <= self.minNameTagAlpha) then
        alphaVar = self.minNameTagAlpha
    elseif (alphaVar >= self.maxNameTagAlpha) then
        alphaVar = self.maxNameTagAlpha 
    end

    return alphaVar
end


function NameTags_C:clear()
	unbindKey(Bindings:getNameTagsKey(), "down", self.m_ChangeDrawLevel)
end


function NameTags_C:destructor()
	self:clear()

	mainOutput("NameTags_C was stoppoke.")
end