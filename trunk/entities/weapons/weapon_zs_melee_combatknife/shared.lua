-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

-- Models paths
SWEP.Author = "Deluvas"
SWEP.ViewModel = Model("models/weapons/cstrike/c_knife_t.mdl")
SWEP.UseHands = true
SWEP.WorldModel = Model("models/weapons/w_knife_t.mdl")

if CLIENT then
	killicon.AddFont("weapon_zs_melee_combatknife", "CSKillIcons", "j", Color(255, 255, 255, 255))
end

-- Name and fov
SWEP.PrintName = "Combat Knife"
SWEP.ViewModelFOV = 70

-- Position
SWEP.Slot = 2
SWEP.SlotPos = 6

-- Damage, distane, delay

SWEP.Primary.Delay = 0.62

SWEP.HoldType = "knife"

SWEP.MeleeDamage = 21
SWEP.MeleeRange = 50
SWEP.MeleeSize = 0.875
SWEP.WalkSpeed = 212

SWEP.HitDecal = "Manhackcut"

SWEP.NoHitSoundFlesh = true

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/knife/knife_slash"..math.random(1, 2)..".wav")
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/knife/knife_hitwall1.wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/knife/knife_hit"..math.random(1, 4)..".wav")
end

function SWEP:Precache()
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
end
