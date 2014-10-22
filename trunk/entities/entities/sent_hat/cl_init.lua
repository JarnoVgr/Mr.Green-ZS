-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
end
ENT.PuffTimer = 0
function ENT:DrawTranslucent()

	local owner = self:GetOwner()
	if MySelf and owner == MySelf and not IsValid(MySelf.Hat) then
		MySelf.Hat = self.Entity
	end
	if not owner:IsValid() or not owner:Alive() or owner == MySelf or not ENABLE_HATS then return end
	if not owner:IsHuman() then return end
	
	if not self:GetHatType() then return end
	
	self.WearType = self.WearType or "Normal"
	
	-- Set global different positions for combine and CSS models
	if self.addX == nil then
		self.addX = 0
		self.addY = 0
		if table.HasValue(CombineModels,string.lower(owner:GetModel())) then
			self.addX = 2.6
			self.addY = -2
			self.WearType = "Combine"
		elseif table.HasValue(TModels,string.lower(owner:GetModel())) then 
			-- Because the urban model returns "urban.mbl", and the arctic model has uppercase "Player" in its path
			self.addX = 3.2
			if owner:GetModel() == "models/player/leet.mdl" then
				self.addX = 3.5
			end
			self.WearType = "CSS"
		elseif table.HasValue(CTModels,string.Replace(owner:GetModel(),".mbl",".mdl")) then 
			self.addX = 4
			self.WearType = "CSS"
		end
		if owner:GetModel() == "models/Police.mdl" then -- This one SHOULD return models/player/police.mdl.. but it just doesn't
			self.addX = 2
			self.WearType = "Combine"
		end
	end
	
	if self.RelPos == nil then
		-- If there are special coordinates for combine or CSS models, use those
		if self.WearType == "Combine" and hats[self:GetHatType()].CombPos then
			self.RelPos = hats[self:GetHatType()].CombPos
			self.addX = 0
			self.addY = 0
		elseif self.WearType == "CSS" and hats[self:GetHatType()].CSSPos then
			self.RelPos = hats[self:GetHatType()].CSSPos
			self.addX = 0
			self.addY = 0
		else
			self.RelPos = hats[self:GetHatType()].Pos
		end
		if hats[self:GetHatType()].SCK then
			self.RelAng = Angle(hats[self:GetHatType()].Ang.r,hats[self:GetHatType()].Ang.y,hats[self:GetHatType()].Ang.p)
		else
			self.RelAng = hats[self:GetHatType()].Ang
		end
	end
	
	if self.Scale == nil then
		if hats[self:GetHatType()].ScaleVector then
			self.Scale = hats[self:GetHatType()].ScaleVector
		end
	end
	-- switch angles so i ca add stuff from Swep Construction Kit
	if hats[self:GetHatType()].SCK then
		-- local temp = self.RelAng.p
		-- self.RelAng.p = self.RelAng.r
		-- self.RelAng.r = temp
	end
	
	-- Now draw the hat in the right spot
	local owner = self:GetOwner():GetRagdollEntity() or self:GetOwner()
	local boneindex = owner:LookupBone("ValveBiped.Bip01_Head1")

	if boneindex then
		local pos, ang = owner:GetBonePosition(boneindex)
		if pos and pos ~= owner:GetPos() then
			-- pos = pos + (ang:Forward() * (self.RelPos.x + self.addX)) + (ang:Right() * (self.RelPos.y + self.addY)) + (ang:Up() * self.RelPos.z)
			self:SetPos(pos + (ang:Forward() * (self.RelPos.x + self.addX)) + (ang:Right() * (self.RelPos.y + self.addY)) + (ang:Up() * self.RelPos.z))
			ang:RotateAroundAxis(ang:Forward(), self.RelAng.p)
			ang:RotateAroundAxis(ang:Up(), self.RelAng.y)
			ang:RotateAroundAxis(ang:Right(), self.RelAng.r)
			self:SetAngles(ang)
			self:DrawModel()
			if hats[self:GetHatType()].ScaleVector then
				self:SetModelScale ( self.Scale )
			end
			-- small piece of code for green's hat from poison headcrab's bomb (this effect is really awesome)
				if self:GetOwner():IsAdmin() then--self:GetHatType() == "greenshat" then
				
					if not self.Emitter then
						self.Particles = {}
						self.Emitter = ParticleEmitter( pos )
					end	
					if self.Emitter then
						self.Emitter:SetPos( pos )
					end
						if ( self.PuffTimer or 0 ) > CurTime() then return end
						self.PuffTimer = CurTime() + 0.2
	
						local partSize = math.Rand( 10, 15 )

						self.Particles[1] = self.Emitter:Add( "sprites/light_glow02_add", pos + self:GetRoundNormal() * -2.25 + ( getVectorSign( VectorRand() * 3, -1 * self:GetRoundNormal() ) ) )
						self.Particles[1]:SetVelocity( ( -1 * self:GetRoundNormal() ) + ( getVectorSign( Vector( math.Rand( -4, 4 ),math.Rand( -4, 4 ),math.Rand( -4, 4 ) ), -1 * self:GetRoundNormal() ) ) )
						self.Particles[1]:SetDieTime( 1.5 )
						self.Particles[1]:SetStartAlpha( 200 )
						self.Particles[1]:SetEndAlpha( 60 )
						self.Particles[1]:SetStartSize( partSize )
						self.Particles[1]:SetEndSize( 0 )
						self.Particles[1]:SetRoll( math.Rand( -0.2, 0.2 ) )
						self.Particles[1]:SetColor( math.random( 70, 90 ), math.random( 70, 200 ), math.random( 30, 70 ) ) 
		
						boneindex = owner:LookupBone("ValveBiped.Bip01_R_Hand")
						if boneindex then
						local pos, ang = owner:GetBonePosition(boneindex)
						self.Particles[2] = self.Emitter:Add( "sprites/light_glow02_add", pos + self:GetRoundNormal() * -2.25 + ( getVectorSign( VectorRand() * 3, -1 * self:GetRoundNormal() ) ) )
						self.Particles[2]:SetVelocity( ( -1 * self:GetRoundNormal() ) + ( getVectorSign( Vector( math.Rand( -4, 4 ),math.Rand( -4, 4 ),math.Rand( -4, 4 ) ), -1 * self:GetRoundNormal() ) ) )
						self.Particles[2]:SetDieTime( 1.5 )
						self.Particles[2]:SetStartAlpha( 200 )
						self.Particles[2]:SetEndAlpha( 60 )
						self.Particles[2]:SetStartSize( partSize )
						self.Particles[2]:SetEndSize( 0 )
						self.Particles[2]:SetRoll( math.Rand( -0.2, 0.2 ) )
						self.Particles[2]:SetColor( math.random( 70, 90 ), math.random( 70, 200 ), math.random( 30, 70 ) ) 
						end
						
						boneindex = owner:LookupBone("ValveBiped.Bip01_L_Hand")
						if boneindex then
						local pos, ang = owner:GetBonePosition(boneindex)
						self.Particles[3] = self.Emitter:Add( "sprites/light_glow02_add", pos + self:GetRoundNormal() * -2.25 + ( getVectorSign( VectorRand() * 3, -1 * self:GetRoundNormal() ) ) )
						self.Particles[3]:SetVelocity( ( -1 * self:GetRoundNormal() ) + ( getVectorSign( Vector( math.Rand( -4, 4 ),math.Rand( -4, 4 ),math.Rand( -4, 4 ) ), -1 * self:GetRoundNormal() ) ) )
						self.Particles[3]:SetDieTime( 1.5 )
						self.Particles[3]:SetStartAlpha( 200 )
						self.Particles[3]:SetEndAlpha( 60 )
						self.Particles[3]:SetStartSize( partSize )
						self.Particles[3]:SetEndSize( 0 )
						self.Particles[3]:SetRoll( math.Rand( -0.2, 0.2 ) )
						self.Particles[3]:SetColor( math.random( 70, 90 ), math.random( 70, 200 ), math.random( 30, 70 ) ) 
						end
						boneindex = owner:LookupBone("ValveBiped.Bip01_L_UpperArm")
						if boneindex then
						local pos, ang = owner:GetBonePosition(boneindex)
						self.Particles[4] = self.Emitter:Add( "sprites/light_glow02_add", pos + self:GetRoundNormal() * -2.25 + ( getVectorSign( VectorRand() * 3, -1 * self:GetRoundNormal() ) ) )
						self.Particles[4]:SetVelocity( ( -1 * self:GetRoundNormal() ) + ( getVectorSign( Vector( math.Rand( -4, 4 ),math.Rand( -4, 4 ),math.Rand( -4, 4 ) ), -1 * self:GetRoundNormal() ) ) )
						self.Particles[4]:SetDieTime( 1.5 )
						self.Particles[4]:SetStartAlpha( 200 )
						self.Particles[4]:SetEndAlpha( 60 )
						self.Particles[4]:SetStartSize( partSize )
						self.Particles[4]:SetEndSize( 0 )
						self.Particles[4]:SetRoll( math.Rand( -0.2, 0.2 ) )
						self.Particles[4]:SetColor( math.random( 70, 90 ), math.random( 70, 200 ), math.random( 30, 70 ) ) 
						end
						
						boneindex = owner:LookupBone("ValveBiped.Bip01_R_UpperArm")
						if boneindex then
						local pos, ang = owner:GetBonePosition(boneindex)
						self.Particles[5] = self.Emitter:Add( "sprites/light_glow02_add", pos + self:GetRoundNormal() * -2.25 + ( getVectorSign( VectorRand() * 3, -1 * self:GetRoundNormal() ) ) )
						self.Particles[5]:SetVelocity( ( -1 * self:GetRoundNormal() ) + ( getVectorSign( Vector( math.Rand( -4, 4 ),math.Rand( -4, 4 ),math.Rand( -4, 4 ) ), -1 * self:GetRoundNormal() ) ) )
						self.Particles[5]:SetDieTime( 1.5 )
						self.Particles[5]:SetStartAlpha( 200 )
						self.Particles[5]:SetEndAlpha( 60 )
						self.Particles[5]:SetStartSize( partSize )
						self.Particles[5]:SetEndSize( 0 )
						self.Particles[5]:SetRoll( math.Rand( -0.2, 0.2 ) )
						self.Particles[5]:SetColor( math.random( 70, 90 ), math.random( 70, 200 ), math.random( 30, 70 ) ) 
						end
						
						end
			return
		end
	end
	
	
	-- Ex-ragdoll attaching code, no longer needed since hats drop off players when they die
	--[=[local attach = owner:GetAttachment(owner:LookupAttachment("eyes"))
	if not attach then attach = owner:GetAttachment(owner:LookupAttachment("head")) end
	if attach then
		local r,g,b,a = owner:GetColor()
		self:SetColor(r,g,b,math.max(1,a))
		local ang = attach.Ang
		self:SetPos(attach.Pos + ang:Up() * 3 + ang:Forward() * -2.5)
		ang:RotateAroundAxis(ang:Up(), 270)
		self:SetAngles(ang)

		self:DrawModel()
	end]=]
end

function ENT:Draw()
	self:DrawTranslucent()	
end

function ENT:GetRoundNormal()
	return Vector( math.Round( self:GetHitNormal().X ), math.Round( self:GetHitNormal().Y ), math.Round( self:GetHitNormal().Z ) )
end	

function ENT:GetHatType()
	if not self.Entity.HatType then
		for k, v in pairs(hats) do
			if string.lower(self.Entity:GetModel()) == string.lower(v.Model) then
				self.Entity.HatType = k
			end
		end
	end
	return self.Entity.HatType
end
