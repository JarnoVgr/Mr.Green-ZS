ENT.Type = "anim"

function ENT:PhysicsCollide(data, physobj)
end

function ENT:StartTouch(ent)
end

function ENT:Touch(ent)
end

function ENT:EndTouch(ent)
end

function ENT:AcceptInput(name, activator, caller)
end

---
-- TODO: Use native :SetHealth function instead
-- 
function ENT:_SetHealth(am)
	self:SetDTFloat(0,am)
end

function ENT:_SetMaxHealth(am)
	self:SetDTFloat(1,am)
end

function ENT:_GetHealth(am)
	return self:GetDTFloat(0)
end

function ENT:_GetMaxHealth(am)
	return self:GetDTFloat(1)
end
