dxWindow = inherit(Class)

function dxWindow:constructor(x, y, width, height, texture, parent)

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.texture = texture
	self.parent = parent
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("dxWindow was started.")
	end
end


function dxWindow:setTexture(texture)
	self.texture = texture
end


function dxWindow:init()
	
end


function dxWindow:update()
	
	if (self.texture) then
		dxDrawImage(self.x, self.y, self.width, self.height, self.texture)
	else
		dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(45, 45, 45, 128))
	end
end


function dxWindow:clear()

end


function dxWindow:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("dxWindow was deleted.")
	end
end
