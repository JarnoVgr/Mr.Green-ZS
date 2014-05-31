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
	
	for i=1, math.random(5, 8) do
			local smoke = emitter:Add("particle/smokestack", self.pos)
			if ( smoke ) then
			smoke:SetVelocity(VectorRand():GetNormal() * math.Rand(48, 82))
			smoke:SetDieTime(math.Rand(2.2, 3.6))
			smoke:SetStartAlpha(220)
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(8)
			smoke:SetEndSize(100)
			smoke:SetColor(0, 30, 0)
			smoke:SetRoll(math.Rand(0, 360))
			smoke:SetRollDelta(math.Rand(-1, 1))
			smoke:SetAirResistance(10)
		end end
		for i=1, math.random(17, 21) do
			local smoke = emitter:Add("effects/fire_cloud1",  self.pos + VectorRand() * 32)
			local dir = VectorRand():GetNormal()
			if ( smoke ) then
			smoke:SetVelocity(dir * math.Rand(500, 600))
			smoke:SetDieTime(math.Rand(1.0, 1.25))
			smoke:SetStartAlpha(220)
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(60)
			smoke:SetEndSize(30)
			smoke:SetRoll(math.Rand(0, 360))
			smoke:SetRollDelta(math.Rand(-3, 3))
			smoke:SetAirResistance(60)
			smoke:SetGravity(dir * math.Rand(-600, -500))
		end end
		for i=1, 2 do
			local smoke = emitter:Add("effects/fire_cloud1",  self.pos)
			if ( smoke ) then
			smoke:SetDieTime(math.Rand(0.3, 0.35))
			smoke:SetStartAlpha(255)
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(16)
			smoke:SetEndSize(300)
			smoke:SetRoll(math.Rand(0, 360))
			smoke:SetRollDelta(math.Rand(-30, 30))
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