--[[
	Filename: SpawnList_S.lua
	Authors: Sam@ke
--]]


SpawnList = {}

-- // PlayerSpawns // --
SpawnList.playerSpawn = {}
SpawnList.playerSpawn[1] = {x = 405.93780517578, y = 2540.3994140625, z = 16.546249389648, rx = 0, ry = 0, rz = 148.2447204589}
--SpawnList.playerSpawn[2] = {x = 229.38693237305, y = 1716.8193359375, z = 21.906894683838, rx = 0, ry = 0, rz = 7.556762695312}
--SpawnList.playerSpawn[3] = {x = -1603.7720947266, y = 2383.3984375, z = 51.57772064209, rx = 0, ry = 0, rz = 264.15582275391}
--SpawnList.playerSpawn[4] = {x = -747.00543212891, y = 1133.1361083984, z = 44.363479614258, rx = 0, ry = 0, rz = 252.2489929199}
--SpawnList.playerSpawn[5] = {x = 1742.9147949219, y = 1323.126953125, z = 10.890406608582, rx = 0, ry = 0, rz = 138.8212890625}
--SpawnList.playerSpawn[6] = {x = 2317.1672363281, y = 2243.912109375, z = 10.8203125, rx = 0, ry = 0, rz = 187.38838195801}
--SpawnList.playerSpawn[7] = {x = -2278.0451660156, y = 660.93084716797, z = 49.4453125, rx = 0, ry = 0, rz = 327.1130065918}
--SpawnList.playerSpawn[8] = {x = -2135.5239257813, y = -387.91802978516, z = 35.343013763428, rx = 0, ry = 0, rz = 328.36630249023}
--SpawnList.playerSpawn[9] = {x = -598.90832519531, y = -1082.0151367188, z = 23.693141937256, rx = 0, ry = 0, rz = 237.5222015380}
--SpawnList.playerSpawn[10] = {x = -2075.2719726563, y = -2302.5812988281, z = 30.625, rx = 0, ry = 0, rz = 140.70123291016}
--SpawnList.playerSpawn[11] = {x = 39.415718078613, y = -199.71669006348, z = 1.6162617206573, rx = 0, ry = 0, rz = 215.2752838134}
--SpawnList.playerSpawn[12] = {x = 2400.6591796875, y = 75.237731933594, z = 26.484375, rx = 0, ry = 0, rz = 48.267028808594}
--SpawnList.playerSpawn[13] = {x = 1145.923828125, y = 280.84963989258, z = 20.274587631226, rx = 0, ry = 0, rz = 311.44613647461}
--SpawnList.playerSpawn[14] = {x = 415.25708007813, y = -1792.7652587891, z = 5.7421875, rx = 0, ry = 0, rz = 312.69943237305}
--SpawnList.playerSpawn[15] = {x = 2260.7666015625, y = -2216.6059570313, z = 13.546875, rx = 0, ry = 0, rz = 218.72190856934}
--SpawnList.playerSpawn[16] = {x = 2319.75390625, y = -1892.2766113281, z = 13.611040115356, rx = 0, ry = 0, rz = 88.397369384766}
--SpawnList.playerSpawn[17] = {x = 952.81677246094, y = -1380.7921142578, z = 13.34375, rx = 0, ry = 0, rz = 180.83160400391}
--SpawnList.playerSpawn[18] = {x = -2489.8139648438, y = -1530.2784423828, z = 393.64151000977, rx = 0, ry = 0, rz = 166.731445312}

-- // Bikes // --
SpawnList.bikes = {}
SpawnList.bikes[1] = {x = 399.96484375, y = 2538.5649414063, z = 16.544788360596, rx = 0, ry = 0, rz = 150.14813232422}


-- // Pokespawns // --
SpawnList.pokespawn= {}
SpawnList.pokespawn[1] = {x = 235.5164642334, y = 2410.6762695313, z = 15.47479057312, radius = 25, type = "ground", count = 3}
SpawnList.pokespawn[2] = {x = 168.72946166992, y = 2614.8212890625, z = 15.477983474731, radius = 15, type = "ground", count = 2}
SpawnList.pokespawn[3] = {x = 265.66949462891, y = 2788.9470214844, z = 31.75863456726, radius = 15, type = "ground", count = 2}

--[[
Pokedex[1] = {modelID = 213, name = "Pikachu", pokedexID = 25, legendary = false, size = 0.8, type = "electric", rate = 24.8, color = Colors.yellow}
Pokedex[2] = {modelID = 214, name = "Rowlet", pokedexID = 722, legendary = false, size = 0.6, type = "plant,flying", rate = 5.9, color = Colors.green}
Pokedex[3] = {modelID = 215, name = "Torchic", pokedexID = 255, legendary = false, size = 0.9, type = "fire", rate = 5.9, color = Colors.red}
Pokedex[4] = {modelID = 216, name = "Shaymin", pokedexID = 492, legendary = true, size = 1.3, type = "plant,flying", rate = 5.9, color = Colors.green}
Pokedex[5] = {modelID = 217, name = "Fennekin", pokedexID = 653, legendary = false, size = 0.9, type = "fire", rate = 5.9, color = Colors.red}
Pokedex[6] = {modelID = 218, name = "Mimikyu", pokedexID = 778, legendary = false, size = 0.4, type = "ghost,fairy", rate = 5.9, color = Colors.lila}
Pokedex[7] = {modelID = 219, name = "Greninja", pokedexID = 659, legendary = false, size = 1.2, type = "water,dark", rate = 5.9, color = Colors.blue}
Pokedex[8] = {modelID = 220, name = "Squishy", pokedexID = 99999, legendary = true, size = 0.35, type = "dragon,ground", rate = 0.1, color = Colors.lila}
Pokedex[9] = {modelID = 221, name = "Gible", pokedexID = 443, legendary = false, size = 0.7, type = "dragon,earth", rate = 5.9, color = Colors.lila}
Pokedex[10] = {modelID = 222, name = "Glalie", pokedexID = 362, legendary = false, size = 1.2, type = "ice", rate = 9.8, color = Colors.lightblue}
Pokedex[11] = {modelID = 223, name = "Braixen", pokedexID = 654, legendary = false, size = 1.0, type = "fire", rate = 5.9, color = Colors.red}
Pokedex[12] = {modelID = 224, name = "Lopunny", pokedexID = 428, legendary = false, size = 1.2, type = "normal,fight", rate = 7.8, color = Colors.earth}
Pokedex[13] = {modelID = 225, name = "Magearna", pokedexID = 801, legendary = false, size = 1.4, type = "steel,fairy", rate = 0.4, color = Colors.grey}
Pokedex[14] = {modelID = 226, name = "Sharpedo", pokedexID = 319, legendary = true, size = 1.1, type = "water,dark", rate = 7.8, color = Colors.blue}
Pokedex[15] = {modelID = 227, name = "Swampert", pokedexID = 260, legendary = false, size = 1.3, type = "water,ground", rate = 5.9, color = Colors.blue}
Pokedex[16] = {modelID = 228, name = "Mewtwo", pokedexID = 150, legendary = true, size = 1.4, type = "psychic,fight", rate = 0.4, color = Colors.pink}
Pokedex[17] = {modelID = 229, name = "Dragonite", pokedexID = 149, legendary = false, size = 1.6, type = "dragon,flying", rate = 5.9, color = Colors.lila}
Pokedex[18] = {modelID = 230, name = "Hydreigon", pokedexID = 635, legendary = false, size = 2.6, type = "dark,dragon", rate = 4.6, color = Colors.brown}
Pokedex[19] = {modelID = 231, name = "Substitute", pokedexID = 99999, legendary = false, size = 1.3, type = "...", rate = 5.9, color = Colors.earth}
Pokedex[20] = {modelID = 232, name = "Mega Mewtwo X", pokedexID = 150, legendary = true, size = 1.4, type = "psychic,fight", rate = 0.1, color = Colors.pink}
Pokedex[21] = {modelID = 233, name = "Ninetales", pokedexID = 38, legendary = false, size = 1.0, type = "fire", rate = 9.8, color = Colors.red}
]]

-- // Chests // --
SpawnList.chests = {}

SpawnList.chests[1] = {x = 416.2038269043, y = 2539.5266113281, z = 15.519538879395, rx = 0, ry = 0, rz = 94.350799560547}
SpawnList.chests[2] = {x = 376.61953735352, y = 2589.5012207031, z = 15.484375, rx = 0, ry = 0, rz = 329.32974243164}
SpawnList.chests[3] = {x = 278.43756103516, y = 2589.0397949219, z = 15.734992980957, rx = 0, ry = 0, rz = 173.3115234375}
SpawnList.chests[4] = {x = 211.90914916992, y = 2411.4572753906, z = 15.4765625, rx = 0, ry = 0, rz = 266.05914306641}
SpawnList.chests[5] = {x = -27.262445449829, y = 2350.0593261719, z = 23.140625, rx = 0, ry = 0, rz = 173.6015625}
SpawnList.chests[6] = {x = 113.47062683105, y = 2411.734375, z = 15.753133773804, rx = 0, ry = 0, rz = 311.13287353516}
SpawnList.chests[7] = {x = 315.54241943359, y = 2540.3935546875, z = 15.812463760376, rx = 0, ry = 0, rz = 268.8560180664}
SpawnList.chests[8] = {x = 268.69430541992, y = 2895.2504882813, z = 9.233081817627, rx = 0, ry = 0, rz = 301.44293212891}
SpawnList.chests[9] = {x = 170.66436767578, y = 2632.1906738281, z = 15.4765625, rx = 0, ry = 0, rz = 128.19134521484}
SpawnList.chests[10] = {x = 77.370513916016, y = 2450.7331542969, z = 15.476619720459, rx = 0, ry = 0, rz = 140.72479248047}

-- // NPCs & Trainer // --
SpawnList.npcs = {}
SpawnList.npcs[1] = {modelID = 12, name = "Selene", sex = "female", isTrainer = true, isVendor = false, x = 428.31134033203, y = 2526.3989257813, z = 16.558265686035, rx = 0, ry = 0, rz = 109.7279052734}
SpawnList.npcs[2] = {modelID = 13, name = "Acerola", sex = "female", isTrainer = true, isVendor = false, x = 261.17065429688, y = 2908.0715332031, z = 6.7388572692871, rx = 0, ry = 0, rz = 10.376892089844}
SpawnList.npcs[3] = {modelID = 15, name = "Elio", sex = "male", isTrainer = true, isVendor = false, x = -34.495552062988, y = 2333.4694824219, z = 24.134738922119, rx = 0, ry = 0, rz = 300.8392944335}

--[[
SpawnList.npcs[1] = {modelID = 12, name = "Selene", sex = "female", x = 370.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[2] = {modelID = 13, name = "Acerola", sex = "female", x = 365.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[3] = {modelID = 14, name = "Luna", sex = "female", x = 360.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[4] = {modelID = 15, name = "Elio", sex = "male", x = 355.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[5] = {modelID = 16, name = "May", sex = "female", x = 350.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[6] = {modelID = 17, name = "Brendan", sex = "male", x = 345.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[7] = {modelID = 18, name = "Wally", sex = "female", x = 340.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[8] = {modelID = 19, name = "Cynthia", sex = "female", x = 335.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[9] = {modelID = 20, name = "Serena", sex = "female", x = 330.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[10] = {modelID = 21, name = "Guzma", sex = "male", x = 325.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[11] = {modelID = 22, name = "Plumeria", sex = "female", x = 320.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[12] = {modelID = 23, name = "Team Skull Female", sex = "female", x = 315.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[13] = {modelID = 24, name = "Team Skull Male", sex = "male", x = 310.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[14] = {modelID = 25, name = "Lillie", sex = "female", x = 305.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[15] = {modelID = 26, name = "Mallow", sex = "female", x = 300.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[16] = {modelID = 27, name = "Gladion", sex = "male", x = 295.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[17] = {modelID = 28, name = "Laxxter", sex = "male", x = 290.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[18] = {modelID = 29, name = "Lysandre", sex = "male", x = 285.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[19] = {modelID = 30, name = "Misty", sex = "female", x = 280.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[20] = {modelID = 31, name = "Corni", sex = "female", x = 275.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[21] = {modelID = 32, name = "Clemont", sex = "male", x = 270.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[22] = {modelID = 33, name = "Bonnie", sex = "female", x = 265.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[23] = {modelID = 34, name = "Ash", sex = "male", x = 260.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
SpawnList.npcs[24] = {modelID = 35, name = "Mei", sex = "female", x = 255.5, y = 2465.266, z = 16.50, rx = 0, ry = 0, rz = 0}
]]