-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

-- Model paths
SWEP.Author = "Duby"
SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/props_canal/mattpipe.mdl"
SWEP.UseHands = true

if CLIENT then
	SWEP.ShowViewModel = false 

SWEP.VElements = {
	["1"] = { type = "Model", model = "models/props_pipes/pipecluster08d_extender128.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1.118, -10.91), angle = Angle(0, 0, 0), size = Vector(0.172, 0.172, 0.219), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["1"] = { type = "Model", model = "models/props_pipes/pipecluster08d_extender128.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 1.557, -11.948), angle = Angle(176.494, 85.324, -3.507), size = Vector(0.237, 0.237, 0.237), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

	killicon.AddFont( "weapon_zs_melee_pipe", "HL2MPTypeDeath", "g", Color(255, 255, 255, 255 ) )
end

-- Name and fov
SWEP.PrintName = "Pipe"
SWEP.ViewModelFOV = 60
SWEP.DeploySpeed = 0.6
-- Slot pos
SWEP.Slot = 2
SWEP.SlotPos = 8

-- Damage, distane, delay
SWEP.MeleeDamage = 70
SWEP.Primary.Delay = 0.90
SWEP.Primary.Distance = 73
SWEP.WalkSpeed = 177
SWEP.SwingTime = 0.75
SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.MeleeKnockBack = SWEP.MeleeDamage * 1.0
-- Killicons
if CLIENT then
	killicon.AddFont( "weapon_zs_melee_pipe", "HL2MPTypeDeath", "6", Color( 255, 80, 0, 255 ) )
end

function SWEP:PlayHitSound()
self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(3)..".wav", 75, math.random(115, 125))
end
