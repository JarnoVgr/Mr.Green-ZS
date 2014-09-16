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
SWEP.ViewModelFOV = 60

-- Position
SWEP.Slot = 2
SWEP.SlotPos = 6

-- Damage, distane, delay

SWEP.Primary.Delay = 0.7

SWEP.HoldType = "knife"

SWEP.MeleeDamage = 20
SWEP.MeleeRange = 50
SWEP.MeleeSize = 0.875
SWEP.WalkSpeed = 210

SWEP.HitDecal = "Manhackcut"

SWEP.NoHitSoundFlesh = true

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_bat.mdl", bone = "v_weapon.Knife_Handle", rel = "", pos = Vector(0, 0, -6.36), angle = Angle(0, 0, 0), size = Vector(0.5, 0.776, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

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
