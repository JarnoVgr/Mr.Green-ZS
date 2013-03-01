AddCSLuaFile("shared.lua")

SWEP.Base = "weapon_zs_melee_base"

if CLIENT then
	SWEP.PrintName = "Shovel"
	SWEP.ViewModelFOV = 75
	
end

SWEP.Slot = 2
SWEP.SlotPos = 1 

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
			["shovel"] = { type = "Model", model = "models/weapons/w_shovel.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.23, 1.656, 1.868), angle = Angle(-169.075, -3.037, 1.993), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
		self.WElements = {} 
	end

	self.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1.611, 1.611, 1.611), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(0.563, 0.563, 0.563), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-2.813, 0, -330), angle = Angle(0, 0, 0) }
	}
	
	
	
end

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/v_shovel/v_shovel.mdl"
SWEP.WorldModel = "models/weapons/w_shovel.mdl"

SWEP.MeleeDamage = 50
SWEP.MeleeRange = 55
SWEP.MeleeSize = 1.3

SWEP.Primary.Delay = 1.3

SWEP.WalkSpeed = 150

SWEP.SwingRotation = Angle(0, -90, -60)
SWEP.SwingOffset = Vector(0, 30, -40)
SWEP.SwingTime = 0.65
SWEP.SwingHoldType = "melee"

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 70))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/shovel/shovel_hit-0"..math.random(1, 4)..".wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end

if CLIENT then killicon.AddFont( "weapon_zs_melee_shovel", "HL2MPTypeDeath", "6", Color(255, 255, 255, 255 ) ) end 