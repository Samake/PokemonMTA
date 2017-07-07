Player_S = inherit(Class)

function Player_S:constructor(playerSettings)
	self.id = playerSettings.id
	self.accountName = playerSettings.accountName
	self.password = playerSettings.password
	self.player = playerSettings.player
	self.skinID = playerSettings.skinID
	self.x = playerSettings.x
	self.y = playerSettings.y
	self.z = playerSettings.z
	self.rx = playerSettings.rx
	self.ry = playerSettings.ry
	self.rz = playerSettings.rz
	self.title = playerSettings.title
	self.playerXP = playerSettings.playerXP
	self.playerLevel = playerSettings.playerLevel
	self.money = playerSettings.money
	self.pokemonSeen = playerSettings.pokemonSeen
	self.pokemonCatched = playerSettings.pokemonCatched
	self.pokemonKilled = playerSettings.pokemonKilled
	
	self.playerName = removeHEXColorCode(self.player:getName())
	
	self.companion = nil
	self.pokemons = {}
	self.maxPokemons = 6
	
	self.isInConversation = "false"
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Player_S " .. self.id .. " was started.")
	end
end


function Player_S:init()

	toggleControl(self.player, "fire", false)
	
	self.m_ToggleCompanion = bind(self.toggleCompanion, self)
	
	addEvent("DOTOGGLECOMPANION", true)
	addEventHandler("DOTOGGLECOMPANION", root, self.m_ToggleCompanion)
	
	self:initSpawn()
	self:performSpawn()
	self:loadInventory()
	self:loadAchievments()
	self:loadPokedex()
	self:loadPokemons()
end


function Player_S:initSpawn()
	if (not self.x) or (not self.y) or (not self.z) or (not self.rx) or (not self.ry) or (not self.rz) then
		local playerSpawns = getElementsByType("PLAYERSPAWN")
			
		if (playerSpawns) then
			if (#playerSpawns > 0) then
				local randomSpawn = playerSpawns[math.random(1, #playerSpawns)]
			
				if (randomSpawn) then
					
					local pos = randomSpawn.position
					local rot = randomSpawn.rotation
					
					self.x = pos.x
					self.y = pos.y
					self.z = pos.z
					self.rx = rot.x
					self.ry = rot.y
					self.rz = rot.z
				end
			end
		end
	end
end


function Player_S:performSpawn()
	if (self.player) then
		self.player:spawn(self.x, self.y, self.z, self.rz, self.skinID)
		fadeCamera(self.player, true, 1.0)
	end
end


function Player_S:loadInventory()
	if (not self.inventory) then
		self.inventory = Inventory_S:new(self.id)
	end
end


function Player_S:loadAchievments()
	if (not self.achievments) then
		self.achievments = Achievments_S:new(self.id)
	end
end


function Player_S:loadPokedex()
	if (not self.pokedex) then
		self.pokedex = Pokedex_S:new(self.id)
	end
end


function Player_S:loadPokemons()
	if (Pokedex) then
		for i = 1, self.maxPokemons do
			if (not self.pokemons[i]) then
				local id = "pokemon_" .. tostring(self.player) .. "_" .. i
				self.pokemons[i] = new(PlayerPokemon_S, id, self.player, Pokedex[math.random(1, #Pokedex)])
			end
		end
	end
end


function Player_S:update()
	if (self.player and isElement(self.player)) then
		self:updateCoords()
		self:updateInventory()
		self:updateAchievments()
		self:updatePokedex()
		self:syncPokemon()
		
		for index, playerPokemon in pairs(self.pokemons) do
			if (playerPokemon) then
				playerPokemon:update()
			end
		end
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


function Player_S:updateInventory()
	if (self.inventory) then
		self.inventory:update()
	end
end


function Player_S:updateAchievments()
	if (self.achievments) then
		self.achievments:update()
	end
end


function Player_S:updatePokedex()
	if (self.pokedex) then
		self.pokedex:update()
	end
end


function Player_S:syncPokemon()
	if (self.player and isElement(self.player)) then
		if (#self.pokemons > 0) then
			triggerClientEvent(self.player, "DOSYNCPLAYERPOKEMON", self.player, self.pokemons)
		end
	end
end


function Player_S:toggleCompanion(slot)
	if (self.player) and (isElement(client)) and (slot) then
		if (client == self.player) then
			if (self.companion) then
				if (slot == self.companion.slot) then
					self:callCompanion()
				else
					self:callCompanion()
					self:sendCompanion(slot)
				end
			else
				self:sendCompanion(slot)
			end
		end
	end
end


function Player_S:sendCompanion(slot)
	if (self.player and isElement(self.player)) and (slot) then
		if (not self.companion) and (self.pokemons[slot]) then
			self.companion = {}
			self.companion.slot = slot

			local x, y, z = getAttachedPosition(self.x, self.y, self.z, self.rx, self.ry, self.rz, 2.5 * self.pokemons[slot].size, 310, 1)
			local dimension = self.player:getDimension()

			self.companion.pokemon = PokemonManager_S:getSingleton():addPokemon(self.pokemons[slot].index, x, y, z, self.rz, dimension, self.radius, self.pokemons[slot].level, self.pokemons[slot].life, self.pokemons[slot].power, self.player)
			
			sendMessage("SERVER || Companion send out!")
		end
	end
end


function Player_S:callCompanion()
	if (self.companion) then
		if (self.companion.pokemon) then
			PokemonManager_S:getSingleton():deletePokemon(self.companion.pokemon.id)
			self.companion = nil
			
			sendMessage("SERVER || Companion called!")
		end
	end
end


function Player_S:clear()
	
	removeEventHandler("DOTOGGLECOMPANION", root, self.m_ToggleCompanion)
	
	for index, playerPokemon in pairs(self.pokemons) do
		if (playerPokemon) then
			playerPokemon:delete()
			playerPokemon = nil
		end
	end
		
	if (self.companion) then
		if (self.companion.pokemon) then
			PokemonManager_S:getSingleton():deletePokemon(self.companion.pokemon.id)
			self.companion = nil
		end
	end
	
	if (self.pokedex) then
		self.pokedex:delete()
		self.pokedex = nil
	end
	
	if (self.achievments) then
		self.achievments:delete()
		self.achievments = nil
	end
	
	if (self.inventory) then
		self.inventory:delete()
		self.inventory = nil
	end
	
	toggleControl(self.player, "fire", true)
end


function Player_S:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		sendMessage("Player_S " .. self.id .. " was deleted.")
	end
end
