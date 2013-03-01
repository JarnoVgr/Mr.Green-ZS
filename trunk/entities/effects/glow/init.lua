-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

EFFECT.Time = 2

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	if not pos then return end

	local emitter = ParticleEmitter(pos)
	local vNormal = VectorRand()

	local particle = emitter:Add("sprites/light_glow02_add", Vector (pos.x+math.random(-10, 10),pos.y+math.random(-10, 10),pos.z+9) )
	particle:SetVelocity(vNormal * math.random(50, 80) - Vector(0,0,math.random(-16, -4)))
	particle:SetDieTime(0.4)
	particle:SetStartAlpha(150)
	particle:SetEndAlpha(0)
	particle:SetStartSize(math.Rand(10,15))
	particle:SetEndSize(10)
	particle:SetColor(math.random(0,255), math.random(0,255), math.random(0,255)) -- 155, 56, math.random(0, 50)
	particle:SetRoll(math.random(90, 360))
	emitter:Finish()
end

--[[function EFFECT:Think()
	return false
end]]

--[[function EFFECT:Render()
end]]
