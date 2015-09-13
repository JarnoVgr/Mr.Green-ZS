-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

if CLIENT then
	SWEP.ShowViewModel = true
	killicon.AddFont( "weapon_zs_melee_crowbar", "HL2MPTypeDeath", "6", Color(255, 255, 255, 255 ) )
end

-- Model paths
SWEP.Author = "Pufulet"
SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.UseHands = true

-- Name and fov
SWEP.PrintName = "Stunstick"

-- Slot pos
SWEP.Slot = 2
SWEP.SlotPos = 3

-- Damage, distance, delay
SWEP.Primary.Delay = 0.8
SWEP.MeleeDamage = 25

SWEP.MeleeRange = 46
SWEP.MeleeSize = 1.5
SWEP.MeleeDelay = 0.9
SWEP.WalkSpeed = SPEED_MELEE + 5
SWEP.MeleeKnockBack = SWEP.MeleeDamage
SWEP.HumanClass = "berserker"
SWEP.SwingTime = 0.3
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