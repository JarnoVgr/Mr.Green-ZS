function EFFECT:Init(data)
	self.DieTime = CurTime() + 10

	self.ent = data:GetEntity()
	self.Ragdoll = self.ent:GetRagdollEntity()
	
	--[==[if IsValid(self.Ragdoll) then
		self.Toast = CreateSound( self.Ragdoll,  "NPC_HeadCrab.Burning" ) 
	end]==]
	
end

function EFFECT:Think()
	
	if not IsValid(self.Ragdoll) then 
		--[==[if self.Toast then
			self.Toast:Stop() 
		end]==]
		return false 
	end
	
	if CurTime() < self.DieTime then
		
		--[==[if self.Toast then
			self.Toast:PlayEx(1, 95 + math.sin(RealTime())*5) 
		end]==]
		if IsValid(self.Ragdoll) then
			self.Entity:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))
			self.Entity:SetPos(self.Ragdoll:GetPos())
		end
		
		return true
	end
	return false
end

function EFFECT:Render()

	if not IsValid(self.Ragdoll) then return end
	
	local rag = self.Ragdoll
	
	rag:SetColor(Color(50,50,50,255))
	
	self.NextPuff = self.NextPuff or 0
	
	if self.NextPuff < CurTime() then
		self.NextPuff = CurTime() + 0.05

		local emitter = ParticleEmitter(rag:GetPos())
		for i=0, 25, 4 do
		local bone = rag:GetBoneMatrix(i)
			if bone then
				local pos = bone:GetTranslation()
				local particle = emitter:Add( (math.random(1,2) == 1 and ("Effects/fire_cloud"..math.random( 1, 2 ))) or "Effects/fire_embers"..math.random( 1, 3 ), pos + VectorRand():GetNormal() * math.Rand(1.6,3) )-- "particles/smokey"
				--particle:SetVelocity( Vector(math.random(-30,30),math.random(-30,30),math.random(30,80)) )
				particle:SetDieTime( math.Rand( 1.6, 1.8 ) )
				particle:SetStartAlpha( math.Rand( 200, 240 ) )
				particle:SetStartSize( 1 )
				particle:SetEndSize( math.Rand( 10, 15 ) )
				particle:SetRoll( math.Rand( 360, 480 ) )
				particle:SetRollDelta( math.Rand( -1, 1 ) )
				particle:SetColor( math.Rand( 230, 255 ), 240, 240 )
				particle:SetGravity(Vector(0, 0, 600))
				particle:SetLighting(true) 
				--particle:VelocityDecay( false )
			end		
	end

		
	end
	

end
