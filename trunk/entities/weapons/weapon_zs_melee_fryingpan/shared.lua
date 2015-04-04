-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

if CLIENT then
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = true

	killicon.AddFont( "weapon_zs_melee_fryingpan", "ZSKillicons", "b", Color(255, 255, 255, 255 ) ) 
end

SWEP.VElements = {
	["pan"] = { type = "Model", model = "models/weapons/w_fryingpan.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.282, 2.484, 0), angle = Angle(0, 180, -90), size = Vector(1, 0.8, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

-- Model paths
SWEP.Author = "Deluvas"
SWEP.ViewModel = Model ( "models/weapons/c_crowbar.mdl" )
SWEP.UseHands = true
SWEP.WorldModel = Model ( "models/weapons/w_fryingpan.mdl" )

-- Name
SWEP.PrintName = "Frying Pan"
SWEP.ViewModelFOV = 50

-- Position
SWEP.Slot = 2
SWEP.SlotPos = 4

-- Damage, distane, delay
SWEP.Primary.Delay = 0.6
SWEP.DamageType = DMG_CLUB
SWEP.MeleeDamage = 37
SWEP.MeleeRange = 54
SWEP.MeleeSize = 1.0
SWEP.WalkSpeed = 207
SWEP.MeleeKnockBack = SWEP.MeleeDamage * 1.1

SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingTime = 0.38
SWEP.SwingHoldType = "grenade"

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/frying_pan/pan_hit-0"..math.random(1,4)..".wav")
end