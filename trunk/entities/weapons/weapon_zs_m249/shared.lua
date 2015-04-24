-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "M249"			
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 0
	SWEP.SlotPos = 9
	SWEP.ViewModelFOV = 60
	SWEP.IconLetter = "z"
	SWEP.FlipYaw = true
	killicon.AddFont("weapon_zs_m249", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model("models/weapons/cstrike/c_mach_m249para.mdl")
SWEP.UseHands = true
SWEP.WorldModel			= Model("models/weapons/w_mach_m249para.mdl")

SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "smg"

SWEP.Primary.Sound			= Sound("Weapon_M249.Single")
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 100
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 400
SWEP.MaxAmmo			    = 500
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.FirePower = (SWEP.Primary.Damage * SWEP.Primary.ClipSize)

SWEP.Cone = 0.049
SWEP.ConeMoving = SWEP.Cone * 1.1
SWEP.ConeCrouching = SWEP.Cone * 0.9
SWEP.ConeIron = SWEP.Cone *0.9
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.9
--SWEP.ConeIronMoving = SWEP.Moving *0.9


SWEP.WalkSpeed = SPEED_HEAVY
SWEP.MaxBulletDistance = 2450

SWEP.IronSightsPos = Vector(-5.9, 19, 2)
SWEP.IronSightsAng = Vector(0, 0, 0)


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