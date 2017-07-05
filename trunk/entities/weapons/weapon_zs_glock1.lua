-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.IconLetter = "c"
	killicon.AddFont( "weapon_zs_glock1", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ) )
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.Glock_Parent", rel = "", pos = Vector(4.848, 2.098, -0.426), angle = Angle(176.225, -20.577, -103.295), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.482, 0.46, -0.691), angle = Angle(0, 0, 180), size = Vector(0.474, 0.474, 0.474), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_base"
SWEP.PrintName = "Glock 1"
SWEP.Type = "Incendiary"
SWEP.Slot = 1
SWEP.Weight = 1
SWEP.ConeMax = 0.06
SWEP.ConeMin = 0.04

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_pist_glock18.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_pist_glock18.mdl" )

SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HumanClass = "pyro"

SWEP.HoldType = "pistol"

SWEP.Primary.Sound			= Sound( "Weapon_Glock.Single" )
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Damage			= 12
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 18
SWEP.Primary.Delay			= 0.1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "alyxgun"




SWEP.IronSightsPos = Vector(-5.8,16,2)
SWEP.IronSightsAng = Vector( 0, 0, 0 )

SWEP.TracerName = "AirboatGunTracer"