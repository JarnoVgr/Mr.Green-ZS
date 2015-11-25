AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.DieTime = CurTime() + 4
	
	self:SetModel("models/mechanics/various/211.mdl")
	--self:SetModel("models/items/flare.mdl")	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	--self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetMaterial("models/shiny")
	self:SetColor(255,0,0)
	self.CanHit = true
	
	--self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass(1)
		phys:SetMaterial("metal")
	end
end

function ENT:HumanHoldable(pl)
	return true
end

function ENT:Think()
	if self.DieTime < CurTime() then
		self.Entity:Remove()
	end
	
		-- In case the owner dies
	local Owner = self:GetOwner()
	if not IsValid ( Owner ) or not Owner:Alive() or Owner:Team() == TEAM_UNDEAD then 
		self.Entity:Remove()
	end
end

function ENT:PhysicsCollide( Data, Phys ) 
	
	local HitEnt = Data.HitEntity
	if self.CanHit and IsValid( HitEnt) then
		local damage = 35
		if HitEnt:IsPlayer() and HitEnt:Team() == TEAM_UNDEAD then	
			if self.Entity:GetOwner():GetPerk("pyro_flare") then
				damage = damage + 10
				if math.random(1,4) == 1 then
					self.CanHit = false
				end
			else
				self.CanHit = false				
			end
			HitEnt:Ignite(3);
			HitEnt:TakeDamage(damage,self.Entity:GetOwner(),self)			
		elseif not HitEnt:IsPlayer() then
			HitEnt:TakeDamage((damage * 0.2) ,self.Entity:GetOwner(),self)

		end
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
