--/*---------------------------------------------------------
--Init
---------------------------------------------------------*/
function EFFECT:Init( data )
	local emitter = ParticleEmitter( data:GetOrigin() )
	self.weapon = data:GetEntity()
	self.attachment = data:GetAttachment()
	self.pos = self:GetTracerShootPos( data:GetOrigin(), self.weapon, self.attachment )

	local heat = emitter:Add( "sprites/heatwave", self.pos )
	if ( heat ) then
		heat:SetVelocity( VectorRand() )
		heat:SetLifeTime( 4 )
		heat:SetDieTime( 5 )
		heat:SetStartAlpha( 255 )
		heat:SetAirResistance( 160 )
		heat:SetEndAlpha( 100 )
		heat:SetStartSize( 200 )
		heat:SetEndSize( 300 )
		heat:SetGravity( Vector( 0, 0, 100 ) )
	end
	for i = 1, 2 do
		local smoke = emitter:Add( "particle/particle_smokegrenade", self.pos )
		if ( smoke ) then
			smoke:SetVelocity( Vector( math.Rand( -20, 20 ), math.Rand( -20, 20 ), 22 ) )
			smoke:SetLifeTime( 4 )
			smoke:SetDieTime( 5 )
			smoke:SetColor( 75, 75, 75 )
			smoke:SetStartAlpha( 255 )
			smoke:SetEndAlpha( 100 )
			smoke:SetStartSize( 200 )
			smoke:SetEndSize( 300 )
			smoke:SetRoll( math.Rand( 180, 480 ) )
			smoke:SetGravity( Vector( 0, 0, 55 ) )
			smoke:SetCollide( false )
			smoke:SetBounce( 0.45 )
		end
	end
	local muzzleflash = emitter:Add( "effects/muzzleflash" .. math.random( 1, 4 ), self.pos )
	muzzleflash:SetVelocity( Vector( 0, 0, 0 ) )
	muzzleflash:SetGravity( Vector( 0, 0, 0 ) )
	muzzleflash:SetDieTime( 0.1 )
	muzzleflash:SetStartAlpha( 150 )
	muzzleflash:SetStartSize( 15 )
	muzzleflash:SetEndSize( 0 )
	muzzleflash:SetRoll( math.Rand( 180, 480 ) )
	muzzleflash:SetRollDelta( math.Rand( -1, 1 ) )
	muzzleflash:SetColor( 255, 255, 255 )

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