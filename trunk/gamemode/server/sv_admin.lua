-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
local table = table
local math = math
local string = string
local util = util
local pairs = pairs
local team = team
local player = player
local timer = timer
local umsg = umsg
--[==[------------------------------------------------
          Admin Addon - Slay a player
-------------------------------------------------]==]
function SlayPlayer ( pl, cmd, args )
	if not ValidEntity ( pl ) or args[1] == nil then return end
	if not pl:IsAdmin() then return end
	
	-- Notice
	if ENDROUND then
		PrintMessageAll ( HUD_PRINTTALK, "[ADMIN] Admin "..tostring ( pl:Name() ).." has slayed player "..GetPlayerByUserID( tonumber( args[1] ) ):Name().." !" )
	else
		for k, v in pairs( player.GetAll() ) do
			v:CustomChatPrint( {nil, Color(255,0,0),"[ADMIN] ", Color(245,245,255),"Admin ",Color(255,0,0),tostring ( pl:Name() ),Color(235,235,255)," has slayed player ",Color(255,255,255),GetPlayerByUserID( tonumber( args[1] ) ):Name().." !"})
		end
	end
	Debug ( "[ADMIN] Admin "..tostring ( pl:Name() ).." has slayed player "..GetPlayerByUserID( tonumber( args[1] ) ):Name().." !" )

	-- kill the player
	GetPlayerByUserID( tonumber( args[1] ) ):Kill()
end
concommand.Add ( "slay_player", SlayPlayer )

--[==[------------------------------------------------
          Admin Addon - Redeem a player
-------------------------------------------------]==]
function RedeemPlayer ( pl, cmd, args )
	if not ValidEntity ( pl ) or args[1] == nil then return end
	if not pl:IsAdmin() then return end
	
	local Target = GetPlayerByUserID( tonumber( args[1] ) )
	if not ValidEntity ( Target ) then return end
	
	-- Can't redeem a human or use the command at round end or lasthuman
	if Target:Team() == TEAM_HUMAN then pl:ChatPrint ( "[ADMIN] You can't redeem a human >.< !" ) return end
	if ENDROUND or LASTHUMAN then pl:ChatPrint ( "[ADMIN] You can't use this command at this time !" ) return end
	
	-- Notice
	if pl == GetPlayerByUserID( tonumber( args[1] ) ) and not pl:IsSuperAdmin() then
		pl:ChatPrint("Only Super Admins can redeem themselves!")
		return
	else
		if ENDROUND then
			PrintMessageAll (HUD_PRINTTALK, "[ADMIN] Admin "..tostring ( pl:Name() ).." has redeemed player "..GetPlayerByUserID( tonumber( args[1] ) ):Name().." !" )
		else
			for k, v in pairs( player.GetAll() ) do
				v:CustomChatPrint( {nil, Color(255,0,0),"[ADMIN] ", Color(245,245,255),"Admin ",Color(255,0,0),tostring ( pl:Name() ),Color(235,235,255)," has redeemed player ",Color(255,255,255),GetPlayerByUserID( tonumber( args[1] ) ):Name().." !"})
			end
		end
		Debug ( "[ADMIN] Admin "..tostring ( pl:Name() ).." has redeemed player "..GetPlayerByUserID( tonumber( args[1] ) ):Name().." !" )
		
	end
	-- Redeem the player
	GetPlayerByUserID( tonumber( args[1] ) ):Redeem()
end
concommand.Add ( "redeem_player", RedeemPlayer )

--[==[------------------------------------------------
          Admin Addon - Add bots
-------------------------------------------------]==]
function AddBots ( pl, cmd, args )
	if not ValidEntity ( pl ) or args[1] == nil then return end
	if not pl:IsSuperAdmin() then return end
	
	-- Notice
	PrintMessageAll ( HUD_PRINTTALK, "[ADMIN] Admin "..tostring ( pl:Name() ).." added "..tonumber( args[1] ).." bots to the game !" )
	Debug ( "[ADMIN] Admin "..tostring ( pl:Name() ).." added "..tonumber( args[1] ).." bots to the game !" )

	-- No mimic and zombies
	RunConsoleCommand ( "bot_mimic", "0" )
	RunConsoleCommand ( "bot_zombie", "1" )
	
	-- Add the bots - be sure not to spawn them all at once
	for i = 1, tonumber ( args[1] ) do
		timer.Simple ( 0.01 + ( i / 3 ), function() RunConsoleCommand ( "bot" ) end )
	end
end
concommand.Add ( "add_bots", AddBots )

--[==[------------------------------------------------
        Admin Addon - Bitch slap a player
-------------------------------------------------]==]
function SlapPlayer ( pl, cmd, args )
	if not ValidEntity ( pl ) or args[1] == nil or args[2] == nil then return end
	if not pl:IsAdmin() then return end
	
	-- get the target player
	local Target = GetPlayerByUserID( tonumber( args[1] ) )
	
	-- Some validity conditions
	if not ValidEntity ( Target ) then return end
	if not Target:Alive() then pl:ChatPrint ( "[ADMIN] The target is already dead !" ) return end
	
	local Damage = math.Round ( Target:GetMaximumHealth() * ( tonumber ( args[2] ) / 100 ) )
	
	-- Notice
	
	if ENDROUND then
		PrintMessageAll ( HUD_PRINTTALK, "[ADMIN] Admin "..tostring ( pl:Name() ).." has slapped player "..GetPlayerByUserID( tonumber( args[1] ) ):Name().." with "..Damage.." damage !" )
		Target:ChatPrint ( "[ADMIN] Admin "..tostring ( pl:Name() ).." has slapped you because you are not obeying the game rules !" )
	else
		for k, v in pairs( player.GetAll() ) do
			v:CustomChatPrint( {nil, Color(255,0,0),"[ADMIN] ", Color(245,245,255),"Admin ",Color(255,0,0),tostring ( pl:Name() ),Color(235,235,255)," has slapped player ",Color(255,255,255),GetPlayerByUserID( tonumber( args[1] ) ):Name().." with "..Damage.." damage !"})
			Target:ChatPrint ( "[ADMIN] Admin "..tostring ( pl:Name() ).." has slapped you because you are not obeying the game rules !" )
		end
	end

	Debug ( "[ADMIN] Admin "..tostring ( pl:Name() ).." has slapped player "..GetPlayerByUserID( tonumber( args[1] ) ):Name().." with "..Damage.." damage !" )
	
	-- Slap the player
	Target:TakeDamage ( Damage )
	Target:EmitSound ( "ambient/voices/citizen_punches2.wav" )
	Target:SetVelocity ( Vector( math.random( -10,10 ),math.random( -10,10 ),math.random( 0,10 ) ):GetNormal() * math.random( 300,500 ) )
end
concommand.Add ( "slap_player", SlapPlayer )

--[==[------------------------------------------------
          Admin Addon - Give weapons/swep
-------------------------------------------------]==]
function GiveWeaponPlayer ( pl, cmd, args )
	if not ValidEntity ( pl ) or args[1] == nil or args[2] == nil then return end
	if not pl:IsSuperAdmin() then return end
	
	local Target = GetPlayerByUserID( tonumber( args[1] ) )
	if not ValidEntity ( Target ) then return end
	
	-- Dead man
	if not Target:Alive() then pl:ChatPrint ( "[ADMIN] The target is already dead !" ) return end
	
	-- Notice
	if ENDROUND then
		PrintMessageAll ( HUD_PRINTTALK, "[ADMIN] Admin "..tostring ( pl:Name() ).." gave player "..GetPlayerByUserID( tonumber( args[1] ) ):Name().." weapon named: "..args[2].." !" )
	else
		for k, v in pairs( player.GetAll() ) do
			v:CustomChatPrint( {nil, Color(255,0,0),"[ADMIN] ", Color(245,245,255),"Admin ",Color(255,0,0),tostring ( pl:Name() ),Color(235,235,255)," gave player ",Color(255,255,255),GetPlayerByUserID( tonumber( args[1] ) ):Name().." weapon named: "..args[2].." !"})
		end
	end
	
	Debug ( "[ADMIN] Admin "..tostring ( pl:Name() ).." gave player "..GetPlayerByUserID( tonumber( args[1] ) ):Name().." weapon named: "..args[2].." !" )

	-- give the weapon
	GetPlayerByUserID( tonumber( args[1] ) ):Give ( tostring ( args[2] ) )
end
concommand.Add ( "give_weapon", GiveWeaponPlayer )

--[==[------------------------------------------------
          Admin Addon - Mute players
-------------------------------------------------]==]
function MutePlayer ( pl, cmd, args )
	if not ValidEntity ( pl ) or args[1] == nil or args[2] == nil then return end
	if not pl:IsAdmin() then return end
	
	-- Type - true means mute, false - unmute
	local Type = tobool ( args[2] )
	local Command, Action = "sm_mute", "muted"
	
	-- Target
	local Target = GetPlayerByUserID( tonumber( args[1] ) )
	
	-- Reverse function
	if Type == false then Command = "sm_unmute" Action = "unmuted" end
	
	-- Notice
	if ENDROUND then
		PrintMessageAll ( HUD_PRINTTALK, "[ADMIN] Admin "..tostring ( pl:Name() ).." "..Action.." player "..GetPlayerByUserID( tonumber( args[1] ) ):Name().." !" )
	else
			for k, v in pairs( player.GetAll() ) do
				v:CustomChatPrint( {nil, Color(255,0,0),"[ADMIN] ", Color(245,245,255),"Admin ",Color(255,0,0),tostring ( pl:Name() ),Color(235,235,255)," "..Action.." player ",Color(255,255,255),GetPlayerByUserID( tonumber( args[1] ) ):Name().." !"})
			end
	end
	Debug ( "[ADMIN] Admin "..tostring ( pl:Name() ).." "..Action.." player "..GetPlayerByUserID( tonumber( args[1] ) ):Name().." !" )

	-- give the weapon
	if not Type then Target:UnMute() else Target:Mute() end
end
concommand.Add ( "mute_player", MutePlayer )

--[==[------------------------------------------------
          Admin Addon - Gag players
-------------------------------------------------]==]
function GagPlayer ( pl, cmd, args )
	if not ValidEntity ( pl ) or args[1] == nil or args[2] == nil then return end
	if not pl:IsAdmin() then return end
	
	-- Type - true means mute, false - unmute
	local Type = tobool ( args[2] )
	local Command, Action = "sm_gag", "gagged"
	
	-- Get target
	local Target = GetPlayerByUserID( tonumber( args[1] ) )
	
	-- Reverse function
	if Type == false then Command = "sm_ungag" Action = "ungagged" end
			
	-- Notice
	if ENDROUND then
		PrintMessageAll ( HUD_PRINTTALK, "[ADMIN] Admin "..tostring ( pl:Name() ).." "..Action.." player "..GetPlayerByUserID( tonumber( args[1] ) ):Name().." !" )
	else
			for k, v in pairs( player.GetAll() ) do
				v:CustomChatPrint( {nil, Color(255,0,0),"[ADMIN] ", Color(245,245,255),"Admin ",Color(255,0,0),tostring ( pl:Name() ),Color(235,235,255)," "..Action.." player ",Color(255,255,255),GetPlayerByUserID( tonumber( args[1] ) ):Name().." !"})
			end
	end
	Debug ( "[ADMIN] Admin "..tostring ( pl:Name() ).." "..Action.." player "..GetPlayerByUserID( tonumber( args[1] ) ):Name().." !" )

	-- give the weapon
	if not Type then Target:UnGag() else Target:Gag() end
end
concommand.Add ( "gag_player", GagPlayer )

--[==[--------------------------------------------------------
     Admin Addon - Kick a player (may cause crash)
---------------------------------------------------------]==]
function KickPlayer ( pl, cmd, args )
	if not ValidEntity ( pl ) or args[1] == nil then return end
	if not pl:IsAdmin() then return end
	
	-- No reason
	if not ( args[2] ) then args[2] = "The admin did not give a kick reason." end
	
	-- Check victim validity
	local Victim = GetPlayerByUserID( tonumber( args[1] ) )
	if not IsValid( Victim ) then return end
	
	-- You can't do this
	if Victim == pl then pl:ChatPrint ( "[ADMIN] You can't kick yourself !" ) return end

	-- Notice
	if ENDROUND then
		PrintMessageAll ( HUD_PRINTTALK, "[ADMIN] Admin "..tostring ( pl:Name() ).." has kicked player "..tostring( Victim:Name() ).." !" )
	else	
		for k, v in pairs( player.GetAll() ) do
			v:CustomChatPrint( {nil, Color(255,0,0),"[ADMIN] ", Color(245,245,255),"Admin ",Color(255,0,0),tostring ( pl:Name() ),Color(235,235,255)," has kicked player ",Color(255,255,255),GetPlayerByUserID( tonumber( args[1] ) ):Name().." !"})
		end
	end
	Debug ( "[ADMIN] Admin "..tostring ( pl:Name() ).." has kicked player "..tostring( Victim:Name() ).." !" )

	-- Run it
	RunConsoleCommand ( "kickid", tonumber ( args[1] ) )
end
concommand.Add( "kick_player", KickPlayer )

--[==[--------------------------------------------------------
     Admin Addon - Safe Kick ( disconnect ) 
---------------------------------------------------------]==]
function SafeKickPlayer ( pl, cmd, args )
	if not ValidEntity ( pl ) or args[1] == nil then return end
	if not pl:IsAdmin() then return end
	
	-- No reason
	if not ( args[2] ) then args[2] = "The admin did not give a kick reason." end
	
	-- You can't do this
	if GetPlayerByUserID( tonumber( args[1] ) ) == pl then pl:ChatPrint ( "[ADMIN] You can't kick yourself !" ) return end

	-- Notice
	PrintMessageAll ( HUD_PRINTTALK, "[ADMIN] Admin "..tostring ( pl:Name() ).." has safely kicked player "..GetPlayerByUserID( tonumber( args[1] ) ):Name().." !" )
	Debug ( "[ADMIN] Admin "..tostring ( pl:Name() ).." has safely kicked player "..GetPlayerByUserID( tonumber( args[1] ) ):Name().." !" )

	-- Run it
	server_RunCommand ( GetPlayerByUserID( tonumber( args[1] ) ), "disconnect" )
end
concommand.Add( "safekick_player", SafeKickPlayer ) 

--[==[--------------------------------------------------------
             Admin Addon - Slay all the players
---------------------------------------------------------]==]
function SlayAllPlayers ( pl, cmd, args )
	if not ValidEntity ( pl ) then return end
	if not pl:IsSuperAdmin() then return end
	
	-- Notice
	PrintMessageAll ( HUD_PRINTTALK, "[ADMIN] Admin "..tostring ( pl:Name() ).." has slayed all the players on the server !" )
	Debug ( "[ADMIN] Admin "..tostring ( pl:Name() ).." has slayed all the players on the server !" )

	-- Kill everyone
	for k,v in pairs ( player.GetAll() ) do
		if v ~= pl then
			v:Kill()
		end
	end
end
concommand.Add( "slay_all", SlayAllPlayers ) 

--[==[-----------------------------------------------------------
        Admin Addon - Ban a player (may cause crash)
-----------------------------------------------------------]==]
function BanPlayer ( pl, cmd, args )
	if not ValidEntity ( pl ) or args[2] == nil then return end
	if not pl:IsAdmin() then return end
	
	-- Time
	if args[1] == nil then args[1] = 5 end
	local TimeToBan = tonumber ( args[1] )
	
	-- No reason
	if not ( args[3] ) then args[3] = "The admin did not give a ban reason." end
	
	-- You can't do this
	if GetPlayerByUserID( tonumber( args[2] ) ) == pl then pl:ChatPrint ( "[ADMIN] You can't ban yourself !" ) return end
	
	-- Notice
	PrintMessageAll ( HUD_PRINTTALK, "[ADMIN] Admin "..tostring ( pl:Name() ).." has banned player "..GetPlayerByUserID( tonumber( args[2] ) ):Name().." for "..TimeToBan.." minutes !" )
	Debug ( "[ADMIN] Admin "..tostring ( pl:Name() ).." has banned player "..GetPlayerByUserID( tonumber( args[2] ) ):Name().." !" )

	-- Run it
	game.ConsoleCommand ("sm_ban \""..tonumber( args[1] ).."\" "..tonumber( args[2] ).." \""..args[3].."\"\n") 
end
concommand.Add( "ban_player", BanPlayer ) 

--[==[-----------------------------------------------------------
                  Admin Addon - Changelevel
-----------------------------------------------------------]==]
function ChangeLevel ( pl, cmd, args )
	if not ValidEntity ( pl ) or args[1] == nil then return end
	if not pl:IsSuperAdmin() then return end
	
	-- Target map
	local TargetMap = tostring ( args[1] )
	local FriendlyName = tostring ( TranslateMapTable[ TargetMap ].Name )
	
	-- We already are on this map
	local CurrentMap = game.GetMap()
	if CurrentMap == TargetMap then	pl:ChatPrint ( "[ADMIN] You can't change the map because it is already the current map." ) return end
	
	-- Notice
	PrintMessageAll ( HUD_PRINTTALK, "[ADMIN] Admin "..tostring ( pl:Name() ).." set the server to change map to "..FriendlyName.." in 10 seconds !" )
	Debug ( "[ADMIN] Admin "..tostring ( pl:Name() ).." set the server to change map to "..FriendlyName.." in 10 seconds !" )

	-- Change the map with a delay of 10
	timer.Simple ( 10, function() RunConsoleCommand ( "changelevel", TargetMap ) end )
end
concommand.Add( "changemap_player", ChangeLevel ) 

--[==[-----------------------------------------------------------
                  Admin Addon - Debugging
-----------------------------------------------------------]==]
function DoDebugCommands(pl, cmd, args)
	if not ValidEntity(pl) or not pl:IsSuperAdmin() or args[1] == nil then
		return
	end

	local sCommand = args[1]
	local bToggle = tonumber(args[2])
	
	
	if sCommand == "roundtime5" then
		ROUNDTIME = CurTime() + 5
		print("[DEBUG] Set RoundTime to expire in 5 seconds")
	elseif sCommand == "startround" then
		if GAMEACTIVE then
			return
		end
		
		WARMUPTIME = CurTime()
		
		Debug("[DEBUG] Started round")
	elseif sCommand == "starthalflife" then
		if not GAMEACTIVE and not HALFLIFE then
			return
		end
		
		GAMEMODE:SetHalflife(true)
		
		Debug("[DEBUG] Started HalfLife")
	elseif sCommand == "startunlife" then
		if not GAMEACTIVE and not UNLIFE then
			return
		end
		
		GAMEMODE:SetUnlife(true)
		
		Debug("[DEBUG] Started UnLife")
	elseif sCommand == "unleashboss" then
		bossPlayer = GAMEMODE:GetPlayerForBossZombie()
		if bossPlayer then
			bossPlayer:SpawnAsZombieBoss()
		end
		
		Debug("[DEBUG] Unleased the Undead Boss")
	elseif sCommand == "gravity" then
		for k,v in pairs(ents.GetAll()) do
			local Phys = v:GetPhysicsObject()
			if ValidEntity(Phys) then
				Phys:EnableGravity(tobool(bToggle))
			end
		end
		
		Debug("[DEBUG] Gravity action")
	-- Freeze/unfreeze props
	elseif sCommand == "freeze" then
		for k,v in pairs(ents.GetAll()) do
			local Phys = v:GetPhysicsObject()
			if ValidEntity(Phys) and not v:IsPlayer() then
				Phys:EnableMotion(tobool(bToggle))
			end
		end
		
		Debug("[DEBUG] (Un)Freeze action")
	end
end
concommand.Add("zs_admin_debug", DoDebugCommands) 

--[==[-----------------------------------------------------------
        Admin Addon - Bring a player to your pos
-----------------------------------------------------------]==]
function BringPlayer ( pl, cmd, args )
	if not ValidEntity ( pl ) then return end
	if not pl:IsAdmin() then return end
	
	-- User id to player -> target
	local target = GetPlayerByUserID( tonumber( args[1] ) )
	local des = pl
	
	-- Target is not valid
	if not ValidEntity ( target ) then return end
	
	-- Count up the retries
	if target.TeleportRetries == nil then target.TeleportRetries = 0 end
	
	if target == -1 or target == -2 then
		pl:PrintMessage(HUD_PRINTTALK, "[ADMIN] Multiple or no players specified!")
		return
	end
	
	if not ( des:Alive() ) then
		pl:PrintMessage(HUD_PRINTTALK, "[ADMIN] You're dead dumbass!")
		return
	end
	
	if not ( target:Alive() ) then
		pl:PrintMessage(HUD_PRINTTALK, "[ADMIN] Specified player is not alive!")
		return
	end
	
	if ( target == des ) then
		pl:PrintMessage(HUD_PRINTTALK, "[ADMIN] You can't bring yourself!")
		return			
	end
	
	local newpos = playerSend ( target, des, target:GetMoveType() == MOVETYPE_NOCLIP )
	
	-- No position found
	if not newpos then
		pl:PrintMessage( HUD_PRINTTALK, "[ADMIN] Can't find a place to put them! Retrying in 1 second.")
		
		-- Retry in 0.5 seconds
		if target.TeleportRetries < 4 then 
			timer.Simple ( 1.5, function() BringPlayer ( pl, cmd, args ) end, pl, cmd, args )
		else
			pl:PrintMessage( HUD_PRINTTALK, "[ADMIN] Can't find a place to put them! Teleportation failed !")
		end
		
		-- Increment teleport retries
		target.TeleportRetries = target.TeleportRetries + 1
		
		return 
	end
	
	-- Teleportation is a succes
	local newang = ( des:GetPos() - newpos ):Angle()

	target:SetPos( newpos )
	target:SetEyeAngles( newang )
	target:SetLocalVelocity( Vector( 0, 0, 0 ) ) -- Stop!
	
	for k, v in pairs( player.GetAll() ) do
		v:CustomChatPrint( {nil, Color(255,0,0),"[ADMIN] ", Color(245,245,255),"Admin ",Color(255,0,0),tostring ( pl:Name() ),Color(235,235,255)," teleported player ",Color(255,255,255),GetPlayerByUserID( tonumber( args[1] ) ):Name().." to himself !"})
	end
	
	target:PrintMessage( HUD_PRINTTALK, "[ADMIN] You were brought to (ADMIN) "..pl:Name() )
	des:PrintMessage( HUD_PRINTTALK, "[ADMIN] Player "..target:Name().." teleported to you" )
	
end
concommand.Add( "bring_player", BringPlayer ) 

--[==[--------------------------------------------------------------------
                   Admin Addon - Go to a specific player
-------------------------------------------------------------------]==]
function GotoPlayer ( pl, cmd, args )
	if not ValidEntity ( pl ) then return end
	if not pl:IsAdmin() then return end
	
	-- User Id to entity
	local target = pl
	local des = GetPlayerByUserID( tonumber( args[1] ) )
	
	-- Target is not valid
	if not ValidEntity ( des ) then return end
	
	-- Count up the retries
	if des.TeleportToRetries == nil then des.TeleportToRetries = 0 end
	
	if des == -1 or des == -2 then
		pl:PrintMessage(HUD_PRINTTALK, "[ADMIN] Multiple or no players specified!")
		return
	end
	
	if not ( des:Alive() ) then
		pl:PrintMessage(HUD_PRINTTALK, "[ADMIN] Specified player is not alive!")
		return
	end
	
	if not ( target:Alive() ) then
		pl:PrintMessage(HUD_PRINTTALK, "[ADMIN] You're dead dumbass!")
		return
	end
	
	if ( target == des ) then
		pl:PrintMessage(HUD_PRINTTALK, "[ADMIN] You can't goto yourself!")
		return			
	end
	
	local newpos = playerSend( target, des, target:GetMoveType() == MOVETYPE_NOCLIP )
	if not newpos then
		pl:PrintMessage( HUD_PRINTTALK, "[ADMIN] Can't find a place to put you! Use noclip to force a teleport. Retrying in 1 second.")
	
		-- Retry in 0.5 seconds
		if des.TeleportToRetries < 4 then 
			timer.Simple ( 1.5, function() GotoPlayer ( pl, cmd, args ) end, pl, cmd, args )
		else
			pl:PrintMessage( HUD_PRINTTALK, "[ADMIN] Can't find a place to put them! Teleportation failed !")
		end
		
		return
	end

	-- Teleportation was a success
	local newang = ( des:GetPos() - newpos ):Angle()

	target:SetPos( newpos )
	target:SetEyeAngles( newang )
	target:SetLocalVelocity( Vector( 0, 0, 0 ) ) -- Stop!
	
	for k, v in pairs( player.GetAll() ) do
		v:CustomChatPrint( {nil, Color(255,0,0),"[ADMIN] ", Color(245,245,255),"Admin ",Color(255,0,0),tostring ( pl:Name() ),Color(235,235,255)," teleported himself to player ",Color(255,255,255),GetPlayerByUserID( tonumber( args[1] ) ):Name().." !"})
	end
	
	target:PrintMessage( HUD_PRINTTALK, "[ADMIN] Teleported to player "..des:Name() )
	
end
concommand.Add( "goto_player", GotoPlayer ) 

local vSpawnPos = 0
local function NextSpawn( pl, bind )
	if not pl:IsSuperAdmin() or bind ~= IN_USE then return end
	if EDITOR_SPAWN_MODE == false then return end
	
	if vSpawnPos <= #SpawnPoints then
	
		-- Increment slot
		vSpawnPos = vSpawnPos + 1
	
		if SpawnPoints[vSpawnPos] then
		
			-- Set position and angles
			pl:SetPos ( SpawnPoints[vSpawnPos][1] )
			pl:SetEyeAngles ( SpawnPoints[vSpawnPos][2] )
			
			-- Notice
			pl:ChatPrint ( "Spawning on position: "..vSpawnPos )
		else
			pl:ChatPrint ( "Spawn position not present. Incrementing slot" )
			vSpawnPos = vSpawnPos + 1
		end
	end
end
if EDITOR_SPAWN_MODE then
	hook.Add ( "KeyPress", "SpawnShit", NextSpawn )
end

local function PrevSpawn( pl, bind )
	if not pl:IsSuperAdmin() or bind ~= IN_ATTACK2 then return end
	if EDITOR_SPAWN_MODE == false then return end
	
	-- Decrement slot
	vSpawnPos = vSpawnPos - 1
	
	if SpawnPoints[vSpawnPos] then
		
		-- Set position and angles
		pl:SetPos ( SpawnPoints[vSpawnPos][1] )
		pl:SetEyeAngles ( SpawnPoints[vSpawnPos][2] )
			
		-- Notice
		pl:ChatPrint ( "Spawning on position: "..vSpawnPos )
	end
end
if EDITOR_SPAWN_MODE then
	hook.Add ( "KeyPress", "SpawnPrevShit", PrevSpawn )
end

local function SaveSpawn( pl, bind )
	if not pl:IsSuperAdmin() or bind ~= IN_DUCK then return end
	if EDITOR_SPAWN_MODE == false then return end

	-- Path to write
	local strPath = "zszombiepoints/"..game.GetMap()..".txt"
	local strContent = "-- File generated by the Mr. Green ZS Automatic Spawn Generation Mechanism by Deluvas\n-- www.left4green.com - www.mr-green.nl\n"
	
	-- Create table
	strContent = strContent.." SpawnPoints = {}\n"
	
	-- Parse spawn table
	for k,v in pairs ( SpawnPoints ) do
		strContent = strContent.."table.insert ( SpawnPoints, { Vector("..( v[1].x )..","..( v[1].y )..","..( v[1].z ).."), Angle("..( v[2].p )..","..( v[2].y )..","..( v[2].r )..") } ) \n"
	end
	
	-- for k,v in pairs ( graph:GetNodes() ) do
		-- local vPos = v:GetPosition()
		-- local tbAngles = { -180, 180, 90, -90 }
			
		-- -- View distance
		-- local fDistance, angSpawn = 0, Angle ( 0,0,0 )
				
		-- -- Parse the 4 directions
		-- for j = 1, #tbAngles do
			-- local vStart = Vector ( 0,0,64 ) + vPos
			-- local vEnd = vStart + Angle( 0, math.NormalizeAngle ( tbAngles[j] ), 0 ):Forward() * 32000
							
			-- -- Start trace
			-- local tr = util.TraceLine ( { start = vStart, endpos = vEnd, filter = player.GetAll() } )
			-- if tr.HitPos:Distance( vStart ) > fDistance then fDistance = tr.HitPos:Distance( vStart ) angSpawn = Angle ( 0, tbAngles[j], 0 ) end
		-- end
		
		-- strContent = strContent.."table.insert ( SpawnPoints, { Vector("..( vPos.x )..","..( vPos.y )..","..( vPos.z ).."), Angle("..( angSpawn.p )..","..( angSpawn.y )..","..( angSpawn.r )..") } ) \n"
	-- end
	
	pl:ChatPrint ( "Saved to file!" )
	
	file.Write ( strPath, strContent )
end
if EDITOR_SPAWN_MODE then
	hook.Add ( "KeyPress", "SpawnSave", SaveSpawn )
end

local function DeleteSpawn( pl, bind )
	if not pl:IsSuperAdmin() or bind ~= IN_RELOAD then return end
	if EDITOR_SPAWN_MODE == false then return end

	-- Delete current slot spawn
	if SpawnPoints[vSpawnPos] then pl:ChatPrint ( "Spawn point "..vSpawnPos.." deleted!" ) SpawnPoints[vSpawnPos] = nil else pl:ChatPrint ( "Spawn position cannot be deleted. It's already deleted." ) end
end
if EDITOR_SPAWN_MODE then
	hook.Add ( "KeyPress", "SpawnFuck", DeleteSpawn )
end

Debug ( "[MODULE] Loaded New Admin Mod Commands." )
