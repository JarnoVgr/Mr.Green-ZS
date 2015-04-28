AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Mac 10 SMG"
	SWEP.Author = "NECROSSIN"
	SWEP.Slot = 0
	SWEP.SlotPos = 12
	SWEP.ViewModelFOV = 60
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

SWEP.Weight = 5

SWEP.HoldType = "pistol"

SWEP.Primary.Sound = Sound("Weapon_MAC10.Single")
SWEP.Primary.Recoil = 1
SWEP.Primary.Damage = 12
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.075

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 90
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"

SWEP.MaxAmmo = 230

SWEP.Cone = 0.073
SWEP.ConeMoving = SWEP.Cone *1.1
SWEP.ConeCrouching = SWEP.Cone *0.9
SWEP.ConeIron = SWEP.Cone *0.85
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.9
--SWEP.ConeIronMoving = SWEP.Moving *0.85

SWEP.WalkSpeed = SPEED_SMG

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