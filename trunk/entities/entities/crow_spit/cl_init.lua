-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

include("shared.lua")

function ENT:Initialize()
	self.Emitter = ParticleEmitter (self:GetPos())
	self.Emitter:SetNearClip (30,45)
end

function ENT:Think()
	self.Emitter:SetPos(self:GetPos())
end

function ENT:OnRemove()
	self.Emitter:Finish()
end

--local shitmat = Material ("decals/Yblood1")
function ENT:Draw()
	--render.SetMaterial ( shitmat )
	--render.DrawSprite (self:GetPos(),16,16,Color (255,255,255,255))
	local pos = self:GetPos()
	
	for i=1,2 do
		local particle = self.Emitter:Add ("decals/Yblood"..math.random(1,6), pos + VectorRand():GetNormal() * math.Rand (1,3))
		particle:SetVelocity(VectorRand():GetNormal() * math.Rand (1,3))
		particle:SetDieTime (math.Rand (0.6,1))
		particle:SetStartAlpha (255)
		particle:SetEndAlpha (255)
		particle:SetStartSize (math.Rand(2,4))
		particle:SetEndSize (0)
		particle:SetRoll (math.Rand(0,360))
		particle:SetRollDelta (math.Rand (-1,1))
	end
end


