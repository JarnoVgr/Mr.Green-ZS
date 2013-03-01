include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 80))
	
	local owner = self:GetOwner()
	if owner:IsValid() then
		owner.Revive = self
		
		local cl = owner:GetZombieClass()
		local tab = ZombieClasses[cl]
	
		if tab.OnRevive then
			tab.OnRevive(owner)
		end
		
		//owner:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
		
		local wep = owner:GetActiveWeapon()
		if wep and wep:IsValid() then
			self.WepFunc = wep.ViewModelDrawn
			wep.ViewModelDrawn = function() end
		end
	end
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsValid() then
		owner.Revive = nil
	end
end

function ENT:Think()
	if not self:IsRising() then
		local owner = self:GetOwner()
		if owner:IsValid() then
			owner:SetCycle(0)
			owner:SetPlaybackRate(0)
			
			local wep = owner:GetActiveWeapon()
			if wep and wep:IsValid() and self.WepFunc then
				wep.ViewModelDrawn = self.WepFunc
			end
		end
	end

	local endtime = self:GetReviveTime()
	if endtime == 0 then return end

	local owner = self:GetOwner()
	if owner:IsValid() then
		local rag = owner:GetRagdollEntity()
		if rag and IsValid(rag) and IsValid(rag:GetPhysicsObject()) then
			rag:GetPhysicsObject():Wake()
			rag:GetPhysicsObject():ComputeShadowControl({secondstoarrive = 0.05, pos = owner:GetPos() + Vector(0,0,16), angle = rag:GetPhysicsObject():GetAngles(), maxangular = 2000, maxangulardamp = 10000, maxspeed = 5000, maxspeeddamp = 1000, dampfactor = 0.85, teleportdistance = 200, deltatime = FrameTime()})
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:Draw()
end
