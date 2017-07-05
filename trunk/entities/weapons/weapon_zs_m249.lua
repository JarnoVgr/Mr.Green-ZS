-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "M249"			
	SWEP.IconLetter = "z"
	SWEP.FlipYaw = true
	killicon.AddFont("weapon_zs_m249", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.Base				= "weapon_zs_base"

SWEP.ViewModel			= Model("models/weapons/cstrike/c_mach_m249para.mdl")
SWEP.UseHands = true
SWEP.WorldModel			= Model("models/weapons/w_mach_m249para.mdl")

SWEP.HoldType = "smg"

SWEP.Primary.Sound			= Sound("Weapon_M249.Single")
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Damage			= 24
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 100
SWEP.Primary.Delay			= 0.075
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"

SWEP.Type = "Assault Rifle"
SWEP.Slot = 3
SWEP.Weight = 8
SWEP.ConeMax = 0.15
SWEP.ConeMin = 0.06

SWEP.OverridePos = Vector(-1.601, -1.311, 1.6)
SWEP.OverrideAng = Vector( 0,0,0 )

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/sniper/xms_sniperrifle.mdl", bone = "v_weapon.bullet1", rel = "", pos = Vector(-2.651, 13.626, -4.856), angle = Angle(0, 90, 0), size = Vector(1.113, 1.113, 1.113), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.045, 0.957, -9.516), angle = Angle(-10.737, 0, 0), size = Vector(0.958, 0.958, 1.164), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

--SWEP.IronSightsPos = Vector(-1.601, -1.311, 1.6)
--SWEP.IronSightsAng = Vector(0, 0, 0)