AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Think()
	local fCurTime = CurTime()
	local owner = self:GetOwner()
	if owner:IsValid() then
		local zombietime = self:GetZombieInitializeTime()
		if zombietime > 0 and CurTime() >= zombietime then
			self:SetZombieInitializeTime(0)
			owner:Freeze(true)
		end

		if self:GetReviveTime() <= fCurTime then
			self:Remove()
			return
		end

		if not self:IsRising() then
			owner:SetCycle(0)
			owner:SetPlaybackRate(0)
		end

	end

	self:NextThink(fCurTime)
	return true
end
