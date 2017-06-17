Animations_S = {}
local animations = {}

animations.default = {idle = {block = "misc", anim = "idle_chat_02"}, walk = {block = "ped", anim = "woman_walksexy"}, run = {block = "ped", anim = "woman_runsexy"}, talk = {block = "playidles", anim = "stretch"}}
animations.pokemon = {idle = {block = "dealer", anim = "dealer_idle_03"}, walk = {block = "ped", anim = "woman_run"}, run = {block = "ped", anim = "woman_runpanic"}}

animations.npc = {}
animations.npc.male = {idle = {block = "dealer", anim = "dealer_idle_02"}, walk = {block = "ped", anim = "walk_civi"}, run = {block = "ped", anim = "run_civi"}, talk = {block = "ped", anim = "idle_chat"}}
animations.npc.female = {idle = {block = "misc", anim = "idle_chat_02"}, walk = {block = "ped", anim = "woman_walksexy"}, run = {block = "ped", anim = "woman_runsexy"}, talk = {block = "playidles", anim = "stretch"}}


function Animations_S:getNPCAnimations(gender)
	if (gender) then
		if (animations.npc[gender]) then
			return animations.npc[gender]
		end
	end
	
	return animations.default
end


function Animations_S:getPokemonAnimations()
	return animations.pokemon
end
