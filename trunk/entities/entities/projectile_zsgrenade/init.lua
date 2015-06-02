AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.DieTime = CurTime() + self.LifeTime

	self:SetModel("models/weapons/w_grenade.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass(20)
		phys:SetMaterial("metal")
	end
end

function ENT:PhysicsCollide(data, phys)
	if 20 < data.Speed and 0.25 < data.DeltaTime then
		self:EmitSound("physics/metal/metal_grenade_impact_hard"..math.random(1,3)..".wav")
	end
	self:SetVelocity(Vector(0,0,0))
end

function ENT:Think()
	if self.Exploded then
		self:Remove()
	elseif self.DieTime <= CurTime() then
		self:Explode()
	end
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local owner = self:GetOwner()
	if owner:IsValid() and owner:IsPlayer() and owner:Team() == TEAM_HUMAN then
		local pos = self:GetPos()
	
		util.BlastDamage2(self, owner, pos, 250, 300)
	
		if owner.DataTable["ShopItems"][52] and owner.GetPerk("_commando") then
			util.BlastDamage2(self, owner, pos, 250, 300 * 1.5)
		end
		
		if owner:GetPerk("_nade") then
			util.BlastDamage2(self, owner, pos, 340, 300 * 1.25)
			if owner.DataTable["ShopItems"][52] and owner.GetPerk("_commando") then
				util.BlastDamage2(self, owner, pos, 290, 300 * 1.75)
			end			
		end			
	

		local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		util.Effect("Explosion", effectdata)
	end
end
