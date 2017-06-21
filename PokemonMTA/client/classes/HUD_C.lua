HUD_C = inherit(Class)

function HUD_C:constructor()

	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self:initHUD()
	
	self.isShowingPokedex = false
	self.isShowingPC = false
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("HUD_C was started.")
	end
end


function HUD_C:initHUD()
	self.m_ShowComputer = bind(self.showComputer, self)
	self.m_TogglePokeDex = bind(self.togglePokeDex, self)
	
	addEvent("SHOWCLIENTCOMPUTER", true)
	addEventHandler("SHOWCLIENTCOMPUTER", root, self.m_ShowComputer)
	
	bindKey(Bindings["POKEDEX"], "down", self.m_TogglePokeDex)
	
	if (not self.nameTags) then
		self.nameTags = NameTags_C:new()
	end
	
	if (not self.worldText3D) then
		self.worldText3D = WorldText3D_C:new()
	end
	
	if (not self.speechBubbles) then
		self.speechBubbles = SpeechBubbles_C:new()
	end
	
	if (not self.radar) then
		self.radar = Radar_C:new()
	end
	
	if (not self.pokeSlots) then
		self.pokeSlots = PokeSlots_C:new()
	end
	
	if (not self.pokePC) then
		self.pokePC = PokePC_C:new()
	end
	
	if (not self.pokeDex) then
		self.pokeDex = PokeDex_C:new()
	end
end


function HUD_C:showComputer(bool)
	self.isShowingPC = bool
	
	if (self.isShowingPC == true) then
		self.isShowingPokedex = false
		
		if (self.pokePC) then
			self.pokePC:fadeIn()
		end
	end
end


function HUD_C:togglePokeDex()
	if (self.isShowingPC == false) then
		self.isShowingPokedex = not self.isShowingPokedex
	else
		self.isShowingPokedex = false
	end
	
	if (self.isShowingPokedex == true) then
		if (self.pokeDex) then
			self.pokeDex:fadeIn()
		end
	end
end


function HUD_C:update(delta, renderTarget)
	if (renderTarget) then
		
		if (self.isShowingPokedex == false) and (self.isShowingPC == false) then
			
			if (isCursorShowing()) then
				showCursor(false, false)
			end
			
			if (self.nameTags) then
				self.nameTags:update(delta, renderTarget)
			end
			
			if (self.worldText3D) then
				self.worldText3D:update(delta, renderTarget)
			end
			
			if (self.speechBubbles) then
				self.speechBubbles:update(delta, renderTarget)
			end
			
			if (self.radar) then
				self.radar:update(delta, renderTarget)
			end
			
			if (self.pokeSlots) then
				self.pokeSlots:update(delta, renderTarget)
			end
		elseif (self.isShowingPokedex == false) and (self.isShowingPC == true) then
			if (self.pokePC) then
				self.pokePC:update(delta, renderTarget)
			end
			
			if (not isCursorShowing()) then
				showCursor(true, false)
			end
		elseif (self.isShowingPokedex == true) then
			if (self.pokeDex) then
				self.pokeDex:update(delta, renderTarget)
			end
			
			if (not isCursorShowing()) then
				showCursor(true, true)
			end
		end
	end
end


function HUD_C:clear()
	removeEventHandler("SHOWCLIENTCOMPUTER", root, self.m_ShowComputer)
	
	unbindKey(Bindings["POKEDEX"], "down", self.m_TogglePokeDex)
	
	if (self.nameTags) then
		self.nameTags:delete()
		self.nameTags = nil
	end
	
	if (self.worldText3D) then
		self.worldText3D:delete()
		self.worldworldText3D = nil
	end
	
	if (self.speechBubbles) then
		self.speechBubbles:delete()
		self.speechBubbles = nil
	end
	
	if (self.radar) then
		self.radar:delete()
		self.radar = nil
	end
	
	if (self.pokeSlots) then
		self.pokeSlots:delete()
		self.pokeSlots = nil
	end
	
	if (self.pokePC) then
		self.pokePC:delete()
		self.pokePC = nil
	end
	
	if (self.pokeDex) then
		self.pokeDex:delete()
		self.pokeDex = nil
	end
end


function HUD_C:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("HUD_C was deleted.")
	end
end
