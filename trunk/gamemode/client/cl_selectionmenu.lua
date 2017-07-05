-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Selection menu draw management

--Duby: I moded this to fit the current zs hud. I think it looks great. Remove this comment if you disagree. 

local SelectPanel = surface.GetTextureID( "greencoins" )

local Gradient = surface.GetTextureID( "gui/center_gradient" )

local MaximumSlots = 7

--  Initialize table for activate weapon slot
local IsSlotActive = {}
for i = 1, MaximumSlots do
	IsSlotActive[i] = false
end

--  Initialize table for the 'existing' slot weapons
local IsSlot = {}
for i = 1, MaximumSlots do
	IsSlot[i] = false
end

local ShowWeapons = false
local WeaponsAlpha, Back1Alpha,Back2Alpha = 0,0,0
local LastScroll, HideSelectionTime = 0, 0
LastInfoScroll = LastInfoScroll or 0

--[==[---------------------------------------------------------
        Called to check if the slot bind is pressed
---------------------------------------------------------]==]
local sIndex, ScrollSpeed = 0, 0.01
local function ManageSlotBinds ( pl, bind, pressed ) 
	if pl:Team() ~= TEAM_HUMAN or not string.find(bind,"slot") then
		return
	end

	for i = 1, MaximumSlots do
		if string.find ( bind, "slot"..i ) then
			if IsSlot[i] then
				for k,v in pairs(IsSlotActive) do
					IsSlotActive[k] = false
				end
			
				IsSlotActive[i] = true
				
				-- Run the almight filtering function and match the weapon you need to select
				local MyWeapons = FilterWeapons()
				local WeaponToSelect = MyWeapons[i]:GetClass()
				
				-- -- Compensate for the scroll wheel
				sIndex = i

				-- Select the weapon
				RunConsoleCommand( "use", tostring( WeaponToSelect ) )
				
			end
			
			return true
		end
	end
end
--hook.Add ( "PlayerBindPress", "ManageSlots", ManageSlotBinds )

local function OnScrolled( pl, bind, pressed )
	if pl:Team() ~= TEAM_HUMAN or (bind ~= "invnext" and bind ~= "invprev") then
		return
	end

	if ScrollSpeed > CurTime() then
		return true
	end

	local ActiveSlots, iIndex = {}, 0
	for k,v in pairs(IsSlot) do
		if IsSlot[k] == true then
			iIndex = iIndex + 1
			ActiveSlots[iIndex] = k
		end
	end
			
	if #ActiveSlots == 0 then
		return true
	end

	-- Case 1: We scroll up
	if bind == "invprev" then
		if sIndex >= 1 then
			sIndex = sIndex - 1
		end
		
		if sIndex <= 0 then
			sIndex = #ActiveSlots
		end
	-- Case 2: We scroll down
	elseif bind == "invnext" then
		if sIndex <= #ActiveSlots then
			sIndex = sIndex + 1
		end
			
		if sIndex > #ActiveSlots then
			sIndex = 1
		end
	end
			
	for k,v in pairs (IsSlotActive) do
		IsSlotActive[k] = false
	end
		
	if ActiveSlots[sIndex] == nil then
		return
	end
	IsSlotActive[ActiveSlots[sIndex]] = true
			
	--Run the almight filtering function and match the weapon you need to select
	local MyWeapons = FilterWeapons()

	--Check if we still have weapons
	if not MyWeapons then
		return true
	end

	local WeaponToSelect = MyWeapons[ ActiveSlots[sIndex] ]:GetClass()
				
	--Use weapon
	RunConsoleCommand("use", tostring(WeaponToSelect))
	
	--Delay next scroll		
	--ScrollSpeed = CurTime() + 0.05
	ScrollSpeed = CurTime() + 0.01

	--Display weapons
	ShowWeapons = true
	LastScroll = CurTime()
	HideSelectionTime = LastScroll + 1.8
		
	return true
end
--hook.Add("PlayerBindPress", "OnScrolled", OnScrolled)

--Restricted half life 2 weapons
local WeaponsRestricted = { "weapon_stunstick", "weapon_crowbar", "weapon_pistol", "weapon_357", "weapon_ar2", "weapon_shotgun", "weapon_frag", "weapon_crossbow", "weapon_rpg", "weapon_physcannon", "weapon_physgun" }

local SlotOrder = {
	["Automatic"] = 0,
	["Pistol"] = 1,
	["Melee"] = 2,
	["Tool1"] = 3,
	["Tool2"] = 4,
	["Misc"] = 5,
	["Admin"] = 6
}

function FilterWeapons()
	if not IsValid ( MySelf ) or not MySelf:Alive() or MySelf:Team() ~= TEAM_HUMAN or ENDROUND then
		return
	end
	-- See what slots are present (what weapons do you actually have)
	local MyWeapons = MySelf:GetWeapons()
	
	-- Filter the table from hard coded weapons like physgun or physcanno
	for k,v in pairs ( MyWeapons ) do
		for i, wep in pairs ( WeaponsRestricted ) do
			if string.find ( v:GetClass(), wep ) then
				MyWeapons[k] = nil
			end
		end
	end
				
	table.sort( MyWeapons, function( a, b ) 
		if a == nil or b == nil then return end 
			-- return a.Slot < b.Slot 
			return SlotOrder[GetWeaponCategory ( a:GetClass() )] < SlotOrder[GetWeaponCategory ( b:GetClass() )]
	end )
				
	-- Match the slot value with our panels index
	local Table = {}
	for k,v in pairs ( MyWeapons ) do
		-- Table[v.Slot+1] = v
		if MySelf:Team() == TEAM_HUMAN then -- small fix
			if SlotOrder and SlotOrder[GetWeaponCategory ( v:GetClass() )] then
				if Table then
					Table[(SlotOrder[GetWeaponCategory ( v:GetClass() )] or 0)+1] = v
				end
			end
		end
	end
	
	-- Switch the old table with the new one
	MyWeapons = Table
	
	return MyWeapons
end

--  Slot 1 - 4 sizes!
local wOffSize, hOffSize = ScaleW(186), ScaleW(98)
local wSize, hSize = ScaleW(220), ScaleW(110)	

local SLOT_SIZE = { 
	[1] = { SizeW = wSize, SizeH = hSize },
	[2] = { SizeW = wSize, SizeH = hSize },
	[3] = { SizeW = wSize, SizeH = hSize },
	[4] = { SizeW = wSize, SizeH = hSize },
	[5] = { SizeW = wSize, SizeH = hSize },
	[6] = { SizeW = wSize, SizeH = hSize },
	[7] = { SizeW = wSize, SizeH = hSize },
	[8] = { SizeW = wSize, SizeH = hSize },
	[9] = { SizeW = wSize, SizeH = hSize },
}

function InitializeWeaponFonts ()
	--Unselected
	surface.CreateFontLegacy("HL2MP", ScreenScale(25), 500, true, false, "WeaponUnselectedHL2") -- 30 and 45
	surface.CreateFontLegacy("csd", ScreenScale(25), 500, true, false, "WeaponUnselectedCSS")
	surface.CreateFontLegacy("ZS New", ScreenScale(25), 500, true, false, "WeaponUnselectedZS")
	
	--Selected
	surface.CreateFontLegacy("HL2MP", ScreenScale(35), 500, true, false, "WeaponSelectedHL2")
	surface.CreateFontLegacy("csd", ScreenScale(35), 500, true, false, "WeaponSelectedCSS")
	surface.CreateFontLegacy("ZS New", ScreenScale(35), 500, true, false, "WeaponSelectedZS")
end
hook.Add ( "Initialize", "InitFonts", InitializeWeaponFonts )

local StoredIcons = {}
local storedicons = false
local WeaponSelectionBackground = Material("mrgreen/hud/hudbackground.png") --Items for the HUD.
function PaintNewWeaponSelection()
	if util.tobool(GetConVarNumber("zs_hidehud")) or not IsValid(MySelf) or not MySelf:Alive() or MySelf:Team() ~= TEAM_HUMAN or ENDROUND or not MySelf.ReadySQL then
		return
	end

	if not storedicons then
		for wep,t in pairs(GAMEMODE.HumanWeapons) do
			if killicon.GetImage( wep ) then
				StoredIcons[wep] = surface.GetTextureID( killicon.GetImage( wep ).mat )
			end
		end
		-- PrintTable(StoredIcons)
		storedicons = true
	end
	
	local AmmoStepX,AmmoStepY = ScrW()*0.06,ScrH()*0.18
	local AmmoW,AmmoH = ScrW()*0.05,ScrH()*0.065
	local AmmoX,AmmoY = ScrW()-AmmoW-AmmoStepX*0.5, (ScrH()*1.15)-AmmoH-AmmoStepY*2
	
	MySelf.WepX,MySelf.WepY = AmmoX, AmmoY
	MySelf.WepW,MySelf.WepH = AmmoW, AmmoH

	-- Run the almighty filtering function
	local MyWeapons = FilterWeapons()
	
	-- Reset the IsSlot table before writing anything to it
	for i = 0, MaximumSlots do
		IsSlot[i] = false
	end
	
	for k,v in pairs(MyWeapons) do
		if k <= MaximumSlots then
			if SlotOrder[GetWeaponCategory ( v:GetClass() )] + 1 == k then
				IsSlot[SlotOrder[GetWeaponCategory ( v:GetClass() )]+1] = true			
			end
		end
	end
	
	-- Reset active slots
	for k,v in pairs (IsSlotActive) do
		IsSlotActive[k] = false
	end
	
	-- Make the active weapon panel enlarge!
	local ActiveWeapon = MySelf:GetActiveWeapon()
	if IsValid ( ActiveWeapon ) then
		local Slot = SlotOrder[GetWeaponCategory ( ActiveWeapon:GetClass() )] or 6-- ActiveWeapon.Slot or 6
		for k, wep in pairs ( WeaponsRestricted ) do
			if not string.find ( ActiveWeapon:GetClass(), wep ) then
				IsSlotActive[Slot + 1] = true
			end
		end
	end	
	
		--  Slot 1 - 4 positions!
	local SLOT_POS = {}
	-- Calculate the distance (height) between each
	local Offset = {}
	local counter = 1
	for i = 0,MaximumSlots do
			if IsSlot[MaximumSlots - i] then
					SLOT_POS[MaximumSlots - i] = { PosX = MySelf.WepX, PosY = MySelf.WepY - counter*MySelf.WepH }
					counter = counter + 1
			end
	end

	local AlphaLockTime = 1.5

	--Check if we still need to display the weapons
	--if HideSelectionTime <= (CurTime()-AlphaLockTime) then
		--ShowWeapons = false
	--end
	
	--Return if we don't want it to be displayed
	--if not ShowWeapons then
	--	return
	--end

	--Calculate alpha levels
	local AlphaSelected = math.Clamp((HideSelectionTime - (CurTime()-AlphaLockTime)) / (HideSelectionTime - LastScroll),0,1)
	local AlphaNonSelected = math.Clamp((HideSelectionTime - (CurTime()-(AlphaLockTime/2))) / (HideSelectionTime - LastScroll),0,1)


	--Draw panels
	for i = 0, MaximumSlots do
		if not IsSlot[i] then
			continue
		end

		
		--Specify what alpha formula to use
		local Alpha
		if IsSlotActive[i] then
			Alpha = AlphaSelected
		else
			Alpha = AlphaNonSelected
		end

		--Background	
		--surface.SetMaterial(WeaponSelectionBackground)
		--surface.SetDrawColor(100, 225, 225, 255*Alpha)
		--surface.DrawTexturedRect(SLOT_POS[i].PosX-60, SLOT_POS[i].PosY-400, 340, 175-2, 180)

		if !IsSlotActive[i] and Alpha == 0 then continue end
		
		
		--Weapon icon			
		local ColorToDraw = Color(255, 255, 255, math.Clamp(160*Alpha, 0, 255))
		local NameHeight = SLOT_POS[i].PosY
		FontSize = "ssNewAmmoFont5"		
		
		if IsSlotActive[i] then
			FontSize = "ssNewAmmoFont6"
			NameHeight = NameHeight - ScrH()*0.015
			Alpha = AlphaSelected + 20
			
			local dmg = 0
			local clip1 = 0
			local clip2 = 0
			local clip3 = 0
			if MyWeapons[i] then			
				if MyWeapons[i].Primary.Damage then
					if MyWeapons[i].Primary.NumShots then
						clip1 = MyWeapons[i]:Clip1()
						clip2 = MySelf:GetAmmoCount(MyWeapons[i]:GetPrimaryAmmoType())
						dmg = MyWeapons[i].Primary.Damage * MyWeapons[i].Primary.NumShots
						

					end
				elseif MyWeapons[i].MeleeDamage then					
					dmg = MyWeapons[i].MeleeDamage
					clip3 = MyWeapons[i]:Clip2()
				end
			end
			
			clip1 = MyWeapons[i]:Clip1()

			ColorToDraw = Color(220, 240, 230, math.Clamp(100*Alpha + 155, 0, 255))

		
			if clip1 > 0 || clip2 > 0 then
				draw.SimpleTextOutlined(clip1, "ssNewAmmoFont9", SLOT_POS[i].PosX + ScrW()*0.005, NameHeight + ScrH()*0.021,  ColorToDraw , TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT,1, Color(0, 0, 0, math.Clamp(160*Alpha + 155, 0, 255)))
				
				if clip2 > 0 then
					draw.SimpleTextOutlined(clip2, "ssNewAmmoFont5", SLOT_POS[i].PosX + ScrW()*0.01, NameHeight + ScrH()*0.027,  ColorToDraw , TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0, 0, 0, math.Clamp(160*Alpha + 155, 0, 255)))
				end
								
				if dmg > 0 then
					draw.SimpleTextOutlined("DMG " .. dmg, "ssNewAmmoFont5", SLOT_POS[i].PosX + ScrW()*0.03, NameHeight + ScrH()*0.027,  ColorToDraw , TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0, 0, 0, math.Clamp(160*Alpha + 155, 0, 255)))
				end
				
			elseif clip1 < 1 and clip3 > 0 then
				if dmg > 0 then
					draw.SimpleTextOutlined("DMG " .. dmg, "ssNewAmmoFont5", SLOT_POS[i].PosX + ScrW()*0.02, NameHeight + ScrH()*0.027,  ColorToDraw , TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0, 0, 0, math.Clamp(160*Alpha + 155, 0, 255)))
				end
				
				draw.SimpleTextOutlined(clip3, "ssNewAmmoFont9", SLOT_POS[i].PosX + ScrW()*0.005, NameHeight + ScrH()*0.021,  ColorToDraw , TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT,1, Color(0, 0, 0, math.Clamp(160*Alpha + 155, 0, 255)))
		
			elseif dmg > 0 then
				draw.SimpleTextOutlined("DMG " .. dmg, "ssNewAmmoFont5", SLOT_POS[i].PosX, NameHeight + ScrH()*0.027,  ColorToDraw , TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0, 0, 0, math.Clamp(160*Alpha + 155, 0, 255)))
			end
		end
		
		if MyWeapons[i].HumanClass == "medic" then
			ColorToDraw = Color(100, 230, 130, math.Clamp(160*Alpha, 0, 255))
		elseif MyWeapons[i].HumanClass == "berserker" then
			ColorToDraw = Color(255, 141, 147, math.Clamp(160*Alpha, 0, 255))
		elseif MyWeapons[i].HumanClass == "pyro" then
			ColorToDraw = Color(255, 178, 62, math.Clamp(160*Alpha, 0, 255))		
		elseif MyWeapons[i].HumanClass == "sharpshooter" then
			ColorToDraw = Color(127, 181, 120, math.Clamp(160*Alpha, 0, 255))		
		elseif MyWeapons[i].HumanClass == "commando" then
			ColorToDraw = Color(188, 168, 255, math.Clamp(160*Alpha, 0, 255))		
		elseif MyWeapons[i].HumanClass == "engineer" then
			ColorToDraw = Color(30, 228, 255, math.Clamp(160*Alpha, 0, 255))	
		elseif MyWeapons[i].HumanClass == "support" then
			ColorToDraw = Color(255, 182, 238, math.Clamp(160*Alpha, 0, 255))					
		end
		
		--Weapon name
		draw.SimpleTextOutlined(GAMEMODE.HumanWeapons[MyWeapons[i]:GetClass()].Name, FontSize, SLOT_POS[i].PosX + MySelf.WepW * 1.25, NameHeight, ColorToDraw , TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT,1,Color(0, 0, 0, math.Clamp(160*Alpha + 40, 0, 255)))
	end
end
--hook.Add("HUDPaintBackground", "PaintSelection", PaintNewWeaponSelection)