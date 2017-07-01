ItemManager_S = inherit(Singleton)

function ItemManager_S:constructor(parent)

    self.coreClass = parent

	self:initManager()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("ItemManager_S was started.")
	end
end


function ItemManager_S:initManager()

end


function ItemManager_S:getBoxContent(player, boxContent, x, y, z)
	if (isElement(player)) and (boxContent) and (x) and (y) and (z) then
		local count = 0
		local playerClass = PlayerManager_S:getSingleton():getPlayerClass(player)
	
		if (playerClass) then
			if (playerClass.inventory) then
				for index, item in pairs(boxContent) do
					if (item) then
						if (item.count) then
							count = count + 1
							
							playerClass.inventory:addItem(index, item.count)
							
							local textProperties = {}
							textProperties.text = "You got " .. item.count .. "x " .. index .. "!"
							textProperties.x = x + (math.random(-50, 50) / 100)
							textProperties.y = y + (math.random(-50, 50) / 100)
							textProperties.z = z + (math.random(0, 100) / 100)
							textProperties.r = 45
							textProperties.g = 220
							textProperties.b = 45
							
							triggerClientEvent(player, "POKEMON3DTEXT", player, textProperties)
							
							local soundSettings = {} 
							soundSettings.soundFile = "res/sounds/effects/pickup_item.ogg"
							soundSettings.x = x
							soundSettings.y = y
							soundSettings.z = z
							soundSettings.distance = 5
							soundSettings.volume = 0.5
							
							triggerClientEvent("POKEMONPLAY3DSOUND", root, soundSettings)
						end
					end
				end
				
				if (count == 0) then
					local textProperties = {}
					textProperties.text = "Empty!"
					textProperties.x = x + (math.random(-50, 50) / 100)
					textProperties.y = y + (math.random(-50, 50) / 100)
					textProperties.z = z + (math.random(0, 100) / 100)
					textProperties.r = 220
					textProperties.g = 45
					textProperties.b = 45
					
					triggerClientEvent(player, "POKEMON3DTEXT", player, textProperties)
					
					local soundSettings = {} 
					soundSettings.soundFile = "res/sounds/effects/empty_chest.wav"
					soundSettings.x = x
					soundSettings.y = y
					soundSettings.z = z
					soundSettings.distance = 5
					soundSettings.volume = 0.5
					
					triggerClientEvent("POKEMONPLAY3DSOUND", root, soundSettings)
				end
			end
		end
	end
end


function ItemManager_S:update()

end


function ItemManager_S:clear()

end


function ItemManager_S:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("ItemManager_S was deleted.")
	end
end
