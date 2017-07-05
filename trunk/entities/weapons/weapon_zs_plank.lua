-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if ( CLIENT ) then
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = true

	SWEP.VElements = {
	--["plank"] = { type = "Model", model = "models/weapons/w_plank.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.359, 1.521, 0), angle = Angle(0, 0, 180), size = Vector(1.23, 1.23, 1.23), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	["plank"] = { type = "Model", model = "models/weapons/w_plank.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.359, 2.521, 0), angle = Angle(0, 0, 180), size = Vector(1.23, 1.23, 1.23), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	killicon.AddFont( "weapon_zs_plank", "ZSKillicons", "e", Color(255, 255, 255, 255 ) )
end


-- Melee base
SWEP.Base = "weapon_zs_melee_base"

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = Model ( "models/weapons/w_plank.mdl" )

SWEP.PrintName = "Plank"
SWEP.Type = "Melee"
SWEP.Weight = 1
SWEP.Slot = 0

SWEP.Primary.Delay = 0.35
SWEP.DamageType = DMG_CLUB
SWEP.MeleeDamage = 18
SWEP.MeleeRange = 48
SWEP.MeleeSize = 1
SWEP.HumanClass = "berserker"
SWEP.UseMelee1 = true
SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

function SWEP:OnDeploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/knife/knife_slash"..math.random(1, 2)..".wav")
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/wood/wood_plank_impact_hard"..math.random(1, 5)..".wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/flesh/flesh_impact_bullet"..math.random(1, 5)..".wav")
end

function SWEP:Precache()
	--TODO: Include base?

	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
end
 