-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

include("shared.lua")

local math = math

function ENT:Draw()
	self:DrawModel()
	if self.Entity:GetVelocity():Length() > 20 then
		-- local emitter = ParticleEmitter(self.Entity:GetPos())
		if self.Entity.IsHead == true then
		local particle = self.Emitter:Add("decals/blood_spray"..math.random(1,8), self.Entity:GetPos())
			particle:SetVelocity(VectorRand() * 16)
			particle:SetDieTime(0.9)
			particle:SetStartAlpha(255)
			particle:SetStartSize(11)
			particle:SetEndSize(4)
			particle:SetRoll(180)
			particle:SetColor(255, 0, 0)
			particle:SetLighting(true)
		else
		local particle = self.Emitter:Add("decals/blood_spray"..math.random(1,8), self.Entity:GetPos())

			particle:SetVelocity(VectorRand() * 16)
			particle:SetDieTime(0.6)
			particle:SetStartAlpha(255)
			particle:SetStartSize(18)
			particle:SetEndSize(8)
			particle:SetRoll(180)
			particle:SetColor(255, 0, 0)
			particle:SetLighting(true)		
			end
	end
end

function ENT:Initialize()
	self.Emitter = ParticleEmitter( self:GetPos() )
end

function ENT:Think()
end

function ENT:OnRemove()
	self.Emitter:Finish()
end
