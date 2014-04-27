include("shared.lua")


function SWEP:DrawHUD()
	if util.tobool(GetConVarNumber("_zs_hidecrosshair")) then
		return
	end
	MeleeWeaponDrawHUD()
end

local function CosineInterpolation(y1, y2, mu)
	local mu2 = (1 - math.cos(mu * math.pi)) / 2
	return y1 * (1 - mu2) + y2 * mu2
end

local ghostlerp = 0
function SWEP:GetViewModelPosition(pos, ang)
	if self:IsSwinging() then
		local rot = self.SwingRotation
		local offset = self.SwingOffset

		ang = Angle(ang.pitch, ang.yaw, ang.roll) -- Copies.
		
		local swingtime = self.SwingTime
	
		if self.Owner and self.Owner:GetSuit() == "meleesuit" then
			swingtime = math.Clamp(self.SwingTime-0.11,0,self.SwingTime)
		end
		
		local swingend = self:GetSwingEnd()
		local delta = self.SwingTime - math.max(0, swingend - CurTime())
		local power = CosineInterpolation(0, 1, delta / swingtime)

		if power >= 0.8 then
			power = (1 - power) * 4
		end

		pos = pos + offset.x * power * ang:Right() + offset.y * power * ang:Forward() + offset.z * power * ang:Up()

		ang:RotateAroundAxis(ang:Right(), rot.pitch * power)
		ang:RotateAroundAxis(ang:Up(), rot.yaw * power)
		ang:RotateAroundAxis(ang:Forward(), rot.roll * power)
	end

	if ghostlerp > 0 then
		ghostlerp = math.max(0, ghostlerp - FrameTime() * 5)
	end

	if ghostlerp > 0 then
		pos = pos + 3.5 * ghostlerp * ang:Up()
		ang:RotateAroundAxis(ang:Right(), -30 * ghostlerp)
	end

	return pos, ang
end
