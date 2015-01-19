-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.Base = "weapon_zs_undead_base"

SWEP.PrintName = "Nerf"
if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
end

SWEP.ViewModel = Model("models/Weapons/v_fza.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Primary.Delay = 0.4
SWEP.Primary.Reach = 35
SWEP.Primary.Damage = 10
SWEP.Primary.Duration = 1


SWEP.Secondary.Damage = 10
SWEP.Secondary.PounceVelocity = 200
SWEP.Secondary.PounceReach = 35
SWEP.Secondary.PounceSize = 20

SWEP.SwapAnims = false
	
SWEP.WElements = {
--	["4"] = { type = "Model", model = "models/gibs/gunship_gibs_wing.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(5, 4.091, 3.181), angle = Angle(86.931, 7.158, 82.841), size = Vector(0.321, 0.321, 0.321), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	--["8"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_Spine4", rel = "7", pos = Vector(2.273, 0, 0), size = { x = 0.01, y = 0.01 }, color = Color(255, 255, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	--["1"] = { type = "Model", model = "models/gibs/gunship_gibs_midsection.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-6.818, 0.455, -0.456), angle = Angle(3.068, -25.569, 80.794), size = Vector(0.151, 0.151, 0.151), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	--["7"] = { type = "Model", model = "models/gibs/shield_scanner_gib1.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(0.455, 5, -1.364), angle = Angle(82.841, 84.886, 5.113), size = Vector(1.003, 1.003, 1.003), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	--["2"] = { type = "Model", model = "models/gibs/gunship_gibs_sensorarray.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-6.818, -0.456, 0), angle = Angle(0, 0, -95.114), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	--["3"] = { type = "Model", model = "models/gibs/gunship_gibs_wing.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(5, 4.091, -6.818), angle = Angle(86.931, 7.158, 82.841), size = Vector(0.321, 0.321, 0.321), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	
--["nerfhead3"] = { type = "Model", model = "models/gibs/gunship_gibs_engine.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.209, 0.209, 0.209), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
--["nerfhead"] = { type = "Model", model = "models/props_combine/tprotato1.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(4.091, 2.273, 0), angle = Angle(0, 0, 86.931), size = Vector(0.094, 0.094, 0.094), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
--["nerfhead2"] = { type = "Model", model = "models/props_combine/tprotato1_chunk01.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(8.635, -0.456, 0), angle = Angle(105.341, 88.976, 80.794), size = Vector(0.094, 0.094, 0.094), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }

	
	}
	


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
	local Velocity = self.Owner:GetAngles():Forward() * 900
	if Velocity.z < 200 then
		Velocity.z = 300
	end
	
	--Apply velocity and set leap status to true
	Owner:SetGroundEntity(NULL)
	Owner:SetLocalVelocity(Velocity)
	
	--Start leap
	self.Leaping = true
	
	--Leap cooldown
	self.NextLeap = CurTime() + 4
	
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