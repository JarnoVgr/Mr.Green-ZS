-- � Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if ( CLIENT ) then
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = true

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_debris/wood_chunk03a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.363, 1.363, -11.365), angle = Angle(180, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_debris/wood_chunk03a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.273, 1.363, -12.273), angle = Angle(180, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	killicon.AddFont( "weapon_zs_melee_plank", "ZSKillicons", "e", Color(255, 255, 255, 255 ) )
end

-- Melee base
SWEP.Base = "weapon_zs_melee_base"


-- Models paths
SWEP.Author = "Deluvas"
--SWEP.ViewModel = Model ( "models/weapons/c_crowbar.mdl" )
--SWEP.ViewModel = Model ( "models/weapons/c_stunstick.mdl" )
SWEP.UseHands = true
SWEP.WorldModel = Model ( "models/weapons/w_plank.mdl" )

-- Name and fov
SWEP.PrintName = "Plank"
SWEP.ViewModelFOV = 60

-- Position
SWEP.Slot = 2
SWEP.SlotPos = 6

-- Damage, distane, delay

SWEP.Primary.Delay = 0.36
SWEP.DamageType = DMG_CLUB
SWEP.MeleeDamage = 15
SWEP.MeleeRange = 50
SWEP.MeleeSize = 1
SWEP.WalkSpeed = SPEED
SWEP.HumanClass = "berserker"
SWEP.UseMelee1 = true
SWEP.MeleeKnockBack = SWEP.MeleeDamage * 1.0
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
 