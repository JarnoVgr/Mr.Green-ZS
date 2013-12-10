net.Receive("SetPlayerScore", function(len)
	local pl = net.ReadEntity()
	local newScore = net.ReadInt(32)
	
	if not IsValid(pl) then
		return
	end
	
	pl:SetScore(newScore)
end)

net.Receive("SetLocalPlayerScore", function(len)
	if not IsValid(MySelf) then
		return
	end

	local newScore = net.ReadInt(32)
	
	MySelf:SetScore(newScore)
end)
