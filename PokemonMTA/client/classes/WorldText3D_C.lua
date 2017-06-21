WorldText3D_C = inherit(Class)

function WorldText3D_C:constructor()
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.player = getLocalPlayer()
	
	self.maxTextDistance = 75
	self.minTextScale = 0.5
	self.maxTextScale = 5.0
	self.minTextAlpha = 128
	self.maxTextAlpha = 255
	
	self.textElements = {}
		
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("WorldText3D_C was started.")
	end
end


function WorldText3D_C:init()
	self.m_AddText = bind(self.addText, self)
	
	addEvent("POKEMON3DTEXT", true)
	addEventHandler("POKEMON3DTEXT", root, self.m_AddText)
end


function WorldText3D_C:addText(textProperties)
	if (textProperties) then
		local id = self:getFreeID()
		
		if (not self.textElements[id]) then
			self.textElements[id] = {}
			self.textElements[id].text = textProperties.text
			self.textElements[id].x = textProperties.x
			self.textElements[id].y = textProperties.y
			self.textElements[id].z = textProperties.z
			self.textElements[id].r = textProperties.r
			self.textElements[id].g = textProperties.g
			self.textElements[id].b = textProperties.b
			self.textElements[id].a = 1
			self.textElements[id].offset = 0
		end
	end
end


function WorldText3D_C:update(delta, renderTarget)
	if (renderTarget) then
		dxSetRenderTarget(renderTarget, false)

		self:draw3DTexts()
		
		dxSetRenderTarget()
	end
end


function WorldText3D_C:draw3DTexts()
	for index, textSlot in pairs(self.textElements) do
		if (textSlot) then
			local cx, cy, cz = getCameraMatrix()
			local distance = getDistanceBetweenPoints3D(cx, cy, cz, textSlot.x, textSlot.y, textSlot.z)
			
			textSlot.offset = textSlot.offset + 1.25
			textSlot.a = textSlot.a - 0.005
			
			if (textSlot.a <= 0) then
				textSlot.a = 0
				table.remove(self.textElements, index)
			end
					
			if (distance <= self.maxTextDistance) then
				local ntx, nty = getScreenFromWorldPosition(textSlot.x, textSlot.y, textSlot.z)
				local scale = self:getTextScale(distance)
				local alpha = self:getTextAlpha(distance)
				local shadowOffset = 1.5 * scale
				local textColor = tocolor(textSlot.r, textSlot.g, textSlot.b, alpha * textSlot.a)
				
				if (ntx) and (nty) then
					local x = ntx
					local y = nty - textSlot.offset
					
					dxDrawText(textSlot.text, x + shadowOffset, y + shadowOffset, x + shadowOffset, y + shadowOffset, tocolor(0, 0, 0, alpha * textSlot.a), scale, Fonts["pokemon_gb_8_bold"], "center", "center", false, false, false, true, true)
					dxDrawText(textSlot.text, x, y, x, y, textColor, scale, Fonts["pokemon_gb_8_bold"], "center", "center", false, false, false, true, true)	
				end
			end
		end
	end
end


function WorldText3D_C:getFreeID()
	for index, textSlot in pairs(self.textElements) do
		if (not textSlot) then
			return index
		end
	end
	
	return #self.textElements + 1
end


function WorldText3D_C:getTextScale(distanceValue)
    local scaleVar = (self.maxTextDistance * self.minTextScale) / (distanceValue * self.maxTextScale)
    
    if (scaleVar <= self.minTextScale) then
        scaleVar = self.minTextScale
    elseif (scaleVar >= self.maxTextScale) then
        scaleVar = self.maxTextScale 
    end
	
    return scaleVar
end


function WorldText3D_C:getTextAlpha(distanceValue)
	local alphaVar = self.maxTextAlpha - ((self.maxTextAlpha / self.maxTextDistance) * distanceValue)
    
    if (alphaVar <= self.minTextAlpha) then
        alphaVar = self.minTextAlpha
    elseif (alphaVar >= self.maxTextAlpha) then
        alphaVar = self.maxTextAlpha 
    end

    return alphaVar
end


function WorldText3D_C:clear()
	removeEventHandler("POKEMON3DTEXT", root, self.m_AddText)
	
	for index, textSlot in pairs(self.textElements) do
		if (textSlot) then
			textSlot = nil
		end
	end
	
	self.textElements = nil
end


function WorldText3D_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("WorldText3D_C was deleted.")
	end
end