AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.DieTime = CurTime() + self.LifeTime

	self:SetModel("models/props_junk/garbage_plasticbottle003a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass(4)
		phys:SetMaterial("metal")
	end
end

function ENT:PhysicsCollide(data, phys)
	if 20 < data.Speed and 0.25 < data.DeltaTime then
		self:EmitSound("physics/glass/glass_sheet_impact_soft"..math.random(1,2)..".wav") --Lets make a nice bouncing noise!
	end
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

			util.BlastDamage2(self, owner, pos, 600, 100) --Need to make this resistant to props and humans. :L	
			--util.BlastDamageEx(self, owner, pos, 450, 100) --Need to make this resistant to props and humans. :L	
		
		local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		util.Effect("fire_nade", effectdata) --Chemical Explosion.
	end
end
