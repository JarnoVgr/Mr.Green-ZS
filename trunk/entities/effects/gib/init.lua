-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local math = math
local table = table

EFFECT.Time = math.Rand(5, 10)
--TOTALGIBS = TOTALGIBS or 0
function EFFECT:Init(data)
	if TOTALGIBS > 25 then return end
	TOTALGIBS = TOTALGIBS + 1
	--print("added gib, total: "..TOTALGIBS)
	--local modelid = data:GetMagnitude()
	local modelid = table.Count( HumanGibs )
	self.Entity:SetModel(HumanGibs[ math.random( modelid ) ])

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )


	if modelid > 4 then
		self.Entity:SetMaterial("models/flesh")
	end

	local phys = self.Entity:GetPhysicsObject()
	if ( phys && IsValid(phys) ) then
	
		phys:Wake()
		phys:SetAngles( Angle( math.random(0,359), math.random(0,359), math.random(0,359) ) )
		phys:SetVelocity( (data:GetNormal() * 3/8 + VectorRand() * 1/4 + Vector(0,0,math.random(0,3)) * 3/8) *  math.random( 50, 200 ) )
	
	end
	self.Time = CurTime() + math.random(8, 15)
	//self.Emitter = ParticleEmitter(self.Entity:GetPos())
end

function EFFECT:Think()
	if TOTALGIBS > 25 then
	--	self.Emitter:Finish()
		return false
	end
	if CurTime() > self.Time then
		--self.Emitter:Finish()
		TOTALGIBS = TOTALGIBS - 1
		--print("removed gib, total: "..TOTALGIBS)
		return false
	end
	return true
end

function EFFECT:Render()
	self.Entity:DrawModel()
	--[[if self.Entity:GetVelocity():Length() > 20 then
		//local emitter = ParticleEmitter(self.Entity:GetPos())
		local particle = self.Emitter:Add("decals/blood_spray"..math.random(1,8), self.Entity:GetPos())
			particle:SetVelocity(VectorRand() * 16)
			particle:SetDieTime(0.6)
			particle:SetStartAlpha(255)
			particle:SetStartSize(18)
			particle:SetEndSize(8)
			particle:SetRoll(180)
			particle:SetColor(255, 0, 0)
			particle:SetLighting(true)
	end]]
end
