AddCSLuaFile()
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_shop.lua")
AddCSLuaFile("cl_obj_player_extend.lua")

CreateConVar("zs_skillshop_buypoints_amount", "100", {FCVAR_REPLICATED}, "")
CreateConVar("zs_skillshop_buypoints_cost", "40", {FCVAR_REPLICATED}, "")



GM.SkillShopAmmo = {
	["pistol"] = {
		Name = "20 Pistol Bullets",
		Model = "models/Items/BoxSRounds.mdl",
		Amount = 20,
		Price = 20
	},
	["357"] = {
		Name = "14 Sniper Bullets",
		Model = "models/Items/357ammo.mdl",
		Amount = 14,
		Price = 45
	},
	["smg1"] = {
		Name = "50 SMG Bullets",
		Model = "models/Items/BoxMRounds.mdl",
		Amount = 50,
		Price = 30
	},
	["ar2"] = {
		Name = "60 Rifle Bullets",
		Model = "models/Items/combine_rifle_cartridge01.mdl",
		Amount = 60,
		Price = 40
	},
	
	["buckshot"] = {
		Name = "16 Shotgun Shells",
		Model = "models/Items/BoxBuckshot.mdl",
		Amount = 16,
		Price = 40
	},
	["slam"] = {
		Name = "C4",
		Model = "models/Items/BoxBuckshot.mdl",
		Tool = "weapon_zs_mine",
		Amount = 1,
		Price = 40,
		ToolTab = true
	},
	["grenade"] = {
		Name = "Grenade",
		Model = "models/Items/BoxBuckshot.mdl",
		Tool = "weapon_zs_grenade",
		Amount = 1,
		Price = 50,
		ToolTab = true
	},
	["gravity"] = {
		Name = "3 Nails",
		Model = "models/Items/BoxBuckshot.mdl",
		Tool = "weapon_zs_tools_hammer",
		Amount = 3,
		Price = 20,
		ToolTab = true
	},

	["Battery"] = {
		Name = "50 Medkit Charge",
		Model = "models/Items/BoxBuckshot.mdl",
		Amount = 50,
		Price = 100,
		ToolTab = true
	},
	
	["xbowbolt"] = { --Instead of the KF Potato, I wanted to add a more community feel to the game. I think this did the trick! aha English humor..
		Name = "Mogadonskoda's Used Dildo",
		Model = "models/Items/BoxBuckshot.mdl",
		Amount = 1,
		Price = 10000,
		ToolTab = true
	},
	
}