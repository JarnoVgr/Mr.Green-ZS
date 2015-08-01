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
		Price = 40
	},
	["alyxgun"] = {
		Name = "40 Pyro Rounds",
		Model = "models/Items/BoxSRounds.mdl",
		Amount = 40,
		Price = 40
	},	
	["357"] = {
		Name = "12 Sharpshooter Rounds",
		Model = "models/Items/357ammo.mdl",
		Amount = 12,
		Price = 40
	},
	["smg1"] = {
		Name = "50 SMG Bullets",
		Model = "models/Items/BoxMRounds.mdl",
		Amount = 50,
		Price = 40
	},
	["ar2"] = {
		Name = "60 Commando Rounds",
		Model = "models/Items/combine_rifle_cartridge01.mdl",
		Amount = 60,
		Price = 40
	},
	
	["buckshot"] = {
		Name = "12 Shotgun Shells",
		Model = "models/Items/BoxBuckshot.mdl",
		Amount = 12,
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
		Price = 40,
		ToolTab = true
	},
	["gravity"] = {
		Name = "6 Nails",
		Model = "models/Items/BoxBuckshot.mdl",
		Tool = "weapon_zs_tools_hammer",
		Amount = 6,
		Price = 30,
		ToolTab = true
	},

	["Battery"] = {
		Name = "50 Medic Rounds",
		Model = "models/Items/BoxBuckshot.mdl",
		Amount = 50,
		Price = 50,
		ToolTab = true
	}

}