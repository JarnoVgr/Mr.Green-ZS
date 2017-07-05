-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "P90"			
	SWEP.IconLetter = "m"
	killicon.AddFont("weapon_zs_p90", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.p90_Parent", rel = "", pos = Vector(-0.083, -0.32, 5.164), angle = Angle(-76.706, 90, 0), size = Vector(0.694, 0.527, 0.589), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-8.839, 1.111, -2.053), angle = Angle(-93.301, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end

SWEP.Base				= "weapon_zs_base"

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_smg_p90.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_smg_p90.mdl" )

SWEP.HoldType = "smg"
SWEP.HumanClass = "support"
SWEP.Primary.Sound			= Sound("Weapon_P90.Single")
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= 18
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 50
SWEP.Primary.Delay 			= 0.076
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Slot = 2
SWEP.Weight	= 5
SWEP.Type = "SMG"
SWEP.ConeMax = 0.8
SWEP.ConeMin = 0.04


SWEP.IronSightsPos = Vector(-5.85, 6, 1.5)
SWEP.IronSightsAng = Vector(0,0,0)

SWEP.OverridePos = Vector(2.299, -2.46, 1.967)
SWEP.OverrideAng = Vector(0, 0, 0)