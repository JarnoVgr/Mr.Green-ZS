-- � Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
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

SPEED = 190
SPEED_LIGHT = SPEED - 5
SPEED_MELEE_LIGHT = SPEED - 6
SPEED_MELEE = SPEED - 11
SPEED_MELEE_HEAVY = SPEED - 21
SPEED_PISTOL = SPEED - 12
SPEED_SMG = SPEED - 17
SPEED_SHOTGUN = SPEED - 27
SPEED_RIFLE = SPEED - 22
SPEED_HEAVY = SPEED - 32

-- Horde stuff
HORDE_MAX_ZOMBIES = 8
HORDE_MAX_DISTANCE = 1800 --Leave this! It affects the beats and how they play. They play best as this number, do not touch it Pufu!


BONUS_RESISTANCE_WAVE = 5
BONUS_RESISTANCE_AMOUNT = 20 -- %

--EVENT: Halloween
HALLOWEEN = false

--EVENT: Christmas
CHRISTMAS = false

--EVENT: Aprils Fools
FIRSTAPRIL = false


--Boss stuff
BOSS_TOTAL_PLAYERS_REQUIRED = 7--Pufu stop fucking with this! Last warning! I've been mellow about everything else, do not fucking change it!
BOSS_CLASS = {11, 20, 10} -- 13 "Nerf" is a bad boss.
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
        ["weapon_zs_deagle"]  = { Name = "Desert Eagle", DPS = 93, Infliction = 0.2, Type = "pistol"},		
        ["weapon_zs_melee_hook"]  = { Name = "Meat Hook", DPS = 38, Infliction = 0, Type = "melee", Price = 100, Description = "Bish bash bosh, fast smacking and hard hitting!", HumanClass = "berserker" },  
        ["weapon_zs_melee_axe"]  = { Name = "Axe", DPS = 78, Infliction = 0.5, Type = "melee", Price = 400, HumanClass = "berserker" },
        ["weapon_zs_melee_sledgehammer"]  = { Name = "Sledgehammer", DPS = 38, Infliction = 0, Type = "melee", Price = 800, HumanClass = "berserker" },
        ["weapon_zs_melee_katana"]  = { Name = "Katana", DPS = 90, Infliction = 0, Type = "melee", Price = 600, Description = "Handle with care. It's very sharp." , HumanClass = "berserker"},
        ["weapon_zs_melee_chainsaw"]  = { Name = "Chainsaw", DPS = 30, Infliction = 0, Type = "melee", Price = 800, Description = "This may become a bit gory.", HumanClass = "berserker" },   
       
        --Commando
        ["weapon_zs_defender"]  = { Name = "Defender Rifle", DPS = 93, Price = 100, Infliction = 0.2, Type = "rifle", Description = "Scrap AK47", HumanClass = "commando"},    
        ["weapon_zs_famas"]  = { Name = "Famas", DPS = 140, Type = "rifle", Price = 300, HumanClass = "commando" },
       -- ["weapon_zs_sg552"]  = { Name = "SG552 Rifle", DPS = 106, Infliction = 0.51, Type = "rifle", Price = 500, HumanClass = "commando" },
        ["weapon_zs_m4a1"]  = { Name = "M4A1", DPS = 138, Infliction = 0.65, Type = "rifle", Price = 500, HumanClass = "commando" },
        ["weapon_zs_ak47"]  = { Name = "AK-47", DPS = 133, Infliction = 0.7, Type = "rifle", Price = 600, HumanClass = "commando" },   
        ["weapon_zs_aug"]  = { Name = "Steyr AUG", DPS = 125, Infliction = 0.53, Type = "rifle", Price = 600, HumanClass = "commando" },       
        ["weapon_zs_galil"]  = { Name = "Galil", DPS = 129, Infliction = 0.57, Type = "rifle", Price = 750, HumanClass = "commando" }, 
        ["weapon_zs_m249"]  = { Name = "M249", DPS = 200, Infliction = 0.85, Type = "rifle", Price = 950, HumanClass = "commando" },      		
		
        --Support
        ["weapon_zs_smg"]  = { Name = "Classic SMG", DPS = 125, Infliction = 0.65, Type = "smg", Price = 100, HumanClass = "support"},
        ["weapon_zs_chipper"]  = { Name = "Chipper", DPS = 143, Infliction = 0, Price = 150, Type = "shotgun", HumanClass = "support" },       		
        ["weapon_zs_mac10"]  = { Name = "Mac 10", DPS = 126, Infliction = 0.60, Type = "smg", Price = 300, HumanClass = "support" },   
        ["weapon_zs_ump"]  = { Name = "UMP", DPS = 110, Infliction = 0.60, Type = "smg", Price = 500, HumanClass = "support" },
        ["weapon_zs_m3super90"]  = { Name = "M3 Shotgun", DPS = 149, Infliction = 0, Type = "shotgun", Price = 550, HumanClass = "support"}, 		
        ["weapon_zs_p90"]  = { Name = "P90", DPS = 125, Infliction = 0.65, Type = "smg", Price = 650, HumanClass = "support" },
        ["weapon_zs_m1014"]  = { Name = "M1014", DPS = 246, Infliction = 0.85, Type = "shotgun", Price = 850, HumanClass = "support"},		
    
        --["weapon_zs_mp5"]  = { Name = "MP5", DPS = 127, Infliction = 0.58, Type = "smg", Price = 300, HumanClass = "support" },
	
        --Medic
        ["weapon_zs_medi2"]  = { Name = "Medi 02", DPS = 143, Infliction = 0, Type = "shotgun",Price = 300, Description = "Ranged medkit that can also shoot zombies!", HumanClass = "medic"},           
        ["weapon_zs_medi3"]  = { Name = "Medi 03", DPS = 143, Infliction = 0, Type = "smg",Price = 600, Description = "Ranged medkit that can also shoot zombies!", HumanClass = "medic"}, 
		["weapon_zs_medi1"]  = { Name = "Medi 01", DPS = 143, Infliction = 0, Type = "pistol",Price = 100, Description = "Ranged medkit that can also shoot zombies!", HumanClass = "medic"}, 
		
        ["weapon_zs_glock3"]  = { Name = "Glock", DPS = 120, Infliction = 0.25, Type = "pistol", Price = 200, HumanClass = "medic" },
        ["weapon_zs_magnum"]  = { Name = ".357 Magnum", DPS = 121, Infliction = 0.3, Type = "pistol", Price = 400, Description = "Russian Roulette Revolver", HumanClass = "medic" },
        ["weapon_zs_alyx"]  = { Name = "Alyx Gun", DPS = 30, Infliction = 0.25, Type = "pistol", Price = 200, Description = "Alyx is hot. But her gun is even more hot.", HumanClass = "medic" }, 

		
        ["weapon_zs_elites"]  = { Name = "Dual-Elites", DPS = 92, Infliction = 0.25, Type = "pistol", Description = "High fire rate thanks to having two pistols in your hands."},
		["weapon_zs_tmp"]  = { Name = "Silent TMP", DPS = 107, Infliction = 0.56, Type = "smg" },
       
        --Sharpshooter
        ["weapon_zs_musket"]  = { Name = "Musket", DPS = 143, Infliction = 0, Type = "rifle", Description = "Somehow still works.", Price = 200, HumanClass = "sharpshooter"},         
        ["weapon_zs_python"]  = { Name = "Python", DPS = 93, Infliction = 0.2, Price = 100, Type = "pistol", HumanClass = "sharpshooter"},       
        ["weapon_zs_scout"]  = { Name = "Scout Sniper", DPS = 40, Infliction = 0, Type = "rifle", Price = 400, Description = "Light-weight sniper.", HumanClass = "sharpshooter" },    
        ["weapon_zs_sg550"]  = { Name = "SG550", DPS = 70, Infliction = 0.65, Type = "rifle", Price = 600, HumanClass = "sharpshooter"  },
        ["weapon_zs_g3sg1"]  = { Name = "G3SG1", DPS = 70, Infliction = 0.65, Type = "rifle", HumanClass = "sharpshooter"  },
        ["weapon_zs_awp"]  = { Name = "AWP", DPS = 200, Infliction = 0, Type = "rifle", Price = 900, Description = "Heavy sniper.", HumanClass = "sharpshooter" },     
       
        --Engineer
        ["weapon_zs_pulsepistol"]  = { Name = "Pulse Pistol", DPS = 93, Infliction = 0.2, Type = "pistol", Price = 100, HumanClass = "engineer"},                      
        ["weapon_zs_pulsesmg"]  = { Name = "Pulse SMG", DPS = 99, Infliction = 0, Type = "smg", Price = 400, HumanClass = "engineer"},
        ["weapon_zs_pulserifle"]  = { Name = "Pulse Rifle", DPS = 99, Infliction = 0, Type = "smg", Price = 800, HumanClass = "engineer"},

 
		--PyroTechnic
		["weapon_zs_flaregun"]  = { Name = "Flare Gun", DPS = 143, Infliction = 0, Type = "rifle", Description = "Alert other Survivors when you're in need of help." },
		["weapon_zs_flamer"]  = { Name = "Flare Gun", DPS = 143, Infliction = 0, Type = "rifle", Description = "Alert other Survivors when you're in need of help." },
		["weapon_zs_firebomb"]  = { Name = "Flame Nade", DPS = 143, Infliction = 0, Type = "misc", Description = "A fire Grenade" },
		
        --Other Class
       -- ["weapon_zs_crossbow"]  = { Name = "Crossbow", DPS = 220, Infliction = 0, Type = "rifle",Price = 600, HumanClass = "other" },          
       
        --Pistols
 
        --Loadout Guns
        ["weapon_zs_fiveseven"]  = { Name = "Five-Seven", DPS = 91, Infliction = 0.15, Type = "pistol"},       
        ["weapon_zs_barreta"]  = { Name = "Barreta", DPS = 30, Infliction = 0.25, Type = "pistol"},            
        ["weapon_zs_usp"]  = { Name = "USP .45", DPS = 42, Infliction = 0, Type = "pistol", Description = "It's practical!" },
        ["weapon_zs_p228"]  = { Name = "P228", DPS = 58, Infliction = 0, Type = "pistol", Description = "More accuracy but less fire power compared to the USP."  },   
        ["weapon_zs_melee_plank"]  = { Name = "Plank", DPS = 56, Infliction = 0, Type = "melee", Description = "The noobs ultimate weapon."  },                
        ["weapon_zs_melee_combatknife"]  = { Name = "Combat Knife", DPS = 15, Infliction = 0, Type = "melee" },
        ["weapon_zs_classic"]  = { Name = "'Classic' Pistol", DPS = 30, Infliction = 0.25, Type = "pistol", Description = "Classic."},
 
        --Loadout Tools 1
        ["weapon_zs_tools_hammer"]  = { Name = "Hammer", DPS = 23, Infliction = 0, Type = "tool1", Description = "Stop! Hammer time. This will freeze props in their place. Primary to repair/whack, Secondary to nail." },
        ["weapon_zs_medkit"]  = { Name = "Medical Kit", DPS = 8, Infliction = 0, Type = "tool1", Description = "Be a good teammate. Or just heal yourself." },
        ["weapon_zs_tools_supplies"] = { Name = "Mobile Supplies", DPS = 0, Infliction = 0, Type = "tool1", Description = "Allows you to spawn a Supply Crate." },
		["weapon_zs_turretplacer"] = { Name = "Turret", DPS = 0, Infliction = 0, Type = "tool1", Description = "Need more fire power? Here you go!"  },
		  
		  --Loadout Tools 2
        ["weapon_zs_tools_remote"] = { Name = "Turret Controller", DPS = 0, Infliction = 0, Type = "misc" },
        ["weapon_zs_tools_torch"] = { Name = "Torch", DPS = 0, Infliction = 0, Type = "tool2", Description = "Fix broken nails to prevent barricades getting broken." },       
        ["weapon_zs_miniturret"] = { Name = "Combat Mini-Turret", DPS = 0, Infliction = 0, Type = "tool2", Description = "CBA to shoot, let your friend here help you with that!"  },
        ["weapon_zs_grenade"]  = { Name = "Grenade", DPS = 8, Infliction = 0, Type = "tool2", Description = "Handheld explosives." },
        ["weapon_zs_mine"]  = { Name = "Proximity C4", DPS = 8, Infliction = 0, Type = "tool2", Description = "BOOM, get your team out a tough spot.."  },       
       
        --Special
        ["weapon_zs_melee_crowbar"]  = { Name = "Crowbar", DPS = 85, Infliction = 0.65, Type = "melee" },      
       
        --Map Only
        ["weapon_zs_melee_beer"]  = { Name = "Beer Bottle", DPS = 30, Infliction = 0, Type = "melee", Description = "Alcohol!" },
        ["weapon_zs_melee_keyboard"]  = { Name = "Keyboard", DPS = 45, Infliction = 0, Type = "melee", Description = "There's no better way to express your online anger." },
        ["weapon_zs_melee_pot"]  = { Name = "Pot", DPS = 61, Infliction = 0, Type = "melee", Description = "Don't do school stay in drugs, live the pot!" },
        ["weapon_zs_melee_fryingpan"]  = { Name = "Frying Pan", DPS = 70, Infliction = 0, Type = "melee", Description = "Cooking by the book." },
        ["weapon_zs_melee_shovel"]  = { Name = "Shovel", DPS = 40, Infliction = 0, Type = "melee", Description = "" },
        ["weapon_zs_melee_pipe"]  = { Name = "Pipe", DPS = 30, Infliction = 0, Type = "melee", Description = "Whoops. Looks like I shouldn't of hit him so hard.."  },
        ["weapon_zs_melee_pipe2"]  = { Name = "Improved Pipe", DPS = 30, Infliction = 0, Type = "melee", Description = "Clunk, oh look his head fell off.."  },
       
        --All the other stuff we don't care about right now
        --Heavy
        ["weapon_zs_boomerstick"]  = { Name = "Boom Stick", DPS = 215, Infliction = 0.85, Type = "shotgun" },
        ["weapon_zs_boomstick"]  = { Name = "Boom Stick", DPS = 215, Infliction = 0.85, Type = "shotgun" },
 
        --Uncategorized
        ["weapon_zs_minishotty"]  = { Name = "'Farter' Shotgun", DPS = 126, Infliction = 0, Type = "shotgun" },
        ["weapon_zs_fists"]  = { Name = "Fists", DPS = 30, Infliction = 0, Restricted = true, Type = "melee", Description = "Punch a Zombie in the face." },
        ["weapon_zs_fists2"]  = { Name = "Fists", DPS = 30, Infliction = 0, Restricted = true, Type = "melee" },
        ["weapon_zs_shotgun"]  = { Name = "Shotgun", DPS = 215, Infliction = 0.85, Type = "shotgun" }, -- 860
     
       
       
        --Tool1
        ["weapon_zs_barricadekit"] = { Name = "Agies Barricading kit", DPS = 0, Infliction = 0, Type = "tool1" },
        --Tool2
        ["weapon_zs_tools_plank"]  = { Name = "Pack of Planks", DPS = 0, Infliction = 0, Type = "tool2", Description = "Help your team mates, bring extra planks!"  },
       
        --Pickups
        ["weapon_zs_pickup_gascan"]  = { Name = "Dangerous Gas Can", DPS = 0, Infliction = 0, Type = "misc" },
        ["weapon_zs_pickup_gascan2"]  = { Name = "Dangerous Gas Can2", DPS = 0, Infliction = 0, Type = "misc" },
        ["weapon_zs_pickup_propane"]  = { Name = "Dangerous Propane Tank", DPS = 0, Infliction = 0, Type = "misc" },
        ["weapon_zs_pickup_flare"]  = { Name = "Rusty Flare", DPS = 0, Infliction = 0, Type = "misc" },
        ["weapon_zs_pickup_gasmask"]  = { Name = "Old Gas Mask", DPS = 0, Infliction = 0, Type = "misc" },
       
 
        --Special Items
        ["weapon_zs_special_vodka"]  = { Name = "Vodka", DPS = 0, Infliction = 0, Type = "misc" }, --Duby: I essentially wanted to get some interest back into the dice and the game. This did the trick!
        ["weapon_zs_special_bottleofwine"]  = { Name = "Bottle ol Wine", DPS = 0, Infliction = 0, Type = "misc" },
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
        ["weapon_slam"] = { Name = "Original Shotgun", DPS = 0, Infliction = 0.2, Type = "admin", Restricted = true  },
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
	["ar2"] = 30, --Rifle
	["alyxgun"] = 16,
	["pistol"] = 20, --Pistol
	["smg1"] = 30, --SMG
	["357"] = 10, --Sniper
	["xbowbolt"] = 5,
	["buckshot"] = 20, --Shotgun
	["ar2altfire"] = 1,
	["slam"] = 2, --Explosive
	["rpg_round"] = 1,
	["smg1_grenade"] = 1,
	["sniperround"] = 1,
	["sniperpenetratedround"] = 5,
	["grenade"] = 1, --Grenade
	["thumper"] = 1,
	["gravity"] = 3, --Nail
	["battery"] = 20, --Medkit
	["gaussenergy"] = 50,
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

XP_PLAYERS_REQUIRED = 5

MAX_RANK = 6

-- -- -- -- -- -- -- -- -- -- /
-- [rank] = {unlocks} 
GM.RankUnlocks = {

	--{{HUMAN CLASSES}}--
	
	[0] = {"_medic","_support2","_commando","_berserker","_engineer","_sharpshooter", "_none1", "_none2"},

	[1] = {"_medupgr2","_accuracy","_support","_mine","_headhunter", "_kevlarcommando"},
	
	[2] = {"_medupgr1","_kevlarsupport","_berserk","_blast","_point","_comeback2","_lethal"},
	
	[3] = {"_nade","_supportammo","_freeman","_accuracy2", "_trap", "_oppressive","_medigun"},
	
	[4] = {"_poisonprotect","_kevlar2","_psychopath","_bloodmoney","_sboost","_reload"},
	
	[5] = {"_turret","_psychotic","_repairs", "_supply", "_sboost2"},
	
	[6] = {"_combat","_profitable","_ironaim", "_nitrate"},
		
	
}

-- [name] = {Name = "...", Description = "...", Material = "..." (optional), Slot = (1 or 2)}
--RequiresWeapon = "weapon_zs_tools_hammer",

GM.Perks = {
--RequiresWeapon = What Human Class does the perk require to be shown
					--[[Slot 1 'equipement perk']]--
	["_none1"] = {Name = "None", Description = "No Perk.", Slot = 1},	
	["_none2"] = {Name = "None", Description = "No Perk.", Slot = 2},	
		
	--Medic
	
	["_medupgr2"] = {Name = "Medical Supplies", Description = "+100 medical charges", RequiresWeapon = "_medic", Slot = 1}, --Done
	["_medigun"] = {Name = "Medi 01", Description = "Spawn with the Medi 01", RequiresWeapon = "_medic", Slot = 1}, --Done
	--["_medishot"] = {Name = "Medi ShotGun", Description = "Gives you the Medical ShotGun", RequiresWeapon = "_medic", Slot = 1}, --Done
	["_healingnads"] = {Name = "Healing grenades", Description = "Gives you 5 healing grenades.", RequiresWeapon = "_medic", Slot = 1}, --Need to make
	
	--Commando
	
	["_nade"] = {Name = "Grenadier", Description = "Throw grenades twice as fast | +25% grenade damage | +40 explosion radius", RequiresWeapon = "_commando", Slot = 1}, --Done
	["_accuracy"] = {Name = "Accuracy", Description = "50% less recoil from weapons while crouching or aiming.", RequiresWeapon = "_commando", Slot = 1},  --Done
	["_arsanal"] = {Name = "Additional Arsanal", Description = "Given the Defender Rifle.", RequiresWeapon = "_commando", Slot = 1},  --Done

	--Support
	
	["_support"] = {Name = "Board Pack", Description = "Eight planks at the start of the round with 30% more health.", RequiresWeapon = "_support2", Slot = 1}, --Done
	["_supportammo"] = {Name = "Ammunition", Description = "+30% ammo from mobile supplies.", RequiresWeapon = "_support2", Slot = 1}, --Done
	["_supportweapon"] = {Name = "Fortify", Description = "You get given an extra weapon.", RequiresWeapon = "_support2", Slot = 1}, --Done
	["_repairs"] = {Name = "Handy Man", Description = "+3 repair points.", RequiresWeapon = "_support2", Slot = 1}, --Done	
	
	--Berserker
	
	["_freeman"] = {Name = "Berserker Fury", Description = "20% more damage with melee weapons.", Material = "VGUI/achievements/kill_enemy_knife_bw", RequiresWeapon = "_berserker", Slot = 1}, --Done
	["_psychotic"] = {Name = "Psychotic", Description = "+4 health from kills.", RequiresWeapon = "_berserker", Slot = 1}, --Done
	["_headhunter"] = {Name = "Head Hunter", Description = "+50% melee damage on heads. -15% melee damage.", RequiresWeapon = "_berserker", Slot = 1}, --Added by Pufulet
	["_oppressive"] = {Name = "Oppressive", Description = "Smash zombies away with your mighty weapons!", RequiresWeapon = "_berserker", Slot = 1}, --Added by Pufulet	
	
	--Engineer
	
	["_turret"] = {Name = "Turret Overload", Description = "+50% turret stats.",RequiresWeapon = "_engineer", Material = "VGUI/gfx/VGUI/defuser", Slot = 1}, --Done
	["_nitrate"] = {Name = "Nitrate Stuffed", Description = "+40% C4 explosion radius. 2 second fuse time instead of 1. ",RequiresWeapon = "_engineer", Material = "HUD/scoreboard_clock", Slot = 1}, --Done	
	["_trap"] = {Name = "Trap Engineered", Description = "+40% C4 damage. 70 proximity distance instead of 140. ",RequiresWeapon = "_engineer", Material = "HUD/scoreboard_clock", Slot = 1}, --Done		
	["_pulsepistol"] = {Name = "Pulse Pistol", Description = "Spawn with the pulse pistol", RequiresWeapon = "_engineer", Slot = 1},	--Done
	["_combat"] = {Name = "Combat Turret", Description = "Gives the Combat turret.", RequiresWeapon = "_engineer", Slot = 1},	--Done	
	["_remote"] = {Name = "Turret Remote", Description = "[REPLACES SECONDARY] Control the turret with this gadget! Your turret shoots 2 bullets for the cost of 1!", RequiresWeapon = "_engineer", Slot = 1}, -- Done	
	
	--Sharpshooter
	
	["_lethal"] = {Name = "Python", Description = "Spawn with the python", RequiresWeapon = "_sharpshooter", Slot = 1}, --Done
	["_accuracy2"] = {Name = "Kinetic Absorption", Description = "No recoil while in iron sight", RequiresWeapon = "_sharpshooter", Slot = 1},	--Done
	["_highcal"] = {Name = "Reinforced Calibre", Description = "Greater bullet knock back", RequiresWeapon = "_sharpshooter", Slot = 1},	--Done
	["_supply"] = {Name = "Medical Station", Description = "Mobile supplies gives 4 health to users. +1 SP", RequiresWeapon = "_sharpshooter", Slot = 1},	--Done	
	
					--[[Slot 2 'personal perk']]--
	--Medic
	
	["_medupgr1"] = {Name = "Healthy Reward", Description = "+30% SP for healing", RequiresWeapon = "_medic", Slot = 2}, --Done
	["_poisonprotect"] = {Name = "Natural Immunity", Description = "70% Poison resistance", RequiresWeapon = "_medic", Slot = 2}, --Done
	["_sboost2"] = {Name = "Speed", Description = "+5% movement speed", RequiresWeapon = "_medic", Slot = 2}, --Done
	
	--Commando
	
	["_kevlarcommando"] = {Name = "Kevlar", Description = "+50 initial health", Material = "VGUI/gfx/VGUI/kevlar", RequiresWeapon = "_commando", Slot = 2}, --Done
	["_profitable"] = {Name = "Lead Market", Description = "+30% SP from kills", RequiresWeapon = "_commando", Slot = 2}, --Done
	["_comeback2"] = {Name = "Bring The Pain", Description = "Redeem with a Famas or SG552", RequiresWeapon = "_commando", Slot = 2},
	
	--Support
	
	["_kevlarsupport"] = {Name = "Healthy As A Horse", Description = "+50 maximum health", RequiresWeapon = "_support2", Slot = 2}, --Done
	["_psychopath"] = {Name = "Regeneration", Description = "Regain health like a monster!", RequiresWeapon = "_support2", Slot = 2}, --Done
	["_reload"] = {Name = "Action Reload", Description = "Reload 2 shotgun shells at once!", RequiresWeapon = "_support2", Slot = 2}, --Done
	
	--Berserker
	
	["_bloodmoney"] = {Name = "Blood Money", Description = "+5 SP for melee kills", RequiresWeapon = "_berserker", Slot = 2}, --Done
	["_berserk"] = {Name = "Berserk", Description = "+10% speed while under 40 health", RequiresWeapon = "_berserker", Slot = 2}, --Done
	
	--Engineer
	
	--["_pulsecash"] = {Name = "Pulse Cash", Description = "+5sp from turret kills.", RequiresWeapon = "_engineer", Slot = 2}, --Need to make this!
	["_blast"] = {Name = "Blast Proof", Description = "+50% resistance to explosives", RequiresWeapon = "_engineer", Slot = 2}, --Done
	["_mine"] = {Name = "Multi C4", Description = "Place up to 10 C4 on the floor instead of 5! ",RequiresWeapon = "_engineer", Material = "HUD/scoreboard_clock", RequiresWeapon = "_engineer", Slot = 2}, --Done	
	["_sboost"] = {Name = "Get to the chopper!", Description = "+15% movement speed", RequiresWeapon = "_engineer", Slot = 2}, --Done

	
	--Sharpshooter
	["_kevlar2"] = {Name = "Kevlar", Description = "+50 initial health.", Material = "VGUI/gfx/VGUI/kevlar", RequiresWeapon = "_sharpshooter", Slot = 2}, --Done
	["_point"] = {Name = "Take Point", Description = "15% Crouch speed increase, you take less fall damage and also don't down.", RequiresWeapon = "_sharpshooter", Slot = 2}, --Done
	["_ironaim"] = {Name = "Hard Scope", Description = "Extra 15% zoom speed on sniper rifles!", RequiresWeapon = "_sharpshooter", Slot = 2}, --Done
	
	--[[New ZS Classes]]--
	["_medic"] = {Name = "Medic",		  		Equipment = "Medkit  | P228  |  Knife                            ",Description = "Extra Speed | Extra Pistol Damage | More Medigun Damage | Poison Protection | Damage Resistance | ", Material = "zombiesurvival/humanclass/avatar_medic", Slot = 3},
	["_commando"] = {Name = "Commando",   		Equipment = "Grenades  |   Five SeveN   | Knife               ", Description = "See Undead Health | Extra Health | Extra Rifle Damage | 1 in 12-X chance to not use bullet | Faster Fire Rate |", Material = "zombiesurvival/humanclass/avatar_marksman", Slot = 3},
	["_support2"] = {Name = "Support",    		Equipment = "Board Pack  |  USP   |  Hammer                  ", Description = "Extra SMG Damage | Extra Shotgun Damage | Extra Nail Health | Bonus Repair Power | Extra Nails | Bonus ammunition from SkillShop and mobile supplies | ", Material = "zombiesurvival/humanclass/avatar_constructor", Slot = 3},
	["_berserker"] = {Name = "Berserker", 		Equipment = "Vodka  |  Desert Eagle  |  Plank               ", Description = "+20% Melee Damage | Extra Melee Damage | +2 Health On Melee Kill | Extra Health On Melee Kill | +60% howler screen rape resistance | No Slowdown | Speed Boost |", Material = "zombiesurvival/humanclass/avatar_assault", Slot = 3},
	["_engineer"] = {Name = "Engineer",   		Equipment = "Turret  |  C4  |  Classic Pistol  |  Pan  ", Description = "Bonus Turret Stats | Bonus Turret Fire Rate | Extra Pulse Capacity | Faster Pulse Regen Rate | Increased C4 Damage | Increased C4 Radius |", Material = "zombiesurvival/humanclass/avatar_demolitions", Slot = 3},
	["_sharpshooter"] = {Name = "Sharpshooter", Equipment = "Mobile Supplies  |  Python  |  Beer Bottle		", Description = "Extra Headshot Damage | Extra Speed | Extra Sniper Damage", Material = "zombiesurvival/humanclass/avatar_assault", Slot = 3},	
	["_pyrotechnic"] = {Name = "PyroTechnic", Equipment = "Fame Nades  |  Fare Gun ", Description = "Immune To Fire | Extra Health  |  Possibility To Get A Flamer On Spawn", Material = "zombiesurvival/humanclass/avatar_constructor", Slot = 3}, --Need to start this soon
	
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
UNDEAD_START_AMOUNT_PERCENTAGE = 0.15
UNDEAD_START_AMOUNT_MINIMUM = 2
UNDEAD_START_AMOUNT = 2

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
MAXIMUM_CRATES = 4 -- math.random(2, 3)

-- Use Zombie Survival's custom footstep sounds? I'm not sure how bad it might lag considering you're potentially sending a lot of data on heavily packed servers.
CUSTOM_FOOTSTEPS = false

-- In seconds, repeatatively, the gamemode gives all humans get a box of whatever ammo of the weapon they use.
AMMO_REGENERATE_RATE = 2056744

--Warming up time
WARMUPTIME = 110

-- In seconds, how long humans need to survive.
--ROUNDTIME = (20*60) + WARMUPTIME -- 20 minutes

-- EXPERIMENTAL
ROUNDTIME = (15*60) + WARMUPTIME -- 15 minutes

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
	
	> Damien, Duby, Reiska, Lameshot, Phychopeti,Jeremiah.
	
	-- SERVER CODERS ----------------------------------------------------
	
	>Ywa, Duby, Pufulet.
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
		  - B-hopping
		  - Spawn camping
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
	title = "LV Unlocks", 
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
	"css_urban"
}

SupportPlayerModels = {
	"css_arctic",
	"css_guerilla",
	"css_leet",
	"css_phoenix",
}

BerserkerPlayerModels = {
	"css_gasmask"
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

HumanClasses = { } --Duby: Leave this table as it will cause errors in sv_tables.lua and in the init.lua. I will deal with it soon!
					 --Duby: Removed it, seems ok. I removed a load of stuff in sv_playerspawn and obj_player_extended and also sv_tables.
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
	[52] = { Image = "zombiesurvival/achv_blank_zs", Key = "flare2", ID = 52, Name = "PyroManiac", Desc = "Kill a zombie with the flare gun.",  },
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