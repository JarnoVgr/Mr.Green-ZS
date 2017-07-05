-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "MP5"			
	SWEP.ViewModelFlip = false
	SWEP.IconLetter = "x"
	killicon.AddFont("weapon_zs_mp5", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0.082, -1.872, 2.549), angle = Angle(-90, 90, 0), size = Vector(0.5, 0.5, 0.836), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-4.881, 0.867, -6.048), angle = Angle(-79.633, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end

SWEP.Base				= "weapon_zs_base"

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_smg_mp5.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_smg_mp5.mdl" )

SWEP.HoldType = "smg"

SWEP.Slot = 2
SWEP.Weight	= 3
SWEP.Type = "SMG"

SWEP.ConeMax = 0.08
SWEP.ConeMin = 0.03

SWEP.Primary.Sound			= Sound("Weapon_MP5Navy.Single")
SWEP.Primary.Recoil			= 0.7
SWEP.Primary.Damage			= 16
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 24
SWEP.Primary.Delay			= 0.098
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"	

SWEP.IronSightsPos = Vector( -5.361, -1.5, 1.6 )
SWEP.IronSightsAng = Vector( 1.9, 0, 0 )


