PokeDex_C = inherit(Class)

function PokeDex_C:constructor()

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.components = {}
	
	self.width = self.screenWidth
	self.height = self.screenHeight
	self.x = 0
	self.y = 0
	
	self.currentAlpha = 0
	self.maxAlpha = 255
	
	self.displayWidth = self.width * 0.515
	self.displayHeight = self.height * 0.6
	self.displayX = self.screenWidth * 0.478
	self.displayY = self.screenHeight * 0.2
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("PokeDex_C was started.")
	end
end


function PokeDex_C:init()
	self.components[1] = dxWindow:new(self.x, self.y, self.width, self.height, Textures["pokedex"].pokedex_frame, nil)
	self.components[2] = dxImage:new(self.displayX, self.displayY, self.displayWidth, self.displayHeight, Textures["computer"].screen_bg, nil)
	self.components[3] = PokeDexGUI_C:new(self.displayX, self.displayY, self.displayWidth, self.displayHeight)
end


function PokeDex_C:fadeIn()
	self.currentAlpha = 0
end


function PokeDex_C:update(delta, renderTarget)
	if (renderTarget) then
		if (self.currentAlpha < self.maxAlpha) then
			self.currentAlpha = self.currentAlpha + 5
			
			if (self.currentAlpha > self.maxAlpha) then
				self.currentAlpha = self.maxAlpha
			end
		end
		
		dxSetRenderTarget(renderTarget, false)
		dxSetBlendMode("modulate_add")
		
		for index, component in ipairs(self.components) do
			if (component) then
				component:update()
				component:setAlpha(self.currentAlpha)
			end
		end
		
		dxSetBlendMode("blend")
		dxSetRenderTarget()
	end
end


function PokeDex_C:clear()
	for index, component in ipairs(self.components) do
		if (component) then
			component:delete()
			component = nil
		end
	end
end


function PokeDex_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("PokeDex_C was deleted.")
	end
end
