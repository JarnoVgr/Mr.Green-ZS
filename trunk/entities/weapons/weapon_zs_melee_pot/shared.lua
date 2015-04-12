-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

if CLIENT then
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true

	killicon.AddFont("weapon_zs_melee_pot", "HL2MPTypeDeath", "f", Color(255, 255, 255, 255))

	SWEP.VElements = {
		["pot"] = { type = "Model", model = "models/weapons/w_pot.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.282, 2.484, 0), angle = Angle(0, 180, -90), size = Vector(1, 0.8, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

-- Model paths
SWEP.Author = "Deluvas"
SWEP.ViewModel = Model ( "models/weapons/c_crowbar.mdl" )
SWEP.UseHands = true
SWEP.WorldModel = Model ( "models/weapons/w_pot.mdl" )

-- Name and fov
SWEP.PrintName = "Pot"
SWEP.ViewModelFOV = 50

-- Slot
SWEP.Slot = 2
SWEP.SlotPos = 7

-- Damage, distane, delay
SWEP.Primary.Delay = 0.70
SWEP.DamageType = DMG_CLUB
SWEP.MeleeDamage = 40
SWEP.MeleeRange = 50
SWEP.MeleeSize = 1.0
SWEP.WalkSpeed = 202

SWEP.UseMelee1 = true

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingTime = 0.35
SWEP.SwingHoldType = "grenade"
SWEP.MeleeKnockBack = SWEP.MeleeDamage * 1.0

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/frying_pan/pan_hit-0"..math.random(1,4)..".wav")
end 