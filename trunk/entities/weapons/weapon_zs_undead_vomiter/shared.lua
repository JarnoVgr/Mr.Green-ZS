-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--BIG WORK IN PROGRESS

AddCSLuaFile()

SWEP.Base = "weapon_zs_undead_base"

SWEP.PrintName = "Vomit Zombie"
if CLIENT then
	SWEP.ViewModelFOV = 35
	SWEP.ViewModelFlip = false
end

SWEP.ViewModel = Model("models/weapons/v_pza.mdl")
SWEP.WorldModel = Model("models/weapons/w_knife_t.mdl")

SWEP.Primary.Delay = 0.8
SWEP.Primary.Reach = 65
SWEP.Primary.Duration = 2
SWEP.Primary.Damage = 55

SWEP.Secondary.Automatic	= true
SWEP.Secondary.Duration = 0
SWEP.Secondary.Delay = 0
SWEP.Secondary.Damage = math.random(2,5)

SWEP.SwapAnims = false


SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1.075, 1.075, 1.075), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1.488, 1.488, 1.488), pos = Vector(0, 0, 0), angle = Angle(-4.139, -1.862, 1.238) },
	["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1.343, 1.343, 1.343), pos = Vector(0, 0, 0), angle = Angle(-3.389, 0.075, 1.312) },
	["ValveBiped.Bip01_Spine4"] = { scale = Vector(1, 1, 1), pos = Vector(-3.701, 0.425, -0.288), angle = Angle(0, 0, 0) },
	-- ["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(1.58, 5.205, 0) },
	["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1.213, 1.213, 1.213), pos = Vector(0, 0, 0), angle = Angle(-0.151, -20.414, -7.045) }
}



SWEP.WElements = {
--	["2"] = { type = "Model", model = "models/weapons/w_plank.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1.557, 0), angle = Angle(5.843, 0, 180), size = Vector(1.08, 1.08, 1.08), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
--	["1"] = { type = "Model", model = "models/zombie/classic_torso.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-9.87, 3.635, 0.518), angle = Angle(10.519, -54.936, -92.338), size = Vector(1.014, 1.014, 1.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
--	["3"] = { type = "Model", model = "models/zombie/fast_torso.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-15.065, 1.557, -0.519), angle = Angle(-8.183, -82.987, -97.014), size = Vector(0.82, 0.82, 0.82), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}




function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	if CLIENT then
		self.BreathSound = CreateSound(self.Weapon,Sound("npc/zombie_poison/pz_breathe_loop1.wav"));
		if self.BreathSound then
			self.BreathSound:Play()
		end
	end
end

function SWEP:StartPrimaryAttack()			
	
end

function SWEP:PostPerformPrimaryAttack(hit)
	
end

function SWEP:StartSecondaryAttack()
	local pl = self.Owner
	
	if pl:GetAngles().pitch > 55 or pl:GetAngles().pitch < -55 then
		pl:EmitSound(Sound("npc/zombie_poison/pz_idle"..math.random(2,4)..".wav"))
		return
	end
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
	if SERVER then
		pl:EmitSound(Sound("npc/zombie_poison/pz_throw".. math.random(2,3) ..".wav"))
	end
end


function SWEP:PerformSecondaryAttack()
	local pl = self.Owner

	-- GAMEMODE:SetPlayerSpeed ( pl, ZombieClasses[ pl:GetZombieClass() ].Speed ) 
	if pl:GetAngles().pitch > 55 or pl:GetAngles().pitch < -55 then 
		if SERVER then
			pl:EmitSound(Sound("npc/zombie_poison/pz_idle".. math.random(2,4) ..".wav"))
		end

		return 
	end
		
	--Swap Anims
	if self.SwapAnims then
		self:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims
		
	if CLIENT then
		return
	end

	local shootpos = pl:GetShootPos()
	local startpos = pl:GetPos()
	startpos.z = shootpos.z
	local aimvec = pl:GetAimVector()
	aimvec.z = math.max(aimvec.z, -0.7)
	
	for i=1, 8 do
		local ent = ents.Create("projectile_poisonpuke")
		if ent:IsValid() then
			local heading = (aimvec + VectorRand() * 0.2):GetNormal()
		--	ent:SetPos(startpos + heading * 8)
			ent:SetPos(startpos + heading * 10)
			ent:SetOwner(pl)
			ent:Spawn()
			ent.TeamID = pl:Team()
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetVelocityInstantaneous(heading * math.Rand(600, 900))
			end
			ent:SetPhysicsAttacker(pl)
		end
	end

	pl:EmitSound(Sound("physics/body/body_medium_break"..math.random(2,4)..".wav"), 80, math.random(70, 80))

	pl:TakeDamage(self.Secondary.Damage, pl, self.Weapon)
end

function SWEP:Move(mv)
	if self:IsInPrimaryAttack() then
		mv:SetMaxSpeed(self.Owner:GetMaxSpeed()*8)
		return true
	elseif self:IsInSecondaryAttack() then
		mv:SetMaxSpeed(170)
		return true
	end
end

function SWEP:OnRemove()
	self.BaseClass.OnRemove(self)

	if CLIENT and self.BreathSound then
		self.BreathSound:Stop()
	end

	return true
end

function SWEP:Precache()
	util.PrecacheSound("npc/zombie_poison/pz_throw2.wav")
	util.PrecacheSound("npc/zombie_poison/pz_throw3.wav")
	util.PrecacheSound("npc/zombie_poison/pz_warn1.wav")
	util.PrecacheSound("npc/zombie_poison/pz_warn2.wav")
	util.PrecacheSound("npc/zombie_poison/pz_idle2.wav")
	util.PrecacheSound("npc/zombie_poison/pz_idle3.wav")
	util.PrecacheSound("npc/zombie_poison/pz_idle4.wav")
	util.PrecacheSound("npc/zombie/claw_strike1.wav")
	util.PrecacheSound("npc/zombie/claw_strike2.wav")
	util.PrecacheSound("npc/zombie/claw_strike3.wav")
	util.PrecacheSound("npc/zombie/claw_miss1.wav")
	util.PrecacheSound("npc/zombie/claw_miss2.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump1.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump2.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump3.wav")
	util.PrecacheSound("npc/zombie_poison/pz_breathe_loop1.wav")
	
	-- Quick way to precache all sounds
	for _, snd in pairs(ZombieClasses[3].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[3].IdleSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[3].DeathSounds) do
		util.PrecacheSound(snd)
	end
end