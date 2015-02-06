net.Receive("SetPlayerScore", function(len)
	local pl = net.ReadEntity()
	
	if not IsValid(pl) then
		return
	end
	
	local newScore = net.ReadInt(32)
	pl:SetScore(newScore)
	
	local newLevel = net.ReadInt(32)
	pl.InternalRank = newLevel
end)

net.Receive("SetLocalPlayerScore", function(len)
	if not IsValid(MySelf) then
		return
	end

	local newScore = net.ReadInt(32)
	
	MySelf:SetScore(newScore)
end)

net.Receive("SetPlayerLevel", function(len)
	local pl = net.ReadEntity()
	
	if not IsValid(pl) then
		return
	end
	
	local newLevel = net.ReadInt(32)
	
	pl.InternalRank = newLevel
	
	Debug("Received SetPlayerLevel with level ".. newLevel)
end)