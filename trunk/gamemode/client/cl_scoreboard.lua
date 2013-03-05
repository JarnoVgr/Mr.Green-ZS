-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

include("vgui/scoreboard.lua")
--[=[
local pScoreBoard = nil

function GM:CreateScoreboard()
	pScoreBoard = vgui.Create("ScoreBoard")
end

function GM:ScoreboardShow()
	if MySelf:Team() == TEAM_SPECTATOR then return end
	if ENDROUND or ZOMBIE_CLASSES then return end
	
	GAMEMODE.ShowScoreboard = true
	gui.EnableScreenClicker(true)

	if not pScoreBoard then
		self:CreateScoreboard()
	end

	pScoreBoard:SetVisible(true)
end

function GM:ScoreboardHide()
	if not pScoreBoard then return end 
	if not ValidEntity (MySelf) then return end
	if (MySelf:Team() == TEAM_SPECTATOR) then return end
	if ENDROUND or ZOMBIE_CLASSES then return end
	
	GAMEMODE.ShowScoreboard = false
	gui.EnableScreenClicker(false)

	pScoreBoard.ViewPlayer = NULL
	for _, element in pairs(pScoreBoard.Elements) do
		element:Remove()
	end
	pScoreBoard.Elements = {}

	pScoreBoard:SetVisible( false )
end

function GM:HUDDrawScoreBoard()
end]=]

function GM:ScoreboardShow()
	if MySelf:Team() == TEAM_SPECTATOR then return end
	if ENDROUND or ZOMBIE_CLASSES then return end
	
	GAMEMODE.ShowScoreboard = true
	gui.EnableScreenClicker(true)

	if not SCPanel then
		self:CreateScoreboardVGUI()
	end

	-- pScoreBoard:SetVisible(true)
end

function GM:ScoreboardHide()
	if not left_scoreboard or not right_scoreboard then return end 
	if not ValidEntity (MySelf) then return end
	if (MySelf:Team() == TEAM_SPECTATOR) then return end
	if ENDROUND or ZOMBIE_CLASSES then return end
	
	GAMEMODE.ShowScoreboard = false
	self:RemoveScoreboardVGUI()
	gui.EnableScreenClicker(false)
	-- pScoreBoard:SetVisible( false )
end

function GM:HUDDrawScoreBoard()
end


