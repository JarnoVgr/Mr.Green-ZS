--Colors
local COLOR_SUBTITLE = Color ( 146,146,146,255 )
local COLOR_TITLE = Color ( 255,245,245,255 )
local COLOR_GREY_ONE = Color ( 99,99,99,255 )
local COLOR_DARK_GREY = Color ( 35,35,35,255 )
local COLOR_BLUE = Color ( 139,183,220,255 )
local COLOR_LIGHT_GREY = Color ( 62,62,62,255 )
local COLOR_LIGHT_RED = Color ( 116,26,26,255 )
local COLOR_DARK_GREY_BUTTON = Color ( 12,72,122,255 )
local COLOR_DARK_RED = Color ( 123,24,24,255 )

--[[---------------------------------------------------------
			 --  Team score panel
---------------------------------------------------------]]
local TEAMSCORE_PANEL = {}
 
function TEAMSCORE_PANEL:Init()
	TEAMSCORE = self
	DoLabel(5, self, "ArialBoldEighteen", ">", ScaleW(412), ScaleH(54), COLOR_DARK_GREY_BUTTON, "next", COLOR_DARK_GREY ) --Next Button
	DoLabel(6, self, "ArialBoldEighteen", "<", ScaleW(383), ScaleH(54), COLOR_DARK_GREY_BUTTON, "prev", COLOR_DARK_GREY ) --Return Button
	   
	--Limit for scores
	self.ScoreBest = {
		["General scores"] = 100,
		["GreenCoins gained"] = 1000
	}
end
 
local Teams = {"Team Humans", "Team Undead" }
 
function TEAMSCORE_PANEL:Paint()
		local Wide = self:GetWide()
		local Tall = self:GetTall()
	   
		draw.RoundedBox(8, 0, 0, Wide, Tall, COLOR_DARK_GREY )
		surface.SetDrawColor ( COLOR_BLUE )
	   
		--Dynamic stuff
		local nextsign,prevsign = ">","<"
		local subtitle = self.PageSubtitles[self.Page]
	   
		if SCREEN then
				surface.DrawRect ( 7,7, Wide - 14, ScaleH(93) )
				draw.SimpleText ("TEAM SCORES","ArialBoldEighteen", ScaleW(25),ScaleH(39), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				draw.SimpleText (subtitle,"ArialBoldNine", ScaleW(28),ScaleH(77), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
 
				--Draw the button > and <
				draw.SimpleText (nextsign,"ArialBoldEighteen",ScaleW(412),ScaleH(54), IntermissionColorLabels[5],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				draw.SimpleText (prevsign,"ArialBoldEighteen",ScaleW(383),ScaleH(54), IntermissionColorLabels[6],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
					   
				self.Height = ScaleH(122)
				for i = 1,2 do
						--Draw selection rectangle over your team.
						if ( MySelf:Team() == TEAM_HUMAN and i == 1 ) or ( MySelf:Team() == TEAM_UNDEAD and i == 2 ) then
								surface.SetDrawColor ( COLOR_LIGHT_GREY )
								surface.DrawRect ( 7, self.Height - ScaleH(15), Wide - 14, ScaleH(30) )
						end
					   
						--Subtitle and score
						local score = "No Score"
						if subtitle then
								if GeneralTeamScores[ subtitle ] then
										score = GeneralTeamScores[ subtitle ][i]
								end
						end
					   
						--Set up some nice titles :D
						local scorenumber = tonumber(score)
						local title = ""
					   
						if scorenumber ~= nil then
								if scorenumber >= self.ScoreBest[subtitle] then
										title = "(Co-op)"
								elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 2 ) then
										title = "(Organized)"
								elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 3 ) then
										title = "(Lazy)"
								elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 4 ) then
										title = "(Newbie-ish)"
								elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 5 ) then
										title = "(Mingebag Cluster)"
								end
							   
								if title ~= "" then
										surface.SetDrawColor ( COLOR_DARK_RED )
										surface.DrawRect ( 7, self.Height - ScaleH(15), Wide - 14, ScaleH(30) )
								end
						end
					   
						--Write winner in front of the winner :P
						if ( i == 1 and WinnerTeam == TEAM_HUMAN ) or ( i == 2 and WinnerTeam == TEAM_UNDEAD ) then
								title = title.." (Winner)"
						end
					   
						draw.SimpleText (Teams[i].." "..title,"ArialNine", ScaleW(18),self.Height, COLOR_BLUE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
						draw.SimpleText (tostring(score),"ArialNine", Wide - 17,self.Height, COLOR_BLUE, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
						self.Height = self.Height + ScaleH(34)
				end    
		elseif WIDESCREEN then
				surface.DrawRect ( 7,7, Wide - 14, ScalePanel(93) )
				draw.SimpleText("TEAM SCORES","ArialBoldEighteen", ScalePanel(25),ScalePanel(39), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				draw.SimpleText(subtitle,"ArialBoldNine", ScalePanel(28),ScalePanel(77), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
 
				--Draw the button > and <
				draw.SimpleText(nextsign,"ArialBoldEighteen",ScalePanel(412),ScalePanel(54), IntermissionColorLabels[5],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				draw.SimpleText(prevsign,"ArialBoldEighteen",ScalePanel(383),ScalePanel(54), IntermissionColorLabels[6],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			   
				self.Height = ScalePanel(122)
				for i = 1,2 do
						--Draw selection rectangle over your team.
						if ( MySelf:Team() == TEAM_HUMAN and i == 1 ) or ( MySelf:Team() == TEAM_UNDEAD and i == 2 ) then
								surface.SetDrawColor ( COLOR_LIGHT_GREY )
								surface.DrawRect ( 7, self.Height - ScalePanel(15), Wide - 14, ScalePanel(30) )
						end
					   
						--Subtitle and score
						local score = "No Score"
						if subtitle then
								if GeneralTeamScores[ subtitle ] then
										score = GeneralTeamScores[ subtitle ][i]
								end
						end
					   
						--Set up some nice titles :D
						local scorenumber = tonumber(score)
						local title = ""
					   
						if scorenumber ~= nil then
								if scorenumber >= self.ScoreBest[subtitle] then
										title = "(Co-op)"
								elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 2 ) then
										title = "(Organized)"
								elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 3 ) then
										title = "(Lazy)"
								elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 4 ) then
										title = "(Newbie-ish)"
								elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 5 ) then
										title = "(Mingebag Cluster)"
								end
							   
								if title ~= "" then
										surface.SetDrawColor ( COLOR_DARK_RED )
										surface.DrawRect ( 7, self.Height - ScalePanel(15), Wide - 14, ScalePanel(30) )
								end
						end
					   
						--Write winner in front of the winner :P
						if ( i == 1 and WinnerTeam == TEAM_HUMAN ) or ( i == 2 and WinnerTeam == TEAM_UNDEAD ) then
								title = title.." (Winner)"
						end
					   
						draw.SimpleText (Teams[i].." "..title,"ArialNine", ScalePanel(18),self.Height, COLOR_BLUE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
						draw.SimpleText (tostring(score),"ArialNine", Wide - 17,self.Height, COLOR_BLUE, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
						self.Height = self.Height + ScalePanel(34)
				end    
		end
			   
		return true
end
 
function TEAMSCORE_PANEL:PerformLayout()
	if SCREEN then
		self:SetSize ( ScaleW(449),ScaleH(179) )
		self:SetPos ( ScaleW(865),ScaleH(348) )
	elseif WIDESCREEN then
		self:SetSize ( ScalePanel(479),ScalePanel(178) )
		self:SetPos ( ScaleW(867),ScaleH(310) )
	end
	   
	--Align the panel to the center.
	self:AlignCenter()
end
vgui.Register("Teamscore", TEAMSCORE_PANEL, "Panel")