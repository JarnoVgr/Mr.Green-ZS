-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local math = math
local util = util

local NextEffect = 0

function EFFECT:Init( data )
	local ent = data:GetEntity()
	local Pos = data:GetOrigin()
	local Normal = data:GetNormal()
	local scale = math.Round(data:GetScale())
	
	if CurTime() < NextEffect then return end
	NextEffect = CurTime() + 0.2
	
	for i = 0, math.random(1,6) do
	
		local effectdata = EffectData()
			effectdata:SetOrigin( Pos + i * Vector(0,0,6) + VectorRand() * 8 )
			effectdata:SetNormal( Normal )
		util.Effect( "gib", effectdata )
		
	end
	
	self.Emitter = ParticleEmitter(self.Entity:GetPos())

	for i=1, math.random(3,15) do
		local particle = self.Emitter:Add("effects/blood_core", Pos-Vector(0,0,20)+Vector(0,0,4)*i+VectorRand()*6)
		particle:SetVelocity(VectorRand()+Vector(0,0,-10)*math.Rand(0.1,1))
		particle:SetDieTime(math.Rand(4,6))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(50)
		particle:SetStartSize(math.random(40,60))
		particle:SetEndSize(math.random(30,50))
		particle:SetRoll(math.Rand(0,3))
		particle:SetRollDelta(math.Rand(0,0.5))
		particle:SetColor(math.random(100,255), 0, 0)
		particle:SetLighting(true)
	end
	
	if IsValid(ent) then
		ent:EmitSound("physics/flesh/flesh_bloody_break.wav")
		
		local amount = ent:OBBMaxs():Length()
		local vel = ent:GetVelocity()
		util.Blood(ent:LocalToWorld(ent:OBBCenter()), math.Rand(amount * 0.25, amount * 0.5), vel:GetNormalized(), vel:Length() * 0.75)
		
	end
	
end


/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think( )

	// Die instantly
	return false
	
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()

	// Do nothing - this effect is only used to spawn the particles in Init
	
end
