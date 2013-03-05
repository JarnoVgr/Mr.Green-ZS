include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 80))
	
	local owner = self:GetOwner()
	if owner:IsPlayer() then
		--owner:SetNoDraw(true)
		owner:SetColor(0,0,0,0)
		owner:DrawShadow( false )
	end
	
	local rag = owner:GetRagdollEntity()
	
	self.BodyParent = owner
	
	self:CreateBody(self.BodyParent)
	
end

function ENT:CreateBody(ent)
	if not IsValid(ent) then return end
	self.Body = ClientsideModel(ent.PreviousModel or ent:GetModel(), RENDERGROUP_OPAQUE)
	self.Body:SetPos(ent:GetPos())
	self.Body:SetAngles(ent:GetAngles())
	self.Body:SetParent(ent)
	self.Body:AddEffects(bit.bor(EF_BONEMERGE , EF_BONEMERGE_FASTCULL , EF_PARENT_ANIMATES))	
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsValid() then

		owner:DrawShadow( true )
		-- owner:SetNoDraw(false)
		if self.Body and IsValid(self.Body) then
			SafeRemoveEntity(self.Body)
			self.Body = nil
		end
		owner:SetColor(255,255,255,255)
		
	end
end

function ENT:Think()
	local ct = CurTime()
	local owner = self:GetOwner()
	if owner:IsValid() then
		if self.Body and IsValid(self.Body) then
			self.Body:SetParent(self.BodyParent)
			owner:SetColor(0,0,0,0)
			owner:DrawShadow( false )
		end
	end
	return true
end

function ENT:Draw()
end
