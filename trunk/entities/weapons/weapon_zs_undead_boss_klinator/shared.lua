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
		
		["RightArm1"] = { type = "Model", model = "models/gibs/antlion_gib_small_1.mdl", bone = "ValveBiped.Bip01_R_UpperArm", rel = "", pos = Vector(7.727, 0.455, 0), angle = Angle(180, 0, 0), size = Vector(1.401, 1.401, 1.401), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["RightArm2"] = { type = "Model", model = "models/gibs/antlion_gib_small_1.mdl", bone = "ValveBiped.Bip01_L_UpperArm", rel = "", pos = Vector(7.727, 0.455, 0), angle = Angle(180, 0, 0), size = Vector(1.401, 1.401, 1.401), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["head"] = { type = "Model", model = "models/gibs/shield_scanner_gib6.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(19.545, 0, 0), angle = Angle(0, 0, 0), size = Vector(1.003, 1.003, 1.003), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Hand1"] = { type = "Model", model = "models/gibs/shield_scanner_gib4.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.456, -0.456, -2.274), angle = Angle(43.977, 0, 0), size = Vector(0.889, 0.889, 0.889), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Hand2"] = { type = "Model", model = "models/gibs/shield_scanner_gib4.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-0.456, -0.456, -2.274), angle = Angle(43.977, 0, 0), size = Vector(0.889, 0.889, 0.889), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["UpperArm"] = { type = "Model", model = "models/gibs/strider_gib7.mdl", bone = "ValveBiped.Bip01_R_UpperArm", rel = "", pos = Vector(5, -0.456, -5.909), angle = Angle(0, 0, 0), size = Vector(0.151, 0.151, 0.151), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["UpperArm2"] = { type = "Model", model = "models/gibs/strider_gib7.mdl", bone = "ValveBiped.Bip01_L_UpperArm", rel = "", pos = Vector(5, -0.456, -5.909), angle = Angle(0, 0, 0), size = Vector(0.151, 0.151, 0.151), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },

	["1"] = { type = "Model", model = "models/gibs/strider_gib6.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.519, -0.519, 0), angle = Angle(0, 0, 97.013), size = Vector(0.432, 0.432, 0.432), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["3"] = { type = "Model", model = "models/gibs/gunship_gibs_headsection.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-7.792, 2.596, 0), angle = Angle(0, -24.546, 82.986), size = Vector(0.237, 0.237, 0.237), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },

["eye1"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(4.406, 2.168, 1.33), size = { x = 13, y = 13 }, color = Color(255, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
["eye1+"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(4.406, -2.438, 1.33), size = { x = 13, y = 13 }, color = Color(255, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["gun1"] = { type = "Model", model = "models/gibs/antlion_gib_large_3.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.518, 0, -0.519), angle = Angle(80.649, 180, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["gun2"] = { type = "Model", model = "models/gibs/antlion_gib_medium_3.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-5.715, -2.597, -0.519), angle = Angle(180, -111.04, 22.208), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },



	}
	
	SWEP.VElements = {
		["plank"] = { type = "Model", model = "models/weapons/v_plank.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-27.084, -15.171, -11.478), angle = Angle(-1.976, 0, -98.67), size = Vector(0.55, 0.55, 0.55), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["plank"] = { type = "Model", model = "models/weapons/v_plank.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-27.084, -15.171, -11.478), angle = Angle(-1.976, 0, -98.67), size = Vector(0.55, 0.55, 0.55), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },	
		["screen"] = { type = "Model", model = "models/gibs/strider_gib3.mdl", bone = "ValveBiped.Bip01", rel = "", pos = Vector(-19.546, -24.091, -2.274), angle = Angle(-180, -5.114, 50.113), size = Vector(0.435, 0.435, 0.435), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hand"] = { type = "Model", model = "models/gibs/shield_scanner_gib6.mdl", bone = "ValveBiped.Bip01", rel = "", pos = Vector(-13.183, -14.091, 24.09), angle = Angle(0, 0, 0), size = Vector(2.025, 2.025, 2.025), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	
	
	}

	
end

SWEP.Base = "weapon_zs_undead_base"

--SWEP.ViewModel = Model("models/weapons/v_zombiearms.mdl")
SWEP.ViewModel = Model("models/weapons/v_plank/v_plank.mdl")

SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Primary.Reach = 20
SWEP.Primary.Duration = 2.3
SWEP.Primary.Delay = 2.1
--SWEP.Primary.Damage = math.random(40,55)


SWEP.Primary.ClipSize = 0                        
SWEP.Primary.Ammo = "ar2"  
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 10

SWEP.Secondary.Delay = 0
SWEP.Secondary.Next = 4
SWEP.Secondary.Duration = 1.3
SWEP.Secondary.Reach = 400

function SWEP:StartPrimaryAttack()
	--self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	--self.IdleAnimation = CurTime() + self:SequenceDuration()

--	local pl = self.Owner

	--Set the thirdperson animation and emit zombie attack sound
--	pl:DoAnimationEvent(CUSTOM_PRIMARY)	

	if CLIENT then
		return
	end	

	local bullet = {}
		bullet.Num = 1
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Spread = Vector(0,0,0)
		bullet.Tracer = 1
		bullet.Force = 800
		bullet.Damage = 1.2
	self:ShootEffects()
	self.Owner:FireBullets( bullet )
	self.Weapon:EmitSound(Sound("player/zombies/seeker/pain2.wav"))
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	
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

	self.Owner:EmitSound(Sound("player/zombies/seeker/pain2.wav"),math.random(100,130),math.random(95,100))
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
			pl:EmitSound(Sound("player/zombies/seeker/pain2.wav"),math.random(100,130),math.random(95,100))
		end
	else
		self.Owner:EmitSound(Sound("player/zombies/seeker/pain1.wav"),math.random(100,130),math.random(95,100))
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
		local fDamage = math.Round(20 * fHitPercentage, 0, 10)
		if fDamage > 0 then
			v:TakeDamage(fDamage, self.Owner, self)
		end
		
		--Set last Howler scream
		v.lastHowlerScream = CurTime()
 
		--Shakey shakey
		local fFuckIntensity = fHitPercentage + 2
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
				WorldSound("player/zombies/seeker/screamclose.wav", v:GetPos() + Vector(0, 0, 20), 120, math.random(60, 75))
			end
		end)
	end
	   
	--On trigger play sound
	local iRandom = math.Rand(1, 2.5)
	if iRandom <= 1.5 then
		self.Owner:EmitSound("player/zombies/seeker/screamclose.wav")
	end
	   
	--Scream effect for myself
	self.Owner:SendLua("WraithScream()")
end