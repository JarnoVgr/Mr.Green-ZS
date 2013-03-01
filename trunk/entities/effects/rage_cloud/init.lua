-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

function EFFECT:Init( data )
	self.Zombie = data:GetEntity()
	if not self:IsEntityValid() then return end
	
	print( 1 )
	
	//Effect size and pos
	self.Size, self.Pos = 35, self:GetCenter()
	
	self.Particles = {}
	self:SetPos( self:GetCenter() )
	self.Emitter = ParticleEmitter( self.Pos )

	for i = 1, 2 do
		self.Particles[i] = self.Emitter:Add( "particle/smokestack", self:GetPos() )
	end
	
	if self.Particles then
		for i = 1, 2 do
			self.Particles[i]:SetVelocity( Vector( 0,0,0 ) )
			self.Particles[i]:SetDieTime(5)
			self.Particles[i]:SetStartAlpha(80)
			self.Particles[i]:SetPos( self:GetPos() )
			self.Particles[i]:SetEndAlpha(80)
			self.Particles[i]:SetStartSize( self.Size )
			self.Particles[i]:SetEndSize( self.Size )
			self.Particles[i]:SetColor( math.random( 70, 120 ), math.random( 20, 30 ), 20 )
		end
	end
end

//Calculate position
function EFFECT:GetCenter()
	if self:IsEntityValid() then
		return self.Zombie:LocalToWorld( self.Zombie:OBBCenter() )
	end
	
	return Vector( 0,0,0 )
end

//Finish effect
function EFFECT:Finish()
	if self.Emitter then
		self.Emitter:Finish() 
	end
	
	//Erase particles
	if self.Particles then
		for i = 1, 2 do
			self.Particles[i]:SetDieTime( 0.01 )
		end
	end
	
	return false
end

function EFFECT:IsEntityValid()
	return IsValid( self.Zombie ) and self.Zombie:IsPlayer() and self.Zombie:IsZombie() and self.Zombie:Alive() and self.Zombie:IsZombieInRage()
end

function EFFECT:Think()
	if not self:IsEntityValid() then 
		return self:Finish()
	end	

	//Update emitter position
	self:SetPos( self:GetCenter() )
	
	return true
end

function EFFECT:Render()
	if self.Particles then
		for i = 1, 2 do
			self.Particles[i]:SetPos( self:GetPos() )
		end
	end
end
