-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.Base = "weapon_zs_undead_base"

SWEP.PrintName = "Fast Zombie"
if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
end

SWEP.ViewModel = Model("models/Weapons/v_fza.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Primary.Delay = 0.1
SWEP.Primary.Reach = 42
SWEP.Primary.Damage = 5
SWEP.Primary.Duration = 0.65


SWEP.Secondary.Damage = 4
SWEP.Secondary.PounceVelocity = 500
SWEP.Secondary.PounceReach = 32
SWEP.Secondary.PounceSize = 8

SWEP.SwapAnims = false


function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	--Attack sounds
	for i = 1, 11 do
		table.insert(self.AttackSounds,Sound("mrgreen/undead/fastzombie/attack"..i..".wav"))
	end

	--Idle sounds
	for i = 1, 12 do
		table.insert(self.IdleSounds,Sound("mrgreen/undead/fastzombie/idle"..i..".wav"))
	end
end

function SWEP:Think()
	self.BaseClass.Think(self)

	--Leaping
	if self.Leaping then
		self.Owner:LagCompensation(true)

		local traces = self.Owner:PenetratingMeleeTrace(self.Secondary.PounceReach, self.Secondary.PounceSize, nil, self.Owner:LocalToWorld(self.Owner:OBBCenter()))

		local hit = false
		for _, trace in ipairs(traces) do
			if not trace.Hit then
				continue
			end

			hit = true

			if not trace.HitWorld then
				local ent = trace.Entity
				if not ent or not ent:IsValid() then
					continue
				end

				--Break glass
				if ent:GetClass() == "func_breakable_surf" then
					ent:Fire( "break", "", 0 )
					hit = true
				end

				--Check for valid phys object
				local phys = ent:GetPhysicsObject()
				if not phys:IsValid() or not phys:IsMoveable() or ent.Nails then
					continue
				end

				if ent:IsPlayer() or ent:IsNPC() then
					ent:SetVelocity(self.Owner:GetForward() * self.Secondary.PounceVelocity)
				else
					--Calculate velocity to push
					local Velocity = self.Owner:EyeAngles():Forward() * (self.Secondary.PounceVelocity * 3)
					Velocity.z = math.min(Velocity.z,1600)

					--Apply push
					phys:ApplyForceCenter(Velocity)
					ent:SetPhysicsAttacker(self.Owner)					
				end
				
				--Take damage
				ent:TakeDamage(self.Secondary.Damage, self.Owner, self)
			end
		end

		if hit then
			if self.Owner.ViewPunch then
				self.Owner:ViewPunch(Angle(math.random(0, 70), math.random(0, 70), math.random(0, 70)))
			end

			if SERVER then
				self.Owner:EmitSound(Sound("physics/flesh/flesh_strider_impact_bullet1.wav"))
				self.Owner:EmitSound(Sound("mrgreen/undead/fastzombie/pain1.wav"))
			end
						
			--Stopped leaping
			self.Leaping = false
			
			--Stop, so we don't bounce around
			self.Owner:SetLocalVelocity(Vector(0, 0, 0))
			
			--Leap Cooldown
			self.NextLeap = CurTime() + 3
		end
		
		--Always update leap status
		if (self.Owner:OnGround() or self.Owner:WaterLevel() >= 2) then
			self.Leaping = false
		end

		self.Owner:LagCompensation(false)
	end
end

function SWEP:Move(mv)
	if self and self.Owner and self.Owner:KeyDown(IN_ATTACK) then
		mv:SetMaxSpeed(self.Owner:GetMaxSpeed()*0.35)
		return true
	end
end

SWEP.NextAttack = 0
function SWEP:PrimaryAttack()
	if self.Leaping then
		return
	end

	self.BaseClass.PrimaryAttack(self)
end

function SWEP:StartPrimaryAttack()			
	--Hacky way for the animations
	if self.SwapAnims then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims
	
	--Set the thirdperson animation and emit zombie attack sound
	self.Owner:DoAnimationEvent(CUSTOM_PRIMARY)
  
  	--Emit sound
	if SERVER and #self.AttackSounds > 0 then
		self.Owner:EmitSound(Sound(self.AttackSounds[math.random(#self.AttackSounds)]))
	end
end

function SWEP:PostPerformPrimaryAttack(hit)
	if CLIENT then
		return
	end

	if hit then
		self.Owner:EmitSound(Sound("npc/zombiegreen/hit_punch_0".. math.random(1, 8) ..".wav"))
	else
		self.Owner:EmitSound(Sound("npc/zombiegreen/claw_miss_"..math.random(1, 2)..".wav"))
	end
end

SWEP.NextLeap = 0
function SWEP:SecondaryAttack()
	if self:IsInPrimaryAttack() then
		return
	end

	local Owner = self.Owner
	
	-- See where the player is ( on ground or flying )
	local bOnGround, bCrouching = Owner:OnGround(), Owner:Crouching()
	
	-- Trace filtering climb factors
	local vStart, vAimVector = Owner:GetShootPos() - Vector ( 0,0,20 ), Owner:GetAimVector()
	local trClimb = util.TraceLine( { start = vStart, endpos = vStart + ( vAimVector * 35 ), filter = Owner } )
		
	if trClimb.HitWorld then
		return
	end
	
	--Leap cooldown / player flying
	if CurTime() < self.NextLeap or not bOnGround or self.Leaping then
		return
	end
	
	--Set flying velocity
	local Velocity = self.Owner:GetAngles():Forward() * 800
	if Velocity.z < 200 then
		Velocity.z = 200
	end
	
	--Apply velocity and set leap status to true
	Owner:SetGroundEntity(NULL)
	Owner:SetLocalVelocity(Velocity)
	
	--Start leap
	self.Leaping = true
	
	--Leap cooldown
	self.NextLeap = CurTime() + 1.3
	
	--Fast zombie scream
	if SERVER then
		Owner:EmitSound(Sound("mrgreen/undead/fastzombie/leap".. math.random(1,5) ..".wav"))
	end
end

-- Shutup.
function SWEP:Precache()
	util.PrecacheSound("mrgreen/undead/fastzombie/leap1.wav")
	util.PrecacheSound("mrgreen/undead/fastzombie/leap2.wav")
	util.PrecacheSound("mrgreen/undead/fastzombie/leap3.wav")
	util.PrecacheSound("mrgreen/undead/fastzombie/leap4.wav")
	util.PrecacheSound("physics/flesh/flesh_strider_impact_bullet1.wav")

	-- Quick way to precache all sounds
	--for _, snd in pairs(ZombieClasses[2].PainSounds) do
	for _, snd in pairs(ZombieClasses[3].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	--for _, snd in pairs(ZombieClasses[2].DeathSounds) do
	for _, snd in pairs(ZombieClasses[3].DeathSounds) do
		util.PrecacheSound(snd)
	end
end