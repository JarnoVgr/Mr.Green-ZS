-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

include( "shared.lua" )

ENT.PuffTimer = 0

-- Initialization
function ENT:Initialize()
	self.Sticked = false
end

-- Main think
function ENT:Think()
	if self:GetHitNormal() ~= Vector( 0,0,0 ) then
		if not self.Sticked then
			self.Sticked = true
		end
	end
end

-- On removal
function ENT:OnRemove()
	if self.Emitter then
		self.Emitter:Finish()
	end
	
	-- Check particles
	if self.Particles then
		for i = 1, 2 do
			self.Particles[i]:SetDieTime( 0.01 )
		end
	end		
end

-- Get rounded hit normal
function ENT:GetRoundNormal()
	return Vector( math.Round( self:GetHitNormal().X ), math.Round( self:GetHitNormal().Y ), math.Round( self:GetHitNormal().Z ) )
end	

-- Render hook
function ENT:Draw()
	self:SetColor( Color(240, 30, 30, 150) )
	self:DrawModel()
	
	-- Initialize emitter
	if not self.Emitter then
		self.Particles = {}
		self.Emitter = ParticleEmitter( self:GetPos() )
	end	
	
	-- Update emitter position
	if self.Emitter then
		self.Emitter:SetPos( self:GetPos() )
	end
	
	-- Trail effect, etc
	if ( self.PuffTimer or 0 ) > CurTime() then return end
	self.PuffTimer = CurTime() + 0.02
	
	-- Properties
	local partSize = math.Rand( 15, 20 )
	if self.Sticked then partSize = math.Rand( 10,15 ) end
	 
	-- Normal trace particle
	self.Particles[1] = self.Emitter:Add( "sprites/light_glow02_add", self:GetPos() + self:GetRoundNormal() * -2.25 + ( getVectorSign( VectorRand() * 3, -1 * self:GetRoundNormal() ) ) )
	self.Particles[1]:SetVelocity( ( -1 * self:GetRoundNormal() ) + ( getVectorSign( Vector( math.Rand( -4, 4 ),math.Rand( -4, 4 ),math.Rand( -4, 4 ) ), -1 * self:GetRoundNormal() ) ) )
	self.Particles[1]:SetDieTime( 1.5 )
	self.Particles[1]:SetStartAlpha( 200 )
	self.Particles[1]:SetEndAlpha( 60 )
	self.Particles[1]:SetStartSize( partSize )
	self.Particles[1]:SetEndSize( 0 )
	self.Particles[1]:SetRoll( math.Rand( -0.2, 0.2 ) )
	self.Particles[1]:SetColor( math.random( 100, 220 ), math.random( 40, 70 ), math.random( 30, 70 ) ) 
	
	local bioVelocity = Vector( math.Rand( -4, 4 ),math.Rand( -4, 4 ),math.Rand( -4, 4 ) )
	if self.Sticked then bioVelocity = Vector( math.Rand( -8, 8 ),math.Rand( -8, 8 ),math.Rand( -8, 8 ) ) end
	
	local bioSize = math.Rand( 4.5, 6 )
	if self.Sticked then bioSize = math.Rand( 3, 4 ) end
	
	-- infected bioharzard sign
	self.Particles[2] = self.Emitter:Add( "effects/hazard_icon", self:GetPos() + self:GetRoundNormal() * -4 + ( getVectorSign( VectorRand() * 3, -1 * self:GetRoundNormal() ) ) )
	self.Particles[2]:SetVelocity( ( -1 * self:GetRoundNormal() ) + ( getVectorSign( bioVelocity, -1 * self:GetRoundNormal() ) ) )
	self.Particles[2]:SetDieTime( 1.8 )
	self.Particles[2]:SetStartAlpha( math.random( 90, 110 ) )
	self.Particles[2]:SetEndAlpha( 40 )
	self.Particles[2]:SetStartSize( bioSize )
	self.Particles[2]:SetEndSize( 0 )
	self.Particles[2]:SetRoll( math.Rand( -0.2, 0.2 ) )
	self.Particles[2]:SetColor( math.random( 100, 200 ), math.random( 10, 50 ), 30 ) 
end



