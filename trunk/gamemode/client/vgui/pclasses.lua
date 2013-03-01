-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local Colors = {}
Colors.Black = Color ( 0,0,0,220 )
Colors.White = Color ( 255,255,255,255 )
Colors.Grey = Color ( 185,185,185,255 )
Colors.Green = Color ( 30,180,10,255 )
Colors.Red = Color ( 204,8,8,255 )
Colors.DarkRed = Color ( 113,32,32,255 )
Colors.Yellow = Color ( 88,213,62,255 )
Colors.LightYellow = Color ( 226,224,24,255 )

Colors.ActivatedRed = Color ( 141,14,14,255 )
Colors.ActivatedGreen = Color ( 20,140,4,255 )

local Image = {
	["arrow"] = surface.GetTextureID ("zombiesurvival/classmenu/arrow"),
	[0] = surface.GetTextureID ("zombiesurvival/classmenu/zombie"),
	[1] = surface.GetTextureID ("zombiesurvival/classmenu/zombie"),
	[2] = surface.GetTextureID ("zombiesurvival/classmenu/fastzombie"),
	[3] = surface.GetTextureID ("zombiesurvival/classmenu/poisonzombie"),
	[4] = surface.GetTextureID ("zombiesurvival/classmenu/wraith"),
	[5] = surface.GetTextureID ("zombiesurvival/classmenu/howler"),
	[6] = surface.GetTextureID ("zombiesurvival/classmenu/headcrab"),
	[7] = surface.GetTextureID ("zombiesurvival/classmenu/poisonheadcrab"),
	[8] = surface.GetTextureID ("zombiesurvival/classmenu/zombine"),
}

-- Initialize the colors needed for the 3 buttons
local ButtonColors = {}
for i = 1, 8 do
	ButtonColors[i] = Colors.Green
end

-- Hacky way, don't even look :(
local Buttons = {}

-- Colors for the dialog buttons ( 2 below)
local DialogColors = {}
for i = 1, 2 do
	DialogColors[i] = Colors.White
end

--Sound DB
local Sounds = {}
Sounds.Accept = "mrgreen/ui/menu_focus.wav"
Sounds.Click = "mrgreen/ui/menu_click01.wav"
Sounds.Over = "mrgreen/ui/menu_accept.wav"

zClasses = nil
zButtons = nil

ZOMBIE_CLASSES = false

--[[--------------------------------------------------------
        Initialize the fonts used for the menu
---------------------------------------------------------]]
function InitMenuFonts()
	-- Bold Arials
	surface.CreateFont("Arial", ScreenScale(16.4), 700, true, false, "ArialBoldThirty")
	surface.CreateFont("Arial", ScreenScale(11.4), 700, true, false, "ZombieName")
	surface.CreateFont("Arial", ScreenScale(9.4), 700, true, false, "ZombieDescription")

	-- Normal Arials
	surface.CreateFont("Arial", ScreenScale(12.8), 500, true, false, "ArialTwelveNormal")
	surface.CreateFont("Arial", ScreenScale(13.8), 500, true, false, "ClassDialog")
end
hook.Add( "Initialize","Fonts",InitMenuFonts )

--Build the bloodsplats table
bloodSplats = {}
for k = 1, 8 do
	bloodSplats[k] = surface.GetTextureID("vgui/images/blood_splat/blood_splat0"..k)
end

//Choose random splats
local bloodrand1,bloodrand2 = bloodSplats[math.random(1,2)], bloodSplats[math.random(3,5)]

--[[--------------------------------------------------------
   Don't draw the chat area when menu is open
---------------------------------------------------------]]
function ShouldDrawChat ( name ) 
	if name == "CHudChat" then
		return not IsClassesMenuOpen()
	end
end
hook.Add("HUDShouldDraw","ShouldDrawChat",ShouldDrawChat)

--[[--------------------------------------------------------
    The localplayer cannot open the chatbox 
                      while menu is open
---------------------------------------------------------]]
function ClassMenuSay ( pl, bind, pressed )
	if IsClassesMenuOpen() then
		if ( string.find (bind, "messagemode") or string.find (bind,"messagemode2") or string.find (bind,"+voicerecord") ) then 
			return true
		end
	end
end
hook.Add ("PlayerBindPress","Spectator",ClassMenuSay)

--[[--------------------------------------------
             Main menu draw hook
--------------------------------------------]]
function DrawClassMenu ()
	if not IsClassesMenuOpen() then return end
	if ENDROUND then return end
		
	-- Draw the blood splats
	surface.SetTexture( bloodrand1 )
	surface.SetDrawColor( Color(140,0,0,255) )
	surface.DrawTexturedRect( 0,0,w,h )
	surface.SetTexture( bloodrand2 )
	surface.DrawTexturedRect( 0,0,w,h )
	
	-- Draw the black boxes
	draw.RoundedBox( 0, 0, ScaleH(74), ScrW(), ScaleH(113), Colors.Black ) // Upper blackbox
	draw.RoundedBox( 0, 0, ScaleH(225), ScrW(), ScaleH(591), Colors.Black ) //Center blackbox
	draw.RoundedBox( 0, 0, ScaleH(855), ScrW(), ScaleH(86), Colors.Black ) // Lower blackbox
	
	-- Uperbox Text
	draw.SimpleText ("UNDEAD CLASSES","ArialBoldThirty", ScaleW(168),ScaleH(110), Colors.White, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	draw.SimpleText (zClasses.Title,"ArialTwelveNormal", ScaleW(168),ScaleH(149), Colors.Grey, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	
	local posY = ScaleH(329)
	for i = 1, 3 do
		local offset = ScaleH(30)
		local color, strTitle = Colors.Green, ZombieClasses[zButtons[i].iIndex].Name
		
		-- Think the color of the title
		if not ZombieClasses[zButtons[i].iIndex].Unlocked then
			color = Colors.Red
			strTitle = ZombieClasses[zButtons[i].iIndex].Name.." ( locked )"
		end
		
		-- Write (selected) if it's active 
		if Buttons[zButtons[i].iIndex].Activated then
			strTitle = ZombieClasses[zButtons[i].iIndex].Name.." ( selected )"
		end
		
		-- Draw the title (zombie name)
		draw.SimpleText (strTitle,"ZombieName", ScaleW(411),posY, ButtonColors[zButtons[i].iIndex], TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		
		draw.SimpleText ("Description: "..ZombieClasses[zButtons[i].iIndex].Description ,"ZombieDescription", ScaleW(411),posY + offset, Colors.Grey, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		offset = offset + ScaleH(30)
		draw.SimpleText (ZombieClasses[zButtons[i].iIndex].Unique ,"ZombieDescription", ScaleW(411),posY + offset, Colors.Grey, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	
		posY = posY + offset + ScaleH(100)
	end
end
hook.Add ("HUDPaint","DrawClassMenu",DrawClassMenu)

--[[--------------------------------------------------------
        Called when the player pressed F3
---------------------------------------------------------]]
function DoClassesMenu()
	ZOMBIE_CLASSES = !ZOMBIE_CLASSES
	
	//This is not wrong
	if IsClassesMenuOpen() then
		OnClassesMenuOpen()
	else
		OnClassesMenuClose()
	end
end

--[[--------------------------------------------------------
      Called when the class menu is open
---------------------------------------------------------]]
function OnClassesMenuOpen()
	-- Enable the cursor
	gui.EnableScreenClicker( true )
	
	-- Create a derma panel and make it visible, but overrite the paint function
	zClasses = vgui.Create ("DPanel")
	zClasses:SetSize ( ScrW(),ScrH() )
	zClasses:SetPos ( 0,0 )
	zClasses:SetVisible ( true )
	
	-- Title
	zClasses.Title = "Choose the zombie class you want to respawn with."
	
	local ScrollTimer = 0
	
	-- Make the slots increment by 1 
	zClasses.OnMouseWheeled = function( self, iDelta )
		if iDelta == 1 then
			if zClasses.iIndex > -1 and ScrollTimer <= CurTime() then
				zClasses.iIndex = zClasses.iIndex - 1
				ScrollTimer = CurTime() + 0.07
				surface.PlaySound ( "buttons/button15.wav" )
			end
		end
		
		if iDelta == -1 then
			if zClasses.iIndex < 5 and ScrollTimer <= CurTime() then
				zClasses.iIndex = zClasses.iIndex + 1
				ScrollTimer = CurTime() + 0.07
				surface.PlaySound ( "buttons/button15.wav" )
			end
		end
	end
	
	-- Create the 2 dialog buttons
	local zDialog, iOffset = {}, 0
	for i = 1, 2 do
		zDialog[i] = vgui.Create ("DLabel")
		zDialog[i]:SetParent (zClasses)
		zDialog[i]:SetText ("")
		
		//Set the size of the label as the text in it
		if i == 1 then zDialog[i].strText = "Done" else zDialog[i].strText = "Respawn" end
		surface.SetFont ( "ClassDialog" )
		local iTextWide,iTextTall = surface.GetTextSize ( zDialog[i].strText )
		zDialog[i]:SetSize ( iTextWide, iTextTall )
		zDialog[i]:SetPos ( ScaleW(240 + iOffset) - ( iTextWide * 0.5 ), ScaleH(900) - ( iTextTall * 0.5 ) )
		
		//Move it to the right
		iOffset = iOffset + 200
		
		zDialog[i].OnCursorEntered = function()
			zDialog[i].IsCursorIn = true
			
			if i == 2 then
				for j = 0, 8 do
					if Buttons[j].Activated then
						if MySelf:GetZombieClass() != j then
							DialogColors[i] = Colors.LightYellow
							surface.PlaySound ( Sounds.Over )
						end
					end
				end
			end
			
			if i == 1 then
				DialogColors[i] = Colors.LightYellow
				surface.PlaySound ( Sounds.Over )
			end
		end
		
		zDialog[i].OnCursorExited = function()
			zDialog[i].IsCursorIn = false
		
			DialogColors[i] = Colors.White
		end
		
		zDialog[i].Paint = function() 
			local Wide,Tall = zDialog[i]:GetWide(), zDialog[i]:GetTall()
			if i == 2 then
				for j = 0, 8 do
					if Buttons[j].Activated then
						if MySelf:GetZombieClass() == j then
							DialogColors[i] = Colors.Grey
						else
							if not zDialog[i].IsCursorIn then
								DialogColors[i] = Colors.White
							end
						end
					end
				end
			end
			
			draw.SimpleText (zDialog[i].strText,"ClassDialog", Wide * 0.5,Tall * 0.5, DialogColors[i], TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
		
		zDialog[i].OnMousePressed = function()
			if i == 2 then 
				for j = 0, 8 do
					if Buttons[j].Activated then
						if MySelf:GetZombieClass() != j then
							RunConsoleCommand ("kill")
							surface.PlaySound ( Sounds.Click )
							zClasses:SetVisible ( false ) 
							DoClassesMenu()
						else
							surface.PlaySound ( "buttons/weapon_cant_buy.wav" )
							zClasses.Title = "You already are a "..ZombieClasses[MySelf:GetZombieClass()].Name..". Choose another class !"
						end
					end
				end
			else
				surface.PlaySound ( Sounds.Click )
				zClasses:SetVisible ( false ) 
				DoClassesMenu()
			end
		end
	end
	
	--For indexing slots correctly
	zClasses.iIndex = -1
	
	--Create the up and down scroll buttons
	local zScroll = {}
	local ScrollTimer, offset = 0, 0
	for i = 1,2 do
		zScroll[i] = vgui.Create ("DButton", zClasses)
		zScroll[i]:SetPos ( ScaleW(707) - (ScaleH(40) * 0.5), (ScaleH(268 + offset) - (ScaleH(40) * 0.5) ) )
		zScroll[i]:SetSize ( ScaleH(40), ScaleH(40) )
		zScroll[i]:SetText ("")
		
		//Move it down
		offset = offset + 503
		
		//Overrite the default paint for button
		zScroll[i].Paint = function()
			//Make sure the image is flipped correctly
			local yaw = 0
			if i == 1 then
				yaw = 180
			end
			
			//Draw the arrow only when its avaiaiable
			if ( i == 1 and zClasses.iIndex > -1 ) or ( i == 2 and zClasses.iIndex < 6 ) then
				surface.SetDrawColor ( 255,255,255,255 )
				surface.SetTexture ( Image["arrow"] )
				surface.DrawTexturedRectRotated ( zScroll[i]:GetWide() * 0.5, zScroll[i]:GetTall() * 0.5, ScaleH(40), ScaleH(40), yaw )
			end
		end
		
		// Make the slots increment by 1 
		zScroll[i].OnMousePressed = function()
			if i == 1 then
				if zClasses.iIndex > -1 and ScrollTimer <= CurTime() then
					zClasses.iIndex = zClasses.iIndex - 1
					ScrollTimer = CurTime() + 0.1
					surface.PlaySound ( "buttons/button15.wav" )
				end
			end
			
			if i == 2 then
				if zClasses.iIndex < 5 and ScrollTimer <= CurTime() then
					zClasses.iIndex = zClasses.iIndex + 1
					ScrollTimer = CurTime() + 0.1
					surface.PlaySound ( "buttons/button15.wav" )
				end
			end
		end
	end
	
	//Create the class buttons
	zButtons = {}
			
	// Initialize some other button vars
	for i = 0, 8 do
		Buttons[i] = {}
		zButtons[i] = {}
		Buttons[i].CursorInside = false
		Buttons[i].Activated = false
		zButtons[i].iIndex = -1
		
		//Select my zombie class first
		if MySelf:GetZombieClass() == i then
			Buttons[i].Activated = true
		end
	end
	
	local DenySoundTimer = 0
	local posY = ScaleH(329)
	for i = 1, 3 do
		local offset = ScaleH(30)
		zButtons[i] = vgui.Create ("DButton", zClasses)
		zButtons[i]:SetPos ( ScaleW(411 - 86) - (ScaleH(126) / 2), posY + offset - (ScaleH(126) / 2) )
		zButtons[i]:SetSize ( ScaleH(126), ScaleH(126) )
		zButtons[i]:SetText ("")
		
		zButtons[i].OnMousePressed = function() 
			if ZombieClasses[zButtons[i].iIndex].Unlocked then
				//Deactivate all buttons first
				for j = 0, 8 do
					if not Buttons[zButtons[i].iIndex].Activated then
						Buttons[j].Activated = false
					end
				end

				if not Buttons[zButtons[i].iIndex].Activated then
					Buttons[zButtons[i].iIndex].Activated = true
					ChangeZombieClass ( ZombieClasses[ zButtons[i].iIndex ].Name )
					zClasses.Title = "You have chosen to respawn as a "..ZombieClasses[ zButtons[i].iIndex ].Name..". Wisely done!"
					surface.PlaySound ( Sounds.Click )
				end
			else
				if DenySoundTimer <= CurTime() then
					surface.PlaySound ( "buttons/weapon_cant_buy.wav" )
					DenySoundTimer = CurTime() + 0.5
				end
			end
		end
		
		//Make them red/green lighter
		zButtons[i].OnCursorEntered = function()
			Buttons[zButtons[i].iIndex].CursorInside = true
			
			if not Buttons[zButtons[i].iIndex].Activated then
				surface.PlaySound ( Sounds.Over )
			end
			
			if not ZombieClasses[zButtons[i].iIndex].Unlocked then
				ButtonColors[zButtons[i].iIndex] = Colors.ActivatedRed
			else
				if not Buttons[zButtons[i].iIndex].Activated then
					ButtonColors[zButtons[i].iIndex] = Colors.ActivatedGreen 
				end
			end
		end
		
		//Restore their original color
		zButtons[i].OnCursorExited = function()
			Buttons[zButtons[i].iIndex].CursorInside = false
			
			if not Buttons[zButtons[i].iIndex].Activated then
				ButtonColors[zButtons[i].iIndex] = Colors.Green
			end
			
			if not ZombieClasses[zButtons[i].iIndex].Unlocked then
				ButtonColors[zButtons[i].iIndex] = Colors.DarkRed
			end
		end
		
		zClasses.Think = function()
			//Enable all the time the panel is open
			gui.EnableScreenClicker( true )
			
			//Close the panel if endround is coming
			if ENDROUND then
				DoClassesMenu ()
				zClasses:SetVisible ( false )
			end
		
			for i = 1, 3 do
				//Overrite the paint function and draw the buttons
				zButtons[i].iIndex = i + zClasses.iIndex
				
				if not Buttons[zButtons[i].iIndex].CursorInside then
					if not Buttons[zButtons[i].iIndex].Activated then
						ButtonColors[zButtons[i].iIndex] = Colors.Green
					end
						
					if not ZombieClasses[zButtons[i].iIndex].Unlocked then
						ButtonColors[zButtons[i].iIndex] = Colors.Red
					end
				end
				
				zButtons[i].Paint = function() 
					//Change its color to yellow if pushed
					if Buttons[zButtons[i].iIndex].Activated then
						ButtonColors[zButtons[i].iIndex] = Colors.Yellow
					end
					
					//Draw the colored button
					draw.RoundedBox( 8, 0, 0, zButtons[i]:GetWide(), zButtons[i]:GetTall(), ButtonColors[zButtons[i].iIndex] )
					
					//Draw the picture of the class
					surface.SetDrawColor ( 255,255,255,255 )
					surface.SetTexture ( Image[zButtons[i].iIndex] )
					surface.DrawTexturedRectRotated ( zButtons[i]:GetWide() * 0.5, zButtons[i]:GetTall() * 0.5, ScaleH(114), ScaleH(114), 0 )
				end
				
				
			end
		end
		
		//Next slot
		offset = offset + ScaleH(30)
		posY = posY + offset + ScaleH(100)
	end
	
	//Overrite the main paint function
	zClasses.Paint = function() end
end

/*--------------------------------------------------------
      Called when the class menu is closed
---------------------------------------------------------*/
function OnClassesMenuClose()
	//Disable the cursor
	gui.EnableScreenClicker( false )
	
	//Close the menu
	zClasses:SetVisible ( false )
	
	//Shuffle the bloodsplats
	bloodrand1,bloodrand2 = bloodSplats[math.random(1,2)], bloodSplats[math.random(3,5)]
end

/*--------------------------------------------------------
        Return false if the menu is closed
---------------------------------------------------------*/
function IsClassesMenuOpen()
	return ZOMBIE_CLASSES
end

/*--------------------------------------------------------
     Switch function used to send class to sv
---------------------------------------------------------*/
function ChangeZombieClass ( name )
	RunConsoleCommand ( "zs_class", tostring ( name ) )
end