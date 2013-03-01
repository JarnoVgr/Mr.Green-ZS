function EFFECT:Think()
	return false
end

function EFFECT:Render()
end

local function CollideCallback(particle, hitpos, hitnormal)
	particle:SetDieTime(0)
	if math.random(1, 3) == 1 then
		WorldSound("physics/flesh/flesh_bloody_impact_hard1.wav", hitpos, 50, math.random(95, 105))
	end

		if math.random(1,2) == 1 then
			util.Decal("Impact.Flesh", hitpos + hitnormal, hitpos - hitnormal)
		else
			util.Decal("Blood", hitpos + hitnormal, hitpos - hitnormal)
		end
end

function EFFECT:Init(data)
	self.ent = data:GetEntity()
	local pos = data:GetOrigin()
	local normal = data:GetNormal() * 1
	
	if not IsValid(self.ent) then return end
	
	if self.ent:IsHuman() then
		local bone = self.ent:LookupBone("ValveBiped.Bip01_Spine"..math.random(1,4).."")
		if bone then
		local bpos, bang = self.ent:GetBonePosition(bone)
			if bpos then
				pos = bpos
				--normal = bang:Right()
			end
		else
			return
		end
	
	
	end
	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(28, 32)
	local grav = Vector(0, 0, -535)
	for i=1, math.random(3, 8) do
		local particle = emitter:Add("decals/blood_spray"..math.random(1,8), pos)
		particle:SetVelocity(normal*math.random(100,150) + VectorRand():GetNormal() * math.Rand(8, 24))
		particle:SetDieTime(math.Rand(2.5, 4.0))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(50)
		particle:SetStartSize(math.Rand(3, 7))
		particle:SetColor(255, 0, 0)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetAirResistance(0)
		particle:SetCollide(true)
		particle:SetBounce(0)
		particle:SetGravity(grav)
		particle:SetCollideCallback(CollideCallback)
	end
	emitter:Finish()

	util.Decal("Blood", pos + normal, pos - normal)

	--WorldSound("physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav", pos, 80, math.random(95, 110))
end
