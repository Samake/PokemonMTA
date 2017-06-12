Textures = {}

function Textures:init()
	Textures["gui"] = {}
	Textures["gui"].pokeNameTag = dxCreateTexture("res/textures/pokeNameTag.png", "argb")
	Textures["gui"].pokeNameTagBG = dxCreateTexture("res/textures/pokeNameTagBG.png", "argb")
	Textures["gui"].slotBG = dxCreateTexture("res/textures/slot_bg.png", "argb")
	Textures["gui"].pokeBallIcon = dxCreateTexture("res/textures/pokeball_icon.png", "argb")
	Textures["gui"].pokeBallIconDisabled = dxCreateTexture("res/textures/pokeball_icon_disabled.png", "argb")
	
	Textures["radar"] = {}
	Textures["radar"].radarBG = dxCreateTexture("res/textures/radar_bg.png", "argb")
	Textures["radar"].defaultBlip = dxCreateTexture("res/textures/default_blip.png", "argb")
	Textures["radar"].playerBlip = dxCreateTexture("res/textures/player_blip.png", "argb")
	Textures["radar"].radarMask = dxCreateTexture("res/textures/radar_mask.png", "argb")
	Textures["radar"].radarMaskBG = dxCreateTexture("res/textures/radar_mask_bg.png", "argb")
	Textures["radar"].radarFrame = dxCreateTexture("res/textures/radar_frame.png", "argb")
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Textures were loaded.")
	end
end


function Textures:cleanUp()
	for index, category in pairs(Textures) do
		if (category) then
			if (type(category) == "table") then
				for index, texture in pairs(category) do
					if (texture) then
						if (isElement(texture)) then
							texture:destroy()
							texture = nil
						end
					end
				end 
			end
		end
	end
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Textures were deleted.")
	end
end
