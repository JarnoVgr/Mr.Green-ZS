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
local spawntimer = 50
SpawnButtons.ColorUsual = Color(1,1,1,180)
SpawnButtons.ColorUsualOver = Color(200,200,200,255)
SpawnButtons.ColorUsualBack = Color(0,0,0,255)

SpawnButtons.ColorRandom = Color(1,1,1,180)
SpawnButtons.ColorRandomOver = Color(200,200,200,255)
SpawnButtons.ColorRandomBack = Color(0,0,0,255)

Loadout = Loadout or {}


local function IsWeapon(wep)
	if not wep then
		return false
	end

	if string.sub(wep, 1, 6) == "weapon" and GAMEMODE.HumanWeapons[wep] then
		return true
	end

	return false
end

local function IsPerk(wep)
	if not wep then
		return false
	end

	if string.sub(wep, 1, 1) == "_" and GAMEMODE.Perks[wep] then
		return true
	end

	return false
end

local function GetPerkSlot(item)
	if not item or not IsPerk(item) then
		return 0
	end
	
	return GAMEMODE.Perks[item].Slot or 0	
end

local Gradient = surface.GetTextureID("gui/center_gradient")

local lockIcon = Material("icon16/lock.png")

-- Lists
Unlocks = {}
SlotLabel = {}

local function IsValidRankUnlock(item, weptype, num)
	--Hide locked items
	--if not MySelf:HasUnlocked(item) then
		--return false
	--end
	
	if MySelf:IsBlocked(item, SlotLabel) or not MySelf:HasUnlocked(item) then
	return false
					end

	local sItemType = GetWeaponCategory(item)

	--Workaround for primary weapons
	if sItemType == "Automatic" then
		sItemType = "Pistol"
	end

	local IsValidWeapon = IsWeapon(item) and sItemType == weptype
	local IsValidPerk = IsPerk(item) and ((GetPerkSlot(item) == 1 and num == 2) or (GetPerkSlot(item) == 2 and num == 3) or (GetPerkSlot(item) == 3 and num == 1) )

	if not IsValidWeapon and not IsValidPerk then
		return false
	end

	return true, IsValidWeapon, IsValidPerk
end

local function DrawContextMenu(x, y, weptype, parent, num)

	Unlocks[num] = vgui.Create("DPanelList", parent)
	--Unlocks[num]:SetPos(0, 0)
	local ww, hh = parent:GetSize()
	
	local posY = ScaleH(130)
	
	--ItemsPanel
	Unlocks[num]:SetPos(0, posY)
	Unlocks[num]:SetSize(ww, hh)
	Unlocks[num]:SetSpacing(4)
	Unlocks[num]:SetPadding(0)
	Unlocks[num]:EnableHorizontal(true)
	Unlocks[num]:EnableVerticalScrollbar(false)
	Unlocks[num].Paint = function()
		--DrawPanelBlackBox(0, 0, ww, hh/2)
	end

	local count = 0

	--Walk through items to count ones we'll display
	for i=0, table.maxn(GAMEMODE.RankUnlocks) do
		if not GAMEMODE.RankUnlocks[i] then
			continue
		end

		for _, item in pairs(GAMEMODE.RankUnlocks[i]) do
			local IsValidItem, IsValidWeapon, IsValidPerk = IsValidRankUnlock(item, weptype, num)
			if not IsValidItem then
				continue
			end

			count = count + 1
		end
	end

	local itemWidth = math.Round(ww / 3.15) - 2
	local itemHeight = ScaleH(70)

	--Make columns smaller when needing a scrollbar
	if (math.ceil(count/2) * (5 + itemHeight) - 5) > hh then
		itemWidth = itemWidth - 10
	end	
	
	local ItemLabel = {}

	local function DrawBorder(item)
		--Border
		if item.Overed then
			surface.SetDrawColor(0, 225, 0, 255)
			surface.DrawOutlinedRect(0, 0, itemWidth, itemHeight)
			surface.DrawOutlinedRect(1, 1, itemWidth-2, itemHeight-2)
		else
			surface.SetDrawColor(30, 30, 30, 200)
			surface.DrawOutlinedRect(0, 0, itemWidth, itemHeight)
			surface.SetDrawColor(30, 30, 30, 255)
			surface.DrawOutlinedRect(1, 1, itemWidth-2, itemHeight-2)
		end
	end

	for i=0, table.maxn(GAMEMODE.RankUnlocks) do
		if not GAMEMODE.RankUnlocks[i] then
			continue
		end

		for _, item in pairs(GAMEMODE.RankUnlocks[i]) do
			local IsValidItem, IsValidWeapon, IsValidPerk = IsValidRankUnlock(item, weptype, num)
			if not IsValidItem then
				continue
			end 

			ItemLabel[item] = vgui.Create("DLabel", Unlocks[num])
			ItemLabel[item]:SetText("")
			ItemLabel[item]:SetSize(itemWidth, itemHeight) 
			ItemLabel[item].OnCursorEntered = function() 
				ItemLabel[item].Overed = true 
				surface.PlaySound(Sound("UI/buttonrollover.wav"))

				--Set description
				local Description = ""
				if GAMEMODE.Perks[item] and GAMEMODE.Perks[item].Description then
					Description = GAMEMODE.Perks[item].Description
				elseif GAMEMODE.HumanWeapons[item] and GAMEMODE.HumanWeapons[item].Description then
					Description = GAMEMODE.HumanWeapons[item].Description
				end
				
				local Equipment = ""				
				if GAMEMODE.Perks[item] and GAMEMODE.Perks[item].Equipment then
					Equipment = GAMEMODE.Perks[item].Equipment
				elseif GAMEMODE.HumanWeapons[item] and GAMEMODE.HumanWeapons[item].Equipment then
					Equipment = GAMEMODE.HumanWeapons[item].Equipment
				end						

				--Extra info about unlocking items
				if not MySelf:HasUnlocked(item) then
					Description = Description .. "\nThis item will be unlocked at a higher level."
				end
				
				if Equipment == "" then
					Description = Description 
				else
					Equipment = "Equipment:\n\n" .. Equipment .. "\n\n"
					Description = Equipment .. Description 			
				end
			
				Description = "Perks:\n\n" .. Description
				ItemDescription:SetText(Description)
				
			end
			
			ItemLabel[item].OnCursorExited = function() 
				ItemLabel[item].Overed = false

				ItemDescription:SetValue("")
			end

			ItemLabel[item].OnMousePressed = function() 
				if MySelf:IsBlocked(item, SlotLabel) or not MySelf:HasUnlocked(item) then
					surface.PlaySound(Sound("buttons/weapon_cant_buy.wav"))
					return
				end					
				
				if not SlotLabel[num] then
					return
				end
					
				surface.PlaySound(Sound("mrgreen/ui/menu_click01.wav"))

				SlotLabel[num].Item = item
			end

			if IsValidWeapon then
				ItemLabel[item].Paint = function()
					--Background
					DrawPanelBlackBox(0,0,itemWidth, itemHeight)

					if item == "none" then
						--Border
						DrawBorder(ItemLabel[item])

						return
					end
	
					if string.sub(item, 1, 6) == "weapon" then
						local font, letter = "WeaponSelectedHL2", "0"
						local Table = killicon.GetFont(item)
									
						if Table then
							letter = Table.letter
										
							if not Table.IsHl2 and not Table.IsZS then
								font = "WeaponSelectedCSS"
							elseif not Table.IsHl2 and Table.IsZS then
								font = "WeaponSelectedZS"
							end
						end
										
						if killicon.GetImage(item) then
							local ImgTable = killicon.GetImage(item) 
							surface.SetDrawColor(255, 255, 255, 180) 
																					
							surface.SetTexture(surface.GetTextureID(ImgTable.mat))	
							local wd, hg = surface.GetTextureSize(surface.GetTextureID(ImgTable.mat))
							local clampedH = (itemWidth * hg) / wd
							surface.DrawTexturedRect(57.5, 12, wd, math.Clamp(hg, 0, itemHeight))-- surface.DrawTexturedRect( x + 57.5,y + 12, wd, clampedH )

							--Draw label
							draw.SimpleTextOutlined(GAMEMODE.HumanWeapons[item].Name, "WeaponNames", itemWidth/2, itemHeight/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))										
						else
							surface.SetFont(font)
							local fWide, fTall = surface.GetTextSize(letter)

							surface.SetDrawColor(255, 255, 255, 255)
									
							draw.SimpleTextOutlined(letter, font, itemWidth/2, 55, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))

							--Draw label
							draw.SimpleTextOutlined(GAMEMODE.HumanWeapons[item].Name, "WeaponNames", itemWidth/2, itemHeight/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
						end
					end

					--Border
					DrawBorder(ItemLabel[item])
								
					--Lock
				if MySelf:IsBlocked(item, SlotLabel) or not MySelf:HasUnlocked(item) then
	
						surface.SetDrawColor(255,255,255,255)
						surface.SetMaterial(lockIcon)
						surface.DrawTexturedRect(itemWidth-18,2,16,16)
					end
				end
			elseif IsValidPerk then							
				ItemLabel[item].Paint = function()
					--Background
					DrawPanelBlackBox(0,0,itemWidth, itemHeight)

					if item == "none" then
						--Border
						DrawBorder(ItemLabel[item])
						
						return
					end					

					if GAMEMODE.Perks[item].Material then	
						local texture = surface.GetTextureID(GAMEMODE.Perks[item].Material)
						surface.SetTexture(texture)
						local wd, hg = surface.GetTextureSize(texture)
						local dif = (itemHeight-14)/hg
						surface.SetDrawColor(255, 255, 255, 180) -- 80, 80, 80, 255
						surface.DrawTexturedRect( itemWidth/2-(wd*dif)/2,12, wd*dif, math.Clamp(hg*dif, 0, itemHeight))
					end

					surface.SetDrawColor(255, 255, 255, 255) 
					draw.SimpleTextOutlined(GAMEMODE.Perks[item].Name, "WeaponNames", itemWidth/2, itemHeight/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))

					--Border
					DrawBorder(ItemLabel[item])
					
					--Lock		
					if MySelf:IsBlocked(item, SlotLabel) or not MySelf:HasUnlocked(item) then
						surface.SetDrawColor(255,255,255,255)
						surface.SetMaterial(lockIcon)
						surface.DrawTexturedRect(itemWidth-18,2,16,16)
					end					
				end				
			end

			Unlocks[num]:AddItem(ItemLabel[item])
		end
	end
end


local function DrawClassesContextMenu(x, y, weptype, parent, num)

	Unlocks[num] = vgui.Create("DPanelList")

	local ww, hh = ScrW()*0.5, ScrH()*0.35
	
	-- Class selection
	
	local posY = ScrH()*0.135
	local posX = ScrW()*0.315
	
	--ItemsPanel
	Unlocks[num]:SetPos(posX,posY)
	Unlocks[num]:SetSize(ScrW()*0.8, ScrH()*0.25)
	Unlocks[num]:SetSpacing(2)
	Unlocks[num]:SetPadding(0)
	Unlocks[num]:EnableHorizontal(true)
	Unlocks[num]:EnableVerticalScrollbar(false)
	--Unlocks[num].Paint = function()
		--DrawPanelBlackBox(0, 0, ww, hh/3)
	--end

	local count = 0

	--Walk through items to count ones we'll display
	for i=0, table.maxn(GAMEMODE.RankUnlocks) do
		if not GAMEMODE.RankUnlocks[i] then
			continue
		end

		for _, item in pairs(GAMEMODE.RankUnlocks[i]) do
			local IsValidItem, IsValidWeapon, IsValidPerk = IsValidRankUnlock(item, weptype, num)
			if not IsValidItem then
				continue
			end

			count = count + 1
		end
	end


	local itemWidth = ScrW()*0.05
	local itemHeight = ScrH()*0.15

	--Make columns smaller when needing a scrollbar
	--if (math.ceil(count/2) * (5 + itemHeight) - 5) > hh then
	--	itemWidth = itemWidth * 0.85
	--end	
	
	local ItemLabel = {}

	local function DrawBorder(item)
		--Border
		if item.Overed then
			surface.SetDrawColor(0, 225, 0, 225)
			surface.DrawOutlinedRect(0, 0, itemWidth * 2, itemHeight * 2)
			surface.DrawOutlinedRect(1, 1, itemWidth-4, itemHeight-4)
		else
			surface.SetDrawColor(30, 30, 30, 0)
			surface.DrawOutlinedRect(0, 0, itemWidth * 2, itemHeight * 2)
			surface.SetDrawColor(30, 30, 30, 0)
			surface.DrawOutlinedRect(1, 1, itemWidth-2, itemHeight-2)
		end
	end

	for i=0, table.maxn(GAMEMODE.RankUnlocks) do
		if not GAMEMODE.RankUnlocks[i] then
			continue
		end

		for _, item in pairs(GAMEMODE.RankUnlocks[i]) do
			local IsValidItem, IsValidWeapon, IsValidPerk = IsValidRankUnlock(item, weptype, num)
			if not IsValidItem then
				continue
			end 

			ItemLabel[item] = vgui.Create("DLabel", Unlocks[num])
			ItemLabel[item]:SetText("")
			ItemLabel[item]:SetSize(itemWidth, itemHeight) 
			ItemLabel[item].OnCursorEntered = function() 
				ItemLabel[item].Overed = true 
				surface.PlaySound(Sound("mrgreen/ui/menu_accept.wav"))

				--Set description
				local Description = ""
				if GAMEMODE.Perks[item] and GAMEMODE.Perks[item].Description then
					Description = GAMEMODE.Perks[item].Description
				elseif GAMEMODE.HumanWeapons[item] and GAMEMODE.HumanWeapons[item].Description then
					Description = GAMEMODE.HumanWeapons[item].Description
				end
				
				local Equipment = ""				
				if GAMEMODE.Perks[item] and GAMEMODE.Perks[item].Equipment then
					Equipment = GAMEMODE.Perks[item].Equipment
				elseif GAMEMODE.HumanWeapons[item] and GAMEMODE.HumanWeapons[item].Equipment then
					Equipment = GAMEMODE.HumanWeapons[item].Equipment
				end				

				--Extra info about unlocking items
				if not MySelf:HasUnlocked(item) then
					Description = Description .. "\nThis item will be unlocked at a higher level."
				end
				Description = "Perks:\n\n" .. Description
				if Equipment == "" then
					Description = Description 
				else
					Equipment = "Equipment:\n\n" .. Equipment .. "\n\n"
					Description = Equipment .. Description 			
				end
				
				ItemDescription:SetText(Description)
			end
			
			ItemLabel[item].OnCursorExited = function() 
				ItemLabel[item].Overed = false

				ItemDescription:SetValue("")
			end

			ItemLabel[item].OnMousePressed = function() 
				--if MySelf:IsBlocked(item, SlotLabel) or not MySelf:HasUnlocked(item) then
				--	surface.PlaySound(Sound("buttons/weapon_cant_buy.wav"))
				--	return
				--end					
				if SlotLabel[num] then
					surface.PlaySound(Sound("mrgreen/ui/menu_click01.wav"))
					SlotLabel[num].Item = item
				end
				
				Unlocks[num]:Remove()
			end
			
			ItemLabel[item].Think = function() 
				if WARMUPTIME-10 - CurTime() <= 1 then
					Unlocks[num]:Remove()
				end	
			end
			

			if IsValidWeapon then
				ItemLabel[item].Paint = function()
					--Background
					DrawPanelBlackBox(0,0,itemWidth, itemHeight)

					if item == "none" then
						--Border
						DrawBorder(ItemLabel[item])

						return
					end
	
					if string.sub(item, 1, 6) == "weapon" then
						local font, letter = "WeaponSelectedHL2", "0"
						local Table = killicon.GetFont(item)
									
						if Table then
							letter = Table.letter
										
							if not Table.IsHl2 and not Table.IsZS then
								font = "WeaponSelectedCSS"
							elseif not Table.IsHl2 and Table.IsZS then
								font = "WeaponSelectedZS"
							end
						end
										
						if killicon.GetImage(item) then
							local ImgTable = killicon.GetImage(item) 
							surface.SetDrawColor(255, 255, 255, 180) 
																					
							surface.SetTexture(surface.GetTextureID(ImgTable.mat))	
							local wd, hg = surface.GetTextureSize(surface.GetTextureID(ImgTable.mat))
							local clampedH = (itemWidth * hg) / wd
							--surface.DrawTexturedRect(57.5, 12, wd, math.Clamp(hg, 0, itemHeight))-- surface.DrawTexturedRect( x + 57.5,y + 12, wd, clampedH )

							--Draw label
							draw.SimpleTextOutlined(GAMEMODE.HumanWeapons[item].Name, "WeaponNames", itemWidth/2, itemHeight/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))																			
						else
							surface.SetFont(font)
							local fWide, fTall = surface.GetTextSize(letter)

							surface.SetDrawColor(255, 255, 255, 255)
							draw.SimpleTextOutlined(letter, font, itemWidth/2, 55, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))

							
							--Draw label
							draw.SimpleTextOutlined(GAMEMODE.HumanWeapons[item].Name, "WeaponNames", itemWidth/2, itemHeight/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
						end
					end

					--Border
					DrawBorder(ItemLabel[item])
								
					--Lock
				
				if MySelf:IsBlocked(item, SlotLabel) or not MySelf:HasUnlocked(item) then
	
						surface.SetDrawColor(255,255,255,255)
						surface.SetMaterial(lockIcon)
						surface.DrawTexturedRect(itemWidth*0.5,0,itemWidth,itemHeight)
					end
				end
			
				
			elseif IsValidPerk then							
				ItemLabel[item].Paint = function()
					--Background
					DrawPanelBlackBox(0,0,itemWidth, itemHeight)

					if item == "none" then
						--Border
						DrawBorder(ItemLabel[item])
						
						return
					end					

					if GAMEMODE.Perks[item].Material then	
						local texture = surface.GetTextureID(GAMEMODE.Perks[item].Material)
						surface.SetTexture(texture)
						local wd, hg = surface.GetTextureSize(texture)
						local dif = itemHeight/hg
						surface.SetDrawColor(255, 255, 255, 180) -- 80, 80, 80, 255
						surface.DrawTexturedRect( itemWidth/2-(wd*dif)/2,12, wd*dif, math.Clamp(hg*dif, 0, itemHeight))
					end

					surface.SetDrawColor(255, 255, 255, 255) 

					draw.SimpleTextOutlined(GAMEMODE.Perks[item].Name, "WeaponNames", itemWidth/2, itemHeight/1.1, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
					

					--Border
					DrawBorder(ItemLabel[item])
					
					--Lock		
					if MySelf:IsBlocked(item, SlotLabel) or not MySelf:HasUnlocked(item) then
						surface.SetDrawColor(255,255,255,255)
						surface.SetMaterial(lockIcon)
						surface.DrawTexturedRect(itemWidth-18,2,16,16)
					end					
				end				
			end

			Unlocks[num]:AddItem(ItemLabel[item])
		end
	end
end


--CLASS SECECTION MENU I AM LAZY AND DID A C&P EDIT
function DrawClassIcon(x, y, ww, hh, wepclass, parent, num, weptype)
	
	hh = hh - 30

	SlotLabel[num] = vgui.Create("DLabel")
	SlotLabel[num]:SetParent(parent)
	SlotLabel[num]:SetText("")
	SlotLabel[num]:SetSkin("ZSMG")
	SlotLabel[num]:SetSize(ww, hh) 
	SlotLabel[num]:SetPos(x, y/1.5)
	SlotLabel[num].Item = wepclass
	
	SlotLabel[num].OnCursorEntered = function() 
		SlotLabel[num].Overed = true 
		surface.PlaySound(Sound("UI/buttonrollover.wav"))

		--Set description
		local item = SlotLabel[num].Item
		local Description = ""
		if GAMEMODE.Perks[item] and GAMEMODE.Perks[item].Description then
			Description = GAMEMODE.Perks[item].Description
		elseif GAMEMODE.HumanWeapons[item] and GAMEMODE.HumanWeapons[item].Description then
			Description = GAMEMODE.HumanWeapons[item].Description
		end
		
		local Equipment = ""				
		if GAMEMODE.Perks[item] and GAMEMODE.Perks[item].Equipment then
			Equipment = GAMEMODE.Perks[item].Equipment
		elseif GAMEMODE.HumanWeapons[item] and GAMEMODE.HumanWeapons[item].Equipment then
			Equipment = GAMEMODE.HumanWeapons[item].Equipment
		end			

		Description = "Perks:\n\n" .. Description
		
		if Equipment != "" then
			Equipment = "Equipment:\n\n" .. Equipment .. "\n\n"
			Description = Equipment .. Description 			
		else
			Description = Description 		
		end
		
		ItemDescription:SetText(Description)		
	end

	SlotLabel[num].OnCursorExited = function () 
		SlotLabel[num].Overed = false

		ItemDescription:SetText("")
	end


	SlotLabel[num].OnMousePressed = function () 
		for i=1, 1 do
			if i == num then
				--Activate
				SlotLabel[i].Active = true 
				
				if not Unlocks[i] then
					DrawClassesContextMenu(x+ww+ScaleH(20), 30, weptype, ItemsPanel, num)
				else
					Unlocks[i]:Remove()
					Unlocks[i] = nil
				end

				surface.PlaySound(Sound("mrgreen/ui/menu_accept.wav"))

			else
				--Inactivate other tabs
				SlotLabel[i].Active = false
				if Unlocks[i] then
					Unlocks[i]:Remove()
					Unlocks[i] = nil
				end
			end
		end	
		
	end

	SlotLabel[num].Think = function() 

	end
	
	SlotLabel[num].Paint = function()
		if SlotLabel[num].Overed then
			surface.SetDrawColor(0, 225, 0, 255)
			surface.DrawOutlinedRect(0, 0, ww, hh)
			surface.DrawOutlinedRect(1, 1, ww-2, hh-2)
		elseif SlotLabel[num].Active then
			surface.SetDrawColor(255, 255, 255, (math.sin(RealTime() * 5) * 95) + 150)
			surface.DrawOutlinedRect( 0, 0, ww, hh)
			surface.DrawOutlinedRect( 1, 1, ww-2, hh-2)
		end
		
		if SlotLabel[num].Item == "none" then
			return
		end

		if string.sub(SlotLabel[num].Item, 1, 6) == "weapon" then
			local font, letter = "WeaponSelectedHL2", "0"
			local Table = killicon.GetFont( SlotLabel[num].Item )
			if Table then
				letter = Table.letter
					
				if not Table.IsHl2 and not Table.IsZS then
					font = "WeaponSelectedCSS"
				elseif not Table.IsHl2 and Table.IsZS then
					font = "WeaponSelectedZS"
				end
			end
				
			if killicon.GetImage( SlotLabel[num].Item ) then
				local ImgTable = killicon.GetImage( SlotLabel[num].Item ) 				

				surface.SetDrawColor(255, 255, 255, 255) 
									
				surface.SetTexture(surface.GetTextureID( ImgTable.mat ))	
				local wd,hg = surface.GetTextureSize(surface.GetTextureID( ImgTable.mat ))
				local clampedH = (ww*hg)/wd
				surface.DrawTexturedRect( 57.5,12, wd, math.Clamp(hg,0,hh) )

				--Draw label
				draw.SimpleTextOutlined ( GAMEMODE.HumanWeapons[SlotLabel[num].Item].Name, "WeaponNames", ww/2, hh, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))

			else				
				surface.SetFont ( font )
				local fWide, fTall = surface.GetTextSize ( letter )
					
				surface.SetDrawColor( 255, 255, 255, 255 )						
					
				draw.SimpleTextOutlined ( letter, font, ww/2, 100, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))

				--Draw label			
				draw.SimpleTextOutlined ( GAMEMODE.HumanWeapons[SlotLabel[num].Item].Name, "WeaponNames", ww/2, hh, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))				
			end
		elseif string.sub(SlotLabel[num].Item, 1, 1) == "_" then
			if GAMEMODE.Perks[SlotLabel[num].Item].Material then		
				surface.SetTexture(surface.GetTextureID( GAMEMODE.Perks[SlotLabel[num].Item].Material ))	
				local wd,hg = surface.GetTextureSize(surface.GetTextureID( GAMEMODE.Perks[SlotLabel[num].Item].Material ))
				local dif = (hh-14)/hg
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawTexturedRect( ww/2-(wd*dif)/2,12, wd*dif, math.Clamp(hg*dif,0,hh) )
			end

			--Draw label
			surface.SetDrawColor(255, 255, 255, 255) 
			draw.SimpleTextOutlined(GAMEMODE.Perks[SlotLabel[num].Item].Name, "WeaponNames", ww/2, hh / 1.1, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		end

		if MySelf:IsBlocked(SlotLabel[num].Item, SlotLabel) then
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(lockIcon)
			surface.DrawTexturedRect(ww-18,2,16,16)
		end
	end
end


-- Loadout
function DrawSlotIcon(x, y, ww, hh, wepclass, parent, num, weptype)
	hh = hh - 30

	SlotLabel[num] = vgui.Create("DLabel")
	SlotLabel[num]:SetParent(parent)
	SlotLabel[num]:SetText("")
	SlotLabel[num]:SetSkin("ZSMG")
	SlotLabel[num]:SetSize(ww, hh) 
	SlotLabel[num]:SetPos(x, y/1.2)
	SlotLabel[num].Item = wepclass
	
	SlotLabel[num].OnCursorEntered = function() 
		SlotLabel[num].Overed = true 
		surface.PlaySound(Sound("UI/buttonrollover.wav"))

		--Set description
		local item = SlotLabel[num].Item
		if GAMEMODE.Perks[item] and GAMEMODE.Perks[item].Description then
			ItemDescription:SetText(GAMEMODE.Perks[item].Description)
		elseif GAMEMODE.HumanWeapons[item] and GAMEMODE.HumanWeapons[item].Description then
			ItemDescription:SetText(GAMEMODE.HumanWeapons[item].Description)
		end
	end

	SlotLabel[num].OnCursorExited = function () 
		SlotLabel[num].Overed = false

		ItemDescription:SetText("")
	end

	SlotLabel[num].OnMousePressed = function () 
		for i=2, 3 do
			if i == num then
				--Activate
				SlotLabel[i].Active = true 
				
				if not Unlocks[i] then
					DrawContextMenu(x+ww+ScaleH(20), 30, weptype, ItemsPanel, num)
				else
					Unlocks[i]:Remove()
					Unlocks[i] = nil
				end

				surface.PlaySound(Sound("mrgreen/ui/menu_accept.wav"))
			else
				--Inactivate other tabs
				SlotLabel[i].Active = false
				if Unlocks[i] then
					Unlocks[i]:Remove()
					Unlocks[i] = nil
				end
			end
		end	
		
	end
	SlotLabel[num].Think = function() 
	end
	
	SlotLabel[num].Paint = function()
		if SlotLabel[num].Overed then
			surface.SetDrawColor(0, 225, 0, 255)
			surface.DrawOutlinedRect(0, 0, ww, hh)
			surface.DrawOutlinedRect(1, 1, ww-2, hh-2)
		elseif SlotLabel[num].Active then
			surface.SetDrawColor(255, 255, 255, (math.sin(RealTime() * 5) * 95) + 150)
			surface.DrawOutlinedRect( 0, 0, ww, hh)
			surface.DrawOutlinedRect( 1, 1, ww-2, hh-2)
		end
		
		if SlotLabel[num].Item == "none" then
			return
		end

		if string.sub(SlotLabel[num].Item, 1, 6) == "weapon" then
			local font, letter = "WeaponSelectedHL2", "0"
			local Table = killicon.GetFont( SlotLabel[num].Item )
			if Table then
				letter = Table.letter
					
				if not Table.IsHl2 and not Table.IsZS then
					font = "WeaponSelectedCSS"
				elseif not Table.IsHl2 and Table.IsZS then
					font = "WeaponSelectedZS"
				end
			end
				
			if killicon.GetImage( SlotLabel[num].Item ) then
				local ImgTable = killicon.GetImage( SlotLabel[num].Item ) 				

				surface.SetDrawColor(255, 255, 255, 255) 
									
				surface.SetTexture(surface.GetTextureID( ImgTable.mat ))	
				local wd,hg = surface.GetTextureSize(surface.GetTextureID( ImgTable.mat ))
				local clampedH = (ww*hg)/wd
				surface.DrawTexturedRect( 57.5,12, wd, math.Clamp(hg,0,hh) )

				--Draw label
				draw.SimpleTextOutlined ( GAMEMODE.HumanWeapons[SlotLabel[num].Item].Name, "WeaponNames", ww/2, hh/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
			else				
				surface.SetFont ( font )
				local fWide, fTall = surface.GetTextSize ( letter )
					
				surface.SetDrawColor( 255, 255, 255, 255 )						
					
				draw.SimpleTextOutlined ( letter, font, ww/2, 55, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))

				--Draw label
				draw.SimpleTextOutlined ( GAMEMODE.HumanWeapons[SlotLabel[num].Item].Name, "WeaponNames", ww/2, hh/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))				
			end
		elseif string.sub(SlotLabel[num].Item, 1, 1) == "_" then
			if GAMEMODE.Perks[SlotLabel[num].Item].Material then		
				surface.SetTexture(surface.GetTextureID( GAMEMODE.Perks[SlotLabel[num].Item].Material ))	
				local wd,hg = surface.GetTextureSize(surface.GetTextureID( GAMEMODE.Perks[SlotLabel[num].Item].Material ))
				local dif = (hh-14)/hg

				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawTexturedRect( ww/2-(wd*dif)/2,12, wd*dif, math.Clamp(hg*dif,0,hh) )
			end

			--Draw label
			surface.SetDrawColor(255, 255, 255, 255) 
			draw.SimpleTextOutlined(GAMEMODE.Perks[SlotLabel[num].Item].Name, "WeaponNames", ww/2, hh/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		end

		if MySelf:IsBlocked(SlotLabel[num].Item, SlotLabel) then
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(lockIcon)
			surface.DrawTexturedRect(ww-18,2,16,16)
		end
	end
end

local LoadoutOpen = false

function DrawSelectClass()
	local filename = "zombiesurvival/loadouts/default.txt"
	if file.Exists(filename,"DATA") then
		local tbl = util.JSONToTable(file.Read(filename))
		if tbl then
			Loadout = table.Copy(tbl)
			for _,v in pairs(Loadout) do
				if not MySelf:HasUnlocked(v) then
					table.remove(Loadout, _)
				end
			end
		else
			Loadout = {"weapon_zs_usp","weapon_zs_melee_keyboard"}
		end
	else
		file.CreateDir("zombiesurvival/loadouts")
		Loadout = {"weapon_zs_usp","weapon_zs_melee_keyboard"}
	end

	LoadoutOpen = true
	
	--Options:
	spawntimer = 50
	local spawntimercd = 0

	TopMenuW, TopMenuH = 0,0
	TopMenuX, TopMenuY = 0,0

	
	
	
	local BlurPanel = vgui.Create("DFrame")
	BlurPanel:SetSize(w,h)
	BlurPanel:SetPos(0,0)
	BlurPanel:SetDraggable(false)
	BlurPanel:SetTitle("")
	--BlurPanel:SetBackgroundBlur(true)
	BlurPanel:SetSkin("ZSMG")
	BlurPanel:ShowCloseButton(false)
	BlurPanel.Paint = function() 
		--Override
		draw.SimpleText("MrGreenGaming.com", "ssNewAmmoFont11", ScrW()*0.5, ScrH()*0.05, Color(60, 120, 60, 220), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("ZOMBIE SURVIVAL", "ssNewAmmoFont9", ScrW()*0.5, ScrH()*0.1, Color(245, 250, 245, 220), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local perk1, perk2, perk3 = "none", "none", "none"

	--Get Perk1
	for k, v in pairs(Loadout) do
		if IsPerk(v) and GetPerkSlot(v) == 1 then
			perk1 = v
			break
		end
	end
	
	--Get Perk2
	for k, v in pairs(Loadout) do
		if IsPerk(v) and GetPerkSlot(v) == 2 then
			perk2 = v
			break
		end
	end
	
				--Get Perk3
	for k, v in pairs(Loadout) do
		if IsPerk(v) and GetPerkSlot(v) == 3 then
			perk3 = v
			break
		end
	end
	
	local stepY = ScrH() * 0.1
	local marginY = 4
	
	local SlotHeight = ScrH()*0.15
	local SlotWidth = ScrW()*0.15
	
	local SlotPosY = ScrH()*0.2
	local SlotPosX = ScrH()*0.75

	local function IncreasestepY()
		stepY = stepY + SlotHeight + marginY
	end

	local LoadoutPistolPanel = vgui.Create("DFrame")
	LoadoutPistolPanel:SetSize(SlotWidth, SlotHeight)
	LoadoutPistolPanel:SetPos(SlotPosX,SlotPosY + stepY)
	LoadoutPistolPanel:SetSkin("ZSMG")
	LoadoutPistolPanel:SetTitle("CLASS") 
	LoadoutPistolPanel:SetDraggable(false)
	LoadoutPistolPanel:SetSizable(false)
	LoadoutPistolPanel:SetDraggable(false)
	LoadoutPistolPanel:ShowCloseButton(false)
	DrawClassIcon(0, 30, SlotWidth, SlotHeight, perk3, LoadoutPistolPanel,1,"perk3") --Edited one for the classes selection menu. Messy messy mess.....
	--DrawClassIcon(x, y, ww, hh, wepclass, parent, 1, "perk3")	

	if perk3 == "none" then
		DrawClassesContextMenu(w/2, h/20, "perk3", ItemsPanel, 1)
	end
	
	IncreasestepY()

	local LoadoutPerk1Panel = vgui.Create("DFrame")
	LoadoutPerk1Panel:SetSize(SlotWidth, SlotHeight)
	LoadoutPerk1Panel:SetPos(SlotPosX,SlotPosY + stepY)
	LoadoutPerk1Panel:SetSkin("ZSMG")
	LoadoutPerk1Panel:SetTitle( "EQUIPMENT PERK" ) 
	LoadoutPerk1Panel:SetDraggable ( false )
	LoadoutPerk1Panel:SetSizable(false)
	LoadoutPerk1Panel:SetDraggable(false)
	LoadoutPerk1Panel:ShowCloseButton(false)
	DrawSlotIcon(0, 30, SlotWidth, SlotHeight,perk1, LoadoutPerk1Panel, 2, "Perk1")
	
	IncreasestepY()	

	
	local LoadoutPerk2Panel = vgui.Create("DFrame")
	LoadoutPerk2Panel:SetSize(SlotWidth, SlotHeight)
	LoadoutPerk2Panel:SetPos(SlotPosX,SlotPosY + stepY)
	LoadoutPerk2Panel:SetSkin("ZSMG")
	LoadoutPerk2Panel:SetTitle( "PERSONAL PERK" ) 
	LoadoutPerk2Panel:SetDraggable ( false )
	LoadoutPerk2Panel:SetSizable(false)
	LoadoutPerk2Panel:SetDraggable(false)
	LoadoutPerk2Panel:ShowCloseButton(false)

	DrawSlotIcon(0, 30, SlotWidth, SlotHeight,perk2,LoadoutPerk2Panel, 3, "Perk2")

	local SecondColumnWidth = math.Round((TopMenuW - (SlotWidth + 20)) / 2)

	ItemDescriptionPanel = vgui.Create("DFrame")
	ItemDescriptionPanel:SetSize(ScrW()*0.225, ScrH()*0.5)
	ItemDescriptionPanel:SetPos(ScrW()*0.175,ScrH()*0.30)
	ItemDescriptionPanel:SetSkin("ZSMG")
	ItemDescriptionPanel:SetTitle("LOADOUT DESCRIPTION")
	ItemDescriptionPanel:SetDraggable(false)
	ItemDescriptionPanel:SetSizable(false)
	ItemDescriptionPanel:SetDraggable(false)
	ItemDescriptionPanel:ShowCloseButton(false)
	
	ItemDescription = vgui.Create("DTextEntry", ItemDescriptionPanel)
	ItemDescription:SetPos(5, 25)
	local ParentW, ParentH = ItemDescriptionPanel:GetSize()
	ItemDescription:SetSize(ParentW - 10,ParentH - 30) 
	ItemDescription:SetEditable(false)
	ItemDescription:SetValue("")
	ItemDescription:SetMultiline(true)

	ItemsPanel = vgui.Create("DFrame")
	ItemsPanel:SetSize(ScrW()*0.25,ScrH()*0.8)
	ItemsPanel:SetPos(ScrW()*0.5875,ScrH()*0.175)
	ItemsPanel:SetDraggable(false)
	ItemsPanel:SetTitle("")
	ItemsPanel:ShowCloseButton(false)
	ItemsPanel:SetDraggable(false)
	ItemsPanel:SetSizable(false)
	ItemsPanel.Paint = function()
		--Override
	end
	
	--And clean table since we dont need yet
	Loadout = {}

	--Spawn button
	SpawnButtonW, SpawnButtonH = SlotWidth, SlotHeight*0.5
	SpawnButtonX = w / 2 - (SpawnButtonW * 0.5)

	SpawnButton = vgui.Create("DButton", BlurPanel)
	SpawnButton:SetText("")
	SpawnButton:SetPos(SpawnButtonX, ScrH()*0.8)
	SpawnButton:SetSize(SpawnButtonW, SpawnButtonH)

	local function CloseSpawnMenu(class)
		ChangeClassClient(1)
		BlurPanel:Close()
		ItemsPanel:Close()
		LoadoutPistolPanel:Close()
		LoadoutPerk1Panel:Close()
		LoadoutPerk2Panel:Close()
		PlayerProgressPanel:Close()
		ItemDescriptionPanel:Close()
	end

	SpawnButton.Think = function () 
		if WARMUPTIME-10 - CurTime() <= 0 then
			CloseSpawnMenu(math.random(1,5))
		end
		
	end
	
	SpawnButton.PaintOver = function ()
		draw.SimpleTextOutlined("Spawn ".. math.Round(WARMUPTIME-10 - CurTime()), "ssNewAmmoFont10", SpawnButtonW/2, SpawnButtonH/2, Color (255,255,255,220), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,230))
	end
	
	SpawnButton.DoClick = function ()
		CloseSpawnMenu(1)
	end
	
	--Stats
	StatsX, StatsY = SpawnButtonX+SpawnButtonW+ScaleH(20),SpawnButtonY
	StatsW, StatsH = SecondColumnWidth, SlotHeight
	
	PlayerProgressPanel = vgui.Create("DFrame")
	PlayerProgressPanel:SetSize(ScrW()*0.28, ScrH()*0.1)
	PlayerProgressPanel:SetPos(ScrW()*0.59 , ScrH()*0.7)
	PlayerProgressPanel:SetSkin("ZSMG")
	PlayerProgressPanel:SetTitle("LEVEL " .. MySelf:GetRank()) 
	PlayerProgressPanel:SetDraggable(false)
	PlayerProgressPanel:SetSizable(false)
	PlayerProgressPanel:SetDraggable(false)
	PlayerProgressPanel:ShowCloseButton(false)

	PlayerProgressPanel.PaintOver = function()

		draw.SimpleTextOutlined(MySelf:CurRankXP()-MySelf:GetXP() .." XP Remaining for level " .. MySelf:GetRank()+1 , "ssNewAmmoFont7", ScrW()*0.0085, ScrH()*0.05, Color (255,255,255,220), TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT,1,Color(0,0,0,230))
		
	end

	
	--What is this doing here?
	ItemDescriptionPanel.Think = function()
		gui.EnableScreenClicker(true)
	end

	--If christmas play xmas sound first and then the normal one
	if CHRISTMAS then
		surface.PlaySound(Sound("mrgreen/music/gamestart_xmas.mp3"))
		timer.Simple(22, function()
		end)
	else

	local ENABLE_MUSIC = util.tobool(GetConVarNumber("_zs_enablemusic"))
	if ENABLE_MUSIC then
		surface.PlaySound(Sound("mrgreen/music/gamestart"..math.random(1,4)..".mp3"))
	end	
	end
end

function IsLoadoutOpen()
	return LoadoutOpen
end

function ChangeClassClient(class)
	gui.EnableScreenClicker(false)
	LoadoutOpen = false
	
	local filename = "zombiesurvival/loadouts/default.txt"
	
	if SlotLabel then
		for i=1,6 do
			if SlotLabel[i] and SlotLabel[i].Item and SlotLabel[i].Item ~= "none" then
				table.insert(Loadout, SlotLabel[i].Item)
			end
		end
	end
	
	local tbl = util.TableToJSON(Loadout)
	file.Write(filename,tbl)
	
	RunConsoleCommand("_applyloadout",unpack(Loadout))
	
	RunConsoleCommand("ChangeClass", class)
	
	-- Only one call after choosing loadout
	gamemode.Call("PostPlayerChooseLoadout", MySelf)
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

	RunConsoleCommand("_applyloadout", unpack(Loadout))
end