-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

function EFFECT:Init ( data )
	local Ent = data:GetEntity()
	if not ValidEntity ( Ent ) then return end
	
	local vOffset = Ent:GetPos()
	local Low, High = Ent:WorldSpaceAABB()

	local NumParticles = Ent:BoundingRadius()
	NumParticles = math.Clamp(  NumParticles * 6, 50, 350 )
		
	local emitter = ParticleEmitter( vOffset )
		for i = 0, NumParticles do
			local vPos = Vector( math.Rand(Low.x,High.x), math.Rand(Low.y,High.y), math.Rand(Low.z,High.z) )
			local particle = emitter:Add( "effects/blueflare1", vPos )
			//if particle:IsValid() then
				particle:SetVelocity( ( ( vPos - vOffset) * math.Rand(1,3) ) + Vector(0,0,math.Rand(1,3) ) )
				particle:SetLifeTime( 0 )
				particle:SetColor( math.random(120, 200 ),50,50,250 )
				particle:SetDieTime( math.Rand( 1.5, 3 ) )
				particle:SetStartAlpha( math.Rand( 130, 190 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand( 3, 5 ) )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
					
				particle:SetAirResistance( 100 )
				particle:SetGravity( Vector( 0, 0, -50 ) )
				particle:SetCollide( true )
				particle:SetBounce( 0.6 )
			//end
		end
	emitter:Finish()
end

function EFFECT:Think ()
	return false
end

function EFFECT:Render ()
end
