-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

function EFFECT:Init( data )
	self.amount = data:GetMagnitude()
	self.time = CurTime() + 1
end

function EFFECT:Emit()
	local emitter = ParticleEmitter( LocalPlayer():GetPos() )
	for i = 0, math.Round( self.amount ) do
		local a = math.random(9999)
		local b = math.random(1,180)
		local dist = math.random(256,2048)
		local X = math.sin(b)*math.sin(a)*dist
		local Y = math.sin(b)*math.cos(a)*dist
		local offset = Vector(X,Y,0)
		local spawnpos = LocalPlayer():GetPos() + Vector( 0,0,300 ) + offset
		
		if util.PointContents ( spawnpos ) == CONTENTS_TESTFOGVOLUME then return end
		
		local particle = emitter:Add("effects/flake1", spawnpos )
		if ( particle ) then
			particle:SetLifeTime( math.random(-2,0) )
			particle:SetDieTime( math.Clamp( ( self.amount/80 ) + math.random(-10,10), 5, 10 ) )
			particle:SetStartAlpha( 254 )
			particle:SetEndAlpha( 254 )
			particle:SetStartSize( 3 )
			particle:SetEndSize( 1 )
			particle:SetAirResistance( 1 )
			particle:SetGravity( Vector( 0,0,math.random(-80,-50) ) )
			particle:SetCollide( false )
			particle:SetColor( 255,255,255,255 )
		end
	end
	emitter:Finish()
end

function EFFECT:Think()
	if not ( self.time < CurTime() ) then
		self:Emit()
	else
		return false
	end
end







