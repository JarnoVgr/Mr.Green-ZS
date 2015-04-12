--[[local function CratesRemoved()
	local pl = LocalPlayer()
	if not IsValid(pl) then
		return
	end
	
	if pl:Team() == TEAM_HUMAN then
		surface.PlaySound(Sound("mrgreen/beep22.wav"))
		pl:Message("The Supplies have been used up. Wait for the next drop off.", 2, "white")
	elseif pl:Team() == TEAM_UNDEAD then
		surface.PlaySound(Sound("player/zombies/b/scream.wav"))
		pl:Message("Human Supplies have been used up for now.", 2, "white")
	end
end
net.Receive("SupplyCratesRemoved", CratesRemoved)


local function CratesDropped()
	local pl = LocalPlayer() 
	if not IsValid(pl) or pl:Team() ~= TEAM_HUMAN then
		return
	end

	surface.PlaySound(Sound("mrgreen/beep22.wav"))
	pl:Message("Supplies have been dropped, go find the crates.", 2, "white")
	timer.Simple(0.1, function()
		surface.PlaySound(Sound("mrgreen/supplycrates/thunder3.mp3"))
	end)
end
net.Receive("SupplyCratesDropped", CratesDropped)
]]--
--TODO: Move to somewhere else
net.Receive("SlowMoEffect", function()
	RunConsoleCommand("stopsound")
	timer.Simple(0.05,function() 
		surface.PlaySound(Sound("mrgreen/new/slowmo_up.mp3"))
	end)

	timer.Simple(0.7,function() 
		surface.PlaySound(Sound("mrgreen/new/slowmo_down.mp3"))
	end)
end)