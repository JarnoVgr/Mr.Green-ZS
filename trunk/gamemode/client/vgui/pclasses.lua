-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
--Duby:Re-built 01/12/2014
local Colors = {}
Colors.Black = Color ( 0,0,0,220 )
Colors.White = Color ( 255,255,255,255 )
Colors.Grey = Color ( 185,185,185,255 )
Colors.Green = Color ( 30,180,10,255 )
Colors.Red = Color ( 204,8,8,255 )
Colors.DarkRed = Color ( 113,32,32,255 )
Colors.Yellow = Color ( 88,213,62,255 )
Colors.LightYellow = Color ( 226,224,24,255 )
Colors.DarkGreen = Color ( 8,70,3,255 )

Colors.ActivatedRed = Color ( 141,14,14,255 )
Colors.ActivatedGreen = Color ( 20,140,4,255 )

local Image = {
	["arrow"] = surface.GetTextureID("zombiesurvival/classmenu/arrow"),
	
	[0] = surface.GetTextureID("zombiesurvival/classmenu/zombie"),
	[1] = surface.GetTextureID("zombiesurvival/classmenu/freshdead"),
	[2] = surface.GetTextureID("zombiesurvival/classmenu/poisonzombie"),
	[8] = surface.GetTextureID("zombiesurvival/classmenu/zombine"),
	[4] = surface.GetTextureID("zombiesurvival/classmenu/ghast"),

	
	[5] = surface.GetTextureID("zombiesurvival/classmenu/wraith"),
	[6] = surface.GetTextureID("zombiesurvival/classmenu/howler"),
	[7] = surface.GetTextureID("zombiesurvival/classmenu/headcrab"),
	[3] = surface.GetTextureID("zombiesurvival/classmenu/fastzombie"),
	[9] = surface.GetTextureID("zombiesurvival/classmenu/poisonheadcrab"),
	
	[20] = surface.GetTextureID("zombiesurvival/classmenu/zombine2"),	

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

--[=[--------------------------------------------------------
        Initialize the fonts used for the menu
---------------------------------------------------------]=]
function InitMenuFonts()
	-- Bold Arials
	surface.CreateFontLegacy("Arial", ScreenScale(16.4), 700, true, false, "ArialBoldThirty")
	surface.CreateFontLegacy("Arial", ScreenScale(15), 700, true, false, "ZombieNameB")
	surface.CreateFontLegacy("Arial", ScreenScale(11), 700, true, false, "ZombieDescription")
	surface.CreateFontLegacy("Arial", ScreenScale(10), 600, true, false, "ZombieDescriptionGameplay")
	surface.CreateFontLegacy("Arial", ScreenScale(11), 600, true, false, "ZombieDescriptionGameplay2")
end
hook.Add("Initialize", "Fonts", InitMenuFonts)

--Build the bloodsplats table
bloodSplats = {}
for k = 1, 8 do
	bloodSplats[k] = surface.GetTextureID("vgui/images/blood_splat/blood_splat0"..k)
end

-- Choose random splats
local bloodrand1,bloodrand2 = bloodSplats[math.random(1,2)], bloodSplats[math.random(3,5)]

--[=[--------------------------------------------------------
   Don't draw the chat area when menu is open
---------------------------------------------------------]=]
function ShouldDrawChat ( name ) 
	if name == "CHudChat" then
		return not IsClassesMenuOpen()
	end
end
hook.Add("HUDShouldDraw","ShouldDrawChat",ShouldDrawChat)

--[=[--------------------------------------------------------
    The localplayer cannot open the chatbox 
                      while menu is open
---------------------------------------------------------]=]
function ClassMenuSay ( pl, bind, pressed )
	if IsClassesMenuOpen() then
		if ( string.find (bind, "messagemode") or string.find (bind,"messagemode2") or string.find (bind,"+voicerecord") ) then 
			return true
		end
	end
end
hook.Add ("PlayerBindPress","Spectator",ClassMenuSay)

--[=[--------------------------------------------
             Main menu draw hook
--------------------------------------------]=]
function DrawClassMenu()
	if not IsClassesMenuOpen() or ENDROUND then
		return
	end

	
	--Draw the blood splats
	surface.SetTexture( bloodrand1 )
	surface.SetDrawColor( Color(140,0,0,255) )
	surface.DrawTexturedRect( 0,0,w,h )
	surface.SetTexture( bloodrand2 )
	surface.DrawTexturedRect( 0,0,w,h )
	
	--Draw the black boxes
	draw.RoundedBox( 0, 0, ScaleH(74), ScrW(), ScaleH(113), Colors.Black ) --  Upper blackbox
	draw.RoundedBox( 0, 0, ScaleH(225), ScrW(), ScaleH(591), Colors.Black ) -- Center blackbox
	draw.RoundedBox( 0, 0, ScaleH(855), ScrW(), ScaleH(86), Colors.Black ) --  Lower blackbox
	--draw.RoundedBox( 0, ScaleW(750), ScaleH(250), ScaleW(500), ScaleH(345), Colors.DarkGreen ) --  Lower blackbox
	
	-- Uperbox Text
	draw.SimpleText("UNDEAD CLASSES","ArialBoldThirty", ScaleW(168),ScaleH(110), Colors.White, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	draw.SimpleText(zClasses.Title,"ArialTwelve", ScaleW(168),ScaleH(149), Colors.Grey, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	
	--Draw hovered classes
	local posY = ScaleH(329)
	
	--for i = 0, 9 do
	for i = 0, 9 do
		if not Buttons[i] then
			continue
		end

		if not Buttons[i].CursorInside then
			continue
		end

		local color, strTitle = Colors.Green, ZombieClasses[i].Name

		-- Think the color of the title
		if not ZombieClasses[i].Unlocked then
			color = Colors.Red
			strTitle = ZombieClasses[i].Name
		end
		
		-- Write (selected) if it's active 
		if Buttons[i].Activated then
			strTitle = ZombieClasses[i].Name.." (chosen)"
		end

		-- Draw the title (zombie name)
		draw.SimpleText(strTitle,"ZombieNameB", ScaleW(880),ScaleH(300), ButtonColors[i], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		draw.SimpleText(ZombieClasses[i].Description, "ZombieDescription", ScaleW(1000), ScaleH(300)+40, Colors.Grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		--draw.SimpleText(ZombieClasses[i].DescriptionGameplay2, "ZombieDescriptionGameplay2", ScaleW(1000), ScaleH(300)+120, Colors.Grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		--Gameplay description
		if ZombieClasses[i].DescriptionGameplay then
			for lineIndex, lineValue in pairs(ZombieClasses[i].DescriptionGameplay) do
				draw.SimpleText(lineValue, "ZombieDescriptionGameplay", ScaleW(1000), ScaleH(300)+40+(40*lineIndex), Colors.Grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		--draw.SimpleText(ZombieClasses[i].Unique, "ZombieDescription", ScaleW(640), ScaleH(500)+80, Colors.Grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		break
	end
	
end
hook.Add("HUDPaint","DrawClassMenu",DrawClassMenu)

--[=[--------------------------------------------------------
        Called when the player pressed F3
---------------------------------------------------------]=]
function DoClassesMenu()
	ZOMBIE_CLASSES = not ZOMBIE_CLASSES
	
	-- This is not wrong
	if IsClassesMenuOpen() then
		OnClassesMenuOpen()
	else
		OnClassesMenuClose()
	end
end

--[=[--------------------------------------------------------
      Called when the class menu is open
---------------------------------------------------------]=]
function OnClassesMenuOpen()
	-- Enable the cursor
	gui.EnableScreenClicker(true)
	
	-- Create a derma panel and make it visible, but overrite the paint function
	zClasses = vgui.Create("DPanel")
	zClasses:SetSize(ScrW(),ScrH())
	zClasses:SetPos(0, 0)
	zClasses:SetVisible(true)
	
	-- Title
	zClasses.Title = "Choose the Undead specie you want to spawn with. They are split up into categories!"

	-- Create the 2 dialog buttons
	local zDialog, iOffset = {}, 0
	for i = 1, 2 do
		zDialog[i] = vgui.Create("DLabel")
		zDialog[i]:SetParent(zClasses)
		zDialog[i]:SetText("")
		
		-- Set the size of the label as the text in it
		if i == 1 then
			zDialog[i].strText = "Done"
		else
			if IsValid(MySelf) and not MySelf:Alive() then
				zDialog[i].strText = "Spawn"
			else
				zDialog[i].strText = "Respawn"
			end
		end

		surface.SetFont("ArialFourteen")
		local iTextWide, iTextTall = surface.GetTextSize(zDialog[i].strText)
		zDialog[i]:SetSize(iTextWide, iTextTall)
		zDialog[i]:SetPos(ScaleW(240 + iOffset) - (iTextWide * 0.5), ScaleH(900) - (iTextTall * 0.5))

		
		-- Move it to the right
		iOffset = iOffset + 200
		
		zDialog[i].OnCursorEntered = function()
			zDialog[i].IsCursorIn = true
			
			if i == 2 then
			--	for j = 0, 8 do
				for j = 0, 9 do
					if not Buttons[j] then
						continue
					end

					if Buttons[j].Activated then
						if MySelf:GetZombieClass() ~= j then
							DialogColors[i] = Colors.LightYellow
							surface.PlaySound(Sounds.Over)
						end
					end
				end
			end
			
			if i == 1 then
				DialogColors[i] = Colors.LightYellow
				surface.PlaySound(Sounds.Over)
			end
		end
		
		zDialog[i].OnCursorExited = function()
			zDialog[i].IsCursorIn = false
		
			DialogColors[i] = Colors.White
		end
		
		zDialog[i].Paint = function() 
			local Wide,Tall = zDialog[i]:GetWide(), zDialog[i]:GetTall()
			if i == 2 then
				--for j = 0, 8 do
				for j = 0, 9 do
					if ZombieClasses[j].Hidden then
						continue
					end

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
			
			draw.SimpleText(zDialog[i].strText,"ArialFourteen", Wide * 0.5,Tall * 0.5, DialogColors[i], TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
		
		zDialog[i].OnMousePressed = function()
			if i == 2 then 
			--	for j = 0, 8 do
				for j = 0, 9 do
					if not Buttons[j] then
						continue
					end

					if Buttons[j].Activated then
						if MySelf:GetZombieClass() ~= j then
							RunConsoleCommand("kill")
							surface.PlaySound(Sounds.Click)
							zClasses:SetVisible(false)
							DoClassesMenu()
						else
							surface.PlaySound("buttons/weapon_cant_buy.wav")
							zClasses.Title = "You already are a "..ZombieClasses[MySelf:GetZombieClass()].Name..". Pick a different specie."
						end
					end
				end
			else
				surface.PlaySound(Sounds.Click)
				zClasses:SetVisible(false) 
				DoClassesMenu()
			end
		end
	end

	-- Create the class buttons
	zButtons = {}

			
	--Initialize some other button vars

	for i = 0, 4 do
		if ZombieClasses[i].Hidden then
			continue
		end

		Buttons[i] = {}
		zButtons[i] = {}

		Buttons[i].CursorInside = false
		Buttons[i].Activated = false
		
		--Get current Zombie Class
		if MySelf:GetZombieClass() == i then
			Buttons[i].Activated = true
		end
	end


	local spaceBetweenButtons = ScaleW(250)
	local totalWidth = (#zButtons*ScaleW(116))+((#zButtons-1)*spaceBetweenButtons)
	
	
	local DenySoundTimer = 0
	local buttonPosX = (ScrW()-totalWidth)/2
	--for i = 0, 8 do
	for i = 0, 4 do
		--Disable hidden classes
		if ZombieClasses[i].Hidden then
			continue
		end

		zButtons[i] = vgui.Create("DButton", zClasses)
		zButtons[i]:SetPos(buttonPosX/2.7, ScaleH(250))
		zButtons[i]:SetSize(ScaleW(116), ScaleW(116))
		zButtons[i]:SetText("")
		

		
		zButtons[i].OnMousePressed = function() 
			if ZombieClasses[i].Unlocked then
				--Deactivate all buttons first

				--for j = 0, 9 do
				for j = 0, 4 do
					--
					if not Buttons[j] or i == j then
						continue
					end

					--Make others inactive
					if Buttons[j].Activated then
						Buttons[j].Activated = false
					end
				end

				if not Buttons[i].Activated then
					Buttons[i].Activated = true
					ChangeZombieClass(ZombieClasses[i].Name)
					zClasses.Title = "You have chosen to respawn as a ".. ZombieClasses[i].Name ..". Wise choice."
					surface.PlaySound(Sounds.Click)
				end
			else
				if DenySoundTimer <= CurTime() then
					surface.PlaySound("buttons/weapon_cant_buy.wav")
					DenySoundTimer = CurTime() + 0.5
				end
			end
		end
		
		
		-- Make them red/green lighter
		zButtons[i].OnCursorEntered = function()
			Buttons[i].CursorInside = true
			
			if not Buttons[i].Activated then
				surface.PlaySound(Sounds.Over)
			end
			
			if not ZombieClasses[i].Unlocked then
				ButtonColors[i] = Colors.ActivatedRed
			elseif not Buttons[i].Activated then
				ButtonColors[i] = Colors.ActivatedGreen
			end
		end
		
		
		-- Restore their original color
		zButtons[i].OnCursorExited = function()
			Buttons[i].CursorInside = false
			
			if not Buttons[i].Activated then
				ButtonColors[i] = Colors.Green
			end
			
			if not ZombieClasses[i].Unlocked then
				ButtonColors[i] = Colors.DarkRed
			end
		end
		

		zButtons[i].Paint = function() 
			-- Change its color to yellow if pushed
			if Buttons[i].Activated then
				ButtonColors[i] = Colors.Yellow
			end

			-- Draw the colored button
			draw.RoundedBox(8, 0, 0, zButtons[i]:GetWide(), zButtons[i]:GetTall(), ButtonColors[i])
					
			-- Draw the picture of the class
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetTexture(Image[i])
			surface.DrawTexturedRectRotated(zButtons[i]:GetWide() * 0.5, zButtons[i]:GetTall() * 0.5, zButtons[i]:GetWide()-12, zButtons[i]:GetTall()-12, 0)
		end


		
		-- Next slot

		buttonPosX = buttonPosX + ScaleW(110) + spaceBetweenButtons
	end
	
	
	
	
	
	
	
	
	--Duby: Don't look!! :<<<
	
	local spaceBetweenButtons2 = ScaleW(18500)
	
	
	for i = 5, 9 do
	
		--Disable hidden classes
		if ZombieClasses[i].Hidden then
			continue
		end

		
		Buttons[i] = {}
		Buttons[i].CursorInside = false
		Buttons[i].Activated = false
		
		--Get current Zombie Class
		if MySelf:GetZombieClass() == i then
			Buttons[i].Activated = true
		end
		
		zButtons[i] = vgui.Create("DButton", zClasses)
		zButtons[i]:SetPos(buttonPosX/140, ScaleH(430))
		zButtons[i]:SetSize(ScaleW(116), ScaleW(116))
		zButtons[i]:SetText("")
		

		
		zButtons[i].OnMousePressed = function() 
			if ZombieClasses[i].Unlocked then
				--Deactivate all buttons first

				for j = 0, 9 do
					--
					if not Buttons[j] or i == j then
						continue
					end

					--Make others inactive
					if Buttons[j].Activated then
						Buttons[j].Activated = false
					end
				end

				if not Buttons[i].Activated then
					Buttons[i].Activated = true
					ChangeZombieClass(ZombieClasses[i].Name)
					zClasses.Title = "You have chosen to respawn as a ".. ZombieClasses[i].Name ..". Wise choice."
					surface.PlaySound(Sounds.Click)
				end
			else
				if DenySoundTimer <= CurTime() then
					surface.PlaySound("buttons/weapon_cant_buy.wav")
					DenySoundTimer = CurTime() + 0.5
				end
			end
		end
		
		
		-- Make them red/green lighter
		zButtons[i].OnCursorEntered = function()
			Buttons[i].CursorInside = true
			
			if not Buttons[i].Activated then
				surface.PlaySound(Sounds.Over)
			end
			
			if not ZombieClasses[i].Unlocked then
				ButtonColors[i] = Colors.ActivatedRed
			elseif not Buttons[i].Activated then
				ButtonColors[i] = Colors.ActivatedGreen
			end
		end
		
		
		-- Restore their original color
		zButtons[i].OnCursorExited = function()
			Buttons[i].CursorInside = false
			
			if not Buttons[i].Activated then
				ButtonColors[i] = Colors.Green
			end
			
			if not ZombieClasses[i].Unlocked then
				ButtonColors[i] = Colors.DarkRed
			end
		end
		

		zButtons[i].Paint = function() 
			-- Change its color to yellow if pushed
			if Buttons[i].Activated then
				ButtonColors[i] = Colors.Yellow
			end

			-- Draw the colored button
			draw.RoundedBox(8, 0, 0, zButtons[i]:GetWide(), zButtons[i]:GetTall(), ButtonColors[i])
					
			-- Draw the picture of the class
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetTexture(Image[i])
			surface.DrawTexturedRectRotated(zButtons[i]:GetWide() * 0.5, zButtons[i]:GetTall() * 0.5, zButtons[i]:GetWide()-12, zButtons[i]:GetTall()-12, 0)
		end

	
		
		-- Next slot

		buttonPosX = buttonPosX + ScaleW(110) + spaceBetweenButtons2
	end
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
		
	zClasses.Think = function()
		-- Enable all the time the panel is open
		gui.EnableScreenClicker(true)
		
		-- Close the panel if endround is coming
		if ENDROUND then
			DoClassesMenu()
			zClasses:SetVisible(false)
		end
	

		for i = 0, 9 do
			if not Buttons[i] then
				continue
			end
			
			if not Buttons[i].CursorInside then
				if not Buttons[i].Activated then
					ButtonColors[i] = Colors.Green
				end
					
				if not ZombieClasses[i].Unlocked then
					ButtonColors[i] = Colors.Red
				end
			end
		end
	end
	
	-- Overrite the main paint function
	zClasses.Paint = function()
	end
end




--[==[--------------------------------------------------------
      Called when the class menu is closed
---------------------------------------------------------]==]
function OnClassesMenuClose()
	--Disable the cursor
	gui.EnableScreenClicker(false)
	
	--Close the menu
	zClasses:SetVisible(false)
	
	--Shuffle the bloodsplats
	bloodrand1,bloodrand2 = bloodSplats[math.random(1,2)], bloodSplats[math.random(3,5)]
end

--[==[--------------------------------------------------------
        Return false if the menu is closed
---------------------------------------------------------]==]
function IsClassesMenuOpen()
	return ZOMBIE_CLASSES
end

--[==[--------------------------------------------------------
     Switch function used to send class to sv
---------------------------------------------------------]==]
function ChangeZombieClass(name)
	RunConsoleCommand("zs_class", tostring(name))
end