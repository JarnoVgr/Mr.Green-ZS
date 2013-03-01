AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.FakeBody = true
end

function ENT:OnRemove()
	local parent = self:GetParent()
	if parent:IsValid() then
		parent.FakeBody = nil
	end
end

function ENT:Think()
	local owner = self:GetOwner()
	if owner:Alive() then 
		owner:GiveStatus("fakebody", -1)
		self:Remove() 
	end
end

