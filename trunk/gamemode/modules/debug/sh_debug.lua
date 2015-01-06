-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	--Initialize debug convars 
	DEBUG_VARS = { "zs_debug" }
	for k,v in pairs ( DEBUG_VARS ) do
		if ConVarExists(v) then 
			continue
		end

		local bValue = 1

		if v == "zs_debug" then
			bValue = 0
		end

		CreateConVar(v, tostring(bValue), FCVAR_NONE, "ConVar used by ZS Debug module")
	end
end

--[==[--------------------------------------------------------
	Save the debug reports from debug file
---------------------------------------------------------]==]
local LogTable, Time, Date = ""
local function WriteDebugToFile ()
	if CLIENT then return end
	if LogTable == "" then return end
	
	-- Debug is off
	if GetConVarNumber( "zs_debug" ) == 0 then return end
	
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

	if GetConVarNumber("zs_debug") == 0 then
		return
	end

	--Get the current time and date
	local Time, Date = os.date("%X"), os.date("%x")
	local NewMessage = Text

	local bLogSave = false
	
	--Check debug convars
	if SERVER then
		bLogSave = util.tobool(GetConVarNumber("zs_debug_save"))

		-- Damage convar
		if GetConVarNumber("zs_debug_damage") == 0 and string.find(tostring ( NewMessage ), "[DAMAGE]") then
			return
		end
	end
	
	--Print the message to the console
	if (SERVER and not bLogSave) or CLIENT then
		print("["..Date.."]["..Time.."] "..tostring(NewMessage))
	else
		ServerLog(tostring(NewMessage).."\n")
	end
	
	if SERVER then
		--Log the text to file if server
		LogTable = LogTable .."[".. Date .."][".. Time .."] ".. tostring(NewMessage).."\n"

		--Turbo debug
		--TODO: Use zs_debug_turbo
		if TURBO_DEBUGGER then
			WriteDebugToFile()
		end
	end	
end

-- Save debug each 3 seconds
--TODO: Use zs_debug_saveatinterval
if SERVER then
	timer.Create("DebugToFileTimer", 10, 0, WriteDebugToFile)
end

-- Write the debug file on lua shutdown
hook.Add("ShutDown", "WriteDebugToFile", function()
	WriteDebugToFile()
end)