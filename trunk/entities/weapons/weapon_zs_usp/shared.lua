-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "USP"
	SWEP.Author	= "Ywa"
	SWEP.Slot = 1
	SWEP.SlotPos = 2
	SWEP.ViewModelFOV = 60
	killicon.AddFont( "weapon_zs_usp", "CSKillIcons", "a", Color(255, 255, 255, 255 ) )
	
	SWEP.IgnoreThumbs = true
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.USP_Parent", rel = "", pos = Vector(0, -0.357, 4.409), angle = Angle(-90, 90, 0), size = Vector(0.467, 0.467, 0.467), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.082, 0.662, -1.106), angle = Angle(0, 0, -180), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.WalkSpeed = SPEED_PISTOL

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_pist_usp.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_pist_usp.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "pistol"

SWEP.Primary.Sound			= Sound( "Weapon_USP.Single" )
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Damage			= 17
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 12
SWEP.Primary.Delay			= 0.12
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.FlipYaw = true

SWEP.Cone = 0.044
SWEP.ConeMoving = SWEP.Cone *1.8
SWEP.ConeCrouching = SWEP.Cone *0.75
SWEP.ConeIron = SWEP.Cone *0.8
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.80
--SWEP.ConeIronMoving = SWEP.Moving *0.80

SWEP.MaxAmmo			    = 130

SWEP.IronSightsPos = Vector(-5.95, 2, 2 )

SWEP.IronSightsAng = Vector( 0, 0, 0 )