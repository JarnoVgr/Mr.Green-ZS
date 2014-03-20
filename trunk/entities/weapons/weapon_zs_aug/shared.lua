-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then		
	SWEP.Author	= "Ywa"
	SWEP.Slot = 0
	SWEP.SlotPos = 2
	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = true
	SWEP.IconLetter = "e"
	killicon.AddFont("weapon_zs_aug", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
	SWEP.ViewModelFOV = 50
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.aug_Parent", rel = "", pos = Vector(0.731, -0.322, 21.634), angle = Angle(-86.223, 90, 0), size = Vector(0.5, 0.5, 1.34), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(17.575, 1.294, -3.518), angle = Angle(91.344, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_rif_aug.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_rif_aug.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.PrintName			= "AUG"

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_AUG.Single")
SWEP.Primary.Recoil			= 2
SWEP.Primary.Damage			= 16
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.095
SWEP.Primary.DefaultClip	= 60
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.Cone			= 0.05
SWEP.MaxBulletDistance 		= 3500
SWEP.MaxAmmo			    = 250

SWEP.Cone = 0.060
SWEP.ConeMoving = SWEP.Cone *1.4
SWEP.ConeCrouching = SWEP.Cone *0.80
SWEP.ConeIron = SWEP.Cone *0.7
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.7
SWEP.ConeIronMoving = SWEP.ConeMoving *0.85

SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.WalkSpeed = 195

SWEP.IronSightsPos = Vector(5.99,-4,34.985)
SWEP.IronSightsAng = Vector(2.4,1.9,45)

SWEP.IronSightsPos = Vector(-4.6, -6.029, 0.839)
SWEP.IronSightsAng = Vector(0, 0, 0)