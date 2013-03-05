ENT.Type = "anim"
ENT.Base = "status_revive_slump"

function ENT:SetZombieInitializeTime(time)
	self:SetDTFloat(1, time)
end

function ENT:GetZombieInitializeTime()
	return self:GetDTFloat(1)
end

function ENT:GetRagdollEyes(pl)
	local attachid = pl:LookupAttachment("eyes")
	if attachid then
		local attach = pl:GetAttachment(attachid)
		if attach then
			return (attach.Pos + attach.Ang:Forward() * 11 + attach.Ang:Right()*2), attach.Ang
		end
	end
end

if CLIENT then
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
		
		-- owner:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
		
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

end