-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

--SWEP.PrintName = "Sub-Machine Gun"
SWEP.PrintName = "Classic SMG"

if CLIENT then		
	SWEP.Author	= "Deluvas"
	SWEP.Slot = 0
	SWEP.SlotPos = 18
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.ShowViewModel = true
	SWEP.IgnoreBonemerge = false
	SWEP.UseHL2Bonemerge = true
	SWEP.ScaleDownLeftHand = true
	
	SWEP.VElements = {
	 	["smg1"] = { type = "Model", model = "models/Weapons/w_smg1.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(-0.826, 0.95, 3.444), angle = Angle(88.787, 143.143, 126.155), size = Vector(0.837, 0.842, 0.856), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.IconLetter = "/"

	killicon.AddFont( "weapon_zs_smg", "HL2MPTypeDeath", SWEP.IconLetter, Color(255, 255, 255, 255 ) )
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

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/c_smg1.mdl" )
--SWEP.ViewModel			= Model ( "models/Weapons/v_smg1.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_smg1.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_AR2.NPC_Single")
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= 9
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 25
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 125
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.MaxBulletDistance 		= 2500
SWEP.MaxAmmo			    = 250
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )


SWEP.ConeMoving = 0.076
SWEP.Cone = 0.068
SWEP.ConeCrouching = 0.063


SWEP.WalkSpeed = 200

SWEP.IronSightsPos = Vector(-6.441, -6.049, 1.059)
SWEP.IronSightsAng = Vector(0, 0, 0)


