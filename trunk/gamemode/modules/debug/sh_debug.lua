-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--[==[--------------------------------------------------------
	Save the debug reports from debug file
---------------------------------------------------------]==]
local LogTable, Time, Date = ""
local function WriteDebugToFile ()
	if CLIENT then return end
	if LogTable == "" then return end
	
	-- Debug is off
	if GetConVarNumber ( "debug" ) == 0 then return end
	
	-- Get the current time and date
	if Time == nil or Date == nil then Time, Date = os.date("%X"), os.date("%x") end
	
	-- We can't use certain character in file name so we replace them
	local ReplaceTime, ReplaceDate = string.gsub ( Time, ":", "-" ), string.gsub ( Date, "/", "-" )
	
	-- Write on this path
	local PathToWrite = "zombiesurvivaldebug/[date-"..ReplaceDate.."][time-"..ReplaceTime.."]debug.txt"
	
	file.Write ( PathToWrite, LogTable )
end

--[==[--------------------------------------------------------
        Use : Debug purporse - prints to console
---------------------------------------------------------]==]
function Debug(Text)
	if Text == nil then
		return
	end

	--Get the current time and date
	local Time, Date = os.date("%X"), os.date("%x")
	local NewMessage = Text
	
	--Server log
	local bLogServer = util.tobool(GetConVarNumber("debug_rconprint"))
	
	--Check debug convars
	if SERVER then
		if GetConVarNumber("debug") == 0 then
			return
		end
		
		-- Damage convar
		if string.find ( tostring ( NewMessage ), "[DAMAGE]" ) and GetConVarNumber ( "debug_damage" ) == 0 then return end
	end
	
	--Print the message to the console
	if bLogServer or CLIENT then
		print("["..Date.."]["..Time.."] "..tostring(NewMessage))
	else
		ServerLog(tostring(NewMessage).."\n")
	end
	
	--Log the text to file if server
	if SERVER then
		LogTable = LogTable .."[".. Date .."][".. Time .."] ".. tostring(NewMessage).."\n"
	end	

	--Turbo debug
	if SERVER and TURBO_DEBUGGER then
		WriteDebugToFile()
	end
end

-- Save debug each 3 seconds
--[[if SERVER then
	timer.Create("DebugToFileTimer", 3, 0, WriteDebugToFile)
end]]

-- Write the debug file on lua shutdown
hook.Add("ShutDown", "WriteDebugToFile", function()
	WriteDebugToFile()
end)