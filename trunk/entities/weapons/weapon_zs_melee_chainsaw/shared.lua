-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

-- Melee base
SWEP.Base = "weapon_zs_melee_base"
SWEP.HitDecal = "ManhackCut"
-- Model paths
SWEP.Author = "Duby"

SWEP.UseHands = true

function SWEP:StartSwinging()
	if self.StartSwingAnimation then
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
	self:PlayStartSwingSound()
	
	local swingtime = self.SwingTime
	self:SetSwingEnd(CurTime() + swingtime)
end

if CLIENT then
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
	
	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(-0.704, 3.443, -0.055), angle = Angle(-6.298, 3.278, -7.829) },
		["Base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.VElements = {
		["Chainsaw"] = { type = "Model", model = "models/weapons/w_chainsaw.mdl", bone = "Base", rel = "", pos = Vector(6.877, 9.47, -13.148), angle = Angle(-2.674, -10.464, -106.545), size = Vector(1.157, 1.157, 1.157), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
end

SWEP.ViewModel = "models/weapons/c_physcannon.mdl"
SWEP.WorldModel = "models/weapons/w_chainsaw.mdl"

-- Name and fov
SWEP.HoldType = "physgun"
SWEP.PrintName = "Chainsaw"

SWEP.DeploySpeed = 0.8
-- Slot pos
SWEP.Slot = 2
SWEP.SlotPos = 8
SWEP.HumanClass = "berserker"
SWEP.Primary.Automatic	= true
SWEP.MeleeDamage = 18
SWEP.MeleeRange = 51
SWEP.MeleeSize = 0.5
SWEP.Primary.Delay = 0.1
SWEP.MeleeKnockBack = SWEP.MeleeDamage * 0.5
SWEP.WalkSpeed = SPEED_MELEE_HEAVY
SWEP.SwingHoldType = "physgun"
SWEP.SwingTime = 0.1
SWEP.SwingRotation = Angle(4, 0, 0)
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/knife/knife_slash"..math.random(1, 2)..".wav", 85, math.random(80,90))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/knife/knife_hitwall1.wav", 85, math.random(80,90))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/knife/knife_hit"..math.random(1, 4)..".wav", 85, math.random(110,115))
end

function SWEP:OnDeploy()
	if SERVER then
		self.ChainSound = CreateSound( self.Owner, "weapons/melee/chainsaw_idle.wav" ) 	
		self.DeployTime = CurTime() + 3.1
		if not self.Deployed then
			self.Owner:EmitSound("weapons/melee/chainsaw_start_0"..math.random(1,2)..".wav")
			self.Deployed = true
		end
	end
	
end

function SWEP:MeleeSwing()
	local owner = self.Owner
	--Viewpunch
	self.Owner:MeleeViewPunch(self.MeleeDamage*0.05)
	local filter = owner:GetMeleeFilter()

	owner:LagCompensation(true)

	local tr = owner:MeleeTrace(self.MeleeRange, self.MeleeSize, filter)
	if tr.Hit then
		local damage = self.MeleeDamage

		local hitent = tr.Entity
		local hitflesh = tr.MatType == MAT_FLESH or tr.MatType == MAT_BLOODYFLESH or tr.MatType == MAT_ANTLION or tr.MatType == MAT_ALIENFLESH
		
		if self.HitAnim then
			self.Weapon:SendWeaponAnim(self.HitAnim)
		end
		self.IdleAnimation = CurTime() + self:SequenceDuration()*2

		if hitflesh then
			util.Decal(self.BloodDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)

			self:PlayHitFleshSound()

			if SERVER and not (hitent:IsValid() and hitent:IsPlayer() and hitent:Team() == owner:Team()) then
				util.Blood(tr.HitPos, math.Rand(damage * 0.05, damage * 0.1), (tr.HitPos - owner:GetShootPos()):GetNormal(), math.Rand(damage * 3, damage * 6), true)
			end

		else
			self:PlayHitSound()	
			util.Decal(self.HitDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		end
		
		if self.OnMeleeHit and self:OnMeleeHit(hitent, hitflesh, tr) then
			owner:LagCompensation(false)
			return
		end

		if SERVER and hitent:IsValid() then
			if hitent:GetClass() == "func_breakable_surf" then
				hitent:Fire("break", "", 0)
			else
				local dmginfo = DamageInfo()
				dmginfo:SetDamagePosition(tr.HitPos)
				dmginfo:SetDamage(damage)
				dmginfo:SetAttacker(owner)
				dmginfo:SetInflictor(self.Weapon)
				--dmginfo:SetDamageType(DMG_BULLET)
				dmginfo:SetDamageType(self.DamageType)
				dmginfo:SetDamageForce(self.MeleeDamage * 20 * owner:GetAimVector())
	
				hitent:TakeDamageInfo(dmginfo)				
				local phys = hitent:GetPhysicsObject()
				if hitent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
					hitent:SetPhysicsAttacker(owner)
				end
			end
		end

		if self.PostOnMeleeHit then self:PostOnMeleeHit(hitent, hitflesh, tr) end

		if CLIENT then
			local tr2 = owner:DoubleTrace(self.MeleeRange, MASK_SHOT, self.MeleeSize, filter)
			if tr2.HitPos == tr.HitPos then
				owner:FireBullets({Num = 1, Src = owner:GetShootPos(), Dir = (tr2.HitPos - owner:GetShootPos()):GetNormal(), Spread = Vector(0, 0, 0), Tracer = 0, Force = self.MeleeDamage * 200, Damage = damage, HullSize = self.MeleeSize * 2})
			end
		end
	else
		if self.MissAnim then
			self.Weapon:SendWeaponAnim(self.MissAnim)
		end
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		self:PlaySwingSound()

		if self.PostOnMeleeMiss then self:PostOnMeleeMiss(tr) end
	end

	owner:LagCompensation(false)
end



function SWEP:_OnRemove() --Cheers Necro, this code is from the hate swep
	if SERVER then
		if self.Owner and self.Owner:IsValid() then
			self.Owner:EmitSound("weapons/melee/chainsaw_die_01.wav")
		end
		self.ChainSound:Stop()
	end
end 