-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

ENT.Type = "anim"
ENT.PrintName = "Snowball"
ENT.Author = "NECROSSIN"

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile( "shared.lua" )
end

function ENT:Initialize()
	if CLIENT then return end
	
	self.Entity:SetModel("models/weapons/w_snowball_thrown.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(1)
		phys:Wake()
	end	
end

function ENT:PhysicsCollide ( data, physobj )
	if CLIENT then return end
	
	-- Hit player
	if data.HitEntity and data.HitEntity:IsValid() and data.HitEntity:IsPlayer() and data.HitEntity ~= self.Entity:GetOwner() then
		self.Entity:EmitSound("player/footsteps/snow"..math.random(1,6)..".wav")
			
		local pl = data.HitEntity
		pl:EmitSound( "physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav" )
		
		data.HitEntity:ViewPunch( Angle(math.random(-1, 1), math.random(-1, 1), math.random(-10, 10) ) )
			
		local Pos1 = data.HitPos + data.HitNormal
		local Pos2 = data.HitPos - data.HitNormal
		util.Decal("PaintSplatBlue", Pos1, Pos2) 
		self.Entity:EmitSound( "physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav" )
		self.Entity:Remove()
		
	-- if it is an entity (not a player)	
	elseif data.HitEntity and data.HitEntity:IsValid() and not data.HitEntity:IsPlayer() then
		
		local Pos1 = data.HitPos + data.HitNormal
		local Pos2 = data.HitPos - data.HitNormal
		util.Decal("PaintSplatBlue", Pos1, Pos2) 
		self.Entity:EmitSound("player/footsteps/snow"..math.random(1,6)..".wav")
		self.Entity:EmitSound( "physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav" )
		self.Entity:Remove()
	-- if its a world	
	else
		local Pos1 = data.HitPos + data.HitNormal
		local Pos2 = data.HitPos - data.HitNormal
		util.Decal("PaintSplatBlue", Pos1, Pos2) 
		self.Entity:EmitSound( "player/footsteps/snow"..math.random(1,6)..".wav" )
		self.Entity:EmitSound( "physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav" )
		self.Entity:Remove()
	end
end

if CLIENT then
	function ENT:Draw()
		self.Entity:DrawModel()
		
		--cool snow effect :p
		local Emitter = ParticleEmitter(self.Entity:GetPos())

		if self.Entity:GetVelocity():Length() > 28 and math.random(1,3) == 2 then
			local particle = Emitter:Add("effects/blood_drop", self.Entity:GetPos())
			particle:SetVelocity(VectorRand() * 15)
			particle:SetDieTime(3)
			particle:SetStartAlpha(180)
			particle:SetStartSize(10)
			particle:SetEndSize(1)
			particle:SetRoll(180)
			particle:SetColor(255, 255, 255)
		end
	end
end
