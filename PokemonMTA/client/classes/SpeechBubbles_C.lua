SpeechBubbles_C = inherit(Class)

function SpeechBubbles_C:constructor()
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.player = getLocalPlayer()
	
	self.maxTextDistance = 50
	self.minTextScale = 0.5
	self.maxTextScale = 3.5
	
	self.x = 0
	self.y = 0
	self.z = 0
	self.alpha = 0
	
	self.width = 64
	self.height = 32
		
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("SpeechBubbles_C was started.")
	end
end


function SpeechBubbles_C:init()
	self.m_AddSpeechBubble = bind(self.addSpeechBubble, self)
	self.m_RemoveSpeechBubble = bind(self.removeSpeechBubble, self)
	
	addEvent("POKEMONSPEECHBUBBLEENABLE", true)
	addEventHandler("POKEMONSPEECHBUBBLEENABLE", root, self.m_AddSpeechBubble)
	
	addEvent("POKEMONSPEECHBUBBLEDISABLE", true)
	addEventHandler("POKEMONSPEECHBUBBLEDISABLE", root, self.m_RemoveSpeechBubble)
end


function SpeechBubbles_C:addSpeechBubble(speechProperties)
	if (speechProperties) then
		self.text = speechProperties.text
		self.x = speechProperties.x
		self.y = speechProperties.y
		self.z = speechProperties.z
		
		self.alpha = 0
	end
end


function SpeechBubbles_C:removeSpeechBubble()
	self.text = nil
	self.x = 0
	self.y = 0
	self.z = 0
	self.alpha = 0
end


function SpeechBubbles_C:update(delta, renderTarget)
	if (renderTarget) then
		dxSetRenderTarget(renderTarget, false)

		self:draw3DTexts()
		
		dxSetRenderTarget()
	end
end


function SpeechBubbles_C:draw3DTexts()
	if (self.text) then
		
		if (self.alpha < 255) then
			self.alpha = self.alpha + 10
			
			if (self.alpha > 255) then
				self.alpha = 255
			end
		end
		
		local cx, cy, cz = getCameraMatrix()
		local distance = getDistanceBetweenPoints3D(cx, cy, cz, self.x, self.y, self.z)
				
		if (distance <= self.maxTextDistance) then
			local ntx, nty = getScreenFromWorldPosition(self.x, self.y, self.z)
			local scale = self:getTextScale(distance)
			local shadowOffset = 1.5 * scale
		
			if (ntx) and (nty) then
				-- // draw bg // -- 
				local width = dxGetTextWidth(removeHEXColorCode(self.text), scale, Fonts["pokemon_gb_8_bold"], false) + self.width
				local height = dxGetFontHeight(scale, Fonts["pokemon_gb_8_bold"]) + self.height
				local x = ntx - (width / 2)
				local y = nty - (height / 2)
				
				dxDrawRectangle(x , y, width, height, tocolor(0, 0, 0, self.alpha * 0.85), false, true)
				dxDrawRectangle(x + 2, y + 2, width - 4, height - 4, tocolor(75, 75, 75, self.alpha * 0.85), false, true)
				
				-- // draw text // -- 
				local x = ntx
				local y = nty
				
				dxDrawText(removeHEXColorCode(self.text), x + shadowOffset, y + shadowOffset, x + shadowOffset, y + shadowOffset, tocolor(0, 0, 0, self.alpha), scale, Fonts["pokemon_gb_8_bold"], "center", "center", false, false, false, false, true)
				dxDrawText(self.text, x, y, x, y, tocolor(255, 255, 255, self.alpha), scale, Fonts["pokemon_gb_8_bold"], "center", "center", false, false, false, true, true)	
			end
		else
			self:removeSpeechBubble()
		end
	end
end


function SpeechBubbles_C:getTextScale(distanceValue)
    local scaleVar = (self.maxTextDistance * self.minTextScale) / (distanceValue * self.maxTextScale)
    
    if (scaleVar <= self.minTextScale) then
        scaleVar = self.minTextScale
    elseif (scaleVar >= self.maxTextScale) then
        scaleVar = self.maxTextScale 
    end
	
    return scaleVar
end


function SpeechBubbles_C:clear()
	removeEventHandler("POKEMONSPEECHBUBBLEENABLE", root, self.m_AddSpeechBubble)
	removeEventHandler("POKEMONSPEECHBUBBLEDISABLE", root, self.m_RemoveSpeechBubble)
end


function SpeechBubbles_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("SpeechBubbles_C was deleted.")
	end
end