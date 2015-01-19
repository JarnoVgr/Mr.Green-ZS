local function CrateRemoved()
	local pl = LocalPlayer()
	if not IsValid(pl) then
		return
	end
	
	if pl:Team() == TEAM_HUMAN then
		surface.PlaySound(Sound("mrgreen/beep22.wav"))
		pl:Message("The Supplies have been used up. Wait for the next drop off!", 2, "white")
	elseif pl:Team() == TEAM_UNDEAD then
		surface.PlaySound(Sound("player/zombies/b/scream.wav"))
		pl:Message("Human supplies have moved", 2, "white")
	end
end
usermessage.Hook("cratemove", CrateRemoved)

local function CrateDropped()
	local pl = LocalPlayer() 
	if not IsValid(pl) or pl:Team() ~= TEAM_HUMAN then
		return
	end

	surface.PlaySound(Sound("mrgreen/beep22.wav"))
	pl:Message("Supplies have been dropped, go find them", 2, "white")
	timer.Simple(2, function()
		surface.PlaySound(Sound("mrgreen/supplycrates/thunder3.mp3"))
	end)
end
usermessage.Hook("spawn", CrateDropped)

--Adding the Slowmo sounds receiver in here to keep the main Client files tidy.

net.Receive("slowmo", function()
	RunConsoleCommand("stopsound")
	timer.Simple(0.05,function() 
		surface.PlaySound(Sound("mrgreen/new/slowmo_up.mp3"))
	end)

	timer.Simple(0.7,function() 
		surface.PlaySound(Sound("mrgreen/new/slowmo_down.mp3"))
	end)
end)