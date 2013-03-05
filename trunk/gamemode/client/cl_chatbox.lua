-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Custom chat box

CustomChat = {}
CustomChat.Lines = {}
CustomChat.ChatOpen = false
CustomChat.FadeTime = 10 

--  Don't change these vars
CustomChat.ChatBoxFrameOffset = ScaleH(15)
CustomChat.ChatTextOffset = ScaleH(20)
CustomChat.PosX = ScaleW(700)
CustomChat.PosY = ScaleH(700)

local Colors = {}
Colors.Background = Color ( 106,106,104, 0 )
Colors.Subframe = Color ( 62,62,62, 0 )
Colors.Chat = Color ( 255,255,255, 0 )
Colors.Console = Color ( 151,211, 255,255 )

-- Initialize line alpha
CustomChat.LineAlpha = {}
for i = 1, 7 do
	CustomChat.LineAlpha[i] = 255
end

-- Initialize open box alpha
CustomChat.LineAlphaOpen = {}
for i = 1, 7 do
	CustomChat.LineAlphaOpen[i] = 255
end

function CustomChat.ResetChat()
	if CustomChat.ChatBox then
		CustomChat.ChatBox:Remove()
	end
	
	CustomChat.CreateChat()
	CustomChat.OpenChat()
	
	CustomChat.ShowTip = true
end

function CustomChat.CreateChat()
	if not ENDROUND then return end
	
	MySelf.StartChatBox = true
	
	--  Create the chat box and chat entry
	CustomChat.ChatBox = vgui.Create( "CustomChat" )
	CustomChat.ChatEntry = vgui.Create ("DTextEntry", CustomChat.ChatBox)
	CustomChat.ChatBox:SetVisible ( false )	
	
	-- Chatbox setup
	CustomChat.ChatBox:SetSize ( ScaleH(587), ScaleH(222) )
	CustomChat.ChatBox:SetPos (CustomChat.PosX, CustomChat.PosY )
	
	-- Calculate where the text entry bar will be
	local ChatBoxTall = CustomChat.ChatBox:GetTall()
	surface.SetFont( "ChatFont" )
	local _, lineHeight = surface.GetTextSize( "H" )
	local height = ChatBoxTall - 65
	for i = 0, 6 do
		height = height + lineHeight + ScaleH(2) 
	end
	height = height - ( ChatBoxTall - 65 ) + ScaleH(20) 
	
	--  local height where every element of the main frame ends.
	CustomChat.HeightEnd = CustomChat.ChatBoxFrameOffset + math.ceil ( height + ScaleH(26) ) + math.ceil ( ScaleH(21) )
	
	-- Text Entry Setup
	local lineWidth, _ = surface.GetTextSize( "Say:" )
	local fWidth = math.ceil ( ScaleH(23) + lineWidth + ScaleH(13) )
	CustomChat.ChatEntry:SetPos( fWidth, math.ceil ( height + ScaleH(26) ) )
	CustomChat.ChatEntry:SetSize( CustomChat.ChatBox:GetWide() - math.ceil ( fWidth ) - math.ceil ( ScaleH(15) ), math.ceil ( ScaleH(21) ) )
	CustomChat.ChatEntryText = ""
	
	-- Setup Paint ChatEntry
	CustomChat.ChatEntry.Paint = function()
		local self = CustomChat.ChatEntry
		local Wide,Tall = self:GetWide(),self:GetTall()
		
		-- Align the text properly
		local text = CustomChat.ChatEntryText or ""
		local align,posx,posy = TEXT_ALIGN_LEFT, 4, Tall * 0.5
		
		local textwide, texttall = surface.GetTextSize ( text )
		if textwide > Wide then
			align = TEXT_ALIGN_RIGHT
			posx, posy = Wide - 4, Tall * 0.5
		end
		
		-- Fade Think for Frame color
		CustomChat.FadeThink()
		
		--  Show a tip to the player
		if CustomChat.ShowTip then
			text = "Press Y to enable typing a message here!"
		end

		-- Draw the frame and the text you write
		draw.RoundedBox ( 0, 0, 0, self:GetWide(), self:GetTall(), Colors.Subframe )
		draw.SimpleText(text, "ChatFont", posx, posy, Colors.Chat, align, TEXT_ALIGN_CENTER )
		
		-- Draw the pointer
		local fClampedTextPos = math.Clamp ( textwide + 4, -10, Wide - ScaleW(3) )
		surface.SetDrawColor ( 200,200,200, math.abs ( 255 * math.sin ( CurTime() * 4 ) ) )
		
		-- Draw the pointer only if the chatbox is "active"
		if not CustomChat.ShowTip then
			surface.DrawLine ( fClampedTextPos, ScaleW(2), fClampedTextPos, self:GetTall() - ScaleW(2) )
		end
	end
end
--hook.Add("Initialize","InitChatBox",CustomChat.CreateChat)

function CustomChat.OpenChat()
	if not ENDROUND then return end

	CustomChat.IsChatOpen = true
	CustomChat.ChatBox:SetVisible( true )
	CustomChat.IsOpening = true
	CustomChat.ShowTip = false
	
	--  Enable cursor
	gui.EnableScreenClicker( true )
	
	return true
end
--hook.Add( "StartChat", "OpenChatBox", CustomChat.OpenChat )

function CustomChat.CloseChat()
	if not CustomChat.ChatBox then return true end
		
	--CustomChat.IsOpening = false
	CustomChat.ShowTip = true
	
	return true
end
--hook.Add( "FinishChat", "ChatCloseBox", CustomChat.CloseChat )

function CustomChat.UpdateChatEntry( text )
	CustomChat.ChatEntryText = text
end
--hook.Add( "ChatTextChanged", "CustomChatUpdateChatEntry", CustomChat.UpdateChatEntry )

function CustomChat.ChatMessage ( pl, Text, TeamOnly, PlayerIsDead )
	if IsValid ( pl ) then
		CustomChat.ParseLine ( Text, pl, TeamOnly, PlayerIsDead, false )
		gamemode.Call ("OnReceiveChatText")
	end
end
--hook.Add( "OnPlayerChat", "CustomChatChatMessage", CustomChat.ChatMessage )

function CustomChat.ChatMessage( plyInd, plyName, mText, mType )
	if mType == "none" or mType == "joinleave" then
		CustomChat.ParseLine ( mText, NULL, false, false, true )
		gamemode.Call ("OnReceiveChatText")
	end
end
--hook.Add( "ChatText", "CustomChatChatMessage2", CustomChat.ChatMessage )

function GM:OnReceiveChatText ()
	--  Play a sound - Source Like
	--surface.PlaySound ( Sound ( "items/flashlight1.wav" ) )

	--  Refresh alpha for the lines that haven't expired yet
	for i = 1, 7 do
		local line = CustomChat.Lines[#CustomChat.Lines - i + 1]
		if line then
			local iTimePosted = CustomChat.Lines[#CustomChat.Lines - i + 1].Value[7]
			if iTimePosted + CustomChat.FadeTime > CurTime() then
				CustomChat.LineAlpha[i] = 255
			end
		end
	end
end

function CustomChat.DrawLine( x, y, line, i )
	local curX = x
	local curY = y
	
	--Data received from the line table
	local Name, TeamOnly, IsDead, HasTitle, Team, IsConsole, Time = line.Value[1],line.Value[2],line.Value[3],line.Value[4],line.Value[5],line.Value[6],line.Value[7]
	local Text, cText, NewText = line.Value[8], line.Value[9], ""
	
	local alpha = CustomChat.LineAlphaOpen[i + 1]
	if not CustomChat.IsChatOpen then
		alpha = CustomChat.LineAlpha[i + 1]
	end
	
	-- Text Color
	local TextCol = Color ( 255, 255, 255, alpha )
	
	if IsConsole then
		TextCol = Color ( 151,211, 255, alpha ) 
	end
	
	NewText = cText
	
	-- Replace color markers with new alpha
	NewText = string.gsub( NewText, "(%,(%d+)%])", ","..math.Round(alpha).."]" )

	--  Draw the text with color tags
	draw.SimpleColoredText ( NewText, "ChatFont", curX, curY, TextCol )
end

function CustomChat.FadeLineThink ()
	for i = 1, 7 do
		local line = CustomChat.Lines[#CustomChat.Lines - i + 1]
		if line then
			local iTimePosted = CustomChat.Lines[#CustomChat.Lines - i + 1].Value[7]
			if iTimePosted + CustomChat.FadeTime <= CurTime() then
				CustomChat.LineAlpha[i] = math.Approach (CustomChat.LineAlpha[i], 0, FrameTime() * 400)
			end
		end
	end
end
	
--[==[--------------------------------------------------------------
         Draw the text when the panel is closed
--------------------------------------------------------------]==]
function CustomChat.DrawChat()
	if not ENDROUND then return end
	if CustomChat.IsChatOpen then return end

	local cBox = CustomChat.ChatBox
	local cBoxX, cBoxY = CustomChat.ChatBox:GetPos()
	
	local Wide = CustomChat.ChatBox:GetWide()
	local Tall = CustomChat.ChatBox:GetTall()
	
	-- Get the height of one line of text "H" the tallest letter
	surface.SetFont( "ChatFont" )
	local _, lineHeight = surface.GetTextSize( "H" )
	
	--  Calculate the h value where the text starts
	local curX = ScaleH(25) + cBoxX
	local curY = ( Tall - ScaleH(65) ) + cBoxY
	local height = curY
	for i = 0, 6 do
		height = height + lineHeight + ScaleH(2) 
	end
	
	--  Height of all lines added
	height =  height - ( Tall - ScaleH(65) ) + CustomChat.ChatTextOffset 
	curY = height - ScaleH(30) * 0.5
	
	--  Line Fade
	CustomChat.FadeLineThink ()
	
	-- Draw text lines
	for i = 0, 6 do
		local line = CustomChat.Lines[#CustomChat.Lines-i]
		if line then
			curX = ScaleH(25) + cBoxX
			CustomChat.DrawLine( math.ceil ( curX ), math.ceil ( curY ), line, i )
			curY = curY - lineHeight - ScaleH(2)
		end
	end
end
--hook.Add( "HUDPaint", "CustomChatDrawChat", CustomChat.DrawChat )

function CustomChat:Init()
	self:EnableMovement()
end

--[==[--------------------------------------------------------------
          Draw the text when the panel is open
--------------------------------------------------------------]==]
function CustomChat:Paint()
	local Wide = self:GetWide()
	local Tall = self:GetTall()
	
	local ChatEntry = CustomChat.ChatEntry
	local WideChatEntry,TallChatEntry = ScaleW(42), ChatEntry:GetTall()
		
	-- Main frame
	draw.RoundedBox( 8, 0, 0, Wide, Tall, Colors.Background )
	
	-- Draw text lines
	surface.SetFont( "ChatFont" )
	local _, lineHeight = surface.GetTextSize( "H" ) --15
	local curX = ScaleH(25)
	local curY = Tall - ScaleH(65)
	
	local height = curY
	for i = 0, 6 do
		height = height + lineHeight + ScaleH(2) 
	end
	
	--  Height of all lines added
	height =  height - ( Tall - ScaleH(65) ) + CustomChat.ChatTextOffset 
	curY = height - ScaleH(30) * 0.5
	
	-- Sub-frame
	surface.SetDrawColor ( Colors.Subframe )
	surface.DrawRect( ScaleH(15), ScaleH(15), Wide - ScaleH(30), height )
	
	for i = 0, 6 do
		local line = CustomChat.Lines[#CustomChat.Lines-i]
		if line then
			curX = ScaleH(25)
			CustomChat.DrawLine ( math.ceil ( curX ), math.ceil ( curY ), line, i )
			curY = curY - lineHeight - ScaleH(2)
		end
	end
	
	-- Chat frames
	local lineWidth, _ = surface.GetTextSize( "Say:" )
	surface.DrawRect( ScaleH(15), math.ceil ( height + ScaleH(26) ), lineWidth + ScaleH(13), math.ceil ( ScaleH(21) ) )

	-- Draw the "say:" text
	draw.SimpleText ( "Say:", "ChatFont", ScaleH(15) + ( ( lineWidth + ScaleH(13) ) * 0.5 ), height + ScaleH(26) + (TallChatEntry * 0.5) , Colors.Chat, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	return true
end

--[==[--------------------------------------------------------------
           Chat panel fading animation set-up
--------------------------------------------------------------]==]
function CustomChat.FadeThink()
	local alpha = { 0,0,0 }
	
	if CustomChat.IsOpening then
		alpha = { 214, 152, 255 }
	end
	
	local iIndex = 0
	for k,v in pairs (Colors) do
		if k ~= "Console" then
			iIndex = iIndex + 1
			v.a = math.Approach (v.a, alpha[iIndex], FrameTime() * 300)
			
			-- Close the frame right when the colors reach 0 alpha
			if v.a == 0 and not CustomChat.IsOpening  then
				CustomChat.IsChatOpen = false
				CustomChat.ChatBox:SetVisible( false )
			end
		end
	end
	
	for i = 1, 7 do
		local line = CustomChat.Lines[#CustomChat.Lines - i + 1]
		if line then
			local iTimePosted = CustomChat.Lines[#CustomChat.Lines - i + 1].Value[7]
			if iTimePosted + CustomChat.FadeTime <= CurTime() then
				CustomChat.LineAlphaOpen[i] = math.Approach (CustomChat.LineAlphaOpen[i], alpha[3], FrameTime() * 400)
			end
		end
	end
end

--[==[----------------------------------------------------------------------
        Extend the Panel Table to do Custom Movement
------------------------------------------------------------------------]==]
local panel = FindMetaTable ("Panel")
if panel then

	--  Used to enable movement on mouse click (for painted panels)
	function panel:EnableMovement()
		self.EnableMove = true

		self.OnMousePressed = function ()
			if not self.EnableMove then return end
		
			self.IsMousePressed = true
			self:SetCursor("sizeall")
			self.MouseX, self.MouseY = self:CursorPos()
		end
		
		self.Think = function()
			if not self.EnableMove then return end
			
			if input.IsMouseDown ( MOUSE_LEFT ) then
				if self:IsVisible() and self.IsMousePressed then
					local x, y = gui.MousePos()
					self:SetPos ( x - self.MouseX , y - self.MouseY )
				end
			end
		end
		
		self.OnMouseReleased = function (  )
			if not self.EnableMove then return end
			
			self:SetCursor("arrow")
			self.IsMousePressed = false
		end
	end
	
	--  Used to disable movement on mouse click (for painted panels)
	function panel:DisableMovement()
		self.EnableMove = false
	end
	
end

function CustomChat:PerformLayout()
	self:SetSize ( ScaleH(587), CustomChat.HeightEnd )
end
vgui.Register("CustomChat", CustomChat, "Panel")

--[==[----------------------------------------------------------------------
        Line parsing (  you don't wanna look down :P )
------------------------------------------------------------------------]==]
function CustomChat.ParseLine ( line, pl, teamonly, deadpl, Console )
	if not ENDROUND then return end

	local Lines = {}
	Lines.Value = {}
	
	local iIndex = 1
	local mLine = line
	local HasTitle = false
	local Team = ""
	local Name = ""
	
	local Prefixes = ""
	local fChatBoxWide = CustomChat.ChatBox:GetWide() - ScaleH(45)
	
	if not Console then
		--  Write the team and name
		Team = pl:Team()
		Name = pl:Name()
		
		--  Check admin status
		if pl.Title ~= nil and pl.Title ~= "" then 
			HasTitle = true
		end
	end
	
	local SecondLine = ""
	local ThirdLine = ""
	
	if not Console then
		local PlayerColor = team.GetColor ( pl:Team() )
	
		if teamonly then
			Prefixes = "["..PlayerColor.r..","..PlayerColor.g..","..PlayerColor.b..","..PlayerColor.a.."](TEAM) [/c]"..Prefixes
		end
		
		if deadpl then
			Prefixes = "[255,0,0,255]*DEAD* [/c]"..Prefixes
		end
		
		if HasTitle then
			local Title = pl.Title or ""
			local ColorToApply = Color ( 255,255,255 )
		
			-- Choose what color to apply to the title
			if pl:Team() == TEAM_HUMAN then ColorToApply = Color( 0, 255, 0 ) end
			if pl:Team() == TEAM_UNDEAD then ColorToApply = Color( 221, 219, 26 ) end
		
			-- Is Admin
			if pl:IsAdmin() or pl:IsSuperAdmin() then
				ColorToApply = Color ( 255,0,0 )
			end
			
			Prefixes = Prefixes.."["..ColorToApply.r..","..ColorToApply.g..","..ColorToApply.b..",255]["..Title.."][/c] "
		end
		
		Prefixes = Prefixes.."["..PlayerColor.r..","..PlayerColor.g..","..PlayerColor.b..","..PlayerColor.a.."]"..pl:Name().."[/c]: "
	end
	
	mLine = Prefixes..mLine
	
	if mLine ~= "" then
		--  Full Line (with markers)
		Line = mLine
	
		-- Actually draw the coloured text!
		surface.SetFont ("ChatFont")
		
		--  Line without color markers
		Line = string.gsub( Line, "(%[(%d+),(%d+),(%d+),(%d+)%])", "" )
		Line = string.gsub( Line, "(%[/c%])", "" )
		
		local LineWide, LineTall = surface.GetTextSize ( Line )
		
		local Text = string.Explode ( "", Line )
		Line = ""
			
		-- Split the larger text (unmarked text)
		local StartPattern, EndPattern, Pattern, Position, strCurrentText, iCutHere = 0, 0, 0, 0, "", 0
		for k,v in ipairs (Text) do
			-- Get current text wide
			strCurrentText = strCurrentText..v
			local strWide, _ = surface.GetTextSize ( strCurrentText )
			local fChatBoxWide = CustomChat.ChatBox:GetWide() - ScaleH(45)
			
			if strWide > fChatBoxWide then
				SecondLine = SecondLine..v
			elseif strWide <= fChatBoxWide then
				Line = Line..v
				iCutHere = k
			end
		end
		
		-- Search for starting pattern
		for k,v in string.gmatch(Prefixes, "(%[(%d+),(%d+),(%d+),(%d+)%])") do
			StartPattern = StartPattern + 1
		end
			
		--Search for ending pattern
		for k,v in string.gmatch(Prefixes, "(%[/c%])" ) do
			EndPattern = EndPattern + 1
			Position = Position + 4
			if StartPattern >= EndPattern then
				Pattern = Pattern + 1
			end
		end
		
		local TextToParse = mLine
		for i=1, Pattern do
			if string.find ( TextToParse, "(%[(%d+),(%d+),(%d+),(%d+)%])" ) then
				-- Get the positions
				local clStart, clEnd = string.find ( TextToParse, "(%[(%d+),(%d+),(%d+),(%d+)%])" )
				Position = Position + ( clEnd - (clStart - 1) )	
				TextToParse = string.sub ( TextToParse, clEnd )
			end
		end
		
		-- Cut the color marked text
		mLine = string.sub (mLine, 0, iCutHere + Position)
	
		iIndex = #CustomChat.Lines + 1
		
		-- -- information from the player that types the message
		table.insert( Lines.Value, Name )
		table.insert( Lines.Value, teamonly )
		table.insert( Lines.Value, deadpl )
		table.insert( Lines.Value, HasTitle )
		table.insert( Lines.Value, Team )
		table.insert( Lines.Value, Console )
		table.insert( Lines.Value, CurTime() )
		
		-- --  Information regarding text content 
		table.insert( Lines.Value, Line )
		table.insert( Lines.Value, mLine )
	end
	
	table.insert( CustomChat.Lines, iIndex, Lines )
	iIndex = iIndex + 1
	
	if SecondLine ~= "" then
		Lines = {}
		Lines.Value = {}
			
		-- Split the larger text
		local Text = string.Explode ( "", SecondLine )
		SecondLine = ""
			
		local strCurrentText, iCutHere = "", 0
		for k,v in ipairs (Text) do
			-- Get current text wide
			strCurrentText = strCurrentText..v
			local strWide, _ = surface.GetTextSize ( strCurrentText )
			local fChatBoxWide = CustomChat.ChatBox:GetWide() - ScaleH(45)
			
			if strWide > fChatBoxWide then
				ThirdLine = ThirdLine..v
			elseif strWide <= fChatBoxWide then
				SecondLine = SecondLine..v
				iCutHere = k
			end
		end
	
		-- -- information from the player that types the message
		table.insert( Lines.Value, "" )
		table.insert( Lines.Value, false )
		table.insert( Lines.Value, false )
		table.insert( Lines.Value, false )
		table.insert( Lines.Value, "" )
		table.insert( Lines.Value, Console )
		table.insert( Lines.Value, CurTime() )
			
		-- --  Information regarding text content 
		table.insert( Lines.Value, SecondLine )
		table.insert( Lines.Value, SecondLine )
			
		table.insert( CustomChat.Lines, iIndex, Lines )
		iIndex = iIndex + 1
	end
	
	if ThirdLine ~= "" then
		Lines = {}
		Lines.Value = {}
		
		local strCurrentText, iCutHere = "", 0
		local strWideInit, _ = surface.GetTextSize ( ThirdLine ) 
		local Text = string.Explode ("", ThirdLine)
		local iTextLength = string.len (ThirdLine)
		ThirdLine = ""
		
		local iInd = 0
		for k,v in ipairs (Text) do
			-- Get current text wide
			strCurrentText = strCurrentText..v
			local strWide, _ = surface.GetTextSize ( strCurrentText )
			
			--  Cut it
			if strWide <= fChatBoxWide then
				ThirdLine = ThirdLine..v
			end
		end
		
		-- Place (..,) at the end to tell the player the message isn't finished
		if strWideInit >= fChatBoxWide then
			ThirdLine = string.sub (ThirdLine, 0, string.len (ThirdLine) - 4)
			ThirdLine = ThirdLine.."(..)"
		end
		
		-- -- information from the player that types the message
		table.insert( Lines.Value, "" )
		table.insert( Lines.Value, false )
		table.insert( Lines.Value, false )
		table.insert( Lines.Value, false )
		table.insert( Lines.Value, "" )
		table.insert( Lines.Value, Console )
		table.insert( Lines.Value, CurTime() )
			
		-- --  Information regarding text content 
		table.insert( Lines.Value, ThirdLine )
		table.insert( Lines.Value, ThirdLine )
			
		table.insert( CustomChat.Lines, iIndex, Lines )
	end
end