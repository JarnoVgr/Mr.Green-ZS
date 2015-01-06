-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--[[if SERVER then
    util.AddNetworkString( "ServerTime" )
    hook.Add("PlayerInitialSpawn", "loldeluvasawesomefix", function( pl )
        net.Start("ServerTime")
            net.WriteFloat(CurTime())
        net.Send(pl)
    end)
end

if CLIENT then
    net.Receive( "ServerTime", function( len, cl )
        g_ServerTime = net.ReadFloat()
        g_ServerTimeReceiveTime = CurTime()
    end)

    function ServerTime()
        return (g_ServerTime or 0) + ( (CurTime() - g_ServerTimeReceiveTime) or 0 )
    end
else
    ServerTime = CurTime
end]]
ServerTime = CurTime

--Case Insensitive HasValue variant
function table.HasValueCI( t, val )
	if val == nil then
		return false
	end

	val = string.lower(val)

	for k,v in pairs(t) do
		if (string.lower(v) == val ) then
			return true
		end
	end
	return false
end

--Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
--Does not copy entities of course, only copies their reference.
--WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
function table.FullCopy(tab)
	if (!tab) then
		return nil
	end
		
	local res = {}
	for k, v in pairs( tab ) do
		if (type(v) == "table") then
			res[k] = table.FullCopy(v) --recursion ho!
		elseif (type(v) == "Vector") then
			res[k] = Vector(v.x, v.y, v.z)
		elseif (type(v) == "Angle") then
			res[k] = Angle(v.p, v.y, v.r)
		else
			res[k] = v
		end
	end
				
	return res
end

--[==[---------------------------------------------------------
	       Get a player by its user ID
---------------------------------------------------------]==]
function GetPlayerByUserID ( id )
	for k, v in pairs( player.GetAll() ) do
		if v:UserID() == id then
			return v
		end
	end
end

function string.Sanitize( sDirty )
	if sDirty == nil then return false end
	if tonumber( sDirty ) then return tonumber( sDirty ) end
	if sDirty == "true" then return true elseif sDirty == "false" then return false end
	return tostring( sDirty )
end

function util.Blood(pos, amount, dir, force, noprediction)
	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetMagnitude(amount)
		effectdata:SetNormal(dir)
		effectdata:SetScale(math.max(128, force))
	util.Effect("bloodstream", effectdata, nil, noprediction)
end

function TrueVisible(posa, posb, filter)
	local filt = ents.FindByClass("projectile_*")
	filt = table.Add(filt, player.GetAll())
	if filter then
		filt[#filt + 1] = filter
	end

	return not util.TraceLine({start = posa, endpos = posb, filter = filt, mask = MASK_SHOT}).Hit
end

function TrueVisibleFilters(posa, posb, ...)
	local filt = ents.FindByClass("projectile_*")
	filt = table.Add(filt, player.GetAll())
	if ... ~= nil then
		for k, v in pairs({...}) do
			filt[#filt + 1] = v
		end
	end

	return not util.TraceLine({start = posa, endpos = posb, filter = filt, mask = MASK_SHOT}).Hit
end

function WorldVisible(posa, posb)
	return not util.TraceLine({start = posa, endpos = posb, mask = MASK_SOLID_BRUSHONLY}).Hit
end

-- I had to make this since the default function checks visibility vs. the entitiy's center and not the nearest position.
function util.BlastDamageEx(inflictor, attacker, epicenter, radius, damage, damagetype)
	local filter = inflictor
	for _, ent in pairs(ents.FindInSphere(epicenter, radius)) do
		local nearest = ent:NearestPoint(epicenter)
		if TrueVisibleFilters(epicenter, nearest, inflictor, ent) then
			ent:TakeSpecialDamage(((radius - nearest:Distance(epicenter)) / radius) * damage, damagetype, attacker, inflictor, nearest)
		end
	end
end

function util.BlastDamage2(inflictor, attacker, epicenter, radius, damage)
	util.BlastDamageEx(inflictor, attacker, epicenter, radius, damage, DMG_BLAST)
end

--[==[---------------------------------------------------------
        Returns the team name (string) of a player
---------------------------------------------------------]==]
function GetStringTeam ( pl )
	if not IsValid ( pl ) then return end
	if not pl:IsPlayer() then return end
	
	local Team, String = pl:Team(), "TEAM_HUMAN"
	if Team == TEAM_UNDEAD then String = "TEAM_UNDEAD" end
	
	return String
end

--[==[---------------------------------------------------------
           Prints a message to all the players
---------------------------------------------------------]==]
function PrintMessageAll ( Type, Text )
	if CLIENT then return end
	if Type == nil or Text == nil then return end
	
	for k,v in pairs ( player.GetAll() ) do
		if IsValid ( v ) then
			v:PrintMessage ( Type, tostring ( Text ) )
		end
	end	
end

--[==[---------------------------------------------------------
    Get a player by its name or fraction of the name
---------------------------------------------------------]==]
function GetPlayerByName( name )
	if name == nil then return end
	if name == "" then return -1 end

	-- entity found, multiple found bool and string found
	local found, multiple, foundString = nil, false
	
	-- run through the players
	for k,v in pairs( player.GetAll() ) do
		foundString = string.find( string.lower( v:GetName() ), string.lower( name ) )
		if ( foundString ~= nil and multiple == false ) then
			if ( found == nil ) then found = v else	multiple = true end
		end	
	end

	-- Return -2 if found multiple or -1 if not found
	if ( multiple == true ) then return -2 end
	if ( found == nil or not found:IsValid() ) then return -1 end
	
	return found	
end

--[==[-----------------------------------------------
                 Returns alive players
------------------------------------------------]==]
function player.GetAlive()
	local tab = {}
	for k, pl in pairs( player.GetAll( )) do
		if pl:IsValid() and pl:Alive() then
			table.insert( tab,pl )
		end
	end
	
	return tab
end

--[==[-----------------------------------------------
                 Returns Admin players
------------------------------------------------]==]
function player.GetAdmin()
	local tab = {}
	for k, pl in pairs( player.GetAll() ) do
		if pl:IsValid() and pl:IsAdmin() then
			table.insert( tab,pl )
		end
	end
	
	return tab
end	

--[==[--------------------------------------------------------------------------------------
                                    Returns humans inside sphere
----------------------------------------------------------------------------------------]==]
function ents.FindHumansInSphere ( vPos, fRadius )
	if not vPos or not fRadius then return end
	
	-- Get ents in that radius
	local tbEnts = team.GetPlayers(TEAM_HUMAN)-- ents.FindInSphere ( vPos, fRadius )
	local tbHumans = {} 
	
	-- Leave only humans
	for k,v in pairs ( tbEnts ) do
		if v:IsPlayer() and v:IsHuman() and v:GetPos():Distance(vPos) <= fRadius then
			table.insert ( tbHumans, v )
		end
	end
	
	return tbHumans	
end

--[==[--------------------------------------------------------
      Used to add entities that don't have a phys.
      entity. Mostly the ones used for hull traces
---------------------------------------------------------]==]
local NonSolids = {}
local function FilterNonSolids()
	for k,v in pairs ( ents.GetAll() ) do	
		if IsValid ( v ) and not v:IsPlayer() then
			local Phys = v:GetPhysicsObject()
			if not Phys:IsValid() then
				table.insert ( NonSolids, v )
			end
		end
	end
end	
hook.Add ( "Initialize", "FilterNonSolids", FilterNonSolids )

--[==[----------------------------------------
           Calculates Infliction
----------------------------------------]==]
function GetInfliction()
	--[[local zombies = team.NumPlayers ( TEAM_UNDEAD )
	local players = #player.GetAll()
	local infliction

	if players < 4 then
		--infliction = 0.15
		infliction = 0.5
	else
		infliction = math.Clamp ( zombies / players, 0.001, 1 )
	end
	
--	return infliction]]--
	return INFLICTION
end

--[==[-------------------------------------------------------
           Calculates a new form of difficulty
--------------------------------------------------------]==]
function GM:CalcFragsDifficulty()
	if ENDROUND then return end
	
	-- Get numbers
	local Zombies = team.GetPlayers ( TEAM_UNDEAD )
	if #Zombies == 0 then return end
	
	-- Difficulty 
	local fFragDifficulty = 0
	
	-- Calc undead frags
	local iZomboFrags, iFrags = 0, 0
	for k,v in pairs ( player.GetAll() ) do
		if v:IsZombie() then iZomboFrags = iZomboFrags + v:Frags() iFrags = iFrags + v:Frags() elseif v:IsHuman() then iFrags = iFrags + v:Frags() end
	end
	
	-- Nothing to calculate here
	if iFrags == 0 then return end
	
	-- Average
	fFragDifficulty = math.Clamp ( iZomboFrags * 3 / iFrags, 0.001, 1 ) * 2
	
	return fFragDifficulty 
end

--[==[-------------------------------------------------------
           Calculates a new form of difficulty
--------------------------------------------------------]==]
function GM:CalcGunsDifficulty()
	if ENDROUND then return end

	-- Get players
	local Humans = team.GetPlayers ( TEAM_HUMAN )
	if #Humans == 0 then return end
	
	-- Difficulty
	local fGunDifficulty = 0
	
	-- Calc gun. difficulty
	local tbHumans, fGunAvg = team.GetPlayers ( TEAM_HUMAN ), 0
	for k,v in pairs ( tbHumans ) do
		if IsEntityValid ( v:GetAutomatic() ) then
			fGunAvg = fGunAvg + 1
		end
	end

	-- Human automatic gun average
	fGunAvg = math.Clamp ( fGunAvg / #tbHumans, 0.001, 1 )
	
	-- Difficulty
	fGunDifficulty = fGunAvg * 2
	
	return fGunDifficulty
end

--[==[-----------------------------------------------------
           Returns if an entity is valid or not
------------------------------------------------------]==]
function IsEntityValid(mEnt)
	return IsValid(mEnt)
end

--[==[---------------------------------------------------------------------------
                Returns closest entity of a type from a point
----------------------------------------------------------------------------]==]
function GetClosestEntity ( vPos, entTable )
	if vPos == nil or entTable == nil then return end
	
	-- Distance to entity
	local fCloseDistance, mClosest = 32354
	
	-- Loop through all type ents
	for k,v in pairs ( entTable ) do
		if IsEntityValid ( v ) then
			local fDistance = vPos:Distance( v:GetPos() )
			
			-- Check current distance
			if fDistance < fCloseDistance then fCloseDistance = fDistance mClosest = v break end
		end
	end
	
	return mClosest
end

--[==[----------------------------------------
         Returns a random human
------------------------------------------]==]
function GetRandomHuman()
	return table.Random ( team.GetPlayers ( TEAM_HUMAN ) )
end

--[==[-------------------------------------------------------------
         Returns howlers within a specific range/pos
--------------------------------------------------------------]==]
function GetHowlers( vPos, iRadius )
	if vPos == nil or iRadius == nil then return end
	
	-- Our howler table
	local tbHowlers = {}
	
	for k,v in pairs ( team.GetPlayers(TEAM_UNDEAD) ) do-- ents.FindInSphere ( vPos, iRadius )
		if v:IsPlayer() and v:Alive() and v:Team() == TEAM_UNDEAD  and vPos:Distance(v:GetPos()) <= iRadius then
			if v:IsHowler() then
				table.insert ( tbHowlers, v )
			end
		end
	end
	
	return tbHowlers 
end

--[==[------------------------------------------------------------------------------
                Returns if an entity is visible by another entity
------------------------------------------------------------------------------]==]
function IsEntityVisible ( mTarget, vSource, mFilter, iMask )
	if vSource == nil or mTarget == nil then return end
	
	-- Mask
	if not iMask then iMask = MASK_SHOT end
	
	-- Bool
	local bIsVisible = false
	
	-- Use center
	local vEnd = mTarget:GetPos() + mTarget:OBBCenter() + Vector( 0,0,6 )
	
	-- Trace 
	local tr = util.TraceLine ( { start = vSource, endpos = vEnd, filter = mFilter, mask = iMask } )
	if tr.Entity == mTarget then bIsVisible = true end
	
	return bIsVisible
end

--[==[-----------------------------------------------------------------------
	    Returns if a world vector is visible to humans
-------------------------------------------------------------------------]==]
function VisibleToHumans ( vPos, mFilter )
	if vPos == nil or mFilter:Team() == TEAM_HUMAN then return end
	
	-- No humans
	if #team.GetPlayers ( TEAM_HUMAN ) <= 0 then return end
	
	-- Visiblity bool
	local bCanSeeMe = false
	
	-- Get closest human first
	local mClosest = GetClosestEntity ( vPos, team.GetPlayers ( TEAM_HUMAN ) )
	if IsEntityVisible ( mClosest, vPos + Vector ( 0,0,55 ), mFilter ) then return true end
	
	-- Cache cheked humans
	local tbChecked = {}
	
	for i = 1, 3 do
		if bCanSeeMe then break end
	
		-- Get closest humans
		local tbFound = ents.FindInSphere ( vPos, i * 150 )
		
		-- Parse through the found humans in sphere
		for k,v in pairs ( tbFound ) do
			if not table.HasValue ( tbChecked, v ) then if v:IsPlayer() and v:IsHuman() then table.insert ( tbChecked, v ) if IsEntityVisible ( v, vPos + Vector ( 0,0,55 ), mFilter ) then bCanSeeMe = true break end end end
		end
	end
	
	return bCanSeeMe
end

--[==[-----------------------------------------------------------
	      Returns fall to ground position
------------------------------------------------------------]==]
function GetFloor ( vPos, mFilter )
	if vPos == nil then return end
	
	-- Difference of height
	local fOffset = Vector ( 0,0,15 )
	
	-- Trace 
	local tr = util.TraceLine ( { start = vPos, endpos = vPos - Vector ( 0,0,10000 ), filter = mFilter, mask = MASK_PLAYERSOLID } )
	if tr.Hit then return tr.HitPos else return vPos end
end

--[==[------------------------------------------------------------
	        Get an entity by its index
-------------------------------------------------------------]==]
--[[function GetEntityByIndex ( iIndex ) 
	for k, v in pairs ( ents.GetAll() ) do
		if v:EntIndex() == iIndex then
			return v
		end
	end
end]]

--[==[----------------------------------------------------------------------------
	       Rounding to a specific digit math. function
------------------------------------------------------------------------------]==]
function math.DigitRound ( fNumber, iDigits )  
	local Remainder = fNumber % iDigits  
	if Remainder / iDigits < 0.5 then return fNumber - Remainder else return fNumber - Remainder + ( iDigits ) end  
end 

--[==[--------------------------------------------------------
	      See if something is stuck
                  ( pos, filter, min, max)
---------------------------------------------------------]==]
function IsStuck ( position, min, max, filtertb )
	if not position then return end
	
	local pos = position
	local x,y,z = pos.x,pos.y,pos.z
	local filters = { }
	
	if filtertb and #filtertb ~= 0 then 
		table.Add ( filters, filtertb )
	end
	
	-- Add non-solids to the filter 
	if #NonSolids > 0 then
		table.Add ( filters, NonSolids )
	end
	
	--  Hull tracing
	local HullTrace = util.TraceHull ( { start = pos, endpos = pos, filter = filters, mins = min, maxs = max } )
	
	return HullTrace.Entity ~= NULL
end

--[==[-------------------------------------------------------
             Computes zombie spawn points
--------------------------------------------------------]==]
function GM:ComputeZombieSpawn()

	-- debug.sethook()
	
	-- Reset zombie spawn table and disable fumes
	SpawnPoints = {}
	TOXIC_SPAWN = true
	
	-- Get all props in the map
	local tbProps = ents.FindByClass ( "prop_physics_multiplayer" )
	table.Add ( tbProps, ents.FindByClass ( "prop_dynamic" ) )
	table.Add ( tbProps, ents.FindByClass ( "func_physbox" ) )
	table.Add ( tbProps, ents.FindByClass ( "info_player_zombie" ) )
	table.Add ( tbProps, ents.FindByClass ( "info_player_undead" ) )
	table.Add ( tbProps, ents.FindByClass ( "info_player_human" ) )
	table.Add ( tbProps, ents.FindByClass ( "func_breakable" ) )
	table.Add ( tbProps, ents.FindByClass ( "info_player_combine" ) )
	table.Add ( tbProps, ents.FindByClass ( "info_player_rebel" ) )

	-- Loop
	local tbTeleport
	for i = 1, #tbProps do
	
		-- Too many spawnpoints
		if #SpawnPoints >= 150 then break end
			
		-- See if the point is suitable
		tbTeleport = LocationsFind ( tbProps[i] )
			
		-- 4 main directions
		local tbAngles = { -180, 180, 90, -90 }
			
		-- View distance
		local fDistance, angSpawn = 0, Angle ( 0,0,0 )
			
		-- Trace start/end points
		if tbTeleport then
			for k,v in pairs ( tbTeleport ) do
				if v then
				
					-- View distance
					local fDistance, angSpawn = 0, Angle ( 0,0,0 )
				
					-- Parse the 4 directions
					for j = 1, #tbAngles do
						local vStart = Vector ( 0,0,64 ) + v
						local vEnd = vStart + Angle( 0, math.NormalizeAngle ( tbAngles[j] ), 0 ):Forward() * 32000
							
						-- Start trace
						local tr = util.TraceLine ( { start = vStart, endpos = vEnd, filter = player.GetAll() } )
						if tr.HitPos:Distance( vStart ) > fDistance then fDistance = tr.HitPos:Distance( vStart ) angSpawn = Angle ( 0, tbAngles[j], 0 ) end
					end
						
					-- Save position
					table.insert ( SpawnPoints, { v, angSpawn } ) 
				end
			end
		end
	end
	
	Debug ( "[SPAWN COMPUTE] Finished computing "..tostring ( #SpawnPoints or 0 ).." spawn points for zombies!" )
end

--[==[---------------------------------------------------------------------------------
            Computes a space to teleport a player near another one
----------------------------------------------------------------------------------]==]
function LocationsFind ( mDestination )
	if not IsEntityValid ( mDestination ) or CLIENT then return end
	
	-- We can't teleport into the void
	if not mDestination:IsInWorld() then return end
	
	-- Offset from destination
	local fOffset = math.random ( 50,250 )
	
	-- Position to teleport
	local tbTeleport = {}

	-- Directions
	local yawForward = mDestination:GetAngles().yaw
	local angTable = { yawForward - 180, yawForward - 130, yawForward - 100, yawForward - 90, yawForward - 70, yawForward - 30, yawForward + 10, yawForward + 40, yawForward + 90 }
	
	local directions = {}
	for i = 1, #angTable do
		directions[i] = Angle( 0, math.NormalizeAngle ( angTable[i] ), 0 ):Forward()
	end
	
	local vTempLoc = GetFloor ( mDestination:GetPos() + directions[1] * fOffset )
	local bIsStuck = IsStuck ( vTempLoc, BIG_HULL[1], BIG_HULL[2] ) 
	
	-- Search algorithm
	for i = 1, #directions do
	
		-- Change offset
		for j = 1, 5 do
			if j == 1 then fOffset = math.random ( 100,350 ) elseif j == 2 then fOffset = math.random ( 450, 650 ) elseif j == 3 then fOffset = math.random ( 650, 850 ) elseif j == 4 then fOffset = math.random ( 1200, 1600 ) else fOffset = math.random ( 1600, 2500 ) end
		
			-- Update the bool with new coords
			vTempLoc = GetFloor ( mDestination:GetPos() + directions[i] * fOffset )
			bIsStuck = IsStuck ( vTempLoc, BIG_HULL[1], BIG_HULL[2] )
			
			-- Found a good place
			if not bIsStuck then if IsEntityInActiveArea( vTempLoc ) then table.insert ( tbTeleport, vTempLoc ) end end
		end
    end

	return tbTeleport
end

--[==[--------------------------------------------------------------------------------
                      Returns if entity is in an active play area
---------------------------------------------------------------------------------]==]
function IsEntityInActiveArea( vPos, mFilter )
	if vPos == nil then return end
	
	-- Location of trace start
	local vStart, vEnd = vPos + Vector ( 0,0,55 )
	
	-- Nr of props seen
	local iSeen, bHitNoDraw = 0, false
	
	local iTotal, iClip, iWorld, iEnts, iSky, iNoDraw = 0, 0, 0, 0, 0, 0
	
	local tbAngles = {}
	for i = -180, 180, 5 do
		table.insert ( tbAngles, i )
	end
	
	local yawang = {}
	for i = -180, 180, 30 do
		table.insert ( yawang, i )
	end
	
	-- Total number of traces
	iTotal = #tbAngles * #yawang
	
	-- Pitch check
	for j = 1, #yawang do
		for i = 1, #tbAngles do
			local vEnd = vStart + Angle( math.NormalizeAngle ( tbAngles[i] ),math.NormalizeAngle ( yawang[j] ) , 0 ):Forward() * 10000
			
			local tr = util.TraceLine ( { start = vStart, endpos = vEnd, filter = MySelf, mask = MASK_PLAYERSOLID } )
			
			-- Hit only world
			if tr.HitWorld and not tr.HitNoDraw and not tr.HitSky and not string.find ( tr.HitTexture, "CLIP" ) then iWorld = iWorld + 1 end
			
			-- Hit an entity
			if tr.HitNonWorld then iEnts = iEnts + 1 end
			
			-- Hit sky
			if tr.HitSky then iSky = iSky + 1 end
			
			-- Hit nodrwa
			if tr.HitNoDraw then iNoDraw = iNoDraw + 1 end
			
			-- Hit clip texture
			if string.find ( tr.HitTexture, "CLIP" ) then iClip = iClip + 1 end
		end
	end
		
	-- print ( "Total: "..iTotal.." ---- Clip: "..( iClip/iTotal * 100 ).." ---- World(solid): "..( iWorld/iTotal * 100 ).." ----  Entities: "..( iEnts/iTotal * 100 ).." ----  Skybox: "..( iSky/iTotal * 100 ).." ---- NoDraw: "..( iNoDraw/iTotal * 100 ) )

	local fClip, fWorld, fEnts, fSky, fNoDraw = ( iClip/iTotal * 100 ), ( iWorld/iTotal * 100 ), ( iEnts/iTotal * 100 ), ( iSky/iTotal * 100 ), ( iNoDraw/iTotal * 100 )
	
	return ( fEnts > 0 and fSky < 50 and fNoDraw <= 10 )
end

function math.Angle2D ( tbPoint1, tbPoint2 )
	if tbPoint1 == nil or tbPoint1 == nil then return end

	-- Our angle
	local fAng = 0

	-- Angle between 2 points in 2d space
	if tbPoint2.x - tbPoint1.x == 0 then
		if tbPoint2.y > tbPoint1.y then fAng = 0 end
	else
		fAng = math.atan2 ( tbPoint1.x - tbPoint2.x , tbPoint1.y - tbPoint2.y )
	end
	
	return math.deg ( fAng )
end

--[==[--------------------------------------------------------------------------------------------------------
         Used to add a draw function clientside, to draw and debug a trace (clientside, ofc)
--------------------------------------------------------------------------------------------------------]==]
function RenderTraceAdd ( pl, vSource, vEnd, iRemoveTimer )

	-- Ran on server
	if SERVER then pl:SendLua ( "RenderTraceAdd ( nil, Vector("..vSource.x..","..vSource.y..","..vSource.z.."),Vector("..vEnd.x..","..vEnd.y..","..vEnd.z.."))" ) return end
	
	-- Random hook name
	local HookName = "RenderTraceNr"..math.random ( 1,5000 )
	hook.Add ( "HUDPaint", HookName, function()
	
		-- Using laser material
		local matLaser = Material("sprites/bluelaser1")
		cam.Start3D( EyePos(), EyeAngles() )
		
			-- Draw the laser beam.
			render.SetMaterial( matLaser )
			render.DrawBeam( vSource, vEnd, 2, 0, 12.5, Color( 255, 0, 0, 255 ) )
		
		cam.End3D()
	end )
	
	-- Remove it
	timer.Simple ( iRemoveTimer or 1000, function() hook.Remove ( "HUDPaint", HookName ) end )
end

-- Draw trace hulls on the screen for a couple of seconds
function DrawTraceHull( trHull, iRemoveTimer )

	-- Grab vars from table
	local vMin, vMax, vStart, vEnd = trHull.mins, trHull.maxs, trHull.start, trHull.endpos

	if SERVER then pl:SendLua( "{mins=Vector("..vMin.x..","..vMin.y..","..vMin.z.."),maxs=Vector("..vMax.x..","..vMax.y..","..vMax.z.."),start=Vector("..vStart.x..","..vStart.y..","..vStart.z.."),endpos=Vector("..vEnd.x..","..vEnd.y..","..vEnd.z..")}" ) return end
	
	-- See what we can draw
	local HookName = "RenderTraceHull"..math.random( 1, 5000 )
	local matLaser = Material( "sprites/bluelaser1" )
	hook.Add( "HUDPaint", HookName, function()
		cam.Start3D( EyePos(), EyeAngles() )
		
			-- Draw the laser beam.
			render.SetMaterial( matLaser )
			
			-- Corner Lower Left 3 lines
			render.DrawBeam( vStart + Vector( vMin.x, vMin.y, vMin.z ), vStart + Vector( vMin.x, vMax.y, vMin.z ), 2, 0, 12.5, Color( 255, 0, 0, 255 ) )
			render.DrawBeam( vStart + Vector( vMin.x, vMin.y, vMin.z ), vStart + Vector( vMax.x, vMin.y, vMin.z ), 2, 0, 12.5, Color( 255, 0, 0, 255 ) )
			render.DrawBeam( vStart + Vector( vMin.x, vMin.y, vMin.z ), vStart + Vector( vMin.x, vMin.y, vMax.z ), 2, 0, 12.5, Color( 255, 0, 0, 255 ) )
			
			-- Corner Upper Right 3 lines
			render.DrawBeam( vStart + Vector( vMax.x, vMax.y, vMax.z ), vStart + Vector( vMax.x, vMin.y, vMax.z ), 2, 0, 12.5, Color( 255, 0, 0, 255 ) )
			render.DrawBeam( vStart + Vector( vMax.x, vMax.y, vMax.z ), vStart + Vector( vMin.x, vMax.y, vMax.z ), 2, 0, 12.5, Color( 255, 0, 0, 255 ) )
			render.DrawBeam( vStart + Vector( vMax.x, vMax.y, vMax.z ), vStart + Vector( vMax.x, vMax.y, vMin.z ), 2, 0, 12.5, Color( 255, 0, 0, 255 ) )
			
			-- Rest of them - from bottom
			render.DrawBeam( vStart + Vector( vMax.x, vMin.y, vMin.z ), vStart + Vector( vMax.x, vMax.y, vMin.z ), 2, 0, 12.5, Color( 255, 0, 0, 255 ) )
			render.DrawBeam( vStart + Vector( vMin.x, vMax.y, vMin.z ), vStart + Vector( vMax.x, vMax.y, vMin.z ), 2, 0, 12.5, Color( 255, 0, 0, 255 ) )
			
			-- Rest of them - from upper
			render.DrawBeam( vStart + Vector( vMin.x, vMax.y, vMax.z ), vStart + Vector( vMin.x, vMin.y, vMax.z ), 2, 0, 12.5, Color( 255, 0, 0, 255 ) )
			render.DrawBeam( vStart + Vector( vMax.x, vMin.y, vMax.z ), vStart + Vector( vMin.x, vMin.y, vMax.z ), 2, 0, 12.5, Color( 255, 0, 0, 255 ) )
			
			-- 2 left laterals
			render.DrawBeam( vStart + Vector( vMin.x, vMax.y, vMin.z ), vStart + Vector( vMin.x, vMax.y, vMax.z ), 2, 0, 12.5, Color( 255, 0, 0, 255 ) )
			render.DrawBeam( vStart + Vector( vMax.x, vMin.y, vMin.z ), vStart + Vector( vMax.x, vMin.y, vMax.z ), 2, 0, 12.5, Color( 255, 0, 0, 255 ) )
		
		cam.End3D()
	end )
	
	-- Remove it
	timer.Simple ( iRemoveTimer or 15, function() hook.Remove ( "HUDPaint", HookName ) end )
end

-- Glitchy table.Random function
function table.Random ( tbTable )
	if not tbTable then return end
	
	-- Random item
	return tbTable[ math.random( 1,#tbTable ) ]
end

--[==[---------------------------------------------------------
	Resequence a table from key 1 to n
---------------------------------------------------------]==]
function table.Resequence ( oldtable )
	local newtable = table.Copy ( oldtable )
	local id = 0
	
	--Clear old table
	table.Empty ( oldtable )
	
	--Write the new one
	for k,v in pairs ( newtable ) do
		id = id + 1
		oldtable[id] = newtable[k]
	end
end

function GetHumanFocus ( mEnt, range )
	if not IsEntityValid ( mEnt ) then return 0 end
	
	local humans = 0
	for k, pl in pairs( player.GetAll() ) do
		if pl ~= mEnt and pl:Team() == TEAM_HUMAN and pl:Alive() then
			local Distance = pl:GetPos():Distance( mEnt:GetPos() )
			if Distance <= range then
				humans = humans + 1
			end
		end
	end

	return humans
end

-- Set same vector sign
function getVectorSign( Vec, VecSign )
	if not Vec or not VecSign then return end
	if VecSign.x < 0 and Vec.x > 0 then Vec.x = -1 * ( Vec.x ) elseif VecSign.X > 0 and Vec.X < 0 then Vec.X = math.abs( Vec.X ) end
	if VecSign.Y < 0 and Vec.Y > 0 then Vec.Y = -1 * ( Vec.Y ) elseif VecSign.Y > 0 and Vec.Y < 0 then Vec.Y = math.abs( Vec.Y ) end
	if VecSign.Z < 0 and Vec.Z > 0 then Vec.Z = -1 * ( Vec.Z ) elseif VecSign.Z > 0 and Vec.Z < 0 then Vec.Z = math.abs( Vec.Z ) end
	return Vector( Vec.X, Vec.Y, Vec.Z )
end

--[==[-----------------------------------------------------------------------------------------------
                      Fixing this shit so it returns rounded values
------------------------------------------------------------------------------------------------]==]
function string.FormattedTime ( TimeInSeconds, Format )
	if not TimeInSeconds then TimeInSeconds = 0 end

	local iTime = math.floor( TimeInSeconds )
	
	-- Convert to h,m,s,ms
	local h,m,s,ms = ( iTime / 3600 ), math.Round ( ( iTime / 60 ) - ( math.floor( iTime / 3600 ) * 3600 ) ), math.Round( TimeInSeconds - ( math.floor( iTime / 60 ) * 60 ) ), math.Round ( ( TimeInSeconds - iTime ) * 100 )
	
	-- Clamp the shit
	m, s, ms = math.Clamp ( m, 0, 60 ), math.Clamp ( s, 0, 60 ), math.Clamp ( ms, 0, 99 )
	
	-- Return shit
	if Format then return string.format( Format, m, s, ms ) else return { h = h, m = m, s = s, ms = ms } end
end

function table.RandomEx( tab )
    local length = 0
    for k,v in pairs ( tab ) do
        length = length + 1
    end
    
    local random = math.random( 1, length )
    local i = 1
    
    for k,v in pairs( tab ) do
        if ( i == random ) then
            return tab[k]
        end
        i = i + 1
    end
end

--[[----------------------------------------------
     Description: simple O(n) shuffle
        algorithm for array type tables
----------------------------------------------]]--
function table.Shuffle( tab )
    --[[for i = 1, #tab - 1 do
        local random = math.random( i + 1, #tab )
        tab[i], tab[random] = tab[random], tab[i]
    end
    
    return tab]]
	local n, order, res = #tab, {}, {}
 
	for i=1,n do
		order[i] = { rnd = math.random(), idx = i }
	end
	
	table.sort(order, function(a,b)
		return a.rnd < b.rnd
	end)
	
	for i=1,n do
		res[i] = tab[order[i].idx]
	end
	
	return res
end


