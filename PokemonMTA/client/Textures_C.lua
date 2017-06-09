--[[
	Filename: Textures_C.lua
	Authors: Sam@ke
--]]

Textures = {}

Textures["gui"] = {}

function Textures:init()
	Textures["gui"].pokeNameTag = dxCreateTexture("res/textures/pokeNameTag.png")
	Textures["gui"].pokeNameTagBG = dxCreateTexture("res/textures/pokeNameTagBG.png")
	
	mainOutput("Textures were loaded.")
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
	
	mainOutput("Textures were deleted.")
end
