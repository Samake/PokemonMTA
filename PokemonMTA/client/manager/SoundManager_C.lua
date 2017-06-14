SoundManager_C = inherit(Singleton)

function SoundManager_C:constructor()

	self.musicAmbient = "res/sounds/music/music_1_03_kalos.mp3"
	self.musicBattle = "res/sounds/music/music_1_11_battle.mp3"
	
	self.ambientVolume = 0.1
	self.battleVolume = 0.2
	
	self.ambientMusic = nil
	self.battleMusic = nil
	
	self:initManager()
	
	if (Settings.showManagerDebugInfo == true) then
		mainOutput("SoundManager_C was started.")
	end
end


function SoundManager_C:initManager()
	self.m_StartBattle = bind(self.startBattle, self)
	self.m_StopBattle = bind(self.stopBattle, self)
	self.m_PlaySound3D = bind(self.playSound3D, self)
	
	addEvent("POKEMONSTARTBATTLESOUND", true)
	addEventHandler("POKEMONSTARTBATTLESOUND", root, self.m_StartBattle)
	
	addEvent("POKEMONSTOPBATTLESOUND", true)
	addEventHandler("POKEMONSTOPBATTLESOUND", root, self.m_StopBattle)
	
	addEvent("POKEMONPLAY3DSOUND", true)
	addEventHandler("POKEMONPLAY3DSOUND", root, self.m_PlaySound3D)
	
	self:playAmbientMusic()
end


function SoundManager_C:playAmbientMusic()
	self.ambientMusic = playSound(self.musicAmbient, true)
	
	if (self.ambientMusic) then
		self.ambientMusic:setVolume(self.ambientVolume)
	end
end


function SoundManager_C:startBattle()
	if (self.ambientMusic) then
		self.ambientMusic:setPaused(true)
	end
	
	self.battleMusic = playSound(self.musicBattle, true)
	
	if (self.battleMusic) then
		self.battleMusic:setVolume(self.battleVolume)
	end
end


function SoundManager_C:stopBattle()
	if (self.battleMusic) then
		self.battleMusic:stop()
	end
	
	if (self.ambientMusic) then
		self.ambientMusic:setPaused(false)
	end
end


function SoundManager_C:playSound3D(soundSettings)
	if (soundSettings) then
		if (soundSettings.soundFile) then
			local sound3D = playSound3D(soundSettings.soundFile, soundSettings.x, soundSettings.y, soundSettings.z)
			
			if (sound3D) then
				sound3D:getMaxDistance(soundSettings.distance)
				sound3D:setVolume(soundSettings.volume)
			end
		end
	end
end


function SoundManager_C:update(delta)
	
end


function SoundManager_C:clear()
	removeEventHandler("POKEMONSTARTBATTLESOUND", root, self.m_StartBattle)
	removeEventHandler("POKEMONSTOPBATTLESOUND", root, self.m_StopBattle)
	removeEventHandler("POKEMONPLAY3DSOUND", root, self.m_PlaySound3D)
	
	if (self.battleMusic) then
		self.battleMusic:stop()
	end
	
	if (self.ambientMusic) then
		self.ambientMusic:stop()
	end
end


function SoundManager_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		mainOutput("SoundManager_C was deleted.")
	end
end
