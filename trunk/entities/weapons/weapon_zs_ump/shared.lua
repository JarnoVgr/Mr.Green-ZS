-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "UMP"			
	SWEP.Author	= "JetBoom"
	SWEP.Slot = 0
	SWEP.SlotPos = 20
	SWEP.ViewModelFOV = 65
	SWEP.IconLetter = "q"
	killicon.AddFont("weapon_zs_ump", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_smg_ump45.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_smg_ump45.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "smg"

SWEP.Primary.Sound			= Sound("Weapon_UMP45.Single")
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 16
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 28
SWEP.Primary.Delay			= 0.089
SWEP.Primary.DefaultClip	= 84
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )


SWEP.ConeMoving = 0.067
SWEP.Cone = 0.049
SWEP.ConeIron = 0.034
SWEP.ConeCrouching = 0.038
SWEP.ConeIronCrouching = 0.023

SWEP.MaxAmmo			    = 250

SWEP.WalkSpeed = 195
SWEP.MaxBulletDistance 		= 2240

SWEP.IronSightsPos = Vector(-5.3, -11, 4.4)
SWEP.IronSightsAng = Vector(-1, 0.2, 2.55)



--SWEP.IronSightsPos = Vector(3.599, -4.591, 1.6)
--SWEP.IronSightsAng = Vector(0, 0, 1.888)