-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

GM.Version  = "Green Apocalypse"
GM.SubVersion = ""

function ToMinutesSeconds(TimeInSeconds)
	local iMinutes = math.floor(TimeInSeconds / 60)
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

if SERVER and tobool(string.find(tostring(game.GetMap()),"zs_arena")) then
	GM:SetGameMode(GAMEMODE_ARENA)
end

DEFAULT_VIEW_OFFSET = Vector(0, 0, 64)
DEFAULT_VIEW_OFFSET_DUCKED = Vector(0, 0, 28)
DEFAULT_JUMP_POWER = 160
DEFAULT_STEP_SIZE = 18
DEFAULT_MASS = 80
DEFAULT_MODELSCALE = 1-- Vector(1, 1, 1)

-- Movement stuff

-- 1 to 0, higher means less penality.
SPEED_PENALTY = 0.60

SPEED = 195
SPEED_LIGHT = SPEED - 2
SPEED_MELEE_LIGHT = SPEED - 3
SPEED_MELEE = SPEED - 10
SPEED_MELEE_HEAVY = SPEED - 23
SPEED_PISTOL = SPEED - 9
SPEED_SMG = SPEED - 20
SPEED_SHOTGUN = SPEED - 32
SPEED_RIFLE = SPEED - 30
SPEED_HEAVY = SPEED - 33

-- Horde stuff
HORDE_MAX_ZOMBIES = 8		--It's meant for creating hordes, doesnt make sense for a zombie to be in a horde if they're across the map.
HORDE_MAX_DISTANCE = 800 --Leave this! It affects the beats and how they play. They play best as this number, do not touch it Pufu!

BONUS_RESISTANCE_WAVE = 5
BONUS_RESISTANCE_AMOUNT = 20 -- %

--EVENT: Halloween
HALLOWEEN = false

--EVENT: Christmas
CHRISTMAS = false

--EVENT: Aprils Fools
FIRSTAPRIL = false

NECROMOD = true


--Boss stuff
BOSS_TOTAL_PLAYERS_REQUIRED = 10
BOSS_CLASS = {11}
--BOSS_CLASS = {16} --Lilith
--BOSS_CLASS = {10} --hate
--BOSS_CLASS = {18} --Seeker2
--BOSS_CLASS = {11} --Behemoth
--BOSS_CLASS = {20} --HateII
--BOSS_CLASS = {13} --Nerf


SHARED_SPEED_INCREASE = 13
----------------------------------
--		STARTING LOADOUTS		--
----------------------------------

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
		[350] = "[Dr. Zombo]",
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
        --Berserker
        ["weapon_zs_deagle"]  = { Name = "Desert Eagle", Tier = 0, Type = "pistol", Price = 50, HumanClass = "berserker"},	
        ["weapon_zs_melee_stunstick"]  = { Name = "Stun Stick", Tier = 1, Type = "melee", Price = 50, HumanClass = "berserker" },			
        ["weapon_zs_melee_hook"]  = { Name = "Meat Hook", Tier = 0, Type = "melee", Price = 60, HumanClass = "berserker" },  
        ["weapon_zs_melee_pipe2"]  = { Name = "Lead Pipe", Tier = 1, Type = "melee", Price = 60, HumanClass = "berserker"  },		
        ["weapon_zs_melee_axe"]  = { Name = "Axe", Tier = 2, Type = "melee", Price = 100, HumanClass = "berserker" },	
        ["weapon_zs_melee_sledgehammer"]  = { Name = "Sledgehammer", Tier = 2, Type = "melee", Price = 150, HumanClass = "berserker" },
        ["weapon_zs_melee_katana"]  = { Name = "Katana", Tier = 3, Type = "melee", Price = 160 , HumanClass = "berserker"},
        ["weapon_zs_melee_chainsaw"]  = { Name = "Chainsaw", Tier = 4, Type = "melee", Price = 180, HumanClass = "berserker" },   
       
        --Commando
        ["weapon_zs_defender"]  = { Name = "Defender", Tier = 0, Type = "rifle", Price = 80,HumanClass = "commando"},    
        ["weapon_zs_famas"]  = { Name = "Famas", Tier = 1, Type = "rifle", Price = 100, HumanClass = "commando" },
        ["weapon_zs_sg552"]  = { Name = "SG552", Tier = 1, Type = "rifle", Price = 100, HumanClass = "commando" },
        ["weapon_zs_m4a1"]  = { Name = "M4A1", Tier = 2, Type = "rifle", Price = 130, HumanClass = "commando" },
        ["weapon_zs_aug"]  = { Name = "Steyr AUG", Tier = 2, Type = "rifle", Price = 130, HumanClass = "commando" }, 		
        ["weapon_zs_ak47"]  = { Name = "AK47", Tier = 3, Type = "rifle", Price = 180, HumanClass = "commando" },         
        ["weapon_zs_galil"]  = { Name = "Galil", Tier = 3, Type = "rifle", Price = 150, HumanClass = "commando" }, 
        ["weapon_zs_m249"]  = { Name = "M249", Tier = 4, Type = "rifle", Price = 200, HumanClass = "commando" },  		
		
        --Support
        ["weapon_zs_shotgun"]  = { Name = "Shotgun", Tier = 1, Type = "shotgun", Price = 80, HumanClass = "support" },	
        ["weapon_zs_smg"]  = { Name = "SMG", Tier = 1, Type = "smg", Price = 80, HumanClass = "support"},
        ["weapon_zs_chipper"]  = { Name = "Chipper", Tier = 2, Price = 120, Type = "shotgun", HumanClass = "support" },       		
        ["weapon_zs_mac10"]  = { Name = "Mac 10", Tier = 2, Type = "smg", Price = 120, HumanClass = "support" },   
        ["weapon_zs_ump"]  = { Name = "UMP", Tier = 3, Type = "smg", Price = 140, HumanClass = "support" },
        ["weapon_zs_m3super90"]  = { Name = "M3", Tier = 3, Type = "shotgun", Price = 160, HumanClass = "support"}, 		
        ["weapon_zs_p90"]  = { Name = "P90", Tier = 4, Type = "smg", Price = 160, HumanClass = "support" },
        ["weapon_zs_m1014"]  = { Name = "M1014", Tier = 4, Type = "shotgun", Price = 190, HumanClass = "support"},		
    
	    ["weapon_zs_mp5"]  = { Name = "MP5 Navy", Tier = 0, Type = "smg", Price = 80, HumanClass = "support" },
	
        --Medic
        ["weapon_zs_medi2"]  = { Name = "Medi 2", Tier = 2, Type = "shotgun",Price = 100, Description = "Ranged medkit that can also shoot zombies!", HumanClass = "medic"},           
		["weapon_zs_medi1"]  = { Name = "Medi 1", Tier = 1, Type = "pistol",Price = 80, Description = "Ranged medkit that can also shoot zombies!", HumanClass = "medic"}, 
        ["weapon_zs_medi3"]  = { Name = "Medi 3", Tier = 3, Type = "smg",Price = 160, Description = "Ranged medkit that can also shoot zombies!", HumanClass = "medic"}, 
        ["weapon_zs_medi4"]  = { Name = "Medi 4", Tier = 4, Type = "rifle",Price = 180, Description = "Ranged medkit that can also shoot zombies!", HumanClass = "medic"}, 
		
        ["weapon_zs_elites"]  = { Name = "Dual Elites", Type = "pistol", Price = 120},
       
        --Sharpshooter
        ["weapon_zs_musket"]  = { Name = "Musket", Tier = 1, Type = "rifle", Description = "Somehow still works.", Price = 100, HumanClass = "sharpshooter"},    
        ["weapon_zs_annabelle"]  = { Name = "Annabelle", Tier = 3, Type = "rifle", Price = 160, HumanClass = "sharpshooter"},   		
        ["weapon_zs_python"]  = { Name = "Python", Tier = 1, Price = 80, Type = "pistol", HumanClass = "sharpshooter"},       
        ["weapon_zs_scout"]  = { Name = "Scout", Tier = 2, Type = "rifle", Price = 120, Description = "Light-weight sniper.", HumanClass = "sharpshooter" }, 
		["weapon_zs_magnum"]  = { Name = ".357 Magnum", Tier = 2, Type = "pistol", Price = 100, Description = "Russian Roulette Revolver", HumanClass = "sharpshooter" },		
        ["weapon_zs_sg550"]  = { Name = "SG550", Tier = 3, Type = "rifle", Price = 160, HumanClass = "sharpshooter"  },
        ["weapon_zs_g3sg1"]  = { Name = "G3SG1", Tier = 4, Type = "rifle", Price = 180, HumanClass = "sharpshooter"  },
        ["weapon_zs_awp"]  = { Name = "AWP", Tier = 4, Type = "rifle", Price = 180, Description = "Heavy sniper.", HumanClass = "sharpshooter" },     
       
	   
        --Engineer
        ["weapon_zs_pulsepistol"]  = { Name = "Pulse Pistol", Tier = 1, Type = "pistol", Price = 80, HumanClass = "engineer"},                      
        ["weapon_zs_pulsesmg"]  = { Name = "Pulse SMG", Tier = 2, Type = "smg", Price = 120, HumanClass = "engineer"},
		["weapon_zs_turretplacer"] = { Name = "Turret", Tier = 3, Type = "tool2", Price = 140, HumanClass = "engineer"   },	
        ["weapon_zs_pulserifle"]  = { Name = "Pulse Rifle", Tier = 3, Type = "smg", Price = 150, HumanClass = "engineer"},
        ["weapon_zs_railgun"]  = { Name = "Railgun", Tier = 4, Type = "rifle", Price = 180, HumanClass = "engineer"},
 
		--Pyro
        ["weapon_zs_alyx"]  = { Name = "Alyx Gun", Tier = 0, Type = "pistol", Price = 60}, 
        ["weapon_zs_glock3"]  = { Name = "Glock 3", Tier = 1, Type = "pistol", Price = 80, HumanClass = "pyro" },		
        ["weapon_zs_glock1"]  = { Name = "Glock 1", Tier = 0, Type = "pistol", Price = 80, HumanClass = "pyro" },		
		["weapon_zs_flaregun"]  = { Name = "Flare Gun", Tier = 2, Type = "shotgun", HumanClass = "pyro", Price = 120},
		["weapon_zs_flaregun_2"]  = { Name = "Baby Flare", Tier = 2, Type = "shotgun", HumanClass = "pyro", Price = 120},

		["weapon_zs_tmp"]  = { Name = "Silent TMP", Tier = 3, Type = "smg", HumanClass = "pyro", Price = 120 },		
		["weapon_zs_pyroshotgun"]  = { Name = "Dragon's Breath", Tier = 3, Type = "shotgun", HumanClass = "pyro", Price = 160},	
		["weapon_zs_pyrocannon"]  = { Name = "'Infernus' Cannon", Tier = 4, Type = "shotgun", HumanClass = "pyro", Price = 180},			
		["weapon_zs_flamer"]  = { Name = "Flare Gun", DPS = 143, Infliction = 0, Type = "rifle", HumanClass = "pyro"},
		["weapon_zs_firebomb"]  = { Name = "Flame Nade", DPS = 143, Infliction = 0, HumanClass = "pyro"},
		
        --Loadout Guns
        ["weapon_zs_fiveseven"]  = { Name = "Five SeveN", DPS = 91, Infliction = 0.15, Type = "pistol", Price = 50, HumanClass = "medic"},       
        ["weapon_zs_barreta"]  = { Name = "Barreta", DPS = 30, Infliction = 0.25, Type = "pistol", Price = 50, HumanClass = "medic"},            
        ["weapon_zs_usp"]  = { Name = "USP .45", DPS = 42, Infliction = 0, Type = "pistol", Description = "It's practical!", Price = 50 , HumanClass = "medic"},
        ["weapon_zs_p228"]  = { Name = "P228", DPS = 58, Infliction = 0, Type = "pistol", Description = "More accuracy but less fire power compared to the USP." , Price = 50, HumanClass = "medic"},   
        ["weapon_zs_melee_plank"]  = { Name = "Plank", DPS = 56, Infliction = 0, Type = "melee", Description = "The noobs ultimate weapon.", Price = 50, HumanClass = "berserker"  },                
        ["weapon_zs_melee_combatknife"]  = { Name = "Combat Knife", DPS = 15, Infliction = 0, Type = "melee", Price = 50 , HumanClass = "berserker" },
        ["weapon_zs_classic"]  = { Name = "Pistol", DPS = 30, Infliction = 0.25, Type = "pistol", Description = "Classic.", Price = 50, HumanClass = "medic" },
 
 
        --Loadout Tools 1
        ["weapon_zs_tools_hammer"]  = { Name = "Hammer", DPS = 23, Infliction = 0, Type = "tool1", Description = "Stop! Hammer time. This will freeze props in their place. Primary to repair/whack, Secondary to nail.", HumanClass = "support" , Price = 100 },
        ["weapon_zs_medkit"]  = { Name = "Medical Kit", DPS = 8, Infliction = 0, Type = "tool1", Description = "Be a good teammate. Or just heal yourself.", Price = 160, HumanClass = "medic"  },
        ["weapon_zs_tools_supplies"] = { Name = "Mobile Supplies", DPS = 0, Infliction = 0, Type = "tool2", Description = "Allows you to spawn a Supply Crate.", Price = 100 },
		
		
		  --Loadout Tools 2
        ["weapon_zs_tools_remote"] = { Name = "Turret Controller", DPS = 0, Infliction = 0, Type = "misc" },
        ["weapon_zs_tools_torch"] = { Name = "Torch", DPS = 0, Infliction = 0, Type = "tool2", Description = "Fix broken nails to prevent barricades getting broken." },       
        ["weapon_zs_miniturret"] = { Name = "Combat Mini-Turret", DPS = 0, Infliction = 0, Type = "tool2", Description = "CBA to shoot, let your friend here help you with that!"  },
        ["weapon_zs_grenade"]  = { Name = "Grenade", DPS = 8, Infliction = 0, Type = "tool1", Description = "Handheld explosives.", Price = 100  },
        ["weapon_zs_mine"]  = { Name = "Proximity C4", DPS = 8, Infliction = 0, Type = "tool1", Description = "BOOM, get your team out a tough spot..", Price = 100  },       
       
	   
        --Special
        ["weapon_zs_melee_crowbar"]  = { Name = "Crowbar", DPS = 85, Infliction = 0.65, Type = "melee", Price = 100 },      
       
        --Map Only
        ["weapon_zs_melee_beer"]  = { Name = "Beer Bottle", DPS = 30, Infliction = 0, Type = "melee", Description = "Alcohol!", Price = 30 },
        ["weapon_zs_melee_chair"]  = { Name = "Chair", Type = "melee", Price = 30 },		
        ["weapon_zs_melee_keyboard"]  = { Name = "Keyboard", DPS = 45, Infliction = 0, Type = "melee", Description = "There's no better way to express your online anger.", Price = 40 },
        ["weapon_zs_melee_pot"]  = { Name = "Pot", DPS = 61, Infliction = 0, Type = "melee", Description = "Don't do school stay in drugs, live the pot!", Price = 40 },
        ["weapon_zs_melee_fryingpan"]  = { Name = "Frying Pan", DPS = 70, Infliction = 0, Type = "melee", Description = "Cooking by the book.", Price = 40 },
        ["weapon_zs_melee_shovel"]  = { Name = "Shovel", DPS = 40, Infliction = 0, Type = "melee", Description = "", Price = 80 },
        ["weapon_zs_melee_pipe"]  = { Name = "Pipe", DPS = 30, Infliction = 0, Type = "melee", Description = "Whoops. Looks like I shouldn't of hit him so hard..", Price = 40  },
       
        --All the other stuff we don't care about right now
        --Heavy
        ["weapon_zs_boomerstick"]  = { Name = "Boom Stick", DPS = 215, Infliction = 0.85, Type = "shotgun" },
        ["weapon_zs_boomstick"]  = { Name = "Boom Stick", DPS = 215, Infliction = 0.85, Type = "shotgun" },
 
        --Uncategorized
        ["weapon_zs_minishotty"]  = { Name = "'Farter' Shotgun", DPS = 126, Infliction = 0, Type = "shotgun" },
        ["weapon_zs_fists"]  = { Name = "Fists", DPS = 30, Infliction = 0, Restricted = true, Type = "melee", Description = "Punch a Zombie in the face." },
        ["weapon_zs_fists2"]  = { Name = "Fists", DPS = 30, Infliction = 0, Restricted = true, Type = "melee" },
     
    
		["weapon_zs_tools_spawner"]  = { Name = "Spawner", Type = "tool2"},
	
       
        --Tool1
        ["weapon_zs_barricadekit"] = { Name = "Agies Barricading kit", DPS = 0, Infliction = 0, Type = "tool1" },
        --Tool2
        ["weapon_zs_tools_plank"]  = { Name = "Board Pack", DPS = 0, Infliction = 0, Type = "tool2", Description = "Help your team mates, bring extra planks!", Price = 60  },
  
        ["weapon_zs_tools_ammobox"]  = { Name = "Ammo Pack", DPS = 0, Infliction = 0, Type = "tool2", Price = 60},  
        --Pickups
        ["weapon_zs_pickup_gascan"]  = { Name = "Dangerous Gas Can", DPS = 0, Infliction = 0, Type = "misc" },
        ["weapon_zs_pickup_gascan2"]  = { Name = "Dangerous Gas Can2", DPS = 0, Infliction = 0, Type = "misc" },
        ["weapon_zs_pickup_propane"]  = { Name = "Dangerous Propane Tank", DPS = 0, Infliction = 0, Type = "misc" },
        ["weapon_zs_pickup_flare"]  = { Name = "Rusty Flare", DPS = 0, Infliction = 0, Type = "misc" },
        ["weapon_zs_pickup_gasmask"]  = { Name = "Old Gas Mask", DPS = 0, Infliction = 0, Type = "misc" },
       
 
        --Special Items
        ["weapon_zs_special_vodka"]  = { Name = "Vodka", DPS = 0, Infliction = 0, Type = "misc", Price = 80 }, --Duby: I essentially wanted to get some interest back into the dice and the game. This did the trick!
        ["weapon_zs_special_bottleofwine"]  = { Name = "Bottle ol Wine", DPS = 0, Infliction = 0, Type = "tool1", Price = 60 },
        ["weapon_zs_special_chembomb"]  = { Name = "Chemical Nade", DPS = 0, Infliction = 0, Type = "misc" },
       
       
        --HL2 weapons
        ["weapon_357"] = { Name = ".357 Original", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
        ["weapon_ar2"] = { Name = "AR2 Rifle", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
        ["weapon_bugbait"] = { Name = "Bugbait", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
        ["weapon_crossbow"] = { Name = "Original Crossbow", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
        ["weapon_crowbar"] = { Name = "Original Crowbar", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
        ["weapon_pistol"] = { Name = "Original Pistol", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
        ["weapon_rpg"] = { Name = "Original RPG", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
        ["weapon_shotgun"] = { Name = "Original Shotgun", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
        ["weapon_slam"] = { Name = "Original Shotgun", DPS = 0, Infliction = 0.2, Type = "tool1", Restricted = false, Price = 40, Tier = 0  },
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


----------------------------------
--		AMMO REGENERATION		--
----------------------------------
-- This is how much ammo a player is given for whatever type it is on ammo regeneration.
-- Players are given double these amounts if 75% or above Infliction.
-- Changing these means you're an idiot.

GM.AmmoRegeneration = {
	["ar2"] = 16, --Rifle
	["alyxgun"] = 22,
	["pistol"] = 12, --Pistol
	["smg1"] = 20, --SMG
	["357"] = 6, --Sniper
	["xbowbolt"] = 12,
	["buckshot"] = 6, --Shotgun
	["ar2altfire"] = 1,
	["slam"] = 1, --Explosive
	["rpg_round"] = 1,
	["smg1_grenade"] = 1,
	["sniperround"] = 0,
	["sniperpenetratedround"] = 5,
	["grenade"] = 1, --Grenade
	["thumper"] = 1,
	["gravity"] = 3, --Nail
	["Battery"] = 20, --Medkit
	["gaussenergy"] = 10,
	["combinecannon"] = 10,
	["airboatgun"] = 100,
	["striderminigun"] = 100,
	["helicoptergun"] = 100
}

-- -- -- -- -- -- -- -- -- -- /
-- Ranks, xp, drugs and etc
-- -- -- -- -- -- -- -- -- -- /
XP_BLANK = 0

XP_INCREASE_BY = 10000

XP_PLAYERS_REQUIRED = 4

MAX_RANK = 10

-- -- -- -- -- -- -- -- -- -- /
-- [rank] = {unlocks} 
GM.RankUnlocks = {
}

GM.Perks = {

	-- Slot 1: Equipment
	-- Slot 2: Specialist
	-- Slot 3: Personal
	-- Slot 4: Global
	-- Slot 5: Classes
	
		["global_sp"] = {Name = "SP", Description = "+200% SP from kills\n0 SP from inflicting damage", Class = "Global", Slot = 4, Rank = 0, Material = "vgui/gfx/vgui/last_match_miscellaneous"},
		["global_none"] = {Name = "None", Description = "", Class = "Global", Slot = 4, Rank = 0, Material = ""},
	
	-- Medic	

		["medic_stun"] = {Name = "Stun", Description = "Disorientates undead on impact with stunstick\n+6 stunstick damage", Class = "Medic", Slot = 1, Rank = 1, Material = "vgui/achievements/meta_pistol.vtf"},              	
		["medic_supplies"] = {Name = "Medical Supplies", Description = "+100 medical charge for medical equipment", Class = "Medic", Slot = 1, Rank = 1, Material = "vgui/achievements/decal_sprays"},
		["medic_medigun"] = {Name = "Medic Pistol", Description = "[TIER 1]\nSpawn with the medic pistol", Class = "Medic", Slot = 1, Rank = 1, Material = "vgui/achievements/kill_enemy_fiveseven"},     

		["medic_overheal"] = {Name = "Overheal", Description = "Heal humans +10% of their maximum health", Class = "Medic", Slot = 2, Rank = 2, Material = "vgui/achievements/meta_rifle.vtf"},              			
		["medic_reward"] = {Name = "Healthy Reward", Description = "+40% SP from healing", Class = "Medic", Slot = 2, Rank = 3, Material = "vgui/achievements/collect_gifts"},
		["medic_antivenom"] = {Name = "Anti Venom", Description = "Healing an undead with a medigun will poison them", Class = "Medic", Slot = 2, Rank = 2, Material = "vgui/achievements/lossless_extermination.vtf"},

		["medic_tanker"] = {Name = "Tanker", Description = "+50 damage resistance for 3 seconds when hit", Class = "Medic", Slot = 3, Rank = 6, Material = "vgui/achievements/hip_shot.vtf"},
		["medic_immunity"] = {Name = "Natural Immunity", Description = "Immune to poison damage inflicted over time", Class = "Medic", Slot = 3, Rank = 6, Material = "vgui/achievements/win_rounds_without_buying"},
		["medic_battlemedic"] = {Name = "Battle Medic", Description = "30% damage resistance from props\n+5% undead damage resistance", Class = "Medic", Slot = 3, Rank = 6, Material = "vgui/achievements/last_player_alive"},

	-- Commando
		["commando_defender"] = {Name = "Defender", Description = "[TIER 0]\nSpawn with the Defender rifle", Class = "Commando", Slot = 1, Rank = 2, Material = "vgui/achievements/kill_enemy_ak47"},
		["commando_grenadier"] = {Name = "Grenadier", Description = "+3 grenades on spawn", Class = "Commando", Slot = 1, Rank = 2, Material = "vgui/achievements/grenade_multikill"},
		["commando_viper"] = {Name = "Viper", Description = "Shoot 2 bullets at a time with assault rifles\n -40% damage", Class = "Commando", Slot = 1, Rank = 2, Material = "vgui/achievements/hip_shot"},

		["commando_bloodammo"] = {Name = "Blood Ammo", Description = "Receive 50% of damage done as assault rifle ammo from kills", Class = "Commando", Slot = 2, Rank = 4, Material = "vgui/achievements/win_knife_fights_low"},
		["commando_enforcer"] = {Name = "Enforcer", Description = "+25 clip size", Class = "Commando", Slot = 2, Rank = 4, Material = "vgui/achievements/kill_enemy_last_bullet"},
		["commando_marksman"] = {Name = "Marksman", Description = "+60% accuracy", Class = "Commando", Slot = 2, Rank = 4, Material = "vgui/achievements/survived_headshot_due_to_helmet"},

		["commando_kevlar"] = {Name = "Kevlar", Description = "+20% damage resistance from the undead", Class = "Commando", Slot = 3, Rank = 7, Material = "vgui/achievements/survived_headshot_due_to_helmet"},
		["commando_health"] = {Name = "Health", Description = "+30 maximum health", Class = "Commando", Slot = 3, Rank = 7, Material = "vgui/achievements/decal_sprays"},
	    ["commando_leadmarket"] = {Name = "Lead Market", Description = "+50% SP from kills", Class = "Commando", Slot = 3, Rank = 7, Material = "vgui/achievements/collect_gifts"},

		
	-- Support	
		["support_boardpack"] = {Name = "Board Pack", Description = "Replace ammo pack with a pack of boards", Class = "Support", Slot = 1, Rank = 3, Material = "vgui/achievements/break_windows"},
		["support_mobilesupplies"] = {Name = "Mobile Supplies", Description = "Replace ammo pack with mobile supplies", Class = "Support", Slot = 1, Rank = 3, Material = "vgui/achievements/kills_with_multiple_guns"},
		["support_shotgun"] = {Name = "Shotgun", Description = "[TIER 1]\nSpawn with a shotgun", Class = "Support", Slot = 1, Rank = 2, Material = "vgui/achievements/kill_enemy_m3"},
		["support_mp5"] = {Name = "MP5", Description = "[TIER 0]\nSpawn with an MP5", Class = "Support", Slot = 1, Rank = 2, Material = "vgui/achievements/kill_enemy_mp5navy"},
		
		["support_ammo"] = {Name = "Ammo", Description = "+40% ammo received", Class = "Support", Slot = 2, Rank = 5, Material = "vgui/achievements/kill_enemy_reloading"},
		["support_repairs"] = {Name = "Repairs", Description = "+3 hammer repair points\n+10 nails on spawn", Class = "Support", Slot = 2, Rank = 5, Material = "vgui/achievements/snipe_two_from_same_spot"},
							   
		["support_regeneration"] = {Name = "Regeneration", Description = "Regain 1 health every 6 seconds", Class = "Support", Slot = 3, Rank = 8, Material = "vgui/achievements/decal_sprays"},
		["support_bulk"] = {Name = "Bulk", Description = "No speed penalty for weapons", Class = "Support", Slot = 3, Rank = 8, Material = "vgui/achievements/meta_weaponmaster"},
		["support_health"] = {Name = "Health", Description = "+50 maximum health", Class = "Support", Slot = 3, Rank = 8, Material = "vgui/achievements/last_player_alive"},
	
	-- Berserker
		["berserker_hook"] = {Name = "Slinger", Description = "[TIER 0]\nSpawn with a hook", Class = "Berserker", Slot = 1, Rank = 1, Material = "vgui/achievements/kill_enemy_knife"},
		["berserker_oppressor"] = {Name = "Oppressor", Description = "[TIER 1]\nSpawn with a lead pipe", Class = "Berserker", Slot = 1, Rank = 1, Material = "vgui/achievements/kill_enemy_last_bullet"},
		["berserker_breakthrough"] = {Name = "Breakthrough", Description = "Leaps do 40% of melee damage and knocks target backwards", Class = "Berserker", Slot = 1, Rank = 1, Material = "vgui/achievements/kill_enemy_in_air"},     
		["berserker_barbed"] = {Name = "Barbed Weaponry", Description = "20% of damage done is applied every 2 seconds for 3 seconds", Class = "Berserker", Slot = 1, Rank = 1, Material = "vgui/achievements/kill_enemy_last_bullet"},              
	   
		["berserker_executioner"] = {Name = "Executioner", Description = "+30% melee damage to targets under or at 30% health", Class = "Berserker", Slot = 2, Rank = 3, Material = "vgui/achievements/pistol_round_knife_kill"},		   
		["berserker_maniac"] = {Name = "Maniac", Description = "+25% health from melee kills\n+50% melee swing", Class = "Berserker", Slot = 2, Rank = 3, Material = "vgui/achievements/win_pistolrounds_med"},               
		["berserker_headhunter"] = {Name = "Head Hunter", Description = "+20% melee damage on heads\n Daze target when struck on the head", Class = "Berserker", Slot = 2, Rank = 3, Material = "vgui/achievements/survived_headshot_due_to_helmet"},
		["berserker_battlecharge"] = {Name = "Battle Charge", Description = "Bonus damage received when falling, maximum +500% damage\nIncreased leap power", Class = "Berserker", Slot = 2, Rank = 3, Material = "vgui/achievements/kill_enemy_in_air"}, 
		
		["berserker_porcupine"] = {Name = "Porcupine", Description = "33% of damage received goes back to the attacker", Class = "Berserker", Slot = 3, Rank = 6, Material = "vgui/achievements/immovable_object"},
		["berserker_bloodmoney"] = {Name = "Blood Money", Description = "+9 SP from melee kills", Class = "Berserker", Slot = 3, Rank = 6, Material = "vgui/achievements/win_knife_fights_low"},
		["berserker_vampire"] = {Name = "Vampire", Description = "+6% of melee damage goes towards health", Class = "Berserker", Slot = 3, Rank = 6, Material = "vgui/achievements/meta_pistol"},
		["berserker_enrage"] = {Name = "Enrage", Description = "Increased movement speed while at or under 40 health", Class = "Berserker", Slot = 3, Rank = 6, Material = "vgui/achievements/pistol_round_knife_kill"},
				
	-- Engineer
		["engineer_bonusturret"] = {Name = "Lockdown", Description = "+1 Turret received on spawn", Class = "Engineer", Slot = 1, Rank = 2, Material = "vgui/achievements/bomb_defuse_needed_kit"},
		["engineer_combatturret"] = {Name = "Combat Turret", Description = "Spawn with a combat turret\nReceives all turret bonuses", Class = "Engineer", Slot = 1, Rank = 2, Material = "vgui/achievements/concurrent_dominations"},
		["engineer_pulsepistol"] = {Name = "Pulse Pistol", Description = "[TIER 1]\nSpawn with a pulse pistol", Class = "Engineer", Slot = 1, Rank = 2, Material = "vgui/achievements/kill_enemy_fiveseven"},
		["engineer_multimine"] = {Name = "Multi Mine", Description = "+4 C4 on spawn", Class = "Engineer", Slot = 1, Rank = 2, Material = "vgui/achievements/goose_chase"},                    

		["engineer_turret"] = {Name = "Turret Overload", Description = "+40 turret stats", Class = "Engineer", Slot = 2, Rank = 5, Material = "vgui/achievements/bomb_defuse_needed_kit"},
		["engineer_combustion"] = {Name = "Combustion", Description = "Targets caught in the explosion are ignited", Class = "Engineer", Slot = 2, Rank = 5, Material = "hud/t_victories_terrorist-win"},	
		["engineer_darkenergy"] = {Name = "Dark Energy", Description = "+10% pulse damage", Class = "Engineer", Slot = 2, Rank = 5, Material = "vgui/achievements/win_rounds_without_buying"}, 

		["engineer_revenue"] = {Name = "Turret Revenue", Description = "+5 SP from turret kills", Class = "Engineer", Slot = 3, Rank = 7, Material = "vgui/achievements/kill_low_damage"},
		["engineer_blastproof"] = {Name = "Blast Proof", Description = "70% resistance to explosives", Class = "Engineer", Slot = 3, Rank = 7, Material = "hud/t_victories_bomb-detonated"},

	-- Sharpshooter
		
		["sharpshooter_python"] = {Name = "Python", Description = "[TIER 1]\nSpawn with the Python", Class = "Sharpshooter", Slot = 1, Rank = 3, Material = "vgui/achievements/hip_shot"},
		["sharpshooter_medical"] = {Name = "Medical Station", Description = "Mobile supplies gives 4 health to users and +1 SP for the owner", Class = "Sharpshooter", Slot = 1, Rank = 3, Material = "vgui/achievements/collect_gifts"},              


		["sharpshooter_marksman"] = {Name = "Marksman", Description = "+60% accuracy", Class = "Sharpshooter", Slot = 2, Rank = 6, Material = "vgui/achievements/domination_overkills_low"},
		["sharpshooter_double"] = {Name = "Double Calibre", Description = "+2 Musket clip size\n+2 Python clip size", Class = "Sharpshooter", Slot = 2, Rank = 6, Material = "vgui/achievements/kill_two_with_one_shot"},              
		["sharpshooter_friction"] = {Name = "Friction Burn", Description = "25% chance to ingite target with a headshot", Class = "Sharpshooter", Slot = 2, Rank = 6, Material = "vgui/achievements/immovable_object"},        

		["sharpshooter_skillshot"] = {Name = "Skill Shot", Description = "+5 SP for headshot kills", Class = "Sharpshooter", Slot = 3, Rank = 8, Material = "vgui/achievements/headshots_in_round"},           
		["sharpshooter_agility"] = {Name = "Agility", Description = "+7% movement speed\n+40 jump power", Class = "Sharpshooter", Slot = 3, Rank = 8, Material = "vgui/achievements/kill_enemy_in_air"},
	-- Pyro
	
		["pyro_backfire"] = {Name = "Backfire", Description = "6 pyro ammunition back when target has been ignited", Class = "Pyro", Slot = 1, Rank = 1, Material = "vgui/achievements/kill_enemy_reloading"},
		["pyro_glock1"] = {Name = "Glock 1", Description = "[TIER 0]\nSpawn with the Glock 1", Class = "Pyro", Slot = 1, Rank = 1, Material = "vgui/achievements/kill_enemy_glock"},
	   
		["pyro_burn"] = {Name = "Burn", Description = "+5% scorch chance\n+10 scorch damage", Class = "Pyro", Slot = 2, Rank = 3, Material = "hud/t_victories_terrorist-win"}, 
		["pyro_flare"] = {Name = "Flare Bounce", Description = "+10 flare damage\n75% chance flare doesn't explode on impact", Class = "Pyro", Slot = 2, Rank = 3, Material = "hud/t_victories_rescue-failed"},
	   
		["pyro_hotpoints"] = {Name = "Hot Points", Description = "+3 SP when a target is burnt", Class = "Pyro", Slot = 3, Rank = 5, Material = "vgui/achievements/kill_bomb_pickup"},          
		["pyro_immolate"] = {Name = "Immolate", Description = "Burn the target that damages you", Class = "Pyro", Slot = 3, Rank = 5, Material = "hud/t_victories_counter-terrorist-eliminated"},
	
	
	-- Bonus Perks
	
	["Medic"] = {Name = "Medic",		  		
		Equipment = "Medkit, P228, Stun Stick",
		Description = " +10% Pistol damage \n +10% Medi damage\n +10% damage Resistance\n +3% Movement speed",
		CoefDesc = " +%G%% Movement speed\n +%i%% Pistol damage\n +%i%% Medi damage\n +%i%% Poison resistance\n +%i%% Undead damage resistance\n +%i%% Medical power",
		Coef = {0.5, 1, 1, 5, 2, 2},
		Slot = 5,
		Rank = 0,
		Colour = Color(100, 230, 130,32),
		Model = "models/player/group03m/female_03.mdl"},
		
	["Commando"] = {Name = "Commando",   		
		Equipment = "Grenades, Five SeveN, Knife", 
		Description = " +10% Rifle Damage \n See undead health\n +10% Clip size \n +10 Health ",
		CoefDesc = " +%i%% Health\n +%i%% Clip size\n +%i%% Rifle damage",
		Coef = {3, 2, 1},
		Slot = 5,
		Rank = 0,
		Colour = Color(188, 168, 255,32),
		Model = "models/player/combine_soldier.mdl"},		
		
	["Support"] = {Name = "Support",    		
		Equipment = "Ammo Pack, USP, Hammer", 			
		Description = " +10% Shotgun damage \n +10% SMG damage \n +10% Ammo received",
		CoefDesc = " +%i%% SMG damage\n +%i%% Shotgun damage \n +%i%% Nail health\n +%G Repair points\n +%i Nail\n +%i%% Ammo received",
		Coef = {1, 1, 1, 0.25, 1, 2},
		Slot = 5,
		Rank = 0,	
		Colour = Color(255, 182, 238,32),
		Model = "models/player/arctic.mdl"},		
		
	["Berserker"] = {Name = "Berserker", 		
		Equipment = "Desert Eagle, Plank", 				
		Description = " [RMB] Leap while holding a melee weapon.\n Cannot be dazed when hit\n +10% melee damage \n +5% melee damage to health\n +5 Health on melee kill\n +10% Damage resistance \n -10% Gun Damage\n +2% Movement Speed",
		CoefDesc = " +%i Health from melee kill\n +%G%% Movement speed",
		Coef = {1, 0.5},
		Slot = 5,
		Rank = 0,
		Colour = Color(255, 141, 147,32),
		Model = "models/player/monk.mdl"},		
		
	["Engineer"] = {Name = "Engineer",   		
		Equipment = "Turret, C4, Pistol, Frying Pan", 	
		Description = " +10% Pulse Weapon Damage\n +5% C4 Damage\n +1 Turret Damage\n +0.01 Turret recharge rate",
		CoefDesc = " +%G%% Turret damage\n +%G%% Turret recharge rate\n +%i%% Turret health\n +%i%% Turret ammo capacity\n +%i Pulse weapon capacity\n +%i%% Pulse weapon damage\n +%i%% Pulse weapon recharge rate\n +%i%% C4 damage\n +%i%% C4 radius",
		Coef = {0.1, 0.005, 2, 2, 5, 1, 2, 1, 1},
		Slot = 5,
		Rank = 0,
		Colour = Color(30, 228, 255,32),
		Model = "models/player/alyx.mdl"},
		
	["Sharpshooter"] = {Name = "Sharpshooter", 
		Equipment = "Mobile Supplies, Beretta, Knife", 	
		Description = " +5% Sniper damage \n +8% Headshot damage",
		CoefDesc = " +%i%% Sniper damage\n +%i%% Headshot damage\n",
		Coef = {1,1},
		Slot = 5,
		Rank = 0,
		Colour = Color(127, 181, 120,32),
		Model = "models/player/odessa.mdl"},		
		
	["Pyro"] = {Name = "Pyro",				
		Equipment = "Alyx Gun, Metal Pipe", 				
		Description = " 12% Chance to burn target\n +10% Pyro damage\n 6 Initial burn damage\n 10 Initial scorch damage\n +10% damage to burning targets",
		CoefDesc = " +%i Burn damage\n +%i Burn chance\n +%i Pyro damage\n +%i Scorch damage",
		Material = "zombiesurvival/humanclass/avatar_assault",
		Coef = {3,1,1,2},
		Slot = 5,
		Rank = 0,
		Colour = Color(255, 178, 62,28),
		Model = "models/player/gasmask.mdl"}		
	
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
UNDEAD_START_AMOUNT_PERCENTAGE = 0.2
UNDEAD_START_AMOUNT_MINIMUM = 1
UNDEAD_START_AMOUNT = 1
UNDEAD_VOLUNTEER_DISTANCE = 340


-- Good values are 1 to 3. 0.5 is about the same as the default HL2. 1 is about ZS difficulty. This is mainly for NPC healths and damages.
DIFFICULTY = 1.5

-- Humans can not carry OR drag anything heavier than this (in kg.)
CARRY_MAXIMUM_MASS = 300


-- Objects with more mass than this will be dragged instead of carried.
CARRY_DRAG_MASS = 145


-- Anything bigger than this is dragged regardless of mass.

CARRY_DRAG_VOLUME = 120


-- Humans can not carry anything with a volume more than this (OBBMins():Length() + OBBMaxs():Length()).

CARRY_MAXIMUM_VOLUME = 150

-- Humans are slowed by this amount per kg carried.
CARRY_SPEEDLOSS_PERKG = 1.1

-- But never slower than this.
CARRY_SPEEDLOSS_MINSPEED = 160

-- -- -- -- -- -- -- -- /

-- Maximum crates per map
MAXIMUM_CRATES = 3 -- math.random(2, 3)

-- Use Zombie Survival's custom footstep sounds? I'm not sure how bad it might lag considering you're potentially sending a lot of data on heavily packed servers.
CUSTOM_FOOTSTEPS = false

-- In seconds, repeatatively, the gamemode gives all humans get a box of whatever ammo of the weapon they use.
AMMO_REGENERATE_RATE = 2056744

--Warming up time
WARMUPTIME = 135

-- In seconds, how long humans need to survive.
--ROUNDTIME = (20*60) + WARMUPTIME -- 20 minutes

-- EXPERIMENTAL
ROUNDTIME = (15*60) + WARMUPTIME -- 15 minutes

-- ROUND START TIME
ROUNDSTARTTIME = 0

-- Time in seconds between end round and next map.
INTERMISSION_TIME = 35

--Amount of time players have to vote for next map(seconds)
VOTE_TIME = 20

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
ALLOW_SHOVE = true -- not needed with soft collisions

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
LASTHUMANSOUND = "mrgreen/music/lasthuman.mp3"
LASTHUMANSOUNDLENGTH = 159 -- 2:39

-- Rave sound; people will hate me for making this :')
RAVESOUND = "mrgreen/ravebreak_fix.mp3"

--Add this Soon
SHITHITFAN = "mrgreen/music/bosstheme2.mp3"
SHITHITFANLENGTH = 300

-- Bug Reporting System
BUG_REPORT = false

-- Turn off/on the redeeming system.
REDEEM = true

-- Players don't have a choice if they want to redeem or not. Setting to false makes them press F2.
AUTOREDEEM = true

--Human kills needed for a zombie player to redeem (resurrect). Do not set this to 0. If you want to turn this
--system off, set AUTOREDEEM to false. (Deluvas: using Score System)
REDEEM_KILLS = 8
REDEEM_FAST_KILLS = 6

--Maximum level to be fit for fast redeem
REDEEM_FAST_LEVEL = 1

-- Use soft collisions for teammates
SOFT_COLLISIONS = true

-- If a person dies when there are less than the above amount of people, don't set them on the undead team if this is true. This should generally be true on public / big servers.
--[[if game.MaxPlayers() < 4 then
	WARMUP_MODE = false
end]]
WARMUP_MODE = false

--Not sure if it will work as planned, but whatever. This thing will shuffle the mapcycle sometimes
MAPS_RANDOMIZER = false

util.PrecacheSound(LASTHUMANSOUND)

--Menu stuff..

WELCOME_TEXT =
[[
Basic Information:
-DON'T FORGET TO PICK A LOADOUT!!!
-F1 for other menu's and the GreenCoin shop!
-GreenShop is located via F1 or !shop 'In chat'
-Roll the dice to see what outcome you will get!! '!rtd'

HUMANS:

-You gain SP for killing zombies and helping your team mates. Eg: Healing
-You gain Greencoins from killing zombies and doing team based roles Eg: Hammer!
-Press 'E' on the supply crate to gain access to the shop!
-!shop in chat to open the GreenShop

UNDEAD:

-If you have 8 points from killing humans you can redeem via 'F2'
-Who ever has the most points near the end of the round will become the boss!
-You can change zombie class Via F3
-Zombie classes unlock over time. So if its a hard game give it some time!
-You gain GreenCoins for killing humans!

Our forums if you want to join us or have any questions! ^^
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
At SkillShop you buy Weapons, Ammo and Supplies with SkillPoints (SP). 
These points are earned by killing Zombies and helping teammates.

Please remember bought items and weapons only last this round!
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
	txt = [[Mr. Green Zombie Survival
	
	| Humans |
	
		[Objective]
			- Survive for 15 minutes to win.
		[How?] 
			- Battle the undead to gain SP(SkillPoints) in order to receive weapons and ammunition.
		[SP]
			- SP is received by damaging/killing/healing/repairing/surviving.
			- You will receive a weapon drop once you reach a required amount of SP.
			- Weapons and ammunition have a chance of dropping from killing undead.
			- Better weapons will drop as the round progresses.
		[F3]
			- Throw weapon.
			- Salvage weapon for SP while looking at a mobile supply crate.

	| Undead |
	
		[Objective]
			- Kill 4 humans (8 score) in order to redeem(become a human).
		[How?] 
			- Use the variety of undead(F3).
			- Each undead has it's own pros and cons and should all be used in seperate situations.
		[F2]
			- Redeem.
		[F3]
			- Undead class selection.
	
	[F4]
		- Options menu.
	[Website]
		- http://mrgreengaming.com
]]
}


HELP_TXT[2] = {
	title = "Rules", 
	txt = [[
	Permanent Ban:
		  - Hacking.
		  - Gettting banned too often.
		  
	Temporary Ban
		  - Purposefully irritating players.

	Teleported
		  - Exploting a map.
		  - Prop climbing
		
	Muted \ Gagged:
		  - Spamming
		  - Abusing voice chat.
		  - Being an idiot.
	]]
} 

HELP_TXT[3] = {
	title = "Leveling Guide", 
	txt = [[
		-At Mr.Green we reward you for playing on the server for long periods of time.
		
		-You are rewarded with XP which allows you to level up and unlock new perks,
		and also equipment!
		
		-You can level up quicker if you win round and kill bosses!
	]]
} 

--[[	Mr. Green forums can be found at http://mrgreengaming.com
		If you have any questions or tips about/for this server you can always e-mail to info@limetric.com
		
		Surf to http://mrgreengaming.com to post your ideas for changes and where you can post suggestions for new maps.
		
		Gamemode is developed by Limetric for Mr. Green Gaming Community. More info at http://limetric.com
		
	If you Win a round you gain XP this can be used to level up and unlock the following items.	
		You can also gain XP by killing humans and zombies.
		]]--


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
if CHRISTMAS then
	player_manager.AddValidModel("santa", "models/Jaanus/santa.mdl")
end
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
		"combie_soldier",
		"combie_soldier_prisonguard",
		"corpse01"	
		--"santa"
}

PyroPlayerModels = {
	"css_gasmask"
}

EngineerPlayerModels = {
	"kleiner",
	"alyx",
	"mossman",
	"barney",
	"breen"	
}

CommandoPlayerModels = {
	"css_riot",
	"css_swat",
	"css_urban",	
}

SupportPlayerModels = {
	"css_arctic",
	"css_guerilla",
	"css_leet",
	"css_phoenix",
}

BerserkerPlayerModels = {
	"monk"
}

SharpshooterPlayerModels = {
	"odessa"
}

MedicPlayerModels = {
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
	"medic15"
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
						--Duby: So Necro used one of the classes for the human class which is used now. Kinda lazy but it works...
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

--[=[--------------------------------------------
		Achievement descriptions
--------------------------------------------]=]
PLAYER_STATS = true --  enables data reading/writing, DO NOT TURN OFF. ALSO APPLIES TO DONATION PROCESSING!

achievementDesc = {
	[1] = { Image = "", Key = "bloodseeker", ID = 1, Name = "[ZS] Bloodseeker", Desc = "[ROUND] Kill 5 humans", Type = "zs",  },
	[2] = { Image = "", Key = "angelofwar", ID = 2, Name = "[ZS] Angel of War", Desc = "[TOTAL] Kill 1000 undead", Type = "zs",  },
	[3] = { Image = "", Key = "ghost", ID = 3, Name = "[ZS] Ghost", Desc = "Make a kill before getting hit as zombie in a life!", Type = "zs",  },
	[4] = { Image = "", Key = "meatseeker", ID = 4, Name = "[ZS] Meatseeker", Desc = "[ROUND] Kill 8 humans", Type = "zs",    },
	[5] = { Image = "", Key = "sexistzombie", ID = 5, Name = "[ZS] Sexist Zombie", Desc = "Kill a human girl", Type = "zs",    },
	[6] = { Image = "", Key = "angelofhope", ID = 6, Name = "[ZS] Angel of Hope", Desc = "[TOTAL] Kill 10.000 undead", Type = "zs",    },
	[7] = { Image = "", Key = "emo", ID = 7, Name = "[ZS] Emo", Desc = "Kill yourself while human", Type = "zs",    },
	[8] = { Image = "", Key = "samurai", ID = 8, Name = "[ZS] Samurai", Desc = "[ROUND] Kill 10 zombies with melee", Type = "zs",    },
	[9] = { Image = "", Key = "spartan", ID = 9, Name = "[ZS] Spartan", Desc = "[TOTAL] Kill 300 undead", Type = "zs",    },
	[10] = { Image = "", Key = "toolsofdestruction", ID = 10, Name = "[ZS] Tools of Destruction", Desc = "[ROUND] Propkill 3 humans", Type = "zs",    },
	[11] = { Image = "", Key = "headfucker", ID = 11, Name = "[ZS] Headfucker", Desc = "[ROUND] Kill 4 humans as a Headcrab", Type = "zs",    },
	[12] = { Image = "", Key = "masterofzs", ID = 12, Name = "[REWARD] Master of ZS", Desc = "Get all [ZS] achievements | Reward: (ZS Master) chat tag", Type = "special",  },
	[13] = { Image = "", Key = "dealwiththedevil", ID = 13, Name = "[ZS] Deal With The Devil", Desc = "[ROUND] Redeem three times", Type = "zs",    },
	[14] = { Image = "", Key = "launchanddestroy", ID = 14, Name = "[ZS] Launch And Destroy", Desc = "Propkill a human", Type = "zs",    },
	[15] = { Image = "", Key = "humanitysdamnation", ID = 15, Name = "[ZS] Humanity's Damnation", Desc = "[TOTAL] Inflict 10.000 damage to the humans", Type = "zs",    },
	[16] = { Image = "", Key = "slayer", ID = 16, Name = "[ZS] Slayer", Desc = "[TOTAL] Kill 50 humans", Type = "zs",    },
	[17] = { Image = "", Key = "runningmeatbag", ID = 17, Name = "[ZS] Running Meatbag", Desc = "Stay alive at least 1 minute when last human", Type = "zs",    },
	[18] = { Image = "", Key = "sergeant", ID = 18, Name = "[ZS] Sergeant", Desc = "[ROUND] Kill 60 undead", Type = "zs",    },
	[19] = { Image = "", Key = "survivor", ID = 19, Name = "[ZS] Survivor", Desc = "Be last human and win the round", Type = "zs",    },
	[20] = { Image = "", Key = "marksman", ID = 20, Name = "[ZS] Marksman", Desc = "Kill a fast zombie in mid-air", Type = "zs",    },
	[21] = { Image = "", Key = "slowdeath", ID = 21, Name = "[ZS] Slow Death", Desc = "Kill a human by poison", Type = "zs",    },
	[22] = { Image = "", Key = "howler", ID = 22, Name = "[ZS] Screaming Bitch", Desc = "[ROUND] Kill 3 humans as a Howler",Type = "zs",  },
	[23] = { Image = "", Key = "private", ID = 23, Name = "[ZS] Private", Desc = "[ROUND] Kill 20 undead", Type = "zs",    },
	[24] = { Image = "", Key = "butcher", ID = 24, Name = "[ZS] Butcher", Desc = "[TOTAL] Kill 100 humans", Type = "zs",    },
	[25] = { Image = "", Key = "iamlegend", ID = 25, Name = "[ZS] I Am Legend", Desc = "Kill yourself when last human", Type = "zs",    },
	[26] = { Image = "", Key = "payback", ID = 26, Name = "[ZS] Payback", Desc = "Redeem once", Type = "zs",    },
	[27] = { Image = "", Key = "dancingqueen", ID = 27, Name = "[ZS] Dancing Queen", Desc = "Win the round without taking a single hit", Type = "zs",    },
	[28] = { Image = "", Key = "feastseeker", ID = 28, Name = "[ZS] Feastseeker", Desc = "[ROUND] Kill 12 humans", Type = "zs",    },
	[29] = { Image = "", Key = ">:(", ID = 29, Name = "[SPECIAL] >:(", Desc = "Kill an admin when they're human", Type = "special",},
	[30] = { Image = "", Key = "hidinkitchencloset", ID = 30, Name = "[ZS] Hide In Kitchen Closet", Desc = "Stay alive for at least 5 minutes as last human", Type = "zs",    },
	[31] = { Image = "", Key = "ninja", ID = 31, Name = "[ZS] Ninja", Desc = "[ROUND] Kill 5 zombies with melee", Type = "zs",    },
	[32] = { Image = "", Key = "lightbringer", ID = 32, Name = "[ZS] Lightbringer", Desc = "[TOTAL] Inflict 100.000 damage to the undead", Type = "zs",    },
	[33] = { Image = "", Key = "laststand", ID = 33, Name = "[ZS] Last Stand", Desc = "Kill a zombie with melee while under 10 health", Type = "zs",    },
	[34] = { Image = "", Key = "mankindsanswer", ID = 34, Name = "[ZS] Mankind's Answer", Desc = "[TOTAL] Inflict 1.000.000 damage to the undead", Type = "zs",    },
	[35] = { Image = "", Key = ">>:o", ID = 35, Name = "[SPECIAL] >>:O", Desc = "[ROUND] Kill a zombie admin 5 times", Type = "special",  },
	[36] = { Image = "", Key = "corporal", ID = 36, Name = "[ZS] Corporal", Desc = "[ROUND] Kill 40 undead", Type = "zs",    },
	[37] = { Image = "", Key = "humanitysworstnightmare", ID = 37, Name = "[ZS] Humanity's Worst Nightmare", Desc = "[TOTAL] Inflict 100.000 damage to the humans", Type = "zs",    },
	[38] = { Image = "", Key = "stuckinpurgatory", ID = 38, Name = "[ZS] Stuck In Purgatory", Desc = "[TOTAL] Redeem 100 times", Type = "zs",    },
	[39] = { Image = "", Key = "eredicator", ID = 39, Name = "[ZS] Eredicator", Desc = "[TOTAL] Kill 250 humans", Type = "zs",    },
	[40] = { Image = "", Key = "annihilator", ID = 40, Name = "[ZS] Annihilator", Desc = "[TOTAL] Kill 1000 humans", Type = "zs",    },
	[41] = { Image = "", Key = "headhumper", ID = 41, Name = "[ZS] Headhumper", Desc = "[ROUND] Kill 2 humans as a Headcrab", Type = "zs",    },
	[42] = { Image = "", Key = "fuckingrambo", ID = 42, Name = "[ZS] Fucking Rambo", Desc = "[TOTAL] Kill 100 undead", Type = "zs",    },
	[43] = { Image = "", Key = "hate", ID = 43, Name = "[ZS] Don't hate me bro", Desc = "Be manly enough to kill the ancient evil!", Type = "zs",    },
	[44] = { Image = "", Key = "bhkill", ID = 44, Name = "[ZS] The Walking Apocalypse", Desc = "'Hey, I saw you before!'", Type = "zs",    },
	[45] = { Image = "", Key = "zombine", ID = 45, Name = "[ZS] Boom Together", Desc = "[ROUND] Blow up 2 humans as a Zombine", Type = "zs",    },	
	[46] = { Image = "", Key = "ghast", ID = 46, Name = "[ZS] Deceiver", Desc = "[ROUND] Kill 2 humans as a Ghast", Type = "zs",    },	
	[47] = { Image = "", Key = "poisonheal", ID = 47, Name = "[ZS] Rotten Medicine", Desc = "[ROUND] Heal 500 health points with poison", Type = "zs",    }	,
	[48] = { Image = "", Key = "pufulet", ID = 48, Name = "[SPECIAL] Myth Busted", Desc = "Kill Pufulet while he's human", Type = "special",  },		
	[49] = { Image = "", Key = "uglyfort", ID = 49, Name = "[MAP] Ugly Fort", Desc = "Survive ugly fort", Type = "map",  },
	[50] = { Image = "", Key = "fortress", ID = 50, Name = "[MAP] Fortress", Desc = "Survive fortress", Type = "map", },
	[51] = { Image = "", Key = "termites", ID = 51, Name = "[MAP] Termites", Desc = "Survive termites", Type = "map",  },
	[52] = { Image = "", Key = "buntshot", ID = 52, Name = "[MAP] Buntshot", Desc = "Survive buntshot", Type = "map", },
	[53] = { Image = "", Key = "ambush", ID = 53, Name = "[MAP] Ambush", Desc = "Survive ambush", Type = "map", },	
	[54] = { Image = "", Key = "dump", ID = 54, Name = "[MAP] Dump", Desc = "Survive dump", Type = "map", },	
	[55] = { Image = "", Key = "filth", ID = 55, Name = "[MAP] Filth", Desc = "Survive filth", Type = "map", }
	--[45] = { Image = "", Key = "flare1", ID = 52, Name = "Pyromaniac", Desc = "Kill a zombie with the flare gun.",  },
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

classData = { --Seems that the medic class is used as the main human class now. Lazy lazy Necro!
	["medic"] = { level = 0, achlevel0_1 = 0, achlevel0_2 = 0, achlevel2_1 = 0, achlevel2_2 = 0, achlevel4_1 = 0, achlevel4_2 = 0 } ,
	["commando"] = { level = 0, achlevel0_1 = 0, achlevel0_2 = 0, achlevel2_1 = 0, achlevel2_2 = 0, achlevel4_1 = 0, achlevel4_2 = 0 },
	["berserker"] = { level = 0, achlevel0_1 = 0, achlevel0_2 = 0, achlevel2_1 = 0, achlevel2_2 = 0, achlevel4_1 = 0, achlevel4_2 = 0 },
	["engineer"] = { level = 0, achlevel0_1 = 0, achlevel0_2 = 0, achlevel2_1 = 0, achlevel2_2 = 0, achlevel4_1 = 0, achlevel4_2 = 0 },
	["support"] = { level = 0, achlevel0_1 = 0, achlevel0_2 = 0, achlevel2_1 = 0, achlevel2_2 = 0, achlevel4_1 = 0, achlevel4_2 = 0 },
	["new"] = { rank = 0, xp = 0 },
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