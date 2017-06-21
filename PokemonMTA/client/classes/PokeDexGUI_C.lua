PokeDexGUI_C = inherit(Class)

function PokeDexGUI_C:constructor(x, y, width, height)

	self.screenWidth, self.screenHeight = guiGetScreenSize()

	self.x = x
	self.y = y
	self.width = width
	self.height = height
	
	self.alpha = 255
	
	self.pokeSlots = {}
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("PokeDexGUI_C was started.")
	end
end


function PokeDexGUI_C:init()

end


function PokeDexGUI_C:update()

	local startX = self.x
	local startY = self.y
	local endX = startX + self.width
	local endY = startY + self.height
	
	dxDrawLine(startX, startY, endX, endY, tocolor(75, 75, 255, self.alpha), 2, false)
	
	local startX = self.x
	local startY = self.y + self.height
	local endX = startX + self.width
	local endY = self.y
	
	dxDrawLine(startX, startY, endX, endY, tocolor(75, 75, 255, self.alpha), 2, false)
end


function PokeDexGUI_C:setAlpha(alpha)
	self.alpha = alpha
end


function PokeDexGUI_C:clear()

end


function PokeDexGUI_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("PokeDexGUI_C was deleted.")
	end
end
