include("shared.lua")

ENT.NextTickSound = 0
ENT.LastTickSound = 0
ENT.NextEmit = 0

function ENT:Initialize()
	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(48, 64)

	self.DieTime = CurTime() + self.LifeTime
end

function ENT:Think()
	local emitter = self.Emitter
	local pos = self:GetPos() + self:GetUp() * 8
	emitter:SetPos(pos)

	local curtime = CurTime()

	if curtime >= self.NextEmit then
		self.NextEmit = curtime + 0.0		
	end

	if curtime >= self.NextTickSound then
		local delta = self.DieTime - curtime

		self.NextTickSound = curtime + math.max(0.2, delta * 0.2)
		self.LastTickSound = curtime
		self:EmitSound("ambient/fire/ignite.wav", 75, math.Clamp((1 - delta / self.LifeTime) * 160, 100, 160)) --Better noise
	end
end

function ENT:OnRemove()
	self.Emitter:Finish()
end

local matGlow = Material("sprites/glow04_noz")
local matGlow2 = Material("sprites/glow04_noz")
function ENT:Draw()
	self:DrawModel()

	if math.abs(self.LastTickSound - CurTime()) < 0.1 then
		local pos = self:GetPos() + self:GetUp() * 8

		render.SetMaterial(matGlow)
		render.DrawSprite(pos, 16, 16, COLOR_RED)
		
		render.SetMaterial(matGlow2)
		render.DrawSprite(pos, -20, -20, COLOR_GREEN) --Lets make it look more like a 'chemical'  weapon..

		local dlight = DynamicLight(self:EntIndex())
		
		if dlight then
			dlight.Pos = pos
			dlight.r = 255
			dlight.g = 0
			dlight.b = 0
			dlight.Brightness = 0.75
			dlight.Size = 64
			dlight.Decay = 256
			dlight.DieTime = CurTime() + 0.1
		end	
	end
end
