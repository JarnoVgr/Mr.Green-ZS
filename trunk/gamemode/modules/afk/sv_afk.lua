-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile ( "cl_afk.lua" )

-- Time to kick
TIME_KICK = 360

--[==[------------------------------------------------------------
	      Kicks a player if afk is overtime
-------------------------------------------------------------]==]
local function CheckPlayerAFK( pl )
	if not IsEntityValid ( pl ) then return end
	
	-- No kicktime
	if not pl.KickTime or ( pl.KickTime and pl.KickTime == -1 ) then return end

	-- Kick player
	if pl.KickTime <= CurTime() then PrintMessageAll ( HUD_PRINTTALK, "[AFK] Player "..tostring ( pl:Name() ).." has been kicked because he was away for too long!" ) server_RunCommand ( pl, "disconnect" ) end
end

--[==[--------------------------------------------------------
	      Check AFKness for all players
-------------------------------------------------------]==]
--local fThinkAFK = 0
local function CheckPlayersAFK()
	--if fThinkAFK > CurTime() then return end
	
	-- Parse through players
	for k,v in pairs ( player.GetAll() ) do
		if not v.bIsAFK then v.bIsAFK = false end

		-- Kick afk players 
		if IsEntityValid ( v ) then
			CheckPlayerAFK( v )
		end
	end
	
	-- Cooldown
	--fThinkAFK = CurTime() + 1
end
--hook.Add ( "Think", "CheckPlayersAFK", CheckPlayersAFK )
timer.Create("CheckPlayersAFK", 1, 0, CheckPlayersAFK)

--[==[---------------------------------------------------------------------------------
		  Receives the AFK status from the client
----------------------------------------------------------------------------------]==]
local function GetAFKStatus ( pl, cmd, tbArgs )
	if not IsEntityValid ( pl ) then return end
	
	-- No password
	if string.reverse( tbArgs[2] ) ~= "drowssap" then return end
	
	-- There is no afk var
	if pl.bIsAFK == nil then pl.bIsAFK = false end
	
	-- No args
	if not tbArgs[1] then return end
	
	-- Same status
	if pl.bIsAFK == tbArgs[1] then return end
	
	-- Get bool
	if type ( pl.bIsAFK ) ~= "boolean" then PrintMessageAll ( HUD_PRINTTALK, "[ADMIN] Player "..tostring ( pl:Name() ).." tried to use command without authorization!" ) return end
	pl.bIsAFK = util.tobool ( tbArgs[1] )
	
	-- Record time
	if pl.bIsAFK then pl.KickTime = CurTime() + TIME_KICK else pl.KickTime = -1 end
	
	-- Notice players when being marked as AFK
	if pl.bIsAFK then
		pl:ChatPrint ( "[AFK] You seem to be away. We will kick you in a couple minutes if you don't hit a key." )
	end
end
concommand.Add ( "set_afk", GetAFKStatus )

-- Add some useful function to the meta player
local mPlayer = FindMetaTable ( "Player" )
if not mPlayer then return end

--[==[----------------------------------------
	Server-side afk status
-----------------------------------------]==]
function mPlayer:IsAFK()
	return self.bIsAFK
end

Debug ( "[MODULE] Loaded Anti-AFK script!" )
