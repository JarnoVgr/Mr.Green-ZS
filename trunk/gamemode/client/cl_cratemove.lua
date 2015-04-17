
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
