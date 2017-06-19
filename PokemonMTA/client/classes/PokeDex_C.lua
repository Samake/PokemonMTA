PokeDex_C = inherit(Class)

function PokeDex_C:constructor()

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.components = {}
	
	self.width = self.screenWidth * 0.8
	self.height = self.screenHeight * 0.8
	self.x = self.screenWidth - self.width
	self.y = self.screenHeight * 0.1
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("PokeDex_C was started.")
	end
end


function PokeDex_C:init()
	self.components.window = dxWindow:new(self.x, self.y, self.width, self.height, Textures["pokedex"].pokedex_frame, nil)
end


function PokeDex_C:update(delta, renderTarget)
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
		mainOutput("PokeDex_C was deleted.")
	end
end
