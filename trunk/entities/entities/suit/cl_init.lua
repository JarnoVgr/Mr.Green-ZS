include("shared.lua")

function ENT:Draw()  
	return false	
end  

function ENT:Think()
	if IsValid(self:GetOwner()) then
		local owner = self:GetOwner()
		if MySelf and owner == MySelf and not IsValid(MySelf.Suit) then
			MySelf.Suit = self.Entity
			MySelf.Suit.IsSuit = true
		end
	end
end
function ENT:OnRemove()

end

function ENT:GetHatType()
	return self:GetNWString("HatType") or "none"
end