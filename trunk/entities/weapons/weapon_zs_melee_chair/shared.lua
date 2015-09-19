-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile ()

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

-- Model paths
SWEP.Author = "Pufulet"
SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/props_c17/furniturechair001a.mdl"
SWEP.UseHands = true
SWEP.Durability = 4
SWEP.PrintName = "Chair"

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

if CLIENT then
	SWEP.VElements = {
		["chair"] = { type = "Model", model = "models/nova/chair_wood01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, -4.676, -28), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["chair"] = { type = "Model", model = "models/nova/chair_wood01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.909, -5.2, -20.9), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

-- Slot pos
SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.HoldType = "melee2"

SWEP.Primary.Delay = 1.3
SWEP.TotalDamage = SWEP.Primary.Damage

SWEP.MeleeDamage = 45
SWEP.MeleeRange = 52
SWEP.MeleeSize = 1.3
SWEP.MeleeKnockBack = SWEP.MeleeDamage
SWEP.WalkSpeed = SPEED_MELEE

SWEP.SwingTime = 0.8
SWEP.SwingRotation = Angle(0, -20, -40)
SWEP.SwingOffset = Vector(10, 0, 0)
SWEP.SwingHoldType = "melee2"

SWEP.HumanClass = "berserker"

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(50, 60))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/wood/wood_box_impact_hard"..math.random(1, 5)..".wav", math.random(80, 90))
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if SERVER then
		self.Durability = self.Durability - 1
		if self.Durability == 0 then
			self.Owner:EmitSound("physics/wood/wood_furniture_break1.wav", 80, math.Rand(90, 105))	
			DropWeapon(self.Owner)
			self:Remove()	
		end
	end	
end