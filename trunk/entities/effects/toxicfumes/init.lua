-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- modified to act as zombie spawn toxic instead of chem zombie toxic

function EFFECT:Init( data )
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
	self.NextPuff = RealTime() + 1 + math.random(3)
	
	if ToxicPool <= 0 then return end
	ToxicPool = ToxicPool - 1
	
	local pos = self.Entity:GetPos()
	local emitter = ParticleEmitter ( pos )
	for i = 1, math.random (1, 3) do
		local particle = emitter:Add( "particle/smokestack", pos+(VectorRand() * 40) )
		particle:SetVelocity( VectorRand() * 4 + Vector(0,0,math.random(7,13)) )
		particle:SetDieTime( math.Rand(5, 10) )
		particle:SetStartAlpha( 0 )
		particle:SetEndAlpha( 10 )
		particle:SetStartSize( 40 + math.random(10) )
		particle:SetEndSize( 80 + math.random(30) )
		particle:SetColor( 20, 100, 20 )
		particle:SetRoll( math.Rand(0, 360) )
	end
	emitter:Finish()	
end
