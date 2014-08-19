-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
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
BOSS_CLASS = {10,11,13,16,17,18} -- 12
--BOSS_CLASS = {16} --Lilith
--BOSS_CLASS = {15} --Klinator
--BOSS_CLASS = {17} --Smoker class
--BOSS_CLASS = {18} --Seeker2
--BOSS_CLASS = {19} --REMEIL


--??
SHARED_SPEED_INCREASE = 13
--hate
----------------------------------
--		STARTING LOADOUTS		--
----------------------------------

-- Only if they bought the Comeback shop item
--ComeBackReward = {}
--ComeBackReward[1] = { -- Medic
--[1] =  { "weapon_zs_elites", "weapon_zs_fiveseven"},
--[2] =  { "weapon_zs_deagle"  }, 
--[3] =  { "weapon_zs_ak47"  }, 
--[4] =  { "weapon_zs_ak47" }, 
--}
--ComeBackReward[2] = { -- Commando
--[1] =  { "weapon_zs_deagle", "weapon_zs_glock3"},
--[2] =  { "weapon_zs_galil", "weapon_zs_sg552" }, 
--[3] =  { "weapon_zs_ak47" }, 
--[4] =  { "weapon_zs_ak47"  }, 
--}
--ComeBackReward[3] = { -- Berserker
--[1] =  { "weapon_zs_fiveseven", "weapon_zs_elites"},
--[2] =  { "weapon_zs_scout" }, 
--[3] =  { "weapon_zs_sg550"}, 
--}
--ComeBackReward[4] = { -- Engineer
--[1] =  { "weapon_zs_fiveseven", "weapon_zs_elites"},
--[2] =  { "weapon_zs_pulsesmg"}, 
--[3] =  {"weapon_zs_ak47"}, 
--[4] =  { "weapon_zs_ak47"}, 
--}
--ComeBackReward[5] = { -- Support
--[1] =  { "weapon_zs_fiveseven", "weapon_zs_elites"},
--[2] =  { "weapon_zs_tmp","weapon_zs_ump", "weapon_zs_mac10"}, 
--[3] =  { "weapon_zs_smg"}, 
--}

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



GM.HumanWeapons = {	
	--Melee
	["weapon_zs_melee_axe"]  = { Name = "Axe", DPS = 78, Infliction = 0.5, Type = "melee", Price = 600 }, 
	["weapon_zs_melee_katana"]  = { Name = "Katana", DPS = 90, Infliction = 0, Type = "melee", Price = 1520 },
	["weapon_zs_melee_crowbar"]  = { Name = "Crowbar", DPS = 85, Infliction = 0.65, Type = "melee", Price = 700 },
	["weapon_zs_melee_keyboard"]  = { Name = "Keyboard", DPS = 45, Infliction = 0, Type = "melee",Price = 250 },
	["weapon_zs_melee_plank"]  = { Name = "Plank", DPS = 56, Infliction = 0, Type = "melee",Price = 140 }, 
	["weapon_zs_melee_pot"]  = { Name = "Pot", DPS = 61, Infliction = 0, Type = "melee",Price = 340 }, 
	["weapon_zs_melee_fryingpan"]  = { Name = "Frying Pan", DPS = 70, Infliction = 0, Type = "melee",Price = 420 },
	["weapon_zs_melee_combatknife"]  = { Name = "Combat Knife", DPS = 15, Infliction = 0, Type = "melee" , Price = 6000 },
	["weapon_zs_melee_shovel"]  = { Name = "Shovel", DPS = 40, Infliction = 0, Type = "melee", Price = 6000 },
	["weapon_zs_melee_sledgehammer"]  = { Name = "Sledgehammer", DPS = 38, Infliction = 0, Type = "melee", Price = 1040 },
	["weapon_zs_melee_hook"]  = { Name = "Meat Hook", DPS = 38, Infliction = 0, Type = "melee", Price = 7000 },
	["weapon_zs_melee_pipe"]  = { Name = "Pipe", DPS = 30, Infliction = 0, Type = "melee",Price = 7000 },
	["weapon_zs_melee_pipe2"]  = { Name = "Improved Pipe", DPS = 30, Infliction = 0, Type = "melee",Price = 7000 },
	["weapon_zs_melee_chainsaw"]  = { Name = "Chain SAW!", DPS = 30, Infliction = 0, Type = "melee" },

	--Pistols
	["weapon_zs_fiveseven"]  = { Name = "Five-Seven",Mat = "VGUI/gfx/VGUI/fiveseven", DPS = 91, Infliction = 0.15, Type = "pistol", Price = 6000 },
	["weapon_zs_glock3"]  = { Name = "Glock", DPS = 120,Mat = "VGUI/gfx/VGUI/glock18", Infliction = 0.25, Type = "pistol", Price = 6000 },
	["weapon_zs_elites"]  = { Name = "Dual-Elites", DPS = 92,Mat = "VGUI/gfx/VGUI/elites", Infliction = 0.25, Type = "pistol", Price = 6000 },
	["weapon_zs_magnum"]  = { Name = ".357 Magnum", DPS = 121, Infliction = 0.3, Type = "pistol", Price = 6000 },
	["weapon_zs_deagle"]  = { Name = "Desert Eagle",Mat = "VGUI/gfx/VGUI/deserteagle", DPS = 93, Infliction = 0.2, Type = "pistol", Price = 6000 },
	
	["weapon_zs_usp"]  = { Name = "USP .45", DPS = 42,Mat = "VGUI/gfx/VGUI/usp45", Infliction = 0, Type = "pistol", Price = 6000 },
	["weapon_zs_p228"]  = { Name = "P228", DPS = 58,Mat = "VGUI/gfx/VGUI/p228", Infliction = 0, Type = "pistol", Price = 6000 },
	["weapon_zs_classic"]  = { Name = "'Classic' Pistol", DPS = 30, Infliction = 0.25, Type = "pistol", Price = 6000 },
	["weapon_zs_alyx"]  = { Name = "Alyx Gun", DPS = 30, Infliction = 0.25, Type = "pistol",Price = 5000 },
	
	--Light Guns
	["weapon_zs_p90"]  = { Name = "P90", DPS = 125,Mat = "VGUI/gfx/VGUI/p90", Infliction = 0.65, Type = "smg", Price = 6000 },
	["weapon_zs_ump"]  = { Name = "UMP", DPS = 110,Mat = "VGUI/gfx/VGUI/ump45", Infliction = 0.60, Type = "smg", Price = 6000 },
	["weapon_zs_mp5"]  = { Name = "MP5", DPS = 127,Mat = "VGUI/gfx/VGUI/mp5", Infliction = 0.58, Type = "smg", Price = 6000 },
	["weapon_zs_tmp"]  = { Name = "Silent TMP", DPS = 107,Mat = "VGUI/gfx/VGUI/tmp", Infliction = 0.56, Type = "smg", Price = 6000 },
	["weapon_zs_mac10"]  = { Name = "Mac 10", DPS = 126,Mat = "VGUI/gfx/VGUI/mac10", Infliction = 0.60, Type = "smg", Price = 6000 },
	["weapon_zs_scout"]  = { Name = "Scout Sniper", DPS = 40,Mat = "VGUI/gfx/VGUI/scout", Infliction = 0, Type = "rifle", Price = 6000 },

			
	--Medium Guns
	
	--["weapon_zs_g3sg1"]  = { Name = "G3-SG1", DPS = 106,Mat = "VGUI/gfx/VGUI/g3sg1", Infliction = 0.51, Type = "rifle", Price = 1600 },
	["weapon_zs_famas"]  = { Name = "Famas", DPS = 140,Mat = "VGUI/gfx/VGUI/famas", Infliction = 0.7, Type = "rifle", Price = 6000 },
	--["weapon_zs_sg552"]  = { Name = "SG552 Rifle", DPS = 106,Mat = "VGUI/gfx/VGUI/sg552", Infliction = 0.51, Type = "rifle", Price = 750 },
	["weapon_zs_galil"]  = { Name = "Galil", DPS = 129,Mat = "VGUI/gfx/VGUI/galil", Infliction = 0.57, Type = "rifle", Price = 6000 },
	["weapon_zs_sg550"]  = { Name = "SG550", DPS = 106,Mat = "VGUI/gfx/VGUI/sg550", Infliction = 0.51, Type = "rifle", Price = 6000 },
	["weapon_zs_ak47"]  = { Name = "AK-47", DPS = 133,Mat = "VGUI/gfx/VGUI/ak47", Infliction = 0.7, Type = "rifle", Price = 6000 },
	["weapon_zs_m4a1"]  = { Name = "M4A1", DPS = 138,Mat = "VGUI/gfx/VGUI/m4a1", Infliction = 0.65, Type = "rifle", Price = 6000 },
	["weapon_zs_aug"]  = { Name = "Steyr AUG", DPS = 125,Mat = "VGUI/gfx/VGUI/aug", Infliction = 0.53, Type = "rifle", Price = 6000 },
	
	--Heavy
	--["weapon_zs_m3super90"]  = { Name = "M3-Super90 Shotgun", DPS = 149,Mat = "VGUI/gfx/VGUI/m3", Infliction = 0,Class = "Support", Type = "shotgun", Price = 6000},
	["weapon_zs_m3super90"]  = { Name = "M3-Super90 Shotgun", DPS = 149,Mat = "VGUI/gfx/VGUI/m3", Infliction = 0,Class = "Support", Type = "pistol", Price = 6000},
	["weapon_zs_m249"]  = { Name = "M249", DPS = 200,Mat = "VGUI/gfx/VGUI/m249", Infliction = 0.85, Type = "rifle", Price = 6000 },
	--["weapon_zs_m1014"]  = { Name = "M1014 Auto-Shotgun", DPS = 246,Mat = "VGUI/gfx/VGUI/xm1014", Infliction = 0.85, Type = "shotgun", Price = 6000},
	["weapon_zs_m1014"]  = { Name = "M1014 Auto-Shotgun", DPS = 246,Mat = "VGUI/gfx/VGUI/xm1014", Infliction = 0.85, Type = "pistol", Price = 6000},
	["weapon_zs_awp"]  = { Name = "AWP", DPS = 200,Mat = "VGUI/gfx/VGUI/awp", Infliction = 0, Class = "Berserker", Type = "rifle", Price = 6000 },
	["weapon_zs_grenadelauncher"]  = { Name = "Grenade Launcher", DPS = 215, Infliction = 0.85, Type = "shotgun", Price = 6000 },
	["weapon_zs_boomerstick"]  = { Name = "Boom Stick", DPS = 215, Infliction = 0.85, Type = "shotgun", Price = 6000 },
	["weapon_zs_crossbow"]  = { Name = "Crossbow", DPS = 220, Infliction = 0, Class = "Medic", Type = "rifle"},
	

	--Uncategorized
	--["weapon_zs_minishotty"]  = { Name = "'Farter' Shotgun", DPS = 126, Infliction = 0, Type = "shotgun" },
	["weapon_zs_fists"]  = { Name = "Fists", DPS = 30, Infliction = 0, Restricted = true, Type = "melee" },
	["weapon_zs_fists2"]  = { Name = "Fists", DPS = 30, Infliction = 0, Restricted = true, Type = "melee" },
	["weapon_zs_shotgun"]  = { Name = "Shotgun", DPS = 215, Infliction = 0.85, Type = "shotgun" }, -- 860
	["weapon_zs_pulsesmg"]  = { Name = "Pulse SMG", DPS = 99, Infliction = 0, Type = "misc",},
	["weapon_zs_pulserifle"]  = { Name = "Pulse Rifle", DPS = 143, Infliction = 0, Type = "rifle" },
	["weapon_zs_dubpulse"]  = { Name = "Super Pulse Rifle", DPS = 143, Infliction = 0, Type = "rifle" }, --Seems to work fine now.
	["weapon_zs_flaregun"]  = { Name = "Flare Gun", DPS = 143, Infliction = 0, Type = "rifle" },
	["weapon_zs_minishotty"]  = { Name = "Farter shotgun", DPS = 143, Infliction = 0, Type = "shotgun" },
	["weapon_zs_chipper"]  = { Name = "Chipper", DPS = 143, Infliction = 0, Type = "shotgun" },
	["weapon_zs_python"]  = { Name = "Python", DPS = 143, Infliction = 0, Type = "pistol" },
	
	
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
--	["pistol"]  = { Name = "12 Pistol Bullets", Model = "models/Items/BoxSRounds.mdl", Amount = 12, Price = 20},
	--["357"]  = { Name = "6 Sniper Bullets", Model = "models/Items/357ammo.mdl", Amount = 6, Price = 35},
	--["smg1"]  = { Name = "30 SMG Bullets", Model = "models/Items/BoxMRounds.mdl", Amount = 30, Price = 25},
--	["ar2"]  = { Name = "30 Rifle Bullets", Model = "models/Items/combine_rifle_cartridge01.mdl", Amount = 35, Price = 30},
--	["buckshot"]  = { Name = "12 Shotguns Shells", Model = "models/Items/BoxBuckshot.mdl", Amount = 12, Price = 30},
--	["slam"]  = { Name = "Refill 1 explosive", Model = "models/Items/BoxBuckshot.mdl",Tool = "weapon_zs_mine", Amount = 1, Price = 60, ToolTab = true},
--	["grenade"]  = { Name = "Refill 1 grenade", Model = "models/Items/BoxBuckshot.mdl",Tool = "weapon_zs_grenade", Amount = 1, Price = 70, ToolTab = true},
	--["gravity"]  = { Name = "Refill 1 nail", Model = "models/Items/BoxBuckshot.mdl",Tool = "weapon_zs_tools_hammer", Amount = 1, Price = 30, ToolTab = true},
	--["Battery"]  = { Name = "Refill 30 charge for Medkit", Model = "models/Items/BoxBuckshot.mdl", Amount = 30, Price = 35, ToolTab = true},
}


----------------------------------
--		AMMO REGENERATION		--
----------------------------------
-- This is how much ammo a player is given for whatever type it is on ammo regeneration.
-- Players are given double these amounts if 75% or above Infliction.
-- Changing these means you're an idiot.
-- Duby: This is confusing when it has this name... Its the amount of ammo which the crate gives out. :P

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
XP_BLANK = 1000

XP_INCREASE_BY = 1000

XP_PLAYERS_REQUIRED = 5

MAX_RANK = 30

-- -- -- -- -- -- -- -- -- -- /
-- [rank] = {unlocks}
GM.RankUnlocks = {
	[0] = {"weapon_zs_usp","weapon_zs_fists2","weapon_zs_tools_hammer2","_nailhp","_sboost2","_kevlar3","_comeback2","weapon_zs_medkit"},
	[1] = {"weapon_zs_melee_plank","weapon_zs_python"},
	[2] = {"weapon_zs_p228","weapon_zs_tools_supplies"},
	[3] = {"_kevlar","weapon_zs_melee_keyboard"},
	[4] = {"weapon_zs_grenade"},
	[5] = {"_imortalpro","_kevlar2"},
	[6] = {"weapon_zs_melee_pipe"},
	[7] = {"_nailamount"},
	[9] = {"_sboost"},
	[10] = {"_comeback","_falldmg"},
	[11] = {"weapon_zs_mine"},
	[13] = {"_adrenaline"},
	[14] = {"_poisonprotect"},
	[15] = {"weapon_zs_turretplacer"},
	[16] = {"weapon_zs_tools_remote"},
	[17] = {"_turretoverdrive","weapon_zs_melee_pipe2"},
	[18] = {"_medupgr1"},
	[19] = {"weapon_zs_melee_combatknife"},
	[20] = {"weapon_zs_tools_plank"},
	[21] = {"weapon_zs_classic"},
	[22] = {"_enhkevlar"},
	[23] = {"_medupgr2"},
	[24] = {"_plankamount"},
	[25] = {"weapon_zs_melee_pot"},
	[26] = {"_plankhp"},
	[27] = {"_freeman"},
	[28] = {"weapon_zs_miniturret"},
	[29] = {"weapon_zs_melee_crowbar"},
	[30] = {"weapon_zs_melee_hook"},
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
	--["_turretammo"] = {Name = "Turret Ammo", Description = "50% more ammo for turret", Slot = 2},
	--["_turrethp"] = {Name = "Turret Durability", Description = "50% more health for turret", Material = "VGUI/gfx/VGUI/defuser", Slot = 2},
	--["_turretdmg"] = {Name = "Turret Power", Description = "50% more turret's damage", Slot = 2},
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
	--["_trchregen"] = {Name = "Handy Man", Description = "Increased regeneration rate for torch", Material = "HUD/scoreboard_clock", Slot = 2},
	["_trchregen"] = {Name = "Handy Man", Description = "40% increased repair with hammer", Material = "HUD/scoreboard_clock", Slot = 2},
	["_comeback"] = {Name = "Comeback", Description = "When you redeem you will spawn either with a P90 or a M4Al! (Only once.)", Slot = 1},
	["_professional"] = {Name = "Professional", Description = "This perk has no effect yet!", Material = "VGUI/logos/spray_elited", Slot = 1},
	["_plankamount"] = {Name = "Extra Plank", Description = "Ability to carry one more plank!", Slot = 2},
	["_plankhp"] = {Name = "Stronger Planks", Description = "30% more health for planks", Slot = 2},
	["_imortalpro"] = {Name = "Immortal Protector!", Description = "You will spawn with the legendary Pulse SMG!", Slot = 1},
	["_turretoverdrive"] = {Name = "Turret Overdrive!", Description = "Your turret has had an upgrade!", Material = "VGUI/gfx/VGUI/defuser", Slot = 2},
	
	["_sboost2"] = {Name = "Running Shoes", Description = "5% faster!", Slot = 1},
	["_kevlar3"] = {Name = "Light Kevlar", Description = "Gives you 5 more HP",Material = "VGUI/gfx/VGUI/kevlar", Slot = 1},
	["_comeback2"] = {Name = "Reborn", Description = "When you redeem you will spawn either with a deagal or a pair of duel elites! (Only once.)", Slot = 1},
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
UNDEAD_START_AMOUNT_MINIMUM = 2

-- Good values are 1 to 3. 0.5 is about the same as the default HL2. 1 is about ZS difficulty. This is mainly for NPC healths and damages.
DIFFICULTY = 1.5

-- Humans can not carry OR drag anything heavier than this (in kg.)
--CARRY_MAXIMUM_MASS = 300
--CARRY_MAXIMUM_MASS = 60
CARRY_MAXIMUM_MASS = 120

-- Objects with more mass than this will be dragged instead of carried.
--CARRY_DRAG_MASS = 145
--CARRY_DRAG_MASS = 130
CARRY_DRAG_MASS = 60

-- Anything bigger than this is dragged regardless of mass.
--CARRY_DRAG_VOLUME = 120
--CARRY_DRAG_VOLUME = 80
--CARRY_DRAG_VOLUME = 60
CARRY_DRAG_VOLUME = 80

-- Humans can not carry anything with a volume more than this (OBBMins():Length() + OBBMaxs():Length()).
--CARRY_MAXIMUM_VOLUME = 150
--CARRY_MAXIMUM_VOLUME = 100
CARRY_MAXIMUM_VOLUME = 120

-- Humans are slowed by this amount per kg carried.
CARRY_SPEEDLOSS_PERKG = 1.3

-- But never slower than this.
CARRY_SPEEDLOSS_MINSPEED = 88

-- -- -- -- -- -- -- -- /

-- Maximum crates per map
MAXIMUM_CRATES = math.random(2, 2)

-- Use Zombie Survival's custom footstep sounds? I'm not sure how bad it might lag considering you're potentially sending a lot of data on heavily packed servers.
CUSTOM_FOOTSTEPS = true


-- In seconds, repeatatively, the gamemode gives all humans get a box of whatever ammo of the weapon they use.
AMMO_REGENERATE_RATE = 2056744

--Warming up time
WARMUPTIME = 110

-- In seconds, how long humans need to survive.
--ROUNDTIME = (20*60) + WARMUPTIME -- 20 minutes
ROUNDTIME = (25*60) + WARMUPTIME -- 20 minutes
--ROUNDTIME = (5*60) + WARMUPTIME -- 5 minutes 'testing'

-- Time in seconds between end round and next map.
INTERMISSION_TIME = 46

--Amount of time players have to vote for next map(seconds)
VOTE_TIME = 18

--Set this to true to destroy all brush-based doors that aren't based on phys_hinge and func_physbox or whatever. For door campers.
DESTROY_DOORS = true

--Prop freezing manage module
PROP_MANAGE_MODULE = false

--Set this to true to destroy all prop-based doors. Not recommended since some doors have boards on them and what-not. Only for true door camping whores.
DESTROY_PROP_DOORS = true

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
--RTD_TIME = 1



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
--MAPS_RANDOMIZER = false
MAPS_RANDOMIZER = true

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
		* Guns for kills. It is what it says on the tin! ^^
		
		> Where I can buy hats?
		* GreenCoins Shop. Type !shop in chat to open it.
		
		> How to use hammer?
		* Right click to nail a prop to something. (Read the screen!)
		
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
@
@
@Ammo - Go to the crate and press 'e' when the timer is up!
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
@	- "leeroy"
@	- "get down"
@ 	- "ok"
@ 	- Ask an admin for '!ravebreak' ^^
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

--HumanClasses = { } --Duby: Leave this table as it will cause errors in sv_tables.lua and in the init.lua. I will deal with it soon!
					 --Duby: Removed it, seems ok. I removed a load of stuff in sv_playerspawn and obj_player_extended and also sv_tables.

--HumanClasses[1] =
--{
	--Name = "Medic",
	--Tag = "medic",
	--Health = 95,
	--Description = {"% more damage with pistols","% more heal on teammates","% increased speed","% less damage taken"},
	--Coef = {2,10,2,5},
	--Models = {"models/player/group03/male_02.mdl","models/player/group03/Male_04.mdl","models/player/group03/male_06.mdl","models/player/group03/male_07.mdl"},
	--Speed = 200,
--}

--HumanClasses[2] =
--{
	--Name = "Commando",
	--Tag = "commando",
	--Health = 100,
	--Description = {"% increased rifle magazine size","% more health","% chance to spawn with rifle","Can see health of zombies and ethereals"},
	--Coef = {5,2,3,""},
	--Models = {"models/player/combine_soldier.mdl","models/player/combine_soldier_prisonguard.mdl","models/player/combine_super_soldier.mdl","models/player/police.mdl" },
	--Speed = 190,
--}

--HumanClasses[3] =
--{
	--Name = "Berserker",--Aka Marksman
	--Tag = "marksman",
	--Health = 90,
	--Description = {"% increased scope zoom","% chance to spawn with scout","% more bullet force"," more long range hs dmg"},
	--Coef = {7,3,18,4},
	--Models = {"models/player/gasmask.mdl","models/player/odessa.mdl","models/player/group01/male_04.mdl","models/player/hostage/hostage_02.mdl"},
	--Speed = 200
--}

--HumanClasses[4] =
--{
	--Name = "Engineer",
--	Health = 100,
	--Description = {"% chance to spawn with turret","% increased clip for pulse weapons","% chance to spawn with pulse smg","% more turret's efficiency"},
	--Models = {"models/player/alyx.mdl","models/player/barney.mdl","models/player/eli.mdl","models/player/mossman.mdl","models/player/kleiner.mdl","models/player/breen.mdl" },
	--Speed = 190
	---}

--HumanClasses[5] =
--{
--	Name = "Support",
--	Tag = "support",
	--Health = 90,
--	Description = {"% increased smg damage.","% chance to spawn with smg","% chance to spawn with mobile supplies","more nail(s) for the hammer"},
--	Coef = {5,3,12,1},
--	Models = {"models/player/arctic.mdl","models/player/leet.mdl","models/player/guerilla.mdl","models/player/phoenix.mdl","models/player/riot.mdl","models/player/swat.mdl","models/player/urban.mdl" },
	--Speed = 200
--}
	
	-- Human Class Description Tables
	--ClassInfo = { }
--	ClassInfo[1] = { }
	--ClassInfo[1].Ach = { }
--	ClassInfo[1].Ach[1] = {"Heal 10k hp", "Open 100 supply crates",10000,100}  -- What you need to do to get from level 0 to 1!
--	ClassInfo[1].Ach[2] = {"Heal 20k hp", "Open 250 supply crates",20000,250} -- What you need to do to get from level 1 to 2!
--	ClassInfo[1].Ach[3] = {"Heal 500 injured people", "Heal 1000 hp from supply crates",500,1000}
--	ClassInfo[1].Ach[4] = {"Heal 1000 injured people", "Heal 2100 hp from supply crates",1000,2100}
--	ClassInfo[1].Ach[5] = {"Heal 400 infected people", "Survive 150 rounds",400,150}
--	ClassInfo[1].Ach[6] = {"Heal 900 infected people", "Survive 300 rounds",900,300}
--	ClassInfo[1].Ach[7] = {"All Done", "All Done",4500,300}
	
--	ClassInfo[2] = { }
--	ClassInfo[2].Ach = { }
--	ClassInfo[2].Ach[1] = {"Dismemberment 600 undead", "Do 150k dmg to undead",600,150000} -- 0 
--	ClassInfo[2].Ach[2] = {"Dismemberment 2000 undead", "Do 300k dmg to undead",2000,300000} -- 1  
--	ClassInfo[2].Ach[3] = {"Kill 300 howlers with rifle", "Kill 1500 zombies with rifle",300,1500} -- 2
--	ClassInfo[2].Ach[4] = {"Kill 600 howlers with rifle", "Kill 3000 zombies with rifle",600,3000} -- 3
--	ClassInfo[2].Ach[5] = {"Open 500 supply crates", "Survive 150 rounds",500,150} -- 4
--	ClassInfo[2].Ach[6] = {"Open 1200 supply crates", "Survive 300 rounds",1200,300} --5
--	ClassInfo[2].Ach[7] = {"All Done", "All Done",500,300}
	
	
--	ClassInfo[3] = { }
--	ClassInfo[3].Ach = { }
--	ClassInfo[3].Ach[1] = {"Get 1000 headshots", "Deal 170k sniper damage",1000,170000}
--	ClassInfo[3].Ach[2] = {"Get 2500 headshots", "Deal 450k sniper damage",2500,450000}
--	ClassInfo[3].Ach[3] = {"Deal 200k headshot damage", "Kill 1500 zombies",200000,1500}
--	ClassInfo[3].Ach[4] = {"Deal 600k headshot damage", "Kill 4000 zombies",600000,4000}
--	ClassInfo[3].Ach[5] = {"Get 700 long range headshots", "Survive 150 rounds",1337,150}
--	ClassInfo[3].Ach[6] = {"Get 1337 long range headshots", "Survive 300 rounds",4000,300}
--	ClassInfo[3].Ach[7] = {"All Done", "All Done",15000,300}
	
	
--	ClassInfo[4] = { }
--	ClassInfo[4].Ach = { }
--	ClassInfo[4].Ach[1] = {"Deploy 20 turrets", "Deploy 150 tripmines",20,150}
--	ClassInfo[4].Ach[2] = {"Deploy 60 turrets", "Deploy 350 tripmines",60,350}
--	ClassInfo[4].Ach[3] = {"Kill 600 undead with mine", "Deal 200k mine damage",600,200000} --
--	ClassInfo[4].Ach[4] = {"Kill 850 undead with mine", "Deal 500k mine damage",850,500000} --
--	ClassInfo[4].Ach[5] = {"Deal 250k damage with pulse", "Survive 150 rounds",250000,150}
--	ClassInfo[4].Ach[6] = {"Deal 500k damage with pulse", "Survive 300 rounds",500000,300}
--	ClassInfo[4].Ach[7] = {"All Done", "All Done",500000,300}
	
--	ClassInfo[5] = { }
--	ClassInfo[5].Ach = { }
--	ClassInfo[5].Ach[1] = {"Take 25000 ammo from supply crates", "Nail 150 props",25000,150}
--	ClassInfo[5].Ach[2] = {"Take 100k ammo from supply crates", "Nail 400 props",100000,400}
--	ClassInfo[5].Ach[3] = {"Deal 150k dmg with smg", "Open 300 supply crates",150000,300}
--	ClassInfo[5].Ach[4] = {"Deal 300k dmg with smg", "Open 1100 supply crates",300000,1100}
--	ClassInfo[5].Ach[5] = {"Deal 200k dmg with shotgun", "Survive 150 rounds",200000,150}
--	ClassInfo[5].Ach[6] = {"Deal 400k dmg with shotgun", "Survive 300 rounds",400000,300}
--	ClassInfo[5].Ach[7] = {"All Done", "All Done",400000,300}

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
	[48] = { Image = "zombiesurvival/achv_blank_zs", Key = "klinator", ID = 48, Name = "'Kill the Cyber Nerd!'", Desc = "Kill the lost kliener and see what happens..",  },
	[49] = { Image = "zombiesurvival/achv_blank_zs", Key = "smoker", ID = 49, Name = "'From the smoke a hero arises!'", Desc = "Kill what blinds you!",  },
	[50] = { Image = "zombiesurvival/achv_blank_zs", Key = "lilith", ID = 50, Name = "'Screaming bitch!'", Desc = "Kill the boss which is on its period.",  },
	[51] = { Image = "zombiesurvival/achv_blank_zs", Key = "seekerII", ID = 51, Name = "'Hide'n'Seek reborn!'", Desc = "Return of an old evil in a new form!",  },
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

--Moved into zs_shop.lua
--Duby:Having one big ass file to run everything from is very inefficient. :P

--[=[-------------------------------
		Voice sets and/or sound tables
---------------------------------]=]


STATE_WARMUP = 0
STATE_GAME = 1
STATE_INTERMISSION = 2