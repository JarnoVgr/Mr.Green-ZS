-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.Base = "weapon_zs_undead_base"

SWEP.ViewModel = Model("models/weapons/v_zombine.mdl")
SWEP.WorldModel = Model("models/weapons/w_knife_t.mdl")

SWEP.PrintName = "Behemoth"
if CLIENT then
	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip = false
end

SWEP.NextPlant = 0
SWEP.Primary.Delay = 0.65
SWEP.Primary.Duration = 1.5
SWEP.Primary.Reach = 48
SWEP.Primary.Damage = 35
SWEP.Secondary.Reach = 500
--Temp workaround
SWEP.IdleSounds = ZombieClasses[8].IdleSounds



function SWEP:Think()
	self.BaseClass.Think(self)	
	
	if not IsValid(self.Owner) then
		return
	end
	
	local mOwner = self.Owner
	
	self:CheckAttackAnim()

	-- Think cooldown
	if ( self.ThinkTimer or 0 ) > CurTime() then
		return
	end		
	
	self.ThinkTimer = CurTime() + 0.5
end

function SWEP:CheckAttackAnim()
	local swingend = self:GetAttackAnimEndTime()
	if swingend == 0 or CurTime() < swingend then
		return
	end
	self:StopAttackAnim()

	local pl = self.Owner
	
	if not IsValid(pl) then return end
end

SWEP.NextSwing = 0
SWEP.ZombineAttacks = { "attackD", "attackE", "attackF", "attackB" }
function SWEP:StartPrimaryAttack()	
	--Make things easier
	local pl = self.Owner
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	--Owner
	local mOwner, mWeapon = self.Owner, self.Weapon
	
	--Set the thirdperson animation and emit zombie attack sound
	if SERVER then 
		self.Owner:EmitSound(Sound("npc/zombine/zombine_alert"..math.random ( 1,7 )..".wav"), 90, math.random(80,85)) 
		
		-- Stop when we get grenade

		--GAMEMODE:SetPlayerSpeed ( mOwner, 0,0)
		--mOwner:SetLocalVelocity ( Vector ( 0,0,0 ) )
	end

	--Sequence to play
	local iSequence = table.Random(self.ZombineAttacks) 	
	self:SetAttackSeq(iSequence)	
	--self:SetAttackAnimEndTime(CurTime() + 0.00)
	self:SetAttackAnimEndTime(CurTime() + 1.5)

	--Hacky way for the animations
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	mOwner:DoAnimationEvent(CUSTOM_PRIMARY)

	-- Idle animation
	--timer.Simple(1.5, function()
	--timer.Simple(10000, function() --work around for zombines walking and attacking
	--	if not IsValid(self) then
		--	return
	--end


	--end)
end

function SWEP:PostPerformPrimaryAttack(hit)
	if CLIENT then
		return
	end
	local pl = self.Owner
	if hit then
		if ent and IsValid(ent) and ent:IsPlayer() then
			pl:EmitSound(Sound("player/zombies/b/hitflesh.wav"),math.random(80,90),math.random(95,100))
			util.Blood(trace.HitPos, math.Rand(self.Primary.Damage * 0.25, self.Primary.Damage * 0.6), (trace.HitPos - self.Owner:GetShootPos()):GetNormal(), math.Rand(self.Primary.Damage * 6, self.Primary.Damage * 12), true)
		else
			pl:EmitSound(Sound("player/zombies/b/hitwall.wav"),math.random(80,90),math.random(95,100))
		end
	else
		self.Owner:EmitSound(Sound("player/zombies/b/swing.wav"),math.random(80,90),math.random(95,100))
	end
end

function SWEP:StopAttackAnim()
	self:SetAttackAnimEndTime(0)
	self.Weapon:SendWeaponAnim(ACT_VM_IDLE)	
end

function SWEP:SetAttackAnimEndTime(time)
	self:SetDTFloat(2, time)
end

function SWEP:GetAttackAnimEndTime()
	return self:GetDTFloat(2)
end

function SWEP:IsAttackingAnim()
	return self:GetAttackAnimEndTime() > 0
end

function SWEP:StopSwinging()
	self:SetSwingEndTime(0)
end

function SWEP:SetAttackSeq(str)
	self:SetDTString(0,str)
end

function SWEP:GetAttackSeq()
	return self:GetDTString(0)
end

function SWEP:Precache()
	util.PrecacheSound("npc/zombie/claw_strike1.wav")
	util.PrecacheSound("npc/zombie/claw_strike2.wav")
	util.PrecacheSound("npc/zombie/claw_strike3.wav")
	util.PrecacheSound("npc/zombie/claw_miss1.wav")
	util.PrecacheSound("npc/zombie/claw_miss2.wav")
	util.PrecacheSound("npc/zombine/zombine_readygrenade1.wav")
	util.PrecacheSound("npc/zombine/zombine_readygrenade2.wav")
	util.PrecacheSound("npc/zombine/zombine_charge1.wav")
	util.PrecacheSound("npc/zombine/zombine_charge2.wav")
	
	util.PrecacheModel(self.ViewModel)
	
	-- Quick way to precache all sounds
	--for _, snd in pairs(ZombieClasses[8].PainSounds) do
	for _, snd in pairs(ZombieClasses[8].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	--for _, snd in pairs(ZombieClasses[8].DeathSounds) do
	for _, snd in pairs(ZombieClasses[8].DeathSounds) do
		util.PrecacheSound(snd)
	end
	
	--for _, snd in pairs(ZombieClasses[8].IdleSounds) do
	for _, snd in pairs(ZombieClasses[8].IdleSounds) do
		util.PrecacheSound(snd)
	end
	
	--for _, snd in pairs(ZombieClasses[8].AlertSounds) do
	for _, snd in pairs(ZombieClasses[8].AlertSounds) do
		util.PrecacheSound(snd)
	end
end

SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then
		return
	end

	
	
	local mOwner = self.Owner
	if not IsValid(mOwner) then
		return
	end	
	
	if CLIENT then
		return
	end	
	
	if SERVER then
		self.Owner:EmitSound("player/zombies/b/scream.wav", 150, math.random(90,95))	
	end

	for k,v in ipairs(team.GetPlayers(TEAM_HUMAN)) do
		local fDistance = v:GetPos():Distance( self.Owner:GetPos() )

		--Check for conditions
		if not v:IsPlayer() or not v:Alive() or fDistance > self.Secondary.Reach then
			continue
		end

		local vPos, vEnd = mOwner:GetShootPos(), mOwner:GetShootPos() + ( mOwner:GetAimVector() * self.Secondary.Reach )
		local Trace = util.TraceLine ( { start = vPos, endpos = v:LocalToWorld( v:OBBCenter() ), filter = mOwner, mask = MASK_SOLID } )
			
		-- Exploit trace
		if not Trace.Hit or not IsValid(Trace.Entity) or Trace.Entity ~= v then
			continue
		end
		
		--Calculate percentage of being hit
		local fHitPercentage = math.Clamp(1 - (fDistance / self.Secondary.Reach), 0, 1)
															
		--Check if last Howler scream was recently (we don't want to stack attacks)
		if v.lastHowlerScream and v.lastHowlerScream >= (CurTime()-4) then
			continue
		end

		--Set last Howler scream
		v.lastHowlerScream = CurTime()

		--Shakey shakey
		local fFuckIntensity = fHitPercentage * 3
		
		if (v:IsHuman()) then
			GAMEMODE:OnPlayerHowlered(v, fFuckIntensity)
		elseif (v:IsZombie()) then
			v:SendLua("WraithScream()")
			v:SetHealth(math.Clamp(v:Health() * fFuckIntensity,0,v:GetMaximumHealth()))
		end
	end
	
for k,v in ipairs(team.GetPlayers(TEAM_UNDEAD)) do
		local fDistance = v:GetPos():Distance( self.Owner:GetPos() )

		--Check for conditions
		if not v:IsPlayer() or not v:Alive() or fDistance > self.Secondary.Reach then
			continue
		end

		local vPos, vEnd = mOwner:GetShootPos(), mOwner:GetShootPos() + ( mOwner:GetAimVector() * self.Secondary.Reach )
		local Trace = util.TraceLine ( { start = vPos, endpos = v:LocalToWorld( v:OBBCenter() ), filter = mOwner, mask = MASK_SOLID } )
			
		-- Exploit trace
		if not Trace.Hit or not IsValid(Trace.Entity) or Trace.Entity ~= v then
			continue
		end
		
		--Calculate percentage of being hit
		local fHitPercentage = math.Clamp(1 - (fDistance / self.Secondary.Reach), 0, 1)
															
		--Check if last Howler scream was recently (we don't want to stack attacks)
		if v.lastHowlerScream and v.lastHowlerScream >= (CurTime()-4) then
			continue
		end

		--Set last Howler scream
		v.lastHowlerScream = CurTime()

		--Shakey shakey
		local fFuckIntensity = 1 + fHitPercentage * 2.0
		
		if (v:IsHuman()) then
			GAMEMODE:OnPlayerHowlered(v, fFuckIntensity)
		elseif (v:IsZombie()) then
			v:SendLua("WraithScream()")
			v:SetHealth(math.Clamp(v:Health() * fFuckIntensity,0,v:GetMaximumHealth()))
		end
	end	
	self.NextYell = CurTime() + 8
end

