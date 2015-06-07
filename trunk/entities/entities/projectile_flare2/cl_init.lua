include("shared.lua")

function ENT:Draw()
	self:DrawModel()
	
	local dlight = DynamicLight( self:EntIndex() )
	
	if ( dlight ) then
		dlight.Pos = self:GetPos()
		dlight.r = 255
		dlight.g = 20
		dlight.b = 20
		dlight.Brightness = 1
		dlight.Size = 200
		dlight.Decay = 200 * 5
		dlight.DieTime = CurTime() + 0.1
		dlight.Style = 0
	end	
end

function ENT:Initialize()
	self.Emitter = ParticleEmitter(self:GetPos())
	--self.Emitter:SetNearClip(48, 64)
	
	self.BurnSound = CreateSound( self, "Weapon_FlareGun.Burn" )  
	
	
end

function ENT:Think()
	
	if self.BurnSound then
		self.BurnSound:PlayEx(1, 85 + math.sin(RealTime())*5) 
	end
	
	self.NextPuff = self.NextPuff or 0

	if self.NextPuff < CurTime() then
		local emitter = self.Emitter
		local pos = self:GetPos()
		emitter:SetPos(pos)

		local particle = emitter:Add("particles/smokey", pos)
		particle:SetVelocity(VectorRand():GetNormal() * math.Rand(2, 20) +vector_up*math.random(3,10))
		particle:SetDieTime(math.Rand(0.2, 0.3))
		particle:SetStartAlpha(100)
		particle:SetEndAlpha(0)
		particle:SetStartSize(0.20)
		particle:SetEndSize(math.Rand(12, 20))
		particle:SetRoll(math.Rand(-0.2, 0.2))
		particle:SetColor(255, 50, 50)
		self.NextPuff = CurTime() + 0.005
	end
end

function ENT:OnRemove()
	
	self.Emitter:Finish()
	if self.BurnSound then
		self.BurnSound:Stop() 
	end
	
end
