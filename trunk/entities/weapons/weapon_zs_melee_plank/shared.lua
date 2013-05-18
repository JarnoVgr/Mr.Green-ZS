-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then AddCSLuaFile( "shared.lua" ) end

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
			["plank"] = { type = "Model", model = "models/weapons/w_plank.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.094, 1.567, -1.451), angle = Angle(1.569, -21.914, 180), size = Vector(1.299, 1.299, 1.299), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
		self.WElements = {} 
	end

	self.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1.611, 1.611, 1.611), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(0.563, 0.563, 0.563), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-2.813, 0, -330), angle = Angle(0, 0, 0) }
	}
	
	
end

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

-- Models paths
SWEP.Author = "Deluvas"
SWEP.ViewModel = Model ( "models/weapons/v_plank/v_plank.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_plank.mdl" )

-- Name and fov
SWEP.PrintName = "Plank"
SWEP.ViewModelFOV = 57

-- Position
SWEP.Slot = 2
SWEP.SlotPos = 6

-- Damage, distane, delay
SWEP.Primary.Damage = 25
SWEP.Primary.Delay = 0.4
SWEP.Primary.Distance = 50

SWEP.DamageType = DMG_CLUB

SWEP.MeleeDamage = 25
SWEP.MeleeRange = 45
SWEP.MeleeSize = 0.875

SWEP.UseMelee1 = true

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/knife/knife_slash"..math.random(1, 2)..".wav")
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/wood/wood_plank_impact_hard"..math.random(1, 5)..".wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/flesh/flesh_impact_bullet"..math.random(1, 5)..".wav")
end


-- Killicon
if CLIENT then killicon.AddFont( "weapon_zs_melee_plank", "ZSKillicons", "e", Color(255, 255, 255, 255 ) ) end

function SWEP:Precache()
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
end
 