Player_S = inherit(Class)

function Player_S:constructor(id, player)
	self.id = id
	self.player = player
	
	self.x = 0
	self.y = 0
	self.z = 0
	self.rx = 0
	self.ry = 0
	self.rz = 0
	
	self.skinID = 258
	
	self.companion = nil
	self.pokemons = {}
	self.maxPokemons = 6
	
	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Player_S " .. self.id .. " was started.")
	end
end


function Player_S:init()
	self.m_ToggleCompanion = bind(self.toggleCompanion, self)
	
	addEvent("DOTOGGLECOMPANION", true)
	addEventHandler("DOTOGGLECOMPANION", root, self.m_ToggleCompanion)
	
	self:initSpawn()
	self:performSpawn()
	self:loadPokemons()
end


function Player_S:initSpawn()
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


function Player_S:performSpawn()
	if (self.player) then
		self.player:spawn(self.x, self.y, self.z, self.rz, self.skinID)
		fadeCamera(self.player, true, 1.0)
	end
end


function Player_S:loadPokemons()
	if (Pokedex) then
		for i = 1, self.maxPokemons do
			self.pokemons[i] = Pokedex[math.random(1, #Pokedex)]
		end
	end
end


function Player_S:update()
	if (self.player and isElement(self.player)) then
		self:updateCoords()
		self:syncPokemon()
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


function Player_S:syncPokemon()
	if (self.player and isElement(self.player)) then
		if (#self.pokemons > 0) then
			triggerClientEvent(self.player, "DOSYNCPLAYERPOKEMON", self.player, self.pokemons)
		end
	end
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
if (not self.companion) and (self.pokemons[1]) then
		local x, y, z = getAttachedPosition(self.x, self.y, self.z, 0, 0, 0, 3, math.random(0, 360), 1)
		self.companion = PokemonManager_S:getSingleton():addPokemon(self.pokemons[1].id, x, y, z, math.random(0, 360), 0, self.radius, 55, 100, self.player)
		
		mainOutput("SERVER || Companion send out!")
	end
end


function Player_S:callCompanion()
	if (self.companion) then
		PokemonManager_S:getSingleton():deletePokemon(self.companion.id)
		self.companion = nil
		
		mainOutput("SERVER || Companion called!")
	end
end


function Player_S:clear()
	removeEventHandler("DOTOGGLECOMPANION", root, self.m_ToggleCompanion)
	
	if (self.companion) then
		PokemonManager_S:getSingleton():deletePokemon(self.companion)
		self.companion = nil
	end
end


function Player_S:destructor()
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Player_S " .. self.id .. " was deleted.")
	end
end
