-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.Base = "weapon_zs_undead_base"


SWEP.PrintName = "Howler"

if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	SWEP.FakeArms = true
end


SWEP.ViewModel = Model("models/Weapons/v_zombiearms.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Primary.Delay = 0
SWEP.Primary.Next = 4
SWEP.Primary.Duration = 1.2
SWEP.Primary.Reach = 480
--SWEP.Primary.Reach = 380

--Mimic primary
SWEP.Secondary.Duration = SWEP.Primary.Duration
SWEP.Secondary.Delay = SWEP.Primary.Delay
SWEP.Secondary.Next = SWEP.Primary.Next

function SWEP:Precache()
	self.BaseClass.Precache(self)

	util.PrecacheSound("ambient/energy/zap6.wav")
	util.PrecacheSound("npc/barnacle/barnacle_bark1.wav")

	-- Quick way to precache all sounds
	for _, snd in pairs(ZombieClasses[5].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[5].DeathSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[5].AttackSounds) do
		util.PrecacheSound(snd)
	end
end	

function SWEP:DoAttack(bPull) 	
	-- Get owner
	local mOwner = self.Owner
	if not IsValid(mOwner) then
		return
	end
	
	-- Cannot scream in air
	if not mOwner:OnGround() then
		return
	end
		
	--Thirdperson animation and sound
	mOwner:DoAnimationEvent(CUSTOM_PRIMARY)

			
	--Just server from here
	if CLIENT then
		return
	end

	--Emit Sound
	mOwner:EmitSound(table.Random(ZombieClasses[mOwner:GetZombieClass()].AttackSounds), 100, math.random(95, 135))

	--Find in sphere
	for k,v in ipairs(team.GetPlayers(TEAM_HUMAN)) do
		local fDistance = v:GetPos():Distance( self.Owner:GetPos() )

		--Check for conditions
		if not v:IsPlayer() or not v:IsHuman() or not v:Alive() or fDistance > self.Primary.Reach then
			continue
		end

		local vPos, vEnd = mOwner:GetShootPos(), mOwner:GetShootPos() + ( mOwner:GetAimVector() * self.Primary.Reach )
		local Trace = util.TraceLine ( { start = vPos, endpos = v:LocalToWorld( v:OBBCenter() ), filter = mOwner, mask = MASK_SOLID } )
			
		-- Exploit trace
		if not Trace.Hit or not IsValid(Trace.Entity) or Trace.Entity ~= v then
			continue
		end
		
		--Calculate percentage of being hit
		local fHitPercentage = math.Clamp(1 - (fDistance / self.Primary.Reach), 0, 1)
															
		--Inflict damage
	--	local fDamage = math.Round(24 * fHitPercentage, 0, 10)
		local fDamage = math.Round(20 * fHitPercentage, 0, 10)
		if fDamage > 0 then
			v:TakeDamage(fDamage, self.Owner, self)
		end

		--Check if last Howler scream was recently (we don't want to stack attacks)
		if v.lastHowlerScream and v.lastHowlerScream >= (CurTime()-4) then
			continue
		end

		--Set last Howler scream
		v.lastHowlerScream = CurTime()

		--Shakey shakey
		local fFuckIntensity = fHitPercentage + 1.4 --Duby test.

		GAMEMODE:OnPlayerHowlered(v, fFuckIntensity)

		-- Calculate base velocity
		local Velocity = -1 * mOwner:GetForward() * 120
		if not bPull then
			Velocity = -1 * Velocity * 2
		end
		
		
		Velocity.x, Velocity.y, Velocity.z = Velocity.x * 0.5, Velocity.y * 0.5, math.random(190, 230)
		if not bPull then
			Velocity = Vector(Velocity.x * 0.45, Velocity.y * 0.45, Velocity.z)
		end

		--Apply velocity		
		v:SetVelocity(Velocity)
				
		-- Play sound
		timer.Simple(0.2, function()
			if IsValid(v) then
				sound.Play("npc/barnacle/barnacle_bark1.wav", v:GetPos() + Vector(0, 0, 20), 120, math.random(60, 75))
			end
		end)
	end
	
	--On trigger play sound
	local iRandom = math.Rand(1, 2.5)
	if iRandom <= 1.5 then
		self.Owner:EmitSound("ambient/energy/zap6.wav")
	end
	
	--Scream effect for myself
	self.Owner:SendLua("WraithScream()")
end

function SWEP:PerformPrimaryAttack()
	self:DoAttack(true)
end

function SWEP:PerformSecondaryAttack()
	--self:DoAttack(false)
	self:DoAttack(true)
end

function SWEP:Move(mv)
	if self:IsInPrimaryAttack() then
		mv:SetMaxSpeed(80)
		return true
	end
	if self:IsInSecondaryAttack() then
		mv:SetMaxSpeed(80)
		return true
	end
end