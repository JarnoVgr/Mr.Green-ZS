-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	killicon.AddFont("weapon_zs_p228", "CSKillIcons", "a", Color(255, 255, 255, 255 ))
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.p228_Parent", rel = "", pos = Vector(0, -0.879, 5.744), angle = Angle(-90, 90, 0), size = Vector(0.493, 0.493, 0.493), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.209, 0.662, -1.331), angle = Angle(0, 0, -180), size = Vector(0.414, 0.414, 0.414), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end

SWEP.Base				= "weapon_zs_base"

SWEP.PrintName = "P228"
SWEP.Type = "Pistol"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.UseHands = true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_pist_p228.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_pist_p228.mdl" )

SWEP.Slot = 1
SWEP.Weight = 1

SWEP.HoldType = "pistol"

SWEP.Primary.Sound			= Sound("Weapon_P228.Single")
SWEP.Primary.Recoil			= 1.1
SWEP.Primary.Damage 		= 16
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 12
SWEP.Primary.Delay			= 0.1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.ConeMax = 0.08
SWEP.ConeMin = 0.02

SWEP.IronSightsPos = Vector(-5.95, 7, 2 )
SWEP.IronSightsAng = Vector( 0, 0, 0 )