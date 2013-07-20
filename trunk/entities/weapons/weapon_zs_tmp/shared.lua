-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "TMP"			
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

SWEP.ViewModel			= Model ( "models/weapons/v_smg_tmp.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_smg_tmp.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "smg"

SWEP.Primary.Sound			= Sound("Weapon_TMP.Single")
SWEP.Primary.Recoil			= 2
SWEP.Primary.UnRecoil		= 5
SWEP.Primary.Damage			= 18
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.06
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.07
SWEP.Primary.DefaultClip	= 60
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.Primary.Cone			= 0.06
SWEP.ConeMoving				= 0.08
SWEP.ConeCrouching			= 0.045
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.MaxAmmo			    = 250

SWEP.Cone = 0.09
SWEP.ConeMoving = 0.08
SWEP.ConeCrouching = 0.02
SWEP.ConeIron = 0.06
SWEP.ConeIronCrouching = 0.05

SWEP.WalkSpeed = 185
SWEP.MaxBulletDistance 		= 2250

SWEP.IronSightsPos = Vector(5.23,-2,2.55)
SWEP.IronSightsAng = Vector(.6,-.05,0)

SWEP.OverridePos = Vector(1.559, -3.116, 1.6)
SWEP.OverrideAng = Vector(0, 0, 0)


--SWEP.IronSightsPos = Vector(1.559, -3.116, 1.6)
--SWEP.IronSightsAng = Vector(0, 0, 0)