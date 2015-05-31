include("shared.lua")

ENT.thinkTimer = 0

local particleTable = {
	[ 1 ] = { particle = "particle/smokesprites_0001", sizeStart = 0, sizeEnd = 220, airRecis = 90, startAlpha = 180, endAlpha = 0, randXY = 46, randZMin = 60, randZMax = 120, color = Color( 0, 80, 0 ), rotRate = 1.8, lifeTimeMin = 1.2, lifeTimeMax = 3.9 },
	[ 2 ] = { particle = "particle/smokesprites_0002", sizeStart = 0, sizeEnd = 260, airRecis = 76, startAlpha = 110, endAlpha = 0, randXY = 24, randZMin = 62, randZMax = 130, color = Color( 0, 120, 0 ), rotRate = 0.6, lifeTimeMin = 1.6, lifeTimeMax = 4.2 },
	[ 3 ] = { particle = "particle/smokesprites_0003", sizeStart = 0, sizeEnd = 240, airRecis = 49, startAlpha = 140, endAlpha = 0,randXY = 36, randZMin = 43, randZMax = 160, color = Color( 0, 90, 0 ), rotRate = 0.6, lifeTimeMin = 1.8, lifeTimeMax = 3.4 },
	[ 4 ] = { particle = "particle/smokesprites_0004", sizeStart = 0, sizeEnd = 230, airRecis = 59, startAlpha = 110, endAlpha = 0,randXY = 42, randZMin = 48, randZMax = 120, color = Color( 0, 60, 0 ), rotRate = 0.2, lifeTimeMin = 1.6, lifeTimeMax = 4.9 },
	[ 5 ] = { particle = "particle/smokesprites_0007", sizeStart = 0, sizeEnd = 290, airRecis = 79, startAlpha = 80, endAlpha = 0,randXY = 46, randZMin = 39, randZMax = 190, color = Color( 0, 70, 0 ), rotRate = 1.4, lifeTimeMin = 1.6, lifeTimeMax = 3.2 },
	[ 6 ] = { particle = "particle/smokesprites_0008", sizeStart = 0, sizeEnd = 180, airRecis = 46, startAlpha = 90, endAlpha = 0,randXY = 49, randZMin = 42, randZMax = 220, color = Color( 0, 90, 0 ), rotRate = 1, lifeTimeMin = 1.7, lifeTimeMax = 3.4 },
	[ 7 ] = { particle = "particle/smokesprites_0003", sizeStart = 0, sizeEnd = 230, airRecis = 4, startAlpha = 155, endAlpha = 0,randXY = 62, randZMin = 61, randZMax = 180, color = Color( 0, 140, 0 ), rotRate = 0, lifeTimeMin = 1.5, lifeTimeMax = 4.3 },
	[ 8 ] = { particle = "particle/smokesprites_0004", sizeStart = 0, sizeEnd = 240, airRecis = 4, startAlpha = 155, endAlpha = 0,randXY = 50, randZMin = 51, randZMax = 140, color = Color( 0, 120, 0 ), rotRate = 0, lifeTimeMin = 1.5, lifeTimeMax = 2.9 },
	[ 9 ] = { particle = "particle/particle_glow_03", sizeStart = 0, sizeEnd = 4, airRecis = 4, startAlpha = 155, endAlpha = 0,randXY = 69, randZMin = 42, randZMax = 140, color = Color( 0, 255, 0 ), rotRate = 0, lifeTimeMin = 1.5, lifeTimeMax = 2.8 },
}
                                              

function ENT:Think()	
	if( self.thinkTimer > CurTime() ) then return end
	local oldPos = self:GetPos()

	local vecRan = VectorRand():GetNormalized()
	local chance = math.random( 1, 9 )
	vecRan.z = math.Rand( 10, 20 )
	local pos = LocalToWorld( Vector( -15, -15, 50 + vecRan.z ), Angle( 0, 0, 0 ), oldPos, Angle( 0, 0, 0 )  )
	local emitter = ParticleEmitter( pos )
	
	emitter:SetNearClip( 48, 64 )
			local particle = emitter:Add( particleTable[ chance ].particle, pos )
			particle:SetVelocity( Vector( math.Rand( -particleTable[ chance ].randXY, particleTable[ chance ].randXY ), math.Rand( -particleTable[ chance ].randXY, particleTable[ chance ].randXY ),  math.Rand( particleTable[ chance ].randZMin, particleTable[ chance ].randZMax ) )  )
			particle:SetColor( particleTable[ chance ].color.r, particleTable[ chance ].color.g, particleTable[ chance ].color.b )
			particle:SetAirResistance( particleTable[ chance ].airRecis )
			particle:SetGravity( Vector( 0, 0, -100 ) )
			particle:SetCollide( true )
			particle:SetDieTime( math.Rand( particleTable[ chance ].lifeTimeMin , particleTable[ chance ].lifeTimeMax ) )
			particle:SetStartAlpha( particleTable[ chance ].startAlpha )
			particle:SetEndAlpha( particleTable[ chance ].endAlpha )
			particle:SetStartSize( particleTable[ chance ].sizeStart )
			particle:SetEndSize( particleTable[ chance ].sizeEnd )
			particle:SetRollDelta( math.Rand( -particleTable[ chance ].rotRate, particleTable[ chance ].rotRate ) )
		emitter:Finish()
				
	self.thinkTimer = CurTime() + math.Rand( 0.05, 0.15 )
end

function ENT:Draw()
end