AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.DieTime = CurTime() + 0.8

	self:SetModel("models/weapons/w_grenade.mdl")
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
	
	if self.CanHit then
		if IsValid( HitEnt ) and ( HitEnt:IsPlayer() ) and ( HitEnt:IsZombie() ) then
			
			local z = HitEnt
			
			z.NoGib = CurTime() + 1
			
			z:TakeDamage(math.random(65,75),self.Entity:GetOwner(),self)
			self:EmitSound("Weapon_FlareGun.Single")
			
			z.DiedFromFlare = CurTime() + 1
			
			self.Entity:GetOwner():UnlockAchievement( "flare2" )
		end
	end
	
	self.CanHit = false
	
	
	

end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
