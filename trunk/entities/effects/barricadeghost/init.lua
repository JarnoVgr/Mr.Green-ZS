function EFFECT:Init(data)
	self.Entity:SetModel("models/props_debris/wood_board03a.mdl") --models/props_debris/wood_board04a.mdl

	local yaw = math.Clamp(tonumber(GetConVarNumber("zs_barricadekityaw")), -180, 180)
	local aimvec = MySelf:GetAimVector()
	local shootpos = MySelf:GetShootPos()
	local tr = util.TraceLine({start = shootpos, endpos = shootpos + aimvec * 65, filter = MySelf})

	self.Entity:SetPos(tr.HitPos)
	
	local norm = tr.HitNormal*-1
	local ang = norm:Angle()
	
	local right = ang:Right():Angle()
	right:RotateAroundAxis(ang:Forward(), yaw)
	local forw = right:Right()*-1
	right = right:Forward()

	
	local tr1 = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos + right * 61, filter = MySelf})
	local tr2 = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos + right * -61, filter = MySelf})
	local tr3 = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos + forw * 1, filter = MySelf})
	
	local case1 = ((tr1.HitWorld or tr2.HitWorld ) and tr3.HitWorld)
	local case2 = ((tr1.HitWorld and tr2.HitWorld ) and not tr3.HitWorld)
	local case3 = ((not tr1.HitWorld and tr2.HitWorld ) and tr3.HitWorld)
	local case4 = ((tr1.HitWorld and not tr2.HitWorld ) and tr3.HitWorld)
	
	--local tr1r = util.TraceLine({start = tr.HitPos + right * 42, endpos = tr.HitPos + right * 40, filter = MySelf})
	--local tr2l = util.TraceLine({start = tr.HitPos + right * -42, endpos = tr.HitPos + right * -40, filter = MySelf})
	--if ((tr1.HitWorld or tr2.HitWorld ) and tr3.HitWorld or (tr1.HitWorld or tr2.HitWorld ) and not tr3.HitWorld or (not tr1.HitWorld or not tr2.HitWorld ) and tr3.HitWorld) and not tr1.HitSky and not tr2.HitSky then
	if (case1 or case2 or case3 or case4) and not tr1.HitSky and not tr2.HitSky then
			if not (tr1.HitEntity and tr1.HitEntity:IsValid() and tr1.HitEntity:IsPlayer() and tr2.HitEntity and tr2.HitEntity:IsValid() and tr2.HitEntity:IsPlayer()) then
			self.Entity:SetColor(30, 255, 30, 180)
			end
	else
			self.Entity:SetColor(255, 0, 0, 180)
	end

	
	
	--if tr.HitNonWorld or tr.HitSky then
		--self.Entity:SetColor(255, 0, 0, 180)
	--elseif tr.HitWorld then
		--self.Entity:SetColor(30, 255, 30, 180)
	--else

	
	ang.roll = math.NormalizeAngle(90 + yaw)

	self.Entity:SetAngles(ang)
	self.DieTime = RealTime() + 0.04
end

function EFFECT:Think()
	return RealTime() < self.DieTime
end

function EFFECT:Render()
	self.Entity:SetMaterial("models/debug/debugwhite")
	self.Entity:DrawModel()
end