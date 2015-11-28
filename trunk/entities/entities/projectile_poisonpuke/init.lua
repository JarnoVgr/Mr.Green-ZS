AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	self.DieTime = CurTime() + 6

	self:DrawShadow(false)
	self:PhysicsInitSphere(1)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(4)
		phys:SetBuoyancyRatio(0.002)		
		phys:EnableMotion(true)
		phys:Wake()
	end
end

function ENT:Think()
	if self.DieTime < CurTime() then
		if self.HitData then
			local data = self.HitData

			local hitent = data.HitEntity
			if hitent and IsValid(hitent) then
				local owner = self:GetOwner()
				if IsValid(owner) then
					if hitent:IsPlayer() and hitent:IsHuman() and hitent:Alive() then
						if hitent:GetPerk("Medic") then
							hitent:TakeDamage(2, owner, self)							
						else
							hitent:TakeDamage(3, owner, self)
						end
					elseif hitent:IsPlayer() and hitent:IsZombie() and hitent:Alive() then
						if hitent:Health() + 5 < hitent:GetMaximumHealth() then
							owner:AddXP(3)
							hitent:SetHealth(hitent:Health() + 10)	
							owner.PoisonHeals = owner.PoisonHeal + 10
							local ph = owner.PoisonHeal
							if ph >= 500 then
								owner:UnlockAchievement("poisonheal")	
							end							
						end			
					end
				else
					if not (hitent:IsPlayer() and hitent:IsZombie() and hitent:Alive()) then
						hitent:TakeDamage(5, self, self)
					end
				end
			end

			self.HitData = nil
		end

		self:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
	if not self:HitFence(data, phys) then

	if self.HitData then return end
	
	self.HitData = data
	self.DieTime = 0

	local effectdata = EffectData()
		effectdata:SetOrigin(data.HitPos)
		effectdata:SetNormal(data.HitNormal)
	util.Effect("pukehit", effectdata)

	self:NextThink(CurTime())
	return true
	end
	return false
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
