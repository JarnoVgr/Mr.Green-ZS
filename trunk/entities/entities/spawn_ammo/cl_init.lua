-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

include("shared.lua")

local ents = ents
local util = util
local cam = cam
local render = render
local pairs = pairs
local table = table

function ENT:Draw()
	self:DrawEntityOutline()
	self:DrawModel()
end

local matOutlineWhite = Material( "white_outline" )

--[==[----------------------------------------------------
    Used to control the colors for outline thing
-----------------------------------------------------]==]
ENT.DrawOutline, ENT.LineColor = false, Color ( 255,0,0,255 )
function PlayerThinkTargetID()
	if not ValidEntity ( MySelf ) then return end

	-- Main trace
	local vStart = MySelf:GetShootPos()
	local tr = util.TraceLine ( { start = vStart, endpos = vStart + ( MySelf:GetAimVector() * 5000 ),filter = MySelf, mask = MASK_SHOT } )
	local ent = tr.Entity
	
	-- Reset outline bool
	for k,v in pairs ( ents.FindByClass ("spawn_ammo" ) ) do
		v.DrawOutline = false
	end
	
	if not ValidEntity ( ent ) then return end

	-- if the trace hit the parent or one of it's children then make it glow
	if ent:GetClass() == "spawn_ammo" then
		ent.DrawOutline = true
	end
	
	if ent:GetClass() == "prop_physics_multiplayer" then
		for k,v in pairs ( ents.FindInSphere ( ent:GetPos(), 100 ) ) do
			if IsEntityValid( v )  and v:GetClass() == "spawn_ammo" then
				if ValidEntity ( ent:GetOwner() ) and ent:GetOwner() == v then
					v.DrawOutline = true
				end
			end
		end	
	end
end

function ENT:OnRemove()
end

--[==[----------------------------------------------
    Returns entity children / clientside
-----------------------------------------------]==]
function ENT:GetChildren()
	--[==[local Parent, Children = self.Entity, {}
	for k,v in pairs ( ents.FindByClass("prop_physics_multiplayer") ) do-- ents.FindInSphere ( self.Entity:GetPos(), 100 )
		if IsEntityValid( v ) and v:GetClass() == "prop_physics_multiplayer" and v:GetPos():Distance(self.Entity:GetPos()) <= 100 then
			if ValidEntity ( v:GetOwner() ) and v:GetOwner() == Parent then
				table.insert ( Children, v )
			end
		end
	end
	table.insert ( Children, Parent )]==]
	
	return self.Children or {}
end
 
 
function ENT:DrawEntityOutline()
	if not ValidEntity ( MySelf ) or MySelf:Team() ~= TEAM_HUMAN then return end
	
	local outline = false
	
	
	if util.tobool(GetConVarNumber("_zs_drawcrateoutline")) then
		cam.Start3D ( EyePos(), EyeAngles() )
		
			render.ClearStencil()
			render.SetStencilEnable( true )
			
			render.SetStencilFailOperation( STENCILOPERATION_KEEP )
			render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )
			render.SetStencilPassOperation( STENCILOPERATION_KEEP )
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
			render.SetStencilReferenceValue( 1 )
			
			outline = true
			
			render.SetStencilReferenceValue( 2 )
				
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
			render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
			
			render.SetStencilEnable( false )
		cam.End3D()
	end
	
	-- Choose the color
	local LineColor = Color ( 210, 0,0, 255 )
	if (not GAMEMODE:GetFighting() and GAMEMODE:GetWave() ~= 6) then
		LineColor = Color ( 0, math.abs ( 200 * math.sin ( CurTime() * 3 ) ),0, 255 )
	end

	local todraw = self:GetChildren()
	
	
	-- Supress light for the children
	-- render.SuppressEngineLighting( true )
	-- render.SetAmbientLight( 1, 1, 1 )
	-- render.SetColorModulation( 1, 1, 1 )

	-- Children props
	cam.Start3D ( EyePos(), EyeAngles() )
		for k,v in pairs ( todraw ) do
			render.SuppressEngineLighting( true )
			render.SetAmbientLight( 1, 1, 1 )
			render.SetColorModulation( 1, 1, 1 )
				
			--  First Outline       
			v:SetModelScale( v:GetModelScale() * 1.03,0 )
			render.ModelMaterialOverride( matOutlineWhite )
			render.SetColorModulation( LineColor.r / 255, LineColor.g / 255, LineColor.b / 255 )
			if outline then cam.IgnoreZ(true) end
			v:DrawModel()
			if outline then cam.IgnoreZ(false) end
			
			--  Revert everything back to how it should be
			render.ModelMaterialOverride( nil )
			v:SetModelScale( 1,0 )
			
			
			render.SuppressEngineLighting( false )
			local c = v:GetColor()
			local r, g, b = c.r, c.g, c.b
			render.SetColorModulation( r / 255, g / 255, b / 255 )
			-- v:DrawModel()
		end		
	cam.End3D()
	
	for k,v in pairs ( todraw ) do
		if v ~= self then
			v:SetModelScale( 1,0 )
			v:DrawModel()
		end
	end
	
	--[==[-- Supress light for the parent
	render.SuppressEngineLighting( true )
	-- render.SetAmbientLight( 1, 1, 1 )
	render.SetColorModulation( 1, 1, 1 )
		   
	--  First Outline       
	self:SetModelScale( self:GetModelScale() * 1.03,0 )
	render.ModelMaterialOverride( matOutlineWhite )
	render.SetColorModulation( LineColor.r / 255, LineColor.g / 255, LineColor.b / 255 )
	if outline then cam.IgnoreZ(true) end
	self:DrawModel()
	if outline then cam.IgnoreZ(false) end
				   
	--  Revert everything back to how it should be
	render.ModelMaterialOverride( nil )
	self:SetModelScale( 1,0 )
				   
	render.SuppressEngineLighting( false )
	local c = self:GetColor()
	local r, g, b = c.r, c.g, c.b
	render.SetColorModulation( r/255, g/255, b/255 )
	
	self:DrawModel()]==]
 end