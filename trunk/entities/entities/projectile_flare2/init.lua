AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.DieTime = CurTime() + 3

	if self.Entity:GetOwner():GetPerk("_pyro") then
		local mul = self.Entity:GetOwner():GetRank() * 0.01
		mul = mul + 0.05
		
		self.Damage = self.Damage*mul
	end
	
	self:SetModel("models/weapons/w_grenade.mdl")
	--self:SetModel("models/items/flare.mdl")	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMaterial("Models/effects/splodearc_sheet")
	
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
		local damage = 30	
		if HitEnt:IsPlayer() and HitEnt:Team() == TEAM_UNDEAD then	
			local ignite = 3 + (2 *(0.05 + self.Entity:GetOwner():GetRank()*0.01)) + (2*(self.Entity:GetOwner():GetRank()*0.01))

			local burn = 5 + (5 * (0.05 + (2*(self.Entity:GetOwner():GetRank()*0.01))))		
			local z = HitEnt
			z:TakeDamageOverTime(burn, 1, ignite, self.Entity:GetOwner(), self )
			z:Ignite(ignite,0)				
			--z.NoGib = CurTime() + 1
			z:TakeDamage(damage,self.Entity:GetOwner(),self)
			
			if self.Entity:GetOwner():GetPerk("_flarebounce") then
				if math.random(1,4) == 1 then
					self.Entity:Remove()
				end
			else
				self.Entity:Remove()		
			end
			
		elseif not HitEnt:IsPlayer() then
			HitEnt:TakeDamage((damage * 0.2) ,self.Entity:GetOwner(),self)
		end
	end
	
	self.CanHit = false
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
