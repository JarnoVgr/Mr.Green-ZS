include("shared.lua")

function ENT:Initialize()
	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(36, 44)
end

function ENT:Think()
	self.Emitter:SetPos(self:GetPos())
end

function ENT:OnRemove()
	self.Emitter:Finish()
end

local render = render
local math = math

local matPuke = Material("decals/Yblood1")
function ENT:Draw()
	render.SetMaterial(matPuke)
	local pos = self:GetPos()
	render.DrawSprite(pos, 32, 32, color_white)

	--local particle = self.Emitter:Add("decals/Yblood"..math.random(1,6), pos + VectorRand():GetNormal() * math.Rand(1, 4))
	local particle = self.Emitter:Add("decals/Yblood"..math.random(1,2), pos)
	particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(1, 2))
	particle:SetDieTime(math.Rand(0.5, 0.55))
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(255)
	particle:SetStartSize(math.Rand(2, 5))
	particle:SetEndSize(0)
	particle:SetRoll(math.Rand(10, 30))
	particle:SetRollDelta(math.Rand(-1, 1))
end
