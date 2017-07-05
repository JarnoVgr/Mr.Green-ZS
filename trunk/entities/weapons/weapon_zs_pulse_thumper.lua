-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
AddCSLuaFile()
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false


if CLIENT then
	SWEP.PrintName = "Pulse 'Thumper'"
	SWEP.IconLetter = "2"
	SWEP.SelectFont = "HL2MPTypeDeath"

	killicon.AddFont("weapon_zs_pulse_thumper", "HL2MPTypeDeath", SWEP.IconLetter, Color(100, 255, 255, 255 ))
end

SWEP.Slot = 2
SWEP.Weight	= 4
SWEP.Type = "Pulse Tech"
SWEP.Pulse_Static_RechargeRate = 0.3
SWEP.Pulse_Static_ClipSize = 8


SWEP.Base				= "weapon_zs_pulse_base"

SWEP.ConeMax = 0.16
SWEP.ConeMin = 0.10



SWEP.ViewModel = Model("models/weapons/c_irifle.mdl")
SWEP.WorldModel = "models/weapons/w_irifle.mdl" 

SWEP.HoldType = "ar2"
SWEP.Primary.Sound = Sound("Airboat.FireGunHeavy")
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 12
SWEP.Primary.NumShots		= 4
SWEP.Primary.Delay			= 0.4
SWEP.Primary.Automatic		= true

SWEP.IronSightsPos = Vector(-2, -4, 1.5)
SWEP.IronSightsAng = Vector(0, 0, 0)