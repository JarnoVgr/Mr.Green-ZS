-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

function EFFECT:Init( data )

	//Get normal
	self.Pos = data:GetOrigin()
	self.Normal = data:GetNormal()

	//Set particle/emitter
	self.Particles = {}
	self.Emitter = ParticleEmitter( self.Pos )
	
	self.DieTime = CurTime() + 3

	//Add particles
	for i = 1, 3 do
		self.Particles[i] = self.Emitter:Add( "particle/smokestack", self.Pos + self.Normal * -4 + ( getVectorSign( VectorRand() * 2.2, -1 * self.Normal ) ) )
		self.Particles[i]:SetVelocity( ( -1 * self.Normal ) + ( getVectorSign( Vector( math.Rand( -10, 10 ),math.Rand( -10, 10 ),math.Rand( -10, 10 ) ), -1 * self.Normal ) ) )
		self.Particles[i]:SetDieTime( 2.5 )
		self.Particles[i]:SetStartAlpha( 110 )
		self.Particles[i]:SetEndAlpha( 80 )
		self.Particles[i]:SetStartSize( math.Rand( 6, 10 ) )
		self.Particles[i]:SetEndSize( 0 )
		self.Particles[i]:SetColor( math.random( 20, 30 ), math.random( 70, 120 ), 20 )
	end
end

//Finish effect
function EFFECT:Finish()
	if self.Emitter then
		self.Emitter:Finish() 
	end
	
	//Erase particles
	if self.Particles then
		for i = 1, 3 do
			self.Particles[i]:SetDieTime( 0.01 )
		end
	end
	
	return false
end

function EFFECT:Think()
	if self.DieTime <= CurTime() then
		return self:Finish()
	end
end

function EFFECT:Render()

end

