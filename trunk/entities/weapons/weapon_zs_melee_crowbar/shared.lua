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
SWEP.Author = "Deluvas"
SWEP.ViewModel = Model("models/weapons/c_crowbar.mdl")
SWEP.UseHands = true
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

-- Name and fov
SWEP.PrintName = "Crowbar"
SWEP.ViewModelFOV = 50

-- Slot pos
SWEP.Slot = 2
SWEP.SlotPos = 3

-- Damage, distance, delay
SWEP.Primary.Delay = 0.80
SWEP.TotalDamage = SWEP.Primary.Damage

SWEP.MeleeDamage = 45
SWEP.MeleeRange = 55
SWEP.MeleeSize = 1.45
SWEP.WalkSpeed = 197
SWEP.MeleeKnockBack = SWEP.MeleeDamage * 1.0

SWEP.SwingTime = 0.55
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