include("shared.lua")

function ENT:Draw()
	if self:GetModel() then
		self:DrawModel()
	end
end

function ENT:Initialize()
	self:OnInitialize()
end

function ENT:OnInitialize()

end

function ENT:Think()
end

function ENT:OnRemove()
end
