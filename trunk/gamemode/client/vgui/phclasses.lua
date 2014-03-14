-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- -- -- -- -- -- -- -- -- -- /
-- New window WIP-- 
-- -- -- -- -- -- -- -- -- -- 
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

local achstat1
local achstat2

Loadout = Loadout or {}

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
	if not wep or not IsPerk(wep) then
		return
	end
	
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

						local sItemType = GetWeaponCategory(item)

						--Work-around for primary weapons
						if sItemType == "Automatic" then
							sItemType = "Pistol"
						end

						if IsWeapon(item) and sItemType == weptype then
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
									draw.SimpleTextOutlined( "NO ITEM", "WeaponNames", (ww/3)/2, hh/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
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
																							
											surface.SetTexture(surface.GetTextureID( ImgTable.mat ))	
											local wd,hg = surface.GetTextureSize(surface.GetTextureID( ImgTable.mat ))
											local clampedH = (ww/3*hg)/wd
											surface.DrawTexturedRect( 57.5,12, wd, math.Clamp(hg,0,hh) )-- surface.DrawTexturedRect( x + 57.5,y + 12, wd, clampedH )

											--Draw label
											draw.SimpleTextOutlined ( GAMEMODE.HumanWeapons[item].Name, "WeaponNames", (ww/3)/2, 7, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))										
										else
										
											surface.SetFont ( font )
											local fWide, fTall = surface.GetTextSize ( letter )

											surface.SetDrawColor( 255, 255, 255, 255 )
											
											draw.SimpleTextOutlined ( letter, font, (ww/3)/2, 55, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))

											--Draw label
											draw.SimpleTextOutlined ( GAMEMODE.HumanWeapons[item].Name, "WeaponNames", (ww/3)/2, 7, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
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
										ItemLabel[item]:SetToolTip("Not available in retro mode!")
									elseif MySelf:IsRetroOnly(item) then
										ItemLabel[item]:SetToolTip("Available only in retro mode!")
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
											if GAMEMODE.Perks[item].Material then		
												surface.SetTexture(surface.GetTextureID( GAMEMODE.Perks[item].Material ))	
												local wd,hg = surface.GetTextureSize(surface.GetTextureID( GAMEMODE.Perks[item].Material ))
												local dif = (hh-14)/hg
												surface.SetDrawColor(80,80,80,255)
												surface.DrawTexturedRect( (ww/3)/2-(wd*dif)/2,12, wd*dif, math.Clamp(hg*dif,0,hh) )
											end

											surface.SetDrawColor( 255, 255, 255, 255) 
											draw.SimpleTextOutlined ( GAMEMODE.Perks[item].Name, "WeaponNames", (ww/3)/2, 7, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
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
			SlotLabel[num]:SetToolTip("Not available in retro mode!")
		end
		if MySelf:IsRetroOnly(SlotLabel[num].Item) then
			SlotLabel[num]:SetToolTip("Available only in retro mode!")
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
	end
	SlotLabel[num].Think = function() 
		-- if IsPerk(SlotLabel[num].Item) then
		-- 	SlotLabel[num]:SetToolTip(GAMEMODE.Perks[SlotLabel[num].Item].Description)
		-- end
		if GAMEMODE:IsRetroMode() then
			if MySelf:IsBlocked(SlotLabel[num].Item) then
				SlotLabel[num]:SetToolTip("Not available in retro mode!")
			elseif MySelf:IsRetroOnly(SlotLabel[num].Item) then
				SlotLabel[num]:SetToolTip("Available only in retro mode!")
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
			draw.SimpleTextOutlined( "NO ITEM", "WeaponNames", ww/2, hh/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
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
									
					surface.SetTexture(surface.GetTextureID( ImgTable.mat ))	
					local wd,hg = surface.GetTextureSize(surface.GetTextureID( ImgTable.mat ))
					local clampedH = (ww*hg)/wd
					surface.DrawTexturedRect( 57.5,12, wd, math.Clamp(hg,0,hh) )

					--Draw label
					draw.SimpleTextOutlined ( GAMEMODE.HumanWeapons[SlotLabel[num].Item].Name, "WeaponNames", ww/2, 7, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				else
				
					surface.SetFont ( font )
					local fWide, fTall = surface.GetTextSize ( letter )
					
					surface.SetDrawColor( 255, 255, 255, 255 )						
					
					draw.SimpleTextOutlined ( letter, font, ww/2, 55, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))

					--Draw label
					draw.SimpleTextOutlined ( GAMEMODE.HumanWeapons[SlotLabel[num].Item].Name, "WeaponNames", ww/2, 7, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))				
				end
			
			
		elseif string.sub(SlotLabel[num].Item, 1, 1) == "_" then
				for perk, desc in pairs(GAMEMODE.Perks) do
					if SlotLabel[num].Item == perk then
						if GAMEMODE.Perks[SlotLabel[num].Item].Material then		
							surface.SetTexture(surface.GetTextureID( GAMEMODE.Perks[SlotLabel[num].Item].Material ))	
							local wd,hg = surface.GetTextureSize(surface.GetTextureID( GAMEMODE.Perks[SlotLabel[num].Item].Material ))
							local dif = (hh-14)/hg
							-- local clampedH = (ww*hg)/wd
							surface.SetDrawColor(80,80,80,255)
							surface.DrawTexturedRect( ww/2-(wd*dif)/2,12, wd*dif, math.Clamp(hg*dif,0,hh) )
						end

						--Draw label
						surface.SetDrawColor( 255, 255, 255, 255) 
						draw.SimpleTextOutlined ( GAMEMODE.Perks[SlotLabel[num].Item].Name, "WeaponNames", ww/2, 7, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
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
	BlurMenu:SetTitle( "Mr. Green Zombie Survival" ) 
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
				secondary = v
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

	--Play spawnscreen sound
	local randSong = math.random(2,3)

	--If christmas play xmas sound first and then the normal one
	if CHRISTMAS then
		surface.PlaySound("mrgreen/music/gamestart_xmas.mp3")
		timer.Simple(22, function()
			surface.PlaySound("mrgreen/music/gamestart".. randSong ..".mp3")
		end)
	else
		surface.PlaySound("mrgreen/music/gamestart".. randSong ..".mp3")
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
	
	-- Only one call after choosing loadout
	gamemode.Call( "PostPlayerChooseLoadout", MySelf )
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
		draw.SimpleTextOutlined(UnlockType.." unlocked!","ArialBoldTen",UnlockX[k]+rand,UnlockY[k]+rand2,col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, col2)
		draw.SimpleTextOutlined(UnlockName,"ArialBoldFifteen",UnlockX[k]+rand,UnlockY[k]+30+rand2,col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, col2)
	end
	
	col = Color(255,255,255,UnlockAlpha)
	
	--[[surface.SetTexture( achievImage )
	surface.SetDrawColor( col )
	surface.DrawTexturedRect( achievX[5], achievY[5],100,100 )]]
	
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
	
	--[[print("Resending loadout")
	PrintTable(Loadout)]]
	
	RunConsoleCommand ("_applyloadout",unpack(Loadout))
end