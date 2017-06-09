--[[
	Filename: Text3D_C.lua
	Author: Sam@ke
--]]

local Instance = nil

Text3D_C = {}

function Text3D_C:constructor(parent)
	
	self.hud = parent
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.player = getLocalPlayer()
	
	self.maxTextDistance = 75
	self.minTextScale = 0.5
	self.maxTextScale = 5.0
	self.minTextAlpha = 128
	self.maxTextAlpha = 255
	
	self:init()
	
	self.texts3D = {}
	
	mainOutput("Text3D_C was loaded.")
end


function Text3D_C:init()
	self.m_AddText = bind(self.addText, self)
	
	addEvent("POKEMON3DTEXT", true)
	addEventHandler("POKEMON3DTEXT", root, self.m_AddText)
end


function Text3D_C:addText(textProperties)
	if (textProperties) then
		local id = self:getFreeID()
		
		if (not self.texts3D[id]) then
			self.texts3D[id] = {}
			self.texts3D[id].text = textProperties.text
			self.texts3D[id].x = textProperties.x
			self.texts3D[id].y = textProperties.y
			self.texts3D[id].z = textProperties.z
			self.texts3D[id].r = textProperties.r
			self.texts3D[id].g = textProperties.g
			self.texts3D[id].b = textProperties.b
			self.texts3D[id].a = 1
			self.texts3D[id].offset = 0
		end
	end
end


function Text3D_C:update(delta, renderTarget)
	if (renderTarget) and (self.hud) then
		dxSetRenderTarget(renderTarget, false)

		self:draw3DTexts()
	end
end


function Text3D_C:draw3DTexts()
	for index, textSlot in pairs(self.texts3D) do
		if (textSlot) then
			local cx, cy, cz = getCameraMatrix()
			local distance = getDistanceBetweenPoints3D(cx, cy, cz, textSlot.x, textSlot.y, textSlot.z)
					
			if (distance <= self.maxTextDistance) then
				local ntx, nty = getScreenFromWorldPosition(textSlot.x, textSlot.y, textSlot.z)
				local scale = self:getTextScale(distance)
				local alpha = self:getTextAlpha(distance)
				local shadowOffset = 1.5 * scale
				local textColor = tocolor(textSlot.r, textSlot.g, textSlot.b, alpha * textSlot.a)
				
				if (ntx) and (nty) then
					-- // name // --
					local x = ntx
					local y = nty - textSlot.offset
					
					dxDrawText(textSlot.text, x + shadowOffset, y + shadowOffset, x + shadowOffset, y + shadowOffset, tocolor(0, 0, 0, alpha * textSlot.a), scale, self.hud.fontBold, "center", "center", false, false, false, true, true)
					dxDrawText(textSlot.text, x, y, x, y, textColor, scale, self.hud.fontBold, "center", "center", false, false, false, true, true)
					
					textSlot.offset = textSlot.offset + 1.25
					textSlot.a = textSlot.a - 0.005
					
					if (textSlot.a <= 0) then
						textSlot.a = 0
						table.remove(self.texts3D, index)
					end	
				end
			end
		end
	end
end


function Text3D_C:getFreeID()
	for index, text in pairs(self.texts3D) do
		if (not text) then
			return index
		end
	end
	
	return #self.texts3D + 1
end


function Text3D_C:getTextScale(distanceValue)
    local scaleVar = (self.maxTextDistance * self.minTextScale) / (distanceValue * self.maxTextScale)
    
    if (scaleVar <= self.minTextScale) then
        scaleVar = self.minTextScale
    elseif (scaleVar >= self.maxTextScale) then
        scaleVar = self.maxTextScale 
    end
	
    return scaleVar
end


function Text3D_C:getTextAlpha(distanceValue)
	local alphaVar = self.maxTextAlpha - ((self.maxTextAlpha/self.maxTextDistance) * distanceValue)
    
    if (alphaVar <= self.minTextAlpha) then
        alphaVar = self.minTextAlpha
    elseif (alphaVar >= self.maxTextAlpha) then
        alphaVar = self.maxTextAlpha 
    end

    return alphaVar
end


function Text3D_C:clear()
	removeEventHandler("POKEMON3DTEXT", root, self.m_AddText)
end


function Text3D_C:destructor()
	self:clear()

	mainOutput("Text3D_C was stoppoke.")
end