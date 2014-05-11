-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.Base = "weapon_zs_undead_base"


SWEP.ViewModel = Model("models/weapons/v_wraith.mdl")
SWEP.WorldModel = Model("models/weapons/w_knife_t.mdl")


SWEP.HoldType = "melee2"

SWEP.PrintName = "Lilith"
SWEP.Author = "Duby"

if CLIENT then
	SWEP.ViewModelFOV = 82
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = true

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -72.75, 0) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -69.2, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -68.004, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -58.772, 0) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(11.871, -71.754, -22.512) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.777, 11.446, -35.982) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-8.693, 2.532, 25.214) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 16.1, -47.251) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 46.051) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(9.029, -52.984, -12.752) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -55.211, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(3.035, -8.169, -6.045) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(20.917, -14.115, -34.5) }
	}
		
	SWEP.VElements = {
		["hookright"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Forearm", rel = "", pos = Vector(23.111, 0.048, 1.35), angle = Angle(0, 90, -85.6), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hookleft"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(23.305, 0.048, -1.05), angle = Angle(180, 90, -85.6), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.WElements = {
		["body2"] = { type = "Model", model = "models/Humans/Charple02.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "body1", pos = Vector(4.162, -1.362, 0.55), angle = Angle(-13.912, -180, -1.675), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cleaver"] = { type = "Model", model = "models/props_lab/Cleaver.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "body1", pos = Vector(-16.514, 3.124, 34), angle = Angle(-67.575, -152.163, 24.312), size = Vector(0.563, 0.563, 0.563), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hookleft"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(12.744, -0.601, -0.758), angle = Angle(-157.594, 90.811, -98.482), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hook"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "body1", pos = Vector(-9.219, -4.031, 50), angle = Angle(-4.95, 95.3, -5.7), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hookright"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.112, -0.732, -0.639), angle = Angle(-100.482, 105.314, -69.044), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["body1"] = { type = "Model", model = "models/Humans/Charple03.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-44, 0, 23.875), angle = Angle(67.311, 0.119, 180), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
		
	
end





SWEP.Primary.Duration = 1.5
SWEP.Primary.Delay = 0.3
SWEP.Primary.Reach = 48
SWEP.Primary.Damage = 45

function SWEP:StartPrimaryAttack()
	self.BaseClass.StartPrimaryAttack(self)

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	local pl = self.Owner

	--Set the thirdperson animation and emit zombie attack sound
	pl:DoAnimationEvent(CUSTOM_PRIMARY)	

	if CLIENT then
		return
	end	

	--Slowdown
	GAMEMODE:SetPlayerSpeed(pl, 120, 120)
	
	--Restore
	timer.Simple(1.6, function()
		if not ValidEntity(pl) then
			return
		end

		local classId = pl:GetZombieClass()
		
		if not pl:Alive() or not classId == 11 then
			return
		end

		GAMEMODE:SetPlayerSpeed(pl, ZombieClasses[classId].Speed, ZombieClasses[classId].Speed)
	end)
end

function SWEP:PostPerformPrimaryAttack(hit)
	if CLIENT then
		return
	end

	self.Owner:EmitSound(Sound("player/zombies/b/swing.wav"),math.random(100,130),math.random(95,100))
end

function SWEP:PrimaryAttackHit(trace, ent)
	if CLIENT then
		return
	end

	if hit then
		if ent and ValidEntity(ent) and ent:IsPlayer() then
			pl:EmitSound(Sound("player/zombies/b/hitflesh.wav"),math.random(100,130),math.random(95,100))
			util.Blood(trace.HitPos, math.Rand(self.Primary.Damage * 0.25, self.Primary.Damage * 0.6), (trace.HitPos - self.Owner:GetShootPos()):GetNormal(), math.Rand(self.Primary.Damage * 6, self.Primary.Damage * 12), true)
		else
			pl:EmitSound(Sound("player/zombies/b/hitwall.wav"),math.random(100,130),math.random(95,100))
		end
	else
		self.Owner:EmitSound(Sound("player/zombies/b/swing.wav"),math.random(100,130),math.random(95,100))
	end
end

SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then
		return
	end

	if SERVER then
		self.Owner:EmitSound("player/zombies/b/scream.wav", math.random(130, 150), math.random(80, 110))
	end

	self.NextYell = CurTime() + math.random(8,13)
end

function SWEP:Think()
	--Start idle animation when needed
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	return self.BaseClass.Think(self)
end