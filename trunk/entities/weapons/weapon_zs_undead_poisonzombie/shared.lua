-- � Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.Base = "weapon_zs_undead_base"

SWEP.PrintName = "Poison Zombie"
if CLIENT then
SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

end

SWEP.ViewModel = "models/weapons/v_pza.mdl"
SWEP.WorldModel = Model("models/weapons/w_knife_t.mdl")

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 0.83, 1), pos = Vector(0.5, 1, -1.668), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 0.628, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}


SWEP.Primary.Delay = 0.8
SWEP.Primary.Reach = 50
SWEP.Primary.Duration = 1.6
SWEP.Primary.Damage = 35

SWEP.Secondary.Delay = 0.8
SWEP.Secondary.Duration = 4

SWEP.SwapAnims = false



function SWEP:StartPrimaryAttack()			
	--Hacky way for the animations
	self.SwapAnims = not self.SwapAnims
		
	self.Owner:SetAnimation(PLAYER_ATTACK1)		
	
	--Set the thirdperson animation and emit zombie attack sound
	--self.Owner:DoAnimationEvent(CUSTOM_PRIMARY)
  
	--Emit sound
	--[[if SERVER and #self.AttackSounds > 0 then
		self.Owner:EmitSound(Sound(self.AttackSounds[math.random(#self.AttackSounds)]))
	end]]

	-- Set the thirdperson animation and emit zombie attack sound
	if SERVER then
		self.Owner:EmitSound(Sound("npc/zombie_poison/pz_warn"..math.random(1, 2)..".wav"))
	end	
end

function SWEP:PostPerformPrimaryAttack(hit)
	if self.SwapAnims then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end

	if hit then
		self.Owner:EmitSound(Sound("npc/zombiegreen/hit_punch_0".. math.random(1, 8) ..".wav"))
	else
		self.Owner:EmitSound(Sound("npc/zombiegreen/claw_miss_"..math.random(1, 2)..".wav"))
	end
end


function SWEP:StartSecondaryAttack()
	local pl = self.Owner
	
	pl:DoAnimationEvent(ACT_RANGE_ATTACK2)		
	
	if pl:GetAngles().pitch > 180 or pl:GetAngles().pitch < -180 then
		pl:EmitSound(Sound("npc/zombie_poison/pz_idle"..math.random(2,4)..".wav"))
		return
	end
	
	pl:Daze(3.25);	
	
	if SERVER then
		pl:EmitSound("NPC_PoisonZombie.Throw")
	end
end


function SWEP:PerformSecondaryAttack()
	local pl = self.Owner

	-- GAMEMODE:SetPlayerSpeed ( pl, ZombieClasses[ pl:GetZombieClass() ].Speed ) 
	if pl:GetAngles().pitch > 90 or pl:GetAngles().pitch < -90 then 
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
			local heading = (aimvec + VectorRand() * 0.32):GetNormal()
			ent:SetPos(startpos + heading * 8)
			ent:SetOwner(pl)
			ent:Spawn()
			ent.TeamID = pl:Team()
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				--phys:SetVelocityInstantaneous(heading * math.Rand(310, 560))
				phys:SetVelocityInstantaneous(heading * math.Rand(420, 520))
			end
			ent:SetPhysicsAttacker(pl)
		end
	end

	pl:EmitSound(Sound("physics/body/body_medium_break"..math.random(2,4)..".wav"), 80, math.random(70, 80))

	--pl:TakeDamage(self.Secondary.Damage, pl, self.Weapon)
end
--[[
function SWEP:Move(mv)
	if self:IsInPrimaryAttack() then
		--mv:SetMaxSpeed(self.Owner:GetMaxSpeed()*0.8)
		return true
	elseif self:IsInSecondaryAttack() then
		--mv:SetMaxSpeed(150)
		return true
	end
end
]]--
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

