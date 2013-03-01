-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

ENT.Type = "anim"

function ENT:GetNailHealth()
	return self:GetDTInt(0)
end

util.PrecacheModel("models/crossbow_bolt.mdl")
util.PrecacheSound("ambient/machines/catapult_throw.wav")