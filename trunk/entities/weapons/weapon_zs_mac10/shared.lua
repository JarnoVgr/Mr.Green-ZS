if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Mac 10 Sub-Machine Gun"
	SWEP.Author = "NECROSSIN"
	SWEP.Slot = 0
	SWEP.SlotPos = 12
	SWEP.ViewModelFOV = 65
	SWEP.ViewModelFlip = false
	
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = true
	SWEP.ViewModelBonescales = {}
	
	SWEP.IconLetter = "l"
	killicon.AddFont("weapon_zs_mac10", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_mac10.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_smg_mac10.mdl"

SWEP.Weight = 5

SWEP.HoldType = "pistol"

SWEP.Primary.Sound = Sound("Weapon_MAC10.Single")
SWEP.Primary.Recoil = 4
SWEP.Primary.Damage = 10
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.07

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"

SWEP.MaxAmmo			    = 230

SWEP.ConeMoving = 0.071
SWEP.Cone = 0.059
SWEP.ConeIron = 0.041
SWEP.ConeCrouching = 0.032
SWEP.ConeIronCrouching = 0.024

SWEP.WalkSpeed = 195

SWEP.IronSightsPos = Vector(-6.881, -11.261, 2.68)
SWEP.IronSightsAng = Vector(0, -0.828, 0)
SWEP.OverridePos = Vector(2.279, -3.28, 1.44)
SWEP.OverrideAng = Vector(0, 0, 6.287)