if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Mac 10"
	SWEP.Author = "NECROSSIN"
	SWEP.Slot = 0
	SWEP.SlotPos = 12
	SWEP.ViewModelFOV = 65
	SWEP.ViewModelFlip = true
	
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = true
	SWEP.ViewModelBonescales = {}
	
	SWEP.IconLetter = "l"
	killicon.AddFont("weapon_zs_mac10", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mac10.mdl"

SWEP.Weight = 5

SWEP.HoldType = "pistol"

SWEP.Primary.Sound = Sound("Weapon_MAC10.Single")
SWEP.Primary.Recoil = 6.5
SWEP.Primary.Damage = 14
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.08

SWEP.Primary.ClipSize = 35
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"

SWEP.Primary.Cone = 0.13
SWEP.ConeMoving = 0.20
SWEP.ConeCrouching = 0.1
SWEP.MaxAmmo			    = 230

SWEP.Cone = 0.1
SWEP.ConeMoving = 0.14
SWEP.ConeCrouching = 0.07
SWEP.ConeIron = 0.065
SWEP.ConeIronCrouching = 0.06

SWEP.WalkSpeed = 175

SWEP.IronSightsPos = Vector(6.658, -2.938, 2.913)
SWEP.IronSightsAng = Vector(0.906, 5.217, 7.913)

SWEP.OverridePos = Vector(2.279, -3.28, 1.44)
SWEP.OverrideAng = Vector(0, 0, 6.287)

--SWEP.IronSightsPos = Vector(2.279, -3.28, 1.44)
--SWEP.IronSightsAng = Vector(0, 0, 6.287)

