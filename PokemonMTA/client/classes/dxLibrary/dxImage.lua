dxImage = inherit(Class)

function dxImage:constructor(x, y, width, height, texture, parent)

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.texture = texture
	self.parent = parent
	
	self.alpha = 255
	
	self.mouseX = 0
	self.mouseY = 0
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("dxImage was started.")
	end
end


function dxImage:setTexture(texture)
	self.texture = texture
end


function dxImage:init()
	
end


function dxImage:update()
	self.mouseX, self.mouseY = getCursorPosition()
	
	if (self.texture) then
		dxDrawImage(self.x, self.y, self.width, self.height, self.texture, 0, 0, 0, tocolor(255, 255, 255, self.alpha), false)
	end
end


function dxImage:getAlpha()
	return self.alpha
end


function dxImage:setAlpha(alpha)
	if (alpha) then
		self.alpha = alpha
	end
end


function dxImage:isCursorInside()
	if (self.mouseX) and (self.mouseY) then
		if (self.mouseX * self.screenWidth > self.x) and (self.mouseX * self.screenWidth < self.x + self.width) then
			if (self.mouseY * self.screenHeight > self.y) and (self.mouseY * self.screenHeight < self.y + self.height) then
				return true
			end
		end
	end
	
	return false
end

function dxImage:clear()

end


function dxImage:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("dxImage was deleted.")
	end
end
