-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then AddCSLuaFile( "shared.lua" ) end

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

if CLIENT then
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.IgnoreBonemerge = true
SWEP.RotateFingers = Angle(12,-35,0)


SWEP.DummyModel = true
end

function SWEP:InitializeClientsideModels()
	
	if XMAS_2012 then
		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/sniper/xms_sniperrifle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.566, 1.733, 1.394), angle = Angle(-81.004, -2.358, -2.655), size = Vector(0.901, 0.901, 0.901), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		self.WElements = {
			["lights"] = { type = "Model", model = "models/player/items/sniper/xms_sniperrifle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.027, 1.738, 0), angle = Angle(-90.68, -8.054, 12.628), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
	else
		self.VElements = {
			["pot"] = { type = "Model", model = "models/weapons/w_pot.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.9, 2.012, 0.381), angle = Angle(-1.395, 180, -91.725), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
		self.WElements = {} 
	end

	self.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1.611, 1.611, 1.611), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(0.563, 0.563, 0.563), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-2.813, 0, -330), angle = Angle(0, 0, 0) }
	}
	
	
	
end

-- Model paths
SWEP.Author = "Deluvas"
SWEP.ViewModel = Model ( "models/weapons/v_pot/v_pot.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_pot.mdl" )

-- Name and fov
SWEP.PrintName = "Pot"
SWEP.ViewModelFOV = 52

-- Slot
SWEP.Slot = 2
SWEP.SlotPos = 7

-- Damage, distane, delay
SWEP.Primary.Damage = 55
SWEP.Primary.Delay = 0.5
SWEP.Primary.Distance = 70

SWEP.DamageType = DMG_CLUB

SWEP.MeleeDamage = 55
SWEP.MeleeRange = 45
SWEP.MeleeSize = 1.1

SWEP.UseMelee1 = true

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingTime = 0.35
SWEP.SwingHoldType = "grenade"

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/frying_pan/pan_hit-0"..math.random(1,4)..".wav")
end

-- Killicon
if CLIENT then killicon.AddFont( "weapon_zs_melee_pot", "HL2MPTypeDeath", "f", Color(255, 255, 255, 255 ) ) end
 