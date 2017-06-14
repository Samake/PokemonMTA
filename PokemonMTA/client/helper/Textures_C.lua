Textures = {}

function Textures:init()
	Textures["gui"] = {}
	Textures["gui"].pokeNameTag = dxCreateTexture("res/textures/pokeNameTag.png")
	Textures["gui"].pokeNameTagBG = dxCreateTexture("res/textures/pokeNameTagBG.png")
	Textures["gui"].slotBG = dxCreateTexture("res/textures/slot_bg.png")
	
	Textures["radar"] = {}
	Textures["radar"].radarBG = dxCreateTexture("res/textures/radar_bg.png")
	Textures["radar"].defaultBlip = dxCreateTexture("res/textures/default_blip.png")
	Textures["radar"].playerBlip = dxCreateTexture("res/textures/player_blip.png")
	Textures["radar"].radarMask = dxCreateTexture("res/textures/radar_mask.png")
	Textures["radar"].radarMaskBG = dxCreateTexture("res/textures/radar_mask_bg.png")
	Textures["radar"].radarFrame = dxCreateTexture("res/textures/radar_frame.png")
	
	Textures["icons"] = {}
	Textures["icons"].pokeBallIcon = dxCreateTexture("res/textures/icons/pokeball_icon.png")
	Textures["icons"].pokeBallIconDisabled = dxCreateTexture("res/textures/icons/pokeball_icon_disabled.png")
	Textures["icons"].default_icon = dxCreateTexture("res/textures/icons/default_icon.png")
	Textures["icons"].pickachu_icon = dxCreateTexture("res/textures/icons/pickachu_icon.png")
	Textures["icons"].rowlet_icon = dxCreateTexture("res/textures/icons/rowlet_icon.png")
	Textures["icons"].torchic_icon = dxCreateTexture("res/textures/icons/torchic_icon.png")
	Textures["icons"].shaymin_icon = dxCreateTexture("res/textures/icons/shaymin_icon.png")
	Textures["icons"].fennekin_icon = dxCreateTexture("res/textures/icons/fennekin_icon.png")
	Textures["icons"].greninja_icon = dxCreateTexture("res/textures/icons/greninja_icon.png")
	Textures["icons"].squishy_icon = dxCreateTexture("res/textures/icons/squishy_icon.png")
	Textures["icons"].gible_icon = dxCreateTexture("res/textures/icons/gible_icon.png")
	Textures["icons"].glalie_icon = dxCreateTexture("res/textures/icons/glalie_icon.png")
	Textures["icons"].braixen_icon = dxCreateTexture("res/textures/icons/braixen_icon.png")
	Textures["icons"].lopunny_icon = dxCreateTexture("res/textures/icons/lopunny_icon.png")
	Textures["icons"].magearna_icon = dxCreateTexture("res/textures/icons/magearna_icon.png")
	Textures["icons"].sharpedo_icon = dxCreateTexture("res/textures/icons/sharpedo_icon.png")
	Textures["icons"].swampert_icon = dxCreateTexture("res/textures/icons/swampert_icon.png")
	Textures["icons"].mewtwo_icon = dxCreateTexture("res/textures/icons/mewtwo_icon.png")
	Textures["icons"].dragonite_icon = dxCreateTexture("res/textures/icons/dragonite_icon.png")
	Textures["icons"].hydreigon_icon = dxCreateTexture("res/textures/icons/hydreigon_icon.png")
	Textures["icons"].ninetales_icon = dxCreateTexture("res/textures/icons/ninetales_icon.png")
	Textures["icons"].zebstrika_icon = dxCreateTexture("res/textures/icons/zebstrika_icon.png")
	Textures["icons"].groudon_icon = dxCreateTexture("res/textures/icons/groudon_icon.png")
	Textures["icons"].starly_icon = dxCreateTexture("res/textures/icons/starly_icon.png")
	Textures["icons"].lucario_icon = dxCreateTexture("res/textures/icons/lucario_icon.png")
	Textures["icons"].riolu_icon = dxCreateTexture("res/textures/icons/riolu_icon.png")
	Textures["icons"].zoroark_icon = dxCreateTexture("res/textures/icons/zoroark_icon.png")
	Textures["icons"].mimikyu_icon = dxCreateTexture("res/textures/icons/mimikyu_icon.png")
	
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
