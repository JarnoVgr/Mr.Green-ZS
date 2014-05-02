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
SWEP.Primary.Delay = 0.5
SWEP.Primary.Reach = 48
SWEP.Primary.Damage = 30

SWEP.EmitWraithSound = 0

function SWEP:Precache()
	self.BaseClass.Precache(self)

	util.PrecacheSound("npc/stalker/breathing3.wav")
	
	-- Quick way to precache all sounds
	for _, snd in pairs(ZombieClasses[4].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[4].DeathSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(self.Screams) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(self.HumanScreams) do
		util.PrecacheSound(snd)
	end
	
	for i=1, 4 do
		util.PrecacheSound("player/zombies/seeker/melee_0")
	end
end

function SWEP:Deploy()
	self.BaseClass.Deploy(self)

	if SERVER then
		self.ScarySound = CreateSound(self.Owner, Sound(""))
		
	end
end

function SWEP:StartPrimaryAttack()		
	-- Hacky way for the animations
	if self.SwapAnims then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims
	
	-- Set the thirdperson animation and emit zombie attack sound
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:EmitSound(Sound("player/zombies/seeker/screamclose.wav"), 100, math.random(92, 107))
	 
	
	local stopPlayer = true

	if self:IsDisguised() then
		self.Primary.Speed = 180
		stopPlayer = false
	else
		self.Primary.Speed = 185
	end
	 
	if SERVER then
		if stopPlayer then
			self.Owner:SetLocalVelocity(Vector(0, 0, 0))
		end
	end
end

function SWEP:Move(mv)
	if self:IsInPrimaryAttack() then
		mv:SetMaxSpeed(self.Primary.Speed)
		return true
	end
end

function SWEP:SetDisguise(bl)
	self:SetDTBool(0,bl)
	self:DrawShadow(bl)
end

function SWEP:IsDisguised()
	return self:GetDTBool(0)
end


function SWEP:SecondaryAttack()
	
end

function SWEP:OnRemove()
	if SERVER then
		self.ScarySound:Stop()
	end

	self.BaseClass.OnRemove(self)
end 

-- Main think
function SWEP:Think()
	self.BaseClass.Think(self)

	if SERVER then
		if self.ScarySound then
			self.ScarySound:PlayEx(0.2, 95 + math.sin(RealTime())*8) 
		end 
	end
	
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	return self.BaseClass.Think(self)
	
end
