-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

include("shared.lua")

function ENT:Draw()
	self:DrawModel()
	if self.Entity:GetVelocity():Length() <= 20 then
		return
	end

	local particle = self.Emitter:Add("decals/blood_spray"..math.random(1,8), self.Entity:GetPos())
	particle:SetVelocity(VectorRand() * 16)
	particle:SetStartAlpha(255)
	particle:SetRoll(180)
	particle:SetColor(255, 0, 0)
	particle:SetLighting(true)
	if self.Entity.IsHead == true then
		particle:SetDieTime(0.9)
		particle:SetStartSize(11)
		particle:SetEndSize(4)
	else
		particle:SetDieTime(0.6)
		particle:SetStartSize(18)
		particle:SetEndSize(8)
	end
end

function ENT:Initialize()
	self.Emitter = ParticleEmitter(self:GetPos())
end

function ENT:Think()
end

function ENT:OnRemove()
	if self.Emitter then
		self.Emitter:Finish()
	end
end
