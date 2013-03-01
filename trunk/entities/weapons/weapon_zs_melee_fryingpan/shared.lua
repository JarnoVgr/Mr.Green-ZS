-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then AddCSLuaFile( "shared.lua" ) end

//Melee base
SWEP.Base = "weapon_zs_melee_base"

if CLIENT then
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.IgnoreBonemerge = true
SWEP.RotateFingers = Angle(12,-35,0)

SWEP.DummyModel = true
end

function SWEP:InitializeClientsideModels()
	
	self.VElements = {
		["pan"] = { type = "Model", model = "models/weapons/w_fryingpan.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.15, 2.368, 0.3), angle = Angle(-15.756, 180, -86.94), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	self.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1.611, 1.611, 1.611), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(0.563, 0.563, 0.563), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-2.813, 0, -330), angle = Angle(0, 0, 0) }
	}
	
	self.WElements = {} 
	
end

//Model paths
SWEP.Author = "Deluvas"
SWEP.ViewModel = Model ( "models/weapons/v_fryingpan/v_fryingpan.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_fryingpan.mdl" )

//Name
SWEP.PrintName = "Frying Pan"
SWEP.ViewModelFOV = 52

//Position
SWEP.Slot = 2
SWEP.SlotPos = 4

//Damage, distane, delay
SWEP.Primary.Damage = 45
SWEP.Primary.Delay = 0.65
SWEP.Primary.Distance = 70

SWEP.DamageType = DMG_CLUB

SWEP.MeleeDamage = 30
SWEP.MeleeRange = 48
SWEP.MeleeSize = 1.15

SWEP.UseMelee1 = true

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingTime = 0.38
SWEP.SwingHoldType = "grenade"

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/frying_pan/pan_hit-0"..math.random(1,4)..".wav")
end

//Killicon
if CLIENT then killicon.AddFont( "weapon_zs_melee_fryingpan", "ZSKillicons", "b", Color(255, 255, 255, 255 ) ) end 
