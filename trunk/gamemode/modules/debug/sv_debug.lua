-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile ( "sh_debug.lua" )

--  Initialize debug convars 
DEBUG_VARS = { "debug", "debug_usermessages", "debug_damage", "debug_effects", "debug_rconprint" }
for k,v in pairs ( DEBUG_VARS ) do
	local bValue = 1
	if v == "debug_rconprint" then bValue = 0 end
	if v == "debug" then bValue = 0 end
	CreateConVar ( v, tostring ( bValue ) )
end

-- Precise timing
local bLoaded = false -- require ( "precisetimer" )

--[==[--------------------------------------------------------------
	       Loaded precise timer or not 
--------------------------------------------------------------]==]
function GM:PreciseTimerActive()
	return bLoaded
end

--[==[-------------------------------------------------------------------------
	    Use this to see time required to compute stuff
------------------------------------------------------------------------]==]
local TimerTimeTable, iLimit = {}, 0.005
function timer.Compute ( strName )
	if strName == nil then return end
	
	-- Didn't load module
	if not GAMEMODE:PreciseTimerActive() then return end
	
	-- No module found
	if not bLoaded then return end
	
	-- Star time and end time
	if TimerTimeTable[strName] == nil then TimerTimeTable[strName] = { ["bStart"] = true, ["CTime"] = CPreciseTimer() } TimerTimeTable[strName].CTime:Start() end
	
	-- Print to console
	if TimerTimeTable[strName].bStart == false then 
	
		-- Last time
		local fTime = TimerTimeTable[strName].CTime:Time()
		if fTime < 1.2 then Debug ( "[PRECISE-TIME] Compute time for script "..tostring ( strName ).." is "..( fTime * 1000 ).." ms." ) end
		
		-- Clear table
		TimerTimeTable[strName] = nil 
		
		-- Check to see if it took more than 3 ms
		if fTime > iLimit and fTime < 1.2 then Debug ( "*** [ WARNING ] *** Script "..tostring ( strName ).." took more than "..tostring ( iLimit * 1000 ).." ms to compute!" ) end
	end

	-- Second time
	if TimerTimeTable[strName] then TimerTimeTable[strName].bStart = false end
end

-- Didn't load precise timer dll
if not GM:PreciseTimerActive() then print ( "[ERROR] PreciseTimer module could not be found. PreciseTimer lua functions will not be available!" ) end

Debug ( "[MODULE] Loaded Debug Script!" )
