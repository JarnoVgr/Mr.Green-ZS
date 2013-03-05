-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Add clientside files to download
if SERVER then AddCSLuaFile( "sh_nav_graph.lua" ) end

local bNavigationLoad, bStarLoad = false,false-- require ( "navigation" ), require( "astar" )
if not bNavigationLoad or not bStarLoad then return end

-- Include it after module check
if SERVER then include( "sv_init.lua" ) end

-- New nodes metatable
nodes, CNodes = {}, {}
nodes.__index = CNodes 

--[==[------------------------------------------------------------
	  Creates a node system
------------------------------------------------------------]==]
function CreateNodeSystem( iStep )
	if not iStep then iStep = 32 end

	-- Create metatable table
	local Table = { Nav = CreateNav( iStep ), bIsValid = true }
	
	-- Set meta table
	setmetatable( Table, nodes ) 
	Debug( "[GRAPH] Created a graph metatable." )
	
	return Table
end

-- Is graph valid
function IsGraphValid( Graph )
	if not Graph then return false end
	return ( Graph.AddSeed ~= nil and Graph.bIsValid )
end

-- Used to trace down on  pos. seeds
local function TraceDown( vPos )
	local tr = util.TraceLine( { start = vPos + Vector( 0, 0, 1 ), endpos = vPos + Vector( 0, 0, 1 ) - Vector( 0, 0, 9000 ), mask = MASK_PLAYERSOLID_BRUSHONLY } )
	return { bHitWorld = tr.HitWorld, vHitPos = tr.HitPos, vNormal = tr.HitNormal }
end

-- Add walkable seeds
function CNodes:AddSeed( vPos )
	self.Nav:AddWalkableSeed( vPos or Vector( 0, 0, 1 ), TraceDown( vPos or Vector( 0, 0, 1 ) ).vNormal )
end

-- Set maximum scan distance
function CNodes:SetMaxDistance( vMainPos, iDistance )
	if not iDistance then iDistance = 1024 end
	
	-- Set it
	self.Nav:SetupMaxDistance( vMainPos or Vector( 0,0,1 ), iDistance )
end

-- Clear walkable seeds
function CNodes:ClearSeeds()
	self.Nav:ClearWalkableSeeds()
end

-- Get node by id
function CNodes:GetNodeByID( ID )
	return self.Nav:GetNodeByID( ID or 1 )
end

-- Get nodes number
function CNodes:GetNodeTotal()
	return self.Nav:GetNodeTotal()
end

-- Returns node table
function CNodes:GetNodes()
	return self.Nav:GetNodes()
end

-- Creates nodes based on a starting position
function CNodes:ComputeNodes()

    -- Starts generation process
	self.Nav:StartGeneration()
	
	-- Warning: Freezes game for a bit
	self.Nav:FullGeneration()
	
	-- Save the node file
	self.Nav:Save( "data/Graphs/"..game.GetMap()..".nav" )
	Debug( "[GRAPH] Saved graph in data/Graphs! Graph maximum nodes: "..self:GetNodeTotal() )
end

-- Server side admin commands
local function GraphChat( pl, sText )
	if not pl:IsSuperAdmin() then return end
	
	-- Create graph command
	if sText == "!creategraph" then
		MainGraph = CreateNodeSystem()
	end
	
	-- Add seed
	if sText == "!addseed" then
		if IsGraphValid( MainGraph ) then MainGraph:AddSeed( pl:GetPos() + Vector( 0,0,1 ) ) pl:ChatPrint( "Added seed point!" ) else pl:ChatPrint( "Please create a graph first with !creategraph" ) end
	end
	
	-- Generate graph
	if sText == "!generategraph" then
		if IsGraphValid( MainGraph ) then MainGraph:ComputeNodes() else pl:ChatPrint( "Please create a graph first and add one or more seed points!" ) end
	end
	
	-- Get length
	if sText == "!graphsize" then
		if IsGraphValid( MainGraph ) then pl:ChatPrint( MainGraph:GetNodeTotal() or 0 ) else pl:ChatPrint( "Main graph is invalid. Please create one!" ) end
	end
	
	-- Draw graph
	if sText == "!drawgraph" then
		if IsGraphValid( MainGraph ) then MainGraph:DrawNodeGraph() else pl:ChatPrint( "Main graph is invalid. Please create one!" ) end
	end
end
if CLIENT then hook.Add( "OnPlayerChat", "HookGraphSay", GraphChat ) end

-- Client shit
if SERVER then return end

local Mat = Material( "effects/laser_tracer" )
function CNodes:DrawNodeGraph()
	if SERVER then return end
		
	-- Randomize hook
	local iRandom = math.random( 1, 1000 )
	hook.Add( "RenderScreenspaceEffects", "RenderNavGraph"..( iRandom ), function()
		render.SetMaterial( Mat )
		cam.Start3D( EyePos(), EyeAngles() )
			for k,v in pairs ( self:GetNodes() ) do
				render.DrawBeam( v:GetPosition(), v:GetPosition() + Vector( 0,0,5 ) , 4, 0.25, 0.75, Color( 255,0,0,255 ) )
			end
		cam.End3D()
	end )
end
