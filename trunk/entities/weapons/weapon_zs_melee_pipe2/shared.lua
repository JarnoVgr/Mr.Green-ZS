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
["base"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.2, 1, -2.274), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
["base"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.599, 1, -6), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


	killicon.AddFont( "weapon_zs_melee_pipe2", "HL2MPTypeDeath", "6", Color(255, 225, 225, 255 ) )
end

-- Name and fov
SWEP.PrintName = "Improved Pipe"
SWEP.ViewModelFOV = 60
SWEP.DeploySpeed = 0.6
-- Slot pos
SWEP.Slot = 2
SWEP.SlotPos = 8

-- Damage, distane, delay
SWEP.MeleeDamage = 80
SWEP.Primary.Delay = 0.6
SWEP.Primary.Distance = 73
SWEP.WalkSpeed = 177
SWEP.SwingTime = 1
SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.MeleeKnockBack = SWEP.MeleeDamage * 1.0

function SWEP:PlayHitSound()
self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(3)..".wav", 75, math.random(115, 125))
end
