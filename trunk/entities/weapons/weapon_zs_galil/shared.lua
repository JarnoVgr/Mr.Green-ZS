-- � Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Galil"			
	SWEP.Author	= "Ywa"
	SWEP.Slot = 0
	SWEP.SlotPos = 6
	SWEP.ViewModelFlip = true
	SWEP.FlipYaw = true
	SWEP.IconLetter = "v"
	killicon.AddFont("weapon_zs_galil", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
	SWEP.ViewModelFOV = 50
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.galil", rel = "", pos = Vector(0.317, -2.356, -7.257), angle = Angle(87.903, 90, 0), size = Vector(0.5, 0.5, 1.238), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(26.448, 0, -5.019), angle = Angle(84.732, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end

SWEP.Base				= "weapon_zs_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_rif_galil.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_rif_galil.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_Galil.Single")
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 30
SWEP.storeclipsize			= 30
SWEP.MaxAmmo			    = 250
SWEP.Primary.Delay			= 0.12
SWEP.Primary.DefaultClip	= 185
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"

SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.WalkSpeed = 195
SWEP.MaxBulletDistance 		= 2750 

SWEP.ConeMoving = 0.069
SWEP.Cone = 0.055
SWEP.ConeCrouching = 0.049
SWEP.ConeIron = 0.039
SWEP.ConeIronCrouching = 0.032

SWEP.IronSightsPos = Vector( -6.386, 3, 2.47 )
SWEP.IronSightsAng = Vector( 0, 0, 0 )

SWEP.OverridePos = Vector( -2, -3.541, 1.519 )
SWEP.OverrideAng = Vector( 0,0,0 )

--SWEP.IronSightsPos = Vector(-2, -3.541, 1.519)
--SWEP.IronSightsAng = Vector(0, 0, 0)