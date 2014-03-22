-- � Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "M249"			
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 0
	SWEP.SlotPos = 9
	SWEP.ViewModelFOV = 68
	SWEP.IconLetter = "z"
	SWEP.ViewModelFlip = false
	SWEP.FlipYaw = true
	killicon.AddFont("weapon_zs_m249", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model("models/weapons/cstrike/c_mach_m249para.mdl")
SWEP.UseHands = true
SWEP.WorldModel			= Model("models/weapons/w_mach_m249para.mdl")

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "smg"

SWEP.Primary.Sound			= Sound("Weapon_M249.Single")
SWEP.Primary.Recoil			= 4
SWEP.Primary.Damage			= 27
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 100
SWEP.storeclipsize			= 100
SWEP.Primary.Delay			= 0.096
SWEP.Primary.DefaultClip	= 450
SWEP.MaxAmmo			    = 500
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.FirePower = (SWEP.Primary.Damage * SWEP.Primary.ClipSize)

SWEP.ConeMoving = 0.079
SWEP.Cone = 0.059
SWEP.ConeIron = 0.051
SWEP.ConeCrouching = 0.042
SWEP.ConeIronCrouching = 0.031


SWEP.WalkSpeed = 191
SWEP.MaxBulletDistance = 2450

SWEP.IronSightsPos = Vector(-5.961, -6.535, 2.359)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.OverridePos = Vector(-1.601, -1.311, 1.6)
SWEP.OverrideAng = Vector( 0,0,0 )

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/sniper/xms_sniperrifle.mdl", bone = "v_weapon.bullet1", rel = "", pos = Vector(-2.651, 13.626, -4.856), angle = Angle(0, 90, 0), size = Vector(1.113, 1.113, 1.113), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.045, 0.957, -9.516), angle = Angle(-10.737, 0, 0), size = Vector(0.958, 0.958, 1.164), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

--SWEP.IronSightsPos = Vector(-1.601, -1.311, 1.6)
--SWEP.IronSightsAng = Vector(0, 0, 0)