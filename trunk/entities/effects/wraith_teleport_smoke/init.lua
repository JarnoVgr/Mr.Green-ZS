-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

function EFFECT:Init( data )

	-- Get entity
	self.Ent = data:GetEntity()
	self.Pos = data:GetOrigin()
	
	if not IsValid(self.Ent) then return end

	-- Set particle/emitter
	self.Particles = {}
	self.Emitter = ParticleEmitter( self.Pos + self.Ent:OBBCenter() )
	
	-- Effect die time
	self.DieTime = CurTime() + 3.3
	
	-- Pre-fab random local location table
	self.ParticlePosition = {}
	for i = 1, 500 do
		local X, Y, Z
		if math.random( 1, 2 ) == 1 then X = math.Rand( self.Ent:OBBMins().X + 4, self.Ent:OBBMins().X + 8 ) else X = math.Rand( self.Ent:OBBMaxs().X - 4, self.Ent:OBBMaxs().X - 8 ) end 
		if math.random( 1, 2 ) == 1 then Y = math.Rand( self.Ent:OBBMins().Y + 4, self.Ent:OBBMins().Y + 8 ) else Y = math.Rand( self.Ent:OBBMaxs().Y - 4, self.Ent:OBBMaxs().Y - 8 ) end 
		Z = math.Rand( self.Ent:OBBMins().Z + 10, self.Ent:OBBMaxs().Z - 20 ) 
		
		self.ParticlePosition[i] = Vector( X, Y, Z )
	end
	
	-- Particle color (grey random)
	local greyCol = math.random( 40, 80 )
	
    -- Add particles
	for i = 1, 14 do
		self.Particles[i] = self.Emitter:Add( "particle/smokestack", self.Pos + table.Random( self.ParticlePosition ) )
		self.Particles[i]:SetVelocity( Vector( math.Rand( -2, 2 ),math.Rand( -2, 2 ), math.Rand( 15, 35 ) ) )
		self.Particles[i]:SetDieTime( 2.5 )
		self.Particles[i]:SetStartAlpha( 200 )
		self.Particles[i]:SetEndAlpha( 80 )
		self.Particles[i]:SetStartSize( math.Rand( 13, 20 ) )
		self.Particles[i]:SetEndSize( 0 )
		self.Particles[i]:SetColor( greyCol, greyCol, greyCol )
	end
	
	self:Finish()
end

-- Finish effect
function EFFECT:Finish()
	if self.Emitter then
		self.Emitter:Finish() 
	end
	
	-- Erase particles
	if self.Particles then
		for i = 1, 10 do
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

