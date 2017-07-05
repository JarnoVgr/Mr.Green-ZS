-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Glock 3"
	SWEP.Slot = 1
	SWEP.IconLetter = "c"
	killicon.AddFont( "weapon_zs_glock3", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ) )
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.Glock_Parent", rel = "", pos = Vector(4.848, 2.098, -0.426), angle = Angle(176.225, -20.577, -103.295), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.482, 0.46, -0.691), angle = Angle(0, 0, 180), size = Vector(0.474, 0.474, 0.474), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end

SWEP.Type = "Incendiary"

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_pist_glock18.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_pist_glock18.mdl" )


SWEP.HoldType = "pistol"

SWEP.Primary.Sound			= Sound( "Weapon_Glock.Single" )
SWEP.Primary.Recoil			= 2
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 3
SWEP.Primary.ClipSize		= 7
SWEP.Primary.Delay			= 0.25
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "alyxgun"

SWEP.ConeMax = 0.07
SWEP.ConeMin = 0.06

SWEP.Weight = 1

SWEP.IronSightsPos = Vector(-5.8,16,2)
SWEP.IronSightsAng = Vector( 0, 0, 0 )

SWEP.TracerName = "AirboatGunTracer"