--/*---------------------------------------------------------
--Init
---------------------------------------------------------*/
function EFFECT:Init( data )
	local emitter = ParticleEmitter( data:GetOrigin() )
	self.weapon = data:GetEntity()
	self.attachment = data:GetAttachment()
	self.pos = self:GetTracerShootPos( data:GetOrigin(), self.weapon, self.attachment )
	for i = 1, 2 do
		local smoke = emitter:Add( "particle/particle_smokegrenade", self.pos )
		if ( smoke ) then
			smoke:SetVelocity( Vector( math.Rand( -20, 20 ), math.Rand( -20, 20 ), 22 ) )
			smoke:SetLifeTime( 10 )
			smoke:SetDieTime( 10 )
			smoke:SetColor( 11, 11, 11 )
			smoke:SetStartAlpha( 115 )
			smoke:SetEndAlpha( 600 )
			smoke:SetStartSize( 120 )
			smoke:SetEndSize( 150 )
			smoke:SetRoll( math.Rand( 180, 480 ) )
			smoke:SetGravity( Vector( 0, 0, 55 ) )
			smoke:SetCollide( false )
			smoke:SetBounce( 0.45 )
		end
	end
	
	for i = 1, 2 do
		local smoke = emitter:Add( "particle/particle_smokegrenade", self.pos )
		if ( smoke ) then
			smoke:SetVelocity( Vector( math.Rand( -20, 20 ), math.Rand( -20, 20 ), 22 ) )
			smoke:SetLifeTime( 10 )
			smoke:SetDieTime( 10 )
			smoke:SetColor( 11, 11, 11 )
			smoke:SetStartAlpha( 115 )
			smoke:SetEndAlpha( 600 )
			smoke:SetStartSize( 40 )
			smoke:SetEndSize( 50 )
			smoke:SetRoll( math.Rand( 180, 480 ) )
			smoke:SetGravity( Vector( 0, 0, 55 ) )
			smoke:SetCollide( false )
			smoke:SetBounce( 0.45 )
		end
	end
	
	for i = 1, 2 do
		local smoke = emitter:Add( "particle/particle_smokegrenade", self.pos )
		if ( smoke ) then
			smoke:SetVelocity( Vector( math.Rand( -20, 20 ), math.Rand( -20, 20 ), 22 ) )
			smoke:SetLifeTime( 10 )
			smoke:SetDieTime( 10 )
			smoke:SetColor( 75, 75, 75 )
			smoke:SetStartAlpha( 115 )
			smoke:SetEndAlpha( 600 )
			smoke:SetStartSize( 140 )
			smoke:SetEndSize( 150 )
			smoke:SetRoll( math.Rand( 180, 480 ) )
			smoke:SetGravity( Vector( 0, 0, 55 ) )
			smoke:SetCollide( false )
			smoke:SetBounce( 0.45 )
		end
	end
	
	for i = 1, 2 do
		local smoke = emitter:Add( "particle/particle_smokegrenade", self.pos )
		if ( smoke ) then
			smoke:SetVelocity( Vector( math.Rand( -20, 20 ), math.Rand( -20, 20 ), 22 ) )
			smoke:SetLifeTime( 10 )
			smoke:SetDieTime( 10 )
			smoke:SetColor( 11, 11, 11 )
			smoke:SetStartAlpha( 115 )
			smoke:SetEndAlpha( 600 )
			smoke:SetStartSize( 140 )
			smoke:SetEndSize( 150 )
			smoke:SetRoll( math.Rand( 180, 480 ) )
			smoke:SetGravity( Vector( 0, 0, 55 ) )
			smoke:SetCollide( false )
			smoke:SetBounce( 0.45 )
		end
	end
	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

--/*---------------------------------------------------------
--Render
---------------------------------------------------------*/
function EFFECT:Render()
end