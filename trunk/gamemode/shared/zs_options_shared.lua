-- � Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

GM.Version  = "Green Apocalypse"
GM.SubVersion = ""
--Testing shop

function ToMinutesSeconds(TimeInSeconds)
	local iMinutes = math.floor(TimeInSeconds / 60.0)
	return string.format("%0d:%02d", iMinutes, math.floor(TimeInSeconds - iMinutes*60))
end

--[==[------------------------------------------------------------
   Call this whenever you want to check an option
-------------------------------------------------------------]==]
function ConVarIsTrue(convar)
	if not ConVarExists(convar) then
		return false
	end
	
	return GetConVar(convar):GetBool()
end

ARENA_MODE = tobool(string.find(tostring(game.GetMap()),"zs_arena"))
if ARENA_MODE then
	print("[MAPCODER] Arena map")
end

DEFAULT_VIEW_OFFSET = Vector(0, 0, 64)
DEFAULT_VIEW_OFFSET_DUCKED = Vector(0, 0, 28)
DEFAULT_JUMP_POWER = 180
DEFAULT_STEP_SIZE = 18
DEFAULT_MASS = 80
DEFAULT_MODELSCALE = 1-- Vector(1, 1, 1)

-- Horde stuff
HORDE_MAX_ZOMBIES = 15
HORDE_MAX_DISTANCE = 280

BONUS_RESISTANCE_WAVE = 5
BONUS_RESISTANCE_AMOUNT = 20 -- %

--EVENT: Halloween
HALLOWEEN = false

--EVENT: Christmas
CHRISTMAS = false

--EVENT: Aprils Fools
FIRSTAPRIL = false

--Boss stuff
BOSS_TOTAL_PLAYERS_REQUIRED = 9
BOSS_CLASS = {10,11,13,15} -- 12
--BOSS_CLASS = {16} --Lilith
--BOSS_CLASS = {15} --Klinator
--BOSS_CLASS = {17} --Smoker class


--??
SHARED_SPEED_INCREASE = 13
--hate
----------------------------------
--		STARTING LOADOUTS		--
----------------------------------

-- Only if they bought the Comeback shop item
ComeBackReward = {}
ComeBackReward[1] = { -- Medic
[1] =  { "weapon_zs_elites", "weapon_zs_fiveseven"},
[2] =  { "weapon_zs_deagle"  }, 
[3] =  { "weapon_zs_ak47"  }, 
[4] =  { "weapon_zs_ak47" }, 
}
ComeBackReward[2] = { -- Commando
[1] =  { "weapon_zs_deagle", "weapon_zs_glock3"},
[2] =  { "weapon_zs_galil", "weapon_zs_sg552" }, 
[3] =  { "weapon_zs_ak47" }, 
 [4] =  { "weapon_zs_ak47"  }, 
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
[4] =  { "weapon_zs_ak47"}, 
}
ComeBackReward[5] = { -- Support
[1] =  { "weapon_zs_fiveseven", "weapon_zs_elites"},
[2] =  { "weapon_zs_tmp","weapon_zs_ump", "weapon_zs_mac10"}, 
[3] =  { "weapon_zs_smg"}, 
}

--[[
ComeBackReward = {}
ComeBackReward[1] = { "weapon_zs_glock3", "weapon_zs_fiveseven", "weapon_zs_magnum" } -- humans outnumber zombies
ComeBackReward[2] = { "weapon_zs_p90", "weapon_zs_smg" } -- zombies outnumber humans by a small marigin
ComeBackReward[3] = { "weapon_zs_galil", "weapon_zs_ak47", "weapon_zs_m4a1" } -- zombies outnumber humans 2 to 1
ComeBackReward[4] = { "weapon_zs_m1014", "weapon_zs_shotgun" } -- zombies outnumber humans 4 to 1
]]

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

--Human weapons data

-- Weapons information table
GM.HumanWeapons = {	
	--Melee
	["weapon_zs_melee_keyboard"]  = { Name = "Keyboard", DPS = 45, Infliction = 0, Type = "melee",Price = 250 },
	["weapon_zs_melee_plank"]  = { Name = "Plank", DPS = 56, Infliction = 0, Type = "melee",Price = 140 }, 
	["weapon_zs_melee_pot"]  = { Name = "Pot", DPS = 61, Infliction = 0, Type = "melee",Price = 340 }, 
	["weapon_zs_melee_fryingpan"]  = { Name = "Frying Pan", DPS = 70, Infliction = 0, Type = "melee",Price = 420 },
	["weapon_zs_melee_axe"]  = { Name = "Axe", DPS = 78, Infliction = 0.5, Type = "melee", Price = 600 }, 
	["weapon_zs_melee_crowbar"]  = { Name = "Crowbar", DPS = 85, Infliction = 0.65, Type = "melee", Price = 700 },
	["weapon_zs_melee_katana"]  = { Name = "Katana", DPS = 90, Infliction = 0, Type = "melee", Price = 1520 },
	["weapon_zs_melee_combatknife"]  = { Name = "Combat Knife", DPS = 15, Infliction = 0, Type = "melee" , Price = 6000 },
	["weapon_zs_melee_shovel"]  = { Name = "Shovel", DPS = 40, Infliction = 0, Type = "melee", Price = 6000 },
	["weapon_zs_melee_sledgehammer"]  = { Name = "Sledgehammer", DPS = 38, Infliction = 0, Type = "melee", Price = 1040 },
	["weapon_zs_melee_hook"]  = { Name = "Meat Hook", DPS = 38, Infliction = 0, Type = "melee", Price = 7000 },
	["weapon_zs_melee_pipe"]  = { Name = "Pipe", DPS = 30, Infliction = 0, Type = "melee",Price = 7000 },
	["weapon_zs_melee_pipe2"]  = { Name = "Improved Pipe", DPS = 30, Infliction = 0, Type = "melee",Price = 7000 },

	--Pistols
	["weapon_zs_usp"]  = { Name = "USP .45", DPS = 42,Mat = "VGUI/gfx/VGUI/usp45", Infliction = 0, Type = "pistol" },
	["weapon_zs_p228"]  = { Name = "P228", DPS = 58,Mat = "VGUI/gfx/VGUI/p228", Infliction = 0, Type = "pistol" },
	["weapon_zs_deagle"]  = { Name = "Desert Eagle",Mat = "VGUI/gfx/VGUI/deserteagle", DPS = 93, Infliction = 0.2, Type = "pistol", Price = 530 },
	["weapon_zs_fiveseven"]  = { Name = "Five-Seven",Mat = "VGUI/gfx/VGUI/fiveseven", DPS = 91, Infliction = 0.15, Type = "pistol", Price = 120 },
	["weapon_zs_magnum"]  = { Name = ".357 Magnum", DPS = 121, Infliction = 0.3, Type = "pistol", Price = 390 },
	["weapon_zs_glock3"]  = { Name = "Glock", DPS = 120,Mat = "VGUI/gfx/VGUI/glock18", Infliction = 0.25, Type = "pistol", Price = 270 },
	["weapon_zs_elites"]  = { Name = "Dual-Elites", DPS = 92,Mat = "VGUI/gfx/VGUI/elites", Infliction = 0.25, Type = "pistol", Price = 420 },
	["weapon_zs_classic"]  = { Name = "'Classic' Pistol", DPS = 30, Infliction = 0.25, Type = "pistol",Price = 60 },
	["weapon_zs_alyx"]  = { Name = "Alyx Gun", DPS = 30, Infliction = 0.25, Type = "pistol",Price = 5000 },
	
	--Light Guns
	["weapon_zs_p90"]  = { Name = "P90", DPS = 125,Mat = "VGUI/gfx/VGUI/p90", Infliction = 0.65, Type = "smg", Price = 740 },
	["weapon_zs_ump"]  = { Name = "UMP", DPS = 110,Mat = "VGUI/gfx/VGUI/ump45", Infliction = 0.60, Type = "smg", Price = 650 },
	["weapon_zs_smg"]  = { Name = "Sub-Machine Gun", DPS = 130, Infliction = 0.9, Type = "smg" },
	["weapon_zs_mp5"]  = { Name = "MP5", DPS = 127,Mat = "VGUI/gfx/VGUI/mp5", Infliction = 0.58, Type = "smg", Price = 510 },
	["weapon_zs_tmp"]  = { Name = "Silent TMP", DPS = 107,Mat = "VGUI/gfx/VGUI/tmp", Infliction = 0.56, Type = "smg", Price = 430 },
	["weapon_zs_mac10"]  = { Name = "Mac 10", DPS = 126,Mat = "VGUI/gfx/VGUI/mac10", Infliction = 0.60, Type = "smg", Price = 320 },
	["weapon_zs_scout"]  = { Name = "Scout Sniper", DPS = 40,Mat = "VGUI/gfx/VGUI/scout", Infliction = 0, Type = "rifle", Price = 210 },
			
	--Medium Guns
	["weapon_zs_ak47"]  = { Name = "AK-47", DPS = 133,Mat = "VGUI/gfx/VGUI/ak47", Infliction = 0.7, Type = "rifle", Price = 840 },
	["weapon_zs_aug"]  = { Name = "Steyr AUG", DPS = 125,Mat = "VGUI/gfx/VGUI/aug", Infliction = 0.53, Type = "rifle" , Price = 1390 },
	["weapon_zs_sg552"]  = { Name = "SG552 Rifle", DPS = 106,Mat = "VGUI/gfx/VGUI/sg552", Infliction = 0.51, Type = "rifle", Price = 1090 },
	["weapon_zs_sg550"]  = { Name = "SG550", DPS = 106,Mat = "VGUI/gfx/VGUI/sg550", Infliction = 0.51, Type = "rifle", Price = 1560 },
	--["weapon_zs_g3sg1"]  = { Name = "G3-SG1", DPS = 106,Mat = "VGUI/gfx/VGUI/g3sg1", Infliction = 0.51, Type = "rifle", Price = 1120 },
	["weapon_zs_famas"]  = { Name = "Famas", DPS = 140,Mat = "VGUI/gfx/VGUI/famas", Infliction = 0.7, Type = "rifle", Price = 800 },
	["weapon_zs_galil"]  = { Name = "Galil", DPS = 129,Mat = "VGUI/gfx/VGUI/galil", Infliction = 0.57, Type = "rifle", Price = 1100 },
	["weapon_zs_m4a1"]  = { Name = "M4A1", DPS = 138,Mat = "VGUI/gfx/VGUI/m4a1", Infliction = 0.65, Type = "rifle", Price = 1690 },

	--Heavy
	["weapon_zs_awp"]  = { Name = "AWP", DPS = 200,Mat = "VGUI/gfx/VGUI/awp", Infliction = 0, Class = "Berserker", Type = "rifle",Price = 2500 },
	["weapon_zs_m249"]  = { Name = "M249", DPS = 200,Mat = "VGUI/gfx/VGUI/m249", Infliction = 0.85, Type = "rifle", Price = 2200 },
	["weapon_zs_boomstick"]  = { Name = "Boom Stick", DPS = 215, Infliction = 0.85, Type = "shotgun", Price = 2700 },
	["weapon_zs_boomerstick"]  = { Name = "Boom Stick", DPS = 215, Infliction = 0.85, Type = "shotgun", Price = 3900 },
	["weapon_zs_grenadelauncher"]  = { Name = "Grenade Launcher", DPS = 215, Infliction = 0.85, Type = "shotgun", Price = 3700 },
	["weapon_zs_m1014"]  = { Name = "M1014 Auto-Shotgun", DPS = 246,Mat = "VGUI/gfx/VGUI/xm1014", Infliction = 0.85, Type = "shotgun", Price = 2400 },
	["weapon_zs_crossbow"]  = { Name = "Crossbow", DPS = 220, Infliction = 0, Class = "Medic", Type = "rifle"},
	["weapon_zs_m3super90"]  = { Name = "M3-Super90 Shotgun", DPS = 149,Mat = "VGUI/gfx/VGUI/m3", Infliction = 0,Class = "Support", Type = "shotgun", Price = 2100 },

	--Uncategorized
	["weapon_zs_minishotty"]  = { Name = "'Farter' Shotgun", DPS = 126, Infliction = 0, Type = "shotgun" },
	["weapon_zs_fists"]  = { Name = "Fists", DPS = 30, Infliction = 0, Restricted = true, Type = "melee" },
	["weapon_zs_fists2"]  = { Name = "Fists", DPS = 30, Infliction = 0, Restricted = true, Type = "melee" },
	["weapon_zs_shotgun"]  = { Name = "Shotgun", DPS = 215, Infliction = 0.85, Type = "shotgun" }, -- 860
	["weapon_zs_pulsesmg"]  = { Name = "Pulse SMG", DPS = 99, Infliction = 0, Type = "rifle", Price = 1750},
	["weapon_zs_pulserifle"]  = { Name = "Pulse Rifle", DPS = 143, Infliction = 0, Type = "rifle" },
	["weapon_zs_dubpulse"]  = { Name = "Super Pulse Rifle", DPS = 143, Infliction = 0, Type = "rifle", Price = 2600 }, --Seems to work fine now.
	["weapon_zs_flaregun"]  = { Name = "Flare Gun", DPS = 143, Infliction = 0, Type = "rifle" },
	
	--Tool1
	["weapon_zs_tools_hammer"]  = { Name = "Nailing Hammer", DPS = 23, Infliction = 0, Type = "tool1", NoRetro = true },
	["weapon_zs_tools_hammer2"]  = { Name = "Special Nailing Hammer", DPS = 23, Infliction = 0, Type = "tool1", NoRetro = true },
	["weapon_zs_medkit"]  = { Name = "Medkit", DPS = 8, Infliction = 0, Type = "tool1", NoRetro = true },
	["weapon_zs_tools_supplies"] = { Name = "Mobile Supplies", DPS = 0, Infliction = 0, Type = "tool1", NoRetro = true },
	["weapon_zs_tools_remote"] = { Name = "Remote Controller", DPS = 0, Infliction = 0, Type = "tool2" },
	["weapon_zs_tools_torch"] = { Name = "Torch", DPS = 0, Infliction = 0, Type = "tool2", NoRetro = true },
	
	--Tool2
	["weapon_zs_miniturret"] = { Name = "Combat Mini-Turret", DPS = 0, Infliction = 0, Type = "tool2" },
	["weapon_zs_turretplacer"] = { Name = "Turret", DPS = 0, Infliction = 0, Type = "tool1", NoRetro = true },
	["weapon_zs_grenade"]  = { Name = "Grenade", DPS = 8, Infliction = 0, Type = "tool2", NoRetro = true },
	["weapon_zs_mine"]  = { Name = "Explosives", DPS = 8, Infliction = 0, Type = "tool1", NoRetro = true },
	["weapon_zs_tools_plank"]  = { Name = "Pack of Planks", DPS = 0, Infliction = 0, Type = "tool2" },
	["weapon_zs_tools_c42"]  = { Name = "C4", DPS = 0, Infliction = 0, Type = "tool2" },
	

	--Pickups
	["weapon_zs_pickup_gascan2"]  = { Name = "Dangerous Gas Can", DPS = 0, Infliction = 0, Type = "misc" },
	["weapon_zs_pickup_propane"]  = { Name = "Dangerous Propane Tank", DPS = 0, Infliction = 0, Type = "misc" },
	["weapon_zs_pickup_flare"]  = { Name = "Rusty Flare", DPS = 0, Infliction = 0, Type = "misc" },
	["weapon_zs_pickup_gasmask"]  = { Name = "Old Gas Mask", DPS = 0, Infliction = 0, Type = "misc" },

	--HL2 weapons
	["weapon_357"] = { Name = ".357 Original", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
	["weapon_ar2"] = { Name = "AR2 Rifle", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
	["weapon_bugbait"] = { Name = "Bugbait", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
	["weapon_crossbow"] = { Name = "Original Crossbow", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
	["weapon_crowbar"] = { Name = "Original Crowbar", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
	["weapon_pistol"] = { Name = "Original Pistol", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
	["weapon_rpg"] = { Name = "Original RPG", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
	["weapon_shotgun"] = { Name = "Original Shotgun", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },

	--Admin and Dev. Tools
	["admin_tool_canister"] = { Name = "Canister Tool", DPS = 0, Infliction = 0.2, Type = "admin" },
	["admin_tool_sprayviewer"] = { Name = "Sprayviewer Tool", DPS = 0, Infliction = 0.2, Type = "admin" },
	["admin_tool_igniter"] = { Name = "Igniter Tool", DPS = 0, Infliction = 0.2, Type = "admin" },
	["admin_tool_remover"] = { Name = "Remover Tool", DPS = 0, Infliction = 0.2, Type = "admin" },
	["admin_maptool"] = { Name = "Map Tool", DPS = 0, Infliction = 0.2, Type = "admin" },
	["weapon_physgun"] = { Name = "Physgun", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true },
	["weapon_physcannon"] = { Name = "Physcannon", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true },
	["dev_points"] = { Name = "Developer Tool", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true },
	["map_tool"] = { Name = "Mapping Tool", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true },
	["admin_raverifle"] = { Name = "Ravebreak Rifle!", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true },
	["admin_poisonspawner"] = { Name = "Poison Spawner Tool", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true },
	["admin_exploitblocker"] = { Name = "Exploit blocker Tool", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true },
	["christmas_snowball"] = { Name = "Christmas Snowball", DPS = 0, Infliction = 0, Type = "christmas", Restricted = true },
	["weapon_frag"]  = { Name = "Grenade", DPS = 1, Infliction = 0, Restricted = true, Type = "admin" },
}

---

GM.SkillShopAmmo = {
	["pistol"]  = { Name = "12 Pistol Bullets", Model = "models/Items/BoxSRounds.mdl", Amount = 12, Price = 20},
	["357"]  = { Name = "6 Sniper Bullets", Model = "models/Items/357ammo.mdl", Amount = 6, Price = 35},
	["smg1"]  = { Name = "30 SMG Bullets", Model = "models/Items/BoxMRounds.mdl", Amount = 30, Price = 25},
	["ar2"]  = { Name = "30 Rifle Bullets", Model = "models/Items/combine_rifle_cartridge01.mdl", Amount = 35, Price = 30},
	["buckshot"]  = { Name = "12 Shotguns Shells", Model = "models/Items/BoxBuckshot.mdl", Amount = 12, Price = 30},
	["slam"]  = { Name = "Refill 1 explosive", Model = "models/Items/BoxBuckshot.mdl",Tool = "weapon_zs_mine", Amount = 1, Price = 60, ToolTab = true},
	["grenade"]  = { Name = "Refill 1 grenade", Model = "models/Items/BoxBuckshot.mdl",Tool = "weapon_zs_grenade", Amount = 1, Price = 70, ToolTab = true},
	["gravity"]  = { Name = "Refill 1 nail", Model = "models/Items/BoxBuckshot.mdl",Tool = "weapon_zs_tools_hammer", Amount = 1, Price = 30, ToolTab = true},
	["Battery"]  = { Name = "Refill 30 charge for Medkit", Model = "models/Items/BoxBuckshot.mdl", Amount = 30, Price = 35, ToolTab = true},
}


----------------------------------
--		AMMO REGENERATION		--
----------------------------------
-- This is how much ammo a player is given for whatever type it is on ammo regeneration.
-- Players are given double these amounts if 75% or above Infliction.
-- Changing these means you're an idiot.

GM.AmmoRegeneration = {
	["ar2"] = 80, --Rifle
	["alyxgun"] = 16,
	["pistol"] = 40, --Pistol
	["smg1"] = 80, --SMG
	["357"] = 20, --Sniper
	["xbowbolt"] = 5,
	["buckshot"] = 35, --Shotgun
	["ar2altfire"] = 1,
	["slam"] = 2, --Explosive
	["rpg_round"] = 1,
	["smg1_grenade"] = 1,
	["sniperround"] = 1,
	["sniperpenetratedround"] = 5,
	["grenade"] = 1, --Grenade
	["thumper"] = 1,
	["gravity"] = 3, --Nail
	["battery"] = 30, --Medkit
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

MAX_RANK = 78

-- -- -- -- -- -- -- -- -- -- /
-- [rank] = {unlocks}
GM.RankUnlocks = {
	[0] = {"weapon_zs_usp","weapon_zs_fists2"},
	[1] = {"weapon_zs_melee_plank"},
	[2] = {"weapon_zs_p228"},
	[3] = {"_kevlar"},
	[4] = {"weapon_zs_tools_torch"},
	[5] = {"weapon_zs_medkit"},
	[6] = {"weapon_zs_tools_hammer"},
	[7] = {"_nailamount"},
	[11] = {"weapon_zs_tools_supplies"},
	[13] = {"_adrenaline"},
	[12] = {"weapon_zs_melee_keyboard"},
	[14] = {"_sboost"},
	[15] = {"weapon_zs_grenade"},
	[16] = {"_trchregen"},
	[17] = {"_nailhp"},
	[18] = {"weapon_zs_melee_pipe"},
	[19] = {"_falldmg"},
	[21] = {"_kevlar2"},
	[22] = {"_medupgr2"},
	[24] = {"_comeback"},
	[25] = {"weapon_zs_turretplacer"},
	[27] = {"_poisonprotect"},
	[28] = {"weapon_zs_tools_remote"},
	[30] = {"_turretdmg"},
	[31] = {"weapon_zs_mine"},
	[32] = {"_turrethp"},
	[33] = {"_turretammo"},-- ,"weapon_zs_melee_axe"
	[34] = {"_medupgr1"},
	[35] = {"_enhkevlar"},
	[36] = {"weapon_zs_melee_combatknife"}, --Combat knife. 
	[37] = {"weapon_zs_tools_plank"},
	[39] = {"_plankamount"},
	[40] = {"_freeman"},
	[42] = {"weapon_zs_melee_pipe2"},
	[43] = {"_plankhp"},
	[45] = {"weapon_zs_melee_pot"},
	[50] = {"weapon_zs_miniturret"},
	[55] = {"weapon_zs_melee_crowbar"},
	[65] = {"weapon_zs_classic"},
	[70] = {"weapon_zs_fiveseven"},
	[76] = {"weapon_zs_melee_hook"},
	[77] = {"weapon_zs_alyx"},
	[78] = {"weapon_zs_tools_hammer2"},
	-- [90] = {"_professional"},-- hidden for a while
}

--Weapons to spawn with in Arena Mode
GM.ArenaWeapons = {
	"weapon_zs_m249",
	"weapon_zs_m1014",
	"weapon_zs_shotgun",
	"weapon_zs_ak47",
	"weapon_zs_m4a1",
	"weapon_zs_m3super90",
	"weapon_zs_famas",
	"weapon_zs_galil",
	"weapon_zs_mp5",
	"weapon_zs_grenadelauncher",
	"weapon_zs_boomerstick",
	"weapon_zs_boomstick",
	"weapon_zs_crossbow",
	
}

-- [name] = {Name = "...", Description = "...", Material = "..." (optional), Slot = (1 or 2)}
GM.Perks = {
	["_kevlar"] = {Name = "Kevlar", Description = "Gives you 10 more HP",Material = "VGUI/gfx/VGUI/kevlar", Slot = 1},
	["_kevlar2"] = {Name = "Full Kevlar", Description = "Gives you 30 more HP",Material = "VGUI/gfx/VGUI/kevlar", Slot = 1},
	["_turretammo"] = {Name = "Turret Ammo", Description = "50% more ammo for turret", Slot = 2},
	["_turrethp"] = {Name = "Turret Durability", Description = "50% more health for turret", Material = "VGUI/gfx/VGUI/defuser", Slot = 2},
	["_turretdmg"] = {Name = "Turret Power", Description = "50% more turret's damage", Slot = 2},
	["_poisonprotect"] = {Name = "Poison Protection", Description = "30% less damage from Poison Headcrabs", Slot = 2},
	["_nailamount"] = {Name = "Pack of nails", Description = "50% more starting nails", Slot = 2},
	["_nailhp"] = {Name = "Upgraded nails", Description = "40% more health for nails", Slot = 2},
	["_falldmg"] = {Name = "Fall Protection", Description = "25% less fall damage", Slot = 1},
	["_freeman"] = {Name = "Freeman's Spirit", Description = "Do 50% more melee damage", Material = "VGUI/achievements/kill_enemy_knife_bw", Slot = 1},
	["_enhkevlar"] = {Name = "Enhanced Kevlar", Description = "15% less damage from hits",Material = "VGUI/gfx/VGUI/kevlar_helmet", Slot = 1},
	["_adrenaline"] = {Name = "Adrenaline Injection", Description = "Negates speed reduction on low health. Also your screen won't turn red when you are low on health", Slot = 1},
	["_medupgr1"] = {Name = "Medical Efficiency", Description = "35% more healing power", Slot = 2},
	["_medupgr2"] = {Name = "Medical Pack", Description = "Doubled maximum Medical Kit charges", Slot = 2},
	["_sboost"] = {Name = "Speed Boost", Description = "8% more walking speed", Slot = 1},
	["_trchregen"] = {Name = "Handy Man", Description = "Increased regeneration rate for torch", Material = "HUD/scoreboard_clock", Slot = 2},
	["_comeback"] = {Name = "Comeback", Description = "Gives you random Tier 2 pistol after redeeming! Works only once.", Slot = 1},
	["_professional"] = {Name = "Professional", Description = "This perk has no effect yet!", Material = "VGUI/logos/spray_elited", Slot = 1},
	["_plankamount"] = {Name = "Extra Plank", Description = "Ability to carry one more plank!", Slot = 2},
	["_plankhp"] = {Name = "Stronger Planks", Description = "30% more health for planks", Slot = 2},
}

-- Leave this. This table will be filled at initialize hook
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
UNDEAD_START_AMOUNT_PERCENTAGE = 0.20
UNDEAD_START_AMOUNT_MINIMUM = 1

-- Good values are 1 to 3. 0.5 is about the same as the default HL2. 1 is about ZS difficulty. This is mainly for NPC healths and damages.
DIFFICULTY = 1.5

-- Humans can not carry OR drag anything heavier than this (in kg.)
CARRY_MAXIMUM_MASS = 300

-- Objects with more mass than this will be dragged instead of carried.
--CARRY_DRAG_MASS = 145
CARRY_DRAG_MASS = 130

-- Anything bigger than this is dragged regardless of mass.
--CARRY_DRAG_VOLUME = 120
CARRY_DRAG_VOLUME = 100

-- Humans can not carry anything with a volume more than this (OBBMins():Length() + OBBMaxs():Length()).
CARRY_MAXIMUM_VOLUME = 150

-- Humans are slowed by this amount per kg carried.
CARRY_SPEEDLOSS_PERKG = 1.3

-- But never slower than this.
CARRY_SPEEDLOSS_MINSPEED = 88

-- -- -- -- -- -- -- -- /

-- Maximum crates per map
MAXIMUM_CRATES = math.random(3, 4)

-- Use Zombie Survival's custom footstep sounds? I'm not sure how bad it might lag considering you're potentially sending a lot of data on heavily packed servers.
CUSTOM_FOOTSTEPS = true

-- In seconds, repeatatively, the gamemode gives all humans get a box of whatever ammo of the weapon they use.
AMMO_REGENERATE_RATE = 999140

--Warming up time
WARMUPTIME = 110

-- In seconds, how long humans need to survive.
ROUNDTIME = (20*60) + WARMUPTIME -- 20 minutes

-- Time in seconds between end round and next map.
INTERMISSION_TIME = 46

--Amount of time players have to vote for next map(seconds)
VOTE_TIME = 18

--Set this to true to destroy all brush-based doors that aren't based on phys_hinge and func_physbox or whatever. For door campers.
DESTROY_DOORS = true

--Prop freezing manage module
PROP_MANAGE_MODULE = false

--Set this to true to destroy all prop-based doors. Not recommended since some doors have boards on them and what-not. Only for true door camping whores.
DESTROY_PROP_DOORS = false

--Set this to true to force players to have mat_monitorgamma set to 2.2. This could cause problems with non-calibrated screens so, whatever.
--It forces people to use flashlights instead of whoring the video settings to make it brighter.
FORCE_NORMAL_GAMMA = false

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

--Time untill roll-the-dice is re-enabled
RTD_TIME = 180

--Sound to play for last human.
LASTHUMANSOUND = "lasthuman_fixed.mp3"
LASTHUMANSOUNDLENGTH = 159 -- 2:39

-- Sound played to a person when they die as a human.
DEATHSOUND = "music/stingers/HL1_stinger_song28.mp3"

-- Rave sound; people will hate me for making this :')
RAVESOUND = "mrgreen/ravebreak_fix.mp3"

-- Bug Reporting System
BUG_REPORT = false

-- Turn off/on the redeeming system.
REDEEM = true

-- Players don't have a choice if they want to redeem or not. Setting to false makes them press F2.
AUTOREDEEM = true

-- Human kills needed for a zombie player to redeem (resurrect). Do not set this to 0. If you want to turn this
-- system off, set AUTOREDEEM to false. (Deluvas: using Score System)
REDEEM_KILLS = 8
REDEEM_FAST_KILLS = 6

--Players cant redeem near end of round
REDEEM_PUNISHMENT = true

--Number of wave or above when zombies cant redeem
REDEEM_PUNISHMENT_TIME = 6

-- Use soft collisions for teammates
SOFT_COLLISIONS = false

--
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

--Menu stuff..

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
At SkillShop you buy Weapons, Ammo and Supplies. Payment is done with SkillPoints (SP).
To gain SkillPoints - simply kill the Undead and help your teammates.

Please remember bought Weapons only last this round!
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
	
	> Objective: Team up and survive Against the zombie horde!
	> Weapons: Kill zombies, Get SP go to the crate when the timer is up and press 'e' It then gives you your new weapons.
	> Leveling: To level up - you need to gain experience that you get for almost anything you do. Each time you level up - you may unlock new tools and perks. 
	To check your current experience type !levelstats in chat.
	> Tips: Stick with your team and make good use of your tools.
	
	-- ZOMBIES ----------------------------------------------------
	
	> Objective: Eat all humans. If you get 8 score (by eating 4 humans) - you will be able to redeem (F2).
	> Classes: Zombies have 8 different classes that will be unlocked depending on the round time. (press F3 to choose your class).
	> Spawning: As zombie you can spawn on other zombies (left mouse button). With right mouse button you can scroll through other zombies.
	> Teamwork: Zombies can gain damage resistance from bullets by grouping into hordes. 
	
	-- ADMINS ----------------------------------------------------
	
	> Damien, Duby, Gheii Ben, Reiska, The real freeman, Lameshot, Phychopeti.
	
	-- SERVER CODERS ----------------------------------------------------
	
	>Ywa, Duby.
	Any questions go to:  http://mrgreengaming.com
	
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
		
		Gamemode is developed by Limetric for Mr. Green Gaming Community. More info at http://limetric.com
		
	If you Win a round you gain XP this can be used to level up and unlock the following items.	
		You can also gain XP by killing humans and zombies.
		---lEVEL UNLOCKS------------------
		
	[0] = USP, fists [1] = Plank [2] = P228 [3] = Kevlar
	[5] = Medkit [6] = Hammer [7] = Pack of nails [11] = Mobile supplies, Keyboard
	[13] = Adrenaline injection, [14] = Speed boost [15] = Grenade
	[16] = Torch regen rate [17] = NailHP [19] = Falldmg
	[21] = Kevlar2 [22] = Medical upgrade2 [24] = Comeback
	[25] = Turret [27] = Poison protection [28] = Turret remote
	[30] = Turret Damage [31] = C4 [32] = Turret Health [33] = Turret Ammo
	[35] = Enhanced Kevlar [37] = Planks [39] = Plank amount [40] = Freeman spirit
	[43] = Plank HP [44] = Combat knife  [45] = Pot [50] = Mini turret
	[55] = Crowbar [65] = Classic pistol [70] = Five seven [76] = Hook
	[77] = Alyx Gun [78] = Special Hammer!
		
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
		* Get SkillPoints by helping your team and use them on available supply crate (When the timer is up)
		
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
--battery
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
@Go to our forums at http://mrgreengaming.com and post it there.
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
@If you have any questions or tips about/for this server you can always e-mail to mail@mrgreengaming.com
@
@Surf to http://mrgreengaming.com to post your ideas for changes and where you can post suggestions for new maps.
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
@   - Exploiting after Being Warned Several Times 'exploiting spots on a map, or exploiting zombie classes.'
@   - Glitching on Purpose
@   - Glitching with a zombie class which needs a path can result in a week or month ban!
@
@^yThe following can result in kick or insta-death:
@   - Being AFK for a Long Period of Time
@   - Spamming after being muted/gagged
@   - Cade breaking
@
@^yThe following can result in being teleported:
@   - Exploiting a Map
@   - Prop Climbing
@
@^yThe following can result in being muted/gagged:
@   - Spamming
@   - Being Underage and Using Microphone
@   - Excessive Swearing
@   - Abusing an admin 'verbal'
 ]]}

-- DON'T CHANGE DONATE TO ANOTHER NUMBER THAN 5 (see ReceiveDonLevel in cl_init)
HELP_TEXT[5] = { title = "Donate!", text = [[^yDONATE TO THIS SERVER!
@
@As you all might know, Mr. Green is a very active server. This results in a massive use of bandwidth
@which unfortunately, doesn't pay for itself.
@
@We will gladly accept donations to keep our server online! Every donation will be translated to GreenCoins on the server!
@
@This is how it works: for every EURO you donate, you get 1000 GC (GreenCoins). So if you donate 5 euros you
@get 5000 GC, donate 10 euros and you'll get 10.000! Green-Coins can be spend in the Green-Shop to buy upgrades, 
@fancy hats or other neat features! (type "!shop" to open it, or use the button on the right)
@
@^yHOW TO DONATE
@
@All instructions can be found on: http://mrgreengaming.com/greencoins.php
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
@A: Press F3.
@
@^gQ: How do I become human if I am Zombie?
@A: Kill 4 Humans, Get 8 Score.
@
@^gQ: How do I change human class?
@A: Press F4.
@
@^gQ: Where is the options menu?
@A: Press F4.
@
@ 
@^b Q: How do I sprint and use grenade as Zombine?	
@ A: When you take enough damage (~50% of your HP) you will be able to sprint and use grenade (right mouse click).
@	
@^b Q: How do I heal as medic?	
@ A: Equip medkit. Left click to heal other players, right click to heal yourself (make sure you're standing still).
@	
@^b Q: How do I use teleport as Ethereal Zombie?	
@ A: Aim at the ground (not the walls) and press right mouse button.	
@	
@^b Q: How to change my class as zombie?	
@ A: Press F3 and you will see class selection menu.	
@	
@^b Q: How to nail props using a hammer?	
@ A: Thats easy, aim at the prop (make sure that there is a wall behind it) and press right mouse button.	
@
@^b Q: Why Supply Crate gives me only ammo?
@ A: Supply Crates will give you ammo until when there will be ~6-7 humans.
@
@^b Q: Where i can see the full changelog?
@ A: Here: http://dev.limetric.com/svn/zs.php
@
@^b Q: How I can buy stuff?
@ A: Click 'GreenShop' button or type '!shop' to open a shop where you can spend your Green Coins.
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
--

for k, v in pairs(HELP_TEXT) do
	v.text = string.Explode("@", v.text)
	for _, text in pairs(v.text) do
		text = string.gsub(text, "@", "")
	end
end


--Add custom player models and hands
player_manager.AddValidModel("gordon", "models/player/gordon_classic.mdl")
player_manager.AddValidModel("santa", "models/Jaanus/santa.mdl")
player_manager.AddValidHands("gordon", "models/weapons/c_arms_hev.mdl", 0, "00000000")

--Add models for players to allow (and randomly be picked from when having no preference)
PlayerModels = {
	--Half-Life 2
		"alyx",
		"barney",
		"breen",
		"eli",
		"gman",
		"kleiner",
		"monk",
		"magnusson",
		"mossman",
		"odessa",
		"female01",
		"female02",
		"female03",
		"female05",
		"female06",
		"female07",
		"female08",
		"female09",
		"female10",
		"female11",
		"female12",
		"male01",
		"male02",
		"male03",
		"male04",
		"male05",
		"male06",
		"male07",
		"male08",
		"male09",
		"male10",
		"male11",
		"male12",
		"male13",
		"male14",
		"male15",
		"male16",
		"male17",
		"male18",
		"medic01",
		"medic02",
		"medic03",
		"medic04",
		"medic05",
		"medic06",
		"medic07",
		"medic08",
		"medic09",
		"medic10",
		"medic11",
		"medic12",
		"medic13",
		"medic14",
		"medic15",
		"refugee01",
		"refugee02",
		"refugee03",
		"refugee04",
		"hostage01",
		"hostage02",
		"hostage03",
		"hostage04",
		"css_arctic",
		"css_gasmask",
		"css_guerilla",
		"css_leet",
		"css_phoenix",
		"css_riot",
		"css_swat",
		"css_urban",
		--"santa"
}

PlayerAdminModels = {
	--Day of Defeat
		"dod_american",
		"dod_german"
	--Custom
		--"gordon",
		--"obama",
		--"creepr"
}

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


STATE_WARMUP = 0
STATE_GAME = 1
STATE_INTERMISSION = 2