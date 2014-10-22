-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end

-- local function Collide (particle, hitpos, hitnormal)
	-- particle:SetDieTime (0)
	-- if math.random (1,3) == 1 then
		-- sound.Play ("physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav",hitpos,80,math.random (80,100))
	-- end
	-- util.Decal ("Impact.Antlion", hitpos + hitnormal, hitpos - hitnormal)
-- end


function EFFECT:Init ( data )
	local pos = data:GetOrigin()
	local normal = data:GetNormal() * -1
	
	-- local emitter = ParticleEmitter (pos)
	-- emitter:SetNearClip (20,32)
	-- local gravity = Vector (0,0,-480)
	
	-- for i=1,5 do
		-- local particle = emitter:Add ("decals/Yblood"..math.random(1,5), pos)
		-- particle:SetVelocity (VectorRand():Normalize() * math.Rand (15,40))
		-- particle:SetDieTime (math.Rand (2,4))
		-- particle:SetStartAlpha (255)
		-- particle:SetEndAlpha (50)
		-- particle:SetStartSize (math.Rand (2,5))
		-- particle:SetEndSize (0)
		-- particle:SetRoll (math.Rand (0,360))
		-- particle:SetRollDelta (math.Rand (-1,1))
		-- particle:SetCollide(true)
		-- particle:SetBounce (0)
		-- particle:SetCollideCallback (Collide)
	-- end
	-- emitter:Finish()
	
	util.Decal ("YellowBlood", pos+normal, pos-normal)
	sound.Play ("physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav",pos,80,math.random (80,100))
end