PlayerPokemon_S = inherit(Class)

function PlayerPokemon_S:constructor(id, player, pokedexInfo)
	
	self.player = player
	self.id = id
	self.index = pokedexInfo.index
	self.modelID = pokedexInfo.modelID
	self.name = pokedexInfo.name
	self.pokedexID = pokedexInfo.pokedexID
	self.legendary = pokedexInfo.legendary
	self.size = pokedexInfo.size
	self.type = pokedexInfo.type
	self.rate = pokedexInfo.rate
	self.color = pokedexInfo.color
	self.soundFile = pokedexInfo.soundFile
	self.icon = pokedexInfo.icon
	self.level = math.random(1, 100)
	self.life = math.random(1, 100)
	self.power = math.random(1, 100)

	self:init()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("PlayerPokemon_S " .. self.id .. " was started.")
	end
end


function PlayerPokemon_S:init()

end


function PlayerPokemon_S:update()

end


function PlayerPokemon_S:clear()

end


function PlayerPokemon_S:destructor()
	
	self:clear()
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("PlayerPokemon_S " .. self.id .. " was deleted.")
	end
end
