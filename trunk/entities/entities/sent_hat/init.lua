-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:DrawShadow(false)
	self.Entity:SetSolid(false)
	
end

function ENT:Think()
end

function ENT:SetHatType( hat )
	self.Entity:SetModel( hats[hat].Model )
	self.HatType = hat
	
	if self:GetOwner():HasBought("hatpainter") then
		local r,g,b = self:GetOwner():GetInfoNum("_zs_hatpcolR",255) or 255 ,self:GetOwner():GetInfoNum("_zs_hatpcolG",255) or 255 ,self:GetOwner():GetInfoNum("_zs_hatpcolB",255) or 255
		//self:GetOwner():PrintMessage (HUD_PRINTTALK, "You got the hat painter! Color is: "..tostring(r).." "..tostring(g).." "..tostring(b))
		self.Entity:SetColor(r,g,b,255)
	end
end

function ENT:GetHatType()
	return self.HatType or "NO HAT TYPE SPECIFIED"
end

/*---------------------------------------------------------
   Name: PhysicsCollide
---------------------------------------------------------*/
function ENT:PhysicsCollide( data, physobj )
end

/*---------------------------------------------------------
   Name: OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage( dmginfo )
end


/*---------------------------------------------------------
   Name: Use
---------------------------------------------------------*/
function ENT:Use( activator, caller )
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end



