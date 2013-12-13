AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Mac 10 SMG"
	SWEP.Author = "NECROSSIN"
	SWEP.Slot = 0
	SWEP.SlotPos = 12
	SWEP.ViewModelFOV = 65
	SWEP.ViewModelFlip = false
	
	SWEP.ShowViewModel = true
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
SWEP.Primary.Recoil = 1
SWEP.Primary.Damage = 15
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.093

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"

SWEP.MaxAmmo = 230

SWEP.ConeMoving = 0.069
SWEP.Cone = 0.057
SWEP.ConeIron = 0.046
SWEP.ConeCrouching = 0.039
SWEP.ConeIronCrouching = 0.032

SWEP.WalkSpeed = 195

SWEP.IronSightsPos = Vector(-9.04, -8.426, 2.759)
SWEP.IronSightsAng = Vector(1.483, -5.311, -6.961)
SWEP.OverridePos = Vector(2.279, -3.28, 1.44)
SWEP.OverrideAng = Vector(0, 0, 6.287)