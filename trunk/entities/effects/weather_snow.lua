function EFFECT:Init( data )

	local g = data:GetScale()
	local m = math.Round(data:GetMagnitude())
	local n = data:GetRadius()

	local em3D = ParticleEmitter(data:GetOrigin(), false)
	
	if (em3D) then

		for i = 0, m do
	
			local pos = data:GetOrigin() + Vector( math.random( -n, n ), math.random( -n, n ), math.random( n, 2 * n ) )
			
			local particle = em3D:Add("particle/snow", pos)
			if (particle) then
				particle:SetLifeTime(math.random(-2,0))
				particle:SetDieTime(math.random(30, 60))
				particle:SetStartAlpha(100)
				particle:SetEndAlpha(100)
				particle:SetStartSize(1.5)
				particle:SetEndSize(0.2)
				particle:SetAirResistance(1)
				particle:SetGravity(Vector(0,0, math.random(g, math.Round(g / 2.5))))
				particle:SetCollide(true)
				particle:SetCollideCallback( function( p, pos, norm )
				
					particle:SetEndAlpha(200)
					particle:SetEndSize(1)

				end )

				particle:SetBounce(.01)
				particle:SetColor(255,255,255,255)
			end
	
		end
		
		em3D:Finish()

	end

	local em2D = ParticleEmitter( data:GetOrigin() )
		
	if( em2D ) then
			
		if( math.random( 1, ( m / 10 ) * 2 ) == 1 ) then

			local pos = data:GetOrigin() + Vector( math.random( -n, n ), math.random( -n, n ), math.random( n, 2 * n ) )
				
			local p = em2D:Add( "particle/cloud", pos )
					
			p:SetVelocity( Vector( 0, 0, -1000 ) )
			p:SetDieTime( 5 )
			p:SetStartAlpha( 6 )
			p:SetStartSize( 166 )
			p:SetEndSize( 166 )
			p:SetColor( 255,255,255 )
					
			p:SetCollide( true )
			p:SetCollideCallback( function( p, pos, norm )
						
				p:SetDieTime( 0 )
						
			end )
				
		end
			
		em2D:Finish()
			
	end
	
		/*if (self.Clouds == 1) then

			local particle2 = emitter:Add("particle/cloud", spawnpos)
			if (particle2) then
				Ang = LocalPlayer():GetAimVector()-Vector(0,0,LocalPlayer():GetAimVector().z)
				Vec = Vector(math.sin(math.random() * math.Rand(-70, 70)), math.sin(math.random() * math.Rand(-70, 70)), 0)
				particle2:SetVelocity((Vec + Ang) * 10000)
				particle2:SetLifeTime(0)
				particle2:SetDieTime(10)
				particle2:SetStartAlpha(255)
				particle2:SetEndAlpha(55)
				particle2:SetStartLength(0)
				particle2:SetEndLength(0)
				particle2:SetStartSize(100)
				particle2:SetEndSize(100)
				particle2:SetAirResistance(500)
				particle2:SetGravity(Vector(0,0,0))
				particle2:SetCollide(false)
				particle2:SetBounce(0.005)
				particle2:SetColor(255,255,255,255)
			end
		end*/
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end