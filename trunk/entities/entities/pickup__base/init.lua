AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	
	self.Entity:PhysicsInit(SOLID_VPHYSICS )
	--self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	--self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
			
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion( true ) 
	end

	self:OnInitialize()
	
end

function ENT:OnInitialize()

end

function ENT:Think()
end

function ENT:PhysicsCollide(data, physobj)
end

function ENT:Touch(ent)
end

function ENT:OnRemove()
end

function ENT:SetUse()
	
end

function ENT:OnTakeDamage( dmginfo )
	if !self.AllowDamage then return end
	
	local dmg = dmginfo:GetDamage()
	
	self:_SetHealth(self:_GetHealth() - dmg)
	
	if self:_GetHealth() <=0 then
		self:OnZeroHealth(dmginfo)
	end
	
end

function ENT:OnZeroHealth(dmginfo)

end

function ENT:Use(a,c)
	if IsValid(a) and a:IsPlayer() and a:IsHuman() then
		self.Activator = a
		self:SetUse()
	end
	
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
