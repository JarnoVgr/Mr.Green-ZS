-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

if CLIENT then
	SWEP.ShowViewModel = true
	killicon.AddFont( "weapon_zs_stunstick", "HL2MPTypeDeath", "!", Color(255, 255, 255, 255 ) )
end

-- Model paths

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.UseHands = true

-- Name and fov
SWEP.PrintName = "Stunstick"

-- Slot pos
SWEP.Slot = 0
SWEP.Weight = 1
SWEP.Type = "Melee"

-- Damage, distance, delay
SWEP.Primary.Delay = 0.8
SWEP.MeleeDamage = 30

SWEP.MeleeRange = 49
SWEP.MeleeSize = 1.5
SWEP.MeleeDelay = 0.9

SWEP.SwingTime = 0.65
SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingHoldType = "grenade"

function SWEP:PlaySwingSound()
	self:EmitSound("Weapon_StunStick.Swing")
end

function SWEP:PlayHitSound()
	self:EmitSound("Weapon_StunStick.Melee_HitWorld")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("Weapon_StunStick.Melee_Hit")
end