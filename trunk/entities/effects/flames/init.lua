function EFFECT:Init(data)		
	--local Startpos = self:GetTracerShootPos(self.Position, data:GetEntity(), data:GetAttachment())
	local Hitpos = data:GetOrigin()
			
	--if data:GetEntity():IsValid() && Startpos && Hitpos then
		--self.Emitter = ParticleEmitter(Startpos)
		self.Emitter = ParticleEmitter()
		
		
		for i = 1, 40 do
			--local p = self.Emitter:Add("particles/flamelet" .. math.random(1, 5), Startpos)
			local p = self.Emitter:Add("particles/flamelet" .. math.random(1, 5))
			
			p:SetDieTime(0.3)
			p:SetStartAlpha(255)
			p:SetEndAlpha(0)
			p:SetStartSize(math.Rand(0.6, 1))
			p:SetEndSize(math.random(25, 35))
			p:SetRoll(math.random(1, 60))
			p:SetRollDelta(math.random(1, 60))	
		--	p:SetVelocity(((Hitpos - Startpos):GetNormal() * math.random(500, 800)) + VectorRand() * math.random(1, 20))
			p:SetVelocity(((Hitpos):GetNormal() * math.random(500, 800)) + VectorRand() * math.random(1, 20))
			p:SetCollide(true)
		end
		
		self.Emitter:Finish()
	--end
end
		
function EFFECT:Think()
	return false
end

function EFFECT:Render()
end