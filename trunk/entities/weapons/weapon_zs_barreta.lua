-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then

	SWEP.IconLetter = "s"	
	SWEP.PrintName = "Barreta"
	killicon.AddFont( "weapon_zs_barreta", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ) )

	SWEP.IgnoreThumbs = true

	SWEP.ViewModelBoneMods = {
	["v_weapon.FIVESEVEN_PARENT"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

	SWEP.VElements = {
	["Elite"] = { type = "Model", model = "models/weapons/w_pist_elite_single.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(-0.053, 2.496, -1.752), angle = Angle(-91.276, 0, -90.195), size = Vector(0.777, 0.777, 0.777), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
	
end

SWEP.Base = "weapon_zs_base"



SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite_single.mdl"

	SWEP.Slot = 1
SWEP.Weight	= 1
SWEP.Type = "Pistol"
SWEP.HoldType = "pistol"

SWEP.Primary.Sound			= Sound( "Weapon_ELITE.Single" )
SWEP.Primary.Recoil			= 1.1
SWEP.Primary.Damage			= 16
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 15
SWEP.Primary.Delay			= 0.12
SWEP.MaxAmmo			    = 70
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"


SWEP.ConeMax = 0.08
SWEP.ConeMin = 0.03

SWEP.IronSightsPos = Vector(-5.5,15,2)
SWEP.IronSightsAng = Vector( 0, 0, 0 )