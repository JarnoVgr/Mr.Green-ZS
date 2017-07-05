-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

if CLIENT then
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true

	killicon.AddFont("weapon_zs_pot", "HL2MPTypeDeath", "f", Color(255, 255, 255, 255))
end

SWEP.VElements = {
	["pot"] = { type = "Model", model = "models/weapons/w_pot.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.282, 2.484, 0), angle = Angle(0, 180, -90), size = Vector(1, 0.8, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

-- Model paths
SWEP.ViewModel = Model ( "models/weapons/c_crowbar.mdl" )
SWEP.UseHands = true
SWEP.WorldModel = Model ( "models/weapons/w_pot.mdl" )

-- Name and fov
SWEP.PrintName = "Pot"

-- Slot
SWEP.Slot = 0

-- Damage, distane, delay
SWEP.Primary.Delay = 1
SWEP.DamageType = DMG_CLUB
SWEP.MeleeDamage = 40
SWEP.MeleeRange = 52
SWEP.MeleeSize = 1.0
SWEP.SwingTime = 0.65

SWEP.Type = "Melee"
SWEP.Weight = 1

SWEP.UseMelee1 = true

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingHoldType = "grenade"


function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/frying_pan/pan_hit-0"..math.random(1,4)..".wav")
end 