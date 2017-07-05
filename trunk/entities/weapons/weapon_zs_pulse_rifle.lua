-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Pulse Rifle"

	SWEP.IconLetter = "2"
	SWEP.SelectFont = "HL2MPTypeDeath"

	killicon.AddFont("weapon_zs_pulse_rifle", "HL2MPTypeDeath", SWEP.IconLetter, Color(100, 255, 255, 255 ))		
end

SWEP.Slot = 2
SWEP.Weight	= 4
SWEP.Type = "Pulse Tech"

SWEP.Base				= "weapon_zs_pulse_base"

SWEP.ConeMax = 0.1
SWEP.ConeMin = 0.0385

SWEP.Pulse_Static_RechargeRate = 0.15
SWEP.Pulse_Static_ClipSize = 30

SWEP.ViewModel = Model("models/weapons/c_irifle.mdl")
SWEP.WorldModel = "models/weapons/w_irifle.mdl" 

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_AR2.Single")
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 16
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 0.11
SWEP.Primary.Automatic		= true

SWEP.IronSightsPos = Vector(-2, -4, 1.5)
SWEP.IronSightsAng = Vector(0, 0, 0)


