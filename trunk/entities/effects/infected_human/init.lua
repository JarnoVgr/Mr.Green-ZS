-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

function EFFECT:Init ( data )
	self.Human = data:GetEntity()
	if not self:IsItemValid() then return end

	//Emitter
	self.Emitter = ParticleEmitter ( self.Human:LocalToWorld( self.Human:OBBCenter() ) )
	
	//Pre-fab random local location table
	self.ParticlePosition = {}
	for i = 1, 500 do
		local X, Y, Z
		if math.random( 1, 2 ) == 1 then X = math.Rand( self.Human:OBBMins().X, self.Human:OBBMins().X + 5 ) else X = math.Rand( self.Human:OBBMaxs().X, self.Human:OBBMaxs().X - 5 ) end 
		if math.random( 1, 2 ) == 1 then Y = math.Rand( self.Human:OBBMins().Y, self.Human:OBBMins().Y + 5 ) else Y = math.Rand( self.Human:OBBMaxs().Y, self.Human:OBBMaxs().Y - 5 ) end 
		Z = math.Rand( self.Human:OBBMins().Z, self.Human:OBBMaxs().Z - 25 ) 
		
		self.ParticlePosition[i] = Vector( X, Y, Z )
	end
end

//Checks to see if item is valid
function EFFECT:IsItemValid()
	return IsValid( self.Human ) and self.Human:IsPlayer() and self.Human:IsHuman() and self.Human:IsTakingDOT()
end

//Returns effect position
function EFFECT:Position()
	if self:IsItemValid() then
		return self.Human:LocalToWorld( table.Random( self.ParticlePosition ) )
	end
	
	return Vector( 0,0,0 )
end

function EFFECT:Think()
	if not self:IsItemValid() then
		return self:Finish()
	end
	
	//Update emitter position
	if self.Emitter then
		self.Emitter:SetPos( self:Position() )
		self:SetPos( self:Position() )
	end
	
	return true
end

//Finishes effect
function EFFECT:Finish()
	if self.Emitter then
		self.Emitter:Finish()

	end
	
	return false
end

function EFFECT:Render()
	if ( self.PuffTime or 0 ) <= CurTime() then
		if self.Emitter then
			for i = 1, 3 do
				local Particle = self.Emitter:Add ( "effects/hazard_icon", self:Position() )
				Particle:SetVelocity ( Vector( math.Rand( -10, 10 ),math.Rand( -10, 10 ), math.Rand( 15, 30 ) ) )
				Particle:SetDieTime ( math.Rand ( 1, 2 ) )
				Particle:SetStartAlpha ( 170 )
				Particle:SetEndAlpha ( 0 )
				Particle:SetStartSize ( math.Rand ( 2,5.2 ) )
				Particle:SetEndSize ( 0 )
				Particle:SetColor( math.random( 70, 150 ), math.random( 100, 150 ), math.random( 30, 50 ) )
			end
		end
				
		//Apply cooldown
		self.PuffTime = CurTime() + math.Clamp( 0.3 - ( self.Human:GetVelocity():Length() / 1000 ), 0.13, 0.3 )
	end
end
