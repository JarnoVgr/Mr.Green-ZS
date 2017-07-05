AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Mac 10 SMG"
	
	SWEP.ViewModelFlip = false
	
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	SWEP.ViewModelBonescales = {}
	
	SWEP.IconLetter = "l"
	killicon.AddFont("weapon_zs_mac10", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/cstrike/c_smg_mac10.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_smg_mac10.mdl"

SWEP.HoldType = "smg"
SWEP.Primary.Sound = Sound("Weapon_MAC10.Single")
SWEP.Primary.Recoil = 1.5
SWEP.Primary.Damage = 16
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.071

SWEP.Primary.ClipSize = 24
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"

SWEP.Slot = 2
SWEP.Weight	= 2
SWEP.Type = "SMG"
SWEP.ConeMax = 0.1
SWEP.ConeMin = 0.04

SWEP.IronSightsPos = Vector(-2, 10, 1.5)
SWEP.IronSightsAng = Vector(0,0,0)
SWEP.OverridePos = Vector(2.279, -3.28, 1.44)
SWEP.OverrideAng = Vector(0, 0, 6.287)

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.mac10_parent", rel = "", pos = Vector(-0.48, -0.559, 10.204), angle = Angle(-90, 90, 0), size = Vector(0.554, 0.554, 0.694), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-4.9, 0.81, -6.652), angle = Angle(0, -2.901, 0), size = Vector(0.666, 0.666, 0.666), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end