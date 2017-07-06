-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "TMP"			
	SWEP.IconLetter = "d"
	killicon.AddFont("weapon_zs_tmp", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.Base				= "weapon_zs_base"

SWEP.ViewModel			= Model("models/weapons/cstrike/c_smg_tmp.mdl")
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_smg_tmp.mdl" )

SWEP.HoldType = "smg"

SWEP.Primary.Sound			= Sound("Weapon_TMP.Single")
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Damage			= 16
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 25
SWEP.Primary.Delay 		= 0.06
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "alyxgun"

SWEP.Slot = 2
SWEP.Weight	= 3
SWEP.Type = "Incendiary"
SWEP.ConeMax = 0.08
SWEP.ConeMin = 0.035

SWEP.IronSightsPos = Vector(-3.5, 5, 2)
SWEP.IronSightsAng = Vector(0,0,0)

SWEP.OverridePos = Vector(1.559, -3.116, 1.6)
SWEP.OverrideAng = Vector(0, 0, 0)

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.TMP_Parent", rel = "", pos = Vector(0, -5.909, -10.079), angle = Angle(90, 90, 0), size = Vector(0.535, 0.535, 0.712), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/sniper/xms_sniperrifle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-2.53, 1.159, -2.718), angle = Angle(-13.704, 0, 0), size = Vector(0.961, 0.961, 0.961), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end


--SWEP.IronSightsPos = Vector(1.559, -3.116, 1.6)
--SWEP.IronSightsAng = Vector(0, 0, 0)