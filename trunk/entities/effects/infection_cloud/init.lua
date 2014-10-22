-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local math = math
local util = util

function EFFECT:Init( data )
	self.Zombie = data:GetEntity()
	if not self:IsEntityValid() then return end
	
	local colr,colg
	
	if self.Zombie:Health() > ZombieClasses[self.Zombie:GetZombieClass()].Health then
		colr = math.random( 190, 255 )
		colg = math.random( 0, 20 )
		alpha = 220
	else
		colr = math.random( 0, 20 )
		colg = math.random( 190, 255 )
		alpha = 80
	end
	
	--[=[	-- Effect size and pos
	self.Size, self.Pos = 35, self:GetCenter()
	if self.Zombie:IsHeadcrab() or self.Zombie:IsPoisonCrab() then
		self.Size = 22
	end
	
	self.Particles = {}
	self:SetPos( self:GetCenter() )
	self.Emitter = ParticleEmitter( self.Pos )

	for i = 1, 2 do
		self.Particles[i] = self.Emitter:Add( "particle/smokestack", self:GetPos() )
	end
	
	if self.Particles then
		for i = 1, 2 do
			self.Particles[i]:SetVelocity( Vector( 0,0,0 ) )
			self.Particles[i]:SetDieTime(90000)
			self.Particles[i]:SetStartAlpha(alpha)
			self.Particles[i]:SetPos( self:GetPos() )
			self.Particles[i]:SetEndAlpha(alpha)
			self.Particles[i]:SetStartSize( self.Size )
			self.Particles[i]:SetEndSize( self.Size )
			self.Particles[i]:SetColor( colr, colg, 20 )
		end
	end]=]
end

-- Calculate position
function EFFECT:GetCenter()
	if self:IsEntityValid() then
		if self.Zombie:IsHeadcrab() or self.Zombie:IsPoisonCrab() then
			return self.Zombie:GetPos() + Vector( 0,0,11.5 )
		end
		
		return self.Zombie:LocalToWorld( self.Zombie:OBBCenter() )
	end
	
	return Vector( 0,0,0 )
end

-- Finish effect
function EFFECT:Finish()
	--[=[if self.Emitter then
		self.Emitter:Finish() 
	end
	
	-- Erase particles
	if self.Particles then
		for i = 1, 2 do
			self.Particles[i]:SetDieTime( 0.01 )
		end
	end]=]
	
	-- Effect status
	if IsValid( self.Zombie ) then
		self.Zombie.EffectActive = false
		self.Zombie:SetMaterial("")
	end
	
	return false
end

function EFFECT:IsEntityValid()
	return IsValid( self.Zombie ) and self.Zombie:IsPlayer() and self.Zombie:IsZombie() and self.Zombie:Alive() and (self.Zombie:IsZombieInAura() or (self.Zombie:Health() > ZombieClasses[self.Zombie:GetZombieClass()].Health and not self.Zombie:IsSteroidZombie())  )
end

function EFFECT:Think()
	if not self:IsEntityValid() then 
		return self:Finish()
	end	

	-- Update emitter position
	self:SetPos( self:GetCenter() )
	
	return true
end

function CollideCallback(particle, hitpos, hitnormal)
	if not particle.HitAlready then
		particle.HitAlready = true
	local pos = hitpos + hitnormal

	if math.random(1, 10) == 3 then
		-- sound.Play("physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav", hitpos, 50, math.random(95, 105))
	end
	
	if hitnormal.z < -0.5 then
		local effectdata = EffectData()
			effectdata:SetOrigin( hitpos )
			effectdata:SetNormal( hitnormal )
		util.Effect( "bloodsplash", effectdata )
	else
		if math.random(1,2) == 1 then
			util.Decal("Blood", hitpos + hitnormal, hitpos - hitnormal)
		else
			util.Decal("Impact.Flesh", hitpos + hitnormal, hitpos - hitnormal)
		end
	end

	particle:SetDieTime(0)
	end
end

function EFFECT:Render()
	
	self.Em = self.Em or 0
	
	if ( self.Em or 0 ) > CurTime() then return end
	self.Em = CurTime() + 0.15
	if self.Zombie and self.Zombie:IsValid() then
		self.Zombie:SetMaterial("models/flesh")
		local emitter = ParticleEmitter(self.Zombie:GetPos())
		for i=0, 25, 4 do
		local bone = self.Zombie:GetBoneMatrix(i)
			if bone then
				local pos = bone:GetTranslation()
				local particle = emitter:Add( "decals/blood_spray"..math.random(1,8), pos )-- "particles/smokey"
				particle:SetVelocity( Vector(math.Rand(-4,4)/3,math.Rand(-4,4)/3,1):GetNormal()*math.Rand( 1, 30 ) )
				particle:SetDieTime( math.Rand(0.8,1.4) )
				particle:SetStartAlpha(alpha)
				particle:SetEndAlpha(0)
				particle:SetStartSize( math.Rand( 0, 2 ) )
				particle:SetEndSize( math.Rand( 5, 13 ) )
				particle:SetRoll( math.Rand( -0.7, 0.7 ) )
				particle:SetColor( colr, colg, 0 )
				particle:SetCollide(true)
				particle:SetCollideCallback(CollideCallback)				
				particle:SetBounce( 1 )
			end		
	end
	end
	


	--[=[if self.Particles then
		for i = 1, 2 do
			self.Particles[i]:SetPos( self:GetPos() )
		end
	end]=]
	
end
