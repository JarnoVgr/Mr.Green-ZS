-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Five-seveN"			
	SWEP.Author	= "Ywa"
	SWEP.Slot = 1
	SWEP.ViewModelFOV = 68
	SWEP.SlotPos = 4
	SWEP.IconLetter = "u"
	killicon.AddFont("weapon_zs_fiveseven", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
	
	SWEP.IgnoreThumbs = true

	
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_pist_fiveseven.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_pist_fiveseven.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "pistol"

SWEP.Primary.Sound			= Sound( "Weapon_FiveSeven.Single" )
SWEP.Primary.Recoil			= 8
SWEP.Primary.Unrecoil		= 3
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 15
SWEP.Primary.Delay			= 0.12
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Cone			= 0.04
SWEP.MaxBulletDistance 		= 1900
SWEP.MaxAmmo			    = 60
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.Cone = 0.055
SWEP.ConeMoving = 0.060
SWEP.ConeCrouching = 0.03
SWEP.ConeIron = 0.04
SWEP.ConeIronCrouching = 0.02

SWEP.WalkSpeed = 200

SWEP.IronSightsPos = Vector(-5.961, -12.363, 2.88)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.OverridePos = Vector(1.12, -0.913, 1.919)
SWEP.OverrideAng = Vector( 0,0,0 )

--SWEP.IronSightsPos = Vector(1.12, -0.913, 1.919)
--SWEP.IronSightsAng = Vector(0, 0, 0)