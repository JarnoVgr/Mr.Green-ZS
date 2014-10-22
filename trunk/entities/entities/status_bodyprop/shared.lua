AddCSLuaFile("shared.lua")

ENT.Type = "anim"
ENT.Base = "status__base"

function ENT:Initialize()
	
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)	
	if SERVER then
		self:SetModel("models/Gibs/HGIBS.mdl")
	end
end

function ENT:Think()
	if SERVER then
		if not IsValid(self:GetOwner()) or not self:GetOwner():Alive() then
			self:Remove()
		end
	end
end

if CLIENT then
	function ENT:Draw()
	local owner = self:GetOwner()
	if owner:IsValid() and owner:Alive() then
	local ply = self:GetOwner():GetRagdollEntity() or owner
	-- local bone = ply:LookupBone(bonename)  
	if bone then  
		local position, angles = ply:GetBonePosition(bone)
		
		-- local localpos = self:GetDTVector(0)
		-- local localang = self:GetDTAngle(0)

		-- local newpos, newang = LocalToWorld( localpos, localang, position, angles ) 

		-- self:SetPos(newpos)  
		-- self:SetAngles(newang)  
		
		self:DrawModel()
		
		end
	end
end
end
