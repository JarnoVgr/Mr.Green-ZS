-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Famas"
	SWEP.Slot = 2

	SWEP.ViewModelFlip = false
	SWEP.FlipYaw = true
	SWEP.IconLetter = "t"
	killicon.AddFont("weapon_zs_famas", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0, 2.229, 28.027), angle = Angle(-76.706, 90, 0), size = Vector(0.5, 0.5, 0.87), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-4.312, -0.08, -2.339), angle = Angle(-90.025, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end

SWEP.Base				= "weapon_zs_base"

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_rif_famas.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_rif_famas.mdl" )

SWEP.Slot = 2
SWEP.Weight = 3
SWEP.Type = "Assault Rifle"

SWEP.ConeMax = 0.09
SWEP.ConeMin = 0.04


SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_FAMAS.Single")
SWEP.Primary.Recoil			= 1			
SWEP.Primary.Damage			= 17
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.11
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"


SWEP.IronSightsPos = Vector(-2, 10, 1.5)
SWEP.IronSightsAng = Vector(0,0,0)