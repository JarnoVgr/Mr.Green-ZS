-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--EFFECT.Time = math.Rand(5, 10)

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	if not pos then return end
	
	//local boxVec = data:GetStart()
	local radius = data:GetScale()/2
	
	local emitter = ParticleEmitter(pos)
	for i=1, 15 do
		local ppos = pos
		ppos = ppos + VectorRand()*radius
		ppos.z = -math.abs(ppos.z)
		//ppos.x = ppos.x-math.abs(boxVec.x)+math.random(0,math.abs(boxVec.x))
		//ppos.y = ppos.y-math.abs(boxVec.y)+math.random(0,math.abs(boxVec.y))
		//ppos.z = ppos.z-math.abs(boxVec.z)+math.random(0,math.abs(boxVec.z))
		local part = emitter:Add("particles/smokey",ppos)
		if part then
			local rand = math.random(30)
			part:SetColor(70+rand,70+rand,70+rand,math.random(180+math.random(50)))
			part:SetVelocity((ppos-pos):GetNormal() * (4+math.random(3)))
			part:SetDieTime(2+math.random(2))
			part:SetLifeTime(0)
			part:SetStartSize(radius/(1+math.Rand(0,1)))
			part:SetEndSize(radius*(1+math.Rand(0,0.5)))
		end
	end 
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
