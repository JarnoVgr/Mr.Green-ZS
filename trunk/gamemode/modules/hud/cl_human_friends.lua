
local nearPlayers, nextFriendsCache = {}, CurTime() + 5
local function cacheFriends(max)
	nextFriendsCache = CurTime() + 5

	nearPlayers = {}
	
	local Survivors = team.GetPlayers(TEAM_SURVIVORS)

	for i=1, #Survivors do
		local pl = Survivors[i]
		
		if #nearPlayers >= max then
			continue
		end

		if not IsValid(pl) or not pl:Alive() or pl == MySelf then
			continue
		end

		local distance = pl:GetPos():Distance(MySelf:GetPos())
		if distance < 80 then
			table.insert(nearPlayers, {
				pl = pl,
				distance = distance
			})
		end
	end

	--Sort ascending
	table.SortByMember(nearPlayers, "distance", true)

	print("Cached new friends!" .. #nearPlayers)
end

function hud.DrawFriends()
	if nextFriendsCache <= CurTime() then
		cacheFriends(3)
	end

	if #nearPlayers == 0 then
		return
	end

	for i, v in ipairs(nearPlayers) do
		if i > 3 then
			break
		end

		local pl = v.pl

		--Background
		surface.SetMaterial(nHudBackground) 
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawTexturedRect(ScaleW(-50), ScaleH(770-(250*i)), ScaleW(150), ScaleH(250))

		local textX, textValueY, textKeyY = ScaleW(40), ScaleH(860-(250*i)), ScaleH(890-(250*i))
		draw.SimpleText(pl:Nick() or 0, "HUDBetaHeader", textX, textValueY, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("+".. pl:Health(), "ssNewAmmoFont9", textX, textKeyY, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end