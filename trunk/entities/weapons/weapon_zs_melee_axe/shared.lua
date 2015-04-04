-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile ()

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

if CLIENT then
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = true

	SWEP.VElements = {
		["axe"] = { type = "Model", model = "models/props/CS_militia/axe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.885, 2.0, -4.541), angle = Angle(0, -6.658, 88.976), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	--[[SWEP.WElements = {
		["axe"] = { type = "Model", model = "models/props/CS_militia/axe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.742, 1.603, -3.182), angle = Angle(2.88, 0, 82.841), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}]]

	killicon.AddFont("weapon_zs_melee_axe", "ZSKillicons", "a", Color(255, 255, 255, 255))
end

-- Model paths
SWEP.Author = "Deluvas"
SWEP.ViewModel = Model ( "models/weapons/c_stunstick.mdl" )
SWEP.UseHands = true
SWEP.WorldModel = Model("models/weapons/w_axe.mdl")

-- Name and fov
SWEP.PrintName = "Axe"
SWEP.ViewModelFOV = 50

-- Slot pos
SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.HoldType = "melee2"
-- Damage, distane, delay

SWEP.Primary.Delay = 1.05
SWEP.TotalDamage = SWEP.Primary.Damage

SWEP.MeleeDamage = 50
SWEP.MeleeRange = 56
SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = SWEP.MeleeDamage * 1.0
SWEP.WalkSpeed = 200

SWEP.SwingTime = 0.65
SWEP.SwingRotation = Angle(0, -20, -40)
SWEP.SwingOffset = Vector(10, 0, 0)
SWEP.SwingHoldType = "melee"

SWEP.CanDecapitate = true

SWEP.HitDecal = "Manhackcut"

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 70))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/golf club/golf_hit-0"..math.random(1, 4)..".wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end

function SWEP:Precache()
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
end