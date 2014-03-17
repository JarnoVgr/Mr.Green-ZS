-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.PrintName = "Klinanator"

if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = false
	SWEP.FakeArms = true

	SWEP.WElements = {
		["bone1+"] = { type = "Model", model = "models/props_junk/vet001_chunk6.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(3.127, 5.98, 4.98), angle = Angle(78.624, 121.805, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bone1"] = { type = "Model", model = "models/props_junk/vet001_chunk6.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(3.489, 6.668, -4.731), angle = Angle(109.05, 121.805, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["plank"] = { type = "Model", model = "models/Weapons/w_plank.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.857, 0.418, 1.325), angle = Angle(0, -107.212, -97.001), size = Vector(1, 1.715, 1.763), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["plank"] = { type = "Model", model = "models/Weapons/w_plank.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.95, 0.418, 1.5), angle = Angle(0, -107.212, -97.001), size = Vector(1, 1.715, 1.763), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["RightArm1"] = { type = "Model", model = "models/gibs/antlion_gib_small_1.mdl", bone = "ValveBiped.Bip01_R_UpperArm", rel = "", pos = Vector(7.727, 0.455, 0), angle = Angle(180, 0, 0), size = Vector(1.401, 1.401, 1.401), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["RightArm2"] = { type = "Model", model = "models/gibs/antlion_gib_small_1.mdl", bone = "ValveBiped.Bip01_L_UpperArm", rel = "", pos = Vector(7.727, 0.455, 0), angle = Angle(180, 0, 0), size = Vector(1.401, 1.401, 1.401), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["head"] = { type = "Model", model = "models/gibs/shield_scanner_gib6.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(19.545, 0, 0), angle = Angle(0, 0, 0), size = Vector(1.003, 1.003, 1.003), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Hand1"] = { type = "Model", model = "models/gibs/shield_scanner_gib4.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.456, -0.456, -2.274), angle = Angle(43.977, 0, 0), size = Vector(0.889, 0.889, 0.889), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Hand2"] = { type = "Model", model = "models/gibs/shield_scanner_gib4.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-0.456, -0.456, -2.274), angle = Angle(43.977, 0, 0), size = Vector(0.889, 0.889, 0.889), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["UpperArm"] = { type = "Model", model = "models/gibs/strider_gib7.mdl", bone = "ValveBiped.Bip01_R_UpperArm", rel = "", pos = Vector(5, -0.456, -5.909), angle = Angle(0, 0, 0), size = Vector(0.151, 0.151, 0.151), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["UpperArm2"] = { type = "Model", model = "models/gibs/strider_gib7.mdl", bone = "ValveBiped.Bip01_L_UpperArm", rel = "", pos = Vector(5, -0.456, -5.909), angle = Angle(0, 0, 0), size = Vector(0.151, 0.151, 0.151), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	}
end

SWEP.Base = "weapon_zs_undead_base"

SWEP.ViewModel = Model("models/weapons/v_zombiearms.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Primary.Reach = 80
SWEP.Primary.Duration = 2.3
SWEP.Primary.Delay = 0.7
SWEP.Primary.Damage = math.random(40,55)

SWEP.Secondary.Delay = 0
SWEP.Secondary.Next = 4
SWEP.Secondary.Duration = 1.3
SWEP.Secondary.Reach = 400

function SWEP:StartPrimaryAttack()
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	local pl = self.Owner

	--Set the thirdperson animation and emit zombie attack sound
	pl:DoAnimationEvent(CUSTOM_PRIMARY)	

	if CLIENT then
		return
	end	

	--[[
	--Slowdown
	GAMEMODE:SetPlayerSpeed(pl, 200, 200)
	
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
	end)]]
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
			pl:EmitSound(Sound("player/zombies/k/smash.wav"),math.random(100,130),math.random(95,100))
			util.Blood(trace.HitPos, math.Rand(self.Primary.Damage * 0.25, self.Primary.Damage * 0.6), (trace.HitPos - self.Owner:GetShootPos()):GetNormal(), math.Rand(self.Primary.Damage * 6, self.Primary.Damage * 12), true)
		else
			pl:EmitSound(Sound("player/zombies/k/hitwall.wav"),math.random(100,130),math.random(95,100))
		end
	else
		self.Owner:EmitSound(Sound("player/zombies/k/swing.wav"),math.random(100,130),math.random(95,100))
	end
end


function SWEP:PerformSecondaryAttack()
	-- Get owner
	local mOwner = self.Owner
	if not ValidEntity(mOwner) then
		return
	end
			   
	--Thirdperson animation and sound
	mOwner:DoAnimationEvent(CUSTOM_PRIMARY)
					   
	--Just server from here
	if CLIENT then
		return
	end
	
	
	for k,v in ipairs(team.GetPlayers(TEAM_HUMAN)) do
		local fDistance = v:GetPos():Distance( self.Owner:GetPos() )

		--Check for conditions
		if not v:IsPlayer() or not v:IsHuman() or not v:Alive() or fDistance > self.Primary.Reach then
			continue
		end
 
		local vPos, vEnd = mOwner:GetShootPos(), mOwner:GetShootPos() + ( mOwner:GetAimVector() * self.Primary.Reach )
		local Trace = util.TraceLine ( { start = vPos, endpos = v:LocalToWorld( v:OBBCenter() ), filter = mOwner, mask = MASK_SOLID } )
					   
		-- Exploit trace
		if not Trace.Hit or not ValidEntity(Trace.Entity) or Trace.Entity ~= v then
			continue
		end
			   
		--Calculate percentage of being hit
		local fHitPercentage = math.Clamp(1 - (fDistance / self.Primary.Reach), 0, 1)
																													   
		--Inflict damage
		local fDamage = math.Round(15 * fHitPercentage, 0, 10)
		if fDamage > 0 then
			v:TakeDamage(fDamage, self.Owner, self)
		end
		
		--Set last Howler scream
		v.lastHowlerScream = CurTime()
 
		--Shakey shakey
		local fFuckIntensity = fHitPercentage + 1
		GAMEMODE:OnPlayerHowlered(v, fFuckIntensity)
 
		-- Calculate base velocity
		local Velocity = -1 * mOwner:GetForward() * 225
		if not bPull then
			Velocity = -1 * Velocity * 2
		end
			   
		--
		Velocity.x, Velocity.y, Velocity.z = Velocity.x * 0.5, Velocity.y * 0.5, math.random(320, 232)
		if not bPull then
			Velocity = Vector(Velocity.x * 0.4, Velocity.y * 0.4, Velocity.z)
		end
 
		--Apply velocity               
		v:SetVelocity(Velocity)
							   
		-- Play sound
		timer.Simple(0.2, function()
			if IsValid(v) then
				WorldSound("npc/barnacle/barnacle_bark1.wav", v:GetPos() + Vector(0, 0, 20), 120, math.random(60, 75))
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