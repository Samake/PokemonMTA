Fonts = {}

function Fonts:init()
	Fonts["pokemon_gb_8"] = dxCreateFont("res/fonts/pokemon_gb.ttf", 8, false, "proof")
	Fonts["pokemon_gb_8_bold"] = dxCreateFont("res/fonts/pokemon_gb.ttf", 8, true, "proof")

	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Fonts were loaded.")
	end
end


function Fonts:cleanUp()
	for index, font in pairs(Fonts) do
		if (font) then
			if (isElement(font)) then
				--font:destroy()
				font = nil
			end
		end
	end
	
	if (Settings.showClassDebugInfo == true) then
		mainOutput("Fonts were deleted.")
	end
end
