-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

-- Models paths
SWEP.Author = "Deluvas"
SWEP.ViewModel = Model("models/weapons/cstrike/c_knife_t.mdl")
SWEP.UseHands = true
SWEP.WorldModel = Model("models/weapons/w_knife_t.mdl")

if CLIENT then
	killicon.AddFont("weapon_zs_melee_combatknife", "CSKillIcons", "j", Color(255, 255, 255, 255))
end

-- Name and fov
SWEP.PrintName = "Combat Knife"
SWEP.ViewModelFOV = 55
SWEP.ShowViewModel = true

-- Position
SWEP.Slot = 2
SWEP.SlotPos = 6

-- Damage, distane, delay

SWEP.Primary.Delay = 0.3
SWEP.SwingTime = 0
SWEP.HoldType = "knife"
SWEP.SwingTime = 0.1
SWEP.MeleeDamage = 24
SWEP.MeleeRange = 50
SWEP.MeleeSize = 1
SWEP.WalkSpeed = SPEED
SWEP.HitDecal = "ManhackCut"
SWEP.HumanClass = "berserker"
SWEP.NoHitSoundFlesh = true

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_bat.mdl", bone = "v_weapon.Knife_Handle", rel = "", pos = Vector(0, 0, -6.36), angle = Angle(0, 0, 0), size = Vector(0.5, 0.776, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

function SWEP:MeleeSwing()
	local owner = self.Owner

	--Viewpunch
	self.Owner:MeleeViewPunch(self.MeleeDamage*0.05)
	owner:SetAnimation(PLAYER_ATTACK1)
	local filter = owner:GetMeleeFilter()

	owner:LagCompensation(true)

	local tr = owner:MeleeTrace(self.MeleeRange, self.MeleeSize, filter)
	if tr.Hit then
		local damage = self.MeleeDamage
			self.Weapon:SendWeaponAnim(self.MissAnim)
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

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/knife/knife_slash"..math.random(1, 2)..".wav")
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/knife/knife_hitwall1.wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/knife/knife_hit"..math.random(1, 4)..".wav")
end

function SWEP:Precache()
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
end
