-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")


-- Normal set data
ENT.Table = {
	--Duby: This is the new crate model.
	["Ammo"] = { Model = "models/items/item_item_crate.mdl", Position = Vector ( -0.1039, 16, 24 ), Angles = Angle ( 0, 180, 0 ) },
	["Shotgun"] = { Model = "models/items/item_item_crate.mdl", Position = Vector ( -0.1039, 34.8135, 0 ), Angles = Angle ( 0, 80, 0 ) },
	["AmmoUp"] = { Model = "models/items/item_item_crate.mdl", Position = Vector ( -2.1039, 10.8135, 0 ), Angles = Angle ( 0, -80, 0 ) },
	["Vial"] = { Model = "models/weapons/w_shot_xm1014.mdl", Position = Vector ( 16, 10.8135, 18 ), Angles = Angle ( 100, -90, 180 ) },
	["Ammo2"] = { Model = "models/weapons/w_shot_xm1014.mdl", Position = Vector ( -18, 10.8135, 18 ), Angles = Angle ( 100, -90, 180 ) },
	["AmmoUp5"] = { Model = "models/greenshat/greenshat.mdl", Position = Vector ( -0.1039, 10, 48 ), Angles = Angle ( 0, -180, 0 ) },
	
	--Necros old crate:
	--["AmmoUp"] = { Model = "models/items/item_item_crate.mdl", Position = Vector ( -2.1039, 18.8135, 0 ), Angles = Angle ( 0, -180, 0 ) }, --Old
	--["Shotgun"] = { Model = "models/weapons/w_shot_xm1014.mdl", Position = Vector ( -7.1762, -10.9928, 24 ), Angles = Angle ( -1.297 ,60 ,-89.158 ) }, --Old
	--["Ammo"] = { Model = "models/items/boxbuckshot.mdl", Position = Vector ( 4.6052 ,-6.7138, 23 ), Angles = Angle ( -0.336 , -115 ,0.072 ) }, --Old
	["Vial2"] = { Model = "models/healthvial.mdl", Position = Vector ( -11.5952, -10, 25.5 ), Angles = Angle ( 0.726, -66.560, -90.018 ) }, --Old 
}

-- Precache their models
for k,v in pairs(ENT.Table) do
	util.PrecacheModel(v.Model)
end

--Check penetration
ENT.PenetrationCheckTimes = 4


function ENT:Initialize()
	--Spawn the main parent prop 
	self:SetModel(self.Table["AmmoUp"].Model)
	self:SetAngles(self.Table["AmmoUp"].Angles)

	
	--self:PhysicsInit(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false)
	self.AmmoCrate = true
	
	--Effect for parent
	local effectdata = EffectData()
	effectdata:SetEntity( self )
	util.Effect("ammo_spawn_effect", effectdata, nil, true)
	
	-- Freeze the main prop
	local Phys = self:GetPhysicsObject()
	if Phys:IsValid() then 
		Phys:EnableMotion ( false )
	end
	
	local i = 0
	
	-- Now spawn the rest
	for k,v in pairs ( self.Table ) do
		if k ~= "AmmoUp" then

			i = i + 1
			
			local Ent = ents.Create ("prop_physics")-- _multiplayer
			Ent:SetModel ( v.Model )
			Ent:SetAngles ( v.Angles )
			
			-- Actually set position
			Ent:SetPos ( self:GetPos() + Vector ( v.Position.x, v.Position.y, v.Position.z ) )
			Ent:SetKeyValue ( "minhealthdmg", 600 )
			-- Ent:SetKeyValue ( "PerformanceMode", 3 ) 
			
			-- Delete the children when the parent is removed
			Ent:SetOwner ( self )
			
			-- Physics properties
			Ent:PhysicsInit( SOLID_VPHYSICS )
			Ent:SetMoveType( MOVETYPE_NONE )
			Ent:DrawShadow ( false )
			Ent:SetUseType( SIMPLE_USE )
			
			-- Prevent unnecessary collisions
			 if k == "Ammo" or k == "Shotgun" or k == "Vial" or k == "AmmoUp5" or k == "Ammo2" or k == "Vial2" or k == ""  then
				--Ent:SetCollisionGroup ( COLLISION_GROUP_DEBRIS_TRIGGER )
				Ent:SetCollisionGroup ( SOLID_VPHYSICS )
			end
			
			Ent:Spawn()
			Ent.AmmoCrate = true
			
			-- Effect for parent
			local effectdata = EffectData()
			effectdata:SetEntity( Ent )
			util.Effect( "ammo_spawn_effect", effectdata, nil, true )
			
			-- Freeze them
			local Phys = Ent:GetPhysicsObject()
			if Phys:IsValid() then 
				Phys:EnableMotion ( false )
			end
			
			-- Sync
			self:SetDTEntity( i, Ent )
		end
	end
end

function ENT:Think()
	if (self.PenetrationCheckTime or 0) >= CurTime() then
		return
	end

	if self.GetCreationTime and (self:GetCreationTime() + ( self.PenetrationCheckTimes or 4 )) <= CurTime() then
		return
	end

	local blocks = ents.FindInBox(self:LocalToWorld(self:OBBMins() * 0.7), self:LocalToWorld(self:OBBMaxs() * 0.7))
	
	for k,v in pairs(blocks) do
		if not v:IsPlayer() then
			continue
		end

		local phys = v:GetPhysicsObject()
		if not IsValid( phys ) then
			continue
		end
		
		local vel = VectorRand() * 10000
		vel.z = 0
					   
		phys:SetVelocity(vel)
	end
			
	self.PenetrationCheckTime = CurTime() + 1
end

function ENT:OnRemove()
	local children = self:GetEntities()
	for k,v in pairs(children) do
		if not IsValid(v) then
			continue
		end
		
		v:Remove()
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end