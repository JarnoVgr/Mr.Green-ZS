AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Undead Gas"

if CLIENT then
	function ENT:Initialize()
		ParticleEffect("BUTT_FART2",self:GetPos(),Angle(100,100,100),nil)
	end

	function ENT:Draw()
	end
end