-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--[==[--------------------------------------------------------
	      Check AFKness for all players
-------------------------------------------------------]==]


local onlineClients = 0

hook.Add("PlayerDisconnected", "dynamicSlots.PlayerDisconnected", function(pl)
	onlineClients = onlineClients-1
end)

hook.Add("PlayerConnect", "dynamicSlots.PlayerConnect", function(name, ip)
	onlineClients = onlineClients+1
end)

--local fThinkAFK = 0
local function CheckSlots()
	local CurrentPlayers = #player.GetAll()
	--game.MaxPlayers()


	local VisibleMaxPlayers = math.max(12, math.max(onlineClients, #player.GetAll() + 2) + 5)

	RunConsoleCommand("sv_visiblemaxplayers", VisibleMaxPlayers)
end
timer.Create("CheckSlots", 10, 0, CheckSlots)