-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then AddCSLuaFile( "shared.lua" ) end

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

if CLIENT then
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.IgnoreBonemerge = true
-- SWEP.RotateFingers = Angle(12,-35,0)

SWEP.DummyModel = true
end

function SWEP:InitializeClientsideModels()
	
	self.VElements = {
		["keyboard"] = { type = "Model", model = "models/weapons/w_keyboard.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.763, 3.513, 4.163), angle = Angle(18.881, -24.063, -170.181), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	self.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1.611, 1.611, 1.611), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(0.563, 0.563, 0.563), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-2.813, 0, -330), angle = Angle(0, 0, 0) }
	}
	
	self.WElements = {} 
	
end

-- Model paths
SWEP.Author = "Deluvas"
SWEP.ViewModel = Model ( "models/weapons/v_keyboard/c_keyboard.mdl" )
SWEP.UseHands = true
SWEP.WorldModel = Model ( "models/weapons/w_keyboard.mdl" )

-- Name and fov
SWEP.PrintName = "Keyboard"
SWEP.ViewModelFOV = 70

-- Slot position
SWEP.Slot = 2
SWEP.SlotPos = 5

-- Damage, distane, delay

SWEP.MeleeDamage = 35
SWEP.MeleeRange = 50
SWEP.MeleeSize = 1.0


SWEP.DamageType = DMG_CLUB

SWEP.MeleeDamage = 35
SWEP.MeleeRange = 45
SWEP.MeleeSize = 1.25
SWEP.WalkSpeed = 195

SWEP.SwingTime = 0.3
SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingOffset = Vector(0, -30, 0)
SWEP.SwingHoldType = "melee"

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/keyboard/keyboard_hit-0"..math.random(1, 4)..".wav")
end

-- Killicon
if CLIENT then killicon.AddFont( "weapon_zs_melee_keyboard", "ZSKillicons", "d", Color(255, 255, 255, 255 ) ) end
 

