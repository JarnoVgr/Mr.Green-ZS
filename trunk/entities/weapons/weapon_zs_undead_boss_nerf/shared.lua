-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()



SWEP.PrintName = "Nerf"
if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	
	
SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 75.605, 0) },
	["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 49.916, 0) },
	["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 20.795, 0) },
	["ValveBiped.Bip01_R_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 52.007, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(-0.923, 0, -0.608), angle = Angle(-16.098, -16.886, 3.661) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.409, 0), angle = Angle(-13.473, 4.796, -47.446) },
	["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 99.51, 0) },
	["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 18.854, 0) },
	["ValveBiped.Bip01_R_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 75.922, 0) },
	["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 40.652, 0) },
	["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 29.76, 0) },
	["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 73.269, 0) },
	["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 61.735, 0) },
	["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.185, 1.73, 41.8) },
	["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 74.68, 0) },
	["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 22.555, 0) },
	["ValveBiped.Bip01_R_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 48.576, 0) },
	["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -6.368, 0) },
	["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 54.191, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 38.962, 0) },
	["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 44.536, 0) }
}		

	
function SWEP:DrawWorldModel()
		self:SetMaterial("models/flesh")
		self:DrawModel()
	end	
	
end

SWEP.Base = "weapon_zs_undead_base"

SWEP.ViewModel = Model("models/Weapons/v_fza.mdl")
--SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")
SWEP.WorldModel = Model("models/weapons/w_grenade.mdl")

SWEP.Primary.Delay = 0.4
SWEP.Primary.Reach = 35
SWEP.Primary.Damage = 10
SWEP.Primary.Duration = 1


SWEP.Secondary.Damage = 5
SWEP.Secondary.PounceVelocity = 200
SWEP.Secondary.PounceReach = 35
SWEP.Secondary.PounceSize = 20

SWEP.SwapAnims = false


function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	--Attack sounds
	for i = 1, 1 do
		table.insert(self.AttackSounds,Sound("npc/antlion/attack_double1.wav"))
	end

	
	
	--Idle sounds
	for i = 1, 1 do
		table.insert(self.IdleSounds,Sound("npc/antlion_guard/growl_idle.wav"))
	end
	
	--self.IdleSounds,Sound("npc/antlion_guard/growl_idle.wav")
	
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
					Velocity.z = math.min(Velocity.z,400)

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
			self.NextLeap = CurTime() + 2
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
	self.NextLeap = CurTime() + 2
	
	--Fast zombie scream
	if SERVER then
		--Owner:EmitSound(Sound("mrgreen/undead/fastzombie/leap".. math.random(1,5) ..".wav"))
		Owner:EmitSound(Sound("npc/antlion_guard/angry".. math.random(1,3) ..".wav"))
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
	for _, snd in pairs(ZombieClasses[2].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[2].DeathSounds) do
		util.PrecacheSound(snd)
	end
end


if CLIENT then
	function SWEP:DrawHUD()
		if not self.Owner:Alive() or ENDROUND then
			return
		end
		MeleeWeaponDrawHUD()
	end
end