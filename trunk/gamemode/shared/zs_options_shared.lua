-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

GM.Version  = "Green Apocalypse"
GM.SubVersion = ""
--Testing shop

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
DEFAULT_JUMP_POWER = 180
DEFAULT_STEP_SIZE = 18
DEFAULT_MASS = 80
DEFAULT_MODELSCALE = 1-- Vector(1, 1, 1)

-- Horde stuff
HORDE_MAX_ZOMBIES = 15
HORDE_MAX_DISTANCE = 2000

BONUS_RESISTANCE_WAVE = 5
BONUS_RESISTANCE_AMOUNT = 20 -- %

--EVENT: Halloween
HALLOWEEN = false

--EVENT: Christmas
CHRISTMAS = false

--EVENT: Aprils Fools
FIRSTAPRIL = false


--Boss stuff
BOSS_TOTAL_PLAYERS_REQUIRED = 2
BOSS_CLASS = {10, 11, 13, 18, 20}
--BOSS_CLASS = {12} --Seeker
--BOSS_CLASS = {16} --Lilith
--BOSS_CLASS = {10} --hate
--BOSS_CLASS = {15} --Klinator
--BOSS_CLASS = {17} --Smoker class
--BOSS_CLASS = {18} --Seeker2
--BOSS_CLASS = {19} --REMEIL
--BOSS_CLASS = {11} --Behemoth
--BOSS_CLASS = {19} --Pumpking!
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
	--Melee
	["weapon_zs_melee_axe"]  = { Name = "Axe", DPS = 78, Infliction = 0.5, Type = "melee", Price = 300 }, 
	["weapon_zs_melee_katana"]  = { Name = "Katana", DPS = 90, Infliction = 0, Type = "melee", Price = 800, Description = "Handle with care. It's very sharp." },
	["weapon_zs_melee_crowbar"]  = { Name = "Crowbar", DPS = 85, Infliction = 0.65, Type = "melee", Price = 290 },
	["weapon_zs_melee_keyboard"]  = { Name = "Keyboard", DPS = 45, Infliction = 0, Type = "melee", Price = 50, Description = "There's no better way to express your online anger." },
	["weapon_zs_melee_plank"]  = { Name = "Plank", DPS = 56, Infliction = 0, Type = "melee",Price = 40, Description = "The noobs ultimate weapon."  }, 
	["weapon_zs_melee_pot"]  = { Name = "Pot", DPS = 61, Infliction = 0, Type = "melee",Price = 160, Description = "Don't do school stay in drugs, live the pot!" }, 
	["weapon_zs_melee_fryingpan"]  = { Name = "Frying Pan", DPS = 70, Infliction = 0, Type = "melee", Price = 100, Description = "Cooking by the book." },
	["weapon_zs_melee_combatknife"]  = { Name = "Combat Knife", DPS = 15, Infliction = 0, Type = "melee" , Price = 40 },
	["weapon_zs_melee_shovel"]  = { Name = "Shovel", DPS = 40, Infliction = 0, Type = "melee", Price = 550, Description = "" },
	["weapon_zs_melee_sledgehammer"]  = { Name = "Sledgehammer", DPS = 38, Infliction = 0, Type = "melee", Price = 650 },
	["weapon_zs_melee_hook"]  = { Name = "Meat Hook", DPS = 38, Infliction = 0, Type = "melee", Price = 130, Description = "Bish bash bosh, fast smacking and hard hitting!"  },
	["weapon_zs_melee_pipe"]  = { Name = "Pipe", DPS = 30, Infliction = 0, Type = "melee", Price = 80, Description = "Whoops. Looks like I shouldn't of hit him so hard.."  },
	["weapon_zs_melee_pipe2"]  = { Name = "Improved Pipe", DPS = 30, Infliction = 0, Type = "melee", Price = 90, Description = "Clunk, oh look his head fell off.."  },
	["weapon_zs_melee_chainsaw"]  = { Name = "Chain SAW!", DPS = 30, Infliction = 0, Type = "melee", Price = 850, Description = "This may become a bit gory." },

	--Pistols
	["weapon_zs_fiveseven"]  = { Name = "Five-Seven",Mat = "VGUI/gfx/VGUI/fiveseven", DPS = 91, Infliction = 0.15, Type = "pistol", Price = 130 },
	["weapon_zs_glock3"]  = { Name = "Glock", DPS = 120,Mat = "VGUI/gfx/VGUI/glock18", Infliction = 0.25, Type = "pistol", Price = 260 },
	["weapon_zs_elites"]  = { Name = "Dual-Elites", DPS = 92,Mat = "VGUI/gfx/VGUI/elites", Infliction = 0.25, Type = "pistol", Price = 260, Description = "High fire rate thanks to having two pistols in your hands." },
	["weapon_zs_magnum"]  = { Name = ".357 Magnum", DPS = 121, Infliction = 0.3, Type = "pistol", Price = 350, Description = "Russian Roulette Revolver" },
	["weapon_zs_deagle"]  = { Name = "Desert Eagle",Mat = "VGUI/gfx/VGUI/deserteagle", DPS = 93, Infliction = 0.2, Type = "pistol", Price = 390 },
	
	["weapon_zs_usp"]  = { Name = "USP .45", DPS = 42,Mat = "VGUI/gfx/VGUI/usp45", Infliction = 0, Type = "pistol", Price = 70, Description = "Fast firing lower damage." },
	["weapon_zs_p228"]  = { Name = "P228", DPS = 58,Mat = "VGUI/gfx/VGUI/p228", Infliction = 0, Type = "pistol", Price = 80, Description = "More power, slower fire rate."  },
	["weapon_zs_classic"]  = { Name = "'Classic' Pistol", DPS = 30, Infliction = 0.25, Type = "pistol", Price = 120, Description = "Classic Half-Life 2 pistol." },
	--["weapon_zs_alyx"]  = { Name = "Alyx Gun", DPS = 30, Infliction = 0.25, Type = "pistol", Price = 190, Description = "Alyx is hot. But her gun is even more hot." },
	--["weapon_zs_barreta"]  = { Name = "Barreta", DPS = 30,Mat = "VGUI/gfx/VGUI/elites", Infliction = 0.25, Type = "pistol",Price = 450 },
	
	--Light Guns
	["weapon_zs_p90"]  = { Name = "P90", DPS = 125,Mat = "VGUI/gfx/VGUI/p90", Infliction = 0.65, Type = "smg", Price = 450 },
	["weapon_zs_smg"]  = { Name = "Classic SMG", DPS = 125, Infliction = 0.65, Type = "smg", Price = 100},
	["weapon_zs_ump"]  = { Name = "UMP", DPS = 110,Mat = "VGUI/gfx/VGUI/ump45", Infliction = 0.60, Type = "smg", Price = 460 },
	["weapon_zs_mp5"]  = { Name = "MP5", DPS = 127,Mat = "VGUI/gfx/VGUI/mp5", Infliction = 0.58, Type = "smg", Price = 440 },
	["weapon_zs_tmp"]  = { Name = "Silent TMP", DPS = 107,Mat = "VGUI/gfx/VGUI/tmp", Infliction = 0.56, Type = "smg", Price = 350 },
	["weapon_zs_mac10"]  = { Name = "Mac 10", DPS = 126,Mat = "VGUI/gfx/VGUI/mac10", Infliction = 0.60, Type = "smg", Price = 330 },
	["weapon_zs_scout"]  = { Name = "Scout Sniper", DPS = 40,Mat = "VGUI/gfx/VGUI/scout", Infliction = 0, Type = "rifle", Price = 800, Description = "Light-weight sniper." },

			
	--Medium Guns
	["weapon_zs_famas"]  = { Name = "Famas", DPS = 140,Mat = "VGUI/gfx/VGUI/famas", Infliction = 0.7, Type = "rifle", Price = 550 },
	["weapon_zs_sg552"]  = { Name = "SG552 Rifle", DPS = 106,Mat = "VGUI/gfx/VGUI/sg552", Infliction = 0.51, Type = "rifle", Price = 650 },
	["weapon_zs_galil"]  = { Name = "Galil", DPS = 129,Mat = "VGUI/gfx/VGUI/galil", Infliction = 0.57, Type = "rifle", Price = 800 },
	["weapon_zs_ak47"]  = { Name = "AK-47", DPS = 133,Mat = "VGUI/gfx/VGUI/ak47", Infliction = 0.7, Type = "rifle", Price = 900 },
	["weapon_zs_m4a1"]  = { Name = "M4A1", DPS = 138,Mat = "VGUI/gfx/VGUI/m4a1", Infliction = 0.65, Type = "rifle", Price = 950 },
	["weapon_zs_aug"]  = { Name = "Steyr AUG", DPS = 125,Mat = "VGUI/gfx/VGUI/aug", Infliction = 0.53, Type = "rifle", Price = 1000 },
	["weapon_zs_sg550"]  = { Name = "SG550", DPS = 70,Mat = "VGUI/gfx/VGUI/sg550", Infliction = 0.65, Type = "rifle", Price = 900  },
	
	--Heavy
	["weapon_zs_m3super90"]  = { Name = "M3-Super90 Shotgun", DPS = 149,Mat = "VGUI/gfx/VGUI/m3", Infliction = 0, Type = "shotgun", Price = 1200},
	["weapon_zs_m249"]  = { Name = "M249", DPS = 200,Mat = "VGUI/gfx/VGUI/m249", Infliction = 0.85, Type = "rifle", Price = 1650 },
	["weapon_zs_m1014"]  = { Name = "M1014 Auto-Shotgun", DPS = 246,Mat = "VGUI/gfx/VGUI/xm1014", Infliction = 0.85, Type = "shotgun", Price = 1100},
	["weapon_zs_awp"]  = { Name = "AWP", DPS = 200,Mat = "VGUI/gfx/VGUI/awp", Infliction = 0, Type = "rifle", Price = 1400, Description = "Heavy sniper." },
	["weapon_zs_boomerstick"]  = { Name = "Boom Stick", DPS = 215, Infliction = 0.85, Type = "shotgun", Price = 1700 },
	["weapon_zs_boomstick"]  = { Name = "Boom Stick", DPS = 215, Infliction = 0.85, Type = "shotgun" },
	
	["weapon_zs_crossbow"]  = { Name = "Crossbow", DPS = 220, Infliction = 0, Type = "rifle",Price = 1600 },


	--Uncategorized
	["weapon_zs_minishotty"]  = { Name = "'Farter' Shotgun", DPS = 126, Infliction = 0, Type = "shotgun" },
	["weapon_zs_fists"]  = { Name = "Fists", DPS = 30, Infliction = 0, Restricted = true, Type = "melee", Description = "Punch a Zombie in the face." },
	["weapon_zs_fists2"]  = { Name = "Fists", DPS = 30, Infliction = 0, Restricted = true, Type = "melee" },
	["weapon_zs_shotgun"]  = { Name = "Shotgun", DPS = 215, Infliction = 0.85, Type = "shotgun" }, -- 860
	["weapon_zs_pulsesmg"]  = { Name = "Pulse SMG", DPS = 99, Infliction = 0, Type = "smg", Price = 350},
--	["weapon_zs_pulserifle"]  = { Name = "Pulse Rifle", DPS = 143, Infliction = 0, Type = "rifle" },
	--["weapon_zs_dubpulse"]  = { Name = "Super Pulse Rifle", DPS = 143, Infliction = 0, Type = "rifle", Price = 6000 }, --Seems to work fine now.
	["weapon_zs_flaregun"]  = { Name = "Flare Gun", DPS = 143, Infliction = 0, Type = "rifle", Description = "Alert other Survivors when you're in need of help." },
	--["weapon_zs_minishotty"]  = { Name = "Farter shotgun", DPS = 143, Infliction = 0, Type = "shotgun" },
	
	
	--Tool1
	["weapon_zs_tools_hammer"]  = { Name = "Nailing Hammer", DPS = 23, Infliction = 0, Type = "tool1", Description = "Stop! Hammer time. This will freeze props in their place." },
	["weapon_zs_medkit"]  = { Name = "Medical Kit", DPS = 8, Infliction = 0, Type = "tool1", Description = "Be a good teammate. Or just heal yourself." },
	["weapon_zs_tools_supplies"] = { Name = "Mobile Supplies", DPS = 0, Infliction = 0, Type = "tool1", Description = "Allows you to spawn a Supply Crate." },
	["weapon_zs_tools_remote"] = { Name = "Remote Controller", DPS = 0, Infliction = 0, Type = "tool2" },
	["weapon_zs_tools_torch"] = { Name = "Torch", DPS = 0, Infliction = 0, Type = "tool1", Description = "Fix broken nails to prevent barricades getting broken." },
	["weapon_zs_barricadekit"] = { Name = "Agies Barricading kit", DPS = 0, Infliction = 0, Type = "tool1" },
	
	--Tool2
	["weapon_zs_miniturret"] = { Name = "Combat Mini-Turret", DPS = 0, Infliction = 0, Type = "tool1", Description = "CBA to shoot, let your friend here help you with that!"  },
	["weapon_zs_turretplacer"] = { Name = "Turret", DPS = 0, Infliction = 0, Type = "tool1", Description = "Need more fire power? Here you go!"  },
	["weapon_zs_grenade"]  = { Name = "Grenade", DPS = 8, Infliction = 0, Type = "tool1", Description = "BOOM!" },
	["weapon_zs_mine"]  = { Name = "Explosives", DPS = 8, Infliction = 0, Type = "tool1", Description = "BOOM, get your team out a tough spot.."  },
	["weapon_zs_tools_plank"]  = { Name = "Pack of Planks", DPS = 0, Infliction = 0, Type = "tool1", Description = "Help your team mates, bring extra planks!"  },
	
	--Pickups
	["weapon_zs_pickup_gascan2"]  = { Name = "Dangerous Gas Can", DPS = 0, Infliction = 0, Type = "misc" },
	["weapon_zs_pickup_propane"]  = { Name = "Dangerous Propane Tank", DPS = 0, Infliction = 0, Type = "misc" },
	["weapon_zs_pickup_flare"]  = { Name = "Rusty Flare", DPS = 0, Infliction = 0, Type = "misc" },
	["weapon_zs_pickup_gasmask"]  = { Name = "Old Gas Mask", DPS = 0, Infliction = 0, Type = "misc" },
	["weapon_zs_chipper"]  = { Name = "Chipper", DPS = 143,Mat = "VGUI/gfx/VGUI/m3", Infliction = 0, Type = "shotgun", Price = 100 },

	--Special Items

	["weapon_zs_vodka"]  = { Name = "Bottle ol Vodka", DPS = 0, Infliction = 0, Type = "misc" },
	["weapon_zs_chembomb"]  = { Name = "Chemical Nade", DPS = 0, Infliction = 0, Type = "misc" },
	
	
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


----------------------------------
--		AMMO REGENERATION		--
----------------------------------
-- This is how much ammo a player is given for whatever type it is on ammo regeneration.
-- Players are given double these amounts if 75% or above Infliction.
-- Changing these means you're an idiot.
-- Duby: This is confusing when it has this name... Its the amount of ammo which the crate gives out. :P

GM.AmmoRegeneration = {
	["ar2"] = 60, --Rifle
	["alyxgun"] = 16,
	["pistol"] = 30, --Pistol
	["smg1"] = 60, --SMG
	["357"] = 15, --Sniper
	["xbowbolt"] = 5,
	["buckshot"] = 25, --Shotgun
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
XP_BLANK = 350

XP_INCREASE_BY = 2550

XP_PLAYERS_REQUIRED = 6

MAX_RANK = 30

-- -- -- -- -- -- -- -- -- -- /
-- [rank] = {unlocks} 
GM.RankUnlocks = {
	[0] = {"weapon_zs_usp","weapon_zs_fists2","_comeback2","weapon_zs_tools_torch","weapon_zs_medkit","weapon_zs_tools_supplies","weapon_zs_turretplacer","weapon_zs_grenade","weapon_zs_mine","weapon_zs_melee_plank","_remote"},
	[1] = {"weapon_zs_tools_plank","weapon_zs_tools_hammer"},
	[2] = {"weapon_zs_p228","_nade"},
	[3] = {"_extranails","_kevlar"},
	[4] = {"_turretammo"},
	[5] = {"weapon_zs_melee_keyboard"},
	[6] = {"weapon_zs_melee_pipe"},
	[7] = {"_turrethp"},
	[9] = {"_falldmg",},
	[10] = {"_falldown"},
	[11] = {"_kevlar2","_horse"},
	[12] = {"weapon_zs_melee_pipe2"},
	[13] = {"_nailhp"},
	[14] = {"_poisonprotect"},
	[15] = {"weapon_zs_melee_hook"},
	[16] = {"_support"},
	[17] = {"_turretdmg"},
	[19] = {"weapon_zs_melee_pot"},
	[21] = {"_mine"},
	[22] = {"_sboost"},
	[24] = {"weapon_zs_melee_combatknife"},
	[28] = {"_adrenaline"},
	[29] = {"weapon_zs_melee_axe"},
	[31] = {"_medupgr1"},
	[32] = {"weapon_zs_classic"},
	[33] = {"_freeman"},
	[34] = {"_medupgr2"},
	[35] = {"weapon_zs_fiveseven"},
	[36] = {"weapon_zs_miniturret"},
	-- [90] = {"_professional"},-- hidden for a while
}

-- [name] = {Name = "...", Description = "...", Material = "..." (optional), Slot = (1 or 2)}
GM.Perks = {
	["_kevlar"] = {Name = "Kevlar", Description = "Gives you 10 more HP.", Material = "VGUI/gfx/VGUI/kevlar", Slot = 2},
	["_kevlar2"] = {Name = "Kevlar2", Description = "Gives you 20 more HP.", Material = "VGUI/gfx/VGUI/kevlar", Slot = 2},
	["_freeman"] = {Name = "Berserker", Description = "Do 30% more damage and attack faster with melee weapons.", Material = "VGUI/achievements/kill_enemy_knife_bw", Slot = 2},
	["_adrenaline"] = {Name = "Adrenaline Injection", Description = "Negates speed reduction on low health. Also your screen won't turn red when you are low on health.", Slot = 2},
	["_sboost"] = {Name = "SpeedBoost", Description = "8% increase in walking speed.", Slot = 2},	
	["_poisonprotect"] = {Name = "Poison Protection", Description = "30% less damage from Poison Headcrabs.", Slot = 2},
	["_falldown"] = {Name = "Fall Down", Description = "Prevents you from falling over from high jumps or being hit by props.", Slot = 2},
	["_falldmg"] = {Name = "Fall Protection", Description = "25% less fall damage.", Slot = 2},
	["_comeback2"] = {Name = "Reborn", Description = "When redeeming you will spawn once with either a Deagle or a pair of Dual Elites.", Material = "VGUI/logos/spray_elited", Slot = 2},
	["_remote"] = {Name = "Turret Remote", Description = "Gives you the turret remote 'Requires turret'", RequiresWeapon = "weapon_zs_turretplacer", Slot = 2},
	["_horse"] = {Name = "Health Regenerate", Description = "If you take damage after 60 seconds you will regain the HP!", Slot = 2},
	
	["_support"] = {Name = "Extra Planks", Description = "Five planks at the start of the round, with 30% more health.", RequiresWeapon = "weapon_zs_tools_plank", Slot = 1},
	["_extranails"] = {Name = "Pack of Nails", Description = "Double the amount of nails for your hammer!", RequiresWeapon = "weapon_zs_tools_hammer", Slot = 1},
	["_nailhp"] = {Name = "Nail HP", Description = "Double the health of your nails!", Material = "HUD/scoreboard_clock", RequiresWeapon = "weapon_zs_tools_hammer", Slot = 1},
	["_turretammo"] = {Name = "Turret Ammo", Description = "50% more ammo for turret", RequiresWeapon = "weapon_zs_turretplacer", Slot = 1},
	["_turrethp"] = {Name = "Turret Durability", Description = "50% more health for turret", Material = "VGUI/gfx/VGUI/defuser", RequiresWeapon = "weapon_zs_turretplacer", Slot = 1},
	["_turretdmg"] = {Name = "Turret Power", Description = "50% more turret's damage", RequiresWeapon = "weapon_zs_turretplacer", Slot = 1},	
	["_medupgr1"] = {Name = "Medical Efficiency", Description = "35% more healing power", RequiresWeapon = "weapon_zs_medkit", Slot = 1},
	["_medupgr2"] = {Name = "Medical Pack", Description = "Doubled maximum Medical Kit charges", RequiresWeapon = "weapon_zs_medkit", Slot = 1},
	["_nade"] = {Name = "Grenades tosser", Description = "Throw Grenades twice as quickly! ", RequiresWeapon = "weapon_zs_grenade", Slot = 1},
	["_trchregen"] = {Name = "Handy Man", Description = "40% increased repair with Torch.", Material = "HUD/scoreboard_clock", RequiresWeapon = "weapon_zs_tools_torch", Slot = 1},
	["_mine"] = {Name = "Multi Mine", Description = "Place up to 10 mines on the floor! ", Material = "HUD/scoreboard_clock", RequiresWeapon = "weapon_zs_mine", Slot = 1},
	
--	["_imortalpro"] = {Name = "Immortal Protector", Description = "You will spawn with the Pulse SMG!", Slot = 2}
	--["_professional"] = {Name = "Professional", Description = "This perk has no effect yet!", Material = "VGUI/logos/spray_elited", Slot = 1},
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
CARRY_SPEEDLOSS_MINSPEED = 150

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
ROUNDTIME = (20*60) + WARMUPTIME -- 20 minutes

-- Time in seconds between end round and next map.
INTERMISSION_TIME = 35

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

--Sound to play for last human.
LASTHUMANSOUND = "mrgreen/music/lasthuman.mp3"
LASTHUMANSOUNDLENGTH = 159 -- 2:39

-- Rave sound; people will hate me for making this :')
RAVESOUND = "mrgreen/ravebreak_fix.mp3"

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
REDEEM_FAST_LEVEL = 10

-- Use soft collisions for teammates
SOFT_COLLISIONS = false

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
-The crate works on a timer. Once its ready and you press 'e' on it. 
It will give you weapons == to the amount of SP you have.
-The crate moves around the map. So make sure you are either on the move,
or nice and snug behind a good cade!!
-You gain Greencoins from killing humans!

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
At SkillShop you buy Weapons, Ammo and Supplies with SkillPoints (SP). These points are earned by killing Zombies and helping teammates.

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
	
	> Damien, Duby, Reiska, Lameshot, Phychopeti,Jeremiah,Szl.
	
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
		This is the Unlock tree for every unlock on the server. WorkHard PlayHard!! ^^
		Some levels don't have any unlocks. 
		
[0] = USP, FISTS, KEVLAR3, COMBACK2, P228, Torch, Hammer, 
[0] = Medkit, Supplies, Turret, Granade, Mine, Plank 
[1] = PLANK'tool'  	
[2] = Experienced Medic 
[3] = Upgraded Hammer	 
[4] = 'Classic' SMG		
[5] = Keyboard	
[6] = PIPE1	 
[7] = IMORTALPRO
[8] = Nothing ;'(		 
[9] = Fall Damage
[10] = Support
[11] = Kevlar	
[12] = PIPE2	
[13] = Berserker	
[14] = POISON PROTECTION
[15] = Hook	
[17] = Turret Overdrive	
[19] = Classic Pistol	
[21] = CLASSICE PISTOL	
[22] = SPEED BOOST1	
[24] = Combat Knife	
[26] = COMBAT KNIFE		
[28] = ADRENALINE INJECTION	
[29] = CROWBAR	
[30] = MINI TURRET
	
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
		"combie_soldier_prisonguard"
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
--[[
HumanClasses[3] =
{
	Name = "Berserker",--Aka Marksman
	Tag = "berserker",
	Health = 90,
	Description = {"% increased scope zoom","% chance to spawn with scout","% more bullet force"," more long range hs dmg"},
	Coef = {7,3,18,4},
	Models = {"models/player/gasmask.mdl","models/player/odessa.mdl","models/player/group01/male_04.mdl","models/player/hostage/hostage_02.mdl"},
	Speed = 200
}

HumanClasses[4] =
{
	Name = "Engineer",
	Health = 100,
	Description = {"% chance to spawn with turret","% increased clip for pulse weapons","% chance to spawn with pulse smg","% more turret's efficiency"},
	Models = {"models/player/alyx.mdl","models/player/barney.mdl","models/player/eli.mdl","models/player/mossman.mdl","models/player/kleiner.mdl","models/player/breen.mdl" },
	Speed = 190
	}]]--


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