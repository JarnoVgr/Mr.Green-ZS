-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "P90"			
	SWEP.Author	= "Ywa"
	SWEP.Slot = 0
	SWEP.ViewModelFOV = 65
	SWEP.SlotPos = 13
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

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_smg_p90.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_smg_p90.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "smg"

SWEP.Primary.Sound			= Sound("Weapon_P90.Single")
SWEP.Primary.Recoil			= 1
SWEP.Primary.Unrecoil		= 0
SWEP.Primary.Damage			= 12
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 50
SWEP.Primary.Delay 			= 0.07
SWEP.Primary.DefaultClip	= 150
SWEP.MaxAmmo			    = 250
SWEP.Primary.Automatic		= true
--SWEP.Primary.Ammo			= "smg1"
SWEP.Primary.Ammo			= "buckshot"
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.Cone = 0.06
SWEP.ConeMoving = SWEP.Cone *1.2
SWEP.ConeCrouching = SWEP.Cone *0.85
SWEP.ConeIron = SWEP.Cone *0.85
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.80
--SWEP.ConeIronMoving = SWEP.Moving *0.85

SWEP.WalkSpeed = 197
SWEP.MaxBulletDistance 		= 1800

SWEP.IronSightsPos = Vector(-5.85, 6, 1.5)
SWEP.IronSightsAng = Vector(0,0,0)

SWEP.OverridePos = Vector(2.299, -2.46, 1.967)
SWEP.OverrideAng = Vector(0, 0, 0)