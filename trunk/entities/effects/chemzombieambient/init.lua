-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- modified to act as zombie spawn toxic instead of chem zombie toxic

function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	self.NextPuff = RealTime() + math.random(3)
	self.Entity:SetPos(self.Pos)
	self.LifeTime = RealTime() + 5
end

function EFFECT:Think()
	if RealTime() > self.LifeTime then return false end
	return true
end

function EFFECT:Render()
	if RealTime() < self.NextPuff then return true end
	self.NextPuff = RealTime() + 1 + math.random( 3 )
	
	--if ToxicPool <= 0 then return end
	--ToxicPool = ToxicPool - 1
	
	local pos = self.Entity:GetPos()
	local emitter = ParticleEmitter( pos )
	for i=2, math.random(1, 2) do
		local particle = emitter:Add("particle/smokestack", pos+(VectorRand() * 40))
		--local particle = emitter:Add("particle/smokestack", pos+(VectorRand() * 20))
		particle:SetVelocity(VectorRand() * 4 + Vector(0,0,math.random(7,13)))
		--particle:SetVelocity(VectorRand() * 4 + Vector(0,0,math.random(3,8)))
		particle:SetDieTime(math.Rand(2, 6))
		particle:SetStartAlpha(50)
		particle:SetEndAlpha(10)
		particle:SetStartSize(30+math.random(12))
		particle:SetEndSize(60+math.random(15))
		particle:SetColor(20, 100, 20)
		particle:SetRoll(math.Rand(0, 360))
	end
	emitter:Finish()	
end
