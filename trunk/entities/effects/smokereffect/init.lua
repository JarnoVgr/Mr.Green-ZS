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
			smoke:SetLifeTime( 4 )
			smoke:SetDieTime( 6 )
			smoke:SetColor( 75, 75, 75 )
			smoke:SetStartAlpha( 115 )
			smoke:SetEndAlpha( 600 )
			smoke:SetStartSize( 150 )
			smoke:SetEndSize( 250 )
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
			smoke:SetLifeTime( 4 )
			smoke:SetDieTime( 6 )
			smoke:SetColor( 75, 75, 75  )
			smoke:SetStartAlpha( 300 )
			smoke:SetEndAlpha( 600 )
			smoke:SetStartSize( 150 )
			smoke:SetEndSize( 250 )
			smoke:SetRoll( math.Rand( 180, 480 ) )
			smoke:SetGravity( Vector( 0, 0, 55 ) )
			smoke:SetCollide( false )
			smoke:SetBounce( 0.45 )
		end
	end
	for i = 1, 2 do
		local smoke = emitter:Add( "particle/particle_smokegrenade", self.pos )
		if ( smoke ) then
			smoke:SetVelocity( Vector( math.Rand(20, 60), math.Rand(40, 90), 44))
			smoke:SetLifeTime( 5 )
			smoke:SetDieTime( 7 )
		--	smoke:SetColor( 25, 25, 25 )
			smoke:SetColor( 75, 75, 75 )
			smoke:SetStartAlpha( 300 )
			smoke:SetEndAlpha( 700 )
			smoke:SetStartSize( 150 )
			smoke:SetEndSize( 250 )
			smoke:SetRoll( math.Rand( 180, 480 ) )
			smoke:SetGravity( Vector( 0, 0, 55 ) )
			smoke:SetCollide( false )
			smoke:SetBounce( 0.45 )
		end
	end
	for i = 1, 2 do
		local smoke = emitter:Add( "particle/particle_smokegrenade", self.pos )
		if ( smoke ) then
			smoke:SetVelocity( Vector( math.Rand(20, 60), math.Rand(40, 90), 44))
			smoke:SetLifeTime( 7 )
			smoke:SetDieTime( 7 )
		--	smoke:SetColor( 25, 25, 25 )
			smoke:SetColor( 75, 75, 75 )
			smoke:SetStartAlpha( 300 )
			smoke:SetEndAlpha( 700 )
			smoke:SetStartSize( 150 )
			smoke:SetEndSize( 250 )
			smoke:SetRoll( math.Rand( 180, 480 ) )
			smoke:SetGravity( Vector( 0, 0, 55 ) )
			smoke:SetCollide( false )
			smoke:SetBounce( 0.45 )
		end
	end
	
	for i = 1, 2 do
	local smoke = emitter:Add( "particle/particle_smokegrenade", self.pos )
		if ( smoke ) then
			smoke:SetVelocity( Vector( math.Rand(20, 60), math.Rand(40, 90), 44))
			smoke:SetLifeTime( 7 )
			smoke:SetDieTime( 7 )
		--	smoke:SetColor( 25, 25, 25 )
			smoke:SetColor( 75, 75, 75 )
			smoke:SetStartAlpha( 300 )
			smoke:SetEndAlpha( 700 )
			smoke:SetStartSize( 150 )
			smoke:SetEndSize( 250 )
			smoke:SetRoll( math.Rand( 180, 480 ) )
			smoke:SetGravity( Vector( 0, 0, 55 ) )
			smoke:SetCollide( false )
			smoke:SetBounce( 0.45 )
		end
	end
	
	for i = 1, 2 do
	local smoke = emitter:Add( "particle/particle_smokegrenade", self.pos )
		if ( smoke ) then
			smoke:SetVelocity( Vector( math.Rand(20, 60), math.Rand(40, 90), 44))
			smoke:SetLifeTime( 7 )
			smoke:SetDieTime( 7 )
		--	smoke:SetColor( 25, 25, 25 )
			smoke:SetColor( 75, 75, 75 )
			smoke:SetStartAlpha( 300 )
			smoke:SetEndAlpha( 700 )
			smoke:SetStartSize( 150 )
			smoke:SetEndSize( 250 )
			smoke:SetRoll( math.Rand( 180, 480 ) )
			smoke:SetGravity( Vector( 0, 0, 55 ) )
			smoke:SetCollide( false )
			smoke:SetBounce( 0.45 )
		end
	end
	
	for i = 1, 2 do
	local smoke = emitter:Add( "particle/particle_smokegrenade", self.pos )
		if ( smoke ) then
			smoke:SetVelocity( Vector( math.Rand(20, 60), math.Rand(40, 90), 44))
			smoke:SetLifeTime( 5 )
			smoke:SetDieTime( 7 )
		--	smoke:SetColor( 25, 25, 25 )
			smoke:SetColor( 75, 75, 75 )
			smoke:SetStartAlpha( 300 )
			smoke:SetEndAlpha( 700 )
			smoke:SetStartSize( 150 )
			smoke:SetEndSize( 250 )
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