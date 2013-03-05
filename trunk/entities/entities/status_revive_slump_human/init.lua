AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Think()
	local fCurTime = CurTime()
	local owner = self:GetOwner()
	if owner:IsValid() then
		local zombietime = self:GetZombieInitializeTime()
		if zombietime > 0 and CurTime() >= zombietime then
			self:SetZombieInitializeTime(0)

			if not owner:Alive() then
				owner.LastModel = owner:GetModel()
				owner:SecondWind()
				owner:SetModel(owner.LastModel or owner:GetModel())
				owner:SetRandomFace()
				owner:Freeze(true)
				owner:TemporaryNoCollide()
				-- local status2 = owner:GiveStatus("overridemodel")
				-- if status2:IsValid() then
				-- 	status2:SetModel(owner.LastModel or owner:GetModel())
				-- end
				-- owner:TemporaryNoCollide()
			end
		end

		if self:GetReviveTime() <= fCurTime then
			self:Remove()
			return
		end

		if not self:IsRising() then
			-- owner:SetCycle(0)
			-- owner:SetPlaybackRate(0)
		end

	end

	self:NextThink(fCurTime)
	return true
end
