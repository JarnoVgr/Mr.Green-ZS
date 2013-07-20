-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--[=[------------------------------------------------------------------------------
              Map information - update when you add a map
         Size is the maximum player number the map can hold
--------------------------------------------------------------------------------]=]


--[=[-----------------------------------------------------------------------------
	Read this how to use additional functions for each map
-------------------------------------------------------------------------------]=]

--[=[--------------------------------------------------------------------------------
*Removing entities by class
Format: 		RemoveEntities = table with entities
Example: 		RemoveEntities = {"prop_physics"}
			RemoveEntities = {"prop_physics","prop_door"}
--------------------------------
*Except remove for specific entities
Format:		ExceptEntitiesRemoval = table with entities
Example:		ExceptEntitiesRemoval = {"prop_physics"}
			ExceptEntitiesRemoval = {"prop_physics","prop_door"}
--------------------------------
*Remove entities by model
Format:		RemoveEntitiesByModel = table with names of models
Example:		RemoveEntitiesByModel = {"models/props_junk/vent001.mdl"}
			RemoveEntitiesByModel = {"models/props_junk/vent001.mdl","models/props/de_nuke/car_nuke_animation.mdl"}
--------------------------------
*Disable ability to break doors
Format:		EnableSolidDoors = boolean value
Example:		EnableSolidDoors = true
*Note: This function is always 'false' by default
--------------------------------
*Remove solid glass (anti lag purpose)
Format:		RemoveGlass = boolean value
Example:		RemoveGlass = true
*Note: This function is always 'false' by default
--------------------------------
*Enable spawn protection for zombies
Format:		ZombieSpawnProtection	 = integer (in seconds)
Example:		ZombieSpawnProtection = 6
--------------------------------
*Disable bloom effects (useful on bright maps)
Format:		DisableBloom = boolean value
Example:		DisableBloom = true
*Note: This function is always 'false' by default
--------------------------------
*Disable beats
Format:		DisableBeats = boolean value
Example:		DisableBeats = true
*Note: This function is always 'false' by default
--------------------------------
*Disable music (Deadlife and LastHuman)
Format:		DisableMusic = boolean value
Example:		DisableMusic = true
*Note: This function is always 'false' by default
--------------------------------
*Confirm objective mode (This thing is nessesary, otherwise obj. file wont be included)
Format:		Objective = boolean value
Example:		Objective = true
*Note: This function is always 'false' by default
----------------------------------------------------------------------------------]=]

-- Maximum player limit 
VERY_SMALL,SMALL,MEDIUM,BIG,VERY_BIG = 7, 14, 20, MaxPlayers(), MaxPlayers()

-- Map table - Be sure there are 7 maps of each type (VERY_SMALL,SMALL and MEDIUM - BIG AND VERY_BIG ARE SHARED)
TranslateMapTable = {
	["zs_clav_chaossystem"] = { Name = "Chaos System", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 14 },
	["zs_alexg_motel_v3"] = { Name = "Motel", Size = MEDIUM, RandomizeSpawn = true },
	["zs_ambush_v3"] = { Name = "Ambush 3", Size = BIG, RandomizeSpawn = true },
	["zs_urbandecay_v4"] = { Name = "Urban Decay", Size = MEDIUM, RandomizeSpawn = true },
	["zs_ambush_v2"] = { Name = "Ambush 2", Size = MEDIUM, RandomizeSpawn = true,ZombieSpawnProtection = 13 },
	["zs_bunker"] = { Name = "Bunker", Size = BIG, RandomizeSpawn = true },
	["zs_despair"] = { Name = "Despair", Size = MEDIUM, RandomizeSpawn = true },--, EnableSolidDoors = true
	["zs_dump_v1"] = { Name = "Dump", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 6 },
	["zs_subway_v7"] = { Name = "Subway7", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 15 },
	["zs_urban_strain"] = { Name = "Urban Strain", Size = MEDIUM, RandomizeSpawn = true },
	["zs_harvest_b2"] = { Name = "Harvest", Size = BIG, RandomizeSpawn = true },
	["zs_urbanbreakout"] = { Name = "Urban Break-out", Size = MEDIUM, RandomizeSpawn = true, RemoveEntities = { "point_viewcontrol", "trigger_once", "info_camera_link", "point_camera", "info_target", "point_servercommand", "logic_timer", "logic_case", "info_player_start" } },
	["zs_lighthouse_v1"] = { Name = "Light House", Size = MEDIUM, RandomizeSpawn = true,RemoveGlass = true, RemoveEntities = { "npc_barnacle", "env_headcrabcanister", "npc_barnacle_tongue_tip" }, ZombieSpawnProtection = 7 },
	["zs_hospital"] = { Name = "Hospital", Size = MEDIUM, RandomizeSpawn = true },
	["zs_jail_v1"] = { Name = "Jail", Size = BIG, RandomizeSpawn = true, RemoveEntities = { "func_button", "move_rope", "keyframe_rope" }, ZombieSpawnProtection = 4 },
	["zs_c17_arena"] = { Name = "Destroyed City 17", Size = BIG, RandomizeSpawn = true },
	["zs_subversive_part3"] = { Name = "Subversive - Part 3", Size = BIG, RandomizeSpawn = true },
	["zs_subversive_v1"] = { Name = "Subversive - Part 1", Size = BIG, RandomizeSpawn = true },--, EnableSolidDoors = true
	["zs_caverns_final"] = { Name = "Caverns", Size = MEDIUM, RandomizeSpawn = true },
	["zs_vault_106_v5"] = { Name = "The Vault", Size = BIG, RandomizeSpawn = true },
	["zs_insurance"] = { Name = "Insurance", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 7 },
	["zs_subway_part1"] = { Name = "The Subway - Trainstation", Size = BIG, RandomizeSpawn = true, RemoveEntities = { "/725" } , ZombieSpawnProtection = 6},
	["zs_s_evergybunker_v2"] = { Name = "Energy Bunker", Size = MEDIUM, RandomizeSpawn = true, ZombieSpawnProtection = 6 },
	["zs_pub_v2"] = { Name = "The Pub 2", Size = SMALL, RandomizeSpawn = true },
	["zs_deadblock_v2"] = { Name = "Dead Block", Size = SMALL, RandomizeSpawn = true },
	["zs_chaste_part1"] = { Name = "Chaste", Size = MEDIUM, RandomizeSpawn = true },
	["zs_industrialheaven"] = { Name = "Industrial", Size = MEDIUM, RandomizeSpawn = true, ZombieSpawnProtection = 4 },
	["zs_trainstation"] = { Name = "Train Station", Size = MEDIUM, RandomizeSpawn = true, ZombieSpawnProtection = 5 },
	["zs_rooftop_b1"] = { Name = "No Mercy Hospital - Rooftop", Size = BIG, RandomizeSpawn = true },
	["zs_noir"] = { Name = "Noir", Size = MEDIUM, RandomizeSpawn = true },
	["zs_seige_v1"] = { Name = "The Seige", Size = VERY_SMALL, RandomizeSpawn = true, RemoveEntities = { "func_precipitation" } },
	["zs_urbandecay_v3"] = { Name = "Urban Decay - Winter", Size = MEDIUM, RandomizeSpawn = true, ZombieSpawnProtection = 7 },
	["zs_uglyfort"] = { Name = "Ugly Fort", Size = MEDIUM, RandomizeSpawn = true, ZombieSpawnProtection = 13 },
	["zs_raunchyhouse_final"] = { Name = "Raunchy House", Size = VERY_SMALL, RandomizeSpawn = true },
	["zs_clav_maze"] = { Name = "The Maze", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 8 },
	["zs_storm_v1"] = { Name = "Storm House", Size = SMALL, RandomizeSpawn = true, ExceptEntitiesRemoval = { "func_door"}, ZombieSpawnProtection = 11 },
	["zs_fortress"] = { Name = "The Fortress", Size = SMALL, RandomizeSpawn = true, ZombieSpawnProtection = 25, MapCoder = true},
	["zs_barren"] = { Name = "Barren", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 20 },
	["zs_house_number_23"] = { Name = "House Number 23", Size = MEDIUM, RandomizeSpawn = true, RemoveGlass = true },
	["zs_clav_segments_v2"] = { Name = "Segments", Size = MEDIUM, RandomizeSpawn = true, ZombieSpawnProtection = 14 },
	["zs_nastierhouse_v3"] = { Name = "Nastier House", Size = VERY_SMALL, RandomizeSpawn = true, ExceptEntitiesRemoval = { "func_door" } },
	["zs_subway_1_cargo"] = { Name = "The Subway - Cargo", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 9 },
	["zs_villagehouse_final"] = { Name = "Village House", Size = VERY_SMALL, RandomizeSpawn = true },
	["zs_stormier_v1"] = { Name = "Stormier House", Size = SMALL, RandomizeSpawn = true },
	["zs_sewers_final"] = { Name = "The Sewers", Size = MEDIUM, RandomizeSpawn = true, RemoveEntities = { "func_breakable", "location_brush" }, RemoveEntitiesByModel = {"models/props_junk/vent001.mdl"}, ZombieSpawnProtection = 7} ,
	["zs_bog_shityhouse"] = { Name = "Shity House", Size = SMALL, RandomizeSpawn = true },
	["zs_pub"] = { Name = "The Pub", Size = VERY_SMALL, RandomizeSpawn = true },
	["zs_greenpub_b1"] = { Name = "The Green Pub", Size = SMALL, RandomizeSpawn = true, ZombieSpawnProtection = 8, RemoveEntitiesByModel = {"models/props_interiors/furniture_couch01a.mdl"} },
	["zs_subversive_v2"] = { Name = "Subversive - Part 2", Size = MEDIUM, RandomizeSpawn = true },
	["zs_forgotten_city_enclosed"] = { Name = "Forgotten City", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 25 },
	["zs_ravenholm_v4"] = { Name = "Ravenholm", Size = BIG, RandomizeSpawn = true },
	["zs_clav_inverse"] = { Name = "Inverse", Size = VERY_BIG, RandomizeSpawn = true },
	["zs_port_v5"] = { Name = "The Port", Size = SMALL, RandomizeSpawn = true },
	["zs_deadhouse"] = { Name = "Dead House", Size = BIG, RandomizeSpawn = true, RemoveEntities = {"func_door_rotating"},ZombieSpawnProtection = 9 },
	["zs_plague_v2"] = { Name = "The Plague", Size = MEDIUM, RandomizeSpawn = true, ZombieSpawnProtection = 9 },
	["zs_shithole_v3"] = { Name = "Shit Hole House", Size = VERY_SMALL, RandomizeSpawn = true },
	["zs_clav_massive"] = { Name = "Massive", Size = MEDIUM, RandomizeSpawn = true, ZombieSpawnProtection = 9 },
	["zs_clav_wall"] = { Name = "The Wall", Size = SMALL, RandomizeSpawn = true },
	["zs_subversive_part4"] = { Name = "Subversive - Part 4", Size = BIG, RandomizeSpawn = true },
	["zs_cabin_v2"] = { Name = "Cabin", Size = SMALL, RandomizeSpawn = false, ExceptEntitiesRemoval = { "func_door" } },
	["zs_market_2"] = { Name = "Market", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 8 },
	["zs_crackhouse"] = { Name = "Crack House", Size = BIG, RandomizeSpawn = true },
	["zs_necrotic_v3"] = { Name = "Necrotic", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 6 },
	["zs_hazard"] = { Name = "Hazard", Size = BIG, RandomizeSpawn = true },
	["zs_glacier"] = { Name = "Glacier", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 7 },
	["zs_marsh_fixed"] = { Name = "Marsh", Size = BIG, RandomizeSpawn = true, RemoveEntities = { "func_button" }, ExceptEntitiesRemoval = {"func_door", "func_door_rotating" } },
	["zs_nipperhouse_v3"] = { Name = "Nipper House", Size = BIG, RandomizeSpawn = true , ZombieSpawnProtection = 5},
	["zs_house_outbreak_b2"] = { Name = "House Outbreak", Size = BIG, RandomizeSpawn = true, RemoveEntitiesByModel = {"models/props/de_nuke/car_nuke_animation.mdl"} },
	["zs_barrelfactory"] = { Name = "Barrel Factory", Size = SMALL, RandomizeSpawn = true, RemoveEntities = { "func_tracktrain" }, RemoveEntitiesByModel = {"models/props_c17/oildrum001.mdl"} },
	["zs_farmhouse_v2"] = { Name = "Farm House", Size = BIG, RandomizeSpawn = true, ExceptEntitiesRemoval = { "func_door", "func_door_rotating" }, RemoveEntitiesByModel = {"models/props_c17/trappropeller_engine.mdl"} },
	["zs_forestofthedamned_2010"] = { Name = "Forest of the Damned", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 7},
	["zs_plaza_opt"] = { Name = "Plaza", Size = BIG, RandomizeSpawn = true, RemoveEntities = {"func_door"}, ZombieSpawnProtection = 20},
	["zs_woodhouse_rain"] = { Name = "Wood House Rain", Size = BIG, RandomizeSpawn = true},
	["zs_imashouse_final"] = { Name = "ImasHouse Final", Size = BIG, RandomizeSpawn = true},
	["zs_please"] = { Name = "Please", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 5},
	["zs_tigcrik"] = { Name = "Tigcrik", Size = BIG, RandomizeSpawn = true, RemoveGlass = true},
	["zs_the_citadel"] = { Name = "Citadel", Size = BIG, RandomizeSpawn = true},
	["zs_lost_coast_house"] = { Name = "Lost Coast House", Size = BIG, RandomizeSpawn = true},
	["zs_stormiest_b1"] = { Name = "Stormiest House", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 9},
	["zs_mall_final"] = { Name = "The Mall", Size = BIG, RandomizeSpawn = true,ZombieSpawnProtection = 7},
	["zs_aeolus_v4"] = { Name = "Aeolus", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 16},
	["zs_nastyhouse2_v2"] = { Name = "Nasty House", Size = BIG, RandomizeSpawn = true},
	["zs_uglyfort_snow1"] = { Name = "Ugly Fort Snow", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 5},
	["zs_godzilla"] = { Name = "Godzilla", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 7},
	["zs_gravity_v2"] = { Name = "Gravity", Size = BIG, RandomizeSpawn = true, ExceptEntitiesRemoval = { "game_text", "func_door", "func_door_rotating"} },
	["zs_nowhere"] = { Name = "Nowhere", Size = BIG, RandomizeSpawn = true, ExceptEntitiesRemoval = { "game_text", "func_door", "func_door_rotating"} },
	["zs_prc_wurzel_v2"] = { Name = "Wurzel (aka Train Rape)", Size = BIG, MapCoder = true, RandomizeSpawn = true},
	["zs_gutter"] = { Name = "Gutter", Size = BIG, RandomizeSpawn = true,ZombieSpawnProtection = 8},
	["cs_bulletheory"] = { Name = "Bulletheory", Size = BIG, RandomizeSpawn = true,ZombieSpawnProtection = 5},
	["cs_meridian"] = { Name = "Meridian", Size = BIG, RandomizeSpawn = true,ZombieSpawnProtection = 3},
	["zs_buntshot"] = { Name = "Bunshot", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 6},
	["zs_death_house_v2"] = { Name = "Death House", Size = BIG, RandomizeSpawn = true},
	["zs_dystopian_apartments"] = { Name = "Dystopian Apartments", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 4},
	["zs_panic_house_v2"] = { Name = "Panic House", Size = BIG, RandomizeSpawn = true},
	["zs_residentevil2v2"] = { Name = "Resident Evil", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 10},
	["zs_swimming_pool_v2"] = { Name = "Swimming Pool", Size = BIG, RandomizeSpawn = true, ZombieSpawnProtection = 10},
	["zm_gasdump_b4"] = { Name = "Gasdump (Obj)", Size = BIG,Objective = true, RandomizeSpawn = true,ExceptEntitiesRemoval = { "game_text", "func_door", "func_door_rotating","func_breakable"},DisableBloom = true,DisableMusic = true,DisableBeats = true},
	["zs_sos_b2"] = { Name = "Sos (Obj)", Size = BIG, RandomizeSpawn = true,ExceptEntitiesRemoval = { "game_text", "func_door", "func_door_rotating"}},
	["zs_youareavirusinsidejoe_4"] = { Name = "Joe", Size = BIG, RandomizeSpawn = true,RemoveEntities = {"logic_timer"}},
	["zs_asylum_v6"] = { Name = "Asylum", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 14},
	["zs_cityholdout"] = { Name = "City Holdout", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 10},
	["zs_dezecrated_beta"] = { Name = "Desecrated", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 11},
	["zs_greenie_lounge"] = { Name = "Greenie Lounge", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 13,RemoveEntities = {"point_template"}},
	["zs_lockup"] = { Name = "Lockup", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 16},
	["zs_seclusion"] = { Name = "Seclusion", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 11},
	["zs_siege_opt4"] = { Name = "The Siege Evil", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 15},
	["zs_uglyfort_v6"] = { Name = "Ugly Fort Final", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 14},
	["zs_egypt"] = { Name = "Egypt", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 18,DisableBloom = true},
	["zs_tunnels_fixed_v2"] = { Name = "Tunnels", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 13,RemoveGlass = true},
	["zs_chernobyl_v1"] = { Name = "Chernobyl", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 7, RemoveGlass = true}, 
	["zs_4ngry_quaruntine"] = { Name = "Quarantine", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 8},
	["zs_canyon"] = { Name = "Canyon", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 16},
	["zs_cave_b3"] = { Name = "Cave", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 16},
	["zs_deadwater_v2"] = { Name = "Dead Water", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 6},
	["zs_ghostcanal"] = { Name = "Ghost Canal", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 14},
	["zs_laboratory"] = { Name = "Laboratory", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 12},
	["zs_mental_hospital"] = { Name = "Mental Hospital?", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 25, RemoveEntities = {"func_win", "env_fade"}},
	["zs_ventilation"] = { Name = "Ventilation", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 20},
	["zs_vitron_f9"] = { Name = "Vitron", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 15},	
	["zs_zincoshine_v2"] = { Name = "Zincoshine", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 6},
	["zs_zombie_village_npc"] = { Name = "Zombie Village", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 7,RemoveEntities = {"npc_fastzombie","npc_headcrab_poison","npc_poisonzombie"}},
	["zs_greenie_woodhouse_rain"] = { Name = "Greenie Woodhouse Rain", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 6},
	["zs_underpass_330"] = { Name = "Underpass", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 10},
	["zs_factory_b3"] = { Name = "Factory Tennis", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 10},
	["zs_abandon_factory_v3"] = { Name = "Abandoned Factory", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 10},
	["zs_abandoned_mall_v3"] = { Name = "A Proper Mall", Size = BIG, RandomizeSpawn = false, ZombieSpawnProtection = 17},
}