-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local LoadoutOpen = false
local spawned = false

local frameSizeWidth = ScrW()*0.75
local frameSizeHeight = ScrH()*0.75

local buttonWidth = ScrW()*0.125
local buttonHeight = ScrH()*0.06	

local Classes = { Class = {}, Perk1 = {}, Perk2 = {}, Perk3 = {}, Perk4 = {} }

local classSelected = "Medic"

buttonPerks = {}

buttonClass = {}

perkButtons = {}

Loadout = {}

local Frame = vgui.Create( "DFrame" )
Frame:SetVisible( false )

function updateSelectedClass(classSelected)
	local filename = "zombiesurvival/loadouts/".. classSelected ..".txt"
	local Loadout = {}
	if file.Exists(filename,"DATA") then
		local tbl = util.JSONToTable(file.Read(filename))
		if tbl then
			Loadout = table.Copy(tbl)
			for _,v in pairs(Loadout) do
				if not MySelf:HasUnlocked(v) then
					table.remove(Loadout, _)
				else

					for i,j in pairs(perkButtons[0]) do
						if (j.CodeName == v) then
							j.Active = true
						end
					end
					
					for i,j in pairs(perkButtons[1]) do
						if (j.CodeName == v) then
							j.Active = true
						end
					end

					for i,j in pairs(perkButtons[2]) do
						if (j.CodeName == v) then
							j.Active = true
						end
					end

					for i,j in pairs(perkButtons[3]) do
						if (j.CodeName == v) then
							j.Active = true
						end
					end				
				end
			end
		end
	end	
end


spawnMusic = {"hl1_song14.mp3","hl1_song19.mp3","hl1_song24.mp3","hl1_song26.mp3","hl1_song5.mp3"}
local menuTimeOpened
local spawnInstantly = false
function DrawLoadoutMenu()
	
	menuTimeOpened = CurTime()
	
	MySelf:ConCommand("tooltip_delay 0") 
	MySelf:ConCommand("r_dynamic 0")
	MySelf:ConCommand("r_PhysPropStaticLighting 0")

	local filename = "zombiesurvival/loadouts/chosenClass.txt"
	
	if file.Exists(filename,"DATA") then
		classSelected = file.Read(filename)
	end
	
	--updateSelectedClass(classSelected)
	
	Frame:SetPos( ScrW()*0.5 - (frameSizeWidth/2), ScrH()*0.5 - (frameSizeHeight/2) )
	Frame:SetSize( frameSizeWidth, frameSizeHeight )
	Frame:SetVisible( true )
	Frame:SetText( "" )	
	Frame:SetTitle( "" )	
	Frame:SetDraggable( false )
	Frame:ShowCloseButton( false )
	Frame:SetSkin("ZSMG")	
	Frame:MakePopup()
	
	Frame.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 35, 30, 230 ) )
	end
	
	Frame.Think = function () 
		if WARMUPTIME - CurTime() <= 0 then
			Frame:Close()
			spawned = true
			saveClass(classSelected, perkButtons)				
		end
	end		
	
	local FrameDescription = vgui.Create("DTextEntry",Frame)
	FrameDescription:SetPos( frameSizeWidth * 0.585, frameSizeHeight*0.435 ) 
	FrameDescription:SetSize( frameSizeWidth * 0.4, frameSizeHeight * 0.2 ) 
	FrameDescription:SetEditable( false )
	FrameDescription:SetValue("")
	FrameDescription:SetFont("Trebuchet18")
	FrameDescription:SetMultiline( true )	

	local frameDescriptionText = ""
	
	FrameDescription.PaintOver = function ()
		draw.DrawText(" " .. frameDescriptionText, "Trebuchet24", 0, 0, Color(248,253,248,235), TEXT_ALIGN_LEFT)		
	end	
	
	local ProfileText = vgui.Create("DTextEntry",Frame)
	ProfileText:SetPos( frameSizeWidth * 0.585, frameSizeHeight*0.34 )
	ProfileText:SetSize( frameSizeWidth * 0.4, frameSizeHeight * 0.09 ) 
	ProfileText:SetEditable( false )
	ProfileText:SetValue("")
	ProfileText.PaintOver = function ()
		draw.SimpleText("GreenCoins: " .. MySelf:GreenCoins() .. " | Rank " .. MySelf:GetRank()  .. " | " ..  MySelf:NextRankXP() - MySelf:GetXP() .. " XP Remaining","Trebuchet18", ScaleW(60), ScaleH(22), Color(248,253,248,235), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)				
	end
	

	ProfileText:SetFont("Trebuchet24")
	ProfileText:SetMultiline( false )		
		
	local Avatar = vgui.Create( "AvatarImage", ProfileText )
	Avatar:SetSize( frameSizeHeight*0.0875, frameSizeHeight*0.0875 )
	Avatar:SetPos( 0, 0 )
	Avatar:SetPlayer( LocalPlayer(), 64)
	
	local FrameText = vgui.Create("DTextEntry",Frame)
	FrameText:SetPos( frameSizeWidth * 0.585, frameSizeHeight*0.64 ) 
	FrameText:SetSize( frameSizeWidth * 0.4, frameSizeHeight * 0.32 ) 
	FrameText:SetEditable( false )
	FrameText:SetValue("")
	FrameText:SetFont("Trebuchet18")
	FrameText:SetMultiline( true )	
	
	FrameText.PaintOver = function ()
		draw.DrawText(" [DOUBLE XP ACTIVATED]\n Welcome to the new class selection menu!\n Report any bugs/issues or post suggestions on the forums.", "Trebuchet18", 0, 0, Color(248,253,248,235), TEXT_ALIGN_LEFT)
	end	
	
	local buttonWeb = vgui.Create( "DButton", Frame)
	
	buttonWeb:SetPos( frameSizeWidth*0.87, frameSizeHeight - buttonHeight * 1.33)
	buttonWeb:SetSize( frameSizeWidth * 0.11, frameSizeHeight * 0.06 ) 	
	buttonWeb:SetText("")
	buttonWeb:SetTextColor( Color( 95, 240, 110, 255 ) )
	buttonWeb.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 35, 29, 240 ) )
	end		
	
	buttonWeb.PaintOver = function ()
	end	
	
	buttonWeb.OnCursorEntered = function() 
		buttonWeb.Overed = true
		surface.PlaySound(Sound("mrgreen/ui/menu_focus.wav"))
	end
	
	buttonWeb.OnCursorExited = function() 
		buttonWeb.Overed = false
	end		
	
	buttonWeb.DoClick = function()
		surface.PlaySound(Sound("mrgreen/ui/menu_accept.wav"))
		gui.OpenURL( "http://mrgreengaming.com/forums/forum/13-zombie-survival/" )
	end
	
	buttonWeb.PaintOver = function ()
	
		draw.DrawText("Forums", "Trebuchet24", (frameSizeWidth * 0.11) * 0.5, ScaleH(12),  Color( 95, 240, 110, 255 ), TEXT_ALIGN_CENTER)	
		
		if buttonWeb.Overed then
			surface.SetDrawColor(50, 255, 60, math.Clamp(math.sin(CurTime()*5)*100 + 100,40,255))
			surface.DrawOutlinedRect(0, 0, frameSizeWidth * 0.11, frameSizeHeight * 0.06)
		end
	end	
	
	LoadoutOpen = true
			
	for k, v in pairs(GAMEMODE.Perks) do
	
		GAMEMODE.Perks[k].CodeName = k

		if (v.Slot == 5) then
			table.insert(Classes.Class,v)		
		elseif (v.Slot == 1) then
			table.insert(Classes.Perk1,v)		
		elseif (v.Slot == 2) then
			table.insert(Classes.Perk2,v)		
		elseif (v.Slot == 3) then
			table.insert(Classes.Perk3,v)		
		elseif (v.Slot == 4) then
			table.insert(Classes.Perk4,v)		
		end				
	end
	
	local buttonClassX = ScrW()*0.1
	local buttonClassY = ScrH()*0.1
	local buttonClassWidth = ScrW()*0.1
	local buttonClassHeight = buttonClassWidth
	
	perkButtons[0] = drawPerks(Perk1,frameSizeHeight*0.34, 6)
	perkButtons[1] = drawPerks(Perk2,frameSizeHeight*0.34 + (buttonClassHeight*0.70), 6)	
	perkButtons[2] = drawPerks(Perk3,frameSizeHeight*0.34 + (buttonClassHeight*1.40), 6)	
	perkButtons[3] = drawPerks(Perk4,frameSizeHeight*0.34 + (buttonClassHeight*2.10), 6)		

	for k, v in pairs(Classes.Class) do

		for i, j in pairs (v.Coef) do
			v.Coef[i] = j * MySelf:GetRank()			
		end
		
		buttonClass[k] = vgui.Create( "DButton", Frame )	
		buttonClass[k]:SetParent(Frame)		
		buttonClass[k]:SetText( "" )		
		buttonClass[k]:SetTextColor( Color( 255, 255, 255 ) )
		buttonClass[k]:SetPos( frameSizeWidth*0.035 + ((k-1)*(buttonClassWidth)), frameSizeHeight*0.03)
		buttonClass[k]:SetSize( buttonClassWidth, buttonClassHeight)
		buttonClass[k]:SetTooltip(v.Name .. "\n\n [BASE PERKS]\n" .. v.Description .. "\n\n [BONUS PERKS]\n" .. string.format(v.CoefDesc,unpack( v.Coef )))		
		
		buttonClass[k].Paint = function( self, w, h )	
			draw.RoundedBox( 0, 0, 0, w, h, v.Colour )
		end	
		
		local icon = vgui.Create( "DModelPanel", buttonClass[k] )

		icon:SetDirectionalLight( BOX_TOP, v.Colour )
		icon:SetDirectionalLight( BOX_FRONT, v.Colour )		
		icon:SetSize( buttonClassWidth, buttonClassHeight )
		icon:SetAmbientLight( v.Colour )
		icon:SetModel( v.Model )
		icon:SetFOV(75)
		local eyepos = icon.Entity:GetBonePosition( icon.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )

		eyepos:Add(Vector( 0, 0, 2 ))
		icon:SetLookAt( eyepos )
		icon:SetCamPos( eyepos-Vector( -17, 0, 0 ) )
		icon.Entity:SetEyeTarget( eyepos-Vector( 0, 0, 0 ) )			

		icon.OnCursorEntered = function() 
			buttonClass[k]:OnCursorEntered()
		end	
		
		function icon:LayoutEntity( Entity ) return end -- disables default rotation

		icon.OnCursorExited = function() 
			buttonClass[k]:OnCursorExited()
		end					

		icon.DoClick = function() 
			buttonClass[k]:DoClick()
		end					
		
		if (classSelected == v.Name) then
			buttonClass[k].Active = true	
		
			surface.PlaySound(Sound("mrgreen/ui/menu_accept.wav"))
			
			for k, v in pairs(perkButtons) do
				for i, j in pairs (v) do
					j.Disabled = true
					j.Overed = false
					j.Active = false	
					j.Perk = null
					j.CodeName = null
					j.PerkItem = null
					j:SetTooltip(nil)	
					j:SetImage(null)	
				end
			end
			
			for k,v in pairs(Classes.Perk1) do
				if (v.Class == classSelected) then
					insertPerk(v, perkButtons[0])
				end	
			end
			
			for k,v in pairs(Classes.Perk2) do
				if (v.Class == classSelected) then
					insertPerk(v, perkButtons[1])
				end	
			end
			
			for k,v in pairs(Classes.Perk3) do
				if (v.Class == classSelected) then
					insertPerk(v, perkButtons[2])
				end	
			end
			
			for k,v in pairs(Classes.Perk4) do
				insertPerk(v, perkButtons[3])
			end		
			
			updateSelectedClass(classSelected)			
		end
		
		buttonClass[k].PaintOver = function ()
		
			if buttonClass[k].Overed and not buttonClass[k].Active then
				surface.SetDrawColor(200, 200, 50, math.Clamp(math.sin(CurTime()*5)*100 + 100,40,255))
				surface.DrawOutlinedRect(0, 0, buttonClassWidth, buttonClassHeight)

			elseif buttonClass[k].Active then
				surface.SetDrawColor(50, 255, 50, math.Clamp(math.sin(CurTime()*5)*100 + 150,40,255))
				surface.DrawOutlinedRect( 0, 0, buttonClassWidth, buttonClassHeight)
				frameDescriptionText = "Equipment: " .. v.Equipment
			end
		end
		
		buttonClass[k].DoClick = function ()
		
			for k, v in pairs(Classes.Class) do
				buttonClass[k].Active = false
			end		
			
			buttonClass[k].Active = true
			surface.PlaySound(Sound("mrgreen/ui/menu_accept.wav"))
			classSelected = v.Name		
			
			for k, v in pairs(perkButtons) do
				for i, j in pairs (v) do
					j.Disabled = true
					j.Overed = false
					j.Active = false	
					j.Perk = null
					j.CodeName = null
					j.PerkItem = null
					j:SetTooltip(nil)	
					j:SetImage(null)	
				end
			end
			
			for k,v in pairs(Classes.Perk1) do
				if (v.Class == classSelected) then
					insertPerk(v, perkButtons[0])
				end	
			end
			
			for k,v in pairs(Classes.Perk2) do
				if (v.Class == classSelected) then
					insertPerk(v, perkButtons[1])
				end	
			end
			
			for k,v in pairs(Classes.Perk3) do
				if (v.Class == classSelected) then
					insertPerk(v, perkButtons[2])
				end	
			end
			
			for k,v in pairs(Classes.Perk4) do
				insertPerk(v, perkButtons[3])
			end		
			
			updateSelectedClass(classSelected)
			
		end		
		
		buttonClass[k].OnCursorEntered = function() 
			buttonClass[k].Overed = true 		
			surface.PlaySound(Sound("mrgreen/ui/menu_focus.wav"))
		end

		buttonClass[k].OnCursorExited = function () 
			buttonClass[k].Overed = false				
		end		
	
	end	
	
	classTitle = vgui.Create("DLabel", Frame)
	classTitle:SetParent(Frame)
	classTitle:SetText("")
	classTitle:SetSize(frameSizeWidth, buttonHeight*0.55) 
	classTitle:SetPos(0, frameSizeHeight*0.267)		

	classTitle.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 90, 110, 90, 40 ) )
	end	
	
	classTitle.PaintOver = function ()
		draw.SimpleTextOutlined(" " .. classSelected, "ssNewAmmoFont9", 0, (buttonHeight*0.5)*0.25, Color (255,255,255,220), TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT,1,Color(0,0,0,230))
	end
	
	local buttonSpawn = vgui.Create( "DButton", Frame)
	
	buttonSpawn:SetParent(Frame)
	buttonSpawn:SetSkin("ZSMG")		
	buttonSpawn:SetText( "" )		
	buttonSpawn:SetTextColor( Color( 255, 255, 255 ) )
	buttonSpawn:SetPos( frameSizeWidth*0.5 - buttonWidth*0.51, frameSizeHeight - buttonHeight * 1.5)
	buttonSpawn:SetSize( buttonWidth, buttonHeight )
	buttonSpawn.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 60, 65, 60, 220 ) )
	end	
	
	buttonSpawn.PaintOver = function ()
		draw.SimpleTextOutlined("Spawn ".. math.Round(WARMUPTIME-5 - CurTime()), "Trebuchet24", buttonWidth/2, buttonHeight/2, Color (250,255,250,230), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,230))
		if buttonSpawn.Overed then
			surface.SetDrawColor(50, 255, 60, math.Clamp(math.sin(CurTime()*12)*100 + 100,40,255))
		else	
			surface.SetDrawColor(200, 200, 50, math.Clamp(math.sin(CurTime()*6)*200 + 100,0,255))
		end
		surface.DrawOutlinedRect(0, 0, buttonWidth, buttonHeight)
	end
	
	
	buttonSpawn.OnCursorEntered = function() 
		surface.PlaySound(Sound("mrgreen/ui/menu_focus.wav"))
		buttonSpawn.Overed = true
	end	
	
	buttonSpawn.OnCursorExited = function() 
		buttonSpawn.Overed = false
	end		
	
	buttonSpawn.DoClick = function ()
		Frame:Close()
		spawned = true
		saveClass(classSelected, perkButtons)		
		surface.PlaySound(Sound("mrgreen/ui/menu_accept.wav"))		
		
		local ENABLE_MUSIC = util.tobool(GetConVarNumber("_zs_ambientmusic"))
		if ENABLE_MUSIC then
			surface.PlaySound("music/" .. table.Random(spawnMusic))
		end
	end
	
	buttonSpawn.Think = function () 
		if WARMUPTIME-10 - CurTime() <= 0 then
			Frame:Close()
			spawned = true
			saveClass(classSelected, perkButtons)				
		end
	end	

end

function insertPerk(Perk, PerkButton)
	for k, v in pairs(PerkButton) do
		if (v.Disabled) then
			v.Perk = Perk
			v.Disabled = false
			v:SetTooltip(Perk.Name .. "\n" .. Perk.Description)	
			v.Material = Perk.Material
			v.Rank = Perk.Rank
			v.CodeName = Perk.CodeName
			return
		end
	end
end

function drawPerks(Perk, y, numPerks)	
	Perk = {}
		
	local buttonPerkWidth = ScrW()*0.05
	local buttonPerkHeight = buttonPerkWidth

	for i = 1, numPerks do

		Perk[i] = vgui.Create( "DButton", Frame )
		Perk[i]:SetParent(Frame)		
		Perk[i]:SetText( "" )		
		Perk[i]:SetTextColor( Color( 255, 255, 255 ) )
		
		Perk[i]:SetPos( frameSizeWidth*0.035 + ((i-1)*(buttonPerkWidth*1.05)), y)
		Perk[i]:SetSize( buttonPerkWidth, buttonPerkHeight )	
		
		Perk[i].Disabled = true
		Perk[i].Overed = false
		Perk[i].Active = false	
		Perk[i].Perk = null
		Perk[i].CodeName = null
		Perk[i].PerkItem = null
		Perk[i]:SetTooltip(nil)	
		Perk[i]:SetImage(null)	
		
		Perk[i].Paint = function( self, w, h )
			if Perk[i].Disabled then return end
			draw.RoundedBox( 0, 0, 0, w, h, Color( 110, 90, 90, 100 ) )
		end	

		Perk[i].PaintOver = function ()
		
			if Perk[i].Disabled then return end
				
				if (Perk[i].Material != nil && Perk[i].Material != "") then
					local texture = surface.GetTextureID(Perk[i].Material)
					surface.SetTexture(texture)
					surface.DrawTexturedRect(0,0, buttonPerkWidth, buttonPerkHeight)
				end
					
				if (MySelf:GetRank() < Perk[i].Rank) then 
					surface.SetDrawColor(255, 50, 50,math.Clamp(math.sin(CurTime()*3)*100 + 20,40,255))
					surface.DrawRect(0, 0, buttonPerkWidth, buttonPerkHeight)	
					Perk[i]:SetTooltip("[UNLOCKED AT RANK " .. Perk[i].Rank .. "]\n" ..  Perk[i].Perk.Name .. "\n" .. Perk[i].Perk.Description)						
					return
				end		
								
			if Perk[i].Overed and not Perk[i].Active then
				surface.SetDrawColor(255, 255, 50, math.Clamp(math.sin(CurTime()*3)*100 + 20,40,255))
				surface.DrawRect(0, 0, buttonPerkWidth, buttonPerkHeight)

			elseif Perk[i].Active then
				surface.SetDrawColor(50, 255, 50, math.Clamp(math.sin(CurTime()*3)*100 + 20,40,255))
				surface.DrawRect( 0, 0, buttonPerkWidth, buttonPerkHeight)
			end		
		end
	
		Perk[i].DoClick = function ()
			if Perk[i].Disabled then return end
			
			if (MySelf:GetRank() < Perk[i].Rank) then 				
				return
			end					
			
			for j = 1, numPerks do
				Perk[j].Active = false
			end		
			
			Perk[i].Active = true
			surface.PlaySound(Sound("mrgreen/ui/menu_accept.wav"))
			--selectClass(v, Frame)
			
		end		
		
		Perk[i].OnCursorEntered = function() 
			if Perk[i].Disabled then return end
			
			Perk[i].Overed = true 		
			surface.PlaySound(Sound("mrgreen/ui/menu_focus.wav"))
		end

		Perk[i].OnCursorExited = function () 
			if Perk[i].Disabled then return end		
			Perk[i].Overed = false				
		end			
	end	
	
	return Perk
	
end

--[[
	if SlotLabel then
		for i=1,6 do
			if SlotLabel[i] and SlotLabel[i].Item and SlotLabel[i].Item ~= "none" then
				table.insert(Loadout, SlotLabel[i].Item)
			end
		end
	end]]--

function saveClass(class, perkButtons)

    local selectedPerks = {}
	
	for k, v in pairs(perkButtons) do
		for i, j in pairs (v) do
			if (j.Active) then
				table.insert(selectedPerks,j.Perk.CodeName)
			end
		end
	end

	table.insert(selectedPerks,class)	
	
	local filename = "zombiesurvival/loadouts/".. class .. ".txt"
	
	local tbl = util.TableToJSON(selectedPerks)
	
	file.Write(filename,tbl)

	local filename = "zombiesurvival/loadouts/chosenClass.txt"
	file.Write(filename, classSelected)
	
	RunConsoleCommand("_applyloadout",unpack(selectedPerks))
	
	RunConsoleCommand("ChangeClass", 1)

	-- Only one call after choosing loadout
	gamemode.Call("PostPlayerChooseLoadout", MySelf)
end
	
function IsLoadoutOpen()
	return LoadoutOpen
end
