-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

//Initialization
function EFFECT:Init( data )
	self.Item = data:GetEntity()
	if not self:IsItemValid() then return end

	//Set emitter position
	self:SetPos( self:GetCenter() )
	self.Emitter = ParticleEmitter( self:GetCenter() )
	
	//Get grenade type
	self.GrenadeType = self.Item:GetType()

	self.Particles = {}
	for i = 1, 2 do
		self.Particles[i] = self.Emitter:Add( "sprites/light_glow02_add", self:GetCenter() )
		self.Particles[i]:SetVelocity( Vector( 0,0,0 ) )
		self.Particles[i]:SetDieTime( 5000 )
		
		self.Particles[i]:SetEndAlpha( 210 )
		self.Particles[i]:SetStartSize( 9 )
		self.Particles[i]:SetEndSize( 9 )
		self.Particles[i]:SetRoll( 250 )
		
		//Red for kinetic, green for poison
		if self.GrenadeType then	
			self.Particles[i]:SetStartAlpha( 210 )
			self.Particles[i]:SetColor( 255, 30, 30 )
		else
			self.Particles[i]:SetStartAlpha( 60 )
			self.Particles[i]:SetColor( 60, 160, 50 )
		end
	end
end

//Terminates effect
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

//Checks if item is valid
function EFFECT:IsItemValid()
	return IsValid( self.Item ) 
end

//Returns effect position
function EFFECT:GetCenter()
	if self:IsItemValid() then
		return self.Item:LocalToWorld( self.Item:OBBCenter() )
	end
	
	return Vector( 0,0,0 )
end

//Effect think
function EFFECT:Think()
	if not self:IsItemValid() then
		return self:Finish()
	end
	
	//Update emitter position
	self:SetPos( self:GetCenter() )
	
	return true
end

//Renders particles
function EFFECT:Render()
	if self.Particles then
		for i = 1, 2 do
			self.Particles[i]:SetPos( self:GetPos() )
		end
	end
end
