AddCSLuaFile("shared.lua")

ENT.Type = "anim"
ENT.Base = "status__base"

function ENT:Think()
end

function ENT:SetType(int)
	self:SetDTInt(0,int)
end

function ENT:GetType()
	return self:GetDTInt(0)
end



