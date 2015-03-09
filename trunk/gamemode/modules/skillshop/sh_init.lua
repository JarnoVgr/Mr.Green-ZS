AddCSLuaFile()
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_shop.lua")
AddCSLuaFile("cl_obj_player_extend.lua")

CreateConVar("zs_skillshop_buypoints_amount", "150", {FCVAR_REPLICATED}, "")
CreateConVar("zs_skillshop_buypoints_cost", "40", {FCVAR_REPLICATED}, "")

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