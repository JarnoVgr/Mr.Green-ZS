ENT.Type = "anim"
ENT.Base = "status_revive_slump"


function ENT:GetRagdollEyes(pl)
	local attachid = pl:LookupAttachment("head")
	if attachid then
		local attach = pl:GetAttachment(attachid)
		if attach then
			return (attach.Pos + attach.Ang:Forward() * 11 + attach.Ang:Right()*2), attach.Ang
		end
	end
end

function ENT:IsRising()
	return self:GetReviveTime() - (self:GetReviveDuration() or 1.9) <= CurTime()
end

function ENT:SetReviveTime(tim)
	self:SetDTFloat(0, tim)
end

function ENT:SetReviveDuration(tim)
	self:SetDTFloat(2, tim)
end

function ENT:GetReviveDuration()
	return self:GetDTFloat(2)
end

function ENT:GetReviveTime()
	return self:GetDTFloat(0)
end

function ENT:SetZombieInitializeTime(time)
	self:SetDTFloat(1, time)
end

function ENT:GetZombieInitializeTime()
	return self:GetDTFloat(1)
end
