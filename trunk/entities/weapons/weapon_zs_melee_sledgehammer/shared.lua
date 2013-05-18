-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then AddCSLuaFile ( "shared.lua" ) end

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
			["sledge"] = { type = "Model", model = "models/weapons/w_sledgehammer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.137, 0.675, 15.994), angle = Angle(8.475, -9.606, -180), size = Vector(1.149, 1.149, 1.149), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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
SWEP.Author = "NECROSSIN"
SWEP.ViewModel = "models/weapons/v_sledgehammer/v_sledgehammer.mdl"
SWEP.WorldModel = "models/weapons/w_sledgehammer.mdl" 

-- Name and fov
SWEP.PrintName = "Mr Sledge"
SWEP.ViewModelFOV = 60

-- Slot pos
SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.HoldType = "melee2"
-- Damage, distane, delay
SWEP.Primary.Damage = 150
SWEP.Primary.Delay = 1.35
SWEP.Primary.Distance = 70
SWEP.TotalDamage = SWEP.Primary.Damage

SWEP.MeleeDamage = 150
SWEP.MeleeRange = 70
SWEP.MeleeSize = 1.75
SWEP.MeleeKnockBack = SWEP.MeleeDamage * 2.25

SWEP.Primary.Delay = 1.3

SWEP.WalkSpeed = 185

SWEP.SwingRotation = Angle(60, 0, -80)
SWEP.SwingOffset = Vector(0, -30, 0)
SWEP.SwingTime = 0.75
SWEP.SwingHoldType = "melee"

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(35, 45))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(1, 3)..".wav", 75, math.random(86, 90))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.random(86, 90))
end

-- Killicon
if CLIENT then 
--killicon.AddFont( "weapon_zs_melee_axe", "HL2MPTypeDeath", "6", Color( 255, 80, 0, 255 ) ) 
killicon.Add( "weapon_zs_melee_sledgehammer", "killicon/fists", Color(255, 255, 255, 255 ) )
end

function SWEP:Precache()
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
end
