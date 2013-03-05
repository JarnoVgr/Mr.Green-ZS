-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local table = table
local surface = surface
local draw = draw
local math = math
local string = string
local util = util
local pairs = pairs
local team = team
local player = player
local vgui = vgui

local texGradient = surface.GetTextureID("gui/center_gradient")

local function SortFunc(a, b)
	return a:Frags() > b:Frags()
end

local colBackground = Color(10, 10, 10, 220)

--[=[local PANEL = {}

function PANEL:Init()
	SCOREBOARD = self
	--self.imgAvatar = vgui.Create( "AvatarImage", self )
	self.Elements = {}
end

-- BITCH BE SAPPING MAH SCOREBOARD!!! >:O
function PANEL:Paint()
	if ENDROUND then return end
	
	-- Close it if it's already open and we open the zombie classes menu
	if ( zClasses and zClasses:IsVisible() ) then SCOREBOARD:SetVisible ( false ) end
	
	local tall, wide = self:GetTall(), self:GetWide()
	local posx, posy = self:GetPos()

	draw.RoundedBox(8, 0, 0, wide, tall, colBackground)

	draw.DrawText("Zombie Survival "..GAMEMODE.Version, "ScoreboardHead", wide * 0.5, 0, COLOR_LIMEGREEN, TEXT_ALIGN_CENTER)
	surface.SetFont("HUDFont")
	local gmw, gmh = surface.GetTextSize("Z")
	draw.DrawText(GetGlobalString("servername"), "HUDFontSmaller2", wide * 0.5, gmh, COLOR_GRAY, TEXT_ALIGN_CENTER)
	surface.SetFont("HUDFontSmaller2")
	gmh = gmh+surface.GetTextSize("Z")
	local y = gmh+30
	local panPos = y
	local panLowPos = tall-32
	
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(30, y-2, wide - 60, panLowPos-y+4)

	surface.SetDrawColor(200, 200, 200, 255)
	surface.DrawOutlinedRect(30, y-2, wide - 60, panLowPos-y+4)

	local colHuman = team.GetColor(TEAM_HUMAN)
	local colUndead = team.GetColor(TEAM_UNDEAD)
	local colSpectator = team.GetColor (TEAM_SPECTATOR)

	local HumanPlayers = team.GetPlayers(TEAM_HUMAN)
	local UndeadPlayers = team.GetPlayers(TEAM_UNDEAD)
	local Spectators = team.GetPlayers (TEAM_SPECTATOR)
	
	local MySelf = LocalPlayer()

	table.sort(HumanPlayers, SortFunc)
	table.sort(UndeadPlayers, SortFunc)

	draw.DrawText("Players", "Default", 34, panPos-14, color_white, TEXT_ALIGN_LEFT)
	draw.DrawText("Title", "Default", 238, panPos-14, color_white, TEXT_ALIGN_LEFT)
	draw.DrawText("Class", "Default", 353, panPos-14, color_white, TEXT_ALIGN_LEFT) 
	draw.DrawText("Score", "Default", 425, panPos-14, color_white, TEXT_ALIGN_LEFT)
	draw.DrawText("Health", "Default", 468, panPos-14, color_white, TEXT_ALIGN_LEFT)
	draw.DrawText("Ping", "Default", wide-62, panPos-14, color_white, TEXT_ALIGN_RIGHT)

	-- Initialize titles
	for k, v in pairs(player.GetAll()) do
		if v.Title == nil then
			v.Title = ""
		end
	end
	
	surface.SetFont("Default")
	local width, height = surface.GetTextSize("Q")

	local humanclassname = ""
	local humanname = "" 
	for i, pl in pairs(HumanPlayers) do
		if MySelf:Team() == TEAM_HUMAN and pl:Team() == TEAM_HUMAN then
			humanclassname = "Unknown" -- HumanClasses[pl:GetHumanClass()].Name or "Unknown"
			if pl:GetHumanClass() == 3 then
				humanclassname = "Marksman"
			end
		else
			humanclassname = "Unknown"
		end
	
		humanname = pl:Name()		
		local fMaxHealth = pl:GetMaximumHealth()
		if fMaxHealth == math.huge then fMaxHealth = 100 end
		--local fHealth = math.Round ( math.Clamp ( ( pl:Health() / pl:GetMaximumHealth() ) * 100, 0, 100 ) )
		local fHealth = math.Round ( pl:Health())
		
		if y >= panLowPos-height then
			draw.DrawText("...", "Default", 34, y, colHuman, TEXT_ALIGN_LEFT)
			break
		else
			draw.DrawText(humanname, "Default", 34, y, colHuman, TEXT_ALIGN_LEFT)
			draw.DrawText(pl.Title, "Default", 246, y, colHuman, TEXT_ALIGN_CENTER) -- 192
			-- draw.DrawText(humanclassname, "Default", 365, y, colHuman, TEXT_ALIGN_CENTER)
			draw.DrawText(pl:Frags(), "Default", 433, y, colHuman, TEXT_ALIGN_CENTER)
			draw.DrawText(fHealth, "Default", 484, y, colHuman, TEXT_ALIGN_CENTER)
			draw.DrawText(pl:Ping(), "Default", 527, y, colHuman, TEXT_ALIGN_CENTER)
			y = y + height
			if pl == MySelf then
				surface.SetDrawColor (36,126,213,10)
				surface.DrawRect (31,y - height,537,height)
			end
		end
	end

	if team.NumPlayers (TEAM_HUMAN) > 0 then
		surface.SetDrawColor(200, 200, 200, 255)
		surface.DrawLine(32,y+height/4,wide-32,y+height/4)
		y = y + height/2
	end
	
	local status = 0
	local classname = ""
	local MySelf = LocalPlayer()
	for i, pl in ipairs(UndeadPlayers) do
		if MySelf:Team() == TEAM_UNDEAD then
			status = tostring(math.Clamp(pl:Health(),0,9999))
			classname = ZombieClasses[pl.Class or 1].Name
		else
			if pl:Alive() then
				status = "ALIVE-ish"
			else
				status = "DEAD"
			end
			classname = "Unknown"
		end
		
		if y >= panLowPos-height then
			draw.DrawText("...", "Default", 34, y, colUndead, TEXT_ALIGN_LEFT)
			break
		else
			draw.DrawText(pl:Name(), "Default", 34, y, colUndead, TEXT_ALIGN_LEFT)
			draw.DrawText(pl.Title, "Default", 246, y, colUndead, TEXT_ALIGN_CENTER) -- 192
			draw.DrawText(classname, "Default", 365, y, colUndead, TEXT_ALIGN_CENTER)
			draw.DrawText(pl:Frags(), "Default", 433, y, colUndead, TEXT_ALIGN_CENTER)
			draw.DrawText(status, "Default", 484, y, colUndead, TEXT_ALIGN_CENTER)
			draw.DrawText(pl:Ping(), "Default", 527, y, colUndead, TEXT_ALIGN_CENTER)
			y = y + height
			if pl == MySelf then
				surface.SetDrawColor (44,177,31,10)
				surface.DrawRect (31,y - height,537,height)
			end
		end
	end
	
	if team.NumPlayers (TEAM_UNDEAD) > 0 then
		surface.SetDrawColor(200, 200, 200, 255)
		surface.DrawLine(32,y+height/4,wide-32,y+height/4)
		y = y + height/2
	end
	
	for i, pl in ipairs(Spectators) do
		if y >= panLowPos-height then
			draw.DrawText("...", "Default", 34, y, colSpectator, TEXT_ALIGN_LEFT)
			break
		else
			draw.DrawText(pl:Name(), "Default", 34, y, colSpectator, TEXT_ALIGN_LEFT)
			draw.DrawText("Connecting", "Default", 246, y, colSpectator, TEXT_ALIGN_CENTER) -- 192
			draw.DrawText("N/A", "Default", 365, y, colSpectator, TEXT_ALIGN_CENTER)
			draw.DrawText("0", "Default", 433, y, colSpectator, TEXT_ALIGN_CENTER)
			draw.DrawText("0", "Default", 484, y, colSpectator, TEXT_ALIGN_CENTER)
			draw.DrawText(pl:Ping(), "Default", 527, y, colSpectator, TEXT_ALIGN_CENTER)
			y = y + height
		end
	end
	
	draw.DrawText("F1:  Help and Info - F2: Manual redeem - F3: Zombie classes - F4: Options", "HUDFontSmaller2", wide*0.5, tall-30, COLOR_LIMEGREEN, TEXT_ALIGN_CENTER)

	return true
end

function PANEL:PerformLayout()
	self:SetSize(600, h * 0.8)
	self:SetPos((w - self:GetWide()) * 0.5, (h - self:GetTall()) * 0.5)
end
vgui.Register("ScoreBoard", PANEL, "Panel")
]=]

-- We will do it easier


local function AddScoreboardItem(ply,list)
	
	MainLabel = MainLabel or {}

	if MainLabel[ply] then return end
	
	
	
	MainLabel[ply] = vgui.Create( "DLabel")
	MainLabel[ply].Player = ply
	
	MainLabel[ply]:SetSize(scoreboard_w,40)
	MainLabel[ply]:SetText("")
	
	MainLabel[ply].AvatarButton = MainLabel[ply]:Add( "DButton" )
	MainLabel[ply].AvatarButton:Dock( LEFT )
	MainLabel[ply].AvatarButton:DockMargin( 5, 4, 0, 4 )
	MainLabel[ply].AvatarButton:SetSize( 32, 32 )
	MainLabel[ply].AvatarButton:SetText("")
	MainLabel[ply].AvatarButton.DoClick = function() MainLabel[ply].Player:ShowProfile() end
	
	MainLabel[ply].Avatar = vgui.Create( "AvatarImage", MainLabel[ply].AvatarButton)
	MainLabel[ply].Avatar:SetSize( 32, 32 )
	MainLabel[ply].Avatar:SetMouseInputEnabled( false )	
	
	MainLabel[ply].Avatar:SetPlayer( ply )
	
	MainLabel[ply].Name	= MainLabel[ply]:Add( "DLabel" )
	MainLabel[ply].Name:Dock( FILL )
	MainLabel[ply].Name:SetText("")
	-- MainLabel[ply].Name:SetFont( "ArialBoldFive" )
	MainLabel[ply].Name:DockMargin( 15, 0, 0, 0 )
	MainLabel[ply].Name.Paint = function()
	local col = Color (255,255,255,255)
		
		if not IsValid(ply) then return end
		
		if ply:Team() == TEAM_UNDEAD then
			col = team.GetColor( ply:Team() )
		end
		draw.SimpleTextOutlined(ply:Nick() , "ArialBoldFive", 0,MainLabel[ply].Name:GetTall()/2, col, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end
	
	MainLabel[ply].Mute = MainLabel[ply]:Add( "DImageButton" )
	MainLabel[ply].Mute:SetSize( 32, 32 )
	MainLabel[ply].Mute:Dock( RIGHT )
	MainLabel[ply].Mute:DockMargin( 0, 4, 2, 4 )

	MainLabel[ply].Ping	= MainLabel[ply]:Add( "DLabel" )
	MainLabel[ply].Ping:Dock( RIGHT )
	MainLabel[ply].Ping:SetText("")
	MainLabel[ply].Ping:SetWidth( 50 )
	-- MainLabel[ply].Ping:SetFont( "ScoreboardDefault" )
	-- MainLabel[ply].Ping:SetTextColor( color_white )
	-- MainLabel[ply].Ping:SetContentAlignment( 5 )
	MainLabel[ply].Ping.Paint = function()
		local col = Color (255,255,255,255)
		
		if not IsValid(ply) then return end
		
		if ply:Team() == TEAM_UNDEAD then
			col = team.GetColor( ply:Team() )
		end
		draw.SimpleTextOutlined(ply:Ping() , "ArialBoldFive", MainLabel[ply].Ping:GetWide()/2,MainLabel[ply].Ping:GetTall()/2, col, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end

	MainLabel[ply].Health = MainLabel[ply]:Add( "DLabel" )
	MainLabel[ply].Health:Dock( RIGHT )
	MainLabel[ply].Health:SetText("")
	MainLabel[ply].Health:SetWidth( 50 )
	-- MainLabel[ply].Deaths:SetFont( "ScoreboardDefault" )
	-- MainLabel[ply].Deaths:SetTextColor( color_white )
	-- MainLabel[ply].Deaths:SetContentAlignment( 5 )
	MainLabel[ply].Health.Paint = function()
		local col = Color (255,255,255,255)
		
		if not IsValid(ply) then return end
		
		if ply:Team() == TEAM_UNDEAD then
			col = team.GetColor( ply:Team() )
		end
		
		local txt = "+"..ply:Health()
		if ply:Health() <= 0 then
			txt = "DEAD"
		end
		
		draw.SimpleTextOutlined(txt, "ArialBoldFive", MainLabel[ply].Health:GetWide()/2,MainLabel[ply].Health:GetTall()/2, col, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end

	MainLabel[ply].Kills = MainLabel[ply]:Add( "DLabel" )
	MainLabel[ply].Kills:Dock( RIGHT )
	MainLabel[ply].Kills:SetText("")
	MainLabel[ply].Kills:SetWidth( 60 )
	-- MainLabel[ply].Kills:SetFont( "ScoreboardDefault" )
	-- MainLabel[ply].Kills:SetTextColor( color_white )
	-- MainLabel[ply].Kills:SetContentAlignment( 5 )
	MainLabel[ply].Kills.Paint = function()
		local col = Color (255,255,255,255)
		
		if not IsValid(ply) then return end
		
		if ply:Team() == TEAM_UNDEAD then
			col = team.GetColor( ply:Team() )
		end
		draw.SimpleTextOutlined(ply:Frags() , "ArialBoldFive", MainLabel[ply].Kills:GetWide()/2,MainLabel[ply].Kills:GetTall()/2, col, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end
	
	MainLabel[ply].Think = function()
		
		if not IsValid(ply) then return end
	
		local self = MainLabel[ply]
		if ( self.Muted == nil or self.Muted ~= self.Player:IsMuted() ) then

			self.Muted = self.Player:IsMuted()
			if ( self.Muted ) then
				self.Mute:SetImage( "icon32/muted.png" )
			else
				self.Mute:SetImage( "icon32/unmuted.png" )
			end

			self.Mute.DoClick = function() self.Player:SetMuted( not self.Muted ) end

		end
	end
	
	MainLabel[ply].Paint = function()
		
		--[==[local x1 = 15+32+5
		local y1 = (scoreboard_h/11)/2-- MainLabel[ply]:GetTall()/2
		
		local col = Color (255,255,255,255)
		
		if ply:Team() == TEAM_UNDEAD then
			col = team.GetColor( ply:Team() )
		end
		
		draw.SimpleTextOutlined(ply:Nick() , "ArialBoldFive", x1,y1, col, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		x1 = scoreboard_w/1.7
		draw.SimpleTextOutlined(ply:Frags() , "ArialBoldFive", x1,y1, col, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		x1 = scoreboard_w/1.3
		draw.SimpleTextOutlined(ply:Health() , "ArialBoldFive", x1,y1, col, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		x1 = scoreboard_w-25
		draw.SimpleTextOutlined(ply:Ping() , "ArialBoldFive", x1,y1, col, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		]==]
		if not IsValid(ply) then return end
		
		if ply == MySelf then
			surface.SetDrawColor( 255, 255, 255, 255)
			surface.DrawOutlinedRect( 0, 0, MainLabel[ply]:GetWide(), MainLabel[ply]:GetTall())
			surface.DrawOutlinedRect( 1, 1, MainLabel[ply]:GetWide()-2, MainLabel[ply]:GetTall()-2 )
		else
			surface.SetDrawColor( 30, 30, 30, 200 )
			surface.DrawOutlinedRect( 0, 0, MainLabel[ply]:GetWide(), MainLabel[ply]:GetTall())
			surface.SetDrawColor( 30, 30, 30, 255 )
			surface.DrawOutlinedRect( 1, 1, MainLabel[ply]:GetWide()-2, MainLabel[ply]:GetTall()-2 )
		end
		
		
		
	end
	
	
	list:AddItem( MainLabel[ply] )
	
end

local function SwitchScoreboardItem(ply,from,to)
	if not ValidEntity(ply) then return end
	if not MainLabel then return end
	if not MainLabel[ply] then return end
	
	from:RemoveItem(MainLabel[ply])
	MainLabel[ply] = nil
	AddScoreboardItem(ply,to)	
	
	
	
	

end

local function RemoveScoreboardItem(ply,list)
	if not ValidEntity(ply) then return end
	if not MainLabel then return end
	if not MainLabel[ply] then return end
	
	list:RemoveItem(MainLabel[ply])
	MainLabel[ply] = nil
	
	

end

function GM:CreateScoreboardVGUI()
	
	-- small options
	
	SCPanel = vgui.Create("DFrame")
	SCPanel:SetSize(w,h)
	SCPanel:SetPos(0,0)
	SCPanel:SetDraggable ( false )
	SCPanel:SetTitle ("")
	-- SCPanel:SetSkin("ZSMG")
	SCPanel:ShowCloseButton (false)
	SCPanel.Paint = function() 
		-- override this
		draw.SimpleTextOutlined(GAMEMODE.Name , "ArialBoldTwenty", SCPanel:GetWide()/2,ScaleH(135), Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		draw.SimpleTextOutlined(GetGlobalString("servername") , "ArialBoldTwelve", SCPanel:GetWide()/2,ScaleH(180), Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
	end
	
	scoreboard_w,scoreboard_h = ScaleW(340), ScaleH(670)
	
	scoreboard_space = ScaleW(40)
	
	left_x,left_y = w/2 - scoreboard_space/2 - scoreboard_w, h/2 - scoreboard_h/2 + 25 +ScaleH(50)
	right_x,right_y = w/2 + scoreboard_space/2, h/2 - scoreboard_h/2 + 25+ScaleH(50)
	
	--[==[InfoLabel = vgui.Create( "DLabel",SCPanel)
	-- InfoLabel:ParentToHUD()
	InfoLabel:SetPos( left_x,left_y-25 )
	InfoLabel:SetSize( scoreboard_w*2+scoreboard_space,25 )
	InfoLabel:SetText("")
	InfoLabel.Paint = function()
		
		-- left
		DrawPanelBlackBox(0,0,scoreboard_w,InfoLabel:GetTall())
		-- right
		DrawPanelBlackBox(scoreboard_w+scoreboard_space,0,scoreboard_w,InfoLabel:GetTall())
		
		-- left text
		local x1 = 15
		local y1 = InfoLabel:GetTall()/2
		
		local col = Color (255,255,255,255)
		
		draw.SimpleTextOutlined("Players" , "ArialBoldFive", x1,y1, col, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		x1 = scoreboard_w/1.7
		draw.SimpleTextOutlined("Score" , "ArialBoldFive", x1,y1, col, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		x1 = scoreboard_w/1.3
		draw.SimpleTextOutlined("Health" , "ArialBoldFive", x1,y1, col, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		x1 = scoreboard_w-25
		draw.SimpleTextOutlined("Ping" , "ArialBoldFive", x1,y1, col, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		local spacing = scoreboard_w+scoreboard_space
		
		x1 = 15+spacing
		draw.SimpleTextOutlined("Players" , "ArialBoldFive", x1,y1, col, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		x1 = scoreboard_w/1.7 + spacing
		draw.SimpleTextOutlined("Score" , "ArialBoldFive", x1,y1, col, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		x1 = scoreboard_w/1.3 + spacing
		draw.SimpleTextOutlined("Health" , "ArialBoldFive", x1,y1, col, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		x1 = scoreboard_w-25 + spacing
		draw.SimpleTextOutlined("Ping" , "ArialBoldFive", x1,y1, col, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		
		
	end]==]
	
	
	left_scoreboard = vgui.Create( "DPanelList",SCPanel )
	-- left_scoreboard:ParentToHUD()
	left_scoreboard:SetPos( left_x,left_y )
	left_scoreboard:SetSize( scoreboard_w,scoreboard_h )
	left_scoreboard:SetSkin("ZSMG")
	left_scoreboard:SetSpacing(0)
	left_scoreboard:SetPadding(0)
	left_scoreboard:EnableVerticalScrollbar( true )
	left_scoreboard.Paint = function ()
		DrawPanelBlackBox(0,0,scoreboard_w,scoreboard_h)
	end
	
	
	right_scoreboard = vgui.Create( "DPanelList",SCPanel )
	-- right_scoreboard:ParentToHUD()
	right_scoreboard:SetPos( right_x,right_y )
	right_scoreboard:SetSize( scoreboard_w,scoreboard_h )
	right_scoreboard:SetSkin("ZSMG")
	right_scoreboard:SetSpacing(0)
	right_scoreboard:SetPadding(0)
	right_scoreboard:EnableVerticalScrollbar( true )
	right_scoreboard.Paint = function ()
		DrawPanelBlackBox(0,0,scoreboard_w,scoreboard_h)
	end
	
	left_scoreboard.Think = function()

		local HumanPlayers = team.GetPlayers(TEAM_HUMAN)
		local UndeadPlayers = team.GetPlayers(TEAM_UNDEAD)
		table.sort(HumanPlayers, SortFunc)
	
		for i, pl in ipairs(HumanPlayers) do
			AddScoreboardItem(pl,left_scoreboard,right_scoreboard,TEAM_HUMAN)
		end		
		-- left_scoreboard:Rebuild()
		for i, pl in ipairs(UndeadPlayers) do
			for k,v in pairs(left_scoreboard:GetItems()) do
				if pl == v.Player then
				-- RemoveScoreboardItem(pl,left_scoreboard)
				-- AddScoreboardItem(pl,right_scoreboard)
				SwitchScoreboardItem(pl,left_scoreboard,right_scoreboard)
				break
				end
			end
		end
		
		for k,v in pairs(left_scoreboard:GetItems()) do
			if not ValidEntity(v.Player) then
				left_scoreboard:RemoveItem(v)
				MainLabel[v.Player] = nil
			end
		end
		
	end
	-- ..............

	
	right_scoreboard.Think = function()
		local HumanPlayers = team.GetPlayers(TEAM_HUMAN)
		local UndeadPlayers = team.GetPlayers(TEAM_UNDEAD)
	
		table.sort(UndeadPlayers, SortFunc)
	
		for i, pl in pairs(UndeadPlayers) do
			AddScoreboardItem(pl,right_scoreboard,left_scoreboard,TEAM_UNDEAD)	
		end
		
		-- right_scoreboard:Rebuild()
		for i, pl in pairs(HumanPlayers) do
			for k,v in pairs(right_scoreboard:GetItems()) do
				if pl == v.Player then
					-- RemoveScoreboardItem(pl,right_scoreboard)
					-- AddScoreboardItem(pl,left_scoreboard)
					SwitchScoreboardItem(pl,right_scoreboard,left_scoreboard)
					break
				end
			end
		end
		
		for k,v in pairs(right_scoreboard:GetItems()) do
			if not ValidEntity(v.Player) then
				right_scoreboard:RemoveItem(v)
				MainLabel[v.Player] = nil
			end
		end
	
	end	
	-- ................
	
end

function GM:RemoveScoreboardVGUI()
	
	if SCPanel then
	
		SCPanel:Remove()
		SCPanel = nil
		MainLabel = nil
		
	end
	--[=[if left_scoreboard and right_scoreboard then
		
		left_scoreboard:Remove()
		left_scoreboard = nil
		right_scoreboard:Remove()
		right_scoreboard = nil
		InfoLabel:Remove()
		MainLabel = nil
		InfoLabel = nil
	end]=]

end