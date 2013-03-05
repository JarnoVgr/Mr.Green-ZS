-- 'Fake' entity for zombie master maps.
-- Its a really easy way how to detect who won.

ENT.Type = "point"

-- Because map will call an input - we can track which one we can use
function ENT:AcceptInput(name, activator, caller, arg)
	
	--[==[if name == "Win" then
		gamemode.Call( "OnEndRound", TEAM_HUMAN )
		return true
	end
	if name == "Lose" then
		gamemode.Call( "OnEndRound", TEAM_UNDEAD )
		return true
	end]==]
end