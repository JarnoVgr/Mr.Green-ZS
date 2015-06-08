-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Time limit (seconds)
TIME_CHECK, TIME_AFK = 1, 300

-- Local vars
local TimerAFK = 0

--[==[----------------------------
    Client-side afk status
-----------------------------]==]
function GetAFK()
	return MySelf.bIsAFK 
end

--[==[---------------------------------------------------------------------------------
    Checks current player stats with old ones ( position,eye angles, etc )
----------------------------------------------------------------------------------]==]
local function IsPlayerAFK ( pl, vPos, angAng )
	if pl:IsBot() then return false end

	-- Compare current stats with old stats
	return vPos == pl:GetPos() and angAng == pl:EyeAngles()
end

--[==[-------------------------------------------
         Check player for AFK-ness
-------------------------------------------]==]
local function CheckAFK()
	if not IsEntityValid ( MySelf ) then return end
	
	-- Don't need on endround
	if ENDROUND then return end
	
	-- Check bool
	if MySelf.bIsAFK == nil then return end
	
	-- Grab current eye angles, pos and check them
	local bAfk = IsPlayerAFK( MySelf, MySelf.PosAFK, MySelf.AngAFK )
	if bAfk then TimerAFK = math.Clamp ( TimerAFK + 1, 0, TIME_AFK ) else ChangeAFK ( false ) MySelf.PosAFK, MySelf.AngAFK = MySelf:GetPos(), MySelf:EyeAngles() end
	
	-- Timer reached max
	if TimerAFK == TIME_AFK then if not MySelf.bIsAFK then ChangeAFK ( true ) end end
	
	-- Loop
	timer.Simple ( TIME_CHECK, function() CheckAFK() end )
end

--[==[--------------------------------------------------
                 Initialize AFK variables
---------------------------------------------------]==]
local function InitializeAFK()
	timer.Simple ( 2, function()
		
		if not IsValid(MySelf) then return end
		-- Main bool
		if MySelf.bIsAFK == nil then MySelf.bIsAFK = false else return end
		
		-- Get his initial position and eye angles
		MySelf.PosAFK, MySelf.AngAFK = MySelf:GetPos(), MySelf:EyeAngles()
		
		-- Check afk status
		timer.Simple ( TIME_CHECK, function() CheckAFK() end )		
	end )
end
hook.Add ( "Initialize", "InitializeAFK", InitializeAFK )

--[==[-----------------------------------------------
              Sends status to server
----------------------------------------------]==]
function ChangeAFK ( bAfk )
	if bAfk == nil then return end
	
	-- Same status
	if bAfk == MySelf.bIsAfk then return end
	
	-- Change status
	MySelf.bIsAFK = bAfk

	-- Send status to server
	if TimerAFK == TIME_AFK then RunConsoleCommand ( "set_afk", tostring ( util.tobool ( bAfk ) ), "password" ) end
	
	-- Reset afk time
	if not bAfk then TimerAFK = 0 end
end

--[==[-------------------------------------------------------------------
                An important event in AFK prediction
--------------------------------------------------------------------]==]
local function OnKeyPress ( pl, iBind )
	if not IsEntityValid ( MySelf ) then return end
	
	-- Only myself
	if pl ~= MySelf then return end
	
	-- No afk bool
	if pl.bIsAFK == nil then return end
	
	-- Disable afk-ness on press
	if iBind then ChangeAFK ( false ) end	
end
hook.Add( "PlayerBindPress", "OnKeyPressAFK", OnKeyPress )

Debug ( "[MODULE] Loaded Client-Side Anti-AFK script!" )
