-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "P228"
	SWEP.Author	= "JetBoom"
	SWEP.Slot = 1
	SWEP.ViewModelFOV = 68
	SWEP.SlotPos = 1
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

SWEP.WalkSpeed = 190

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_pist_p228.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_pist_p228.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "pistol"

SWEP.Primary.Sound			= Sound("Weapon_P228.Single")
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 18
SWEP.Primary.Delay			= 0.15
SWEP.Primary.DefaultClip	= 90
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.Cone = 0.031
SWEP.ConeMoving = SWEP.Cone *1.3
SWEP.ConeCrouching = SWEP.Cone *0.75
SWEP.ConeIron = SWEP.Cone *0.8
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.80
--SWEP.ConeIronMoving = SWEP.Moving *0.80

SWEP.MaxAmmo			    = 130

SWEP.IronSightsPos = Vector(-3, 2, 1 )

SWEP.IronSightsAng = Vector( 0, 0, 0 )