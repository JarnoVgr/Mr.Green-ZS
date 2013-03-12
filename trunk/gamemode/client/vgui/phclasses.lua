-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

function GetAch ( class, level, achpos )
	if not class or not level or not achpos then return 0 end

	if achpos == 1 then
		if level == 0 or level == 1 then
			return MySelf.DataTable["ClassData"][string.lower(HumanClasses[class].Name)].achlevel0_1
		elseif level == 2 or level == 3 then
			return MySelf.DataTable["ClassData"][string.lower(HumanClasses[class].Name)].achlevel2_1
		elseif level == 4 or level == 5 or level == 6 then	
			return MySelf.DataTable["ClassData"][string.lower(HumanClasses[class].Name)].achlevel4_1
		end
	elseif achpos == 2 then
		if level == 0 or level == 1 then
			return MySelf.DataTable["ClassData"][string.lower(HumanClasses[class].Name)].achlevel0_2
		elseif level == 2 or level == 3 then
			return MySelf.DataTable["ClassData"][string.lower(HumanClasses[class].Name)].achlevel2_2
		elseif level == 4 or level == 5 or level == 6 then	
			return MySelf.DataTable["ClassData"][string.lower(HumanClasses[class].Name)].achlevel4_2
		end
	end
end

function oldDrawSelectClass ()

	local Colors = {}
	Colors.SpawnButtonNormal = Color (200, 200, 200, 255)
	Colors.SpawnButtonOver = Color (186,21,21,255)
	Colors.SpawnButtonBack = Color (33,9,9,255)
	Colors.RandomButtonNormal = Color (200, 200, 200, 255)
	Colors.RandomButtonOver = Color (186,21,21,255)
	Colors.RandomButtonBack = Color (33,9,9,255)
	
	Colors.MedicButton = Color (200, 200, 200, 255)
	Colors.MedicBack = Color (15,4,4,86)
	Colors.CommandoButton = Color (200, 200, 200, 255)
	Colors.CommandoBack = Color (15,4,4,86)
	Colors.EngineerButton = Color (200, 200, 200, 255)
	Colors.EngineerBack = Color (15,4,4,86)
	Colors.BersekerButton = Color (200, 200, 200, 255)
	Colors.BersekerBack = Color (15,4,4,86)
	Colors.SupportButton = Color (200, 200, 200, 255)
	Colors.SupportBack = Color (15,4,4,86)
	
	local Sounds = {}
	Sounds.Accept = "mrgreen/ui/menu_focus.wav"
	Sounds.Click = "mrgreen/ui/menu_click01.wav"
	Sounds.Over = "mrgreen/ui/menu_accept.wav"
	Sounds.Startup = "mrgreen/ui/gamestartup1.mp3"
	
	local SelectedClass = GetConVarNumber("_zs_redeemclass") or 1
	local Levels = {0,2,1,4,5}
	
	surface.PlaySound (Sounds.Startup)
	
	local achstat1
	local achstat2
	
	local offsetxright = 36
	local offsetx = 18
	local spawntimer = 25
	local spawntimercd = 0
	
	----------------------------------
	local firstachmaximum 
	local secondachmaximum
	-----------------------------------

	local bloodrand1 = bloodSplats[math.random(1,2)]
	local bloodrand2 = bloodSplats[math.random(3,5)]
	
	local BlurMenu = vgui.Create("DFrame")
	BlurMenu:SetSize(ScaleW(785),ScaleH(629))
	BlurMenu:SetPos(((w*0.5)-(ScaleW(785)/2)),(h*0.5)-(ScaleH(629)/2))
	BlurMenu:SetDraggable ( false )
	BlurMenu:SetBackgroundBlur( true )
	
	local InvisiblePanel = vgui.Create("DFrame")
	InvisiblePanel:SetSize(w,h)
	InvisiblePanel:SetPos(0,0)
	InvisiblePanel:SetDraggable ( false )
	InvisiblePanel:SetTitle ("")
	InvisiblePanel:ShowCloseButton (false)
	InvisiblePanel.Paint = function() 
		-- override this
	end
	
	local BloodPanel = vgui.Create("DLabel")
	BloodPanel:SetText("")
	BloodPanel:SetParent(InvisiblePanel)
	BloodPanel:SetSize (w, h) 
	BloodPanel:SetPos (0, 0)
	BloodPanel.Paint = function ()
		surface.SetTexture( bloodrand1 )
		surface.SetDrawColor( Color(150,30,30,255) )
		surface.DrawTexturedRect( 0,0,w,h )
		surface.SetTexture( bloodrand2 )
		surface.DrawTexturedRect( 0,0,w,h )
	end
	
	local LabelNews = vgui.Create("DLabel")
	LabelNews:SetText("")
	LabelNews:SetParent(InvisiblePanel)
	LabelNews:SetSize (ScaleW(1280), ScaleH(76)) 
	LabelNews:SetPos (0, ScaleH(909))
	LabelNews.Paint = function ()
		draw.RoundedBox( 0, 0, 0, ScaleW(1280), ScaleH(78), Color (0,0,0,230) )  --  Welcome frame!
		if HALLOWEEN then
			draw.SimpleText("Welcome to mr green zombie survival! happy halloween!", "L4DDIFF", ScaleW(639), ScaleH(30), Color ( 190,180,190,255), TEXT_ALIGN_CENTER)
		elseif CHRISTMAS then
			draw.SimpleText("Welcome to mr green zombie survival! merry christmas!", "L4DDIFF", ScaleW(639), ScaleH(30), Color ( 190,180,190,255), TEXT_ALIGN_CENTER)
		else		
			draw.SimpleText("Welcome to mr green zombie survival!", "L4DDIFF", ScaleW(639), ScaleH(30), Color ( 190,180,190,255), TEXT_ALIGN_CENTER)
		end
	end
	
	local BlackOutpanel = vgui.Create("DLabel") --  Yes,yes i know, it's kind of stupid to make a label and turn it in a paint board... but meh.
	BlackOutpanel:SetText("")
	BlackOutpanel:SetParent(InvisiblePanel)
	BlackOutpanel:SetSize (ScaleW(865), ScaleH(709)) 
	BlackOutpanel:SetPos (ScaleW(207), ScaleH(157)) 
	BlackOutpanel.Paint = function ()
		draw.RoundedBox( 0, 0, 0, BlackOutpanel:GetWide(), BlackOutpanel:GetTall() , Color (0,0,0,230) )  --  Black-ish outpanel
	end

	local Menu = vgui.Create("DFrame")
	Menu:SetSize(ScaleW(785),ScaleH(629)) --  + 48
	Menu:SetPos(((w*0.5)-(Menu:GetWide()/2)),(h*0.5)-(Menu:GetTall()/2))
	Menu:SetTitle("")
	Menu:ShowCloseButton( false )
	Menu:SetDraggable ( false )
	Menu.Paint = function()
		draw.RoundedBox( 0, 0, 0,Menu:GetWide(), Menu:GetTall(), Color(44,12,12,255) )  --  MAIN FRAME
		surface.SetDrawColor (0,0,0,255)
		
		draw.RoundedBox( 0, ScaleW(44-offsetx), ScaleH(51), ScaleW(299), ScaleH(546), Color(51,21,21,250) )  --  right side panel
		draw.RoundedBox( 0, ScaleW(377-offsetxright), ScaleH(51), ScaleW(419), ScaleH(239), Color(51,21,21,250) ) --  upper left
		draw.RoundedBox( 0, ScaleW(377-offsetxright), ScaleH(307) ,ScaleW(419), ScaleH(223), Color(51,21,21,250) ) --  down left
		
		surface.SetFont( "FRAGS" ) 
		surface.SetTextPos( ScaleW(263), ScaleH(19) )
		surface.SetTextColor (200,200,200,255)
		surface.DrawText( "CHOOSE YOUR CLASS ..." ) --  main title
		
		surface.SetFont( "FRAGS" ) 
		surface.SetTextPos ( ScaleW(58-offsetx), ScaleH(61) )
		surface.DrawText( "Select Perk" ) --  perks title
		
		surface.SetTextPos ( ScaleW(394-offsetxright), ScaleH(65) )
		surface.DrawText( "Perk Description" ) --  perks title
		
		surface.SetFont ("SEVEN")
		surface.SetTextPos ( ScaleW(394-offsetxright), ScaleH(323) )
		surface.DrawText( "Next level requierments" ) --  next level reqs
		
		--  Achievment Maximum Calculation
		firstachmaximum = ClassInfo[SelectedClass].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1][3]
		secondachmaximum = ClassInfo[SelectedClass].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1][4]
		
		--  Class tabs
		draw.RoundedBox( 0, ScaleW(70-offsetx), ScaleH(108) ,ScaleW(247), ScaleH(70), Colors.MedicBack ) 
		draw.RoundedBox( 0, ScaleW(70-offsetx), ScaleH(198) ,ScaleW(247), ScaleH(70), Colors.CommandoBack ) 
		draw.RoundedBox( 0, ScaleW(70-offsetx), ScaleH(296) ,ScaleW(247), ScaleH(70), Colors.BersekerBack )
		draw.RoundedBox( 0, ScaleW(70-offsetx), ScaleH(392) ,ScaleW(247), ScaleH(70), Colors.EngineerBack )
		draw.RoundedBox( 0, ScaleW(70-offsetx), ScaleH(492) ,ScaleW(247), ScaleH(70), Colors.SupportBack )
		
		--  In-Tab Boxes -- Medic
		draw.RoundedBox( 0, ScaleW(93-offsetx), ScaleH(124) ,ScaleW( math.Clamp (( (GetAch (1, MySelf.DataTable["ClassData"][string.lower(HumanClasses[1].Name)].level, 1 ) + GetAch (1, MySelf.DataTable["ClassData"][string.lower(HumanClasses[1].Name)].level, 2 ) ) / (ClassInfo[1].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[1].Name)].level+1][4]+ClassInfo[1].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[1].Name)].level+1][3])),0,1) *207), ScaleH(36), Color(136,2,2,255) )
		draw.RoundedBox( 0, ScaleW(93-offsetx), ScaleH(124) ,ScaleW(207), ScaleH(36), Color(0,0,0,240) )
		surface.SetFont( "SEVEN" ) 
		surface.SetTextPos(ScaleW(102-offsetx),ScaleH(135))
		surface.SetTextColor (Colors.MedicButton)
		surface.DrawText( "Medic" )
		surface.SetTextPos(ScaleW(244-offsetx),ScaleH(135))
		surface.DrawText( "Lvl "..MySelf.DataTable["ClassData"]["medic"].level )
		
		--  Commando!
		surface.SetTextColor (Color (200, 200, 200, 255))
		draw.RoundedBox( 0, ScaleW(93-offsetx), ScaleH(214) ,ScaleW( math.Clamp ( ( (GetAch (2, MySelf.DataTable["ClassData"][string.lower(HumanClasses[2].Name)].level, 1 ) + GetAch (2, MySelf.DataTable["ClassData"][string.lower(HumanClasses[2].Name)].level, 2 ) ) / (ClassInfo[2].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[2].Name)].level+1][4]+ClassInfo[2].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[2].Name)].level+1][3])),0,1) *207), ScaleH(36), Color(136,2,2,255) )
		draw.RoundedBox( 0, ScaleW(93-offsetx), ScaleH(214) ,ScaleW(207), ScaleH(36), Color(0,0,0,240) )
		surface.SetTextPos(ScaleW(102-offsetx),ScaleH(225))
		surface.SetTextColor (Colors.CommandoButton)
		surface.DrawText( "Commando" )
		surface.SetTextPos(ScaleW(244-offsetx),ScaleH(225))
		surface.DrawText( "Lvl "..MySelf.DataTable["ClassData"]["commando"].level  )
		
		-- Berseker
		draw.RoundedBox( 0, ScaleW(93-offsetx), ScaleH(312) ,ScaleW( math.Clamp (( (GetAch (3, MySelf.DataTable["ClassData"][string.lower(HumanClasses[3].Name)].level, 1 ) + GetAch (3, MySelf.DataTable["ClassData"][string.lower(HumanClasses[3].Name)].level, 2 ) ) / (ClassInfo[3].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[3].Name)].level+1][4]+ClassInfo[3].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[3].Name)].level+1][3])),0,1) *207), ScaleH(36), Color(136,2,2,255) )
		draw.RoundedBox( 0, ScaleW(93-offsetx), ScaleH(312) ,ScaleW(207), ScaleH(36), Color(0,0,0,240) )
		surface.SetTextPos(ScaleW(102-offsetx),ScaleH(324))
		surface.SetTextColor (Colors.BersekerButton)
		surface.DrawText( "Berserker" )
		surface.SetTextPos(ScaleW(244-offsetx),ScaleH(324))
		surface.DrawText( "Lvl "..MySelf.DataTable["ClassData"]["berserker"].level  )	
		
		-- Engineer
		draw.RoundedBox( 0, ScaleW(93-offsetx), ScaleH(408) ,ScaleW( math.Clamp ( ( (GetAch (4, MySelf.DataTable["ClassData"][string.lower(HumanClasses[4].Name)].level, 1 ) + GetAch (4, MySelf.DataTable["ClassData"][string.lower(HumanClasses[4].Name)].level, 2 ) ) / (ClassInfo[4].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[4].Name)].level+1][4]+ClassInfo[4].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[4].Name)].level+1][3])),0,1) *207), ScaleH(36), Color(136,2,2,255) )
		draw.RoundedBox( 0, ScaleW(93-offsetx), ScaleH(408) ,ScaleW(207), ScaleH(36), Color(0,0,0,240) )
		surface.SetTextPos(ScaleW(102-offsetx),ScaleH(420))
		surface.SetTextColor (Colors.EngineerButton)
		surface.DrawText( "Engineer" )
		surface.SetTextPos(ScaleW(244-offsetx),ScaleH(420))
		surface.DrawText( "Lvl "..MySelf.DataTable["ClassData"]["engineer"].level  )			

		-- Support
		draw.RoundedBox( 0, ScaleW(93-offsetx),ScaleH(506) ,ScaleW( math.Clamp( ( (GetAch (5, MySelf.DataTable["ClassData"][string.lower(HumanClasses[5].Name)].level, 1 ) + GetAch (5, MySelf.DataTable["ClassData"][string.lower(HumanClasses[5].Name)].level, 2 ) ) / (ClassInfo[5].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[5].Name)].level+1][4]+ClassInfo[5].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[5].Name)].level+1][3])),0,1) *207), ScaleH(36), Color(136,2,2,255) )
		draw.RoundedBox( 0, ScaleW(93-offsetx),ScaleH(506) ,ScaleW(207), ScaleH(36), Color(0,0,0,240) )
		surface.SetTextPos(ScaleW(102-offsetx),ScaleH(518))
		surface.SetTextColor (Colors.SupportButton)
		surface.DrawText( "Support" )
		surface.SetTextPos(ScaleW(244-offsetx),ScaleH(518))
		surface.DrawText( "Lvl "..MySelf.DataTable["ClassData"]["support"].level  )	
		
		----------------------------------[==[ Holy shit code for determining what achievment to draw ]==] ------------------------------
		if MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level == 0 or MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level == 1 then
			achstat1 = MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].achlevel0_1
			achstat2 = MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].achlevel0_2
		elseif MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level == 2 or MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level == 3 then
			achstat1 = MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].achlevel2_1
			achstat2 = MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].achlevel2_2
		elseif MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level == 4 or MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level == 5 or MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level == 6 then
			achstat1 = MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].achlevel4_1
			achstat2 = MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].achlevel4_2
		end
		---------------------------------------------------------------------------------------------------------------------------------------
		-- First Req Bar
		draw.RoundedBox( 0, ScaleW(402-offsetxright), ScaleH(98) ,ScaleW(368), ScaleH(162), Color(15,4,4,86) ) --  Req outline panel
		
		surface.SetTextColor (200,200,200,255)
		draw.RoundedBox(0, ScaleW(422-offsetxright),ScaleH(373),ScaleW( math.Clamp( (achstat1 / ClassInfo[SelectedClass].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1][3]),0,1) *323) ,ScaleH(29), Color(136,2,2,255)) -- Progress bar
		draw.RoundedBox(0, ScaleW(422-offsetxright),ScaleH(373),ScaleW(323),ScaleH(29), Color(0,0,0,240))
		draw.RoundedBox( 0, ScaleW(400-offsetxright), ScaleH(352) ,ScaleW(368), ScaleH(70), Color(15,4,4,86) ) --  Req Tab
		
		-- Second Req Bar
		draw.RoundedBox(0, ScaleW(422-offsetxright),ScaleH(456),ScaleW( math.Clamp ( (achstat2 / ClassInfo[SelectedClass].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1][4]),0,1) *323),ScaleH(29), Color(136,2,2,255)) -- Progress bar
		draw.RoundedBox(0, ScaleW(422-offsetxright),ScaleH(456),ScaleW(323),ScaleH(29), Color(0,0,0,240))
		draw.RoundedBox( 0, ScaleW(400-offsetxright), ScaleH(436) ,ScaleW(368), ScaleH(70), Color(15,4,4,86) ) --  Req Tab #2
		
		--  First next level req
		draw.SimpleText(ClassInfo[SelectedClass].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1][1]..": "..achstat1, "GC", ScaleW(548),ScaleH(381), Color ( 200, 200, 200, 255), TEXT_ALIGN_CENTER)
		
		-- Second next level req
		draw.SimpleText(ClassInfo[SelectedClass].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1][2]..": "..achstat2, "GC", ScaleW(548),ScaleH(464), Color ( 200, 200, 200, 255), TEXT_ALIGN_CENTER)

		--  Description Shit
		surface.SetFont( "GC" ) 
		surface.SetTextPos(ScaleW(419-offsetxright),ScaleH(124))
		surface.DrawText( ""..(HumanClasses[SelectedClass].Coef[1]*(MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1)).." "..HumanClasses[SelectedClass].Description[1] )	
		surface.SetTextPos(ScaleW(419-offsetxright),ScaleH(158))		
		surface.DrawText(  ""..(HumanClasses[SelectedClass].Coef[2]*(MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1)).." "..HumanClasses[SelectedClass].Description[2] )	
		surface.SetTextPos(ScaleW(419-offsetxright),ScaleH(192))
		surface.DrawText(  ""..(HumanClasses[SelectedClass].Coef[3]*(MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1)).." "..HumanClasses[SelectedClass].Description[3] )
		surface.SetTextPos(ScaleW(419-offsetxright),ScaleH(227))		
		if SelectedClass == 2 then
			surface.DrawText( ""..HumanClasses[SelectedClass].Description[4] ) 
		else
			surface.DrawText( ""..(HumanClasses[SelectedClass].Coef[4]*(MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1)).." "..HumanClasses[SelectedClass].Description[4] )
		end
	end

	ClassMenu = Menu 
---------------------------------------------------------------------------------------------------------------------------------	
	local spawnbutton = vgui.Create("DButton",Menu)
	spawnbutton:SetText("")
	spawnbutton:SetPos(ScaleW(386-offsetxright),ScaleH(549))
	spawnbutton:SetSize (ScaleW(192),ScaleH(48))
	spawnbutton.Paint = function ()
		draw.RoundedBox( 0, 0, 0,Menu:GetWide(), Menu:GetTall(), Colors.SpawnButtonBack )
		surface.SetDrawColor (0,0,0,255)
		surface.SetTextColor( Colors.SpawnButtonNormal )
		draw.SimpleText("SPAWN", "L4DDIFF", ScaleW(94), ScaleH(15), Color (255,255,255,255), TEXT_ALIGN_CENTER)
	end
	spawnbutton.OnCursorEntered = function () Colors.SpawnButtonNormal = Color (200, 200, 200, 255)	Colors.SpawnButtonBack = Color (111,27,27,255) surface.PlaySound (Sounds.Over) end
	spawnbutton.OnCursorExited = function () Colors.SpawnButtonNormal = Color (200, 200, 200, 255) Colors.SpawnButtonBack = Color (33,9,9,255) end
	spawnbutton.DoClick = function ()
		ChangeClassClient (SelectedClass)
		surface.PlaySound (Sounds.Click)
		ClassMenu:Close()
		BlurMenu:Close()
		InvisiblePanel:Close()
	end
---------------------------------------------------------------------------------------------------------------------------------	
	local randombutton = vgui.Create("DButton",Menu)
	randombutton:SetText("")
	randombutton:SetPos(ScaleW(595-offsetxright),ScaleH(549))
	randombutton:SetSize (ScaleW(192),ScaleH(48))
	randombutton.Think = function () 
		if spawntimercd <= CurTime() then 
			spawntimer = spawntimer - 1
			if spawntimer <= 0 then
				local randomclass = math.random (1,5)
				ChangeClassClient (randomclass)
				ClassMenu:Close()
				BlurMenu:Close()
				InvisiblePanel:Close()
			end
			spawntimercd = CurTime() + 1
		end
	end
	
	randombutton.Paint = function ()
		draw.RoundedBox( 0, 0, 0,Menu:GetWide(), Menu:GetTall(), Colors.RandomButtonBack  )
		surface.SetDrawColor (0,0,0,255)
		surface.SetTextColor( Colors.RandomButtonNormal  )
		draw.SimpleText("RANDOM ("..spawntimer..")" , "L4DDIFF", ScaleW(94), ScaleH(15), Color (255,255,255,255), TEXT_ALIGN_CENTER)
	end
	randombutton.DoClick = function ()
		local randclass = math.random (1,5)
		ChangeClassClient (randclass)
		surface.PlaySound (Sounds.Click)
		ClassMenu:Close()
		BlurMenu:Close()
		InvisiblePanel:Close()
	end
	randombutton.OnCursorEntered = function () Colors.RandomButtonNormal = Color (200, 200, 200, 255) Colors.RandomButtonBack = Color (111,27,27,255) surface.PlaySound (Sounds.Over) end
	randombutton.OnCursorExited = function () Colors.RandomButtonNormal = Color (200, 200, 200, 255) Colors.RandomButtonBack = Color (33,9,9,255) end
	
	local LabelMedic = vgui.Create("DLabel")
	LabelMedic:SetParent( Menu )
	LabelMedic:SetText("")
	LabelMedic:SetSize (ScaleW(207), ScaleH(36)) 
	LabelMedic:SetPos (ScaleW(93-offsetx), ScaleH(124))
	LabelMedic.OnCursorEntered = function () Colors.MedicButton = Color (200, 200, 200, 255) Colors.MedicBack = Color (157,34,34,86) if SelectedClass ~= 1 then surface.PlaySound (Sounds.Over) end end
	LabelMedic.OnCursorExited = function () Colors.MedicButton = Color (200, 200, 200, 255) Colors.MedicBack = Color (15,4,4,86) end
	LabelMedic.OnMousePressed = function () 
		if SelectedClass ~= 1 then
			surface.PlaySound (Sounds.Click) 
		end
		SelectedClass = 1 
		Colors.MedicBack = Color (125 ,98, 98,86)
		Colors.CommandoBack = Color (15,4,4,86)
		Colors.EngineerBack = Color (15,4,4,86)
		Colors.BersekerBack = Color (15,4,4,86)
		Colors.SupportBack = Color (15,4,4,86)
	end
	LabelMedic.Think = function() 
		if SelectedClass == 1 then
			Colors.MedicBack = Color (125 ,98, 98,86)
		end
	end
	
	local LabelCommando = vgui.Create("DLabel")
	LabelCommando:SetParent( Menu )
	LabelCommando:SetText("")
	LabelCommando:SetSize (ScaleW(207), ScaleH(36)) 
	LabelCommando:SetPos (ScaleW(93-offsetx), ScaleH(214))
	LabelCommando.OnCursorEntered = function () Colors.CommandoButton = Color (200, 200, 200, 255) Colors.CommandoBack = Color (157,34,34,86) if SelectedClass ~= 2 then surface.PlaySound (Sounds.Over) end end
	LabelCommando.OnCursorExited = function () Colors.CommandoButton = Color (200, 200, 200, 255) Colors.CommandoBack = Color (15,4,4,86) end
	LabelCommando.OnMousePressed = function () 
		if SelectedClass ~= 2 then
			surface.PlaySound (Sounds.Click) 
		end
		SelectedClass = 2 
		Colors.MedicBack = Color (15,4,4,86)
		Colors.CommandoBack = Color (125 ,98, 98,86)
		Colors.EngineerBack = Color (15,4,4,86)
		Colors.BersekerBack = Color (15,4,4,86)
		Colors.SupportBack = Color (15,4,4,86)
	end
	LabelCommando.Think = function() 
		if SelectedClass == 2 then
			Colors.CommandoBack = Color (125 ,98, 98,86)
		end
	end
	
	local LabelBerseker = vgui.Create("DLabel")
	LabelBerseker:SetParent( Menu )
	LabelBerseker:SetText("")
	LabelBerseker:SetSize (ScaleW(207), ScaleH(36)) 
	LabelBerseker:SetPos (ScaleW(93-offsetx), ScaleH(312))
	LabelBerseker.OnCursorEntered = function () Colors.BersekerButton = Color (200, 200, 200, 255) Colors.BersekerBack = Color (157,34,34,86) if SelectedClass ~= 3 then surface.PlaySound (Sounds.Over) end end
	LabelBerseker.OnCursorExited = function () Colors.BersekerButton = Color (200, 200, 200, 255) Colors.BersekerBack = Color (15,4,4,86) end
	LabelBerseker.OnMousePressed = function () 
		if SelectedClass ~= 3 then
			surface.PlaySound (Sounds.Click) 
		end
		SelectedClass = 3 
		Colors.MedicBack = Color (15,4,4,86)
		Colors.CommandoBack = Color (15,4,4,86)
		Colors.EngineerBack = Color (15,4,4,86)
		Colors.BersekerBack = Color (125 ,98, 98,86)
		Colors.SupportBack = Color (15,4,4,86)		
	end
	LabelBerseker.Think = function() 
		if SelectedClass == 3 then
			Colors.BersekerBack = Color (125 ,98, 98,86)
		end
	end
	
	local LabelEngineer = vgui.Create("DLabel")
	LabelEngineer:SetParent( Menu )
	LabelEngineer:SetText("")
	LabelEngineer:SetSize (ScaleW(207), ScaleH(36)) 
	LabelEngineer:SetPos (ScaleW(93-offsetx), ScaleH(408))
	LabelEngineer.OnCursorEntered = function () Colors.EngineerButton = Color (200, 200, 200, 255) Colors.EngineerBack = Color (157,34,34,86) if SelectedClass ~= 4 then surface.PlaySound (Sounds.Over) end end
	LabelEngineer.OnCursorExited = function () Colors.EngineerButton = Color (200, 200, 200, 255) Colors.EngineerBack = Color (15,4,4,86) end
	LabelEngineer.OnMousePressed = function ()
		if SelectedClass ~= 4 then
			surface.PlaySound (Sounds.Click) 
		end
		SelectedClass = 4 
		Colors.MedicBack = Color (15,4,4,86)
		Colors.CommandoBack = Color (15,4,4,86)
		Colors.EngineerBack = Color (125 ,98, 98,86)
		Colors.BersekerBack = Color (15,4,4,86)
		Colors.SupportBack = Color (15,4,4,86)
	end
	LabelEngineer.Think = function() 
		if SelectedClass == 4 then
			Colors.EngineerBack = Color (125 ,98, 98,86)
		end
	end
	
	local LabelSupport = vgui.Create("DLabel")
	LabelSupport:SetParent( Menu )
	LabelSupport:SetText("")
	LabelSupport:SetSize (ScaleW(207), ScaleH(36)) 
	LabelSupport:SetPos (ScaleW(93-offsetx), ScaleH(518))
	LabelSupport.OnCursorEntered = function () Colors.SupportButton = Color (200, 200, 200, 255) Colors.SupportBack = Color (157,34,34,86) if SelectedClass ~= 5 then surface.PlaySound (Sounds.Over) end end
	LabelSupport.OnCursorExited = function () Colors.SupportButton = Color (200, 200, 200, 255) Colors.SupportBack = Color (15,4,4,86) end
	LabelSupport.OnMousePressed = function () 
		if SelectedClass ~= 5 then
			surface.PlaySound (Sounds.Click) 
		end
		SelectedClass = 5 
		Colors.MedicBack = Color (15,4,4,86)
		Colors.CommandoBack = Color (15,4,4,86)
		Colors.EngineerBack = Color (15,4,4,86)
		Colors.BersekerBack = Color (15,4,4,86)
		Colors.SupportBack = Color (125 ,98, 98,86)		
	end
	LabelSupport.Think = function() 
		if SelectedClass == 5 then
			Colors.SupportBack = Color (125 ,98, 98,86)
		end
	end
	
---------------------------------------------------------------------------------------------------------------------------------		
	Menu.Think = function ()
		gui.EnableScreenClicker(true) --  Prevent Steam Chat to enable mouse!
	end
end

--usermessage.Hook("DrawSelectClass", DrawSelectClass) 

-- -- -- -- -- -- -- -- -- -- /
-- New window WIP-- 
-- -- -- -- -- -- -- -- -- -- 

local Sounds = {}
Sounds.Accept = "mrgreen/ui/menu_focus.wav"
Sounds.Click = "mrgreen/ui/menu_click01.wav"
Sounds.Over = "mrgreen/ui/menu_accept.wav"
Sounds.Startup = "mrgreen/ui/gamestartup1.mp3"

local Colors = {}
Colors[1] = {CButton = Color (0,0,0,255)}
Colors[2] = {CButton = Color (0,0,0,255)}
Colors[3] = {CButton = Color (0,0,0,255)}
Colors[4] = {CButton = Color (0,0,0,255)}
Colors[5] = {CButton = Color (0,0,0,255)}

local SpawnButtons = {}

SpawnButtons.ColorUsual = Color(1,1,1,180)
SpawnButtons.ColorUsualOver = Color(200,200,200,255)
SpawnButtons.ColorUsualBack = Color(0,0,0,255)

SpawnButtons.ColorRandom = Color(1,1,1,180)
SpawnButtons.ColorRandomOver = Color(200,200,200,255)
SpawnButtons.ColorRandomBack = Color(0,0,0,255)

local Classes = {}
Classes[1] = {LabelName = "Medic",Avatar = "zombiesurvival/hud/avatar_medic",Desc1 = "Pros.: Fast, have pistol damage bonus, body armor.",Desc2 = "Cons.: Not a military guy.", AddSize = 1.0, Overed = false} -- I need addsize thingy to add some kind of animations for buttons later
Classes[2] = {LabelName = "Commando",Avatar = "zombiesurvival/hud/avatar_commando",Desc1 = "Pros.: Brutal, have bonus damage for all weapons.",Desc2 = "Cons.: Slow.", AddSize = 1.0, Overed = false}
Classes[3] = {LabelName = "Berserker",Avatar = "zombiesurvival/hud/avatar_berserker",Desc1 = "Pros.: Cold blooded killer. Uses sniper rifles.",Desc2 = "Cons.: Not easy for use, very weak at close range.", AddSize = 1.0, Overed = false}
Classes[4] = {LabelName = "Engineer",Avatar = "zombiesurvival/hud/avatar_engineer",Desc1 = "Pros.: Have bonuses for pulse-powered weapons, got 'pro builder' kit.",Desc2 = "Cons.: Explosive, not a military guy.", AddSize = 1.0, Overed = false}
Classes[5] = {LabelName = "Support",Avatar = "zombiesurvival/hud/avatar_support",Desc1 = "Pros.: Equipped with hammer, additional smg damage, got Mobile Supplies.",Desc2 = "Cons.: Sometimes very selfish, not a military guy.", AddSize = 1.0, Overed = false}

local SelectedClass = 1

local achstat1
local achstat2

Loadout = Loadout or {}

function DrawSelectClass1 ()
	-- 
	
	
	local filename = "zombiesurvival/loadouts/default.txt"
	if file.Exists (filename) then
		local tbl = util.JSONToTable(file.Read(filename))
		Loadout = table.Copy(tbl)
		for _,v in pairs (Loadout) do
			if not MySelf:HasUnlocked(v) then
				Loadout[_] = nil
			end
		end
	else
		Loadout = {"weapon_zs_usp","weapon_zs_galil"}
	end
	-- 


	local bloodrand1 = bloodSplats[math.random(1,2)]
	local bloodrand2 = bloodSplats[math.random(3,5)]
	
	local spawntimer = 35
	local spawntimercd = 0
	local randmusic = math.random(1,3)
	
	if randmusic == 1 then
		Sounds.Startup = "mrgreen/ui/deadlightdistrict.mp3" 
	elseif randmusic == 2 then
		Sounds.Startup = "mrgreen/ui/osweetdeath.mp3" 
	else
		Sounds.Startup = "mrgreen/ui/gamestartup1.mp3"
	end
	surface.PlaySound (Sounds.Startup)
	
	--local BlurMenu = vgui.Create("DFrame")
	--BlurMenu:SetSize(10,10)
	--BlurMenu:SetPos(w/2-5,h/2-5)
	--BlurMenu:SetDraggable ( false )
	--BlurMenu:SetBackgroundBlur( true )
	
	local InvisiblePanel = vgui.Create("DFrame")
	InvisiblePanel:SetSize(w,h)
	InvisiblePanel:SetPos(0,0)
	InvisiblePanel:SetDraggable ( false )
	InvisiblePanel:SetTitle ("")
	InvisiblePanel:ShowCloseButton (false)
	InvisiblePanel.Paint = function() 
		-- override this
	end
	
	local BloodPanel = vgui.Create("DLabel")
	BloodPanel:SetText("")
	BloodPanel:SetParent(InvisiblePanel)
	BloodPanel:SetSize (w, h) 
	BloodPanel:SetPos (0, 0)
	BloodPanel.Paint = function ()
		surface.SetTexture( bloodrand1 )
		surface.SetDrawColor( Color(120,0,0,255) )
		surface.DrawTexturedRect( 0,0,w,h )
		surface.SetTexture( bloodrand2 )
		surface.DrawTexturedRect( 0,0,w,h )
	end
	local TopClasspanel = vgui.Create("DFrame")
	TopClasspanel:SetSize (ScaleW(681), ScaleH(189)) 
	TopClasspanel:SetPos (w/2-TopClasspanel:GetWide()/2, ScaleH(25)) 
	TopClasspanel:SetTitle("")
	TopClasspanel:ShowCloseButton( false )
	TopClasspanel:SetDraggable ( false )
	TopClasspanel.Paint = function ()
		    surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawOutlinedRect( 0, 0, TopClasspanel:GetWide(), TopClasspanel:GetTall())
			draw.RoundedBox( 0, 0, 0, TopClasspanel:GetWide(), TopClasspanel:GetTall() , Color (1,1,1,200) )
	
	
		-- TODO: make new icons
		local TopClassoffsetx,TopClassoffsety = 15,24
		local classx = 15 -- easy way to move all background panels at once
		local spacing = 27
		
		--  In-Tab Boxes -- Medic
		CreateClassIcon(TopClassoffsetx+classx,TopClassoffsety,103,145,"zombiesurvival/hud/avatar_medic",Colors[1].CButton,1)
		classx = classx + 103 + spacing
		
		--  In-Tab Boxes -- Commando
		CreateClassIcon(TopClassoffsetx+classx,TopClassoffsety,103,145,"zombiesurvival/hud/avatar_commando",Colors[2].CButton,2)
		classx = classx + 103 + spacing
		
		--  In-Tab Boxes -- Berserker
		CreateClassIcon(TopClassoffsetx+classx,TopClassoffsety,103,145,"zombiesurvival/hud/avatar_berserker",Colors[3].CButton,3)
		classx = classx + 103 + spacing
		
		--  In-Tab Boxes -- Engineer
		CreateClassIcon(TopClassoffsetx+classx,TopClassoffsety,103,145,"zombiesurvival/hud/avatar_engineer",Colors[4].CButton,4)
		classx = classx + 103 + spacing
		
		--  In-Tab Boxes -- Support
		CreateClassIcon(TopClassoffsetx+classx,TopClassoffsety,103,145,"zombiesurvival/hud/avatar_support",Colors[5].CButton,5)	
		
		
	end
	--Huge Panel with info and etc--------------------------------------------------------------------------------------------------------------------------------------------
	
	local InfoHugePanel = vgui.Create("DLabel")
	InfoHugePanel:SetSize(w,h)
	InfoHugePanel:SetPos(0,0)
	InfoHugePanel:SetText("")
	InfoHugePanel:SetParent(InvisiblePanel)
	InfoHugePanel.Paint = function()
	
	local HugePanelW, HugePanelH = ScaleW(261), ScaleH(329)
	local HugePanelX, HugePanelY = ((w*0.5)-(HugePanelW/2)),(h*0.5)-(HugePanelH/2) 
	
	--Avatar panel--------
	draw.RoundedBox( 16, HugePanelX, HugePanelY, HugePanelW, HugePanelH , Color (1,1,1,230) )
	
	--Left and right panels--
	
	local SideSmallPanelW,SideSmallPanelH = ScaleW(51), ScaleH(260) -- size of small left and pight panels
	local SidePanelW,SidePanelH = ScaleW(271)-SideSmallPanelW, ScaleH(200) -- size of bigger left and right panels
	
	-- left panels
	local leftx = w*0.5 - HugePanelW/2 - SideSmallPanelW
	draw.RoundedBoxEx( 8, leftx, (h*0.5)-(SideSmallPanelH/2), SideSmallPanelW, SideSmallPanelH, Color(1,1,1,230), true, false, true, false )
	leftx = leftx - SidePanelW
	draw.RoundedBoxEx( 16, leftx, (h*0.5)-(SidePanelH/2), SidePanelW, SidePanelH, Color(1,1,1,230), true, false, true, false )
	
	-- right panels
	local rightx = w*0.5 + HugePanelW/2
	draw.RoundedBoxEx( 8, rightx, (h*0.5)-(SideSmallPanelH/2), SideSmallPanelW, SideSmallPanelH, Color(1,1,1,230), false, true, false, true )
	rightx = rightx + SideSmallPanelW
	draw.RoundedBoxEx( 16, rightx, (h*0.5)-(SidePanelH/2), SidePanelW, SidePanelH, Color(1,1,1,230), false, true, false, true )
	
	--Avatar on huge panel-------------------------
	
	local IndexToName = string.lower(Classes[SelectedClass].LabelName)
	
	local AvatarTexture = Classes[SelectedClass].Avatar
	local AvatarW, AvatarH = HugePanelW*0.65, HugePanelH*0.75
	local AvatarX, AvatarY = w/2 - AvatarW/2, h/2 - AvatarH/2
	
	draw.RoundedBox( 16, AvatarX-8, AvatarY-8, AvatarW+16,  AvatarH+16 , Color (1,1,1,100) )
	
	local Quad = {} 
	Quad.texture 	= surface.GetTextureID( AvatarTexture )
	Quad.color		= Color (255,255,255,255) 
 
	Quad.x = AvatarX
	Quad.y = AvatarY
	Quad.w = AvatarW
	Quad.h = AvatarH
	draw.TexturedQuad( Quad )
	
	
	--Perks on left panel----------------------------
	local PerkPanelX, PerkPanelY = leftx+ScaleW(12),((h*0.5)-(SidePanelH/2))+ScaleH(17)
	
	CreatePerkPanel(PerkPanelX, PerkPanelY)
	
	--Lvl requirements on right panel-------------
	local ReqPanelX, ReqPanelY = rightx+ScaleW(2),((h*0.5)-(SidePanelH/2))+ScaleH(17)
	CreateRequirementsPanel(ReqPanelX, ReqPanelY)
	
	
	--Class description ------------------------------
	local ClassDesX,ClassDesY = w/2,HugePanelY + HugePanelH + ScaleH(39)
	CreateClassDescription(ClassDesX,ClassDesY)
	end
	--Spawn Button------------------------------------
	local spawnbutton = vgui.Create("DButton",InvisiblePanel)
	spawnbutton:SetText("")
	spawnbutton:SetPos(w/3,h/2 +ScaleH(368))
	spawnbutton:SetSize (ScaleW(142),ScaleH(45))
	spawnbutton.Paint = function ()
		surface.SetDrawColor( SpawnButtons.ColorUsualBack )
		surface.DrawOutlinedRect( 0, 0, spawnbutton:GetWide(), spawnbutton:GetTall())
		draw.RoundedBox( 0, 0, 0,spawnbutton:GetWide(), spawnbutton:GetTall(), SpawnButtons.ColorUsual )
		draw.SimpleText("SPAWN", "ArialBoldTwelve", ScaleW(71), ScaleH(5), Color (255,255,255,255), TEXT_ALIGN_CENTER)
	end
	spawnbutton.OnCursorEntered = function () SpawnButtons.ColorUsualBack = Color (200, 200, 200, 255) surface.PlaySound (Sounds.Over) end
	spawnbutton.OnCursorExited = function () SpawnButtons.ColorUsualBack = Color (0, 0, 0, 255) end
	spawnbutton.DoClick = function ()
		ChangeClassClient (SelectedClass)
		surface.PlaySound (Sounds.Click)
		TopClasspanel:Close()
		--BlurMenu:Close()
		InvisiblePanel:Close()
	end
	--Random Button-------------------------------------
	local randombutton = vgui.Create("DButton",InvisiblePanel)
	randombutton:SetText("")
	randombutton:SetPos(2*w/3 - ScaleW(142),h/2 +ScaleH(368))
	randombutton:SetSize (ScaleW(142),ScaleH(45))
	randombutton.Think = function () 
		if spawntimercd <= CurTime() then 
			spawntimer = spawntimer - 1
			if spawntimer <= 0 then
				local randomclass = math.random (1,5)
				ChangeClassClient (randomclass)
				surface.PlaySound (Sounds.Click)
				TopClasspanel:Close()
				--BlurMenu:Close()
				InvisiblePanel:Close()
			end
			spawntimercd = CurTime() + 1
		end
	end
	
	randombutton.Paint = function ()
		surface.SetDrawColor( SpawnButtons.ColorRandomBack )
		surface.DrawOutlinedRect( 0, 0, randombutton:GetWide(), randombutton:GetTall())
		draw.RoundedBox( 0, 0, 0,randombutton:GetWide(), randombutton:GetTall(), SpawnButtons.ColorRandom )
		draw.SimpleText("RANDOM ("..spawntimer..")" , "ArialBoldTwelve", ScaleW(71), ScaleH(5), Color (255,255,255,255), TEXT_ALIGN_CENTER)
	end
	randombutton.DoClick = function ()
		local randclass = math.random (1,5)
		ChangeClassClient (randclass)
		surface.PlaySound (Sounds.Click)
		TopClasspanel:Close()
		--BlurMenu:Close()
		InvisiblePanel:Close()
	end
	randombutton.OnCursorEntered = function () SpawnButtons.ColorRandomBack = Color (200, 200, 200, 255) surface.PlaySound (Sounds.Over) end
	randombutton.OnCursorExited = function () SpawnButtons.ColorRandomBack = Color (0, 0, 0, 255) end
	
	
	
	--Labels-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	local TopClassoffsetx,TopClassoffsety = 15,24
	local classx = 15
	local spacing = 27
	-- Medic
	CreateClassLabel(TopClassoffsetx+classx,TopClassoffsety,103,145,1,TopClasspanel)
	classx = classx + 103 + spacing
	-- Commando
	CreateClassLabel(TopClassoffsetx+classx,TopClassoffsety,103,145,2,TopClasspanel)
	classx = classx + 103 + spacing
	-- Berserker
	CreateClassLabel(TopClassoffsetx+classx,TopClassoffsety,103,145,3,TopClasspanel)
	classx = classx + 103 + spacing
	-- Engineer
	CreateClassLabel(TopClassoffsetx+classx,TopClassoffsety,103,145,4,TopClasspanel)
	classx = classx + 103 + spacing
	-- Support
	CreateClassLabel(TopClassoffsetx+classx,TopClassoffsety,103,145,5,TopClasspanel)	
	
	TopClasspanel.Think = function ()
		gui.EnableScreenClicker(true) --  Prevent Steam Chat to enable mouse!
	end
	
end

function CreateClassIcon(x,y,w,h,texture,color,class)
		
		-- Changing position, size
		x = x - (w * Classes[class].AddSize - w)/2
		y = y - (h * Classes[class].AddSize - h)/2
		w = w * Classes[class].AddSize
		h = h * Classes[class].AddSize
		
		-- Draw outline
		draw.RoundedBox( 0, ScaleW(x-4), ScaleH(y-4), ScaleW(w+8), ScaleH(h+8), color )
		
		-- Draw the icon itself
		local Quad = {} 
		Quad.texture 	= surface.GetTextureID( texture )
		Quad.color		= Color (255,255,255,255) 
 
		Quad.x = ScaleW(x)
		Quad.y = ScaleH(y)
		Quad.w = ScaleW(w)
		Quad.h = ScaleH(h)
		draw.TexturedQuad( Quad )
		
		-- Draw small box for level
		local LvlBoxW, LvLBoxH = Quad.w/6,Quad.h/6--ScaleW(21),ScaleH(26)
		
		local LvlBoxX, LvlBoxY = ScaleW(x),ScaleH(y)+ScaleH(h)-LvLBoxH
		
		-- Small texture glitch fix
		if texture == "zombiesurvival/hud/avatar_berserker" then
			LvlBoxX = LvlBoxX - 1
		end
		
		
		draw.RoundedBox( 0,LvlBoxX,LvlBoxY, LvlBoxW, LvLBoxH , Color (1,1,1,200) )
		
		-- Draw level number
		local IndexToName = string.lower(Classes[class].LabelName)
		local Lvl = MySelf.DataTable["ClassData"][IndexToName].level
		
		local LvlX,LvlY = LvlBoxX + LvlBoxW/2,LvlBoxY + LvlBoxW/2
		
		draw.SimpleText(Lvl, "ArialBoldFive", LvlX, LvlY, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
end

function CreateClassLabel(x,y,w,h,class,parentframe)
	
	x = x - (w * Classes[class].AddSize - w)/2
	y = y - (h * Classes[class].AddSize - h)/2
	w = w * Classes[class].AddSize
	h = h * Classes[class].AddSize
		
	local ClassLabel = vgui.Create("DLabel")
	ClassLabel:SetParent( parentframe )
	ClassLabel:SetText("")
	ClassLabel:SetSize (ScaleW(w), ScaleH(h)) 
	ClassLabel:SetPos (ScaleW(x), ScaleH(y))
	ClassLabel.OnCursorEntered = function() 
		Colors[class].CButton = Color (200, 200, 200, 255) 
		Classes[class].Overed = true -- sadly but labels doesnt have PaintOverHovered function :/
			if SelectedClass ~= class then 
				surface.PlaySound (Sounds.Over) 
			end 
	end
	ClassLabel.OnCursorExited = function () 
		Colors[class].CButton = Color (0,0,0,255) 
		Classes[class].Overed = false
	end
	ClassLabel.OnMousePressed = function () 
		if SelectedClass ~= class then
			surface.PlaySound (Sounds.Click) 
		end
		SelectedClass = class 
		
		for k,v in pairs(Colors) do
			if SelectedClass == k then 
			Colors[k].CButton = Color (255, 0, 0, 255) 
			else
			Colors[k].CButton = Color (0, 0, 0, 255) 
			end
		end
	end
	ClassLabel.Think = function() 
		if SelectedClass == class then
			Colors[class].CButton = Color (255, 0, 0, 255)
		end
		if Classes[class].Overed == true then
			Classes[class].AddSize = math.Clamp(math.Approach(Classes[class].AddSize, 1.15,0.0115),1.0,1.15 )
		else
			Classes[class].AddSize = math.Clamp(math.Approach(Classes[class].AddSize, 1.0, 0.01),1.0,1.15 )
		end
		
	end

end

function CreatePerkPanel(x,y)

	surface.SetFont( "ArialBoldTen" ) 
	surface.SetTextPos(x,y)
	surface.DrawText("Perk Description")
	
	surface.SetFont( "ArialBoldFive" ) 
	local spacing = 41
	surface.SetTextPos(x,y+spacing)
	surface.DrawText( ""..(HumanClasses[SelectedClass].Coef[1]*(MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1)).." "..HumanClasses[SelectedClass].Description[1] )	
	spacing = spacing + 24
	surface.SetTextPos(x,y+spacing)		
	surface.DrawText(  ""..(HumanClasses[SelectedClass].Coef[2]*(MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1)).." "..HumanClasses[SelectedClass].Description[2] )	
	spacing = spacing + 24
	surface.SetTextPos(x,y+spacing)		
	surface.DrawText(  ""..(HumanClasses[SelectedClass].Coef[3]*(MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1)).." "..HumanClasses[SelectedClass].Description[3] )
	spacing = spacing + 24
	surface.SetTextPos(x,y+spacing)	
	if SelectedClass == 2 then
		surface.DrawText( ""..HumanClasses[SelectedClass].Description[4] ) 
	else
		surface.DrawText( ""..(HumanClasses[SelectedClass].Coef[4]*(MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1)).." "..HumanClasses[SelectedClass].Description[4] )
	end
end


function CreateRequirementsPanel(x,y)
-- Grab some data
if MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level == 0 or MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level == 1 then
	achstat1 = MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].achlevel0_1
	achstat2 = MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].achlevel0_2
elseif MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level == 2 or MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level == 3 then
	achstat1 = MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].achlevel2_1
	achstat2 = MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].achlevel2_2
elseif MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level == 4 or MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level == 5 or MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level == 6 then
	achstat1 = MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].achlevel4_1
	achstat2 = MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].achlevel4_2
end

--print("Achiv1: "..achstat1..", Achiv2: "..achstat2.."")

-- Make header
---------------------------

	surface.SetFont( "ArialBoldTen" ) 
	surface.SetTextPos(x,y)
	surface.DrawText("Next level requirements")
	
---------------------------	

	surface.SetFont( "ArialBoldFive" ) 
	local spacing = 41
	-- Draw text for 1st requirement
	surface.SetTextPos(x,y+spacing)
	surface.DrawText(""..(ClassInfo[SelectedClass].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1][1])..": "..achstat1)
	spacing = spacing + 24
	-- Draw bar for 1st requirement
	draw.RoundedBox(0, x,y+spacing,ScaleW( math.Clamp( (achstat1 / ClassInfo[SelectedClass].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1][3]),0,1) *207) ,ScaleH(22), Color(200,200,200,255))
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawOutlinedRect( x, y+spacing,ScaleW(207), ScaleH(22)+1)
	spacing = spacing + 24
	-- Draw text for2nd requirement
	surface.SetTextPos(x,y+spacing)
	surface.DrawText(""..(ClassInfo[SelectedClass].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1][2])..": "..achstat2)
	spacing = spacing + 24
	-- Draw bar for 2nd requirement
	draw.RoundedBox(0, x,y+spacing,ScaleW( math.Clamp( (achstat2 / ClassInfo[SelectedClass].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1][4]),0,1) *207) ,ScaleH(22), Color(200,200,200,255))
	--print("Actual: "..tonumber(achstat2)..", Need:"..tonumber(ClassInfo[SelectedClass].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1][4])..", Coef:"..tonumber(math.Clamp( (achstat2 / ClassInfo[SelectedClass].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1][4]),0,1))..", Draw: "..tonumber(math.Clamp( (achstat2 / ClassInfo[SelectedClass].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1][4]),0,1) *233).."/233, Actual draw: "..tonumber(ScaleW( math.Clamp( (achstat2 / ClassInfo[SelectedClass].Ach[MySelf.DataTable["ClassData"][string.lower(HumanClasses[SelectedClass].Name)].level+1][4]),0,1) *233)).."/"..tonumber(ScaleW(233)).." ")
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawOutlinedRect( x, y+spacing,ScaleW(207), ScaleH(22)+1)

end

function CreateClassDescription(x,y)
-- Draw cool background
surface.SetDrawColor( 0, 0, 0, 255 )
surface.DrawOutlinedRect( -1, y, w+1, ScaleH(230))
draw.RoundedBox( 0, -1, y, w+1, ScaleH(230), Color (1,1,1,200) )
y = y + ScaleH(26)

-- Draw class name
local DrawName = HumanClasses[SelectedClass].Name

if SelectedClass == 3 then DrawName = "Marksman" end

draw.SimpleText(DrawName,"ArialBoldFifteen",x,y,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
y = y + ScaleH(51)

-- Draw descriptions
draw.SimpleText(Classes[SelectedClass].Desc1,"ArialBoldTwelve",x,y,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
y = y + ScaleH(43)
draw.SimpleText(Classes[SelectedClass].Desc2,"ArialBoldTwelve",x,y,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)


end



function IsWeapon(wep)
	if not wep then return end
	if string.sub(wep, 1, 6) == "weapon" and GAMEMODE.HumanWeapons[wep] then
		return true
	end
	return false
end

function IsPerk(wep)
	if not wep then return end
	if string.sub(wep, 1, 1) == "_" and GAMEMODE.Perks[wep] then
		return true
	end
	return false
end

function GetPerkSlot(wep)
	if not wep then return end
	if not IsPerk(wep) then return end
	return GAMEMODE.Perks[wep].Slot or 0	
end

local Gradient = surface.GetTextureID( "gui/center_gradient" )

local lock_icon = Material("icon16/lock.png")
local heart_icon = Material("icon16/heart.png")


-- Lists
Unlocks = {}
SlotLabel = {}
function DrawContextMenu(x,y,ww,hh,weptype,parent,num)
	
	Unlocks[num] = vgui.Create( "DPanelList", parent )
	Unlocks[num]:SetPos( x,y )
	Unlocks[num]:SetSize(ww,hh*6)
	Unlocks[num]:SetSpacing( 0 )
	Unlocks[num]:SetPadding(0)
	Unlocks[num]:EnableHorizontal( true )
	Unlocks[num]:EnableVerticalScrollbar( false )
	-- Unlocks[num]:SetVisible ( false )
	Unlocks[num].Paint = function ()
		DrawPanelBlackBox(0,0,ww,hh*6)
	end
	
	local ItemLabel = {}
	
	-- if num ~= 6 then -- not a perk
		for i=0,table.maxn(GAMEMODE.RankUnlocks) do
			if GAMEMODE.RankUnlocks[i] then
				for _,item in pairs(GAMEMODE.RankUnlocks[i]) do
					if MySelf:HasUnlocked(item) then
						if IsWeapon(item) and GetWeaponCategory ( item ) == weptype then
							ItemLabel[item] = vgui.Create("DLabel",Unlocks[num])
							ItemLabel[item]:SetText("")
							-- ItemLabel[item]:SetSize(LoadoutMenuW,(LoadoutMenuH/6)*0.9) 
							ItemLabel[item]:SetSize(ww/3,hh) 
							ItemLabel[item].OnCursorEntered = function() 
								ItemLabel[item].Overed = true 
								surface.PlaySound ("UI/buttonrollover.wav") 
							end
							ItemLabel[item].OnCursorExited = function () 
								ItemLabel[item].Overed = false
							end
							
							ItemLabel[item].OnMousePressed = function () 
								if MySelf:IsBlocked(item) then
									surface.PlaySound ( "buttons/weapon_cant_buy.wav" )
								else
									if SlotLabel[num] then
										SlotLabel[num].Item = item
										Unlocks[num]:Remove()
										Unlocks[num] = nil
									end
								end
							end
							
							ItemLabel[item].Think = function()
								if GAMEMODE:IsRetroMode() then
									if MySelf:IsBlocked(item) then
										ItemLabel[item]:SetToolTip("Not avalaible in retro mode!")
									end
									if MySelf:IsRetroOnly(item) then
										ItemLabel[item]:SetToolTip("Avalaible only in retro mode!")
									end
								end
							end
							
							ItemLabel[item].Paint = function()
								
								if ItemLabel[item].Overed then
									surface.SetDrawColor( 255, 255, 255, 255)
									surface.DrawOutlinedRect( 0, 0, ww/3, hh)
									surface.DrawOutlinedRect( 1, 1, ww-2, hh-2 )
								else
									surface.SetDrawColor( 30, 30, 30, 200 )
									surface.DrawOutlinedRect( 0, 0, ww/3, hh)
									surface.SetDrawColor( 30, 30, 30, 255 )
									surface.DrawOutlinedRect( 1, 1, ww/3-2, hh-2 )
								end
								
								if item == "none" then
									surface.SetDrawColor( 255, 255, 255, 255) 
									draw.SimpleTextOutlined ( "NO ITEM", "WeaponNames", (ww/3)/2, hh/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
									return
								end
								
								
								if string.sub(item, 1, 6) == "weapon" then
								local font, letter = "WeaponSelectedHL2", "0"
								local Table = killicon.GetFont( item )
										
									if Table then
										letter = Table.letter
											
										if not Table.IsHl2 and not Table.IsZS then
											font = "WeaponSelectedCSS"
										elseif not Table.IsHL2 and Table.IsZS then
											font = "WeaponSelectedZS"
										end
											
									end
										
									if killicon.GetImage( item ) then
										
										local ImgTable = killicon.GetImage( item ) 
															

											surface.SetDrawColor( 255, 255, 255, 255) 
											draw.SimpleTextOutlined ( GAMEMODE.HumanWeapons[item].Name, "WeaponNames", (ww/3)/2, 7, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
															
											surface.SetTexture(surface.GetTextureID( ImgTable.mat ))	
											local wd,hg = surface.GetTextureSize(surface.GetTextureID( ImgTable.mat ))
											local clampedH = (ww/3*hg)/wd
											surface.DrawTexturedRect( 57.5,12, wd, math.Clamp(hg,0,hh) )-- surface.DrawTexturedRect( x + 57.5,y + 12, wd, clampedH )

										
										else
										
											surface.SetFont ( font )
											local fWide, fTall = surface.GetTextSize ( letter )
											
											surface.SetDrawColor( 255, 255, 255, 255 )
											draw.SimpleTextOutlined ( GAMEMODE.HumanWeapons[item].Name, "WeaponNames", (ww/3)/2, 7, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
												
											
											draw.SimpleTextOutlined ( letter, font, (ww/3)/2, 55, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
										
										end
								end
								
								if MySelf:IsBlocked( item ) then
									surface.SetDrawColor(255,255,255,255)
									surface.SetMaterial( lock_icon )
									surface.DrawTexturedRect((ww/3)-18,2,16,16)
								end
								
								if MySelf:IsRetroOnly( item ) then
									surface.SetDrawColor(255,255,255,255)
									surface.SetMaterial( heart_icon )
									surface.DrawTexturedRect((ww/3)-18,2,16,16)
								end

							end
							
							Unlocks[num]:AddItem(ItemLabel[item])
							
						elseif IsPerk(item) and ((GetPerkSlot(item) == 1 and num == 5) or (GetPerkSlot(item) == 2 and num == 6)) then
							
							ItemLabel[item] = vgui.Create("DLabel",Unlocks[num])
							ItemLabel[item]:SetText("")
							ItemLabel[item]:SetSize(ww/3,hh) 
							-- ItemLabel[item]:SetSize(LoadoutMenuW,(LoadoutMenuH/6)*0.9) 
							ItemLabel[item].OnCursorEntered = function() 
								ItemLabel[item].Overed = true 
								surface.PlaySound ("UI/buttonrollover.wav") 
							end
							ItemLabel[item].OnCursorExited = function () 
								ItemLabel[item].Overed = false
							end
							
							ItemLabel[item].OnMousePressed = function () 
								if MySelf:IsBlocked(item) then
									surface.PlaySound ( "buttons/weapon_cant_buy.wav" )
								else
									if SlotLabel[num] then
										SlotLabel[num].Item = item
										Unlocks[num]:Remove()
										Unlocks[num] = nil
									end
								end
							end
							
							ItemLabel[item].Think = function()
								if GAMEMODE:IsRetroMode() then
									if MySelf:IsBlocked(item) then
										ItemLabel[item]:SetToolTip("Not avalaible in retro mode!")
									elseif MySelf:IsRetroOnly(item) then
										ItemLabel[item]:SetToolTip("Avalaible only in retro mode!")
									else
										ItemLabel[item]:SetToolTip(GAMEMODE.Perks[item].Description)
									end
								else
									ItemLabel[item]:SetToolTip(GAMEMODE.Perks[item].Description)
								end
							end
							
							ItemLabel[item].Paint = function()
								
								if ItemLabel[item].Overed then
									surface.SetDrawColor( 255, 255, 255, 255)
									surface.DrawOutlinedRect( 0, 0, ww/3, hh)
									surface.DrawOutlinedRect( 1, 1, ww/3-2, hh-2 )
								else
									surface.SetDrawColor( 30, 30, 30, 200 )
									surface.DrawOutlinedRect( 0, 0, ww/3, hh)
									surface.SetDrawColor( 30, 30, 30, 255 )
									surface.DrawOutlinedRect( 1, 1, ww/3-2, hh-2 )
								end
								
								if item == "none" then
									surface.SetDrawColor( 255, 255, 255, 255) 
									draw.SimpleTextOutlined ( "NO ITEM", "WeaponNames", (ww/3)/2, hh/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
									return
								end
								
								
								if string.sub(item, 1, 1) == "_" then
									for perk, desc in pairs(GAMEMODE.Perks) do
										if item == perk then
										surface.SetDrawColor( 255, 255, 255, 255) 
										draw.SimpleTextOutlined ( GAMEMODE.Perks[item].Name, "WeaponNames", (ww/3)/2, 7, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
										
											if GAMEMODE.Perks[item].Material then		
												surface.SetTexture(surface.GetTextureID( GAMEMODE.Perks[item].Material ))	
												local wd,hg = surface.GetTextureSize(surface.GetTextureID( GAMEMODE.Perks[item].Material ))
												local dif = (hh-14)/hg
												surface.SetDrawColor(80,80,80,255)
												surface.DrawTexturedRect( (ww/3)/2-(wd*dif)/2,12, wd*dif, math.Clamp(hg*dif,0,hh) )
											end
										end
									end
								end
								
								if MySelf:IsBlocked( item ) then
									surface.SetDrawColor(255,255,255,255)
									surface.SetMaterial( lock_icon )
									surface.DrawTexturedRect((ww/3)-18,2,16,16)
								end
								
								if MySelf:IsRetroOnly( item ) then
									surface.SetDrawColor(255,255,255,255)
									surface.SetMaterial( heart_icon )
									surface.DrawTexturedRect((ww/3)-18,2,16,16)
								end

							end
						
							Unlocks[num]:AddItem(ItemLabel[item])							
						end-- back
					end
				end
			end
		end
	-- end
	
	

end
-- Loadout
function DrawSlotIcon(x,y,ww,hh,wepclass,parent,num,weptype)
			
	SlotLabel[num] = vgui.Create("DLabel")
	SlotLabel[num]:SetParent( parent )
	SlotLabel[num]:SetText("")
	SlotLabel[num]:SetSkin("ZSMG")
	SlotLabel[num]:SetSize (ww, hh) 
	SlotLabel[num]:SetPos (x, y)
	SlotLabel[num].Item = wepclass
	
	if GAMEMODE:IsRetroMode() then
		if MySelf:IsBlocked(SlotLabel[num].Item) then
			SlotLabel[num]:SetToolTip("Not avalaible in retro mode!")
		end
		if MySelf:IsRetroOnly(SlotLabel[num].Item) then
			SlotLabel[num]:SetToolTip("Avalaible only in retro mode!")
		end
	else
		if IsPerk(SlotLabel[num].Item) then
			SlotLabel[num]:SetToolTip(GAMEMODE.Perks[SlotLabel[num].Item].Description)
		end
	end
	
	SlotLabel[num].OnCursorEntered = function() 
		SlotLabel[num].Overed = true 
		surface.PlaySound ("UI/buttonrollover.wav") 
	end
	SlotLabel[num].OnCursorExited = function () 
		SlotLabel[num].Overed = false
		-- Colors[class].CButton = Color (0,0,0,255) 
		-- Classes[class].Overed = false
	end
	SlotLabel[num].OnMousePressed = function () 
		for i=1, 6 do
			if i == num then
				SlotLabel[i].Active = true 
				
				if not Unlocks[i] then
					DrawContextMenu(x+ww+ScaleH(20),30,TopMenuW-(ww+ScaleH(20)),hh,weptype,InvisiblePanel2,num)
				else
					Unlocks[i]:Remove()
					Unlocks[i] = nil
				end
			else
				SlotLabel[i].Active = false
				if Unlocks[i] then
					Unlocks[i]:Remove()
					Unlocks[i] = nil
				end
			end
		end
		-- 	surface.PlaySound (Sounds.Click) 

	end
	SlotLabel[num].Think = function() 
		-- if IsPerk(SlotLabel[num].Item) then
		-- 	SlotLabel[num]:SetToolTip(GAMEMODE.Perks[SlotLabel[num].Item].Description)
		-- end
		if GAMEMODE:IsRetroMode() then
			if MySelf:IsBlocked(SlotLabel[num].Item) then
				SlotLabel[num]:SetToolTip("Not avalaible in retro mode!")
			elseif MySelf:IsRetroOnly(SlotLabel[num].Item) then
				SlotLabel[num]:SetToolTip("Avalaible only in retro mode!")
			elseif IsPerk(SlotLabel[num].Item) then
				SlotLabel[num]:SetToolTip(GAMEMODE.Perks[SlotLabel[num].Item].Description)
			end
		else
			if IsPerk(SlotLabel[num].Item) then
				SlotLabel[num]:SetToolTip(GAMEMODE.Perks[SlotLabel[num].Item].Description)
			end
		end
	end
	
	SlotLabel[num].Paint = function()
	
		if SlotLabel[num].Overed then
			surface.SetDrawColor( 255, 255, 255, 255)
			surface.DrawOutlinedRect( 0, 0, ww, hh)
			surface.DrawOutlinedRect( 1, 1, ww-2, hh-2 )
		else
			if SlotLabel[num].Active then
				surface.SetDrawColor( 255, 255, 255,( math.sin(RealTime() * 5) * 95 ) + 150 )-- 
				surface.DrawOutlinedRect( 0, 0, ww, hh)
				surface.DrawOutlinedRect( 1, 1, ww-2, hh-2 )
			else
				surface.SetDrawColor( 30, 30, 30, 200 )
				surface.DrawOutlinedRect( 0, 0, ww, hh)
				surface.SetDrawColor( 30, 30, 30, 255 )
				surface.DrawOutlinedRect( 1, 1, ww-2, hh-2 )
			end
		end
		
		if SlotLabel[num].Item == "none" then
			surface.SetDrawColor( 255, 255, 255, 255) 
			draw.SimpleTextOutlined ( "NO ITEM", "WeaponNames", ww/2, hh/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
			return
		end
		
		
		if string.sub(SlotLabel[num].Item, 1, 6) == "weapon" then
		local font, letter = "WeaponSelectedHL2", "0"
		local Table = killicon.GetFont( SlotLabel[num].Item )
				
			if Table then
				letter = Table.letter
					
				if not Table.IsHl2 and not Table.IsZS then
					font = "WeaponSelectedCSS"
				elseif not Table.IsHL2 and Table.IsZS then
					font = "WeaponSelectedZS"
				end
					
			end
				
			if killicon.GetImage( SlotLabel[num].Item ) then
				
				local ImgTable = killicon.GetImage( SlotLabel[num].Item ) 
									

					surface.SetDrawColor( 255, 255, 255, 255) 
					draw.SimpleTextOutlined ( GAMEMODE.HumanWeapons[SlotLabel[num].Item].Name, "WeaponNames", ww/2, 7, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
									
					surface.SetTexture(surface.GetTextureID( ImgTable.mat ))	
					local wd,hg = surface.GetTextureSize(surface.GetTextureID( ImgTable.mat ))
					local clampedH = (ww*hg)/wd
					surface.DrawTexturedRect( 57.5,12, wd, math.Clamp(hg,0,hh) )

				
				else
				
					surface.SetFont ( font )
					local fWide, fTall = surface.GetTextSize ( letter )
					
					surface.SetDrawColor( 255, 255, 255, 255 )
					draw.SimpleTextOutlined ( GAMEMODE.HumanWeapons[SlotLabel[num].Item].Name, "WeaponNames", ww/2, 7, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
						
					
					draw.SimpleTextOutlined ( letter, font, ww/2, 55, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				
				end
			
			
		elseif string.sub(SlotLabel[num].Item, 1, 1) == "_" then
				for perk, desc in pairs(GAMEMODE.Perks) do
					if SlotLabel[num].Item == perk then
						surface.SetDrawColor( 255, 255, 255, 255) 
						draw.SimpleTextOutlined ( GAMEMODE.Perks[SlotLabel[num].Item].Name, "WeaponNames", ww/2, 7, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
						
						if GAMEMODE.Perks[SlotLabel[num].Item].Material then		
							surface.SetTexture(surface.GetTextureID( GAMEMODE.Perks[SlotLabel[num].Item].Material ))	
							local wd,hg = surface.GetTextureSize(surface.GetTextureID( GAMEMODE.Perks[SlotLabel[num].Item].Material ))
							local dif = (hh-14)/hg
							-- local clampedH = (ww*hg)/wd
							surface.SetDrawColor(80,80,80,255)
							surface.DrawTexturedRect( ww/2-(wd*dif)/2,12, wd*dif, math.Clamp(hg*dif,0,hh) )
						end
					end
				end
		end

		if MySelf:IsBlocked( SlotLabel[num].Item ) then
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial( lock_icon )
			surface.DrawTexturedRect(ww-18,2,16,16)
		end
		
		if MySelf:IsRetroOnly( SlotLabel[num].Item ) then
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial( heart_icon )
			surface.DrawTexturedRect(ww-18,2,16,16)
		end
		
	end
end

local DescNames = {"Weapon","Melee","Tool #1","Tool #2","Perk #1","Perk #2"}

function DrawSelectClass()
	
	local filename = "zombiesurvival/loadouts/default.txt"
	if file.Exists (filename,"DATA") then
		local tbl = util.JSONToTable(file.Read(filename))
		if tbl then
			Loadout = table.Copy(tbl)
			for _,v in pairs (Loadout) do
				if not MySelf:HasUnlocked(v) then
					table.remove( Loadout, _ )
					-- Loadout[_] = nil
				end
			end
		else
			Loadout = {"weapon_zs_usp","weapon_zs_melee_keyboard"}
		end
	else
		file.CreateDir("zombiesurvival/loadouts")
		Loadout = {"weapon_zs_usp","weapon_zs_melee_keyboard"}
	end
	
	--Options:
	
	local spawntimer = 40
	local spawntimercd = 0

	TopMenuW,TopMenuH = ScaleW(550), 140 -- ScaleH(136)
	TopMenuX,TopMenuY = w/2-TopMenuW/2,h/5-TopMenuH/1.6

	TopMenuH1 = ScaleH(136)
	
	local BlurMenu = vgui.Create("DFrame")
	BlurMenu:SetSize(TopMenuW,TopMenuH)
	BlurMenu:SetPos(TopMenuX,TopMenuY)
	BlurMenu:SetSkin("ZSMG")
	BlurMenu:SetTitle( "Welcome to the Mr Green's Zombie Survival server!" ) 
	BlurMenu:SetDraggable ( false )
	BlurMenu:SetBackgroundBlur( true )
	BlurMenu:SetSizable(false)
	BlurMenu:SetDraggable(false)
	BlurMenu:ShowCloseButton(false)
	
	local welcomebox = vgui.Create("DTextEntry",BlurMenu)
	welcomebox:SetPos( 5, 25 ) 
	welcomebox:SetSize( TopMenuW-10, TopMenuH-30 ) 
	welcomebox:SetEditable( false )
	welcomebox:SetValue(WELCOME_TEXT)
	welcomebox:SetMultiline( true )
	
	BlurMenu.Think = function ()
		gui.EnableScreenClicker(true)
	end
	
	local InvisiblePanel = vgui.Create("DFrame")
	InvisiblePanel:SetSize(w,h)
	InvisiblePanel:SetPos(0,0)
	InvisiblePanel:SetDraggable ( false )
	InvisiblePanel:SetTitle ("")
	InvisiblePanel:SetSkin("ZSMG")
	InvisiblePanel:ShowCloseButton (false)
	InvisiblePanel.Paint = function() 
		-- override this
	end
	
	LoadoutMenuW,LoadoutMenuH = TopMenuW/4, ScaleH(500)
	-- invisible panel for lists
	InvisiblePanel2 = vgui.Create("DFrame")
	InvisiblePanel2:SetSize(TopMenuW,LoadoutMenuH)
	InvisiblePanel2:SetPos(TopMenuX,TopMenuY+TopMenuH+ScaleH(20))
	InvisiblePanel2:SetDraggable ( false )
	InvisiblePanel2:SetTitle ("")
	InvisiblePanel2:ShowCloseButton (false)
	InvisiblePanel2:SetDraggable ( false )
	InvisiblePanel2:SetSizable(false)
	InvisiblePanel2.Paint = function() 
		-- override this
	end
	
	LoadoutMenu = vgui.Create("DFrame")
	LoadoutMenu:SetSize(LoadoutMenuW,LoadoutMenuH)
	LoadoutMenu:SetPos(TopMenuX,TopMenuY+TopMenuH+ScaleH(20))
	LoadoutMenu:SetSkin("ZSMG")
	LoadoutMenu:SetTitle( "Current Loadout" ) 
	LoadoutMenu:SetDraggable ( false )
	LoadoutMenu:SetSizable(false)
	LoadoutMenu:SetDraggable(false)
	LoadoutMenu:ShowCloseButton(false)
		
	
	-- Long shitty code :<
	local primary,secondary,melee,tool1,tool2,perk,perk2 = "none","none","none","none","none","none","none"
	
	-- Get primary
	for k, v in pairs(Loadout) do
		if IsWeapon(v) then
			if GetWeaponCategory ( v ) == "Automatic" then
				primary = v
				break
			end
		end
	end
	
	-- Get Secondary
	for k, v in pairs(Loadout) do
		if IsWeapon(v) then
			if GetWeaponCategory ( v ) == "Pistol" then
				secondary = v
				break
			end
		end
	end
	
	-- Get Melee
	for k, v in pairs(Loadout) do
		if IsWeapon(v) then
			if GetWeaponCategory ( v ) == "Melee" then
				melee = v
				break
			end
		end
	end
	
	-- Get Tool 1
	for k, v in pairs(Loadout) do
		if IsWeapon(v) then
			if GetWeaponCategory ( v ) == "Tool1" then
				tool1 = v
				break
			end
		end
	end
	
	-- Get Tool 2
	for k, v in pairs(Loadout) do
		if IsWeapon(v) then
			if GetWeaponCategory ( v ) == "Tool2" then
				tool2 = v
				break
			end
		end
	end
	
	-- Get Perk
	for k, v in pairs(Loadout) do
		if IsPerk(v) and GetPerkSlot(v) == 1 then
			perk = v
			break
		end
	end
	
	-- Get Perk2
	for k, v in pairs(Loadout) do
		if IsPerk(v) and GetPerkSlot(v) == 2 then
			perk2 = v
			break
		end
	end
	
	-- And clean table since we dont need yet
	Loadout = {}
	
	local step = 30
	
	-- Rifles and etc
	--[==[DrawSlotIcon(0,step,LoadoutMenuW,(LoadoutMenuH/6)*0.9,primary,LoadoutMenu,1,"Automatic")	
	step = step+(LoadoutMenuH/6)*0.9
	
	DrawSlotIcon(0,step,LoadoutMenuW,(LoadoutMenuH/6)*0.9,secondary,LoadoutMenu,2,"Pistol")
	step = step+(LoadoutMenuH/6)*0.9
	
	DrawSlotIcon(0,step,LoadoutMenuW,(LoadoutMenuH/6)*0.9,melee,LoadoutMenu,3,"Melee")
	step = step+(LoadoutMenuH/6)*0.9
	
	DrawSlotIcon(0,step,LoadoutMenuW,(LoadoutMenuH/6)*0.9,tool1,LoadoutMenu,4,"Tool1")
	step = step+(LoadoutMenuH/6)*0.9
	
	DrawSlotIcon(0,step,LoadoutMenuW,(LoadoutMenuH/6)*0.9,tool2,LoadoutMenu,5,"Tool2")
	step = step+(LoadoutMenuH/6)*0.9
	
	DrawSlotIcon(0,step,LoadoutMenuW,(LoadoutMenuH/6)*0.9,perk,LoadoutMenu,6,"Perk")]==]
	
	DrawSlotIcon(0,step,LoadoutMenuW,(LoadoutMenuH/6)*0.9,secondary,LoadoutMenu,1,"Pistol")	
	step = step+(LoadoutMenuH/6)*0.9
	
	DrawSlotIcon(0,step,LoadoutMenuW,(LoadoutMenuH/6)*0.9,melee,LoadoutMenu,2,"Melee")
	step = step+(LoadoutMenuH/6)*0.9
	
	DrawSlotIcon(0,step,LoadoutMenuW,(LoadoutMenuH/6)*0.9,tool1,LoadoutMenu,3,"Tool1")
	step = step+(LoadoutMenuH/6)*0.9
	
	DrawSlotIcon(0,step,LoadoutMenuW,(LoadoutMenuH/6)*0.9,tool2,LoadoutMenu,4,"Tool2")
	step = step+(LoadoutMenuH/6)*0.9
	
	DrawSlotIcon(0,step,LoadoutMenuW,(LoadoutMenuH/6)*0.9,perk,LoadoutMenu,5,"Perk")
	step = step+(LoadoutMenuH/6)*0.9
	
	DrawSlotIcon(0,step,LoadoutMenuW,(LoadoutMenuH/6)*0.9,perk2,LoadoutMenu,6,"Perk2")
	
	-- Spawn button
	
	SpawnButtonX, SpawnButtonY = TopMenuX,TopMenuY+TopMenuH+ScaleH(20)+LoadoutMenuH+ScaleH(20) -- nice and shiny
	SpawnButtonW, SpawnButtonH = LoadoutMenuW, TopMenuH1/1.1
	
	SpawnButton = vgui.Create("DButton",InvisiblePanel)
	SpawnButton:SetText("")
	SpawnButton:SetPos(SpawnButtonX, SpawnButtonY)
	SpawnButton:SetSize (SpawnButtonW, SpawnButtonH)
	SpawnButton.Think = function () 
		if spawntimercd <= CurTime() then 
			spawntimer = spawntimer - 1
			if spawntimer <= 0 then
				local randomclass = math.random (1,5)
				ChangeClassClient (1)
				BlurMenu:Close()
				InvisiblePanel:Close()
				InvisiblePanel2:Close()
				LoadoutMenu:Close()
				StatsMenu:Close()
			end
			spawntimercd = CurTime() + 1
		end
	end
	
	SpawnButton.PaintOver = function ()
		draw.SimpleTextOutlined("SPAWN ("..( spawntimer )..")" , "ArialBoldTwelve", SpawnButtonW/2, SpawnButtonH/2, Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end
	SpawnButton.DoClick = function ()
		ChangeClassClient (1)
		BlurMenu:Close()
		InvisiblePanel:Close()
		InvisiblePanel2:Close()
		LoadoutMenu:Close()
		StatsMenu:Close()
	end	
	
	-- Stats
	
	StatsX, StatsY = SpawnButtonX+SpawnButtonW+ScaleH(20),SpawnButtonY
	StatsW, StatsH = TopMenuW-(SpawnButtonW+ScaleH(20)), SpawnButtonH
	
	StatsMenu = vgui.Create("DFrame")
	StatsMenu:SetSize(StatsW, StatsH)
	StatsMenu:SetPos(StatsX, StatsY)
	StatsMenu:SetSkin("ZSMG")
	StatsMenu:SetTitle( "Player stats" ) 
	StatsMenu:SetDraggable ( false )
	StatsMenu:SetSizable(false)
	StatsMenu:SetDraggable(false)
	StatsMenu:ShowCloseButton(false)
	
	StatsMenu.PaintOver = function()
		
		local Rank1X,Rank1Y = ScaleW(30),StatsH/2
		local Rank2X,Rank2Y = StatsW-Rank1X,Rank1Y
		
		draw.SimpleTextOutlined(MySelf:GetRank() , "ArialBoldFifteen", Rank1X,Rank1Y, Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		draw.SimpleTextOutlined("rank" , "WeaponNames", Rank1X,Rank1Y+ScaleH(25), Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		draw.SimpleTextOutlined(MySelf:GetRank()+1 , "ArialBoldFifteen", Rank2X,Rank2Y, Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		draw.SimpleTextOutlined("rank" , "WeaponNames", Rank2X,Rank2Y+ScaleH(25), Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		
		-- Progress bar
		
		local BarW,BarH = StatsW*0.7,StatsH*.3
		local BarX,BarY = StatsW/2-BarW/2,StatsH/2-BarH/2
		
		surface.SetDrawColor( 0, 0, 0, 150)
		surface.DrawRect(BarX,BarY, BarW,BarH )
	
		surface.DrawRect(BarX+5 , BarY+5,  BarW-10, BarH-10 )	
		
		local full = MySelf:NextRankXP() - MySelf:CurRankXP()
		local actual = MySelf:GetXP()- MySelf:CurRankXP()
		
		if MySelf:GetRank() == 0 then
			full = 3000
			actual = MySelf:GetXP()
		end
				
		local rel = math.Clamp(actual/full,0,1)
		
		surface.SetDrawColor(Color(255,255,255,255))
		surface.DrawRect(BarX+5 , BarY+5, (rel)*(BarW-10), BarH-10 )
		
		draw.SimpleTextOutlined("Experience: "..actual.."/"..full , "WeaponNames", StatsW/2,Rank2Y+ScaleH(25), Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		-- draw.SimpleTextOutlined("Total experience: "..MySelf:GetXP().."/"..MySelf:NextRankXP() , "WeaponNames", StatsW/2,Rank2Y+ScaleH(40), Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	
		-- 
		-- surface.DrawRect(ActualX+5 , ActualY+5, (HPBarSizeW-10)*MySelf.HPBar, HPBarSizeH-10 )
	
	end
	
end

function ChangeClassClient ( class )
	gui.EnableScreenClicker(false)
	
	local filename = "zombiesurvival/loadouts/default.txt"
	
	if SlotLabel then
		for i=1,6 do
			if SlotLabel[i] and SlotLabel[i].Item and SlotLabel[i].Item ~= "none" then
				table.insert(Loadout,SlotLabel[i].Item)
			end
		end
	end
	
	local tbl = util.TableToJSON(Loadout)
	file.Write(filename,tbl)
	
	RunConsoleCommand ("_applyloadout",unpack(Loadout))
	
	RunConsoleCommand("ChangeClass", class)
	
	if not FIRSTAPRIL then
	-- RunConsoleCommand ("stopsounds")
	end
end
usermessage.Hook("DrawSelectClass", DrawNewSelectClass2) 
-- concommand.Add("open_testmenu",DrawNewSelectClass2)

-- Include unlock draw effect too
local UnlockStack = 0
local UnlockTime = 0

function DrawUnlock()
	endX = w/2-200
	endY = h/2-150
	textEndX = w/2-90
	textEndY = h/2-150
	
	UnlockAlpha = achievAlpha or 255
	UnlockX = UnlockX or {}
	UnlockY = UnlockY or {}
	UnlockX[1] = UnlockX[1] or endX-w -- four text location
	UnlockY[1] = UnlockY[1] or endY
	UnlockX[2] = UnlockX[2] or endX+w
	UnlockY[2] = UnlockY[2] or endY
	UnlockX[3] = UnlockX[3] or endX
	UnlockY[3] = UnlockY[3] or endY-h
	UnlockX[4] = UnlockX[4] or endX
	UnlockY[4] = UnlockY[4] or endY+h
	UnlockX[5] = UnlockX[5] or endX-w -- image location
	UnlockY[5] = UnlockY[5] or endY	
	
	local rand = 0
	local rand2 = 0	
	
	col = Color(255,255,255,UnlockAlpha)
	col2 = Color(0,0,0,UnlockAlpha)
	
	for k=1, 4 do
		rand = -2+math.Rand(0,4)
		rand2 = -2+math.Rand(0,4)
		col = Color(220,10,10,UnlockAlpha/1.5)
		if k == 4 then 
			col = Color(255,255,255,UnlockAlpha)
			rand = 0 
			rand2 = 0 
		end
		draw.SimpleTextOutlined(UnlockType.." Unlocked!","ArialBoldTen",UnlockX[k]+rand,UnlockY[k]+rand2,col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, col2)
		draw.SimpleTextOutlined(UnlockName,"ArialBoldFifteen",UnlockX[k]+rand,UnlockY[k]+30+rand2,col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, col2)
		-- draw.DrawText("Achievement Unlocked!","HUDFontSmaller",achievX[k]+rand,achievY[k]+rand2,col, TEXT_ALIGN_CENTER)
		-- draw.DrawText(achievName,"HUDFontSmall",achievX[k]+rand,achievY[k]+20+rand2,col, TEXT_ALIGN_CENTER)
	end
	
	col = Color(255,255,255,UnlockAlpha)
	
	-- surface.SetTexture( achievImage )
	-- surface.SetDrawColor( col )
	-- surface.DrawTexturedRect( achievX[5], achievY[5],100,100 )
	
	for k=1,4 do
		UnlockX[k] = math.Approach(UnlockX[k], textEndX, w*3*FrameTime())
		UnlockY[k] = math.Approach(UnlockY[k], textEndY, h*3*FrameTime())
	end
	UnlockX[5] = math.Approach(UnlockX[5], endX, w*3*FrameTime())
	UnlockY[5] = math.Approach(UnlockY[5], endY, h*3*FrameTime())	
	
	if (UnlockTime < CurTime()+1) then
		UnlockAlpha = math.Approach(UnlockAlpha, 0, 255*FrameTime())
	end
	
	if (UnlockTime < CurTime()) then
		hook.Remove("HUDPaint","DrawUnlock")
		for k=1, 5 do
			UnlockX[k] = nil
			UnlockY[k] = nil
			UnlockAlpha = nil
		end
	end
end

function UnlockEffect2( Unlock )
	UnlockStack = UnlockStack+1
	if UnlockTime < CurTime() then
		
		
		UnlockStack = UnlockStack-1
		UnlockName = "I am error"
		UnlockType = "Error"
		if IsWeapon(Unlock) then
			UnlockName = GAMEMODE.HumanWeapons[Unlock].Name
			UnlockType = "Weapon"
		elseif IsPerk(Unlock) then
			UnlockName = GAMEMODE.Perks[Unlock].Name
			UnlockType = "Perk"
		end
		
		-- UnlockImage = surface.GetTextureID(achievementDesc[statID].Image)
		UnlockTime = CurTime()+4
		
		-- surface.PlaySound("physics/metal/sawblade_stick"..math.random(1,3)..".wav")
		surface.PlaySound("ambient/levels/citadel/pod_close1.wav")
		
		hook.Add("HUDPaint","DrawUnlock",DrawUnlock)
	else
		timer.Simple((UnlockTime-CurTime()+0.2)+5*(UnlockStack-1),function( str ) 
			UnlockEffect2(str) 
			UnlockStack = UnlockStack-1
		end,Unlock) -- Achievement display delays
	end
end
	
function LateSpawnLoadout()

	Loadout = Loadout or {}
	
	local filename = "zombiesurvival/loadouts/default.txt"
	if file.Exists (filename,"DATA") then
		local tbl = util.JSONToTable(file.Read(filename))
		if tbl then
			Loadout = table.Copy(tbl)
			for _,v in pairs (Loadout) do
				if not MySelf:HasUnlocked(v) then
					table.remove( Loadout, _ )
					-- Loadout[_] = nil
				end
			end
		else
			Loadout = {"weapon_zs_usp","weapon_zs_melee_keyboard"}
		end
	else
		Loadout = {"weapon_zs_usp","weapon_zs_melee_keyboard"}
	end
	
	print("Resending loadout")
	PrintTable(Loadout)
	
	RunConsoleCommand ("_applyloadout",unpack(Loadout))
	
end