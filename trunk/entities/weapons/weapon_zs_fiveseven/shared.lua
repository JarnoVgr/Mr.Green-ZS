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

SWEP.ViewModel			= Model ( "models/weapons/v_pist_fiveseven.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_pist_fiveseven.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "pistol"

SWEP.Primary.Sound			= Sound( "Weapon_FiveSeven.Single" )
SWEP.Primary.Recoil			= 1.2 * 4
SWEP.Primary.Unrecoil		= 3.8
SWEP.Primary.Damage			= 17
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 12
SWEP.Primary.Delay			= 0.12
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Cone			= 0.04
SWEP.MaxBulletDistance 		= 1900
SWEP.MaxAmmo			    = 60
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.Cone = 0.05
SWEP.ConeMoving = 0.06
SWEP.ConeCrouching = 0.03
SWEP.ConeIron = 0.04
SWEP.ConeIronCrouching = 0.03

SWEP.WalkSpeed = 195

SWEP.IronSightsPos = Vector (4.5553, -1.7583, 3.1858)
SWEP.IronSightsAng = Vector (0.2386, 0.0272, 0.1524)

SWEP.OverridePos = Vector(1.12, -0.913, 1.919)
SWEP.OverrideAng = Vector( 0,0,0 )

--SWEP.IronSightsPos = Vector(1.12, -0.913, 1.919)
--SWEP.IronSightsAng = Vector(0, 0, 0)