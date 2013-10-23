if SERVER then
        AddCSLuaFile("shared.lua")
end
 
if CLIENT then
        SWEP.PrintName = "'Classic' Pistol"
        SWEP.Author = "NECROSSIN"
        SWEP.Slot = 1
        SWEP.SlotPos = 3
        SWEP.ViewModelFlip = false
        SWEP.ViewModelFOV = 50
       
        SWEP.OverrideAngle = {}
 
       
        killicon.AddFont( "weapon_zs_classic", "HL2MPTypeDeath", "-", Color(255, 255, 255, 255 ) )
end
 
SWEP.Base = "weapon_zs_base"
 
SWEP.Spawnable                  = true
SWEP.AdminSpawnable             = true
 
SWEP.ViewModel = Model("models/weapons/cstrike/c_pist_glock18.mdl")
SWEP.UseHands = true
SWEP.WorldModel = Model("models/weapons/w_pistol.mdl")
 
SWEP.Weight                             = 5
 
SWEP.HoldType = "pistol"
 
SWEP.Primary.Sound                      = Sound("Weapon_Pistol.NPC_Single")
SWEP.ReloadSound                        = Sound("Weapon_Pistol.Reload")
SWEP.Primary.Recoil                     = 3
SWEP.Primary.Damage                     = 13
SWEP.Primary.NumShots           = 2
SWEP.Primary.ClipSize           = 12
SWEP.Primary.Delay                      = 0.2
SWEP.Primary.DefaultClip        = 32
SWEP.MaxAmmo                        = 160
SWEP.Primary.Automatic          = false
SWEP.Primary.Ammo                       = "pistol"
SWEP.Primary.Cone                       = 0.06 --0.12
SWEP.ConeMoving                         = 0.08 -- 0.18
SWEP.ConeCrouching                      = 0.04 -- 0.06
SWEP.WalkSpeed = 200
 
SWEP.ConeMoving = 0.062
SWEP.Cone = 0.045
SWEP.ConeIron = 0.022
SWEP.ConeCrouching = 0.032
SWEP.ConeIronCrouching = 0.014
 
--[==[SWEP.IronSightsPos = Vector(-5.85, -3,4, 0)
SWEP.IronSightsAng = Vector(0.15, -1, 1.5)]==]
 
SWEP.IronSightsPos = Vector(4.38, -1.951, 2.68)
SWEP.IronSightsAng = Vector(0, -0.21, 0)

function SWEP:InitializeClientsideModels()
self.VElements = {
	["pist"] = { type = "Model", model = "models/weapons/c_pistol.mdl", bone = "v_weapon.Glock_Parent", rel = "", pos = Vector(26.976, 1.536, 5.473), angle = Angle(176.932, -16.497, -101.25), size = Vector(10, 10, 10), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

self.ViewModelBoneMods = {
	["v_weapon.Glock_Slide"] = { scale = Vector(0.01, 0.01, 0.01), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["v_weapon.Glock_Parent"] = { scale = Vector(0.46, 0.46, 0.46), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["v_weapon.Glock_Clip"] = { scale = Vector(2.5, 2.5, 2.5), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}
end