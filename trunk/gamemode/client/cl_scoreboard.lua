-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

include("vgui/scoreboard.lua")

function GM:ScoreboardShow()
	if ENDROUND or ZOMBIE_CLASSES then
		return
	end
	
	GAMEMODE.ShowScoreboard = true
	gui.EnableScreenClicker(true)

	--if not SCPanel then
		self:CreateScoreboardVGUI()
	--end
end

function GM:ScoreboardHide()
	if not left_scoreboard or not right_scoreboard or not IsValid (MySelf) or ENDROUND or ZOMBIE_CLASSES then
		return
	end
	
	GAMEMODE.ShowScoreboard = false
	self:RemoveScoreboardVGUI()
	gui.EnableScreenClicker(false)
end

function GM:HUDDrawScoreBoard()
end


