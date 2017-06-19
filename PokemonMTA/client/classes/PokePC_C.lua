PokePC_C = inherit(Class)

function PokePC_C:constructor()

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.components = {}
	
	self.width = self.screenWidth * 0.9
	self.height = self.screenHeight * 0.9
	self.x = (self.screenWidth / 2) - (self.width / 2)
	self.y = (self.screenHeight / 2) - (self.height / 2)
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("PokePC_C was started.")
	end
end


function PokePC_C:init()
	self.components.window = dxWindow:new(self.x, self.y, self.width, self.height, Textures["computer"].computer_frame, nil)
end


function PokePC_C:update(delta, renderTarget)
	if (renderTarget) then
		dxSetRenderTarget(renderTarget, true)
		dxSetBlendMode("modulate_add")
		
		for index, component in pairs(self.components) do
			if (component) then
				component:update()
			end
		end
		
		dxSetBlendMode("blend")
		dxSetRenderTarget()
	end
end


function PokePC_C:clear()
	for index, component in ipairs(self.components) do
		if (component) then
			component:delete()
			component = nil
		end
	end
end


function PokePC_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("PokePC_C was deleted.")
	end
end
