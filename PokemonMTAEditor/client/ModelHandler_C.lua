--[[
	Filename: ModelHandler_C.lua
	Authors: Sam@ke
--]]


ModelHandler = {}


myModels = {}


-- // Skins // --
myModels[101] = {id = 258, pathTXD = "res/models/skins/calem.txd", pathDFF = "res/models/skins/calem.dff", pathCOL = nil}


-- // NPC // --
myModels[151] = {id = 12, pathTXD = "res/models/npc/selene.txd", pathDFF = "res/models/npc/selene.dff", pathCOL = nil}
myModels[152] = {id = 13, pathTXD = "res/models/npc/acerola.txd", pathDFF = "res/models/npc/acerola.dff", pathCOL = nil}
myModels[153] = {id = 14, pathTXD = "res/models/npc/luna.txd", pathDFF = "res/models/npc/luna.dff", pathCOL = nil}
myModels[154] = {id = 15, pathTXD = "res/models/npc/elio.txd", pathDFF = "res/models/npc/elio.dff", pathCOL = nil}
myModels[155] = {id = 16, pathTXD = "res/models/npc/may.txd", pathDFF = "res/models/npc/may.dff", pathCOL = nil}
myModels[156] = {id = 17, pathTXD = "res/models/npc/brendan.txd", pathDFF = "res/models/npc/brendan.dff", pathCOL = nil}
myModels[157] = {id = 18, pathTXD = "res/models/npc/wally.txd", pathDFF = "res/models/npc/wally.dff", pathCOL = nil}
myModels[158] = {id = 19, pathTXD = "res/models/npc/cynthia.txd", pathDFF = "res/models/npc/cynthia.dff", pathCOL = nil}
myModels[159] = {id = 20, pathTXD = "res/models/npc/serena.txd", pathDFF = "res/models/npc/serena.dff", pathCOL = nil}
myModels[160] = {id = 21, pathTXD = "res/models/npc/guzma.txd", pathDFF = "res/models/npc/guzma.dff", pathCOL = nil}
myModels[161] = {id = 22, pathTXD = "res/models/npc/plumeria.txd", pathDFF = "res/models/npc/plumeria.dff", pathCOL = nil}
myModels[162] = {id = 23, pathTXD = "res/models/npc/teamskull_f.txd", pathDFF = "res/models/npc/teamskull_f.dff", pathCOL = nil}
myModels[163] = {id = 24, pathTXD = "res/models/npc/teamskull_m.txd", pathDFF = "res/models/npc/teamskull_m.dff", pathCOL = nil}
myModels[164] = {id = 25, pathTXD = "res/models/npc/lillie.txd", pathDFF = "res/models/npc/lillie.dff", pathCOL = nil}
myModels[165] = {id = 26, pathTXD = "res/models/npc/mallow.txd", pathDFF = "res/models/npc/mallow.dff", pathCOL = nil}
myModels[166] = {id = 27, pathTXD = "res/models/npc/gladion.txd", pathDFF = "res/models/npc/gladion.dff", pathCOL = nil}
myModels[167] = {id = 28, pathTXD = "res/models/npc/laxxter.txd", pathDFF = "res/models/npc/laxxter.dff", pathCOL = nil}
myModels[168] = {id = 29, pathTXD = "res/models/npc/lysandre.txd", pathDFF = "res/models/npc/lysandre.dff", pathCOL = nil}
myModels[169] = {id = 30, pathTXD = "res/models/npc/misty.txd", pathDFF = "res/models/npc/misty.dff", pathCOL = nil}
myModels[170] = {id = 31, pathTXD = "res/models/npc/corni.txd", pathDFF = "res/models/npc/corni.dff", pathCOL = nil}
myModels[171] = {id = 32, pathTXD = "res/models/npc/clemont.txd", pathDFF = "res/models/npc/clemont.dff", pathCOL = nil}
myModels[172] = {id = 33, pathTXD = "res/models/npc/bonnie.txd", pathDFF = "res/models/npc/bonnie.dff", pathCOL = nil}
myModels[173] = {id = 34, pathTXD = "res/models/npc/ash.txd", pathDFF = "res/models/npc/ash.dff", pathCOL = nil}
myModels[174] = {id = 35, pathTXD = "res/models/npc/mei.txd", pathDFF = "res/models/npc/mei.dff", pathCOL = nil}


-- // Items // --
myModels[1004] = {id = 1851, pathTXD = "res/models/items/item_chest.txd", pathDFF = "res/models/items/chest_full.dff", pathCOL = "res/models/items/chest_full.col"}
myModels[1005] = {id = 1852, pathTXD = "res/models/items/pokePC.txd", pathDFF = "res/models/items/pokePC.dff", pathCOL = "res/models/items/pokePC.col"}

function ModelHandler:init()
	for index, modelInfo in pairs(myModels) do
		if (modelInfo) then
			if (modelInfo.id) then
				if (modelInfo.pathTXD) then
					local texture = engineLoadTXD(modelInfo.pathTXD)
					engineImportTXD(texture, modelInfo.id)
				end
				
				if (modelInfo.pathDFF) then
					local model = engineLoadDFF(modelInfo.pathDFF)
					engineReplaceModel(model, modelInfo.id)
				end
				
				if (modelInfo.pathCOL) then
					local col = engineLoadCOL(modelInfo.pathCOL)
					engineReplaceCOL(col, modelInfo.id)
				end
			end
		end
	end
	
	mainOutput("ModelHandler_C was started.")
end
