if SERVER then
	local AmmoAmount = 400
	timer.Create("GiveArenaAmmo", 30, 0, function()
		local Humans = team.GetPlayers(TEAM_HUMAN)

		for i=1, #Humans do
			local pl = Humans[i]
			if not IsValid(pl) or not pl:Alive() then
				continue
			end
			pl:GiveAmmo(AmmoAmount, "ar2", false)
			pl:GiveAmmo(AmmoAmount, "smg1", false)
			pl:GiveAmmo(AmmoAmount, "buckshot", false)
			pl:GiveAmmo(AmmoAmount, "pistol", false)
			pl:GiveAmmo(AmmoAmount, "357", false)
		end

		Debug("[ARENA] Gave ".. #Humans .." extra ammo")
	end)
end

Debug("JeMoeder-1")
print("JeMoeder-2")