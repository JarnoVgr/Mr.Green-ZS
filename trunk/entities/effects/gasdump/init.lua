-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
--Duby:Test
function EFFECT:Init( data )
	local emitter = ParticleEmitter( data:GetOrigin() )
	self.weapon = data:GetEntity()
	self.attachment = data:GetAttachment()
	self.pos = self:GetTracerShootPos( data:GetOrigin(), self.weapon, self.attachment )
	for i = 1, 1 do
		local smoke = emitter:Add( "particle/particle_smokegrenade", self.pos )
		if ( smoke ) then
			smoke:SetVelocity( Vector( math.Rand( 0, 2 ), math.Rand( 0, 2 ), 0 ) )
			smoke:SetLifeTime( 30 )
			smoke:SetDieTime( 2 )
			smoke:SetColor( 225, 225, 225 )
			smoke:SetStartAlpha( 5 )
			smoke:SetEndAlpha( 10 )
			smoke:SetStartSize( 10000 )
			smoke:SetEndSize( 10000 )
			smoke:SetRoll( math.Rand( 180, 480 ) )
			smoke:SetGravity( Vector( 0, 0, 0 ) )
			smoke:SetCollide( false )
			smoke:SetBounce( 0.45 )
		end
	end
	for i = 1, 2 do
		local smoke = emitter:Add( "particle/particle_smokegrenade", self.pos )
		if ( smoke ) then
			smoke:SetVelocity( Vector( math.Rand( -20, 20 ), math.Rand( -20, 20 ), 22 ) )
			smoke:SetLifeTime( 30 )
			smoke:SetDieTime( 6 )
			smoke:SetColor( 225, 225, 225  )
			smoke:SetStartAlpha( 300 )
			smoke:SetEndAlpha( 600 )
			smoke:SetStartSize( 500 )
			smoke:SetEndSize( 10000 )
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
			smoke:SetLifeTime( 40 )
			smoke:SetDieTime( 7 )
		--	smoke:SetColor( 25, 25, 25 )
			smoke:SetColor( 225, 225, 225)
			smoke:SetStartAlpha( 300 )
			smoke:SetEndAlpha( 1000 )
			smoke:SetStartSize( 10000 )
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
			smoke:SetLifeTime( 40 )
			smoke:SetDieTime( 7 )
		--	smoke:SetColor( 25, 25, 25 )
			smoke:SetColor( 225, 225, 225 )
			smoke:SetStartAlpha( 1000 )
			smoke:SetEndAlpha( 10000 )
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
			smoke:SetLifeTime( 40 )
			smoke:SetDieTime( 7 )
		--	smoke:SetColor( 25, 25, 25 )
			smoke:SetColor( 225, 225, 225 )
			smoke:SetStartAlpha( 1000 )
			smoke:SetEndAlpha( 100000 )
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
			smoke:SetStartSize(1000)
			smoke:SetEndSize(100000)
			smoke:SetColor(225, 225, 225)
			smoke:SetRoll(math.Rand(0, 360))
			smoke:SetRollDelta(math.Rand(-1, 1))
			smoke:SetAirResistance(10)
		end end
	
	
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