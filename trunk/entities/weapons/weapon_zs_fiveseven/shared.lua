-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Five-Seven"			
	SWEP.Author	= "Ywa"
	SWEP.Slot = 1
	SWEP.ViewModelFOV = 50
	SWEP.SlotPos = 4
	SWEP.IconLetter = "u"
	killicon.AddFont("weapon_zs_fiveseven", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
	
	SWEP.IgnoreThumbs = true	
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(-0.018, 0.238, 1.363), angle = Angle(-90, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.51, 1.358, -6.229), angle = Angle(0, -3.432, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_pist_fiveseven.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_pist_fiveseven.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "pistol"

SWEP.Primary.Sound			= Sound( "Weapon_FiveSeven.Single" )
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 12
SWEP.Primary.Delay			= 0.23
SWEP.Primary.DefaultClip	= 60
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.MaxBulletDistance 		= 1900
SWEP.MaxAmmo			    = 60
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.Cone = 0.034
SWEP.ConeMoving = SWEP.Cone *1.3
SWEP.ConeCrouching = SWEP.Cone *0.75
SWEP.ConeIron = SWEP.Cone *0.8
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.80
SWEP.ConeIronMoving = SWEP.ConeMoving *0.80
SWEP.WalkSpeed = 200

SWEP.IronSightsPos = Vector(-5.969, 22, 2.79)
SWEP.IronSightsAng = Vector(0, 0, 0)

--SWEP.IronSightsPos = Vector(1.12, -0.913, 1.919)
--SWEP.IronSightsAng = Vector(0, 0, 0)