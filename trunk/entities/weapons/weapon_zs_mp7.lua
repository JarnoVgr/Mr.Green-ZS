-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.PrintName = "MP7"

if CLIENT then		
	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = true
	SWEP.IgnoreBonemerge = false
	SWEP.UseHL2Bonemerge = true
	SWEP.ScaleDownLeftHand = true
	killicon.AddFont( "weapon_zs_mp7", "HL2MPTypeDeath", "/", Color(255, 255, 255, 255 ) )
end

if CHRISTMAS then
	--VElements is broken due to V-to-C-model change
	SWEP.VElements = {
		["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(-0.189, -1.303, 14.432), angle = Angle(3.562, -89.909, 180), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(21.04, 1.501, -9.778), angle = Angle(76.043, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end
SWEP.HumanClass = "support"
SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/c_smg1.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_smg1.mdl" )

SWEP.UseHands 			= true
SWEP.HoldType = 			"ar2"
SWEP.Primary.Sound			= Sound("Weapon_AR2.NPC_Single")
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Damage			= 18
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 40
SWEP.Primary.Delay			= 0.096
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Slot = 2
SWEP.Weight				= 3
SWEP.Type = "SMG"
SWEP.ConeMax = 0.05
SWEP.ConeMin = 0.035

SWEP.IronSightsPos = Vector(-6.441, -6.049, 1.059)
SWEP.IronSightsAng = Vector(0, 0, 0)


