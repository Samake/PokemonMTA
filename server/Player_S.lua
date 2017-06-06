--[[
	Filename: Player_S.lua
	Authors: Sam@ke
--]]

Player_S = {}

function Player_S:constructor(id, player)
	self.id = id
	self.player = player
	
	self.x = 0
	self.y = 0
	self.z = 0
	self.rx = 0
	self.ry = 0
	self.rz = 0
	
	if (SpawnList.playerSpawn) then
		local randomSpawn = SpawnList.playerSpawn[math.random(1, #SpawnList.playerSpawn)]
		
		if (randomSpawn) then
			self.x = randomSpawn.x
			self.y = randomSpawn.y
			self.z = randomSpawn.z
			self.rx = randomSpawn.rx
			self.ry = randomSpawn.ry
			self.rz = randomSpawn.rz
		end
	end
	
	self.skinID = 258
	
	self.companion = nil
	
	self:init()
	
	--mainOutput("Player_S " .. self.id .. " was started.")
end


function Player_S:init()
	self.m_ToggleCompanion = bind(self.toggleCompanion, self)
	
	addEvent("DOTOGGLECOMPANION", true)
	addEventHandler("DOTOGGLECOMPANION", root, self.m_ToggleCompanion)
	
	self:spawn()
end


function Player_S:spawn()
	if (self.player) then
		self.player:spawn(self.x, self.y, self.z, self.rz, self.skinID)
		fadeCamera(self.player, true, 1.0)
	end
end

function Player_S:update()
	if (self.player and isElement(self.player)) then
		self:updateCoords()
	end
	
	if (self.companion) then
		self.companion:update()
	end
end

function Player_S:updateCoords()
	local pos = self.player:getPosition()

	self.x = pos.x
	self.y = pos.y
	self.z = pos.z
	
	local rot = self.player:getRotation()

	self.rx = rot.x
	self.ry = rot.y
	self.rz = rot.z
end


function Player_S:toggleCompanion()
	if (self.player) and (isElement(client)) then
		if (client == self.player) then
			if (not self.companion) then
				self:sendCompanion()
			else
				self:callCompanion()
			end
		end
	end
end


function Player_S:sendCompanion()
	if (not self.companion) and (Pokedex) then
		local rawPokemon = Pokedex[1] -- pikachu
		
		if (rawPokemon) then
			local x, y, z = getAttachedPosition(self.x, self.y, self.z, 0, 0, 0, 2, math.random(0, 360), 1)
			
			local pokemonBluePrint = {}
			
			pokemonBluePrint.spawn = nil
			pokemonBluePrint.owner = self.player
			pokemonBluePrint.id = self.id .. ":" .. rawPokemon.name
			pokemonBluePrint.modelID = rawPokemon.modelID
			pokemonBluePrint.name = rawPokemon.name
			pokemonBluePrint.type = rawPokemon.type
			pokemonBluePrint.legendary = rawPokemon.legendary
			pokemonBluePrint.size = rawPokemon.size
			pokemonBluePrint.level = 1
			pokemonBluePrint.power = math.random(5, 100)
			pokemonBluePrint.x = x
			pokemonBluePrint.y = y
			pokemonBluePrint.z = z
			pokemonBluePrint.rot = math.random(0, 360)
			
			self.companion = new(Pokemon_S, pokemonBluePrint)
			
			local effectSettings = {}
			effectSettings.name = "explosion_door"
			effectSettings.x = x
			effectSettings.y = y
			effectSettings.z = z - 1.5
			effectSettings.rx = 0
			effectSettings.ry = 0
			effectSettings.rz = math.random(0, 360)
			effectSettings.duration = 3000
			
			triggerClientEvent("DOCLIENTEFFECT", root, effectSettings)
		end
		
		mainOutput("SERVER || Companion send out!")
	end
end


function Player_S:callCompanion()
	if (self.companion) then
		
		local effectSettings = {}
		
		effectSettings.name = "camflash"
		effectSettings.x = self.companion.x
		effectSettings.y = self.companion.y
		effectSettings.z = self.companion.z - 0.5
		effectSettings.rx = 0
		effectSettings.ry = 0
		effectSettings.rz = math.random(0, 360)
		effectSettings.duration = 1000
		
		triggerClientEvent("DOCLIENTEFFECT", root, effectSettings)
		
		delete(self.companion)
		self.companion = nil
		
		mainOutput("SERVER || Companion called!")
	end
end


function Player_S:clear()
	removeEventHandler("DOTOGGLECOMPANION", root, self.m_ToggleCompanion)
	
	if (self.companion) then
		delete(self.companion)
		self.companion = nil
	end
end


function Player_S:destructor()
	self:clear()
	
	--mainOutput("Player_S " .. self.id .. " was deleted.")
end
