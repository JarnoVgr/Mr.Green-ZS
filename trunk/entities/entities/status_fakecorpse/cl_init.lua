include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 80))
	
	local owner = self:GetOwner()
	local rag = owner:GetRagdollEntity()
	if owner:IsPlayer() then
		owner:SetNoDraw(true)
		if rag and rag:IsValid() then
			rag:SetNoDraw(true)
		end
	end
	
	--if owner.PreviousModel ~= "models/Zombie/Classic.mdl" then
	--	owner.PreviousModel = owner:GetModel()
	--end
	
	self.BodyParent = rag
	
	self:CreateBody(self.BodyParent)
	
end

function ENT:CreateBody(ent)
	if not IsValid(ent) then return end
	local owner = self:GetOwner()
	
	self.Body = ClientsideModel(owner.PreviousModel or "models/player/breen.mdl", RENDERGROUP_OPAQUE)
	self.Body:SetPos(ent:GetPos())
	self.Body:SetAngles(ent:GetAngles())
	self.Body:SetParent(ent)
	self.Body:AddEffects(bit.bor(EF_BONEMERGE , EF_BONEMERGE_FASTCULL , EF_PARENT_ANIMATES))
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsValid() then
		if rag and rag:IsValid() then
			rag:SetNoDraw(false)
		end
		if self.Body and IsValid(self.Body) then
			SafeRemoveEntity(self.Body)
			self.Body = nil
		end
	end
end

function ENT:Think()
	local ct = CurTime()
	local owner = self:GetOwner()
	local rag = owner:GetRagdollEntity()
	if owner:IsValid() then
		if self.Body and IsValid(self.Body) then
			self.Body:SetParent(self.BodyParent)
			
			local FlexNum = self.Body:GetFlexNum() - 1
	
			if (FlexNum <= 0) then return end

			for i=0, FlexNum-1 do
		
			self.Body:SetFlexWeight( i, math.Rand(0,1) )
			self.Body:SetFlexScale( i, math.Rand(0,1) )
					
			end
			
		end
	end
	return true
end

function ENT:Draw()
end
