-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local math = math
local util = util

GM.Version  = "Green Apocalypse"
GM.SubVersion = ""

function ToMinutesSeconds(TimeInSeconds)
	local iMinutes = math.floor(TimeInSeconds / 60.0)
	return string.format("%0d:%02d", iMinutes, math.floor(TimeInSeconds - iMinutes*60))
end

--[==[------------------------------------------------------------
   Call this whenever you want to check an option
-------------------------------------------------------------]==]
function ConVarIsTrue ( convar )
	if not ConVarExists( convar ) then return false end
	
	return GetConVar( convar ):GetBool()
end

ARENA_MODE = tobool(string.find(tostring(game.GetMap()),"zs_arena"))
print("Arena mode = "..tostring(ARENA_MODE))

XMAS_2012 = false

DEFAULT_VIEW_OFFSET = Vector(0, 0, 64)
DEFAULT_VIEW_OFFSET_DUCKED = Vector(0, 0, 28)
DEFAULT_JUMP_POWER = 180
DEFAULT_STEP_SIZE = 18
DEFAULT_MASS = 80
DEFAULT_MODELSCALE = 1-- Vector(1, 1, 1)

-- Horde stuff

HORDE_MAX_ZOMBIES = 15
HORDE_MAX_RESISTANCE = 60 -- in %
HORDE_MAX_DISTANCE = 260

BONUS_RESISTANCE_WAVE = 5
BONUS_RESISTANCE_AMOUNT = 20 -- %

-- Boss stuff

BOSS_TOTAL_PLAYERS_REQUIRED = 14-- 16
BOSS_INFLICTION_REQUIRED = 95--67-- 1.35--  max % zombies of total players
BOSS_CLASS = {10,13}-- 10,11,12,
BOSS_WAVE = 6

if XMAS_2012 then
	BOSS_CLASS = {14}
	BOSS_WAVE = 5
end

SUPER_BOSS_CHANCE = 2

--[==[if math.random(SUPER_BOSS_CHANCE) == SUPER_BOSS_CHANCE then
	SUPER_BOSS = true
	if SERVER then print("--Super Boss activated!--") end
end]==]

SHARED_SPEED_INCREASE = 13

-- Use custom chatbox
CUSTOM_CHAT = CreateConVar( "sos_customchat", 0, FCVAR_REPLICATED )

----------------------------------
--		STARTING LOADOUTS		--
----------------------------------

GM.STARTLOADOUTS = {}
GM.STARTLOADOUTS[1] = {"weapon_zs_melee_crowbar","weapon_zs_p228"}
GM.STARTLOADOUTS[2] = {"weapon_zs_combatknife","weapon_zs_usp"}

-----------------------------------
-- 		KILL LEVEL REWARDS		 --
-----------------------------------

-- Rewards that start with _ will be called as a powerup. ( PowerupFunctions["_name"](ply) ) This is cAsE-SenSiTivE!
-- See powerups.lua for examples and stuff.
-- Changing these means you're most likely an idiot.

-- add all BUY ONLY rewards to this list
BuyOnly = {}
BuyOnly[30] = "firepower"
BuyOnly[60] = "energize"
-- Moving this into shared, because I want to use this table on client too
RewardsTable = {}
RewardsTable[1] = { --Medic
	[100] = { "weapon_zs_deagle", "weapon_zs_fiveseven","weapon_zs_elites"},
	[250] = { "weapon_zs_glock3","weapon_zs_magnum" },
	[500] = { "weapon_zs_alyxgun"},
	[800] = { "weapon_zs_sg552"},
	[1500] = { "weapon_zs_shotgun", "weapon_zs_m1014" },
}
RewardsTable[2] = { --Commando
	[100] = { "weapon_zs_glock3", "weapon_zs_deagle", "weapon_zs_magnum" },
	[300] = { "weapon_zs_grenade" },
	[600] = { "weapon_zs_aug", "weapon_zs_galil", "weapon_zs_ak47", "weapon_zs_m4a1" },
	[1000] = { "weapon_zs_famas" },
	[1450] = { "weapon_zs_m249" },
	[1950] = { "weapon_zs_shotgun", "weapon_zs_m1014" },
}
RewardsTable[3] = { -- marksman
	[100] = { "weapon_zs_deagle", "weapon_zs_fiveseven","weapon_zs_elites"},
	[250] = { "weapon_zs_scout" },
	[400] = { "weapon_zs_melee_axe" },
	[600] = { "weapon_zs_sg550" },
	[900] = { "weapon_zs_g3sg1"},
	[1800] = { "weapon_zs_awp"},
	--[75] = { "weapon_zs_shotgun", "weapon_zs_m1014" },
}
RewardsTable[4] = { --Engineer
	[100] = { "weapon_zs_glock3", "weapon_zs_deagle", "weapon_zs_elites", "weapon_zs_magnum" },
	[300] = { "weapon_zs_pulsesmg" },
	[700] = {"weapon_zs_pulserifle" },
	[1350] = { "weapon_zs_m249" },
	[1800] = { "weapon_zs_shotgun", "weapon_zs_m1014" },
}
RewardsTable[5] = { --Support
	[100] = { "weapon_zs_glock3", "weapon_zs_deagle", "weapon_zs_fiveseven", "weapon_zs_magnum" },
	[300] = { "weapon_zs_tmp","weapon_zs_ump","weapon_zs_p90","weapon_zs_mac10" },
	[650] = { "weapon_zs_mp5", "weapon_zs_smg" },
	[1210] = { "weapon_zs_m249", "weapon_zs_m3super90" },
	[1800] = { "weapon_zs_shotgun", "weapon_zs_m1014" },
}

-- Only if they bought the comeback thingie
ComeBackReward = {}
ComeBackReward[1] = { -- Medic
[1] =  { "weapon_zs_elites", "weapon_zs_fiveseven"},
[2] =  { "weapon_zs_alyxgun"  }, 
[3] =  { "weapon_zs_ak47"  }, 
--[4] =  { "weapon_zs_ak47" }, 
}
ComeBackReward[2] = { -- Commando
[1] =  { "weapon_zs_deagle", "weapon_zs_glock3"},
[2] =  { "weapon_zs_galil", "weapon_zs_sg552" }, 
[3] =  { "weapon_zs_ak47" }, 
-- [4] =  { "weapon_zs_ak47"  }, 
}
ComeBackReward[3] = { -- Berserker
[1] =  { "weapon_zs_fiveseven", "weapon_zs_elites"},
[2] =  { "weapon_zs_scout" }, 
[3] =  { "weapon_zs_sg550"}, 
}
ComeBackReward[4] = { -- Engineer
[1] =  { "weapon_zs_fiveseven", "weapon_zs_elites"},
[2] =  { "weapon_zs_pulsesmg"}, 
[3] =  {"weapon_zs_ak47"}, 
--[4] =  { "weapon_zs_ak47"}, 
}
ComeBackReward[5] = { -- Support
[1] =  { "weapon_zs_fiveseven", "weapon_zs_elites"},
[2] =  { "weapon_zs_tmp","weapon_zs_ump", "weapon_zs_mac10"}, 
[3] =  { "weapon_zs_smg"}, 
}

--[=[
ComeBackReward = {}
ComeBackReward[1] = { "weapon_zs_glock3", "weapon_zs_fiveseven", "weapon_zs_magnum" } -- humans outnumber zombies
ComeBackReward[2] = { "weapon_zs_p90", "weapon_zs_smg" } -- zombies outnumber humans by a small marigin
ComeBackReward[3] = { "weapon_zs_galil", "weapon_zs_ak47", "weapon_zs_m4a1" } -- zombies outnumber humans 2 to 1
ComeBackReward[4] = { "weapon_zs_m1014", "weapon_zs_shotgun" } -- zombies outnumber humans 4 to 1
]=]
-- Chat titles based on time spent on server
GM.ChatTitles = {

	-- Human titles
	Human = {
		[5] = "[Fresh Meat]",
		[10] = "[Zombie Food]",
		[15] = "[Mc Zomburger]",
		[18] = "[Undead Noodle]",
		[25] = "[Experienced Citizen]",
		[30] = "[Ammo Sniffer]",
		[40] = "[Reloader]",
		[50] = "[Zombie Dodger]",
		[70] = "[Kill-a-Zombie]",
		[90] = "[Undead Terminator]",
		[130] = "[Zombie Virgin]",
		[150] = "[Barricade Specialist]",
		[180] = "[Zombie Desecrator]",
		[215] = "[Last Human]",
		[250] = "[Survivalist]",
		[300] = "[Zombie Meister]",
		[350] = "[Dr Zombo]",
	},
	
	-- Undead titles
	Undead = {
		[5] = "[Free Headshot]",
		[10] = "[Canned Zombie]",
		[15] = "[BullsEye]",
		[18] = "[Flesh Pile]",
		[25] = "[Lawn Mower]",
		[30] = "[Steam Roller]",
		[40] = "[Unfriendly Zombie]",
		[50] = "[Wild Weasel]",
		[70] = "[Meat Grinder]",
		[90] = "[Brain Cook]",
		[130] = "[Master Rapist]",
		[150] = "[Human Shithole]",
		[180] = "[Claw Master]",
		[215] = "[Tire Blaster]",
		[250] = "[Game Ender]",
		[300] = "[Humanity's End]",
		[350] = "[The Apocalypse]",
	},
	
	-- Admin titles
	Admin = {
		[1] = "[ZombAdmin]",
		[2] = "[The Ban Hammer]",
		[3] = "[Admin]",
	}
}

-- Weapons information table
GM.HumanWeapons = {	

	-- Pistols
	["weapon_zs_usp"]  = { Name = "USP .45", DPS = 42,Mat = "VGUI/gfx/VGUI/usp45", Infliction = 0, Type = "pistol", Price = 90 },
	["weapon_zs_p228"]  = { Name = "P228", DPS = 58,Mat = "VGUI/gfx/VGUI/p228", Infliction = 0, Type = "pistol",Price = 90 },
	["weapon_zs_deagle"]  = { Name = "Desert Eagle",Mat = "VGUI/gfx/VGUI/deserteagle", DPS = 93, Infliction = 0.2, Type = "pistol", Price = 260 },
	["weapon_zs_fiveseven"]  = { Name = "Five-Seven",Mat = "VGUI/gfx/VGUI/fiveseven", DPS = 91, Infliction = 0.15, Type = "pistol", Price = 180 },
	["weapon_zs_magnum"]  = { Name = ".357 Magnum", DPS = 121, Infliction = 0.3, Type = "pistol", Price = 310 },
	["weapon_zs_glock3"]  = { Name = "Glock", DPS = 120,Mat = "VGUI/gfx/VGUI/glock18", Infliction = 0.25, Type = "pistol", Price = 240 },
	["weapon_zs_alyxgun"]  = { Name = "Alyx Gun", DPS = 122, Infliction = 0.65,Type = "pistol" },
	["weapon_zs_elites"]  = { Name = "Dual-Elites", DPS = 92,Mat = "VGUI/gfx/VGUI/elites", Infliction = 0.25, Type = "pistol", Price = 230 },
	["weapon_zs_classic"]  = { Name = "'Classic' Pistol", DPS = 30, Infliction = 0.25, Type = "pistol",Price = 230 },
	
	-- Submachine guns
	["weapon_zs_p90"]  = { Name = "P90 Sub-Machine Gun", DPS = 125,Mat = "VGUI/gfx/VGUI/p90", Infliction = 0.65, Type = "smg", Price = 450 }, --  3
	["weapon_zs_ump"]  = { Name = "UMP Sub-Machine Gun", DPS = 110,Mat = "VGUI/gfx/VGUI/ump45", Infliction = 0.60, Type = "smg", Price = 480 }, --  1
	["weapon_zs_smg"]  = { Name = "Sub-Machine Gun", DPS = 130, Infliction = 0.9, Type = "smg", Price = 470 }, --  4
	["weapon_zs_mp5"]  = { Name = "MP5 Sub-Machine Gun", DPS = 127,Mat = "VGUI/gfx/VGUI/mp5", Infliction = 0.58, Type = "smg", Price = 500 }, --  5
	["weapon_zs_tmp"]  = { Name = "TMP Sub-Machine Gun", DPS = 107,Mat = "VGUI/gfx/VGUI/tmp", Infliction = 0.56, Type = "smg", Price = 450 },	--  2
	["weapon_zs_mac10"]  = { Name = "Mac 10 Sub-Machine Gun", DPS = 126,Mat = "VGUI/gfx/VGUI/mac10", Infliction = 0.60, Type = "smg", Price = 490 },
	
	["weapon_zs_minishotty"]  = { Name = "'Farter' Shotgun", DPS = 126, Infliction = 0, Type = "shotgun",Price = 630 },
	
	-- Melee
	["weapon_zs_melee_keyboard"]  = { Name = "Keyboard", DPS = 45, Infliction = 0, Type = "melee",Price = 60 },
	["weapon_zs_melee_plank"]  = { Name = "Plank", DPS = 56, Infliction = 0, Type = "melee",Price = 50 }, 
	["weapon_zs_melee_pot"]  = { Name = "Pot", DPS = 61, Infliction = 0, Type = "melee",Price = 70 }, 
	["weapon_zs_melee_fryingpan"]  = { Name = "Frying Pan", DPS = 70, Infliction = 0, Type = "melee",Price = 70,OnlyRetro = true }, 
	["weapon_zs_melee_axe"]  = { Name = "Axe", DPS = 78, Infliction = 0.5, Type = "melee", Price = 200 }, 
	["weapon_zs_melee_crowbar"]  = { Name = "Crowbar", DPS = 85, Infliction = 0.65, Type = "melee", Price = 250 }, 
	["weapon_zs_melee_katana"]  = { Name = "Katana", DPS = 90, Infliction = 0, Type = "melee" },
	["weapon_zs_melee_combatknife"]  = { Name = "Combat Knife", DPS = 15, Infliction = 0, Type = "melee", Price = 60,OnlyRetro = true },
	["weapon_zs_melee_shovel"]  = { Name = "Shovel", DPS = 40, Infliction = 0, Type = "melee",OnlyRetro = true },
	-- Disabled melee
	["weapon_zs_melee_sledgehammer"]  = { Name = "Mr Sledge", DPS = 38, Infliction = 0, Type = "melee", Price = 400 },
	["weapon_zs_shovel"]  = { Name = "Shovel", DPS = 40, Infliction = 0, Restricted = true, Type = "melee" },
	["weapon_zs_fists"]  = { Name = "Fists", DPS = 30, Infliction = 0, Restricted = true, Type = "melee" },
	
	--Rifles
	["weapon_zs_ak47"]  = { Name = "AK-47", DPS = 133,Mat = "VGUI/gfx/VGUI/ak47", Infliction = 0.7, Type = "rifle", Price = 720 },
	["weapon_zs_aug"]  = { Name = "Steyr AUG", DPS = 125,Mat = "VGUI/gfx/VGUI/aug", Infliction = 0.53, Type = "rifle" , Price = 700},
	["weapon_zs_sg552"]  = { Name = "SG552 Rifle", DPS = 106,Mat = "VGUI/gfx/VGUI/sg552", Infliction = 0.51, Type = "rifle", Price = 640 },
	["weapon_zs_famas"]  = { Name = "Famas", DPS = 140,Mat = "VGUI/gfx/VGUI/famas", Infliction = 0.7, Type = "rifle",Price = 750 },
	["weapon_zs_galil"]  = { Name = "Galil", DPS = 129,Mat = "VGUI/gfx/VGUI/galil", Infliction = 0.57, Type = "rifle", Price = 720 },
	["weapon_zs_pulserifle"]  = { Name = "Pulse Rifle", DPS = 143, Infliction = 0, Type = "rifle" },
	["weapon_zs_m4a1"]  = { Name = "M4A1 Rifle", DPS = 138,Mat = "VGUI/gfx/VGUI/m4a1", Infliction = 0.65, Type = "rifle", Price = 730 },
	["weapon_zs_m249"]  = { Name = "M249", DPS = 200,Mat = "VGUI/gfx/VGUI/m249", Infliction = 0.85, Type = "rifle", Price = 920 },
	
	["weapon_zs_scout"]  = { Name = "Scout Sniper", DPS = 40,Mat = "VGUI/gfx/VGUI/scout", Infliction = 0, Type = "rifle", Price = 820},
	["weapon_zs_awp"]  = { Name = "AWP", DPS = 200,Mat = "VGUI/gfx/VGUI/awp", Infliction = 0, Class = "Berserker", Type = "rifle",Price =1400 },
	["weapon_zs_g3sg1"]  = { Name = "G3-SG1", DPS = 80,Mat = "VGUI/gfx/VGUI/g3sg1", Infliction = 0, Class = "Berserker", Type = "rifle" },
	["weapon_zs_sg550"]  = { Name = "SG550", DPS = 70,Mat = "VGUI/gfx/VGUI/sg550", Infliction = 0, Class = "Berserker", Type = "rifle" },
	
	--Tool1
	["weapon_zs_tools_hammer"]  = { Name = "Nailing Hammer", DPS = 23, Infliction = 0, Type = "tool1", NoRetro = true },
	["weapon_zs_medkit"]  = { Name = "Medkit", DPS = 8, Infliction = 0, Type = "tool1", NoRetro = true },
	["weapon_zs_tools_supplies"] = { Name = "Mobile Supplies", DPS = 0, Infliction = 0, Type = "tool1", NoRetro = true },
	["weapon_zs_tools_remote"] = { Name = "Remote Controller", DPS = 0, Infliction = 0, Type = "tool1" },
	["weapon_zs_tools_torch"] = { Name = "Torch", DPS = 0, Infliction = 0, Type = "tool1", NoRetro = true },
	
	--Tool2
	["weapon_zs_miniturret"] = { Name = "Combat Mini-Turret", DPS = 0, Infliction = 0, Type = "tool2" },
	["weapon_zs_turretplacer"] = { Name = "Turret", DPS = 0, Infliction = 0, Type = "tool2", NoRetro = true },
	["weapon_zs_grenade"]  = { Name = "Grenade", DPS = 8, Infliction = 0, Type = "tool2", NoRetro = true },
	["weapon_zs_mine"]  = { Name = "Explosives", DPS = 8, Infliction = 0, Type = "tool2", NoRetro = true },
	["weapon_zs_tools_plank"]  = { Name = "Pack of Planks", DPS = 0, Infliction = 0, Type = "tool2" },
	
	-- Others
	["weapon_zs_boomstick"]  = { Name = "Boom Stick", DPS = 215, Infliction = 0.85, Type = "shotgun",Price = 1300  },
	["weapon_zs_annabelle"]  = { Name = "Annabelle Shotgun", DPS = 210, Infliction = 0, Type = "shotgun",Price = 870 },
	["weapon_zs_m1014"]  = { Name = "M1014 Auto-Shotgun", DPS = 246,Mat = "VGUI/gfx/VGUI/xm1014", Infliction = 0.85, Type = "shotgun",Price = 900 },
	
	["weapon_zs_crossbow"]  = { Name = "Crossbow", DPS = 220, Infliction = 0, Class = "Medic", Type = "rifle"},
	["weapon_zs_m3super90"]  = { Name = "M3-Super90 Shotgun", DPS = 149,Mat = "VGUI/gfx/VGUI/m3", Infliction = 0,Class = "Support", Type = "shotgun",Price = 1000 }, 
	
	--Pickups!
	["weapon_zs_pickup_gascan2"]  = { Name = "Dangerous Gas Can", DPS = 0, Infliction = 0, Type = "misc" },
	["weapon_zs_pickup_propane"]  = { Name = "Dangerous Propane Tank", DPS = 0, Infliction = 0, Type = "misc" },
	["weapon_zs_pickup_flare"]  = { Name = "Rusty Flare", DPS = 0, Infliction = 0, Type = "misc" },
	["weapon_zs_pickup_gasmask"]  = { Name = "Old Gas Mask", DPS = 0, Infliction = 0, Type = "misc" },
	
	
	["weapon_zs_barricadekit"]  = { Name = "Barricade Kit", DPS = 1, Infliction = 0, Class = "Engineer", Type = "others" },
	["weapon_zs_shotgun"]  = { Name = "Shotgun", DPS = 215, Infliction = 0.85, Type = "shotgun",Price = 1000 },
	["weapon_zs_awm"]  = { Name = "Arctic Warface Magnum", DPS = 92, Infliction = 0.6, Class = "Support", Type = "rifle", Restricted = true },
	["weapon_frag"]  = { Name = "Grenade", DPS = 1, Infliction = 0, Restricted = true, Type = "admin" },
	
	
	["weapon_zs_pulsesmg"]  = { Name = "Pulse SMG", DPS = 99, Infliction = 0, Type = "rifle" },
	
	
	["weapon_357"] = { Name = ".357 Original", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
	["weapon_ar2"] = { Name = "AR2 Rifle", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
	["weapon_bugbait"] = { Name = "Bugbait", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
	["weapon_crossbow"] = { Name = "Original Crossbow", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
	["weapon_crowbar"] = { Name = "Original Crowbar", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
	["weapon_pistol"] = { Name = "Original Pistol", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
	["weapon_rpg"] = { Name = "Original RPG", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
	["weapon_shotgun"] = { Name = "Original Shotgun", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
	
	["admin_tool_canister"] = { Name = "Canister Tool", DPS = 0, Infliction = 0.2, Type = "admin" },
	["admin_tool_sprayviewer"] = { Name = "Sprayviewer Tool", DPS = 0, Infliction = 0.2, Type = "admin" },
	["admin_tool_igniter"] = { Name = "Igniter Tool", DPS = 0, Infliction = 0.2, Type = "admin" },
	["admin_tool_remover"] = { Name = "Remover Tool", DPS = 0, Infliction = 0.2, Type = "admin" },
	["weapon_physgun"] = { Name = "Physgun", DPS = 0, Infliction = 0.2, Type = "admin" },
	["weapon_physcannon"] = { Name = "Physcannon", DPS = 0, Infliction = 0.2, Type = "admin" },
	["dev_points"] = { Name = "Developer Tool", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true },
	["map_tool"] = { Name = "Mapping Tool", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true },
	["admin_raverifle"] = { Name = "Ravebreak Rifle!", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true },
	["admin_poisonspawner"] = { Name = "Poison Spawner Tool", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true },
	["admin_exploitblocker"] = { Name = "Exploit blocker Tool", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true },
	["christmas_snowball"] = { Name = "Christmas Snowball", DPS = 0, Infliction = 0, Type = "christmas", Restricted = true },
} 

GM.SkillShopAmmo = {
	["pistol"]  = { Name = "Pistol ammo pack", Model = "models/Items/BoxSRounds.mdl", Amount = 25, Price = 45},
	["357"]  = { Name = "Sniper rounds pack", Model = "models/Items/357ammo.mdl", Amount = 8, Price = 50},
	["smg1"]  = { Name = "SMG ammo pack", Model = "models/Items/BoxMRounds.mdl", Amount = 30, Price = 50},
	["ar2"]  = { Name = "Rifle Ammo pack", Model = "models/Items/combine_rifle_cartridge01.mdl", Amount = 30, Price = 50},
	["buckshot"]  = { Name = "Small Buckshot Ammo pack", Model = "models/Items/BoxBuckshot.mdl", Amount = 10, Price = 55},
	["slam"]  = { Name = "Refill 1 explosive", Model = "models/Items/BoxBuckshot.mdl",Tool = "weapon_zs_mine", Amount = 1, Price = 85, ToolTab = true},
	["grenade"]  = { Name = "Refill 1 grenade", Model = "models/Items/BoxBuckshot.mdl",Tool = "weapon_zs_grenade", Amount = 1, Price = 70, ToolTab = true},
	["gravity"]  = { Name = "Refill 1 nail", Model = "models/Items/BoxBuckshot.mdl",Tool = "weapon_zs_tools_hammer", Amount = 1, Price = 40, ToolTab = true},
	["Battery"]  = { Name = "Refill 30 charge for medkit", Model = "models/Items/BoxBuckshot.mdl", Amount = 30, Price = 30, ToolTab = true},
}


----------------------------------
--		AMMO REGENERATION		--
----------------------------------
-- This is how much ammo a player is given for whatever type it is on ammo regeneration.
-- Players are given double these amounts if 75% or above Infliction.
-- Changing these means you're an idiot.

GM.AmmoRegeneration = {
	["ar2"] = 80,
	["alyxgun"] = 16,
	["pistol"] = 40,
	["smg1"] = 80,
	["357"] = 20,
	["xbowbolt"] = 5,
	["buckshot"] = 35,
	["ar2altfire"] = 1,
	["slam"] = 2,
	["rpg_round"] = 1,
	["smg1_grenade"] = 1,
	["sniperround"] = 1,
	["sniperpenetratedround"] = 5,
	["grenade"] = 1,
	["thumper"] = 1,
	["gravity"] = 1,
	["battery"] = 1,
	["gaussenergy"] = 50,
	["combinecannon"] = 10,
	["airboatgun"] = 100,
	["striderminigun"] = 100,
	["helicoptergun"] = 100
}

-- -- -- -- -- -- -- -- -- -- /
-- Ranks, xp, drugs and etc
-- -- -- -- -- -- -- -- -- -- /
XP_BLANK = 2000

XP_INCREASE_BY = 1000

XP_PLAYERS_REQUIRED = 5

MAX_RANK = 75

-- -- -- -- -- -- -- -- -- -- /
-- [rank] = {unlocks}
GM.RankUnlocks = {
	[0] = {"weapon_zs_usp","weapon_zs_melee_keyboard"},
	[1] = {"weapon_zs_melee_plank","weapon_zs_tools_hammer"},
	[2] = {"weapon_zs_p228"},
	[3] = {"_kevlar"},
	[4] = {"weapon_zs_medkit"},
	[6] = {"weapon_zs_tools_torch"},
	[7] = {"_nailamount"},
	[11] = {"weapon_zs_tools_supplies"},
	[13] = {"_adrenaline"},
	[14] = {"_sboost"},
	[15] = {"weapon_zs_grenade"},
	[16] = {"_trchregen"},
	[17] = {"_nailhp"},
	[19] = {"_falldmg"},
	[21] = {"_kevlar2"},
	[22] = {"_medupgr2"},
	[24] = {"_comeback"},
	[25] = {"weapon_zs_turretplacer"},
	[27] = {"_poisonprotect"},
	[28] = {"weapon_zs_tools_remote"},
	[30] = {"_turretdmg"},
	[31] = {"_turrethp","weapon_zs_mine"},
	[33] = {"_turretammo"},-- ,"weapon_zs_melee_axe"
	[34] = {"_medupgr1"},
	[35] = {"_enhkevlar"},
	[37] = {"weapon_zs_tools_plank"},
	[39] = {"_plankamount"},
	[40] = {"_freeman"},
	[43] = {"_plankhp"},
	[45] = {"weapon_zs_melee_pot"},
	[50] = {"weapon_zs_miniturret"},
	[55] = {"weapon_zs_melee_axe"},
	[65] = {"weapon_zs_classic"},
	[70] = {"weapon_zs_fiveseven"},
	-- [90] = {"_professional"},-- hidden for a while
}

RETRO_AMMO_REGENERATION = 90

GM.RetroUnlocks = {
	[5] = {"weapon_zs_deagle", "weapon_zs_glock3", "weapon_zs_magnum"},
	[15] = {"weapon_zs_smg", "weapon_zs_mp5", "weapon_zs_p90", "weapon_zs_ump","weapon_zs_tmp","weapon_zs_smg","weapon_zs_sg552"},
	[20] = {"weapon_zs_mine", "weapon_zs_grenade","weapon_zs_minishotty","weapon_zs_famas","weapon_zs_galil"},
	[25] = {"weapon_zs_m1014", "weapon_zs_shotgun", "weapon_zs_annabelle"},
	[35] = {"weapon_zs_ak47", "weapon_zs_m4a1","weapon_zs_m3super90"},
	[50] = {"weapon_zs_m249"},
}

GM.ArenaWeapons = {
	"weapon_zs_m249","weapon_zs_m1014","weapon_zs_annabelle","weapon_zs_shotgun","weapon_zs_ak47","weapon_zs_m4a1","weapon_zs_m3super90",
	"weapon_zs_famas","weapon_zs_galil","weapon_zs_smg", "weapon_zs_mp5",
}

-- [name] = {Name = "...", Description = "...", Material = "..." (optional), Slot = (1 or 2)}
GM.Perks = {
	["_kevlar"] = {Name = "Kevlar", Description = "Gives you 10 more hp",Material = "VGUI/gfx/VGUI/kevlar", Slot = 1},
	["_kevlar2"] = {Name = "Kevlar 2", Description = "Gives you 20 more hp",Material = "VGUI/gfx/VGUI/kevlar", Slot = 1},
	["_turretammo"] = {Name = "Turret Ammo", Description = "50% more ammo for turret", Slot = 2},
	["_turrethp"] = {Name = "Turret Durability", Description = "50% more health for turret", Material = "VGUI/gfx/VGUI/defuser", Slot = 2},
	["_turretdmg"] = {Name = "Turret Power", Description = "50% more turret's damage", Slot = 2},
	["_poisonprotect"] = {Name = "Poison Protection", Description = "30% less damage from poison headcrabs", Slot = 2, NoRetro = true},
	["_nailamount"] = {Name = "Pack of nails", Description = "50% more starting nails", Slot = 2, NoRetro = true},
	["_nailhp"] = {Name = "Upgraded nails", Description = "40% more health for nails", Slot = 2, NoRetro = true},
	["_falldmg"] = {Name = "Fall Protection", Description = "25% less fall damage", Slot = 1},
	["_freeman"] = {Name = "Freeman's Spirit", Description = "50% more melee damage", Material = "VGUI/achievements/kill_enemy_knife_bw", Slot = 1},
	["_enhkevlar"] = {Name = "Enhanced Kevlar", Description = "15% less damage from hits",Material = "VGUI/gfx/VGUI/kevlar_helmet", Slot = 1},
	["_adrenaline"] = {Name = "Adrenaline Injection", Description = "Negates speed reduction on low health. Also your screen won't turn red when you are low on health", Slot = 1},
	["_medupgr1"] = {Name = "Medical Efficiency", Description = "35% more healing power", Slot = 2, NoRetro = true},
	["_medupgr2"] = {Name = "Medical Pack", Description = "70 more charges for medkit on spawn", Slot = 2, NoRetro = true},
	["_sboost"] = {Name = "Speed Boost", Description = "8% more walking speed", Slot = 1},
	["_trchregen"] = {Name = "Handy Man", Description = "Increased regeneration rate for torch", Material = "HUD/scoreboard_clock", Slot = 2, NoRetro = true},
	["_comeback"] = {Name = "Comeback", Description = "Gives you random Tier 2 pistol after redeeming! Works only once.", Slot = 1},
	["_professional"] = {Name = "Professional", Description = "This perk has no effect yet!", Material = "VGUI/logos/spray_elited", Slot = 1},
	["_plankamount"] = {Name = "Extra Plank", Description = "Ability to carry one more plank!", Slot = 2},
	["_plankhp"] = {Name = "Stronger Planks", Description = "30% more health for planks", Slot = 2},
}

local AddRetro = {}

for wep,tbl in pairs(GM.HumanWeapons) do
	if tbl.OnlyRetro then
		table.insert(AddRetro,wep)
	end
end

for prk,tbl in pairs(GM.Perks) do
	if tbl.OnlyRetro then
		table.insert(AddRetro,prk)
	end
end

GM.RankUnlocks[91] = AddRetro


-- [upgrade] = {what to give instead}
GM.UpgradesRefund = {
	["bootsofsteel"] = {"_falldmg"},
	["gordonfreeman"] = {"_freeman","weapon_zs_melee_pot"},
	["adrenaline"] = {"_adrenaline"},
	["backbreaker"] = {"_kevlar2"},
	["naturalimmunity"] = {"_poisonprotect"},
	["quickcure"] = {"weapon_zs_medkit","_kevlar"},
	["cheatdeath"] = {"_enhkevlar"},
	["spartanu"] = {"_enhkevlar"},
	["ammoman"] = {"weapon_zs_tools_supplies"},
	["homerun"] = {"weapon_zs_melee_pot"},
	["surgery"] = {"weapon_zs_medkit","_medupgr2"},
	["antidote"] = {"_medupgr1"},
	["blessedfists"] = {"_sboost"},
	["retrieval"] = {"_comeback"},
	["comeback"] = {"_comeback"},
}

CLASS_REFUND_LEVEL = 4
GM.ClassRefund = {
	["medic"] = {"weapon_zs_medkit","_medupgr2","_medupgr1","_sboost","weapon_zs_fiveseven"},
	["commando"] = {"_enhkevlar","weapon_zs_classic","weapon_zs_grenade","weapon_zs_mine"},
	["berserker"] = {"_sboost","_freeman","weapon_zs_melee_pot","weapon_zs_melee_axe"},
	["engineer"] = {"weapon_zs_turretplacer","weapon_zs_tools_remote","_turretdmg","weapon_zs_miniturret"},
	["support"] = {"_trchregen","weapon_zs_tools_torch","weapon_zs_tools_supplies","weapon_zs_tools_plank"},
}

-- Leave this. THis table will be filled at initialize hook
GM.WeaponsOnSale = {}

------------------------------
--		SERVER OPTIONS		--
------------------------------

-- Prevent GMod particle crashes
DISABLE_PARTICLES = false

-- If you like NPC's. NPC's will only spawn in maps that actually were built to have them in the first place. This gamemode won't create it's own.
USE_NPCS = false

-- Set this to true if you want people to get 'kills' from killing NPC's.
-- IT IS STRONGLY SUGGESTED THAT YOU EDIT THE REWARDS TABLE TO
-- MAKE THE REWARDS REQUIRE MORE KILLS AND/OR MAKE THE DIFFICULTY HIGHER IF YOU DO THIS!!!
-- Example, change Rewards[6] to Rewards[15]. The number represents the kills.
NPCS_COUNT_AS_KILLS = false

-- INCOMING!-- -- 
-- Fraction of people that should be set as zombies at the beginning of the game.
WAVE_ONE_ZOMBIES = 0.17

-- Good values are 1 to 3. 0.5 is about the same as the default HL2. 1 is about ZS difficulty. This is mainly for NPC healths and damages.
DIFFICULTY = 1.5

-- Number of waves the humans need to survive through to completely win.
NUM_WAVES = 6

-- Display current wave on the server list.
DISPLAY_WAVES_ON_SERVERLIST = true

-- Initial length for wave 1.
WAVEONE_LENGTH = ARENA_MODE and 60 or 120

-- Add this many seconds for each additional wave.
WAVE_TIMEADD = 15-- ARENA_MODE and 30 or 

-- New players are put on the zombie team if the current wave is this or higher. Do not put it lower than 1 or you'll break the game.
NONEWJOIN_WAVE = 3

-- Humans can not commit suicide if the current wave is this or lower. Negative numbers will effectively disable it but it's not suggested since people can just join quickly, suicide, and make it half-life (thus making all new players in to zombies).
NOSUICIDE_WAVE = 1

-- How long 'wave 0' should last in seconds. This is the time you should give for new players to join and get ready.
WAVEZERO_LENGTH = ARENA_MODE and 50 or 130

-- Time humans have between waves to do stuff without NEW zombies spawning. Any dead zombies will be in spectator view and any living ones will still be living.
WAVE_INTERMISSION_LENGTH = 75

WAVE_INTERMISSION_LENGTH_RETRO = 15

-- Humans can not carry OR drag anything heavier than this (in kg.)
CARRY_MAXIMUM_MASS = 300

-- Objects with more mass than this will be dragged instead of carried.
CARRY_DRAG_MASS = 145

-- Anything bigger than this is dragged regardless of mass.
CARRY_DRAG_VOLUME = 120

-- Humans can not carry anything with a volume more than this (OBBMins():Length() + OBBMaxs():Length()).
CARRY_MAXIMUM_VOLUME = 150

-- Humans are slowed by this amount per kg carried.
CARRY_SPEEDLOSS_PERKG = 1.3

-- But never slower than this.
CARRY_SPEEDLOSS_MINSPEED = 88

-- -- -- -- -- -- -- -- /

-- Used to spawn supply crates on this interval. ( seconds ) 
DEFAULT_SUPPLY_CRATE_SPAWN_TIME = 240

-- Maximum crates per map
MAXIMUM_CRATES = math.random(2,3)

-- Good values are 1 to 3. 0.5 is about the same as the default HL2. 1 is about ZS difficulty. This is mainly for NPC healths and damages.
DIFFICULTY = 1.5

-- Use Zombie Survival's custom footstep sounds? I'm not sure how bad it might lag considering you're potentially sending a lot of data on heavily packed servers.
CUSTOM_FOOTSTEPS = true

-- In seconds, repeatatively, the gamemode gives all humans get a box of whatever ammo of the weapon they use.
AMMO_REGENERATE_RATE = 999140

-- In seconds, how long humans need to survive.
ROUNDTIME = 19*60 -- 20 minutes

-- Time in seconds between end round and next map.
INTERMISSION_TIME = 46

--Amount of time players have to vote for next map(seconds)
VOTE_TIME = 18

-- New joining players will be put on the Undead team if the round is half over.
HUMAN_DEADLINE = true

-- Set this to true to destroy all brush-based doors that aren't based on phys_hinge and func_physbox or whatever. For door campers.
DESTROY_DOORS = true

-- Prop freezing manage module
PROP_MANAGE_MODULE = false

-- Set this to true to destroy all prop-based doors. Not recommended since some doors have boards on them and what-not. Only for true door camping whores.
DESTROY_PROP_DOORS = false

-- Set this to true to force players to have mat_monitorgamma set to 2.2. This could cause problems with non-calibrated screens so, whatever.
-- It forces people to use flashlights instead of whoring the video settings to make it brighter.
FORCE_NORMAL_GAMMA = true

-- Turn this to true if you don't want humans to be able to camp inside of vents and other hard to reach areas. They will die
-- if they are in a vent for 60 seconds or more.
ANTI_VENT_CAMP = false -- come on! D:

-- Set this to true to allow humans to shove other humans by pressing USE. Great for door blocking tards.
ALLOW_SHOVE = false -- not needed with soft collisions

-- Set this to true if you want your admins to be able to use the 'noclip' concommand.
-- If they already have rcon then it's pointless to set this to false.
ALLOW_ADMIN_NOCLIP = true

-- First zombie spawn delay time (default 20 seconds)
FIRST_ZOMBIE_SPAWN_DELAY = 100

-- For small prop collisions module
SMALLPROPCOLLISIONS = false

-- Time untill roll-the-dice is re-enabled
RTD_TIME = 180

-- Sound to play for last human.
LASTHUMANSOUND = "lasthuman_fixed.mp3"

-- Sound to play for ambient Un-Life music.
UNLIFESOUND = "unlife_mrgreen.mp3"
UNLIFESOUNDLENGTH = 192

-- Sound played to a person when they lose.
ALLLOSESOUND = "lose_test.mp3"

-- Sound played to a person when they win.
HUMANWINSOUND = "humanwin.mp3"

-- Sound played to a person when they die as a human.
DEATHSOUND = "music/stingers/HL1_stinger_song28.mp3"

-- Rave sound; people will hate me for making this :')
RAVESOUND = "mrgreen/ravebreak_fix.mp3"

-- Bug Reporting System
BUG_REPORT = false

-- Halloween
HALLOWEEN = false

-- Christmas!
CHRISTMAS = false



--Keep this until 1st april
FIRSTAPRIL = false

-- Human kills needed for a zombie player to redeem (resurrect). Do not set this to 0. If you want to turn this
-- system off, set AUTOREDEEM to false. (Deluvas: using Score System)
REDEEM_KILLS = 8
REDEEM_FAST_KILLS = 6

-- Turn off/on the redeeming system.
REDEEM = true

--Players cant redeem near end of round
REDEEM_PUNISHMENT = true
--Number of wave or above when zombies cant redeem
REDEEM_PUNISHMENT_TIME = 6

-- Players don't have a choice if they want to redeem or not. Setting to false makes them press F2.
AUTOREDEEM = true

-- use soft collisions for teammates
SOFT_COLLISIONS = false

WARMUP_THRESHOLD = 4
-- If a person dies when there are less than the above amount of people, don't set them on the undead team if this is true. This should generally be true on public / big servers.
WARMUP_MODE = false

--Not sure if it will work as planned, but whatever. This thing will shuffle the mapcycle sometimes
MAPS_RANDOMIZER = false

--Chance when the sale will occur
SKILLSHOP_SALE = 70

--Max amount of items that can be on sale
SKILLSHOP_SALE_MAXITEMS = 6

--Min and Max amount of discount
SKILLSHOP_SALE_SALE_MINRANGE = 10
SKILLSHOP_SALE_SALE_MAXRANGE = 25

if MaxPlayers() < 4 then
	WARMUP_MODE = false
end

util.PrecacheSound(LASTHUMANSOUND)
util.PrecacheSound(UNLIFESOUND)


WELCOME_TEXT =
[[
Select your loadout below and start to survive the Zombie Apocalypse.
The more you play - the more unlocks you get for your loadout.
Need help playing this gamemode? Press F1 while playing.

Community: http://mrgreengaming.com
]]
--[=[
This version of gamemode was heavily modified so if you have any questions - you'd better check out F1 menu as soon as you spawn.

Select your starting loadout at the panels below and press 'Spawn' when you done.
The more you play - the more unlocks you can get for your loadout and of course you get higher rank!
Visit our forums at www.left4green.com if you are interested or if you want to leave a feedback.

Enjoy your stay and have fun!	
]=]	


SKILLSHOP_TEXT =
[[
At SkillShop you can buy weapons and ammo for yourself using SkillPoints.
To gain SkillPoints - simply kill zombies and help your teammates.

At the menu below you can get everything what you need, but remember - SkillShop is avalaible only between waves.
Also, note that if you buy a weapon - it will have low amount of ammo unless you buy more ammunition.

(TIP: During fighting you always can check your amount of SkillPoints on the left side of HUD)
]]	

local shit = ""
if REDEEM then
	shit = [[You must hurry and redeem yourself before the round ends!@
To redeem yourself, get a score of ]]..REDEEM_KILLS..[[ and you will respawn as a human.]]
end


-- This is what is displayed on the scoreboard, in the help menu. Seperate lines with "@"
-- Don't put @'s right next to eachother.
-- Use ^r ^g ^b ^y  when the line starts to change color of the line

HELP_TXT = {}

HELP_TXT[1] = {
	title = "Help", 
	txt = [[
	Mr. Green Zombie Survival
	
	-- HUMANS -----------------------------------------------------
	
	> Objective: Team up and survive the 6 waves!
	> Weapons: Kill zombies, help your teammates to gain skillpoints! Between waves you can buy weapons/ammo/other stuff from supplies crates using your skillpoints.
	> Leveling: To level up - you need to gain experience that you get for almost anything you do. Each time you level up - you may unlock new tools and perks. 
	To check your current experience type !levelstats in chat.
	> Tips: Stick with your team and make good use of your tools and skillpoints.
	
	
	-- ZOMBIES ----------------------------------------------------
	
	> Objective: Eat all humans. If you get 8 score (by eating 4 humans) - you will be able to redeem (F2).
	> Classes: Zombies have 8 different classes that will be unlocked with each wave (press F3 to choose your class). Between waves you will be forced to spectate as crow.
	> Spawning: As zombie you can spawn on other zombies (left mouse button). With right mouse button you can scroll through other zombies.
	> Teamwork: Zombies can gain damage resistance from bullets by grouping into hordes. 
	
	
	
	
	
	
	Check out www.mrgreengaming.com!
	]]
} 

HELP_TXT[2] = {
	title = "Rules", 
	txt = [[
	The following WILL get you permabanned:
		  - hacking / cheating
		  - getting yourself banned too often
		  - being a general retard
	
	The following can result in temporary ban:
		  - Being rude
		  - Impersonating an admin
		  - Exploiting after being warned several times
		  - Ladder glitching
		  - Cadebreaking
	
	The following can result in kick or insta-death:
		  - Being AFK for a long period of time
		  - Spamming after being muted/gagged
		
	The following can result in being teleported:
		  - Exploiting a map
		  - Prop climbing
		
	The following can result in being muted/gagged:
		  - Spamming
		  - Abusing voice (playing music, screaming etc.)
		  - Excessive swearing
	
	]]
} 

HELP_TXT[3] = {
	title = "About", 
	txt = [[
		Mr. Green forums can be found at http://mrgreengaming.com
		If you have any questions or tips about/for this server you can always e-mail to info@limetric.com
		
		Surf to http://mrgreengaming.com to post your ideas for changes and where you can post suggestions for new maps.
		
		Gamemode is developped by Limetric for Mr. Green Gaming Community. More info at http://limetric.com
	]]
} 

HELP_TXT[4] = {
	title = "Quick Guide", 
	txt = [[
		> How to change zombie class?
		* Press F3 (also drops weapon as human)
		
		> How to become a human as a zombie?
		* Kill 4 humans (score 8 points)
		
		> How to get new weapons?
		* Get SkillPoints by helping your team and use them on available supply crate (between waves)
		
		> Where I can buy hats?
		* GreenCoins Shop. Type !shop in chat to open it.
		
		> How to use hammer?
		* Right click to nail a prop to something. (A hammer can't heal props!)
		
		> How to check my experience amount?
		* Type !levelstats in chat
		
		> Where I can find options?
		* Press F4
		
		> Who's awesome?
		* You are!
	]]
} 
ADMINS_HTTP = "http://left4green.com/serverinfo/zs_admins.php"
HELP_TXT[5] = {
	title = "Server", 
	txt = [[]]
} 

HELP_TEXT = {}
HELP_TEXT[1] = { title = "Help", text = [[^rZombie Survival
@This version has been modified for the Mr. Green server
@
@^b          -- HUMANS --
@
@Objective - Survive the Round
@
@Ammo - Supply Crate Drops, Follow the Arrow when it appears and press "E" on supply crates.
@
@Ammo - Ammunition Regeneration will regenerate current weapon
@
@^g          -- ZOMBIES --
@
@Objective - Kill Humans to Redeem
@
@Kill 4 Humans - 8 Score to Redeem.
@
@
@
@
@
@Zombie Survival modified by Limetric Studios.
@
@Check out www.lef4green.com or www.limetric.com!]]}

-- Append the changelog later on
CHANGELOG_HTTP = "http://www.mr-green.nl/portal/serverinfo/zs_changelog.html"
HELP_TEXT[2] = { title = "Changelog", text = [[^rGamemode changelog
@Some changes from JetBoom's original Zombie Survival v1.11 are listed here.
@
@^bGot any ideas, suggestions or whatever?
@Go to our forums at www.left4green.com and post it there.
@
@^yLatest changes on the server:
@
@- Too much stuff. Just browse our forums to check changelog
@
@
@
@
@
]]}


HELP_TEXT[3] = { title = "Server", text = [[^rServer information
@^yThe Mr. Green forums can be found at http://www.left4green.com
@
@If you have any questions or tips about/for this server you can always e-mail to ywa@limetric.com
@
@Surf to http://www.left4green.com to post your ideas for changes and where you can post suggestions for new maps.
@
@
]]}


HELP_TEXT[4] = { title = "Rules", text = [[^rRules
@
@^yThe following WILL get you permabanned
@	- hacking / cheating
@	- getting yourself banned too often
@
@^yThe following can result in temporary ban:
@   - Being Unkind Often
@   - Impersonating an Admin
@   - Exploiting after Being Warned Several Times
@   - Glitching on Purpose
@
@^yThe following can result in kick or insta-death:
@   - Being AFK for a Long Period of Time
@   - Spamming after being muted/gagged
@
@^yThe following can result in being teleported:
@   - Exploiting a Map
@   - Prop Climbing
@
@^yThe following can result in being muted/gagged:
@   - Spamming
@   - Being Underage and Using Microphone
@   - Excessive Swearing
 ]]}

-- DON'T CHANGE DONATE TO ANOTHER NUMBER THAN 5 (see ReceiveDonLevel in cl_init)
HELP_TEXT[5] = { title = "Donate!", text = [[^yDONATE TO THIS SERVER!
@
@As you all might know, Mr. Green is a very active server. This results in a massive use of bandwidth
@which unfortunately, doesn't pay for itself.
@
@We will gladly accept donations to keep our server online! Every donation will be translated to Green-Coins on the server!
@
@This is how it works: for every EURO you donate, you get 1000 GC (Green-Coins). So if you donate 5 euros you
@get 5000 GC, donate 10 euros and you'll get 10.000! Green-Coins can be spend in the Green-Shop to buy upgrades, 
@fancy hats or other neat features! (type "!shop" to open it, or use the button on the right -->)
@
@^yHOW TO DONATE
@
@Donations are all done via PAYPAL (www.paypal.com).
@
@Further instructions can be found on our website www.left4green.com. Select "Green-Coins" and follow the link to the 
@instructions topic in the page footer. Or follow this link directly: http://forums.left4green.com/index.php?showtopic=2183
@
@^yYou will need your SteamID to connect your Steam account to the forum account. Type "!steamid" in chat to view yours.
@
]]}

HELP_TEXT[6] = { title = "Fun", text = [[^yFun stuff
@
@List of chat triggers. Differs per male/female/combine voicesets:
@
@	- "zombie"
@   - "pills"
@	- "headcrab"
@	- "watch out"
@	- "open the door"
@	- "get out"
@	- "nice"
@	- "hacks"
@	- "help"
@	- "move" or "lets go"
@	- "oh shi"
@	- "incoming"
@	- "get down"
@ 	- "ok"
@
@ There are also quite a few secret ones too. ;)
@
]]}

HELP_TEXT[7] = { title = "Quick Guide.", text = [[^Beginners Guide
@
@ @^gQ: How do I change zombie class?
@A: Press f3
@
@^gQ: How do I become human if I am zombie?
@A: Kill 4 Humans, Get 8 Score
@
@^gQ: How do I change human class?
@A: Press f4
@
@^gQ: Where is the options menu?
@A: Press f4
@
@ 
@^b Q: How do I sprint and use grenade as zombine?	
@ A: When you take enough damage (~50% of your hp) you will be able to sprint and use grenade (Right mouse click).
@	
@^b Q: How do I heal as medic?	
@ A: Equip medkit. Left click to heal other players,right click to heal yourself (you should stand still).	
@	
@^b Q: How do I use teleport as Ethereal Zombie?	
@ A: Aim at the ground (not the walls) and press right mouse button.	
@	
@^b Q: How to change my class as zombie?	
@ A: Press F3 and you will see class selection menu.	
@	
@^b Q: How to nail props using hammer?	
@ A: Thats easy, aim at the prop (make sure that there is a wall behind it) and press right mouse button.	
@
@^b Q: Why supply crate gives me only ammo?
@ A: Supply crates will give you ammo until when there will be ~6-7 humans.
@
@^b Q: Where i can see the full changelog?
@ A: Here: http://projects.limetric.com/projects/zombiesurvival
@
@^b Q: How I can buy stuff?
@ A: Click 'Green SHOP' button or type '!shop' to open a shop where you can spend your Green Coins.
@
@^b Q: How to drop weapon as human?
@ A: Select weapon and press F3.
@
@^b Q: My weapons are huge. What the hell?
@ A: Press F4 and disable 'Enable BC2 style weapons' checkbox.
@
@
@
]]}


for k, v in pairs(HELP_TEXT) do
	v.text = string.Explode("@", v.text)
	for _, text in pairs(v.text) do
		text = string.gsub(text, "@", "")
	end
end


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------
-- ZOMBIE CLASSES --
-----------------------------

ZombieClasses = {} -- Leave this.

util.PrecacheSound("npc/zombie/foot1.wav")
util.PrecacheSound("npc/zombie/foot2.wav")
util.PrecacheSound("npc/zombie/foot3.wav")
util.PrecacheSound("npc/zombie/foot_slide1.wav")
util.PrecacheSound("npc/zombie/foot_slide2.wav")
util.PrecacheSound("npc/zombie/foot_slide3.wav")

ZombieClasses[0] =						
{
	Name = "Infected",	
	Tag = "infected",	
	Wave = math.floor(0 * NUM_WAVES),
	Revives = false,
	Health = 80,
	MaxHealth = 100,
	Bounty = 40,
	SP = 10,
	Threshold = 0,	
	SWEP = "weapon_zs_undead_infected",			
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	Model = Model("models/player/group01/male_09.mdl"), 
	Speed = 195,	
	-- AngleFix = true,
	Description = "The victim of zombie plague.",
	Unique = "Agile and hungry.",
	PainSounds = {
				Sound("npc/zombie/zombie_alert1.wav"),
				Sound("npc/zombie/zombie_alert2.wav"),
				Sound("npc/zombie/zombie_alert3.wav"),
				}, 
	DeathSounds = {
				Sound("npc/zombie/zombie_die1.wav"),
				Sound("npc/zombie/zombie_die2.wav"),
				Sound("npc/zombie/zombie_die3.wav")
				}, 	
	PlayerFootstep = true,
	Unlocked = true,
	OnSpawn = function(pl)
		
			local desiredname = pl:GetInfo("cl_playermodel")
			local modelname = player_manager.TranslatePlayerModel(#desiredname == 0 and "models/player/group01/male_09.mdl" or desiredname)
			local lowermodelname = string.lower(modelname)
			pl:SetModel(lowermodelname)
			
			pl:SetRandomFace()
			
		end,
	-- ModelScale = Vector(1.35,1.35,1.35),
}

ZombieClasses[1] =						
{
	Name = "Normal Zombie",	
	Tag = "zombie",	
	Wave = math.floor(0 * NUM_WAVES),
	Revives = true,
	Health = 250,
	MaxHealth = 350,
	Bounty = 100,
	SP = 15,
	Threshold = 0,	
	SWEP = "weapon_zs_zombie",			
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	Model = Model("models/Zombie/Classic.mdl"), 
	Speed = 154,	
	AngleFix = true,
	Description="The Backbone of any Undead Horde. The Common Rotting Zombie.",
	Unique = "Can be deadly in numbers. Can Propkill.",
	PainSounds = {
				Sound("npc/zombie/zombie_pain1.wav"),
				Sound("npc/zombie/zombie_pain2.wav"),
				Sound("npc/zombie/zombie_pain3.wav"),
				Sound("npc/zombie/zombie_pain4.wav"),
				Sound("npc/zombie/zombie_pain5.wav"),
				Sound("npc/zombie/zombie_pain6.wav")
				}, 
	DeathSounds = {
				Sound("npc/zombie/zombie_die1.wav"),
				Sound("npc/zombie/zombie_die2.wav"),
				Sound("npc/zombie/zombie_die3.wav")
				}, 	
	PlayerFootstep = true,
	Unlocked = true,
	-- ViewOffset = Vector( 0, 0, 0 ),
	ReviveCallback = function(pl, attacker, dmginfo)
		if math.random(1, 4) ~= 1 then
			DefaultRevive(pl)
			return true
		end
		return false
	end,
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
	end,
	-- ModelScale = Vector(1.35,1.35,1.35),
}

ZombieClasses[2] = 
{
	Name = "Fast Zombie",
	Tag = "fastzombie",
	Wave = math.floor(0.5 * NUM_WAVES),
	Health = 100,
	MaxHealth = 150,
	TimeLimit = 300,
	Bounty = 80,
	SP = 20,
	Threshold = 2,
	SWEP = "weapon_zs_undead_fastzombie",
	JumpPower = 300,
	CanCrouch = true,
	CanGib = true,
	AngleFix = true,
	Model = Model("models/Zombie/Fast.mdl"),
	Speed = 250,
	Description = "The Predator of the Undead! Avoid trying to run away from this one as it will catch you!.",
	Unique = "Unique abilities: Can climb walls and leep great distances.",
	PainSounds = {
				Sound("npc/fast_zombie/leap1.wav"),
				Sound("npc/fast_zombie/wake1.wav")
				},
	DeathSounds = {
				Sound("npc/fast_zombie/fz_alert_close1.wav")
				},
	PlayerFootstep = true,
	ViewOffset = Vector( 0, 0, 50 ),
	ViewOffsetDucked = Vector( 0, 0, 24 ),
	Hull = { Vector(-16, -16, 0), Vector(16, 16, 58) },
	HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 32)}
	-- ViewOffset = Vector(0, 0, 0)
}

ZombieClasses[3] =
{
	Name = "Poison Zombie",
	Tag = "poisonzombie",
	Wave = 5,--math.floor(0.6 * NUM_WAVES),
	Health = 500,
	MaxHealth = 650,
	TimeLimit = 810,
	Bounty = 130,
	SP = 25,
	Mass = DEFAULT_MASS * 1.5,
	Threshold = 3,
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	SWEP = "weapon_zs_undead_poisonzombie",
	Model = Model( "models/Zombie/Poison.mdl" ),
	Speed = 123,
	Description="The tank of the undead! Prepare to run when these come in numbers!",
	Unique = "Unique abilities: Can take large amounts of damage while the weak undead are behind it. Can throw decaying flesh at humans.",
	PainSounds = {
				Sound("npc/zombie_poison/pz_pain1.wav"),
				Sound("npc/zombie_poison/pz_pain2.wav"),
				Sound("npc/zombie_poison/pz_pain3.wav")
				},
	IdleSounds = {
				Sound("npc/zombie_poison/pz_alert1.wav"),
				Sound("npc/zombie_poison/pz_alert2.wav"),
				Sound("npc/zombie_poison/pz_idle2.wav"),
				Sound("npc/zombie_poison/pz_idle3.wav"),
				Sound("npc/zombie_poison/pz_idle4.wav"),
				},
	DeathSounds = {
				Sound("npc/zombie_poison/pz_die1.wav"),
				Sound("npc/zombie_poison/pz_die2.wav")
				},
	-- ViewOffset = Vector( 0, 0, 0 ),
}

ZombieClasses[4] =
{
	Name = "Ethereal Zombie",
	Tag = "etherealzombie",
	Wave = math.floor(0.4 * NUM_WAVES),-- 0.4 
	Health = 75,
	MaxHealth = 80,
	TimeLimit = 200,
	Bounty = 60,
	SP = 12,
	Threshold = 2,
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	SWEP = "weapon_zs_undead_wraith",
	Model = Model( "models/wraith.mdl" ),
	Speed = 195,
	Description="A Ghastly figure, capable of disguising! The Undead Assassin!",
	Unique = "Unique abilities: Barely visible.",
	PainSounds = {
				Sound("npc/stalker/stalker_pain1.wav"),
				Sound("npc/stalker/stalker_pain2.wav"),
				Sound("npc/stalker/stalker_pain3.wav"),
				-- Sound("npc/barnacle/barnacle_pull4.wav")
				},
	DeathSounds = {
				Sound("npc/stalker/stalker_die1.wav"),
				Sound("npc/stalker/stalker_die2.wav"),
				-- Sound("wraithdeath3.wav"),
				-- Sound("wraithdeath4.wav")
				},
	-- ViewOffset = Vector(0, 0, 0)
}

ZombieClasses[5] =						
{
	Name = "Howler",
	Tag = "howler",	
	Wave = math.floor(0.4 * NUM_WAVES),
	Health = 90,
	MaxHealth = 150,
	TimeLimit = 460,
	Bounty = 70,
	SP = 15,	
	Threshold = 2,					
	SWEP = "weapon_zs_undead_howler",			
	JumpPower = 200,
	CanCrouch = true,
	CanGib = false,
	Model = Model( "models/player/group01/female_01.mdl" ), 
	Speed = 185,						
	Description="Always kill this banshee at a large distanc, as its scream can blow heads up!",
	Unique = "Unique abilities: Can disorientate humans and can sometimes create a sound barrier for herself and other nearby undead.",
	AttackSounds = { 
				Sound ( "player/zombies/howler/howler_scream_01.wav" ),
				Sound ( "player/zombies/howler/howler_scream_02.wav" ),
				},
	PainSounds = { 
				Sound ( "player/zombies/howler/howler_mad_01.wav" ),
				Sound ( "player/zombies/howler/howler_mad_02.wav" ),
				Sound ( "player/zombies/howler/howler_mad_03.wav" ),
				Sound ( "player/zombies/howler/howler_mad_04.wav" ),
				},
	DeathSounds = {
				Sound( "player/zombies/howler/howler_death_01.wav" ),
				}, 
	PlayerFootstep = true,
	OnSpawn = function(pl)
		
		-- pl:SetModel("models/player/group01/female_01.mdl")
	
		local status = pl:GiveStatus("overridemodel")
		
		if status and status:IsValid() then
			status:SetModel("models/mrgreen/howler.mdl")
		end
	end,
	-- ViewOffset = Vector( 0, 0, 0 )
}
util.PrecacheModel("models/mrgreen/howler.mdl")
ZombieClasses[6] =
{
	Name = "Headcrab",
	Tag = "headcrab",
	Wave = math.floor(0 * NUM_WAVES),
	Health = 45,
	MaxHealth = 80,
	Bounty = 50,
	SP = 10,
	Mass = 25,
	TimeLimit = 130,
	IsHeadcrab = true,
	JumpPower = 200,
	CanCrouch = false,
	CanGib = false,
	Threshold = 1,
	SWEP = "weapon_zs_undead_headcrab",
	Model = Model("models/headcrabclassic.mdl"),
	Speed = 180,
	Description="Headhumper!",
	Unique = "Unique abilities: Can sneak through small holes and under barricades.",
	PainSounds = {
				Sound("npc/headcrab/pain1.wav"),
				Sound("npc/headcrab/pain2.wav"),
				Sound("npc/headcrab/pain3.wav")
				},
	DeathSounds = {
				Sound("npc/headcrab/die1.wav"),
				Sound("npc/headcrab/die2.wav")
				},
	ViewOffset = Vector( 0,0,10 ),
	Hull = { Vector(-12, -12, 0), Vector(12, 12, 18.1)}
}

ZombieClasses[7] =
{
	Name = "Poison Headcrab",
	Tag = "poisonheadcrab",
	Wave = math.floor(0.7 * NUM_WAVES),
	Health = 65,
	MaxHealth = 100,
	Bounty = 70,
	SP = 12,
	Mass = 40,
	StepSize = 8,
	TimeLimit = 780,
	IsHeadcrab = true,
	JumpPower = 0,
	CanCrouch = false,
	CanGib = false,
	AngleFix = true,
	Threshold = 3,
	SWEP = "weapon_zs_undead_poisonheadcrab",
	Model = Model("models/headcrabblack.mdl"),
	Speed = 125,
	Description="A headcrab that can launch poison spit from long distances!",
	Unique = "Unique abilities: Can do direct damage with its spit ball. Can poison players with its bite.",
	PainSounds = {
				Sound("npc/headcrab_poison/ph_pain1.wav"),
				Sound("npc/headcrab_poison/ph_pain2.wav"),
				Sound("npc/headcrab_poison/ph_pain3.wav")
				},
	DeathSounds = {
				Sound("npc/headcrab_poison/ph_rattle1.wav"),
				Sound("npc/headcrab_poison/ph_rattle2.wav"),
				Sound("npc/headcrab_poison/ph_rattle3.wav")
				},
	ViewOffset = Vector( 0,0,10 ),
	Hull = { Vector(-12, -12, 0), Vector(12, 12, 18.1) }
}

ZombieClasses[8] =
{
	Name = "Zombine",
	Tag = "zombine",
	Wave = 6, --math.floor(0.7 * NUM_WAVES),
	Health = 270,
	MaxHealth = 270, --decreased from 320
	TimeLimit = 1020,
	Bounty = 150,
	SP = 30,
	Mass = DEFAULT_MASS * 1.2,
	Threshold = 4,
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	SWEP = "weapon_zs_undead_zombine",
	Model = Model("models/zombie/Zombie_Soldier.mdl"),
	Speed = 120,
	RunSpeed = 200,
	Description = "It is best to avoid shooting this slow monster as it might become enraged and charge at humans!",
	Unique = "Unique abilities: Can charge once taken enough amount of damage. Can hold a grenade out!",
	PainSounds = {
				Sound( "npc/zombine/zombine_pain1.wav" ),
				Sound( "npc/zombine/zombine_pain2.wav" ),
				Sound( "npc/zombine/zombine_pain3.wav" ),
				Sound( "npc/zombine/zombine_pain4.wav" ),
				},
	DeathSounds = {
				Sound("npc/zombine/zombine_die1.wav"),
				Sound("npc/zombine/zombine_die2.wav"),
				},
	IdleSounds = {
				Sound("npc/zombine/zombine_idle1.wav"),
				Sound("npc/zombine/zombine_idle2.wav"),
				Sound("npc/zombine/zombine_idle3.wav"),
				Sound("npc/zombine/zombine_idle4.wav"),
				},
	AlertSounds = {
				Sound ( "npc/zombine/zombine_alert1.wav" ),
				Sound ( "npc/zombine/zombine_alert2.wav" ),
				Sound ( "npc/zombine/zombine_alert3.wav" ),
				Sound ( "npc/zombine/zombine_alert4.wav" ),
				Sound ( "npc/zombine/zombine_alert5.wav" ),
				Sound ( "npc/zombine/zombine_alert6.wav" ),
				Sound ( "npc/zombine/zombine_alert7.wav" ),
				},
}

ZombieClasses[9] =
{
	Name = "Crow",
	Health = 30,
	Wave = 0,
	Tag = "crow",
	Bounty = 1,
	SP = 1,
	Mass = 2,
	Threshold = 0,
	CanGib = true,
	CanCrouch = false,
	SWEP = "weapon_zs_crow",
	Model = Model("models/crow.mdl"),
	Speed = 60,
	RunSpeed = 125,
	Description="Use this infected crow to sneak up humans and spawn as zombie!",
	PainSounds = {
				Sound("npc/crow/pain1.wav"),
				Sound("npc/crow/pain2.wav")
				},
	DeathSounds = {
				Sound("npc/crow/die1.wav"),
				Sound("npc/crow/die2.wav")
				},
	CanCrouch = false,
	ViewOffset = Vector(0,0,8),
	Hull = { Vector(-5,-5, 0), Vector(5,5,5) },
	NoPhysics = true,
	Hidden = true
}

ZombieClasses[10] =						
{
	Name = "Hate",	
	Tag = "hate",	
	Wave = math.floor(0 * NUM_WAVES),
	Health = 10000,
	MaxHealth = 10000,
	Bounty = 1000,
	SP = 1000,
	IsBoss = true,
	Mass = DEFAULT_MASS * 2,
	Threshold = 0,	
	SWEP = "weapon_zs_undead_hate",			
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	Model = Model("models/Zombie/Classic.mdl"), 
	Speed = 215,
	Hidden = true,	
	AngleFix = true,
	Description="",
	Unique = "",
	AttackSounds = {
				Sound("player/zombies/hate/chainsaw_attack_miss.wav"),
				Sound("player/zombies/hate/chainsaw_attack_hit.wav"),
				}, 
	PainSounds = {
				Sound("player/zombies/hate/sawrunner_pain1.wav"),
				Sound("player/zombies/hate/sawrunner_pain2.wav"),
				}, 
	DeathSounds = {
				Sound("npc/zombie_poison/pz_die1.wav"),
				Sound("npc/zombie_poison/pz_die2.wav")
				},
	IdleSounds = {
				Sound("player/zombies/hate/sawrunner_alert10.wav"),
				Sound("player/zombies/hate/sawrunner_alert20.wav"),
				Sound("player/zombies/hate/sawrunner_alert30.wav"),
				Sound("player/zombies/hate/sawrunner_attack2.wav"),
				},
	PlayerFootstep = true,
	Unlocked = false,
	-- ViewOffset = Vector( 0, 0, 0 ),
	OnSpawn = function(pl)
		-- if not pl.Revive then
			local status = pl:GiveStatus("overridemodel")
		
			if status and status:IsValid() then
				status:SetModel("models/Zombie/Poison.mdl")
			end
		-- end
		
		local status2 = pl:GiveStatus("simple_revive")
		if status2 then
			status2:SetReviveTime(CurTime() + 4)
			-- status2:SetZombieInitializeTime(CurTime() + 0.1)
		end
		
	end,
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
	end,
	ModelScale = 1.35,-- Vector(1.35,1.35,1.35),
	ViewOffset = Vector(0, 0, 84),
	ViewOffsetDucked = Vector(0,0,38),
	--Hull = { Vector(-21,-21, 0), Vector(21,21,97) },
	Hull = { Vector(-16,-16, 0), Vector(16,16,97) },
	HullDuck = { Vector(-16,-16, 0), Vector(16,16,69) },
}

ZombieClasses[11] =
{
	Name = "Behemoth",
	Tag = "behemoth",
	Wave = 0, --math.floor(0.7 * NUM_WAVES),
	Health = 8100,
	MaxHealth = 8100,
	TimeLimit = 1020,
	Bounty = 1000,
	SP = 1000,
	Mass = DEFAULT_MASS * 2,
	Threshold = 4,
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	Unlocked = false,
	Hidden = true,
	IsBoss = true,
	SWEP = "weapon_zs_undead_behemoth",
	Model = Model("models/zombie/Zombie_Soldier.mdl"),
	Speed = 187,
	Description = "",
	Unique = "",
	PainSounds = {
				Sound( "npc/strider/striderx_pain2.wav" ),
				Sound( "npc/strider/striderx_pain5.wav" ),
				Sound( "npc/strider/striderx_pain7.wav" ),
				Sound( "npc/strider/striderx_pain8.wav" ),
				},
	DeathSounds = {
				Sound("npc/strider/striderx_die1.wav"),
				},
	IdleSounds = {
				Sound("npc/zombine/striderx_alert2.wav"),
				Sound("npc/zombine/striderx_alert4.wav"),
				Sound("npc/zombine/striderx_alert5.wav"),
				Sound("npc/zombine/striderx_alert6.wav"),
				},
	OnSpawn = function(pl)
		local status = pl:GiveStatus("overridemodel")
		
		if status and status:IsValid() then
			status:SetModel("models/zombie/Zombie_Soldier.mdl")
		end
	
	
		local status2 = pl:GiveStatus("simple_revive2")
		if status2 then
			status2:SetReviveTime(CurTime() + 4)
			status2:SetReviveDuration(3.37)
			-- status2:SetZombieInitializeTime(CurTime() + 0.1)
		end
		
	end,
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
		-- pl:AnimRestartMainSequence()		
	end,
	ModelScale = 1.15,-- Vector(1.15,1.15,1.15),
	ViewOffset = Vector(0, 0, 73),
	ViewOffsetDucked = Vector(0,0,32.2),
	-- Hull = { Vector(-18,-18, 0), Vector(18,18,83) },
	Hull = { Vector(-16,-16, 0), Vector(16,16,83) },
	HullDuck = { Vector(-16,-16, 0), Vector(16,16,41) },
}

ZombieClasses[12] =
{
	Name = "Seeker",
	Tag = "seeker",
	Wave = 0, --math.floor(0.7 * NUM_WAVES),
	Health = 8000,
	MaxHealth = 8000,
	TimeLimit = 1020,
	Bounty = 1000,
	SP = 1000,
	Mass = DEFAULT_MASS * 2,
	Threshold = 4,
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	Unlocked = false,
	Hidden = true,
	IsBoss = true,
	SWEP = "weapon_zs_undead_seeker",
	Model = Model("models/Zombie/Poison.mdl"),
	Speed = 195,
	Description = "",
	Unique = "",
	PainSounds = {
				Sound( "player/zombies/seeker/pain1.wav" ),
				Sound( "player/zombies/seeker/pain2.wav" ),
				},
	DeathSounds = {
				Sound("npc/stalker/go_alert2a.wav"),
				},
	IdleSounds = {
				Sound("bot/come_out_and_fight_like_a_man.wav"),
				Sound("bot/come_out_wherever_you_are.wav"),
				Sound("vo/ravenholm/madlaugh03.wav"),
				Sound("vo/NovaProspekt/eli_nevermindme01.wav"),
				Sound("ambient/creatures/town_child_scream1.wav"),
				Sound("npc/zombie_poison/pz_call1.wav"),
				},
	OnSpawn = function(pl)
		local status = pl:GiveStatus("overridemodel")
		
		if status and status:IsValid() then
			status:SetModel("models/player/charple01.mdl")
			status:UsePlayerAlpha(true)
		end		
	end,
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
		-- pl:AnimRestartMainSequence()		
	end,
	ModelScale = 1.15,-- Vector(1.15,1.15,1.15),
	ViewOffset = Vector(0, 0, 73),
	ViewOffsetDucked = Vector(0,0,32.2),
	Hull = { Vector(-16,-16, 0), Vector(16,16,83) },
	HullDuck = { Vector(-16,-16, 0), Vector(16,16,41) },
}

ZombieClasses[13] =
{
	Name = "Nerf",
	Tag = "nerf",
	Wave = 0, --math.floor(0.7 * NUM_WAVES),
	Health = 7000,
	MaxHealth = 7000,
	TimeLimit = 1020,
	Bounty = 1000,
	SP = 1000,
	Mass = DEFAULT_MASS * 2,
	Threshold = 4,
	JumpPower = 300,
	CanCrouch = true,
	CanGib = true,
	Unlocked = false,
	Hidden = true,
	IsBoss = true,
	SWEP = "weapon_zs_undead_nerf",
	Model = Model("models/Zombie/Fast.mdl"),
	Speed = 175,
	Description = "",
	Unique = "",
	PainSounds = {
				Sound("npc/fast_zombie/leap1.wav"),
				Sound("npc/fast_zombie/wake1.wav")
				},
	DeathSounds = {
				Sound("npc/antlion_guard/antlion_guard_die1.wav"),
				Sound("npc/antlion_guard/antlion_guard_die2.wav"),
				},
	IdleSounds = {

				},
	OnSpawn = function(pl)
		local status = pl:GiveStatus("overridemodel")
		
		if status and status:IsValid() then
			status:SetModel("models/Zombie/Fast.mdl")
		end		
	end,
	OnRevive = function(pl)
		--pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
		-- pl:AnimRestartMainSequence()		
	end,
	ModelScale = 0.85,-- Vector(0.85,0.85,0.85),
	ViewOffset = Vector( 0, 0, 50 ),
	ViewOffsetDucked = Vector( 0, 0, 24 ),
	Hull = { Vector(-16, -16, 0), Vector(16, 16, 58) },
	HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 32)}
}

local SantaStart = {
	Sound("vo/ravenholm/engage06.wav"),
	Sound("vo/ravenholm/engage01.wav"),
}

-- for swep
--[==[
RegisterLuaAnimation('babyface', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_Calf'] = {
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -1,
					RR = 13,
					RF = -7
				},
				['ValveBiped.Bip01_Pelvis'] = {
				},
				['ValveBiped.Bip01_R_Hand'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = 15,
					RR = 20,
					RF = -28
				},
				['ValveBiped.Bip01_Spine'] = {
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 27,
					RF = -12
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 44,
					MF = -5,
					RR = 7
				},
				['ValveBiped.Bip01_Spine4'] = {
					RU = 21
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 13,
					RR = 5,
					RF = 17
				},
				['ValveBiped.Bip01_Spine1'] = {
					RU = 8,
					MF = 1,
					RR = 9
				},
				['ValveBiped.Bip01_Spine2'] = {
					RU = 8,
					MF = 1
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = 5,
					RR = -5
				},
				['ValveBiped.Bip01_R_Thigh'] = {
				}
			},
			FrameRate = 1
		}
	},
	Type = TYPE_POSTURE
})

]==]

ZombieSuperBosses = {}

--Hate II
ZombieSuperBosses[10] = {
	Name = "Hate II",	
	Tag = "hate",	
	Wave = math.floor(0 * NUM_WAVES),
	Health = 11000,
	MaxHealth = 11000,
	Bounty = 1300,
	SP = 1300,
	IsBoss = true,
	IsSuperBoss = true,
	Mass = DEFAULT_MASS * 2,
	Threshold = 0,	
	SWEP = "weapon_zs_undead_hate2",			
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	Model = Model("models/Zombie/Classic.mdl"), 
	Speed = 230,
	Hidden = true,	
	AngleFix = true,
	Description="",
	Unique = "",
	AttackSounds = {
				Sound("player/zombies/hate/chainsaw_attack_miss.wav"),
				Sound("player/zombies/hate/chainsaw_attack_hit.wav"),
				}, 
	PainSounds = {
				Sound("player/zombies/hate/sawrunner_pain1.wav"),
				Sound("player/zombies/hate/sawrunner_pain2.wav"),
				}, 
	DeathSounds = {
				Sound("npc/zombie_poison/pz_die1.wav"),
				Sound("npc/zombie_poison/pz_die2.wav")
				},
	IdleSounds = {
				Sound("player/zombies/hate/sawrunner_alert10.wav"),
				Sound("player/zombies/hate/sawrunner_alert20.wav"),
				Sound("player/zombies/hate/sawrunner_alert30.wav"),
				Sound("player/zombies/hate/sawrunner_attack2.wav"),
				},
	PlayerFootstep = true,
	Unlocked = false,
	-- ViewOffset = Vector( 0, 0, 0 ),
	OnSpawn = function(pl)
		-- if not pl.Revive then
			local status = pl:GiveStatus("overridemodel")
		
			if status and status:IsValid() then
				status:SetModel("models/Zombie/Poison.mdl")
				status:SetBodygroup(2,1)
				status:SetBodygroup(3,1)
				status:SetBodygroup(2,1)
			end
		-- end
		
		pl:EmitSound( table.Random ( ZombieClasses[10].IdleSounds ),math.random( 110, 160 ),math.random( 85, 110 )  )
		
		local status2 = pl:GiveStatus("simple_revive")
		if status2 then
			status2:SetReviveTime(CurTime() + 4)
			-- status2:SetZombieInitializeTime(CurTime() + 0.1)
		end
		
	end,
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
	end,
	ModelScale = 1.53,-- Vector(1.52,1.52,1.52),
	ViewOffset = Vector(0, 0, 90),
	ViewOffsetDucked = Vector(0,0,40),
	--Hull = { Vector(-21,-21, 0), Vector(21,21,97) },
	Hull = { Vector(-16,-16, 0), Vector(16,16,106) },
	HullDuck = { Vector(-16,-16, 0), Vector(16,16,70) },
}

--[==[if SUPER_BOSS then
	for index, tbl in pairs(ZombieClasses) do
		if ZombieSuperBosses[index] then
			ZombieClasses[index] = ZombieSuperBosses[index]
		end
	end
end]==]

--Champions
ZombiePowerups = {}

--Stronger 
ZombiePowerups[1] = {HealthAdd = {40,50}, Scale = 1.05, Speed = 0.9, Color = Color(255,170,170,255) }
ZombiePowerups[2] = {HealthAdd = {80,110}, Scale = 1.1, Speed = 0.8, Color = Color(255,100,100,255) }
ZombiePowerups[3] = {HealthAdd = {90,130}, Scale = 1.3, Speed = 0.75, Color = Color(255,50,50,255) }
--Faster
ZombiePowerups[4] = {HealthAdd = {-20,-10}, Scale = 0.9, Speed = 1.1, Color = Color(255,250,170,255) }

ZombieClassesCrow =
{
	Name = "Crow",
	Health = 30,
	Threshold = 0,
	SWEP = "weapon_zs_crow",
	Model = Model("models/crow.mdl"),
	Speed = 250,
	Description="Use this infected crow to sneak up humans and spawn as zombie!",
	PainSounds = {
				Sound("npc/crow/pain1.wav"),
				Sound("npc/crow/pain2.wav")
				},
	DeathSounds = {
				Sound("npc/crow/die1.wav"),
				Sound("npc/crow/die2.wav")
				},
	ViewOffset = Vector(0, 0, 0),
	Hidden = true
}
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Add models to this table to prevent human players from using them (Zombie skins and such).

GM.RestrictedModels = {}
GM.RestrictedModels["models/player/classic.mdl"] = true -- This is the only one that really looks like a zombie.
GM.RestrictedModels["models/player/zombie_soldier.mdl"] = true
GM.RestrictedModels["models/player/zombiefast.mdl"] = true
GM.RestrictedModels["models/player/corpse1.mdl"] = true
GM.RestrictedModels["models/player/charple01.mdl"] = true
GM.RestrictedModels["models/player/zombie_classic.mdl"] = true
GM.RestrictedModels["models/player/zombie_fast.mdl"] = true

--[=[---------------------------------------------
		Human Perks/Classes
------------------------------------------------]=]--

HumanClasses = { }

HumanClasses[1] =
{
	Name = "Medic",
	Tag = "medic",
	Health = 95,
	Description = {"% more damage with pistols","% more heal on teammates","% increased speed","% less damage taken"},
	Coef = {2,10,2,5},
	Models = {"models/player/group03/male_02.mdl","models/player/group03/Male_04.mdl","models/player/group03/male_06.mdl","models/player/group03/male_07.mdl"},
	Speed = 200,
}

HumanClasses[2] =
{
	Name = "Commando",
	Tag = "commando",
	Health = 100,
	Description = {"% increased rifle magazine size","% more health","% chance to spawn with rifle","Can see health of zombies and ethereals"},
	Coef = {5,2,3,""},
	Models = {"models/player/combine_soldier.mdl","models/player/combine_soldier_prisonguard.mdl","models/player/combine_super_soldier.mdl","models/player/police.mdl" },
	Speed = 190,
}

HumanClasses[3] =
{
	Name = "Berserker",--Aka Marksman
	Tag = "marksman",
	Health = 90,
	Description = {"% increased scope zoom","% chance to spawn with scout","% more bullet force"," more long range hs dmg"},
	Coef = {7,3,18,4},
	Models = {"models/player/gasmask.mdl","models/player/odessa.mdl","models/player/group01/male_04.mdl","models/player/hostage/hostage_02.mdl"},
	Speed = 200
}

HumanClasses[4] =
{
	Name = "Engineer",
	Tag = "engineer",
	Health = 100,
	Description = {"% chance to spawn with turret","% increased clip for pulse weapons","% chance to spawn with pulse smg","% more turret's efficiency"},
	Coef = {4,6,3,10},
	Models = {"models/player/alyx.mdl","models/player/barney.mdl","models/player/eli.mdl","models/player/mossman.mdl","models/player/kleiner.mdl","models/player/breen.mdl" },
	Speed = 190
}

HumanClasses[5] =
{
	Name = "Support",
	Tag = "support",
	Health = 90,
	Description = {"% increased smg damage.","% chance to spawn with smg","% chance to spawn with mobile supplies","more nail(s) for the hammer"},
	Coef = {5,3,12,1},
	Models = {"models/player/arctic.mdl","models/player/leet.mdl","models/player/guerilla.mdl","models/player/phoenix.mdl","models/player/riot.mdl","models/player/swat.mdl","models/player/urban.mdl" },
	Speed = 200
}
	
	-- Human Class Description Tables
	ClassInfo = { }
	ClassInfo[1] = { }
	ClassInfo[1].Ach = { }
	ClassInfo[1].Ach[1] = {"Heal 10k hp", "Open 100 supply crates",10000,100}  -- What you need to do to get from level 0 to 1!
	ClassInfo[1].Ach[2] = {"Heal 20k hp", "Open 250 supply crates",20000,250} -- What you need to do to get from level 1 to 2!
	ClassInfo[1].Ach[3] = {"Heal 500 injured people", "Heal 1000 hp from supply crates",500,1000}
	ClassInfo[1].Ach[4] = {"Heal 1000 injured people", "Heal 2100 hp from supply crates",1000,2100}
	ClassInfo[1].Ach[5] = {"Heal 400 infected people", "Survive 150 rounds",400,150}
	ClassInfo[1].Ach[6] = {"Heal 900 infected people", "Survive 300 rounds",900,300}
	ClassInfo[1].Ach[7] = {"All Done", "All Done",4500,300}
	
	ClassInfo[2] = { }
	ClassInfo[2].Ach = { }
	ClassInfo[2].Ach[1] = {"Dismemberment 600 undead", "Do 150k dmg to undead",600,150000} -- 0 
	ClassInfo[2].Ach[2] = {"Dismemberment 2000 undead", "Do 300k dmg to undead",2000,300000} -- 1  
	ClassInfo[2].Ach[3] = {"Kill 300 howlers with rifle", "Kill 1500 zombies with rifle",300,1500} -- 2
	ClassInfo[2].Ach[4] = {"Kill 600 howlers with rifle", "Kill 3000 zombies with rifle",600,3000} -- 3
	ClassInfo[2].Ach[5] = {"Open 500 supply crates", "Survive 150 rounds",500,150} -- 4
	ClassInfo[2].Ach[6] = {"Open 1200 supply crates", "Survive 300 rounds",1200,300} --5
	ClassInfo[2].Ach[7] = {"All Done", "All Done",500,300}
	
	
	ClassInfo[3] = { }
	ClassInfo[3].Ach = { }
	ClassInfo[3].Ach[1] = {"Get 1000 headshots", "Deal 170k sniper damage",1000,170000}
	ClassInfo[3].Ach[2] = {"Get 2500 headshots", "Deal 450k sniper damage",2500,450000}
	ClassInfo[3].Ach[3] = {"Deal 200k headshot damage", "Kill 1500 zombies",200000,1500}
	ClassInfo[3].Ach[4] = {"Deal 600k headshot damage", "Kill 4000 zombies",600000,4000}
	ClassInfo[3].Ach[5] = {"Get 700 long range headshots", "Survive 150 rounds",1337,150}
	ClassInfo[3].Ach[6] = {"Get 1337 long range headshots", "Survive 300 rounds",4000,300}
	ClassInfo[3].Ach[7] = {"All Done", "All Done",15000,300}
	
	
	ClassInfo[4] = { }
	ClassInfo[4].Ach = { }
	ClassInfo[4].Ach[1] = {"Deploy 20 turrets", "Deploy 150 tripmines",20,150}
	ClassInfo[4].Ach[2] = {"Deploy 60 turrets", "Deploy 350 tripmines",60,350}
	ClassInfo[4].Ach[3] = {"Kill 600 undead with mine", "Deal 200k mine damage",600,200000} --
	ClassInfo[4].Ach[4] = {"Kill 850 undead with mine", "Deal 500k mine damage",850,500000} --
	ClassInfo[4].Ach[5] = {"Deal 250k damage with pulse", "Survive 150 rounds",250000,150}
	ClassInfo[4].Ach[6] = {"Deal 500k damage with pulse", "Survive 300 rounds",500000,300}
	ClassInfo[4].Ach[7] = {"All Done", "All Done",500000,300}
	
	ClassInfo[5] = { }
	ClassInfo[5].Ach = { }
	ClassInfo[5].Ach[1] = {"Take 25000 ammo from supply crates", "Nail 150 props",25000,150}
	ClassInfo[5].Ach[2] = {"Take 100k ammo from supply crates", "Nail 400 props",100000,400}
	ClassInfo[5].Ach[3] = {"Deal 150k dmg with smg", "Open 300 supply crates",150000,300}
	ClassInfo[5].Ach[4] = {"Deal 300k dmg with smg", "Open 1100 supply crates",300000,1100}
	ClassInfo[5].Ach[5] = {"Deal 200k dmg with shotgun", "Survive 150 rounds",200000,150}
	ClassInfo[5].Ach[6] = {"Deal 400k dmg with shotgun", "Survive 300 rounds",400000,300}
	ClassInfo[5].Ach[7] = {"All Done", "All Done",400000,300}

--[=[--------------------------------------------
		Achievement descriptions
--------------------------------------------]=]
PLAYER_STATS = true --  enables data reading/writing, DO NOT TURN OFF. ALSO APPLIES TO DONATION PROCESSING!

achievementDesc = {
	[1] = { Image = "zombiesurvival/achv_blank_zs", Key = "bloodseeker", ID = 1, Name = "Bloodseeker", Desc = "Kill 5 humans in one round!",  },
	[2] = { Image = "zombiesurvival/achv_blank_zs", Key = "angelofwar", ID = 2, Name = "Angel of War", Desc = "Kill 1000 undead in total!",  },
	[3] = { Image = "zombiesurvival/achv_blank_zs", Key = "ghost", ID = 3, Name = "Ghost", Desc = "Make a kill before getting hit even once (after spawn) as zombie!",  },
	[4] = { Image = "zombiesurvival/achv_blank_zs", Key = "meatseeker", ID = 4, Name = "Meatseeker", Desc = "Kill 8 humans in one round!",  },
	[5] = { Image = "zombiesurvival/achv_blank_zs", Key = "sexistzombie", ID = 5, Name = "Sexist Zombie", Desc = "Kill a girl! (FYI: based on model)",  },
	[6] = { Image = "zombiesurvival/achv_blank_zs", Key = "angelofhope", ID = 6, Name = "Angel of Hope", Desc = "Kill 10.000 undead in total!",  },
	[7] = { Image = "zombiesurvival/achv_blank_zs", Key = "emo", ID = 7, Name = "Emo", Desc = "Kill yourself while human",  },
	[8] = { Image = "zombiesurvival/achv_blank_zs", Key = "samurai", ID = 8, Name = "Samurai", Desc = "Melee 10 zombies in one round!",  },
	[9] = { Image = "zombiesurvival/achv_blank_zs", Key = "spartan", ID = 9, Name = "Spartan", Desc = "Kill 300 undead in total!",  },
	[10] = { Image = "zombiesurvival/achv_blank_zs", Key = "toolsofdestruction", ID = 10, Name = "Tools of Destruction", Desc = "Propkill 3 humans in one round!",  },
	[11] = { Image = "zombiesurvival/achv_blank_zs", Key = "headfucker", ID = 11, Name = "Headfucker", Desc = "Kill 5 humans as headcrab (poison excluded) in one round!",  },
	[12] = { Image = "zombiesurvival/achv_blank_zs", Key = "masterofzs", ID = 12, Name = "Master of ZS", Desc = "Get every other achievement",  },
	[13] = { Image = "zombiesurvival/achv_blank_zs", Key = "dealwiththedevil", ID = 13, Name = "Deal With The Devil", Desc = "Redeem yourself three times",  },
	[14] = { Image = "zombiesurvival/achv_blank_zs", Key = "launchanddestroy", ID = 14, Name = "Launch And Destroy", Desc = "Propkill a human",  },
	[15] = { Image = "zombiesurvival/achv_blank_zs", Key = "humanitysdamnation", ID = 15, Name = "Humanity's Damnation", Desc = "Do a total of 10.000 damage to the humans!",  },
	[16] = { Image = "zombiesurvival/achv_blank_zs", Key = "slayer", ID = 16, Name = "Slayer", Desc = "Kill 50 humans in total!",  },
	[17] = { Image = "zombiesurvival/achv_blank_zs", Key = "runningmeatbag", ID = 17, Name = "Running Meatbag", Desc = "Stay alive at least 1 minute when last human",  },
	[18] = { Image = "zombiesurvival/achv_blank_zs", Key = "sergeant", ID = 18, Name = "Sergeant", Desc = "Kill 60 undead in one round!",  },
	[19] = { Image = "zombiesurvival/achv_blank_zs", Key = "survivor", ID = 19, Name = "Survivor", Desc = "Be last human and win the round",  },
	[20] = { Image = "zombiesurvival/achv_blank_zs", Key = "marksman", ID = 20, Name = "Marksman", Desc = "Kill a fast zombie in mid-air",  },
	[21] = { Image = "zombiesurvival/achv_blank_zs", Key = "slowdeath", ID = 21, Name = "Slow Death", Desc = "Kill a human by poisoning him!",  },
	[22] = { Image = "zombiesurvival/achv_blank_zs", Key = "poltergeist", ID = 22, Name = "Poltergeist", Desc = "Scare the living daylights out of 10 different players with the Wraith scream!",  },
	[23] = { Image = "zombiesurvival/achv_blank_zs", Key = "private", ID = 23, Name = "Private", Desc = "Kill 20 undead in one round!",  },
	[24] = { Image = "zombiesurvival/achv_blank_zs", Key = "butcher", ID = 24, Name = "Butcher", Desc = "Kill 100 humans in total!",  },
	[25] = { Image = "zombiesurvival/achv_blank_zs", Key = "iamlegend", ID = 25, Name = "I Am Legend", Desc = "Kill yourself when last human",  },
	[26] = { Image = "zombiesurvival/achv_blank_zs", Key = "payback", ID = 26, Name = "Payback", Desc = "Redeem yourself",  },
	[27] = { Image = "zombiesurvival/achv_blank_zs", Key = "dancingqueen", ID = 27, Name = "Dancing Queen", Desc = "Avoid getting hit the whole round when human!",  },
	[28] = { Image = "zombiesurvival/achv_blank_zs", Key = "feastseeker", ID = 28, Name = "Feastseeker", Desc = "Kill 12 humans in one round!",  },
	[29] = { Image = "zombiesurvival/achv_blank_zs", Key = ">:(", ID = 29, Name = ">:(", Desc = "Kill an admin when he's human",  },
	[30] = { Image = "zombiesurvival/achv_blank_zs", Key = "hidinkitchencloset", ID = 30, Name = "Hid In Kitchen Closet", Desc = "Stay alive for at least 5 minutes as last human",  },
	[31] = { Image = "zombiesurvival/achv_blank_zs", Key = "ninja", ID = 31, Name = "Ninja", Desc = "Melee 5 zombies in one round!",  },
	[32] = { Image = "zombiesurvival/achv_blank_zs", Key = "lightbringer", ID = 32, Name = "Lightbringer", Desc = "Do a total of 100.000 damage to the undead!",  },
	[33] = { Image = "zombiesurvival/achv_blank_zs", Key = "laststand", ID = 33, Name = "Last Stand", Desc = "Melee a zombie while having less than 10 hp",  },
	[34] = { Image = "zombiesurvival/achv_blank_zs", Key = "mankindsanswer", ID = 34, Name = "Mankind's Answer", Desc = "Do a MASSIVE total of 1.000.000 damage to the undead!",  },
	[35] = { Image = "zombiesurvival/achv_blank_zs", Key = ">>:o", ID = 35, Name = ">>:O", Desc = "Kill an admin 5 times when he's zombie in one round!",  },
	[36] = { Image = "zombiesurvival/achv_blank_zs", Key = "corporal", ID = 36, Name = "Corporal", Desc = "Kill 40 undead in one round!",  },
	[37] = { Image = "zombiesurvival/achv_blank_zs", Key = "humanitysworstnightmare", ID = 37, Name = "Humanity's Worst Nightmare", Desc = "Do a total of 100.000 damage to the humans!",  },
	[38] = { Image = "zombiesurvival/achv_blank_zs", Key = "stuckinpurgatory", ID = 38, Name = "Stuck In Purgatory", Desc = "Redeem yourself a 100 times in total!",  },
	[39] = { Image = "zombiesurvival/achv_blank_zs", Key = "eredicator", ID = 39, Name = "Eredicator", Desc = "Kill 250 humans in total!",  },
	[40] = { Image = "zombiesurvival/achv_blank_zs", Key = "annihilator", ID = 40, Name = "Annihilator", Desc = "Kill 1000 humans in total!",  },
	[41] = { Image = "zombiesurvival/achv_blank_zs", Key = "headhumper", ID = 41, Name = "Headhumper", Desc = "Kill 3 humans as headcrab (poison excluded) in one round!",  },
	[42] = { Image = "zombiesurvival/achv_blank_zs", Key = "fuckingrambo", ID = 42, Name = "Fucking Rambo", Desc = "Kill 100 undead in one round!",  },
	[43] = { Image = "zombiesurvival/achv_blank_zs", Key = "hate", ID = 43, Name = "Don't hate me, bro", Desc = "Be manly enough to kill the ancient evil!",  },
	[44] = { Image = "zombiesurvival/achv_blank_zs", Key = "bhkill", ID = 44, Name = "The Walking Apocalypse", Desc = "'Hey, I saw you before!'",  },
	[45] = { Image = "zombiesurvival/achv_blank_zs", Key = "seek", ID = 45, Name = "Hide'n'Seek", Desc = "When prey kills the hunter...",  },
	[46] = { Image = "zombiesurvival/achv_blank_zs", Key = "nerf", ID = 46, Name = "Your worst enemy", Desc = "Still complaining? :v",  },
	[47] = { Image = "zombiesurvival/achv_blank_zs", Key = "flare", ID = 47, Name = "'Let there be light!'", Desc = "???",  },
}	

--[=[---------------------------------
	Server stats
----------------------------------]=]
SERVER_STATS = true

GM.DataTable = {}
GM.DataTable[1] = { title = "Top zombies killed in one round", players = {{}} }
GM.DataTable[2] = { title = "Top zombies killed overall", players = {{}} }
GM.DataTable[3] = { title = "Top brains eaten in one round", players = {{}} }
GM.DataTable[4] = { title = "Top brains eaten overall", players = {{}} }
GM.DataTable[5] = { title = "Longest last human time", players = {{}} }
GM.DataTable[6] = { title = "Longest playtime on server", players = {{}} }

for k, v in ipairs( GM.DataTable ) do
	for i = 1, 5 do
		v.players[i] = { name = "< no data >", steamid = "ID"..i, value = 0 } -- filler info
	end
end

--[=[-----------------------------------
		Some other player data
------------------------------------]=]

recordData = {
	["undeadkilled"] = { Name = "Undead killed", Desc = "Amount of undead this person killed", Image = "zombiesurvival/achv_blank_zs" },	
	["humanskilled"] = { Name = "Humans killed", Desc = "Amount of humans this person killed", Image = "zombiesurvival/achv_blank_zs" },
	["undeaddamaged"] = { Name = "Undead damaged", Desc = "Amount of damage this person inflicted to the undead", Image = "zombiesurvival/achv_blank_zs" },	
	["humansdamaged"] = { Name = "Humans damaged", Desc = "Amount of damage this person inflicted to the humans", Image = "zombiesurvival/achv_blank_zs" },	
	["redeems"] = { Name = "Redeems", Desc = "Amount of times this player redeemed", Image = "zombiesurvival/achv_blank_zs" },
	["timeplayed"] = { Name = "Time played", Desc = "Time this player spend on this server (measured from last round)", Image = "zombiesurvival/achv_blank_zs" },
	["progress"] = { Name = "Overall Progress", Desc = "How much percent of the total amount of achievements this person has", Image = "zombiesurvival/achv_blank_zs" },
}

--[=[-----------------------------------
		Class data
------------------------------------]=]

classData = {
	["medic"] = { level = 0, achlevel0_1 = 0, achlevel0_2 = 0, achlevel2_1 = 0, achlevel2_2 = 0, achlevel4_1 = 0, achlevel4_2 = 0 } ,
	["commando"] = { level = 0, achlevel0_1 = 0, achlevel0_2 = 0, achlevel2_1 = 0, achlevel2_2 = 0, achlevel4_1 = 0, achlevel4_2 = 0 },
	["berserker"] = { level = 0, achlevel0_1 = 0, achlevel0_2 = 0, achlevel2_1 = 0, achlevel2_2 = 0, achlevel4_1 = 0, achlevel4_2 = 0 },
	["engineer"] = { level = 0, achlevel0_1 = 0, achlevel0_2 = 0, achlevel2_1 = 0, achlevel2_2 = 0, achlevel4_1 = 0, achlevel4_2 = 0 },
	["support"] = { level = 0, achlevel0_1 = 0, achlevel0_2 = 0, achlevel2_1 = 0, achlevel2_2 = 0, achlevel4_1 = 0, achlevel4_2 = 0 },
	["default"] = { rank = 0, xp = 0 },
}

--[=[---------------------------------
		Mr. Green's Shop Data
----------------------------------]=]
local function PrintData()
	for k,v in pairs ( achievementDesc ) do
		Msg( "["..k.."] = { " )
		for i,j in pairs( v ) do
			local Value = tostring( j )
			if type( j ) == "string" then Value = [["]]..tostring( j )..[["]] end
			Value = string.Replace( Value, "\n", "" )
			Msg( i.." = "..Value..", " )
		end
		Msg( " }, \n" )
	end
end

shopData = {
	[1] = { Cost = 800, Type = "hat", AdminOnly = false, Desc = "Eating too many eggs in the morning? No problem. This is your solution! Now you can eat eggs, in-game, too!", Key = "egg", ID = 1, Sell = 0, Requires = 0, Name = "Egg Hat",  },
	[2] = { Cost = 800, Type = "hat", AdminOnly = false, Desc = "If you wear this, you'll look like that anime character,Kanti Sama.", Key = "monitor", ID = 2, Sell = 0, Requires = 0, Name = "TV Head",  },
	[3] = { Cost = 5000, Hidden = true, AdminOnly = false, Desc = "Join the group with your only friend, Mister .357 cal. Have a 1/3 chance of starting the round with a magnum! Damage with this weapon increased by 50%.", Key = "magnumman", ID = 3, Sell = 0, Requires = 0, Name = "Mysterious Stranger",  },
	[4] = { Cost = 6000, Hidden = true, AdminOnly = false, Desc = "You kill humans for a living. Literally. Restores half your HP after killing a human!", Key = "steamroller", ID = 4, Sell = 0, Requires = 0, Name = "Steamroller",  },
	[5] = { Cost = 7500, Hidden = true, AdminOnly = false, Desc = "Get an additional weapon after redeeming. More zombies, better weapon.", Key = "comeback", ID = 5, Sell = 0, Requires = 0, Name = "Comeback",  },
	[6] = { Cost = 1000, Type = "other", AdminOnly = false, Desc = "Being a bit paranoid about those toxic fumes? No worries, carry this mask! (note: it doesn't work against toxis fumes).", Key = "mask", ID = 6, Sell = 0, Requires = 0, Name = "Mask",  },
	[7] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "Time to hit a homerun! All you need is a headcrab and a crowbar...", Key = "ushat", ID = 7, Sell = 0, Requires = 0, Name = "Baseball cap",  },
	[8] = { Cost = 5000, Hidden = true, AdminOnly = false, Desc = "Human spines are like toothpicks to you. Do more damage when attacking a human from behind!", Key = "backbreaker", ID = 8, Sell = 0, Requires = 0, Name = "Backbreaker",  },
	[9] = { Cost = 100, Type = "hat", AdminOnly = false, Desc = "Trick 'r' treat! Make sure you put this hat on to look cool on Halloween :) (Permanent hat)", Key = "pumpkin", ID = 9, Sell = 0, Requires = 0, Name = "Pumpkin Hat",  },
	[10] = { Cost = 750, Type = "hat", AdminOnly = false, Desc = "Easter eggs. Lol.", Key = "bunnyears", ID = 10, Sell = 0, Requires = 0, Name = "Bunny Ears",  },
	[11] = { Cost = 5000, Hidden = true, AdminOnly = false, Desc = "Bringing your bare hands to a gun fight? Why not! You'll get an extra boost with melee weapons and your fists.", Key = "blessedfists", ID = 11, Sell = 0, Requires = 0, Name = "Blessed Fists",  },
	[12] = { Cost = 7500, Hidden = true, AdminOnly = false, Desc = "God puts you on his express list. Redeem after killing 3 humans!", Key = "quickredemp", ID = 12, Sell = 0, Requires = 0, Name = "Quick Redemption",  },
	[13] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "You might experience a little IQ increase when inserting this thing in your head. Don't count on it though.", Key = "borghat", ID = 13, Sell = 0, Requires = 0, Name = "Borg hat",  },
	[14] = { Cost = 1, Type = "hat", AdminOnly = true, Desc = "Hat for admins! Nope, normal players cannot see this in the list.", Key = "greenshat", ID = 14, Sell = 0, Requires = 0, Name = "Greens Hat",  },
	[15] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "With this big eye-catching thing lodged on your head you're sure to attract some attention. Too bad it doesn't shoot lasers.", Key = "roboteye", ID = 15, Sell = 0, Requires = 0, Name = "Robot hat",  },
	[16] = { Cost = 5500, Hidden = true, AdminOnly = false, Desc = "You are healthy as a horse and you regenerate an additional 10 hp of health, if under 40 health. You need Quick Cure and at least 3 upgrades to buy this.", Key = "antidote", ID = 16, Sell = 0, Requires = 3, Name = "Horse Health",  },
	[17] = { Cost = 7500, Hidden = true, AdminOnly = false, Desc = "Rambo's your bitch. Get a poweful weapon when becoming last human. (Different weapon for different class!)", Key = "lastmanstand", ID = 17, Sell = 0, Requires = 0, Name = "Last Man Stand",  },
	[18] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "Ho ho ho! Merry Christmas! It's that time of the year again .. (Permanent hat)", Key = "snowhat", ID = 18, Sell = 0, Requires = 0, Name = "Snowman Hat",  },
	[19] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "Greencoins make Santa Claus's World go round! That's why you should buy this lovely hat right from Santa's Bag!  .. (Permanent hat)", Key = "present", ID = 19, Sell = 0, Requires = 0, Name = "Present Hat",  },
	[20] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "A sawblade sombrero, how cool can it get? Chuck Norris has one you know.", Key = "sombrero", ID = 20, Sell = 0, Requires = 0, Name = "Sombrero",  },
	[21] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "You won't die of starvation with this thing on.", Key = "melonhead", ID = 21, Sell = 0, Requires = 0, Name = "Melonhead",  },
	[22] = { Cost = 5000, Hidden = true, AdminOnly = false, Desc = "You get twice as much ammunition from the Supply Crates!", Key = "ammoman", ID = 22, Sell = 0, Requires = 0, Name = "Ammunition Man",  },
	[23] = { Cost = 7000, Hidden = true, AdminOnly = false, Desc = "You get thirsty and want to suck the blood out of your victims. With this sucker,you'll leech health from your victims. The greater the damage, the greater the leech!", Key = "vampire", ID = 23, Sell = 0, Requires = 5, Name = "Blood Sucker",  },
	[24] = { Cost = 6500, Hidden = true, AdminOnly = false, Desc = "Have a chance to start the round as THE Gordon Freeman. Crowbar damage is scaled by the number of zombies!", Key = "gordonfreeman", ID = 24, Sell = 0, Requires = 0, Name = "Crowbar Wielding God",  },
	[25] = { Cost = 5000, Hidden = true, AdminOnly = false, Desc = "When having low health you won't walk as slow as without adreline.", Key = "adrenaline", ID = 25, Sell = 0, Requires = 0, Name = "Adrenaline",  },
	[26] = { Cost = 7500, Hidden = true, AdminOnly = false, Desc = "A few bandages should hold. Health regenerates when below 30 hp when you're still human!", Key = "quickcure", ID = 26, Sell = 0, Requires = 0, Name = "Quick Cure",  },
	[27] = { Cost = 1500, Type = "misc", AdminOnly = false, Desc = "Ability to change your player title in the Options (F4) menu.", Key = "titlechanging", ID = 27, Sell = 0, Requires = 0, Name = "Title Editor",  },
	[28] = { Cost = 7200, Hidden = true, AdminOnly = false, Desc = "When your health is 30 or below, and you get hit by zombies that do damage greater than 25, then you have a 30% chance to not take damage. Occurs once in 5 minutes. You must have atleast 4 upgrades to buy this one.", Key = "cheatdeath", ID = 28, Sell = 0, Requires = 4, Name = "Cheat Death",  },
	[29] = { Cost = 3500, Hidden = true, AdminOnly = false, Desc = "Health vials and packs heal you for 50% more health.", Key = "surgery", ID = 29, Sell = 0, Requires = 3, Name = "Surgery",  },
	[30] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "A cooking pot is THE perfect household head protection when fighting anything unnatural!", Key = "pothat", ID = 30, Sell = 0, Requires = 0, Name = "Pot hat",  },
	[31] = { Cost = 4000, Hidden = true, AdminOnly = false, Desc = "Cannibalism is healthy. Get more health from eating flesh gibs when zombie.", Key = "fleshfreak", ID = 31, Sell = 0, Requires = 0, Name = "Flesh Freak",  },
	[32] = { Cost = 800, Type = "hat", AdminOnly = false, Desc = "Your ICING? Uhm, dude you got something on your head! This hat doesn't turn you into a zombie!", Key = "crab", ID = 32, Sell = 0, Requires = 0, Name = "Headcrab Hat",  },
	[33] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "Christmas, it's that time of the year again!", Key = "santahat", ID = 33, Sell = 0, Requires = 0, Name = "Santa hat",  },
	[34] = { Cost = 4000, Type = "misc", AdminOnly = false, Desc = "Luck is not for sale? Well it is here! The chance of a good outcome with roll-the-dice is increased.", Key = "ladyluck", ID = 34, Sell = 0, Requires = 0, Name = "Lady Luck",  },
	[35] = { Cost = 5000, Hidden = true, AdminOnly = false, Desc = "Retrieve all weapons from your previous life after redeeming as zombie.", Key = "retrieval", ID = 35, Sell = 0, Requires = 0, Name = "Might Of A Previous Life ",  },
	[36] = { Cost = 800, Type = "hat", AdminOnly = false, Desc = "You'd be Nicolas Cage - Death Rider with this hat on!", Key = "skull", ID = 36, Sell = 0, Requires = 0, Name = "Skull Hat",  },
	[37] = { Cost = 5000, Hidden = true, AdminOnly = false, Desc = "As human, if you get hit by a poison headcrab spit or hump, you will get 40% less damage.", Key = "naturalimmunity", ID = 37, Sell = 0, Requires = 4, Name = "Natural Immunity",  },
	[38] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "Pirates are the mortal enemy of ninjas, but they love to pick off a zombie on their way.", Key = "piratehat", ID = 38, Sell = 0, Requires = 0, Name = "Pirate hat",  },
	[39] = { Cost = 1500, Type = "hat", AdminOnly = false, Desc = "Raises your intelligence-aura by 100%! Note that it does not scare off zombies.", Key = "tophat", ID = 39, Sell = 0, Requires = 0, Name = "Top hat",  },
	[40] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "Bring some old-fashioned style to the apocalypse. Probably stolen from a dead Brit.", Key = "homburg", ID = 40, Sell = 0, Requires = 0, Name = "Homburg hat",  },
	[41] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "A bucket hat. Works better than kevlar according to the local bums.", Key = "buckethat", ID = 41, Sell = 0, Requires = 0, Name = "Bucket hat",  },
	[42] = { Cost = 5500, Hidden = true, AdminOnly = false, Desc = "As human, you receive [15 + your total score divided by 5] percent less damage from Normal and Poison zombies. Requires 7 other upgrades.", Key = "spartanu", ID = 42, Sell = 0, Requires = 7, Name = "Spartan",  },
	[43] = { Cost = 6500, Hidden = true, AdminOnly = false, Desc = "Bring more destruction power! You will deal 50% more damage against barricades and nailed props! Requires 3 other upgrades.", Key = "cadebuster", ID = 43, Sell = 0, Requires = 3, Name = "Cade Buster (NEW)",  },
	[44] = { Cost = 5000, Hidden = true, AdminOnly = false, Desc = "Screw the gravity! You will have 25% chance to avoid fall damage. Requires 2 other upgrades.", Key = "bootsofsteel", ID = 44, Sell = 0, Requires = 2, Name = "Boots of Steel (NEW)",  },
	[45] = { Cost = 7500, Hidden = true, AdminOnly = false, Desc = "Bonk! Receive additional 20% chance to decapitate a zombie! Requires 6 other upgrades.", Key = "homerun", ID = 45, Sell = 0, Requires = 6, Name = "Home Run (NEW)",  },
	[46] = { Cost = 11000, Hidden = true, Type = "suit", AdminOnly = false, Desc = "Classic suit from IW!", Key = "testsuit", ID = 46, Sell = 0, Requires = 0, Name = "IW test suit",  },
	[47] = { Cost = 1, Type = "suit", AdminOnly = true, Desc = "Special suit just for admins! (not finished yet)", Key = "greenssuit", ID = 47, Sell = 0, Requires = 0, Name = "Admin's Suit",  },
	[48] = { Cost = 11000, Type = "suit", AdminOnly = false, Desc = "For those who tries to keep their teammates alive. Suit Bonus: Faster medkit charge time", Key = "medicsuit", ID = 48, Sell = 0, Requires = 0, Name = "Medic's Suit",  }, --11000
	[49] = { Cost = 11000, Type = "suit", AdminOnly = false, Desc = "Crush. Pound. Suit Bonus: Faster swing speed (heavy weapons only)", Key = "meleesuit", ID = 49, Sell = 0, Requires = 0, Name = "Close combat Suit",  },
	[50] = { Cost = 11000, Type = "suit", AdminOnly = false, Desc = "If shooting zombies aint enough - use more gun. Suit Bonus: 10% damage reduction for turret", Key = "techsuit", ID = 50, Sell = 0, Requires = 0, Name = "Tech Suit",  },
	[51] = { Cost = 11000, Type = "suit", AdminOnly = false, Desc = "If you've mastered cading skills - this suit is for you. Suit Bonus: Increased torch capacity", Key = "supportsuit", ID = 51, Sell = 0, Requires = 0, Name = "Barricade Guy Suit",  },
	[52] = { Cost = 11000, Type = "suit", AdminOnly = false, Desc = "Nothing feels better than killing zombies over and over again. Suit Bonus: Increased grenade damage/radius", Key = "assaultsuit", ID = 52, Sell = 0, Requires = 0, Name = "Zombie killer Suit",  },
	[53] = { Cost = 2400, Type = "other", AdminOnly = false, Desc = "It glows!", Key = "techeyes", ID = 53, Sell = 0, Requires = 0, Name = "Techno Eyes" },
	[54] = { Cost = 1800, Type = "hat", AdminOnly = false, Desc = "What the... How the hell you are still alive with that thing in your head?!", Key = "cleaver", ID = 54, Sell = 0, Requires = 0, Name = "Nasty Cleaver" },
	[55] = { Cost = 2000, Type = "hat", AdminOnly = false, Desc = "Augmentations ftw. However this hat will not increase your accuracy :O", Key = "magnlamp", ID = 55, Sell = 0, Requires = 0, Name = "Magnifying lamp" },
	[56] = { Cost = 2100, Type = "hat", AdminOnly = false, Desc = "It HUNGERS for more!", Key = "scannerhelm", ID = 56, Sell = 0, Requires = 0, Name = "Scanner Helmet" },
	[57] = { Cost = 5200, Type = "misc", AdminOnly = false, Desc = "Ability to change the color of your hat (not suit) in F4 menu!", Key = "hatpainter", ID = 57, Sell = 0, Requires = 0, Name = "Hat Painter" },--5200
	[58] = { Cost = 900, Type = "hat", AdminOnly = false, Desc = "'I love the smell of cooked zombies in the morning!'", Key = "chef", ID = 58, Sell = 0, Requires = 0, Name = "Chef's Hat" },
	[59] = { Cost = 2100, Type = "hat", AdminOnly = false, Desc = "Picking up cans since 2008", Key = "combinehelm", ID = 59, Sell = 0, Requires = 0, Name = "Combine Helmet" },
	[60] = { Cost = 2200, Type = "other", AdminOnly = false, Desc = "Looks like it was ripped off straight from Vaporizer Rifle... Or not?", Key = "termeye", ID = 60, Sell = 0, Requires = 0, Name = "Technology!" },
	[61] = { Cost = 1700, Type = "hat", AdminOnly = false, Desc = "A cute fez for your and your friends :O  (NOTE: Actually it is red by default, but preview aint showing it)", Key = "fez", ID = 61, Sell = 0, Requires = 0, Name = "Tiny Fez" },
	[62] = { Cost = 2100, Type = "other", AdminOnly = false, Desc = "ARE YOU MANLY ENOUGH TO WEAR THIS BEARD?! (Requires TF2)", Key = "beard", ID = 62, Sell = 0, Requires = 0, Name = "Beard" },
	[63] = { Cost = 1500, Type = "other", AdminOnly = false, Desc = "Remember, smoking kills (zombies). (Requires TF2)", Key = "cigar", ID = 63, Sell = 0, Requires = 0, Name = "Cigar" },
	[64] = { Cost = 0, EventOnly = true,Type = "hat", AdminOnly = false, Desc = "Unlockable beanie! (Requires TF2)", Key = "wbeanie", ID = 64, Sell = 0, Requires = 0, Name = "Winter Beanie" },
	[65] = { Cost = 2000, Type = "hat", AdminOnly = false, Desc = "Now that is a proper hat for zombie apocalypse. (Requires TF2)", Key = "hellsing", ID = 65, Sell = 0, Requires = 0, Name = "Hellsing Hat" },
	[66] = { Cost = 1900, Type = "hat",Hidden = true, AdminOnly = false, Desc = "You're tought guy, huh?. (Requires TF2)", Key = "beanie", ID = 66, Sell = 0, Requires = 0, Name = "Beanie" },
	[67] = { Cost = 1900, Type = "hat", AdminOnly = false, Desc = "Just a normal hat. Nothing special... right?. (Requires TF2)", Key = "normalhat", ID = 67, Sell = 0, Requires = 0, Name = "Ordinary Hat" },
	[68] = { Cost = 2200, Type = "hat", AdminOnly = false, Desc = "At least everyone will know who you are. (Requires TF2)", Key = "medhelm", ID = 68, Sell = 0, Requires = 0, Name = "Medic's Helmet" },
	[69] = { Cost = 11000, Type = "suit", AdminOnly = false, Desc = "'You can run, but you can't hide!'. Suit bonus: Hides your heartbeat when standing still.", Key = "stalkersuit", ID = 69, Sell = 0, Requires = 0, Name = "Stalker Suit" },
	[70] = { Cost = 1900, Type = "hat", AdminOnly = false, Desc = "Classic cap for winter apocalypse. (Requires TF2)", Key = "wintercap", ID = 70, Sell = 0, Requires = 0, Name = "Winter Cap" },
	[71] = { Cost = 2300, Type = "hat", AdminOnly = false, Desc = "...and so stylish!. (Requires TF2)", Key = "socold", ID = 71, Sell = 0, Requires = 0, Name = "Im so cold..." },
	[72] = { Cost = 2000, Type = "other", AdminOnly = false, Desc = "Neither snow, neither zombies can stop you from wearing this. (Requires TF2)", Key = "winterhood", ID = 72, Sell = 0, Requires = 0, Name = "Winter Hood" },
	[73] = { Cost = 1900, Type = "hat", AdminOnly = false, Desc = "I love extreme stuff. (Requires TF2)", Key = "skihat", ID = 73, Sell = 0, Requires = 0, Name = "Ski Hat" },
	[74] = { Cost = 2000, Type = "hat", AdminOnly = false, Desc = "Pimp?. (Requires TF2)", Key = "hall", ID = 74, Sell = 0, Requires = 0, Name = "Hustler's Hallmark" },
	[75] = { Cost = 1200, Type = "other", AdminOnly = false, Desc = "Just a pair of cool glasses, I guess?. (Requires TF2)", Key = "copgl", ID = 75, Sell = 0, Requires = 0, Name = "Cop Glasses" },
	[76] = { Cost = 1600, Type = "other", AdminOnly = false, Desc = "Sometimes you just need a little more hair. (Requires TF2)", Key = "sidebrn", ID = 76, Sell = 0, Requires = 0, Name = "Sideburns" },
}

PureHats = {}

for i, tbl in pairs(shopData) do
	if tbl.Type == "hat" then
		PureHats[tbl.Key] = true
	end
end

hats = {
	["buckethat"] = {
		["1"] = { type = "Model", model = "models/props_junk/MetalBucket01a.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(6.15, 1.712, -0.144), angle = Angle(90, 0, 0), size = Vector(0.731, 0.731, 0.731), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["homburg"] = {
		["1"] = { type = "Model", model = "models/katharsmodels/hats/homburg/homburg.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(4.55, 0, 0), angle = Angle(-1.895, -82.101, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["tophat"] = {
		["1"] = { type = "Model", model = "models/tophat/tophat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(4.681, 0.731, 0), angle = Angle(-90, 0.856, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["piratehat"] = {
		["1"] = { type = "Model", model = "models/piratehat/piratehat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(5.093, 0, 0), angle = Angle(2.4, 105.175, 90), size = Vector(1.049, 1.049, 1.049), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["greenshat"] = {
		["1"] = { type = "Model", model = "models/greenshat/greenshat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(5.093, 0, 0), angle = Angle(2.4, 105.175, 90), size = Vector(1.049, 1.049, 1.049), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["santahat"] = {
		["1"] = { type = "Model", model = "models/cloud/kn_santahat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.457, 0, 0), angle = Angle(90, -90, 0), size = Vector(1.049, 1.049, 1.049), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["mask"] = {
		["1"] = { type = "Model", model = "models/Items/combine_rifle_ammo01.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(1.125, -0.838, 0), angle = Angle(90, 90, 0), size = Vector(0.805, 0.805, 0.805), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["ushat"] = {
		["1"] = { type = "Model", model = "models/props/cs_office/Snowman_hat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(5.031, -1.257, 0), angle = Angle(-90, 31.011, 0), size = Vector(0.824, 0.824, 0.824), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["roboteye"] = {
		["1"] = { type = "Model", model = "models/props/cs_office/projector.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(1.375, 2.469, 0), angle = Angle(-90, 8.869, 0), size = Vector(0.563, 0.563, 0.563), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["borghat"] = {
		["1"] = { type = "Model", model = "models/Manhack.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(7.198, -0.094, 0), angle = Angle(-127.388, 90, 90), size = Vector(1.019, 1.019, 1.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["pothat"] = {
		["1"] = { type = "Model", model = "models/props_interiors/pot02a.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(5.506, -5.282, 0), angle = Angle(-90, -170.381, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["sombrero"] = {
		["1"] = { type = "Model", model = "models/props_junk/sawblade001a.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(5.824, 0, 0), angle = Angle(90, 10.968, 0), size = Vector(0.606, 0.606, 0.606), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["melonhead"] = {
		["1"] = { type = "Model", model = "models/props_junk/watermelon01.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(3.049, 1.2, 0.305), angle = Angle(0, 0, 69.163), size = Vector(0.856, 0.856, 0.856), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["bunnyears"] = {
		["1"] = { type = "Model", model = "models/bunnyears/bunnyears.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(7.519, 0, 0), angle = Angle(-180, 108.094, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["monitor"] = {
		["1"] = { type = "Model", model = "models/props_lab/monitor02.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-3.164, 0.625, 0), angle = Angle(180, 90, 90), size = Vector(0.569, 0.569, 0.569), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["skull"] = {
		["1"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(3.674, 1.468, 0), angle = Angle(180, 77.625, 90), size = Vector(1.562, 1.562, 1.562), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2+"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(4.168, -2.162, 1.088), size = { x = 7.1, y = 7.1 }, color = Color(255, 255, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["2"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(3.956, 2.026, 1.088), size = { x = 7.1, y = 7.1 }, color = Color(255, 255, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
	},
	["crab"] = {
		["1"] = { type = "Model", model = "models/Nova/w_headcrab.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.537, 0.4, 0), angle = Angle(90, -90, 0), size = Vector(0.861, 0.861, 0.861), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["egg"] = {
		["1"] = { type = "Model", model = "models/props_phx/misc/egg.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-2.507, 4.212, 0), angle = Angle(-90, 18.35, 0), size = Vector(2.905, 2.905, 2.905), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["pumpkin"] = {
		["1"] = { type = "Model", model = "models/props_outland/pumpkin01.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(2.019, 0, 0), angle = Angle(0, 96.212, 90), size = Vector(0.912, 0.912, 0.912), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["snowhat"] = {
		["1"] = { type = "Model", model = "models/props/cs_office/snowman_face.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(2.525, 1.687, 0), angle = Angle(90, -180, 0), size = Vector(1.055, 1.055, 1.055), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["present"] = {
		["1"] = { type = "Model", model = "models/effects/bday_gib01.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(4.487, 0.725, 0), angle = Angle(-90, 7.086, 0), size = Vector(0.768, 0.768, 0.768), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["rpresent"] = {
		["1"] = { type = "Model", model = "models/effects/bday_gib02.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.801, 0, 0), angle = Angle(90, 180, 0), size = Vector(1.174, 0.744, 1.174), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["techeyes"] = {
		["1"] = { type = "Model", model = "models/props_combine/combine_light002a.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(4.282, 4.638, -2.914), angle = Angle(0, 105.625, 0), size = Vector(0.135, 0.172, 0.153), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["cleaver"] = {
		["1"] = { type = "Model", model = "models/props_lab/Cleaver.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(9.114, -5.792, -3.1), angle = Angle(-33.514, 82.587, 68.824), size = Vector(0.544, 0.544, 0.544), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["magnlamp"] = {
		["1"] = { type = "Model", model = "models/props_c17/light_magnifyinglamp02.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(3.736, 3.793, 0), angle = Angle(-49.095, -62.531, 0), size = Vector(0.18, 0.18, 0.18), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["scannerhelm"] = {
		["1"] = { type = "Model", model = "models/Gibs/Shield_Scanner_Gib3.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(6.599, -1.344, 0.675), angle = Angle(0, -93.638, -102.963), size = Vector(0.662, 0.662, 0.662), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["chef"] = {
		["1"] = { type = "Model", model = "models/chefHat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(4.311, -0.801, 0.126), angle = Angle(-180, -60.5, -89.213), size = Vector(1.169, 1.013, 0.843), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["combinehelm"] = {
		["1"] = { type = "Model", model = "models/Nova/w_headgear.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.037, 0.187, -0.013), angle = Angle(90, -80.687, 0), size = Vector(0.979, 0.979, 0.979), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["termeye"] = {
		["1"] = { type = "Model", model = "models/Gibs/manhack_gib03.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(4.206, 2.404, 1.812), angle = Angle(0, -76.82, 90), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(3.868, 0.388, 0.699), size = { x = 4.212, y = 4.212 }, color = Color(255, 255, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
	},
	["fez"] = {
		["1"] = { type = "Model", model = "models/props_junk/terracotta01.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(8.781, -1.196, -3.014), angle = Angle(-59.658, -180, -16.302), size = Vector(0.175, 0.175, 0.194), color = Color(188, 0, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["beard"] = {
		["1"] = { type = "Model", model = "models/player/items/demo/demo_beardpipe.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-1.32, 1.054, 0), angle = Angle(0, -74.849, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, particle = {"cig_burn","drg_pipe_smoke"}, particleatt = "cig_drg_smoke" }
	},
	["cigar"] = {
		["1"] = { type = "Model", model = "models/player/items/soldier/cigar.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.93, -0.127, -0.681), angle = Angle(0, -90, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, particle = {"drg_pipe_smoke"}, particleatt = "cig_drg_smoke" }
	},
	["wbeanie"] = {
		["1"] = { type = "Model", model = "models/player/items/pyro/pyro_beanie.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-73.206, 6.395, 0), angle = Angle(0, -80.63, -90), size = Vector(1.036, 1.036, 1.036), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["hellsing"] = {
		["1"] = { type = "Model", model = "models/player/items/sniper/hwn_sniper_hat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-71.588, 26.731, -6.08), angle = Angle(3.259, -73.843, -85.499), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["beanie"] = {
		["1"] = { type = "Model", model = "models/player/items/scout/beanie.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-82.501, 27.982, 0), angle = Angle(0, -71.333, -90), size = Vector(1.195, 1.195, 1.195), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["normalhat"] = {
		["1"] = { type = "Model", model = "models/player/items/all_class/hm_disguisehat_scout.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.018, 0.717, 0), angle = Angle(0, -70.433, -90), size = Vector(1.042, 1.042, 1.042), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["medhelm"] = {
		["1"] = { type = "Model", model = "models/player/items/medic/fwk_medic_stahlhelm.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(1.151, -1.522, 0), angle = Angle(0, -78.809, -90), size = Vector(1.085, 1.085, 1.085), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["wintercap"] ={
		["1"] = { type = "Model", model = "models/player/items/all_class/all_earwarmer_demo.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.325, 0.836, 0), angle = Angle(0.527, -69.86, -90), size = Vector(1.044, 1.044, 1.044), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["socold"] = {
		["1"] = { type = "Model", model = "models/player/items/pyro/winter_pyro_mask.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-11.351, 0.377, 0), angle = Angle(0, -69.926, -90), size = Vector(1.169, 1.169, 1.169), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["winterhood"] = {
		["1"] = { type = "Model", model = "models/player/items/sniper/winter_sniper_hood.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-11.25, 6.46, 0), angle = Angle(0, -78.959, -90), size = Vector(1.034, 1.034, 1.034), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["skihat"] = {
		["1"] = { type = "Model", model = "models/player/items/soldier/soldier_skihat_s1.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(3.828, 0.705, 0), angle = Angle(0, -82.066, -90), size = Vector(1.014, 1.014, 1.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["hall"] = {
		["1"] = { type = "Model", model = "models/player/items/demo/hallmark.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.393, 0, 0), angle = Angle(0, -75.812, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["copgl"] = {
		["1"] = { type = "Model", model = "models/player/items/heavy/cop_glasses.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-1.244, -0.419, 0), angle = Angle(0, -71.531, -90), size = Vector(1, 0.962, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["sidebrn"] = {
		["1"] = { type = "Model", model = "models/player/items/all_class/winter_sideburns_medic.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.239, 0.344, 0), angle = Angle(-90, -56.035, 0), size = Vector(1.044, 1.044, 1.044), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {} }
	},
}



hats_old = {
	["buckethat"] = { Model = "models/props_junk/MetalBucket01a.mdl", Pos = Vector(5.2,-2,0), Ang = Angle(0,20,90) },
	["homburg"] = { Model = "models/katharsmodels/hats/homburg/homburg.mdl", Pos = Vector(3,0,0), Ang = Angle(-90,0,-70) },
	["tophat"] = { Model = "models/tophat/tophat.mdl", Pos = Vector(4.1,0.5,0), Ang = Angle(90,0,-75) },
	["piratehat"] = { Model = "models/piratehat/piratehat.mdl", Pos = Vector(4.1,0.5,0), Ang = Angle(90,0,-105) },
	["greenshat"] = { Model = "models/greenshat/greenshat.mdl", Pos = Vector(4.1,0.5,0), Ang = Angle(90,0,-105) },
	["santahat"] = { Model = "models/cloud/kn_santahat.mdl", Pos = Vector(0.5,-0.4,0), Ang = Angle(0,270,90), CombPos = Vector(0.5,-0.4,0) },
	["mask"] = { Model = "models/Items/combine_rifle_ammo01.mdl", Pos = Vector(0,1,0), Ang = Angle(-90,0,170) },
	["ushat"] = { Model = "models/props/cs_office/Snowman_hat.mdl", Pos = Vector(3.5,-2.3,0), Ang = Angle(0,50,-90), CombPos = Vector(3.8,-2.2,0), CSSPos = Vector(6.2,-2,0) },
	["roboteye"] = { Model = "models/props/cs_office/projector.mdl", Pos = Vector(0,0.5,0.5), Ang = Angle(0,0,-90), CombPos = Vector(0,0.5,0.5), CSSPos = Vector(1,0.5,0.5)  },
	["borghat"] = { Model = "models/Manhack.mdl", Pos = Vector(7,-1.8,0), Ang = Angle(-90,0,-70), CombPos = Vector(7.5,-1.8,0), CSSPos = Vector(8.2,-1.8,0) },
	["pothat"] = { Model = "models/props_interiors/pot02a.mdl", Pos = Vector(5.8,0.5,-5.2), Ang = Angle(90,0,80), CombPos = Vector(7.7,-1.2,-5.2), CSSPos = Vector(9,0.3,-5.2) },
	["sombrero"] = { Model = "models/props_junk/sawblade001a.mdl", Pos = Vector(4.6,0.5,0), Ang = Angle(-90,0,-75) },
	["melonhead"] = { Model = "models/props_junk/watermelon01.mdl", Pos = Vector(4.1,0.5,0), Ang = Angle(0,0,0), CombPos = Vector(4.1,0.5,0), CSSPos = Vector(4.1,0.5,0) },
	["bunnyears"] = { Model = "models/bunnyears/bunnyears.mdl", Pos = Vector(6.4,0.5,0), Ang = Angle(-90,0,-105) },
	["monitor"] = { Model = "models/props_lab/monitor02.mdl", Pos = Vector(-3.5,0.5,0.8), Ang = Angle(90,180,90), CombPos = Vector(-3.5,0.5,0.8), CSSPos = Vector(-3.5,0.5,0.8), ScaleVector = Vector (0.7,0.7,0.7)  },
	["skull"] = { Model = "models/Gibs/HGIBS.mdl", Pos = Vector(2.5,0,0), Ang = Angle(90,180,90), CombPos = Vector(3,0,0), CSSPos = Vector(3,0,0),ScaleVector = Vector (1.8,1.8,1.8) },	
	["crab"] = { Model = "models/Nova/w_headcrab.mdl", Pos = Vector(-2.5,0,0), Ang = Angle(0,-90,90), CombPos = Vector(-2,0,0), CSSPos = Vector(0.2,0,0),ScaleVector = Vector (1.1,1.1,1.1) },	
	["egg"] = { Model = "models/props_phx/misc/egg.mdl", Pos = Vector(-3,1.5,0), Ang = Angle(0,-180,90), CombPos = Vector(-3,1.2,0), CSSPos = Vector(-3,1.1,0),ScaleVector = Vector (0.5,0.5,0.5) },	
	["pumpkin"] = { Model = "models/props_outland/pumpkin01.mdl", Pos = Vector(4.1,0.5,0), Ang = Angle(0,-180,90), CombPos = Vector(4.1,0.5,0), CSSPos = Vector(4.1,0.5,0) },	
	["snowhat"] = { Model = "models/props/cs_office/snowman_face.mdl", Pos = Vector(4.1,0.5,0), Ang = Angle(0,-180,90), CombPos = Vector(4.1,0.5,0), CSSPos = Vector(4.1,0.5,0), ScaleVector = Vector (1.3,1.3,1.3) },					
	["present"] = { Model = "models/effects/bday_gib01.mdl", Pos = Vector(4.1,0.5,0), Ang = Angle(0,-180,90), CombPos = Vector(4.1,0.5,0), CSSPos = Vector(4.1,0.5,0) },
	["rpresent"] = { Model = "models/effects/bday_gib02.mdl", Pos = Vector(-2,0.5,0), Ang = Angle(0,-180,90), CombPos = Vector(-2,0.5,0), CSSPos = Vector(-2,0.5,0), ScaleVector = Vector (1.5,1.5,1.5)  },	
	["techeyes"] = { Model = "models/props_combine/combine_light002a.mdl", Pos = Vector(3.18, 4.012, -3.462), Ang = Angle(0, 90, 0), ScaleVector = Vector(0.174, 0.231, 0.174), SCK = true},
	["cleaver"] = { Model = "models/props_lab/Cleaver.mdl", Pos = Vector(10.187, -3.306, 3.98), Ang = Angle(123.305, -156.868, -3.119), ScaleVector = Vector(0.5, 0.5, 0.5), SCK = true},
	["magnlamp"] = { Model = "models/props_c17/light_magnifyinglamp02.mdl", Pos = Vector(2.911, 4.23, 0.238), Ang = Angle(-59.276, -53.07, -0.489), ScaleVector = Vector(0.194, 0.194, 0.194), SCK = true},
	["scannerhelm"] = { Model = "models/Gibs/Shield_Scanner_Gib3.mdl", Pos = Vector(5.711, 0.667, 1.105), Ang = Angle(173.292-90, 62.006+90, 87.013+33), ScaleVector = Vector(0.688, 0.688, 0.688), SCK = true},
}

suits = {
	["greenssuit"] = {
		["1"] = { type = "Model", model = "models/weapons/w_sledgehammer.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(13.043, 2.974, -7.763), angle = Angle(51.706, -14.294, 16.419), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["medicsuit"] = {
		["1"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(-7.432, -1.969, -2.287), angle = Angle(-3.362, 180, -85.087), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["3"] = { type = "Model", model = "models/weapons/w_eq_eholster_elite.mdl", bone = "ValveBiped.Bip01_L_Thigh", rel = "", pos = Vector(11.281, -1.507, 2.78), angle = Angle(18.736, -92.639, 94.268), size = Vector(0.718, 0.718, 0.718), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/items/healthkit.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(6.775, 3.068, 2.299), angle = Angle(2.375, 171.6, -74.189), size = Vector(0.688, 0.688, 0.688), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["5"] = { type = "Model", model = "models/weapons/w_rif_sg552.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-3.22, 2.112, -6.369), angle = Angle(-1.589, -3.97, 26.544), size = Vector(0.593, 0.593, 0.593), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["4"] = { type = "Model", model = "models/weapons/w_defuser.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(0.723, 1.593, -6.757), angle = Angle(98.436, -92.312, 0.13), size = Vector(0.763, 0.763, 0.763), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["meleesuit"] = {
		["1"] = { type = "Model", model = "models/weapons/w_crowbar.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(0.418, 3.405, 1.769), angle = Angle(150.555, -0.988, -39.144), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["3"] = { type = "Model", model = "models/weapons/w_knife_ct.mdl", bone = "ValveBiped.Bip01_L_Thigh", rel = "", pos = Vector(5.935, 3.595, 1.768), angle = Angle(157.486, -126.381, -75.176), size = Vector(0.705, 0.705, 0.705), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/weapons/w_axe.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-2.632, 3.693, -3.856), angle = Angle(53.894, -180, 0), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["5"] = { type = "Model", model = "models/Items/grenadeAmmo.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "4", pos = Vector(3.437, 6.061, 0), angle = Angle(0.405, 0, 0), size = Vector(0.563, 0.563, 0.563), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["4"] = { type = "Model", model = "models/weapons/w_defuser.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(-5.08, -1.201, -5.888), angle = Angle(48.2, -6.587, -84.014), size = Vector(0.669, 0.669, 0.669), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["5+"] = { type = "Model", model = "models/Items/grenadeAmmo.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "4", pos = Vector(5.537, 6.567, 0), angle = Angle(0.405, 0, 0), size = Vector(0.563, 0.563, 0.563), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["techsuit"] = {
		["1"] = { type = "Model", model = "models/combine_turrets/floor_turret.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-24.925, -0.625, -4.42), angle = Angle(-97.112, 176.037, -173.445), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/Combine_Turrets/Floor_turret/floor_turret_citizen4", skin = 0, bodygroup = {} },
		["3"] = { type = "Model", model = "models/Weapons/w_annabelle.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(4.756, 3.042, 3.18), angle = Angle(7.794, 179.805, -171.65), size = Vector(0.794, 0.794, 0.794), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/weapons/w_pistol.mdl", bone = "ValveBiped.Bip01_L_Thigh", rel = "", pos = Vector(9.519, 2.732, 3.036), angle = Angle(1.743, 180, -103.357), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["5"] = { type = "Model", model = "models/props_combine/combine_light002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "4", pos = Vector(2.47, 0.025, 3.65), angle = Angle(0, -180, 0), size = Vector(0.059, 0.109, 0.109), color = Color(155, 155, 155, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["4"] = { type = "Model", model = "models/props_combine/combine_teleportplatform.mdl", bone = "ValveBiped.Bip01_R_Forearm", rel = "", pos = Vector(1.238, 0.194, 0.018), angle = Angle(-90.595, 0, 0), size = Vector(0.05, 0.05, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["supportsuit"] = {
		["1"] = { type = "Model", model = "models/props_debris/wood_board06a.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-0.47, 3.956, 3.206), angle = Angle(-169.258, -88.006, -90.407), size = Vector(0.4, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["3"] = { type = "Model", model = "models/Weapons/w_shotgun.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-3.5, 3.312, -4.514), angle = Angle(-4.051, 4.175, 11.831), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/items/boxsrounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(-1.619, 3.493, 0), angle = Angle(0, 0, -88.551), size = Vector(0.481, 0.768, 0.723), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["5"] = { type = "Model", model = "models/items/crossbowrounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "2", pos = Vector(0.361, 7.593, 3.305), angle = Angle(-85.857, 14.081, -27.32), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["4"] = { type = "Model", model = "models/weapons/w_hammer.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(-7.551, -0.163, -1.089), angle = Angle(-78.883, 3.611, 98.086), size = Vector(0.669, 0.669, 0.669), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["assaultsuit"] = {
		["1"] = { type = "Model", model = "models/weapons/w_rif_ak47.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-5.462, 1.725, 4.068), angle = Angle(-2.406, -8.273, 164.861), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["6+"] = { type = "Model", model = "models/Weapons/Shotgun_shell.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "3", pos = Vector(2.657, 6.25, 0.03), angle = Angle(-93.906, 10.026, 0), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["3"] = { type = "Model", model = "models/weapons/w_defuser.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(-6.613, 1.618, -3.718), angle = Angle(22.743, -0.019, -92.306), size = Vector(0.656, 0.656, 0.656), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/weapons/w_pist_deagle.mdl", bone = "ValveBiped.Bip01_L_Thigh", rel = "", pos = Vector(6.625, -1.576, 2.086), angle = Angle(3.819, -0.094, 84.574), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["5"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "4", pos = Vector(4.418, 3.562, 0.88), size = { x = 6.493, y = 6.493 }, color = Color(255, 255, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["4"] = { type = "Model", model = "models/Weapons/w_package.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(4.487, -2.833, 7.948), angle = Angle(-3.175, -6.601, -29.331), size = Vector(0.75, 0.75, 0.75), color = Color(115, 115, 115, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["6++"] = { type = "Model", model = "models/Weapons/Shotgun_shell.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "3", pos = Vector(3.763, 6.432, 0.03), angle = Angle(-93.906, 10.026, 0), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["6"] = { type = "Model", model = "models/Weapons/Shotgun_shell.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "3", pos = Vector(1.544, 5.943, 0.03), angle = Angle(-93.906, 10.026, 0), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["stalkersuit"] = {
		["4"] = { type = "Model", model = "models/weapons/w_eq_eholster_elite.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(7.691, 2.102, 1.12), angle = Angle(78.029, 95.286, -180), size = Vector(0.874, 0.874, 0.874), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["3+"] = { type = "Model", model = "models/weapons/w_defuser.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(-5.52, 0.703, -4.053), angle = Angle(22.438, 7.679, -92.752), size = Vector(0.839, 0.839, 0.839), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["5"] = { type = "Model", model = "models/props_junk/GlassBottle01a.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(-5.665, -0.12, 2.918), angle = Angle(2.697, 0.115, -90.807), size = Vector(0.742, 0.742, 0.742), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/props_combine/suit_charger001.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-2.362, 1.274, -1.663), angle = Angle(-11.079, -90.47, -94.134), size = Vector(0.54, 0.54, 0.54), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["3"] = { type = "Model", model = "models/weapons/w_defuser.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(4.645, 0.118, -5.936), angle = Angle(117.144, 7.679, -92.752), size = Vector(0.839, 0.839, 0.839), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/Weapons/W_crossbow.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-2.425, 2.528, 1.911), angle = Angle(-1.489, -1.742, 79.861), size = Vector(0.689, 0.689, 0.689), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
}

suits_old = {
	["testsuit"] = {
		{ model = "models/props_combine/combine_light002a.mdl", scale = Vector(0.5,0.5,0.5), bone = "ValveBiped.Bip01_Spine2", pos = Vector(-8.4397354125977, -4.2856278419495, -4.8038859367371), ang = Angle(-20.218063354492, 89.163124084473, 92.542297363281) },
		{ model = "models/props_combine/tprotato2.mdl", scale = Vector(0.15,0.15,0.15), bone = "ValveBiped.Bip01_Spine2", pos = Vector(2.9495055675507, 11.850051879883, 0.18194548785686), ang = Angle(1.8538411855698, 73.883186340332, -92.593276977539) },
		{ model = "models/props_combine/combine_intwallunit.mdl", scale = Vector(0.25,0.25,0.25), bone = "ValveBiped.Bip01_Spine2", pos = Vector(7.4525828361511, -5.0034132003784, 0.57272636890411), ang = Angle(-3.9635679721832, -86.458190917969, 176.28259277344) },
		{ model = "models/weapons/w_alyx_gun.mdl", scale = Vector(1,1,1), bone = "ValveBiped.Bip01_R_UpperArm", pos = Vector(5.7516212463379, -1.9248474836349, -4.1494512557983), ang = Angle(-5.7085776329041, -170.07400512695, -165.52563476563) },
		{ model = "models/gibs/manhack_gib02.mdl", scale = Vector(0.8,0.8,0.8), bone = "ValveBiped.Bip01_Head1", pos = Vector(2.4370293617249, -2.6262662410736, -3.7462885379791), ang = Angle(-2.652161359787, -73.73762512207, 90.886138916016) }
	},
	["greenssuit"] = {
		--{ model = "models/greenshat/greenshat.mdl", scale = Vector(1, 1, 1), bone = "ValveBiped.Bip01_Head1", pos = Vector(4.7985687255859, -0.3487548828125, -0.0367431640625), ang = Angle(-1.5857821702957, 99.832473754883, 88.898849487305) },
		{ model = "models/weapons/w_sledgehammer.mdl", scale = Vector(0.8, 0.8, 0.8), bone = "ValveBiped.Bip01_Spine2", pos = Vector(16.047988891602, -2.2593566894531, -7.4102783203125), ang = Angle(55.588428497314, 179.62707519531, -7.3176641464233) },
		{ model = "models/gibs/shield_scanner_gib4.mdl", scale = Vector(0.5, 0.5, 0.5), bone = "ValveBiped.Bip01_R_Forearm", pos = Vector(10.531005859375, -0.38937377929688, -3.1612548828125), ang = Angle(-45.036098480225, -0.81545609235764, 7.7072429656982) }
	},
	["medicsuit"] = {
		{ model = "models/healthvial.mdl", scale = Vector(0.75, 0.75, 0.75), bone = "ValveBiped.Bip01_Pelvis", pos = Vector(-9.3896636962891, -5.8730239868164, -0.4644775390625), ang = Angle(-5.9380683898926, 177.3962097168, 87.504753112793) },
		{ model = "models/items/healthkit.mdl", scale = Vector(0.75, 0.75, 0.75), bone = "ValveBiped.Bip01_Spine2", pos = Vector(7.3329620361328, -3.7342529296875, -1.1940460205078), ang = Angle(-17.783504486084, -174.82952880859, -88.17741394043) },
		{ model = "models/weapons/w_eq_eholster_elite.mdl", scale = Vector(0.6, 0.6, 0.6), bone = "ValveBiped.Bip01_L_Thigh", pos = Vector(13.132080078125, -0.203125, 3.4675827026367), ang = Angle(8.3461780548096, -95.820625305176, 85.483924865723) },
		{ model = "models/weapons/w_defuser.mdl", scale = Vector(0.7, 0.7, 0.7), bone = "ValveBiped.Bip01_Pelvis", pos = Vector(7.1811981201172, -1.722526550293, -3.1448974609375), ang = Angle(-26.365127563477, 179.97027587891, 96.087631225586) },
	},
	["meleesuit"] = {
		{ model = "models/weapons/w_crowbar.mdl", scale = Vector(1, 1, 1), bone = "ValveBiped.Bip01_Spine2", pos = Vector(6.231819152832, -3.5177612304688, -1.8016738891602), ang = Angle(43.045528411865, 5.8933568000793, 145.62739562988) },
		{ model = "models/weapons/w_knife_ct.mdl", scale = Vector(0.75, 0.75, 0.75), bone = "ValveBiped.Bip01_L_Thigh", pos = Vector(7.3256301879883, -1.5550537109375, 3.533088684082), ang = Angle(3.7624142169952, 49.689037322998, 89.807983398438) },
		{ model = "models/weapons/w_defuser.mdl", scale = Vector(0.7, 0.7, 0.7), bone = "ValveBiped.Bip01_Pelvis", pos = Vector(-5.5647258758545, 0.091384887695313, -4.556396484375), ang = Angle(-44.3967628479, 5.108145236969, -95.67423248291) },
		{ model = "models/weapons/w_axe.mdl", scale = Vector(1, 1, 1), bone = "ValveBiped.Bip01_Spine2", pos = Vector(-4.7819671630859, -4.3813323974609, -5.0008544921875), ang = Angle(-59.132465362549, -175.11282348633, -1.0494492053986), mat = "" },
	},
	["techsuit"] = {
		{ model = "models/combine_turrets/floor_turret.mdl", scale = Vector(0.65, 0.65, 0.65), bone = "ValveBiped.Bip01_Spine2", pos = Vector(-16.249351501465, -8.5250854492188, 10.013265609741), ang = Angle(-52.792457580566, 9.0308504104614, -177.92620849609) },
		{ model = "models/weapons/w_pistol.mdl", scale = Vector(0.8, 0.8, 0.8), bone = "ValveBiped.Bip01_L_Thigh", pos = Vector(12.181709289551, -0.4613037109375, 3.9242324829102), ang = Angle(-4.9796981811523, 176.87321472168, -81.989204406738) },
		{ model = "models/props_c17/tools_wrench01a.mdl", scale = Vector(0.75, 0.75, 0.75), bone = "ValveBiped.Bip01_Pelvis", pos = Vector(-8.8688278198242, -3.1391754150391, -1.1537475585938), ang = Angle(-46.818305969238, 87.676483154297, 87.161766052246), mat = "models/props_c17/metalladder001" },
		{ model = "models/props_c17/tools_pliers01a.mdl", scale = Vector(1, 1, 1), bone = "ValveBiped.Bip01_Pelvis", pos = Vector(-10.238813400269, -4.3920974731445, 1.4630126953125), ang = Angle(-60.661434173584, -133.55381774902, -62.927299499512) },
		{ model = "models/gibs/shield_scanner_gib1.mdl", scale = Vector(0.75, 0.75, 0.75), bone = "ValveBiped.Bip01_R_Forearm", pos = Vector(6.7405700683594, -0.96442413330078, -1.2118835449219), ang = Angle(1.7456701993942, 60.498374938965, 165.4289855957), mat = "" },
	},
	["supportsuit"] = {
		{ model = "models/items/boxsrounds.mdl", scale = Vector(1, 1, 1), bone = "ValveBiped.Bip01_Spine2", pos = Vector(-7.9963302612305, -6.3760375976563, -2.2481060028076), ang = Angle(-1.7087403535843, -89.774269104004, -64.968193054199) },
		{ model = "models/weapons/w_hammer.mdl", scale = Vector(0.75, 0.75, 0.75), bone = "ValveBiped.Bip01_Pelvis", pos = Vector(-8.1949787139893, 1.0550079345703, -2.9791870117188), ang = Angle(46.68924331665, -90.599281311035, 3.1780381202698) },
		{ model = "models/props_debris/wood_board06a.mdl", scale = Vector(0.5, 0.5, 0.5), bone = "ValveBiped.Bip01_Spine2", pos = Vector(2.9047775268555, -3.678466796875, 0.20827960968018), ang = Angle(3.8104009628296, -86.105697631836, 129.0941619873) },
		{ model = "models/items/crossbowrounds.mdl", scale = Vector(0.65, 0.65, 0.65), bone = "ValveBiped.Bip01_Pelvis", pos = Vector(8.206693649292, -3.7448501586914, -0.17242431640625), ang = Angle(23.519021987915, -81.454879760742, 61.945243835449) },
	},
	["assaultsuit"] = {
		{ model = "models/weapons/w_rif_ak47.mdl", scale = Vector(1, 1, 1), bone = "ValveBiped.Bip01_Spine2", pos = Vector(5.8207550048828, -3.7877807617188, -5.5291147232056), ang = Angle(-39.557312011719, -176.11592102051, 1.1124407052994) },
		{ model = "models/items/grenadeammo.mdl", scale = Vector(0.8, 0.8, 0.8), bone = "ValveBiped.Bip01_Pelvis", pos = Vector(-9.5070037841797, -3.4014358520508, -1.3558349609375), ang = Angle(7.0540013313293, 9.3924551010132, -54.073848724365) },
		{ model = "models/gibs/scanner_gib02.mdl", scale = Vector(0.75, 0.75, 0.75), bone = "ValveBiped.Bip01_L_UpperArm", pos = Vector(1.9710693359375, -0.96748352050781, 0.96389770507813), ang = Angle(-36.684658050537, -34.976982116699, 93.18497467041), mat = "models/props_combine/metal_combinebridge001" },
		{ model = "models/gibs/scanner_gib02.mdl", scale = Vector(0.75, 0.75, 0.75), bone = "ValveBiped.Bip01_R_UpperArm", pos = Vector(2.266845703125, -0.34785461425781, -1.2991333007813), ang = Angle(46.084629058838, -15.180951118469, -150.51264953613), mat = "models/props_combine/metal_combinebridge001" },
		{ model = "models/weapons/w_pist_deagle.mdl", scale = Vector(0.9, 0.9, 0.9), bone = "ValveBiped.Bip01_Pelvis", pos = Vector(6.8150939941406, -0.15524291992188, -3.9432439804077), ang = Angle(-22.379274368286, -80.852088928223, -13.983214378357), mat = "" },
	},
}


--[=[-------------------------------
		Voice sets and/or sound tables
---------------------------------]=]

-- Male pain / death sounds
VoiceSets = {}

VoiceSets["male"] = {}
VoiceSets["male"].PainSoundsLight = {
Sound("vo/npc/male01/ow01.wav"),
Sound("vo/npc/male01/ow02.wav"),
Sound("vo/npc/male01/pain01.wav"),
Sound("vo/npc/male01/pain02.wav"),
Sound("vo/npc/male01/pain03.wav")
}

VoiceSets["male"].PainSoundsMed = {
Sound("vo/npc/male01/pain04.wav"),
Sound("vo/npc/male01/pain05.wav"),
Sound("vo/npc/male01/pain06.wav")
}

VoiceSets["male"].PainSoundsHeavy = {
Sound("vo/npc/male01/pain07.wav"),
Sound("vo/npc/male01/pain08.wav"),
Sound("vo/npc/male01/pain09.wav")
}

VoiceSets["male"].DeathSounds = {
Sound("vo/npc/male01/no02.wav"),
Sound("vo/npc/Barney/ba_ohshit03.wav"),
Sound("vo/npc/Barney/ba_ohshit03.wav"),
Sound("vo/npc/Barney/ba_no01.wav"),
Sound("vo/npc/Barney/ba_no02.wav")
}

VoiceSets["male"].Frightened = {
Sound ( "vo/npc/male01/help01.wav" ),
Sound ( "vo/streetwar/sniper/male01/c17_09_help01.wav" ),
Sound ( "vo/streetwar/sniper/male01/c17_09_help02.wav" ),
Sound ( "ambient/voices/m_scream1.wav" ),
Sound ( "vo/k_lab/kl_ahhhh.wav" ),
Sound ( "vo/npc/male01/startle01.wav" ),
Sound ( "vo/npc/male01/startle02.wav" ),
}

-- Trigger sounds for chat. If someone says "zombie" in chat, it'll emit the corresponding sound
VoiceSets["male"].ChatSounds = {
	["burp"] = { Sound("mrgreen/burp.wav") },
	["leeroo"] = { Sound("mrgreen/leeroy.mp3") },
	["over 9000"] = { Sound("mrgreen/9000.wav") },
	["damnit"] = { Sound("mrgreen/goddamnit2.wav") },
	["this is sparta"] = { Sound("mrgreen/sparta.wav") },
	["open the door"] = { Sound("mrgreen/opendoor2.wav"), Sound("mrgreen/opendoor3.wav") },
	["ok"] = { Sound("vo/npc/male01/ok01.wav"), Sound("vo/npc/male01/ok02.wav") },
	["hack"] = { Sound("vo/npc/male01/hacks01.wav"), Sound("vo/npc/male01/hacks02.wav") },
	["headcrab"] = { Sound("vo/npc/male01/headcrabs01.wav"), Sound("vo/npc/male01/headcrabs02.wav") },
	["run"] = { Sound("vo/npc/male01/runforyourlife01.wav"), Sound("vo/npc/male01/runforyourlife02.wav") },
	["s go"] = { Sound("vo/npc/male01/letsgo01.wav"), Sound("vo/npc/male01/letsgo02.wav") },
	["help"] = { Sound("vo/npc/male01/help01.wav") },
	["nice"] = { Sound("vo/npc/male01/nice.wav") },
	["incoming"] = { Sound("vo/npc/male01/incoming02.wav") },
	["watch out"] = { Sound("vo/npc/male01/watchout.wav") },
	["get down"] = { Sound("vo/npc/male01/getdown02.wav") },
	["oh shi"] = { Sound("vo/npc/male01/uhoh.wav"), Sound("vo/npc/male01/ohno.wav") },
	["zombie"] = { Sound("vo/npc/male01/zombies01.wav"), Sound("vo/npc/male01/zombies02.wav") },
	["freeman"] = { Sound("vo/npc/male01/gordead_ques03a.wav"), Sound("vo/npc/male01/gordead_ques03b.wav") },
	["get out"] = { Sound("vo/npc/male01/gethellout.wav") },
	["pills"] = { Sound("mrgreen/pills/SpotPills01male.wav"), Sound("mrgreen/pills/SpotPills02male.wav"),Sound("mrgreen/pills/SpotPills03male.wav")  },
}

-- Random things they'll say now and then
VoiceSets["male"].QuestionSounds = {
Sound("vo/npc/male01/question04.wav"),
Sound("vo/npc/male01/question06.wav"),
Sound("vo/npc/male01/question02.wav"),
Sound("vo/npc/male01/question09.wav"),
Sound("vo/npc/male01/question11.wav"),
Sound("vo/npc/male01/question12.wav"),
Sound("vo/npc/male01/question17.wav"),
Sound("vo/npc/male01/question19.wav"),
Sound("vo/npc/male01/question20.wav"),
Sound("vo/npc/male01/question22.wav"),
Sound("vo/npc/male01/question26.wav"),
Sound("vo/npc/male01/question28.wav"),
Sound("vo/npc/male01/question29.wav"),
Sound("vo/npc/male01/question07.wav"),
Sound("vo/npc/male01/question01.wav"),
Sound("vo/npc/male01/question03.wav"),
Sound("vo/npc/male01/question05.wav"),
Sound("vo/npc/male01/question13.wav"),
Sound("vo/npc/male01/question07.wav"),
Sound("vo/npc/male01/question14.wav"),
Sound("vo/npc/male01/question18.wav"),
Sound("vo/npc/male01/question21.wav"),
Sound("vo/npc/male01/question25.wav"),
Sound("vo/npc/male01/question27.wav"),
Sound("vo/trainyard/cit_pacing.wav"),
Sound("vo/npc/male01/question30.wav")
}

VoiceSetsGhost = {}

VoiceSetsGhost.PainSounds = {
Sound("npc/barnacle/barnacle_pull1.wav"),
Sound("npc/barnacle/barnacle_pull2.wav"),
Sound("npc/barnacle/barnacle_pull3.wav"),
Sound("npc/barnacle/barnacle_pull4.wav")
}

VoiceSets["male"].AnswerSounds = {
Sound("vo/npc/male01/vanswer08.wav"),
Sound("vo/npc/male01/vanswer09.wav"),
Sound("vo/npc/male01/answer05.wav"),
Sound("vo/npc/male01/answer07.wav"),
Sound("vo/npc/male01/answer09.wav"),
Sound("vo/npc/male01/answer11.wav"),
Sound("vo/npc/male01/answer14.wav"),
Sound("vo/npc/male01/answer17.wav"),
Sound("vo/npc/male01/answer18.wav"),
Sound("vo/npc/male01/answer22.wav"),
Sound("vo/npc/male01/answer24.wav"),
Sound("vo/npc/male01/answer29.wav"),
Sound("vo/npc/male01/answer30.wav"),
Sound("vo/npc/male01/answer01.wav"),
Sound("vo/npc/male01/answer02.wav"),
Sound("vo/npc/male01/answer08.wav"),
Sound("vo/npc/male01/answer10.wav"),
Sound("vo/npc/male01/answer12.wav"),
Sound("vo/npc/male01/answer13.wav"),
Sound("vo/npc/male01/answer16.wav"),
Sound("vo/npc/male01/answer19.wav"),
Sound("vo/npc/male01/answer20.wav"),
Sound("vo/npc/male01/answer21.wav"),
Sound("vo/npc/male01/answer26.wav"),
Sound("vo/npc/male01/answer27.wav"),
Sound("vo/npc/male01/busy02wav")
}

VoiceSets["male"].PushSounds = {
Sound("vo/npc/male01/excuseme01.wav"),
Sound("vo/npc/male01/excuseme02.wav"),
Sound("vo/npc/male01/sorry01.wav"),
Sound("vo/npc/male01/sorry02.wav"),
Sound("vo/npc/male01/sorry03.wav"),
Sound("vo/npc/male01/pardonme01.wav"),
Sound("vo/npc/male01/pardonme02.wav")
}

VoiceSets["male"].KillCheer = {
Sound("vo/npc/male01/evenodds.wav"),
Sound("vo/npc/male01/gotone01.wav"),
Sound("vo/npc/male01/gotone02.wav")
}

VoiceSets["male"].ReloadSounds = {
Sound("vo/npc/male01/coverwhilereload01.wav"),
Sound("vo/npc/male01/coverwhilereload02.wav"),
Sound("vo/npc/male01/gottareload01.wav"),
}

VoiceSets["male"].SupplySounds = {
Sound("vo/npc/male01/ammo04.wav"),
Sound("vo/npc/male01/ammo05.wav"),
Sound("vo/npc/male01/oneforme.wav"),
Sound("vo/npc/male01/yeah02.wav"),
}

VoiceSets["male"].WaveSounds = {
Sound("vo/npc/male01/headsup02.wav"),
Sound("vo/npc/male01/incoming02.wav"),
Sound("vo/npc/male01/watchout.wav"),
Sound("vo/npc/male01/zombies01.wav"),
Sound("vo/npc/male01/zombies02.wav"),
}

VoiceSets["male"].HealSounds = {
Sound("vo/npc/male01/health01.wav"),
Sound("vo/npc/male01/health02.wav"),
Sound("vo/npc/male01/health03.wav"),
Sound("vo/npc/male01/health04.wav"),
Sound("vo/npc/male01/health05.wav"),
}

-- WARNING!
-- Here goes insane precaching code
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
for _, set in pairs(VoiceSets["male"]) do
	for k, snd in pairs(set) do
		--Check if its another table
		if type( snd ) == "table" then
			for j, sndnew in pairs(snd) do
				--print("Precached "..tostring(sndnew))
				util.PrecacheSound( sndnew )
			end
		else
		--print("Precached "..tostring(snd))
		util.PrecacheSound( snd )
		end
	end
end

for _, tbl in pairs(VoiceSetsGhost) do
	for k, snd in pairs(tbl) do
		--print("Precached "..tostring(snd))
		util.PrecacheSound( snd )
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- /

-- Female pain / death sounds
VoiceSets["female"] = {}
VoiceSets["female"].PainSoundsLight = {
Sound("vo/npc/female01/pain01.wav"),
Sound("vo/npc/female01/pain02.wav"),
Sound("vo/npc/female01/pain03.wav")
}

VoiceSets["female"].PainSoundsMed = {
Sound("vo/npc/female01/pain04.wav"),
Sound("vo/npc/female01/pain05.wav"),
Sound("vo/npc/female01/pain06.wav")
}

VoiceSets["female"].PainSoundsHeavy = {
Sound("vo/npc/female01/pain07.wav"),
Sound("vo/npc/female01/pain08.wav"),
Sound("vo/npc/female01/pain09.wav")
}

VoiceSets["female"].DeathSounds = {
Sound("vo/npc/female01/no01.wav"),
Sound("vo/npc/female01/ow01.wav"),
Sound("vo/npc/female01/ow02.wav")
}

VoiceSets["female"].Frightened = {
Sound ( "vo/canals/arrest_helpme.wav" ),
Sound ( "vo/npc/female01/help01.wav" ),
Sound ( "ambient/voices/f_scream1.wav" ),
}

VoiceSets["female"].ChatSounds = {
	["burp"] = { Sound("mrgreen/burp.wav") },
	["ok"] = { Sound("vo/npc/female01/ok01.wav"), Sound("vo/npc/female01/ok02.wav") },
	["hack"] = { Sound("vo/npc/female01/hacks01.wav"), Sound("vo/npc/female01/hacks02.wav") },
	["headcrab"] = { Sound("vo/npc/female01/headcrabs01.wav"), Sound("vo/npc/female01/headcrabs02.wav") },
	["incoming"] = { Sound("vo/npc/female01/incoming02.wav") },
	["help"] = { Sound("vo/npc/female01/help01.wav") },
	["s go"] = { Sound("vo/npc/female01/letsgo01.wav"), Sound("vo/npc/female01/letsgo02.wav") },
	["run"] = { Sound("vo/npc/female01/runforyourlife01.wav"), Sound("vo/npc/female01/runforyourlife02.wav") },
	["watch out"] = { Sound("vo/npc/female01/watchout.wav"), Sound("vo/npc/female01/headsup01.wav") },
	["nice"] = { Sound("vo/npc/female01/nice01.wav"), Sound("vo/npc/female01/nice02.wav") },
	["get down"] = { Sound("vo/npc/female01/getdown02.wav") },
	["oh shi"] = { Sound("vo/npc/female01/uhoh.wav"), Sound("vo/npc/female01/ohno.wav") },
	["zombie"] = { Sound("vo/npc/female01/zombies01.wav"), Sound("vo/npc/female01/zombies02.wav") },
	["get out"] = { Sound("vo/npc/female01/gethellout.wav") },
	["pills"] = { Sound("mrgreen/pills/SpotPills01female.wav"), Sound("mrgreen/pills/SpotPills02female.wav")  },
}

VoiceSets["female"].ReloadSounds = {
Sound("vo/npc/female01/coverwhilereload01.wav"),
Sound("vo/npc/female01/coverwhilereload02.wav"),
Sound("vo/npc/female01/gottareload01.wav"),
}

VoiceSets["female"].QuestionSounds = {
Sound("vo/npc/female01/vquestion02.wav"),
Sound("vo/npc/female01/question04.wav"),
Sound("vo/npc/female01/question06.wav"),
Sound("vo/npc/female01/question02.wav"),
Sound("vo/npc/female01/question09.wav"),
Sound("vo/npc/female01/question12.wav"),
Sound("vo/npc/female01/question17.wav"),
Sound("vo/npc/female01/question19.wav"),
Sound("vo/npc/female01/question20.wav"),
Sound("vo/npc/female01/question29.wav"),
Sound("vo/npc/female01/question30.wav")
}

VoiceSets["female"].AnswerSounds = {
Sound("vo/npc/female01/vanswer08.wav"),
Sound("vo/npc/female01/vanswer09.wav"),
Sound("vo/npc/female01/answer13.wav"),
Sound("vo/npc/female01/busy02.wav"),
Sound("vo/npc/female01/answer33.wav"),
Sound("vo/npc/female01/answer27.wav"),
Sound("vo/npc/female01/answer17.wav"),
Sound("vo/npc/female01/answer28.wav"),
Sound("vo/npc/female01/answer22.wav"),
Sound("vo/npc/female01/answer24.wav")
}

VoiceSets["female"].PushSounds = {
Sound("vo/npc/female01/excuseme01.wav"),
Sound("vo/npc/female01/excuseme02.wav"),
Sound("vo/npc/female01/sorry01.wav"),
Sound("vo/npc/female01/sorry02.wav"),
Sound("vo/npc/female01/sorry03.wav")
}

VoiceSets["female"].KillCheer = {
Sound("vo/npc/male01/gotone01.wav"),
Sound("vo/npc/male01/gotone02.wav")
}

VoiceSets["female"].SupplySounds = {
Sound("vo/npc/female01/ammo04.wav"),
Sound("vo/npc/female01/ammo05.wav"),
Sound("vo/npc/female01/yeah02.wav"),
}

VoiceSets["female"].WaveSounds = {
Sound("vo/npc/female01/headsup01.wav"),
Sound("vo/npc/female01/headsup02.wav"),
Sound("vo/npc/female01/incoming02.wav"),
Sound("vo/npc/female01/watchout.wav"),
Sound("vo/npc/female01/zombies01.wav"),
Sound("vo/npc/female01/zombies02.wav"),
}

VoiceSets["female"].HealSounds = {
Sound("vo/npc/female01/health01.wav"),
Sound("vo/npc/female01/health02.wav"),
Sound("vo/npc/female01/health03.wav"),
Sound("vo/npc/female01/health04.wav"),
Sound("vo/npc/female01/health05.wav"),
}

-- Precache all sounds for female set
for _, set in pairs(VoiceSets["female"]) do
	for k, snd in pairs(set) do
		--Check if its another table
		if type( snd ) == "table" then
			for j, sndnew in pairs(snd) do
				----print("Precached "..tostring(sndnew))
				util.PrecacheSound( sndnew )
			end
		else
		--print("Precached "..tostring(snd))
		util.PrecacheSound( snd )
		end
	end
end

-- Combine sounds
VoiceSets["combine"] = {}
VoiceSets["combine"].PainSoundsLight = {
Sound("npc/combine_soldier/pain1.wav"),
Sound("npc/combine_soldier/pain2.wav"),
Sound("npc/combine_soldier/pain3.wav")
}

VoiceSets["combine"].PainSoundsMed = {
Sound("npc/metropolice/pain1.wav"),
Sound("npc/metropolice/pain2.wav")
}

VoiceSets["combine"].PainSoundsHeavy = {
Sound("npc/metropolice/pain3.wav"),
Sound("npc/metropolice/pain4.wav")
}

VoiceSets["combine"].DeathSounds = {
Sound("npc/combine_soldier/die1.wav"),
Sound("npc/combine_soldier/die2.wav"),
Sound("npc/combine_soldier/die3.wav")
}

VoiceSets["combine"].ReloadSounds = {
Sound("npc/combine_soldier/vo/coverme.wav"),
Sound("npc/combine_soldier/vo/targetmyradial.wav"),
}

VoiceSets["combine"].ChatSounds = {
	["burp"] = { Sound("mrgreen/burp.wav") },
	["ok"] = { Sound("npc/metropolice/vo/affirmative.wav"), Sound("npc/metropolice/vo/ten4.wav") },
	["zombie"] = { Sound("npc/metropolice/vo/freenecrotics.wav"), Sound("npc/metropolice/vo/necrotics.wav") },
	["incoming"] = { Sound("npc/metropolice/vo/takecover.wav") },
	["headcrab"] = { Sound("npc/metropolice/vo/bugs.wav"), Sound("npc/metropolice/vo/bugsontheloose.wav") },
	["move"] = { Sound("npc/metropolice/vo/move.wav"), Sound("npc/metropolice/vo/moveit.wav") },
	["oh shi"] = { Sound("npc/metropolice/vo/shit.wav") },
	["help"] = { Sound("npc/metropolice/vo/help.wav") },
	["watch out"] = { Sound("npc/metropolice/vo/lookout.wav"), Sound("npc/metropolice/vo/watchit.wav") },
	["get down"] = { Sound("npc/metropolice/vo/getdown.wav") },
	["get out"] = { Sound("npc/metropolice/vo/nowgetoutofhere.wav"), Sound("npc/metropolice/vo/getoutofhere.wav") }
}

VoiceSets["combine"].QuestionSounds = {
Sound("npc/combine_soldier/vo/motioncheckallradials.wav"),
Sound("npc/combine_soldier/vo/hardenthatposition.wav"),
Sound("npc/combine_soldier/vo/confirmsectornotsterile.wav"),
Sound("npc/combine_soldier/vo/necroticsinbound.wav"),
Sound("npc/combine_soldier/vo/readyweapons.wav"),
Sound("npc/combine_soldier/vo/readyweaponshostilesinbound.wav"),
Sound("npc/combine_soldier/vo/weareinaninfestationzone.wav"),
Sound("npc/combine_soldier/vo/stayalert.wav")
}

VoiceSets["combine"].AnswerSounds = {
Sound("npc/combine_soldier/vo/affirmative.wav"),
Sound("npc/combine_soldier/vo/affirmative2.wav"),
Sound("npc/combine_soldier/vo/copy.wav"),
Sound("npc/combine_soldier/vo/copythat.wav")
}

VoiceSets["combine"].PushSounds = {
Sound("npc/combine_soldier/vo/contact.wav"),
Sound("npc/combine_soldier/vo/displace.wav"),
Sound("npc/combine_soldier/vo/displace2.wav")
}

VoiceSets["combine"].KillCheer = {
Sound("npc/combine_soldier/vo/contactconfirmprosecuting.wav"),
Sound("npc/combine_soldier/vo/payback.wav"),
Sound("npc/combine_soldier/vo/onedown.wav"),
Sound("npc/combine_soldier/vo/onecontained.wav")
}

VoiceSets["combine"].Frightened = {
Sound("npc/metropolice/vo/officerneedshelp.wav"),
Sound("npc/metropolice/vo/help.wav"),
Sound("npc/combine_soldier/vo/inbound.wav"),
Sound("npc/combine_soldier/vo/callhotpoint.wav")
}

VoiceSets["combine"].SupplySounds = {
Sound("npc/metropolice/vo/chuckle.wav"),
}

VoiceSets["combine"].WaveSounds = {
Sound("npc/metropolice/vo/freenecrotics.wav"),
Sound("npc/metropolice/vo/holdthisposition.wav"),
Sound("npc/metropolice/vo/holditrightthere.wav"),
Sound("npc/combine_soldier/vo/contactconfirmprosecuting.wav"),
Sound("npc/combine_soldier/vo/overwatchrequestreinforcement.wav"),
}

-- Aaaand precache sounds for combine voice set
for _, set in pairs(VoiceSets["combine"]) do
	for k, snd in pairs(set) do
		--Check if its another table
		if type( snd ) == "table" then
			for j, sndnew in pairs(snd) do
				--print("Precached "..tostring(sndnew))
				util.PrecacheSound( sndnew )
			end
		else
		--print("Precached "..tostring(snd))
		util.PrecacheSound( snd )
		end
	end
end

GameSounds = {}

GameSounds.WinMusic = {
	"music/HL2_song6.mp3",
	"music/HL1_song17.mp3",
	"music/HL2_song31.mp3"
}

GameSounds.LoseMusic = {
	"music/HL2_song7.mp3",
	"music/HL2_song32.mp3",
	"music/HL2_song33.mp3"
}

for _, tbl in pairs(GameSounds) do
	for k, snd in pairs(tbl) do
		--print("Precached "..tostring(snd))
		util.PrecacheSound( snd )
	end
end

Ambience = {}

Ambience.Human = {
	Sound ( "music/HL1_song20.mp3" ),
	Sound ( "music/HL1_song26.mp3" ),
	Sound ( "music/HL1_song3.mp3" ),
	Sound ( "music/HL1_song14.mp3" ),
	Sound ( "music/HL1_song5.mp3" ),
	Sound ( "music/HL1_song6.mp3" ),
	Sound ( "music/HL1_song9.mp3" ),
	Sound ( "music/HL2_song0.mp3" ),
	Sound ( "music/HL2_song1.mp3" ),
	Sound ( "music/HL2_song10.mp3" ),
	Sound ( "music/HL2_song13.mp3" ),
	Sound ( "music/HL2_song17.mp3" ),
	Sound ( "music/HL2_song19.mp3" ),
	Sound ( "music/Ravenholm_1.mp3" ),
	Sound ( "music/HL2_song30.mp3" ),
	Sound ( "music/HL2_song7.mp3" ),
	Sound ( "music/HL2_song19.mp3" ),
	Sound ( "music/HL2_song26_trainstation1.mp3" ),
	Sound ( "music/HL2_song27_trainstation2.mp3" ),
	Sound ( "music/HL2_song32.mp3" ),
}

Ambience.Zombie = {
	Sound ( "music/stingers/HL1_stinger_song16.mp3" ),
	Sound ( "music/stingers/HL1_stinger_song27.mp3" ),
	Sound ( "music/stingers/HL1_stinger_song7.mp3" ),
	Sound ( "music/stingers/HL1_stinger_song8.mp3" ),
	Sound ( "music/stingers/industrial_suspense1.wav" ),
	Sound ( "music/stingers/industrial_suspense2.wav" ),
}

for _, tbl in pairs(Ambience) do
	for k, snd in pairs(tbl) do
		--print("Precached "..tostring(snd))
		util.PrecacheSound( snd )
	end
end

GameDeathHints = {
	"Use props to fastly kill humans!",
	"Stick together as a team to win the game!",
	"You usually get 3 greencoins for a human kill.",
	"Headcrabs are small.Use them wisely!",
	"Critially injured humans move slower!",
	"You usually get 1 greencoin for a zombie kill.",
	"You can select a zombie class by pressing F3.",
	"Try to stick as a team when you are human!",
	"More zombie classes are unlocked when roundtime passes!",
	"As zombie, you can redeem by eating 4 brains (8 points)!",
	"Death isn't endgame. You can redeem by eating 4 brains (8 points)!",
}	

