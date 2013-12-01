-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Five-Seven"			
	SWEP.Author	= "Ywa"
	SWEP.Slot = 1
	SWEP.ViewModelFOV = 50
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
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 17
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 18
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 80
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.MaxBulletDistance 		= 1900
SWEP.MaxAmmo			    = 60
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.ConeMoving = 0.060
SWEP.Cone = 0.047
SWEP.ConeIron = 0.029
SWEP.ConeCrouching = 0.031
SWEP.ConeIronCrouching = 0.019

SWEP.WalkSpeed = 200

SWEP.IronSightsPos = Vector( -5.969, -1.5, 2.79 )
SWEP.IronSightsAng = Vector( 0, 0, 0 )

SWEP.OverridePos = Vector( 1.12, -0.913, 1.919 )
SWEP.OverrideAng = Vector( 0, 0, 0 )

--SWEP.IronSightsPos = Vector(1.12, -0.913, 1.919)
--SWEP.IronSightsAng = Vector(0, 0, 0)