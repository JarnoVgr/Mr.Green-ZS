-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

-- Melee base
SWEP.Base = "weapon_zs_melee_base"


if CLIENT then
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = true

	SWEP.VElements = {
		["sledge"] = { type = "Model", model = "models/weapons/w_sledgehammer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.144, 1.421, 8.611), angle = Angle(0, 0, 180), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	killicon.Add( "weapon_zs_sledgehammer", "killicon/fists", Color(255, 255, 255, 255 ) )
end

--SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.ViewModel = Model ( "models/weapons/c_stunstick.mdl" )
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_sledgehammer.mdl" 

-- Name and fov
SWEP.PrintName = "Sledgehammer"
SWEP.Weight = 3
SWEP.Slot = 0
SWEP.Type = "Melee"
-- Slot pos



SWEP.HoldType = "melee2"
-- Damage, distane, delay

SWEP.HumanClass = "berserker"
SWEP.MeleeDamage = 75
SWEP.MeleeRange = 64
SWEP.MeleeSize = 2.0

SWEP.Primary.Delay = 1.4

SWEP.SwingRotation = Angle(60, 0, -80)
SWEP.SwingOffset = Vector(0, -30, 0)
SWEP.SwingTime = 1
SWEP.SwingHoldType = "melee"

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(35, 45))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(1, 3)..".wav", 75, math.random(86, 90))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.random(86, 90))
end


function SWEP:Precache()
	--TODO: Include base?

	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
end
