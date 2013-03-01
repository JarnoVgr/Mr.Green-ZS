include("shared.lua")

function ENT:OnRemove()
	if MySelf == self:GetOwner() and self.Rotating then
		//hook.Remove("CreateMove", "HoldingCreateMove")
	end
end
