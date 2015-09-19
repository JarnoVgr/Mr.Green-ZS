-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

-- Model paths
SWEP.Author = "Duby"
SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/props_lab/pipesystem01b.mdl"
SWEP.UseHands = true

if CLIENT then
SWEP.VElements = {
	["1"] = { type = "Model", model = "models/props_lab/pipesystem01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1.118, -10.91), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.55), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["1"] = { type = "Model", model = "models/props_lab/pipesystem01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 1.557, -11.948), angle = Angle(176.494, 85.324, -3.507), size = Vector(0.65, 0.65, 0.67), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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
SWEP.HumanClass = "berserker"
-- Damage, distane, delay
SWEP.MeleeDamage = 23
SWEP.Primary.Delay = 0.75
SWEP.Primary.Distance = 55
SWEP.WalkSpeed = SPEED_MELEE
SWEP.SwingTime = 0.7
SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.MeleeKnockBack = SWEP.MeleeDamage
-- Killicons
if CLIENT then
	killicon.AddFont( "weapon_zs_melee_pipe", "HL2MPTypeDeath", "6", Color( 255, 200, 200, 255 ) )
end

function SWEP:PlayHitSound()
self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(3)..".wav", 75, math.random(115, 125))
end
