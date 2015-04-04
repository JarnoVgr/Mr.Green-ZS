AddCSLuaFile()

SWEP.Base = "weapon_zs_melee_base"

if CLIENT then
	SWEP.PrintName = "Shovel"
	SWEP.ViewModelFOV = 60
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = true
	--SWEP.IgnoreBonemerge = true
	--SWEP.RotateFingers = Angle(12,-35,0)
	--SWEP.DummyModel = true
	killicon.AddFont( "weapon_zs_melee_shovel", "HL2MPTypeDeath", "6", Color(255, 255, 255, 255 ) )
end

SWEP.Slot = 2
SWEP.SlotPos = 1 

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_shovel.mdl"

SWEP.MeleeDamage = 70
SWEP.MeleeRange = 70
SWEP.MeleeSize = 1.3

SWEP.Primary.Delay = 1.25
SWEP.WalkSpeed = 190

SWEP.SwingRotation = Angle(0, -90, -60)
SWEP.SwingOffset = Vector(0, 30, -40)
SWEP.SwingTime = 0.65
SWEP.SwingHoldType = "melee"
SWEP.MeleeKnockBack = SWEP.MeleeDamage * 1.1

SWEP.VElements = {
	["shovel"] = { type = "Model", model = "models/weapons/w_shovel.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.924, 1.907, 0), angle = Angle(0, 180, 180), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {}

SWEP.ViewModelBoneMods = {}

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 70))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/shovel/shovel_hit-0"..math.random(1, 4)..".wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end