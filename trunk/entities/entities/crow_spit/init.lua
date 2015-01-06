-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	self.DieTime = CurTime() + 3

	local pl = self.Entity:GetOwner()
	-- local aimvec = pl.Crow:GetAngles():Forward()
	local aimvec = pl:GetAimVector()
	pl:DeleteOnRemove(self.Entity)
	self.Entity.Team = pl:Team()
	self.Entity:SetPos(pl:GetPos() + pl:GetAimVector() * 5)
	self.Entity:SetAngles(pl:GetAngles())
	self.Entity:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self.Entity:SetModel ("models/props/cs_italy/orange.mdl")
	self.Entity:PhysicsInitSphere (5)
	self.Entity:SetSolid (SOLID_VPHYSICS)
	self.Entity:SetTrigger(true)
	self.Entity:DrawShadow (false)
	local phys = self.Entity:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableDrag(false)
		phys:EnableMotion (true)
		phys:Wake()
		phys:ApplyForceCenter(aimvec * math.random(600,1000))
		phys:SetMass(2)
	end
	self.Touched = {}
	self.OriginalAngles = self.Entity:GetAngles()
end

function ENT:Think()
	if CurTime() > self.DieTime then
		self.Entity:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
	local hitent = data.HitEntity

	if hitent.SendLua then return end
	if hitent then
		local hitphys = hitent:GetPhysicsObject()
		if IsValid(hitphys) and hitphys:IsMoveable() then
			self.Entity:SetPos(data.HitPos)
			self.Entity:SetAngles(self.OriginalAngles)
			self.Entity:SetParent(hitent)
		end
		if hitent.SendLua and hitent:Team() ~= TEAM_UNDEAD then
			local owner = self:GetOwner()
			if owner and IsValid(owner) and owner:Team() == TEAM_UNDEAD then
				-- if hitent:Team() == TEAM_HUMAN and hitent:IsPlayer() then
					-- hitent:TakeDamage(1, owner)
				-- else
					-- hitent:TakeDamage(1, self)
				-- end
			end
		end
		
		local effectdata = EffectData()
			effectdata:SetOrigin (data.HitPos)
			effectdata:SetNormal (data.HitNormal)
		util.Effect ("crow_spit_effect", effectdata)
	end
	
	function self:PhysicsCollide() end
	function self:Touch() end
	self:Remove()
end

function ENT:Touch(ent)
	if ent.TakeDamage then
		local owner = self.Entity:GetOwner()
		if not (IsValid(owner) and owner:IsPlayer()) then return end
		if owner:Team() ~= self.Entity.Team then return end
		if owner == ent then return end
		-- Make a splashing sound
		sound.Play ("physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav",ent:GetPos(),80,math.random (80,100))
		self:Remove()
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
