-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	pos = pos + Vector(0, 0, 48)

	--sound.Play("thrusters/rocket04.wav", pos, 90, math.random(85, 95))
	
		local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(40, 45)
		for i=1, math.random(12, 15) do
			local heading = VectorRand():GetNormal()
			local particle = emitter:Add("particles/flamelet" .. math.random(1, 5), pos + heading * 16)
			particle:SetVelocity(heading * 72)
			particle:SetDieTime(math.Rand(3, 5))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(60)
			particle:SetEndSize(30)
			particle:SetColor(100, 20, 20)
			particle:SetRoll(math.Rand(0, 1))
			particle:SetRollDelta(math.Rand(-1, 1))
		end
		for i=1, math.random(5, 8) do
			local particle = emitter:Add("particles/flamelet" .. math.random(1, 5), pos)
			particle:SetVelocity(VectorRand():GetNormal() * math.Rand(48, 82))
			particle:SetDieTime(math.Rand(2.2, 3.6))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(50)
			particle:SetEndSize(100)
			particle:SetColor(0, 30, 0)
			particle:SetRoll(math.Rand(0, 1))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetAirResistance(10)
		end
		for i=1, math.random(17, 21) do
			local particle = emitter:Add("particles/flamelet" .. math.random(1, 5), pos + VectorRand() * 32)
			local dir = VectorRand():GetNormal()
			particle:SetVelocity(dir * math.Rand(500, 600))
			particle:SetDieTime(math.Rand(2, 3))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(80)
			particle:SetEndSize(30)
			particle:SetRoll(math.Rand(0, 1))
			particle:SetRollDelta(math.Rand(-3, 3))
			particle:SetAirResistance(60)
			particle:SetGravity(dir * math.Rand(-600, -500))
		end
		for i=1, 2 do
			local particle = emitter:Add("particles/flamelet" .. math.random(1, 5), pos)
			particle:SetDieTime(math.Rand(2, 4))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(200)
			particle:SetEndSize(150)
			particle:SetRoll(math.Rand(0, 1))
			particle:SetRollDelta(math.Rand(0, 0))
		end
		
			for i = 1, 1 do
		local smoke = emitter:Add( "particle/particle_smokegrenade", pos )
		if ( smoke ) then
			smoke:SetLifeTime( 1 )
			smoke:SetDieTime( 2 )
			smoke:SetColor( 75, 75, 75 )
			smoke:SetStartAlpha( 5 )
			smoke:SetEndAlpha( 10 )
			smoke:SetStartSize( 5 )
			smoke:SetEndSize( 10 )
			smoke:SetRoll( math.Rand( 0, 0 ) )
			smoke:SetGravity( Vector( 0, 0, 0 ) )
			smoke:SetCollide( false )
			smoke:SetBounce( 0.45 )
		end
	end
	emitter:Finish()
	
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
