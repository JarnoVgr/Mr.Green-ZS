-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "tmp"			
	SWEP.Author	= "Ywa"
	SWEP.Slot = 0
	SWEP.ViewModelFOV = 65
	SWEP.SlotPos = 19
	SWEP.IconLetter = "d"
	killicon.AddFont("weapon_zs_tmp", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_smg_tmp.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_smg_tmp.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "smg"

SWEP.Primary.Sound			= Sound("Weapon_TMP.Single")
SWEP.Primary.Recoil			= 7
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 25
SWEP.Primary.Delay			= 0.07
SWEP.Primary.DefaultClip	= 75
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.MaxAmmo			    = 250


SWEP.ConeMoving = 0.082
SWEP.Cone = 0.077
SWEP.ConeIron = 0.069
SWEP.ConeCrouching = 0.070
SWEP.ConeIronCrouching = 0.056

SWEP.WalkSpeed = 197
SWEP.MaxBulletDistance 		= 2250

SWEP.IronSightsPos = Vector(-6.881, -12.039, 2.519)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.OverridePos = Vector(1.559, -3.116, 1.6)
SWEP.OverrideAng = Vector(0, 0, 0)


--SWEP.IronSightsPos = Vector(1.559, -3.116, 1.6)
--SWEP.IronSightsAng = Vector(0, 0, 0)