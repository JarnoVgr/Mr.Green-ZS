-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Famas"
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 0
	SWEP.SlotPos = 5
	SWEP.ViewModelFlip = true
	SWEP.FlipYaw = true
	SWEP.IconLetter = "t"
	killicon.AddFont("weapon_zs_famas", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0, 2.229, 28.027), angle = Angle(-76.706, 90, 0), size = Vector(0.5, 0.5, 0.87), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-4.312, -0.08, -2.339), angle = Angle(-90.025, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end

SWEP.Base				= "weapon_zs_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_rif_famas.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_rif_famas.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_FAMAS.Single")
SWEP.Primary.Recoil			= 2						
SWEP.Primary.Unrecoil		= 0
SWEP.Primary.Damage			= 18
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 31
SWEP.storeclipsize			= 31
SWEP.MaxAmmo			    = 250
SWEP.Primary.Delay			= 0.145
SWEP.Primary.DefaultClip	= 165
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.Cone			= 0.04
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.ConeMoving = 0.066
SWEP.Cone = 0.054
SWEP.ConeIron = 0.046
SWEP.ConeCrouching = 0.039
SWEP.ConeIronCrouching = 0.031

SWEP.WalkSpeed = 195
SWEP.MaxBulletDistance 		= 2300

--SWEP.IronSightsPos = Vector(-4,-3,1)
--SWEP.IronSightsAng = Vector(3,.5,4)

SWEP.IronSightsPos = Vector(-2.641, -4.481, 1 )
SWEP.IronSightsAng = Vector( 0, 0, 0 )

SWEP.OverridePos = Vector(-1.56, -1.968, 1.44)
SWEP.OverrideAng = Vector( 0,0,0 )

--SWEP.IronSightsPos = Vector(-1.56, -1.968, 1.44)
--SWEP.IronSightsAng = Vector(0, 0, 0)

