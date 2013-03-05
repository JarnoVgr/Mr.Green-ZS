AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	self.HealCarryOver = self.HealCarryOver or 0

	pPlayer.Revive = self
	pPlayer:Freeze(true)
	if not bExists then
		pPlayer:GodEnable()
		self.GodDisableTime = CurTime() + 0.1
	end

	local cl = pPlayer:GetZombieClass()
	local tab = ZombieClasses[cl]
	
	if tab.OnRevive then
		tab.OnRevive(pPlayer)
	end
	
	-- pPlayer:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)

end

function ENT:Think()
	local fCurTime = CurTime()
	local owner = self:GetOwner()
	if owner:IsValid() then
		if self:GetReviveTime() <= fCurTime or not owner:Alive() then
			self:Remove()
			return
		end

		if not self:IsRising() then
			owner:SetCycle(0)
			owner:SetPlaybackRate(0)
		end

		if self.GodDisableTime and fCurTime >= self.GodDisableTime then
			owner:GodDisable()
			self.GodDisableTime = nil
		end

		self.HealCarryOver = self.HealCarryOver + FrameTime() * 15
		if self.HealCarryOver >= 1 then
			local toheal = math.floor(self.HealCarryOver)
			owner:SetHealth(math.min(owner:GetMaxHealth(), owner:Health() + toheal))
			self.HealCarryOver = self.HealCarryOver - toheal
		end
	end

	self:NextThink(fCurTime)
	return true
end

function ENT:OnRemove()
	local parent = self:GetOwner()
	if parent:IsValid() then
		parent.Revive = nil
		parent:Freeze(false)
		parent:GodDisable()
		--[=[if not parent:Alive() then
			parent:SecondWind()
		end]=]
	end
end
