dxWindow = inherit(Class)

function dxWindow:constructor(x, y, width, height, texture, parent)

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
		sendMessage("dxWindow was started.")
	end
end


function dxWindow:setTexture(texture)
	self.texture = texture
end


function dxWindow:init()
	
end


function dxWindow:update()
	self.mouseX, self.mouseY = getCursorPosition()
	
	if (self.texture) then
		dxDrawImage(self.x, self.y, self.width, self.height, self.texture, 0, 0, 0, tocolor(255, 255, 255, self.alpha), false)
	else
		dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(45, 45, 45, self.alpha))
	end
end


function dxWindow:getAlpha()
	return self.alpha
end


function dxWindow:setAlpha(alpha)
	if (alpha) then
		self.alpha = alpha
	end
end


function dxWindow:isCursorInside()
	if (self.mouseX) and (self.mouseY) then
		if (self.mouseX * self.screenWidth > self.x) and (self.mouseX * self.screenWidth < self.x + self.width) then
			if (self.mouseY * self.screenHeight > self.y) and (self.mouseY * self.screenHeight < self.y + self.height) then
				return true
			end
		end
	end
	
	return false
end

function dxWindow:clear()

end


function dxWindow:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("dxWindow was deleted.")
	end
end
