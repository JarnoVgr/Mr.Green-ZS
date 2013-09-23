-- � Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then AddCSLuaFile( "shared.lua" ) end

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

-- Models paths
SWEP.Author = "Deluvas"--Edited by NECROSSIN
SWEP.ViewModel = Model ( "models/weapons/cstrike/c_knife_t.mdl"  )
SWEP.UseHands = true
SWEP.WorldModel = Model ( "models/weapons/w_knife_t.mdl"  )

-- Name and fov
SWEP.PrintName = "Combat Knife"
SWEP.ViewModelFOV = 70

-- Position
SWEP.Slot = 2
SWEP.SlotPos = 6

-- Damage, distane, delay

SWEP.Primary.Delay = 0.55

SWEP.HoldType = "knife"

SWEP.MeleeDamage = 17
SWEP.MeleeRange = 50
SWEP.MeleeSize = 0.875
SWEP.WalkSpeed = 215

SWEP.HitDecal = "Manhackcut"

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
SWEP.MissGesture = SWEP.HitGesture

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

-- Killicon
if CLIENT then killicon.AddFont( "weapon_zs_melee_combatknife", "CSKillIcons", "j", Color(255, 255, 255, 255 ) ) 
SWEP.ShowViewModel = true
-- SWEP.FlipYaw = true
end

function SWEP:Precache()
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
end
