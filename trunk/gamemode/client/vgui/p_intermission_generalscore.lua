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
		   Damage/Healing etc Panel
---------------------------------------------------------]]
local GENERALSCORE_PANEL = {}
 
function GENERALSCORE_PANEL:Init()
		local Wide, Tall
	   
		if SCREEN then
			Wide, Tall = ScaleW(704),ScaleH(288)
		else
			Wide, Tall = ScalePanel(704),ScalePanel(288)
		end
	   
		--Limit for scores
		self.ScoreBest = {
			["Survival of the fittest"] = 0,
			["Most GreenCoins gained"] = 100 ,
			["Most assists (both teams)"] = 50,
			["Most healing done (medic)"] = 300,
			["Most undead killed"] = 70,
			["Damage done to humans"] = 1000,
			["Most brains eaten"] = 12,
			["Damage done to undead"] = 10000
		}
	   
		GENERALSCORE = self
		DoLabel( 7, self, "ArialBoldEighteen", ">", Wide - ScaleW(36), ScaleH(57), COLOR_DARK_GREY_BUTTON, "next", COLOR_DARK_GREY) --Next button
		DoLabel( 8, self, "ArialBoldEighteen", "<", Wide - ScaleW(64), ScaleH(57), COLOR_DARK_GREY_BUTTON, "prev", COLOR_DARK_GREY) --Prev button
end
 
----Materials for the picture for each rank - Don't change the ORDER! (With chainsawman's help)
local ScoreImage = {
	[8] = surface.GetTextureID("mrgreen/intermission/mostdamagedone"),
	[4] = surface.GetTextureID("mrgreen/intermission/healing"),
	[3] = surface.GetTextureID("mrgreen/intermission/assists"),
	[2] = surface.GetTextureID("mrgreen/intermission/greencoins"),
	[1] = surface.GetTextureID("mrgreen/intermission/survival"),
	[6] = surface.GetTextureID("mrgreen/intermission/damagezombies"),
	[5] = surface.GetTextureID("mrgreen/intermission/undeadkilled"),
	[7] = surface.GetTextureID("mrgreen/intermission/brains"),
}
 
function GENERALSCORE_PANEL:Paint()
		local Wide = self:GetWide()
		local Tall = self:GetTall()
	   
		draw.RoundedBox(8, 0, 0, Wide, Tall, COLOR_DARK_GREY )
		surface.SetDrawColor ( COLOR_BLUE )
	   
		local nextsign,prevsign = ">","<"
		local subtitle = self.PageSubtitle[self.Page]
		local title = ""
	   
		if subtitle == "Most assists (both teams)" or subtitle == "Most healing done (medic)" then
				title = self.PageTitle[3]
		elseif subtitle == "Most undead killed" or subtitle == "Damage done to humans" or subtitle == "Most brains eaten" or subtitle == "Damage done to undead" then
				title = self.PageTitle[2]
		else
				title = self.PageTitle[1]
		end
	   
		if SCREEN then
				surface.DrawRect ( ScaleW(280),7, Wide - ScaleW(280) - 7, ScaleH(100) )
				draw.SimpleText (title,"ArialBoldEighteen", ScaleW(295),ScaleH(40), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				draw.SimpleText (subtitle,"ArialBoldNine", ScaleW(298),ScaleH(80), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
 
				--Draw the button > and <
				draw.SimpleText (nextsign,"ArialBoldEighteen",Wide - ScaleW(36),ScaleH(57), IntermissionColorLabels[7],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				draw.SimpleText (prevsign,"ArialBoldEighteen",Wide - ScaleW(64),ScaleH(57), IntermissionColorLabels[8],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
 
				--Draw the specific image
				if ScoreImage[self.Page] and ScoreImage[self.Page] > 0 then
					surface.SetTexture(ScoreImage[self.Page])
					surface.SetDrawColor(Color(255,255,255,255))
					surface.DrawTexturedRectRotated(ScaleW(140), Tall / 2, ScaleW(267), ScaleH(270), 0)
				end
			   
				local h = ScaleH(129)
				for i = 1,5 do
						--Page setup!
						local playername,playerscore = "",""
						if subtitle == "Most GreenCoins gained" then
								if TopGreencoinsGained[i] then
										playername = TopGreencoinsGained[i].Name
										playerscore = TopGreencoinsGained[i].Score
								end
						elseif subtitle == "Survival of the fittest" then
								if TopSurvivalTimes[i] then
										playername = TopSurvivalTimes[i].Name
										playerscore = TopSurvivalTimes[i].Score
								end                    
						elseif subtitle == "Most assists (both teams)" then
								if TopAssists[i] then
										playername = TopAssists[i].Name
										playerscore = TopAssists[i].Score
								end
						elseif subtitle == "Most healing done (medic)" then
								if TopHealing[i] then
										playername = TopHealing[i].Name
										playerscore = TopHealing[i].Score
								end    
						elseif subtitle == "Most undead killed" then
								if TopZombiesKilled[i] then
										playername = TopZombiesKilled[i].Name
										playerscore = TopZombiesKilled[i].Score
								end            
						elseif subtitle == "Damage done to humans" then
								if TopZombieDamage[i] then
										playername = TopZombieDamage[i].Name
										playerscore = TopZombieDamage[i].Score
								end    
						elseif subtitle == "Most brains eaten" then
								if TopBrainsEaten[i] then
										playername = TopBrainsEaten[i].Name
										playerscore = TopBrainsEaten[i].Score
								end    
						elseif subtitle == "Damage done to undead" then
								if TopHumanDamage[i] then
										playername = TopHumanDamage[i].Name
										playerscore = TopHumanDamage[i].Score
								end    
						end
					   
						--Draw selection box over your name
						if MySelf:Name() == playername then
								surface.SetDrawColor ( COLOR_LIGHT_GREY )
								surface.DrawRect ( ScaleW(280), h - ScaleH(15), Wide - ScaleW(287), ScaleH(30) )
						end
					   
						if i == 1 then
								local scorenumber = tonumber(playerscore)
								local title = ""
								if scorenumber ~= nil then
										if scorenumber >= self.ScoreBest[subtitle] then
												title = "(Insane)"
										elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 2 ) then
												title = "(Skilled)"
										elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 3 ) then
												title = "(Mediocre)"
										elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 4 ) then
												title = "(Newbie)"
										elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 10 ) then
												title = "(Mingebag)"
										end
																			   
										if title ~= "" then
												playername = playername.." "..title
												surface.SetDrawColor ( COLOR_DARK_RED )
												surface.DrawRect ( ScaleW(280), h - ScaleH(15), Wide - ScaleW(287), ScaleH(30) )
										end
								end
						end
			   
						--Format player name so it doesn't exceed a character limit
						local text = string.Explode ("", playername )
						playername = ""
						for k,v in pairs (text) do
								if k <= 25 then
										playername = playername..v
								elseif k > 25 and k <= 28 then
										playername = playername.."."
								end
						end
							   
						draw.SimpleText (playername,"ArialNine", ScaleW(280 + 7),h, COLOR_BLUE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
						draw.SimpleText (playerscore,"ArialNine", Wide - 17,h, COLOR_BLUE, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
						h = h + ScaleH(34)
				end    
		elseif WIDESCREEN then
				surface.DrawRect ( ScalePanel(280),7, Wide - ScalePanel(280) - 7, ScalePanel(100) )
				draw.SimpleText (title,"ArialBoldEighteen", ScalePanel(295),ScalePanel(40), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				draw.SimpleText (subtitle,"ArialBoldNine", ScalePanel(297),ScalePanel(80), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			   
				--Draw the button > and <
				draw.SimpleText (nextsign,"ArialBoldEighteen",Wide - ScalePanel(36),ScalePanel(57), IntermissionColorLabels[7],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				draw.SimpleText (prevsign,"ArialBoldEighteen",Wide - ScalePanel(64),ScalePanel(57), IntermissionColorLabels[8],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
 
				--Draw the specific image
				if ScoreImage[self.Page] and ScoreImage[self.Page] > 0 then
					surface.SetTexture(ScoreImage[self.Page])
					surface.SetDrawColor(Color(255, 255, 255, 255))
					surface.DrawTexturedRectRotated(ScalePanel(140), Tall / 2, ScalePanel(267), ScalePanel(270), 0)
				end
			   
				local h = ScalePanel(129)
				for i = 1,5 do
						--Page setup!
						local playername,playerscore = "",""
						if subtitle == "Most GreenCoins gained" then
								if TopGreencoinsGained[i] then
										playername = TopGreencoinsGained[i].Name
										playerscore = TopGreencoinsGained[i].Score
								end
						elseif subtitle == "Survival of the fittest" then
								if TopSurvivalTimes[i] then
										playername = TopSurvivalTimes[i].Name
										playerscore = TopSurvivalTimes[i].Score
								end                    
						elseif subtitle == "Most assists (both teams)" then
								if TopAssists[i] then
										playername = TopAssists[i].Name
										playerscore = TopAssists[i].Score
								end
						elseif subtitle == "Most healing done (medic)" then
								if TopHealing[i] then
										playername = TopHealing[i].Name
										playerscore = TopHealing[i].Score
								end    
						elseif subtitle == "Most undead killed" then
								if TopZombiesKilled[i] then
										playername = TopZombiesKilled[i].Name
										playerscore = TopZombiesKilled[i].Score
								end            
						elseif subtitle == "Damage done to humans" then
								if TopZombieDamage[i] then
										playername = TopZombieDamage[i].Name
										playerscore = TopZombieDamage[i].Score
								end    
						elseif subtitle == "Most brains eaten" then
								if TopBrainsEaten[i] then
										playername = TopBrainsEaten[i].Name
										playerscore = TopBrainsEaten[i].Score
								end    
						elseif subtitle == "Damage done to undead" then
								if TopHumanDamage[i] then
										playername = TopHumanDamage[i].Name
										playerscore = TopHumanDamage[i].Score
								end    
						end
					   
						--Draw selection box over your name
						if MySelf:Name() == playername then
								surface.SetDrawColor ( COLOR_LIGHT_GREY )
								surface.DrawRect ( ScalePanel(280), h - ScalePanel(15), Wide - ScalePanel(287), ScalePanel(30) )
						end
					   
						if i == 1 then
								local scorenumber = tonumber(playerscore)
								local title = ""
								if scorenumber ~= nil then
										if scorenumber >= self.ScoreBest[subtitle] then
												title = "(Insane)"
										elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 2 ) then
												title = "(Skilled)"
										elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 3 ) then
												title = "(Mediocre)"
										elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 4 ) then
												title = "(Newbie)"
										elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 10 ) then
												title = "(Mingebag)"
										end
																			   
										if title ~= "" then
												playername = playername.." "..title
												surface.SetDrawColor ( COLOR_DARK_RED )
												surface.DrawRect ( ScalePanel(280), h - ScalePanel(15), Wide - ScalePanel(287), ScalePanel(30) )
										end
								end
						end
					   
						--Format player name so it doesn't exceed a character limit
						local text = string.Explode ("", playername )
						playername = ""
						for k,v in pairs (text) do
								if k <= 25 then
										playername = playername..v
								elseif k > 25 and k <= 28 then
										playername = playername.."."
								end
						end
							   
						draw.SimpleText (playername,"ArialNine", ScalePanel(280 + 7),h, COLOR_BLUE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
						draw.SimpleText (playerscore,"ArialNine", Wide - ScalePanel(17),h, COLOR_BLUE, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
						h = h + ScalePanel(34)
				end    
		end
	   
		return true
end
 
function GENERALSCORE_PANEL:PerformLayout()
	if SCREEN then
		self:SetSize ( ScaleW(704),ScaleH(288) )
		self:SetPos ( ScaleW(893),ScaleH(625) )
	elseif WIDESCREEN then
		self:SetSize ( ScalePanel(704),ScalePanel(288) )
		self:SetPos ( ScaleW(889),ScaleH(641) )
	end
	   
	--Align the panel to the center.
	self:AlignCenter()
end
vgui.Register("Generalscore", GENERALSCORE_PANEL, "Panel")