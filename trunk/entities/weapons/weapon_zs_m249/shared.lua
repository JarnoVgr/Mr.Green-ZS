-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "M249 SAW"			
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

SWEP.ViewModel			= Model("models/weapons/v_mach_m249para.mdl")
SWEP.WorldModel			= Model("models/weapons/w_mach_m249para.mdl")

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "smg"

SWEP.Primary.Sound			= Sound("Weapon_M249.Single")
SWEP.Primary.Recoil			= 27
SWEP.Primary.Unrecoil		= 4
SWEP.Primary.Damage			= 48
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 100
SWEP.storeclipsize			= 100
SWEP.Primary.Delay			= 0.09
SWEP.Primary.DefaultClip	= 100
SWEP.MaxAmmo			    = 400
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.Cone			= 0.14
SWEP.FirePower = (SWEP.Primary.Damage * SWEP.Primary.ClipSize)

SWEP.Cone = 0.12
SWEP.ConeMoving = 0.18
SWEP.ConeCrouching = 0.085
SWEP.ConeIron = 0.12
SWEP.ConeIronCrouching = 0.1

SWEP.WalkSpeed = 155
SWEP.MaxBulletDistance = 2450

SWEP.IronSightsPos = Vector(-4.49,-2,2.15)
SWEP.IronSightsAng = Vector(.00001,-.06,.00001)

SWEP.OverridePos = Vector(-1.601, -1.311, 1.6)
SWEP.OverrideAng = Vector( 0,0,0 )

--SWEP.IronSightsPos = Vector(-1.601, -1.311, 1.6)
--SWEP.IronSightsAng = Vector(0, 0, 0)