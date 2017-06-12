Core_C = inherit(Singleton)

function Core_C:constructor()
	if (Settings.showCoreDebugInfo == true) then
		mainOutput("Core_C was loaded.")
	end

	self.showMTAHUD = false

	self:initClient()
	self:initComponents()
end


function Core_C:initClient()
	setDevelopmentMode(true, true)
	
	self.m_ToggleDebug = bind(self.toggleDebug, self)
	bindKey(Bindings["DEBUG"], "down", self.m_ToggleDebug)
	
	self.m_Update = bind(self.update, self)
	addEventHandler("onClientPreRender", root, self.m_Update)
end


function Core_C:initComponents()

	ModelHandler:init()
	Textures:init()
	Fonts:init()
	
	DevTools_C:new()
	Debug_C:new()
	
	Camera_C:new()
	Player_C:new()
	EffectManager_C:new()
	SoundManager_C:new()
	ShaderManager_C:new()
end


function Core_C:toggleDebug()
	Settings.debugEnabled = not Settings.debugEnabled
	
	if (Settings.debugEnabled == true) then
		mainOutput("CLIENT || Debug mode enabled!")
	else
		mainOutput("CLIENT || Debug mode disabled!")
	end
end


function Core_C:update(deltaTime)
	setPlayerHudComponentVisible("all", self.showMTAHUD)
	
	if (deltaTime) then
		self.delta = (1 / 17) * deltaTime
	end
	
	DevTools_C:getSingleton():update(self.delta)
	Debug_C:getSingleton():update(self.delta)
	
	Camera_C:getSingleton():update(self.delta)
	Player_C:getSingleton():update(self.delta)
	EffectManager_C:getSingleton():update(self.delta)
	SoundManager_C:getSingleton():update(self.delta)
	ShaderManager_C:getSingleton():update(self.delta)
end


function Core_C:clear()
	removeEventHandler("onClientPreRender", root, self.m_Update)
	unbindKey(Bindings["DEBUG"], "down", self.m_ToggleDebug)

	delete(DevTools_C:getSingleton())
	delete(Debug_C:getSingleton())
	
	delete(Camera_C:getSingleton())
	delete(Player_C:getSingleton())
	delete(EffectManager_C:getSingleton())
	delete(SoundManager_C:getSingleton())
	delete(ShaderManager_C:getSingleton())
	
	Textures:cleanUp()
	Fonts:cleanUp()
	
	setDevelopmentMode(false, false)
	setPlayerHudComponentVisible("all", true)
end


function Core_C:destructor()
	self:clear()
	
	if (Settings.showCoreDebugInfo == true) then
		mainOutput("Core_C was deleted.")
	end
end


addEventHandler("onClientResourceStart", resourceRoot,
function()
	Core_C:new()
end)


addEventHandler("onClientResourceStop", resourceRoot,
function()
	delete(Core_C:getSingleton())
end)
