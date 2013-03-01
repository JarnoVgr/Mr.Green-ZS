-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local math = math
local util = util

function ENT:Initialize()
	self.DieTime = CurTime() + math.Rand( 20, 35 )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS ) -- For the time being to see how it behaves
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:SetTrigger( true )
	self.Touched = false

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:ApplyForceCenter( VectorRand() * math.Rand(2000, 5000) )
	end
end

function ENT:Think()
	if CurTime() > self.DieTime then
		self:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
	if self.Entity.IsHead == true then
		util.Decal("Impact.Flesh",data.HitPos - data.HitNormal,data.HitPos + data.HitNormal);
	end
end

function ENT:Touch(ent)
	if not self.Touched and self.IsHead then
		self:EmitSound( "physics/flesh/flesh_squishy_impact_hard"..math.random(1, 4)..".wav" )
		self.Touched = true
	end
end

function ENT:StartTouch ( ent )
	if ent:IsPlayer() and ent != self:GetOwner() and ent:Alive() and ent:Team() == TEAM_UNDEAD then
		if not (ent:IsZombine() and ent.bCanSprint) then
		local MaxHealth = ent:GetMaximumHealth()
		if ent:Health() < MaxHealth then
			local maxhealth = MaxHealth
			local multiplier = 0.1
			if ent:HasBought("fleshfreak") then
				multiplier = 0.15
			end
			if not ent:IsBossZombie() then
				ent:SetHealth(math.min(maxhealth, ent:Health() + maxhealth * multiplier))
			end
			
			self:EmitSound( "physics/body/body_medium_break"..math.random(2, 4)..".wav" )
			
			self.DieTime = -10
			function self:StartTouch() end
		end
		end
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
