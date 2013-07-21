-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then AddCSLuaFile ( "shared.lua" ) end

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

if CLIENT then

SWEP.ShowViewModel = true
SWEP.IgnoreBonemerge = true
SWEP.RotateFingers = Angle(12,-35,0)

SWEP.DummyModel = true
end

function SWEP:InitializeClientsideModels()
	
	if XMAS_2012 then
		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/sniper/xms_sniperrifle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.667, -0.433, 5.466), angle = Angle(-87.473, -94.765, -37.489), size = Vector(0.912, 0.912, 0.912), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		self.WElements = {
			["lights"] = { type = "Model", model = "models/player/items/sniper/xms_sniperrifle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.027, 1.738, 0), angle = Angle(-90.68, -8.054, 12.628), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
	else
		self.VElements = {
			["crowbar"] = { type = "Model", model = "models/weapons/w_crowbar.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.456, 1.562, 1.044), angle = Angle(93.392, -34.156, 180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
		self.WElements = {} 
	end
	
	
end

-- Model paths
SWEP.Author = "Deluvas"
SWEP.ViewModel = Model ( "models/weapons/v_crowbar.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_crowbar.mdl" )

-- Name and fov
SWEP.PrintName = "Crowbar"
SWEP.ViewModelFOV = 60

-- Slot pos
SWEP.Slot = 2
SWEP.SlotPos = 3

-- Damage, distane, delay
SWEP.Primary.Damage = 45
SWEP.Primary.Delay = 0.7
SWEP.Primary.Distance = 65
SWEP.TotalDamage = SWEP.Primary.Damage

SWEP.MeleeDamage = 60
SWEP.MeleeRange = 65
SWEP.MeleeSize = 1.45
SWEP.MeleeKnockBack = SWEP.MeleeDamage * 1.5

SWEP.SwingTime = 0.44
SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingHoldType = "grenade"

function SWEP:PlaySwingSound()
	self:EmitSound("Weapon_Crowbar.Single")
end

function SWEP:PlayHitSound()
	self:EmitSound("Weapon_Crowbar.Melee_HitWorld")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("Weapon_Crowbar.Melee_Hit")
end


-- Killicons
if CLIENT then killicon.AddFont( "weapon_zs_melee_crowbar", "HL2MPTypeDeath", "6", Color(255, 255, 255, 255 ) ) end
 
