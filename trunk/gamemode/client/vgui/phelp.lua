-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local sbutton = {}

local labtable = {}

local function ShowHelpEntry(bl)
	pHelpEntry:SetVisible(bl)
end

local function ClearAch()
	for k, v in pairs(labtable) do
		v:Remove()
	end
	labtable = {}
end

local function ClearHTML()
	if pHelpHTML then
		pHelpHTML:Remove()
		pHelpHTML = nil
	end
end

local HelpBtn = {}

for i=1,#HELP_TXT do
	HelpBtn[i] = {name = HELP_TXT[i].title, action = function() ClearHTML() ClearAch() ShowHelpEntry(true); pHelpEntry:SetValue(HELP_TXT[i].txt or [[Wrong text. Check that]]) end}
end

HelpBtn[#HELP_TXT+1] = {
	name = "Achievements",
	action = function()
			
			ClearHTML()
			
			ShowHelpEntry(false)
			
			ClearAch()
			
			local ax,ay = 10, 55
			
			-- create player list
			local playerlist = vgui.Create("DComboBox",pHelp)  //vgui.Create("DScrollPanel",pHelp)
			playerlist:SetPos( ax,ay+25) 
			playerlist:SetSize( 150, 25 )
			table.insert(labtable,playerlist)
			-- update player list button
			local buttonUpdate = vgui.Create("DButton",pHelp)
			buttonUpdate:SetText( "Update Player List")
			buttonUpdate:SetPos(ax,ay)
			buttonUpdate:SetSize(150,25)
			table.insert(labtable,buttonUpdate)
			
			-- Top label
			local toplabel = vgui.Create("DLabel",pHelp)
			toplabel:SetText( "Select a player" )
			toplabel:SetPos( ax+150+5, ay ) 
			toplabel:SetSize( 500, 25 ) 
			table.insert(labtable,toplabel)
			
			-- List view
			local list = vgui.Create("DListView",pHelp)
			list:SetPos(ax+150+5,ay+25)
			list:SetSize(340,300)
			table.insert(labtable,list)
			
			list.SortByColumn = function() end
			
			local c0 = list:AddColumn( "Score/Achievement" ) 
			local c1 = list:AddColumn( "Progress" ) 

			c0:SetMinWidth( math.floor(340/2+10) )
			c0:SetMaxWidth( math.floor(340/2+10) )
			c1:SetMinWidth( math.floor(340/2-10) )
			c1:SetMaxWidth( math.floor(340/2-10) )
			
			-- image
			local achvimage = vgui.Create("DImage", pHelp)
			achvimage:SetPos(ax+150+5,ay+25+5+300)
			achvimage:SetSize(100,100)
			achvimage:SetImage( "zombiesurvival/achv_blank_zs" )
			achvimage:SetImageColor( Color(255,255,255,255) )
			table.insert(labtable,achvimage)
			
			-- description box
			local reasonbox = vgui.Create("DTextEntry",pHelp)
			reasonbox:SetPos( ax+150+5+100+5, ay+25+5+300 ) 
			reasonbox:SetSize( 235, 100 ) 
			reasonbox:SetEditable( false )
			reasonbox:SetMultiline( true )
			reasonbox:SetValue("< Select something to view the description! >")
			table.insert(labtable,reasonbox)
		
			-- Bottom label
			/*local botlabel = vgui.Create("DLabel",pHelp)
			botlabel:SetText( "NOTE: there must be at least 8 players ingame before you can get achievements!" )
			botlabel:SetPos( 16, 605 ) 
			botlabel:SetSize( 500, 25 ) 
			table.insert(labtable,botlabel)*/
			
			/*-- unlockinfo box
			local unlockbox = vgui.Create("DTextEntry",Window)
			unlockbox:SetPos( 120, 550 ) 
			unlockbox:SetSize( 410, 50 ) 
			unlockbox:SetEditable( false )
			unlockbox:SetMultiline( true )
			unlockbox:SetValue("")
			table.insert(labtable,unlockbox)*/
			
			/*-------------------------------
						Functions
			-------------------------------*/
				
			function updatePlayerList()
				playerlist:Clear()
				for k, v in pairs(player.GetAll()) do
					//v.Item = playerlist:AddItem( v:Name() )
					v.Item = playerlist:AddChoice( v:Name() )
				end	
				updateDoClicks()
				if LocalPlayer().Item then
					//LocalPlayer().Item:Select() -- Calls DoClick
					--playerlist:SelectItem(LocalPlayer().Item)
					playerlist:ChooseOptionID(LocalPlayer().Item)
				end
			end
					
			function updateScorelist( pl )

				list:Clear()	

				toplabel:SetText( "Fetching stats of player "..pl:Name().."..." )
				if not pl.DataTable then return end

				toplabel:SetText( "Stats of player "..pl:Name().." ("..(pl.Title or "")..")" )
				
				list:AddLine( "---------- SCORE ------------------------ ","----------------------------------" )
				
				local id
					list:Clear()
					for k, v in pairs( pl.DataTable ) do
						if type( v ) != "table" then
							if k != "coins" and k != "lastip" then
								local str = tostring( v )
								local secs, mins, hours
								if k == "timeplayed" then
									secs = tonumber(str)
									if secs != nil then
										mins = (secs-(secs%60))/60
										hours = (secs-(secs%(3600)))/3600
										mins = mins-(hours*60)
										str = tostring(hours).." hours, "..tostring(mins).." minutes"
									else
										str = "TIME RECORDING BROKEN"
									end
								end
								if k == "progress" then
									str = str.."%"
								end
								id = list:AddLine( k, str )
							end
						end
					end	

					list:AddLine( "------- ACHIEVEMENTS ---------------- ","----------------------------------" )
					
					for k, v in ipairs( achievementDesc ) do
						local str
						local statID = util.GetAchievementID( v )
						if pl.DataTable["Achievements"][k] == true then
							str = "<< ACHIEVED! >>"
						else
							str = "Unattained"
						end
						id = list:AddLine( achievementDesc[k].Name, str )
						id.Image = achievementDesc[k].Image
						id.Desc = achievementDesc[k].Desc
					end
			end
			
			/*--------------------------------
				DoClick functions and others
			--------------------------------*/
			
			function updateDoClicks()
				playerlist.OnSelect = function( panel,index, value, data )
					for k, pl in pairs(player.GetAll()) do
						if (pl.Item) and pl.Item == index then
							//pl.Item.DoClick = function( btn )
								-- It's getting quite messy around here...
								pl.StatsReceived = false
								updateScorelist( pl )
								RunConsoleCommand("get_playerstats",pl:UserID())
								-- Update score list with delay so server can send data
								timer.Create(pl:UserID().."statreceive",0.5,3,function( ply, dalist ) 
									if IsValid(ply) then
										if IsValid(dalist) then
											if IsValid(ply) and ply.StatsReceived then
												updateScorelist(ply)
												timer.Destroy(ply:UserID().."statreceive")
											end
										else
											timer.Destroy(ply:UserID().."statreceive")
										end
									end
								end,pl,list)
							//end
						end
					end
				end
			end
			
			list.OnRowSelected = function(lineID,line) 
				local theline = list:GetSelected()[1] -- those fucking function arguments do not contain the real line entity
				if (theline.Image and theline.Desc) then
					reasonbox:SetValue(theline.Desc)
					--unlockbox:SetValue(theline.UnlockInfo)
					achvimage:SetImage(theline.Image)
				else
					reasonbox:SetValue("< Select something to view the description! >")
					achvimage:SetImage( "zombiesurvival/achv_blank_zs" )
				end
			end
				
			buttonUpdate.DoClick = function( btn ) 
				updatePlayerList()
			end -- update playerlist	
			
			updatePlayerList()
			
	end
}

HelpBtn[#HELP_TXT+2] = {
	name = "Adv. Guide",
	action = function()
		
		ClearHTML()
		
		ShowHelpEntry(false)
			
		ClearAch()
	
		local guide = vgui.Create("HTML",pHelp)
		guide:SetPos( 10, 55 ) 
		guide:SetSize( 490, 430 ) 
		guide:OpenURL("http://forums.mrgreengaming.com/topic/10337-zombie-survival-20-the-basics/page__view__findpost__p__100237")
		
		pHelpHTML = guide
		
	end
}

HelpBtn[#HELP_TXT+3] = {
	name = "Green Shop",
	action = function()
		
		pHelp:Close()
		
		DrawGreenShop()
		
	end
}

function MakepHelp( nr )
		
	local ww,wh = 600, 500
	local wx,wy = w/2-ww/2,h/2-wh/2
	
	local MainWindow = vgui.Create("DFrame")
	MainWindow:SetSize(ww,wh)
	MainWindow:SetPos(wx,wy)
	MainWindow:SetSkin("ZSMG")
	MainWindow:SetTitle( "" ) --"F1: Help | F2: Redeem (as zombie) | F3: Drop weapon (as human)/Open class menu (as zombie) | F4: Options"
	MainWindow:SetDraggable (false)
	MainWindow:SetSizable(false)
	MainWindow:MakePopup()
	
	MainWindow.PaintOver = function()
		draw.SimpleTextOutlined ( "F1: Help | F2: Redeem (as zombie) | F3: Drop weapon (as human)/Open class menu (as zombie) | F4: Options", "ArialBoldFour", 10, 30, Color(255, 255, 255, 255) , TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP,1,Color(0,0,0,255))
	end
	
	local MainWindowEntry = vgui.Create("DTextEntry",MainWindow)
	MainWindowEntry:SetPos( 10, 55 ) 
	MainWindowEntry:SetSize( ww-110, wh-70 ) 
	MainWindowEntry:SetEditable( false )
	MainWindowEntry:SetValue(HELP_TXT[nr] or [[Nothing at all!]])
	MainWindowEntry:SetMultiline( true )
	
	
	pHelpEntry = MainWindowEntry
	pHelp = MainWindow

	
	local btn = {}
	local step = 0
	for i=1,#HelpBtn do
		
		btn[i] = vgui.Create("DButton",MainWindow)
		btn[i]:SetText(HelpBtn[i].name or "Error name")
		btn[i]:SetSize(80,25)
		btn[i]:SetPos(ww-80-10,55+step)
		btn[i].DoClick = HelpBtn[i].action
		step = step + 25 + 5
	end
	
	local page = 1
	
	if nr then page = nr end
	
	if HelpBtn[page] then
		HelpBtn[page].action()
	end

end
