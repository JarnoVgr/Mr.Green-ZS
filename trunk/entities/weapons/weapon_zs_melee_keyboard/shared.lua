-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

if CLIENT then
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true

	killicon.AddFont("weapon_zs_melee_keyboard", "ZSKillicons", "d", Color(255, 255, 255, 255))
end

-- Model paths
SWEP.Author = "Deluvas"
SWEP.ViewModel = Model("models/weapons/v_keyboard/c_keyboard.mdl")
SWEP.UseHands = true
SWEP.WorldModel = Model("models/weapons/w_keyboard.mdl")

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
SWEP.WalkSpeed = 208

SWEP.SwingTime = 0.3
SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingOffset = Vector(0, -30, 0)
SWEP.SwingHoldType = "melee"

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/keyboard/keyboard_hit-0"..math.random(1, 4)..".wav")
end