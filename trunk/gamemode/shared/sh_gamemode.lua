AddCSLuaFile()

--Enum
GAMEMODE_NORMAL = 0
GAMEMODE_ARENA = 1
GAMEMODE_SCAVENGE = 2

local Data = {}
Data[GAMEMODE_ARENA] = {
	Script = "sh_arena.lua"
}

local CurrentGameMode = 0

--GLua has a bug where it has problems to include a file from an anonymous function (timers, net.Receive etc)
local function StoreCurrentPath()
	local str = debug.getinfo(2, "S").source:sub(2)
	str = str:match("(.*/)"):gsub("gamemodes/", "")
	return str
end
local RealPath = StoreCurrentPath()

local function SetGameMode(GameMode)
	CurrentGameMode = GameMode
	Debug("[GAMEMODE] Starting ".. CurrentGameMode)

	if Data and Data[GameMode] then
		local GMData = Data[GameMode]
		if GMData.Script then
			if SERVER then
				include("gamemodes/".. GMData.Script)
			elseif CLIENT then
				include(RealPath .. "gamemodes/".. GMData.Script)
			end
			--include("shared/gamemodes/".. GMData.Script)
		end
	end
end

if SERVER then
	util.AddNetworkString("SetGameMode")

	local function SendGameMode(pl)
		--Inform players
		net.Start("SetGameMode")
		net.WriteInt(CurrentGameMode, 32)
		if IsValid(pl) then
			net.Send(pl)
		else
			net.Broadcast()
		end
	end

	function GM:SetGameMode(GameMode)
		SetGameMode(GameMode)

		--Broadcast
		SendGameMode()
	end


	--Inform late-joiners
	hook.Add("PlayerInitialSpawn", "InformPlayerAboutGameMode", function(pl) --PlayerReady
		SendGameMode(pl)
	end)
end



function GM:GetGameMode()
	return CurrentGameMode
end

if CLIENT then
	net.Receive("SetGameMode", function()
		SetGameMode(net.ReadInt(32))
	end)
end

--Include all gamemode files
if SERVER then
	for k, GMData in pairs(Data) do
		print("WOOP")
		if GMData.Script then
			print("gamemodes/".. GMData.Script)
			AddCSLuaFile("gamemodes/".. GMData.Script)
		end
	end
end
