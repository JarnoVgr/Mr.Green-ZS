-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Desert Eagle"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.ViewModelFOV = 50
	killicon.AddFont( "weapon_zs_deagle", "CSKillIcons", "f", Color(255, 255, 255, 255 ) )

	SWEP.IgnoreThumbs = true

end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.Deagle_Parent", rel = "", pos = Vector(0, -0.562, 2.2), angle = Angle(-90, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.365, 0.629, -1.385), angle = Angle(0, 0, 180), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_pist_deagle.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_pist_deagle.mdl" )

SWEP.Weight				= 5

SWEP.HoldType = "pistol"

SWEP.Primary.Sound			= Sound( "Weapon_Deagle.Single" )
SWEP.Primary.Recoil			= 4
SWEP.Primary.Damage			= 41
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 7
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip	= 45
SWEP.MaxAmmo			    = 70
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.WalkSpeed = 200

SWEP.ConeMoving = 0.062
SWEP.Cone = 0.044
SWEP.ConeIron = 0.036
SWEP.ConeCrouching = 0.034
SWEP.ConeIronCrouching = 0.026

--SWEP.IronSightsPos = Vector( -6.391, 20, 1.8 )
--SWEP.IronSightsAng = Vector( 0.456, 0, 0 )

SWEP.IronSightsPos = Vector(-3.2,0,1)
SWEP.IronSightsAng = Vector( 0, 0, 0 )

SWEP.OverridePos = Vector( 1.48, -1.282, 1.679 )
SWEP.OverrideAng = Vector( 0, 0, 0 )
--SWEP.IronSightsPos = Vector(1.48, -1.282, 1.679)
--SWEP.IronSightsAng = Vector(0, 0, 0)

