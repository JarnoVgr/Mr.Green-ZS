AddCSLuaFile("shared.lua")

ENT.Type = "anim"
ENT.Base = "status__base"


if SERVER then
	AddCSLuaFile( "sh_bonemods.lua" )
end

-- Tables file
include ( "sh_bonemods.lua" )


function ENT:Initialize()
	
	if SERVER and self:GetOwner() and IsValid(self:GetOwner()) then
		self:SetDTVector(0,Vector( self:GetOwner():GetInfo( "cl_playercolor" ) ) or Vector(1,1,1) )
	end
	
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:AddEffects(bit.bor(EF_BONEMERGE , EF_BONEMERGE_FASTCULL))
	
	local pPlayer = self:GetOwner()
	if pPlayer and IsValid(pPlayer) then
		pPlayer.status_overridemodel = self
		pPlayer:SetRenderMode(RENDERMODE_NONE)
		--[==[if pPlayer.Team and pPlayer:Team() == TEAM_UNDEAD and SERVER then
			if pPlayer:IsWraith() then
				-- self:SetBoneMods("ethereal")
			elseif pPlayer:GetZombieClass() == 10 then
				if ZombieClasses[pPlayer:GetZombieClass()].IsSuperBoss then
					-- self:SetBoneMods("hate2")
				else
					self:SetBoneMods("hate")
				end
			elseif pPlayer:GetZombieClass() == 11 then
				-- self:SetBoneMods("behe")
			elseif pPlayer:GetZombieClass() == 12 then
				-- self:SetBoneMods("seeker")
			elseif pPlayer:GetZombieClass() == 13 then
				-- self:SetBoneMods("nerf")
			else
				self:ResetBoneMods()
			end
		end]==]
	end
	
	
	
end

function ENT:GetPlayerColor()
	return self:GetDTVector(0)-- self:GetOwner() and IsValid(self:GetOwner()) and Vector( self:GetOwner():GetInfo( "cl_playercolor" ) ) or Vector(1,1,1) 
end

function ENT:UsePlayerAlpha(bl)
	self:SetDTBool(0,bl)
end

function ENT:ShouldUsePlayerAlpha()
	return self:GetDTBool(0) or false
end

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer:SetRenderMode(RENDERMODE_NONE)
end

function ENT:OnRemove()
	local pPlayer = self:GetOwner()
	if pPlayer:IsValid() then
		pPlayer:SetRenderMode(RENDERMODE_NORMAL)
	end
end

function ENT:Think()

end

if CLIENT then
	function ENT:Draw()
		local owner = self:GetOwner()
		if owner:IsValid() and owner:Alive() then
		
		
			local r,g,b,a = owner:GetColor()
			
			if not self:ShouldUsePlayerAlpha() then
				self.Entity:SetColor(r,g,b,255)
			else
				self.Entity:SetColor(owner:GetColor())
			end
			
			
			self:SetParent(owner)
			-- if MySelf == owner and owner.Revive and owner.Revive:IsValid() and owner.Revive:IsRising() then return end
			self:DrawModel()
			-- print(self:GetColor())
		end
	end
end
