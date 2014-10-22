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
			  -- Nitwits panel
---------------------------------------------------------]]
local NITWITS_PANEL = {}
 
function NITWITS_PANEL:Init()
	NITWITS = self
	if SCREEN then
		self:SetSize ( ScaleW(440),ScaleH(317) )
	elseif WIDESCREEN then
		self:SetSize ( ScalePanel(440),ScalePanel(216) )
	end
	   
	DoLabel( 3, self, "ArialBoldEighteen", ">", ScaleW(400), ScaleH(54), COLOR_DARK_GREY_BUTTON, "next", COLOR_DARK_GREY ) --Next button
	DoLabel( 4, self, "ArialBoldEighteen", "<", ScaleW(370), ScaleH(54), COLOR_DARK_GREY_BUTTON, "prev", COLOR_DARK_GREY ) --Prev button
end
 
function NITWITS_PANEL:Paint()
		local Wide = self:GetWide()
		local Tall = self:GetTall()
	   
		draw.RoundedBox(8, 0, 0, Wide, Tall, COLOR_DARK_GREY )
		surface.SetDrawColor ( COLOR_BLUE )
	   
		local nextsign, prevsign = ">", "<"
	   
		if SCREEN then
				surface.DrawRect ( 7,7, Wide - 14, ScaleH(93) )
				draw.SimpleText ("TOP RANKS","ArialBoldEighteen", ScaleW(25),ScaleH(39), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				draw.SimpleText ("Veteran scores (page "..self.Page..")","ArialBoldNine", ScaleW(28),ScaleH(77), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
 
				--Draw the buttons > and <
				draw.SimpleText (nextsign,"ArialBoldEighteen",ScaleW(400),ScaleH(54), IntermissionColorLabels[3],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				draw.SimpleText (prevsign,"ArialBoldEighteen",ScaleW(370),ScaleH(54), IntermissionColorLabels[4],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			   
				self.Height = ScaleH(122)
				for i = 1,#self.PageScoreName do
						if self.Page == 2 then
								if i == 7 then
										self.Height = ScaleH(122)
								end
						end
					   
						local scoredesc = self.PageScoreName[i]
						local playername = self.PageScore[i]
					   
						if (self.Page == 1 and i < 7) or (self.Page == 2 and i >= 7 ) then
								--Draw the selection box on your name
								local howmany,slot = 0,0
								if MySelf:Name() == playername then
										for i = 1, #self.PageScoreName do
												if self.PageScore[i] == MySelf:Name() then
														slot = i
														if i == 2 then
																break
														end
												end
										end
										for i = 1, #self.PageScoreName do
												if self.PageScore[i] == MySelf:Name() then
														howmany = howmany + 1
												end
										end
									   
										if i == slot and howmany > 1 then
												surface.SetDrawColor ( Color ( 116,26,26,252 * math.abs ( math.sin ( CurTime() * 2.1 ) ) ) )
												scoredesc = scoredesc.." (bonus)"
										else
												surface.SetDrawColor ( COLOR_LIGHT_GREY )
										end
									   
										surface.DrawRect ( 7, self.Height - ScaleH(15), Wide - 14, ScaleH(30) )
								end
							   
								--Format player name so it doesn't exceed a character limit
								local text = string.Explode ("", playername )
								playername = ""
								for k,v in pairs (text) do
										if k <= 14 then
												playername = playername..v
										elseif k > 14 and k <= 17 then
												playername = playername.."."
										end
								end
 
								--Draw the description of the nitwit and name of the veteran
								draw.SimpleText (scoredesc,"ArialNine", ScaleW(18),self.Height, COLOR_BLUE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
								draw.SimpleText (playername,"ArialNine", Wide - 17,self.Height, COLOR_BLUE, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
								self.Height = self.Height + ScaleH(34)
						end
				end    
		elseif WIDESCREEN then
				surface.DrawRect ( 7,7, Wide - 14 , ScalePanel(93) )
				draw.SimpleText ("TOP RANKS","ArialBoldEighteen", ScalePanel(25),ScalePanel(39), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				draw.SimpleText ("Veteran scores (page "..self.Page..")","ArialBoldNine", ScalePanel(28),ScalePanel(77), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
 
				--Draw the button > and <
				draw.SimpleText (nextsign,"ArialBoldEighteen",ScalePanel(400),ScalePanel(54), IntermissionColorLabels[3],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				draw.SimpleText (prevsign,"ArialBoldEighteen",ScalePanel(370),ScalePanel(54), IntermissionColorLabels[4],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
 
				self.Height = ScalePanel(122)
				for i = 1,#self.PageScoreName do
						if self.Page == 2 then
								if i == 4 then
										self.Height = ScalePanel(122)
								end
						end
					   
						local scoredesc = self.PageScoreName[i]
						local playername = self.PageScore[i]
					   
						if (self.Page == 1 and i < 4) or (self.Page == 2 and (i < 7 and i >= 4) ) or (self.Page == 3 and (i < 10 and i >= 7) ) or (self.Page == 4 and (i < 13 and i >= 10) ) then
								--Draw the selection box on your name
								local howmany,slot = 0,0
								if MySelf:Name() == playername then
										for i = 1, #self.PageScoreName do
												if self.PageScore[i] == MySelf:Name() then
														slot = i
														break
												end
										end
										for i = 1, #self.PageScoreName do
												if self.PageScore[i] == MySelf:Name() then
														howmany = howmany + 1
												end
										end
									   
										if i == slot and howmany > 1 then
												surface.SetDrawColor ( Color ( 116,26,26,252 * math.abs ( math.sin ( CurTime() * 2.1 ) ) ) )
												scoredesc = scoredesc.." (bonus)"
										else
												surface.SetDrawColor ( COLOR_LIGHT_GREY )
										end
										surface.DrawRect ( 7, self.Height - ScalePanel(15), Wide - 14, ScalePanel(30) )
								end
							   
								--Format player name so it doesn't exceed a character limit
								local text = string.Explode ("", playername )
								playername = ""
								for k,v in pairs (text) do
										if k <= 14 then
												playername = playername..v
										elseif k > 14 and k <= 17 then
												playername = playername.."."
										end
								end
							   
								--Draw the description of the nitwit and name of the veteran
								draw.SimpleText (scoredesc,"ArialNine", ScaleW(18),self.Height, COLOR_BLUE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
								draw.SimpleText (playername,"ArialNine", Wide - 17,self.Height, COLOR_BLUE, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
								self.Height = self.Height + ScalePanel(34)
						end
				end    
		end
	   
		---Resize the panel (we only need height)
		local height = self.Height - ScaleH(10)
		if WIDESCREEN then height = self.Height - ScalePanel(12) end
	   
		self:Resize ( nil, height )
	   
		self:PerformLayout()
			   
		return true
end
 
function NITWITS_PANEL:PerformLayout()
		if SCREEN then
				self:SetPos ( ScaleW(269),ScaleH(676) )
		elseif WIDESCREEN then
				self:SetPos ( ScaleW(261),ScaleH(672) )
		end
 
		--Align the panel to the center.
		self:AlignCenter()
end
 
function NITWITS_PANEL:Resize ( w, h )
		if SCREEN then
				self:SetSize ( ScaleW(440), h )
		else
				self:SetSize ( ScalePanel(440), h )
		end
end
vgui.Register("Nitwits", NITWITS_PANEL, "Panel")


--[[---------------------------------------------------------
   --  Receive Nitwits (as Clavus or Ywa named them)
---------------------------------------------------------]]
 
--Init the Nitwits table
local Nitwits = {}
 
local function ReceiveNitwits(um)
		--Reset any existing table
		table.Empty(Nitwits)
	   
		--A total of 12 Nitwits (HOLY SHIT)
		for i = 1,12 do
			Nitwits[i] = um:ReadString()
		end
end
usermessage.Hook("RcTopNitwits", ReceiveNitwits)
 
--[[---------------------------------------------------------
			  -- Manage Nitwits
---------------------------------------------------------]]
function ManageNitwits ( panel )
		--Create the actual nitwit list desc.
		local NitwitsInOrder = {
			"Most scary player",
			"Most horny player",
			"Most unhappy player",
			"Most brutal player",
			"Most propkills",
			"Last human",
			"Most headshots",
			"Most helpful player",
			"Most undead meleed",
			"First player redeemed",
			"Most GreenCoins gained",
			"Hungriest zombie"
		}      
 
		panel.PageScoreName = {} --Nitwit name / description
		panel.PageScore = {} --Player names
 
		local id = 0
		for k,v in ipairs (Nitwits) do
				id = id + 1
				if v ~= "" then
						panel.PageScoreName[id] = NitwitsInOrder[k]
						panel.PageScore[id] = Nitwits[k]
				end
		end
	   
		--Convert the tables to consecutive keys from 1 to .. how many items are in there
		table.Resequence ( panel.PageScoreName )
		table.Resequence ( panel.PageScore )
	   
		--Manage page stuff
		panel.Page = 1 --Current Page
	   
		--Maximum pages stuff
		local entryperpage = 0
		if SCREEN then
			entryperpage = 6
		else   
			entryperpage = 3
		end
	   
		--Calc total pages
		panel.MaxPages = math.ceil ( #panel.PageScoreName / entryperpage )
	   
		--Close the panel if there are 0-1 players in it
		if #panel.PageScoreName <= 1 then
			panel:SetVisible(false)
			panel = nil
		end
end