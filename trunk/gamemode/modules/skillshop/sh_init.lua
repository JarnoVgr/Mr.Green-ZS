AddCSLuaFile()
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_shop.lua")
AddCSLuaFile("cl_obj_player_extend.lua")

CreateConVar("zs_skillshop_buypoints_amount", "100", {FCVAR_REPLICATED}, "")
CreateConVar("zs_skillshop_buypoints_cost", "40", {FCVAR_REPLICATED}, "")



GM.SkillShopAmmo = {
	["pistol"] = {
		Name = "12 Pistol Bullets",
		Model = "models/Items/BoxSRounds.mdl",
		Amount = 12,
		Price = 20
	},
	["357"] = {
		Name = "6 Sniper Bullets",
		Model = "models/Items/357ammo.mdl",
		Amount = 6,
		Price = 30
	},
	["smg1"] = {
		Name = "30 SMG Bullets",
		Model = "models/Items/BoxMRounds.mdl",
		Amount = 30,
		Price = 25
	},
	["ar2"] = {
		Name = "30 Rifle Bullets",
		Model = "models/Items/combine_rifle_cartridge01.mdl",
		Amount = 35,
		Price = 30
	},
	
	["buckshot"] = {
		Name = "12 Shotgun Shells",
		Model = "models/Items/BoxBuckshot.mdl",
		Amount = 12,
		Price = 30
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
		Price = 60,
		ToolTab = true
	},
	["gravity"] = {
		Name = "Nail",
		Model = "models/Items/BoxBuckshot.mdl",
		Tool = "weapon_zs_tools_hammer",
		Amount = 1,
		Price = 10,
		ToolTab = true
	},

	["Battery"] = {
		Name = "30 Medkit Charge",
		Model = "models/Items/BoxBuckshot.mdl",
		Amount = 30,
		Price = 30,
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