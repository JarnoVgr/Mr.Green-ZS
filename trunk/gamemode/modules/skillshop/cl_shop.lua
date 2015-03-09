-- Blah. Moved some code from human's and zombie's classes so I can work much easier

local SortByCVar = CreateConVar("zs_skillshop_sort", "available", {FCVAR_ARCHIVE}, "Sort SkillShop items by")

local BuyPointsAmount = GetConVar("zs_skillshop_buypoints_amount")
local BuyPointsCost = GetConVar("zs_skillshop_buypoints_cost")

local IsSkillShopNowOpen = false

WeaponTypeToCategory = {}
WeaponTypeToCategory["rifle"] = "Automatic"
WeaponTypeToCategory["smg"] = "Automatic"
WeaponTypeToCategory["shotgun"] = "Automatic"
WeaponTypeToCategory["pistol"] = "Pistol"
WeaponTypeToCategory["melee"] = "Melee"
WeaponTypeToCategory["tool1"] = "Tool1"
WeaponTypeToCategory["tool2"] = "Tool2"
WeaponTypeToCategory["misc"] = "Misc"
-- WeaponTypeToCategory["others"] = "Others"
WeaponTypeToCategory["explosive"] = "Explosive"
WeaponTypeToCategory["admin"] = "Admin"
WeaponTypeToCategory["christmas"] = "Admin"


local MaxWeaponStats = {}
local WeaponStats = {}

local AlreadyStored = false

function StoreWeaponStats()
	-- max stats
	MaxWeaponStats["Automatic"] = GetMaxWeaponStats("Automatic")
	MaxWeaponStats["Pistol"] = GetMaxWeaponStats("Pistol")
	MaxWeaponStats["Melee"] = GetMaxWeaponStats("Melee")
	
	-- usual stats
	for wep, tab in pairs(GAMEMODE.HumanWeapons) do
		WeaponStats[wep] = GetWeaponStats(wep)
	end
end

function GetMaxWepStats(category)
	return MaxWeaponStats[category] or {0.1, 0.65, 0.1}
end

function GetWepStats(wep)
	return WeaponStats[wep] or {0.1,0.65,0.1}
end

function GetMaxWeaponStats(category)

	local weps = {}
	
	local dmg, acc, rof = 0.1, 0.001, 0.01
	
	for wep,tab in pairs(GAMEMODE.HumanWeapons) do
		if tab.Price then
			if GetWeaponCategory ( wep ) == category then
				table.insert(weps,wep)
			end
		end
	end
	
	-- damage
	for _, weapon in pairs(weps) do
		local tbl = weapons.Get(weapon)
		if tbl then
			if tbl.Primary.Damage and not tbl.IsShotgun then
				local dmg1 = tbl.Primary.Damage
				if tbl.Primary.NumShots then 
					dmg1 = tbl.Primary.Damage * tbl.Primary.NumShots 
					if tbl.IsShotgun then
						dmg1 = dmg1 * 0.15 -- lower a bit so players wont be confused
					end
				end
				
				if dmg1 >= dmg then
					dmg = dmg1
				end
			end
		end
	end
	
	-- accuracy
	for _, weapon in pairs(weps) do
		local tbl = weapons.Get(weapon)
		if tbl then
			if tbl.Cone then
				if tbl.Cone >= acc then
					acc = tbl.Cone
				end
			end
		end
	end
	
	acc = 0.3
	
	-- acc = math.max(0.00001, 1-(acc / 0.8)) * 100
	
	-- RoF
	for _, weapon in pairs(weps) do
		local tbl = weapons.Get(weapon)
		if tbl then
			if tbl.Primary.Delay then
				local r = 1/tbl.Primary.Delay
				if r >= rof then
					rof = r
				end
			end
		end
	end
	-- melee weapons
	if category == "Melee" then
		dmg, acc, rof = 0.1, 0.001, 0.01
		
		-- damage
		for _, weapon in pairs(weps) do
			local tbl = weapons.Get(weapon)
			if tbl then
				if tbl.MeleeDamage then					
					if tbl.MeleeDamage >= dmg then
						dmg = tbl.MeleeDamage
					end
				end
			end
		end
		
		-- reach
		for _, weapon in pairs(weps) do
			local tbl = weapons.Get(weapon)
			if tbl then
				if tbl.MeleeRange then
					if tbl.MeleeRange >= acc then
						acc = tbl.MeleeRange
					end
				end
			end
		end
		
		-- speed overall
		for _, weapon in pairs(weps) do
			local tbl = weapons.Get(weapon)
			if tbl then
				if tbl.Primary.Delay and tbl.SwingTime then
					local total = tbl.SwingTime-- tbl.Primary.Delay +
					if total >= rof then
						rof = total
					end
				end
			end
		end

		rof = 1--1.3
	end
	
	return {dmg, acc, rof}
end

function GetWeaponStats(wep)
	local dmg, acc, rof = 0.1, 0.001, 0.1
	
	local tbl = weapons.Get(wep)
	if tbl then
		if tbl.Primary.Damage then
			local dmg1 = tbl.Primary.Damage
			if tbl.Primary.NumShots then dmg1 = tbl.Primary.Damage * tbl.Primary.NumShots end
			dmg = dmg1
		end
		if tbl.Cone then
			-- acc = math.max(0.00001, 1-(tbl.Cone / 0.8)) * 100
			acc = math.Clamp(0.3-tbl.Cone,0,0.3)
		end
		if tbl.Primary.Delay then
			rof = 1/tbl.Primary.Delay
		end
	end
	
	if GetWeaponCategory(wep) == "Melee" then
		local tbl = weapons.Get(wep)
		if tbl then
			if tbl.MeleeDamage then					
				dmg = tbl.MeleeDamage
			end
			if tbl.MeleeRange then
				acc = tbl.MeleeRange
			end
			if tbl.Primary.Delay and tbl.SwingTime then
				local total = tbl.SwingTime--  tbl.Primary.Delay + 
				rof = math.Clamp(1-total,0,1)
			end
		end	
	end
	
	return {dmg, acc, rof}
end
util.PrecacheSound("UI/buttonrollover.wav")

function InsertWeaponsTab()
	--Primary
	WeaponsList1 = vgui.Create("DScrollPanel")
	WeaponsList1:SetSize(MainSheetW,MainSheetH)
	WeaponsList1:SetSkin("ZSMG")
	WeaponsList1.Paint = function()
	end
	
	--Secondary
	WeaponsList2 = vgui.Create( "DScrollPanel")
	WeaponsList2:SetSize(MainSheetW,MainSheetH)
	WeaponsList2:SetSkin("ZSMG")
	WeaponsList2.Paint = function()
	end
	
	--Melee
	WeaponsList3 = vgui.Create( "DScrollPanel")
	WeaponsList3:SetSize(MainSheetW,MainSheetH)
	WeaponsList3:SetSkin("ZSMG")
	WeaponsList3.Paint = function()
	end

	local WeaponTab = {}
	
	for wep,tab in pairs(GAMEMODE.HumanWeapons) do
	
		if tab.Price then
			
			WeaponTab[wep] = vgui.Create("DLabel")
			
			if GetWeaponCategory ( wep ) == "Automatic" then
				WeaponTab[wep]:SetParent(WeaponsList1)
			elseif GetWeaponCategory ( wep ) == "Pistol" then
				WeaponTab[wep]:SetParent(WeaponsList2)
			elseif GetWeaponCategory ( wep ) == "Melee" then
				WeaponTab[wep]:SetParent(WeaponsList3)
			end
			
			WeaponTab[wep]:SetText("")
			WeaponTab[wep]:SetSkin("ZSMG")
			WeaponTab[wep]:SetSize(MainSheetW,MainSheetH/5)
			WeaponTab[wep]:Dock(TOP)

			WeaponTab[wep].Think = function()
				local SortBy = SortByCVar:GetString()
				if SortBy == "mcheap" then
					WeaponTab[wep]:SetZPos( GAMEMODE.HumanWeapons[wep].Price )
				elseif SortBy == "expensive" then
					WeaponTab[wep]:SetZPos( GAMEMODE.HumanWeapons[wep].Price*-1 )
				elseif SortBy == "onsale" then
					WeaponTab[wep]:SetZPos( IsOnSale(wep) and -2000 or 2000 )
				else --available
					WeaponTab[wep]:SetZPos( GAMEMODE.HumanWeapons[wep].Price <= MySelf:GetScore() and GAMEMODE.HumanWeapons[wep].Price*-1 or GAMEMODE.HumanWeapons[wep].Price )
				end				
			end

			WeaponTab[wep].OnCursorEntered = function() 
				WeaponTab[wep].Overed = true 
				surface.PlaySound ("UI/buttonrollover.wav") 
			end

			WeaponTab[wep].OnCursorExited = function () 
				WeaponTab[wep].Overed = false
			end

			WeaponTab[wep].Paint = function()
				if WeaponTab[wep].Overed then
					surface.SetDrawColor( 255, 255, 255, 255)
					surface.DrawOutlinedRect( 0, 0,WeaponTab[wep]:GetWide(), WeaponTab[wep]:GetTall())
					surface.DrawOutlinedRect( 1, 1, WeaponTab[wep]:GetWide()-2, WeaponTab[wep]:GetTall()-2 )
				else
					surface.SetDrawColor( 30, 30, 30, 200 )
					surface.DrawOutlinedRect( 0, 0,WeaponTab[wep]:GetWide(), WeaponTab[wep]:GetTall())
					surface.SetDrawColor( 30, 30, 30, 255 )
					surface.DrawOutlinedRect( 1, 1, WeaponTab[wep]:GetWide()-2, WeaponTab[wep]:GetTall()-2 )
				end
			
				surface.SetDrawColor( 255, 255, 255, 255) 
				if GAMEMODE.HumanWeapons[wep].Mat then
					draw.SimpleTextOutlined ( GAMEMODE.HumanWeapons[wep].Name, "WeaponNames", 15, 11, Color(255, 255, 255, 255) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
					
					surface.SetTexture(surface.GetTextureID( GAMEMODE.HumanWeapons[wep].Mat ))	
					local wd,hg = surface.GetTextureSize(surface.GetTextureID( GAMEMODE.HumanWeapons[wep].Mat ))
					local dif = (WeaponTab[wep]:GetTall()-23)/hg
					surface.SetDrawColor(190,190,190,255)
					surface.DrawTexturedRect( 5,12, wd*dif, math.Clamp(hg*dif,0,WeaponTab[wep]:GetTall()-23) )
				else
					draw.SimpleTextOutlined ( GAMEMODE.HumanWeapons[wep].Name, "WeaponNames", 15, WeaponTab[wep]:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				end
				--Stats
				local barw,barh = 120, WeaponTab[wep]:GetTall()/6
				local barx, bary = WeaponTab[wep]:GetWide()/2-barw+55, 2*WeaponTab[wep]:GetTall()/6 - barh-- /2
				
				local labels = {}
				labels[1] = {"Damage","Damage"}
				labels[2] = {"Accuracy","Reach"}
				labels[3] = {"Rate of fire","Speed"}
				
				local num = 1
				
				if GetWeaponCategory(wep) == "Melee" then
					num = 2
				end
				
				for i=1, 3 do
					surface.SetDrawColor( 0, 0, 0, 150)
					
					surface.DrawRect(barx, bary, barw,barh )
					surface.DrawRect(barx+2 , bary+2, barw-4, barh-4 )
					
					surface.SetDrawColor(Color(255,255,255,255))
					
					local rel = math.Clamp(GetWepStats(wep)[i]/GetMaxWepStats(GetWeaponCategory(wep))[i],0,1)
					
					surface.DrawRect(barx+2 , bary+2, rel*barw-4, barh-4 )
					
					draw.SimpleTextOutlined ( labels[i][num], "WeaponNamesTiny",  barx-7, bary+barh/2, Color(255, 255, 255, 255) , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))

					bary = bary + barh*1.5		
				end

				---------
				if MySelf:GetScore() < tab.Price then --MySelf.SkillPoints
					draw.SimpleTextOutlined ( GAMEMODE.HumanWeapons[wep].Price.." SP", "ArialBoldSeven",  WeaponTab[wep]:GetWide()/2+70, WeaponTab[wep]:GetTall()/2, Color(180, 11, 11, 255) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255)) -- WeaponTab[wep]:GetWide()/2-35
				else
					draw.SimpleTextOutlined ( GAMEMODE.HumanWeapons[wep].Price.." SP", "ArialBoldSeven",  WeaponTab[wep]:GetWide()/2+70, WeaponTab[wep]:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				end
				-- Add sale thingy
				local Sale = GetSale(wep)
				if Sale then
					local s = surface.GetTextSize ( GAMEMODE.HumanWeapons[wep].Price.." SP" )
					draw.SimpleTextOutlined("(ON SALE: -".. Sale .."%)", "WeaponNames",  WeaponTab[wep]:GetWide()/2+70+s+6, WeaponTab[wep]:GetTall()/2, Color(( math.sin(RealTime() * 5) * 95 ) + 150 , 30, 30, 255) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				end
			end
			
			WeaponTab[wep].Btn = vgui.Create("DButton",WeaponTab[wep])
			WeaponTab[wep].Btn:SetText("Buy it!")
			WeaponTab[wep].Btn:SetSize(70, WeaponTab[wep]:GetTall()/2.3)
			WeaponTab[wep].Btn:SetPos(WeaponTab[wep]:GetWide()-70-50, WeaponTab[wep]:GetTall()/2-WeaponTab[wep].Btn:GetTall()/2)
			
			WeaponTab[wep].Btn.Think = function()
				if MySelf:GetScore() < tab.Price then
					WeaponTab[wep].Btn:SetEnabled(false)
					WeaponTab[wep].Btn:SetDisabled(true)
				else
					WeaponTab[wep].Btn:SetEnabled(true)
					WeaponTab[wep].Btn:SetDisabled(false)
				end
			end
			
			WeaponTab[wep].Btn.DoClick = function()	
				RunConsoleCommand ("zs_skillshop_buy",wep)
			end
		end
	end
	
	MainSheet:AddSheet( "Primary", WeaponsList1, nil, false, false, nil )
	MainSheet:AddSheet( "Pistols", WeaponsList2, nil, false, false, nil )
	MainSheet:AddSheet( "Melee", WeaponsList3, nil, false, false, nil )
end

function InsertAmmoTab()
	AmmoList = vgui.Create( "DScrollPanel")
	AmmoList:SetSize(MainSheetW,MainSheetH)
	AmmoList:SetSkin("ZSMG")
	AmmoList.Paint = function()
	end
	
	ToolList = vgui.Create( "DScrollPanel")
	ToolList:SetSize(MainSheetW,MainSheetH)
	ToolList:SetSkin("ZSMG")
	ToolList.Paint = function()
	end

	local AmmoTab = {}
	
	for ammo,tab in pairs(GAMEMODE.SkillShopAmmo) do
		if tab.Price then			
			AmmoTab[ammo] = vgui.Create("DLabel")
			
			if tab.ToolTab then
				AmmoTab[ammo]:SetParent(ToolList)
			else
				AmmoTab[ammo]:SetParent(AmmoList)
			end
			
			AmmoTab[ammo]:SetText("")
			AmmoTab[ammo]:SetSkin("ZSMG")
			AmmoTab[ammo]:SetSize(MainSheetW,MainSheetH/5)
			
			AmmoTab[ammo]:Dock(TOP)
			AmmoTab[ammo].Think = function()
				local SortBy = SortByCVar:GetString()
				if SortBy == "mcheap" then
					AmmoTab[ammo]:SetZPos(GAMEMODE.SkillShopAmmo[ammo].Price)
				elseif SortBy == "expensive" then
					AmmoTab[ammo]:SetZPos(GAMEMODE.SkillShopAmmo[ammo].Price*-1)
				else --available
					AmmoTab[ammo]:SetZPos(GAMEMODE.SkillShopAmmo[ammo].Price <= MySelf:GetScore() and GAMEMODE.SkillShopAmmo[ammo].Price*-1 or GAMEMODE.SkillShopAmmo[ammo].Price)
				end				
			end
			
			AmmoTab[ammo].OnCursorEntered = function() 
				AmmoTab[ammo].Overed = true 
				surface.PlaySound("UI/buttonrollover.wav") 
			end
			AmmoTab[ammo].OnCursorExited = function () 
				AmmoTab[ammo].Overed = false
			end
			AmmoTab[ammo].Paint = function()
				if AmmoTab[ammo].Overed then
					surface.SetDrawColor( 255, 255, 255, 255)
					surface.DrawOutlinedRect( 0, 0,AmmoTab[ammo]:GetWide(),AmmoTab[ammo]:GetTall())
					surface.DrawOutlinedRect( 1, 1, AmmoTab[ammo]:GetWide()-2, AmmoTab[ammo]:GetTall()-2 )
				else
					surface.SetDrawColor( 30, 30, 30, 200 )
					surface.DrawOutlinedRect( 0, 0,AmmoTab[ammo]:GetWide(), AmmoTab[ammo]:GetTall())
					surface.SetDrawColor( 30, 30, 30, 255 )
					surface.DrawOutlinedRect( 1, 1, AmmoTab[ammo]:GetWide()-2, AmmoTab[ammo]:GetTall()-2 )
				end
			
				surface.SetDrawColor( 255, 255, 255, 255) 
				draw.SimpleTextOutlined(GAMEMODE.SkillShopAmmo[ammo].Name, "WeaponNames", 15, AmmoTab[ammo]:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				if MySelf:GetScore() < tab.Price then
					draw.SimpleTextOutlined(GAMEMODE.SkillShopAmmo[ammo].Price.." SP", "ArialBoldSeven",  AmmoTab[ammo]:GetWide()/2-35, AmmoTab[ammo]:GetTall()/2, Color(180, 11, 11, 255) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				else
					draw.SimpleTextOutlined(GAMEMODE.SkillShopAmmo[ammo].Price.." SP", "ArialBoldSeven",  AmmoTab[ammo]:GetWide()/2-35, AmmoTab[ammo]:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				end
			end
			
			AmmoTab[ammo].Btn = vgui.Create("DButton",AmmoTab[ammo])
			AmmoTab[ammo].Btn:SetText("Buy it!")
			AmmoTab[ammo].Btn:SetSize(70, AmmoTab[ammo]:GetTall()/2.3)
			AmmoTab[ammo].Btn:SetPos(AmmoTab[ammo]:GetWide()-70-50, AmmoTab[ammo]:GetTall()/2-AmmoTab[ammo].Btn:GetTall()/2)
			
			AmmoTab[ammo].Btn.Think = function()
				if MySelf:GetScore() < tab.Price then
					AmmoTab[ammo].Btn:SetEnabled(false)
					AmmoTab[ammo].Btn:SetDisabled(true)
				else
					AmmoTab[ammo].Btn:SetEnabled(true)
					AmmoTab[ammo].Btn:SetDisabled(false)
				end
			end
			
			AmmoTab[ammo].Btn.DoClick = function()	
				RunConsoleCommand("zs_skillshop_buy", ammo)
			end	
		end
	end
	
	MainSheet:AddSheet("Ammunition", AmmoList, nil, false, false, nil)
	MainSheet:AddSheet("Tools", ToolList, nil, false, false, nil)
end

local Sorting = {}
Sorting["available"] = {"Best-Available items on top"}
Sorting["mcheap"] = {"Cheapest items on top"}
Sorting["expensive"] = {"Most Expensive items on top"}
Sorting["onsale"] = {"Discounted items on top"}

function DrawSkillShop()
	if not MySelf:IsHuman() or not MySelf:Alive() or not MySelf:IsNearCrate() then return end
	
	if not AlreadyStored then
		StoreWeaponStats()
		AlreadyStored = true
	end

	TopMenuW,TopMenuH = ScaleW(550), 130 -- ScaleH(136)
	TopMenuX,TopMenuY = w/2-TopMenuW/2,h/5-TopMenuH/1.6

	TopMenuH1 = ScaleH(136)
	
	BlurMenu = vgui.Create("DFrame")
	BlurMenu:SetSize(TopMenuW,TopMenuH)
	BlurMenu:SetPos(TopMenuX,TopMenuY)
	BlurMenu:SetSkin("ZSMG")
	BlurMenu:SetTitle( "Welcome to the SkillShop: For all your Weapons and Supply needs" ) 
	BlurMenu:SetDraggable ( false )
	BlurMenu:SetBackgroundBlur( true )
	BlurMenu:SetSizable(false)
	BlurMenu:SetDraggable(false)
	BlurMenu:ShowCloseButton(false)
	
	local welcomebox = vgui.Create("DTextEntry",BlurMenu)
	welcomebox:SetPos( 5, 25 ) 
	welcomebox:SetSize( TopMenuW-10, TopMenuH-30 ) 
	welcomebox:SetEditable( false )
	welcomebox:SetValue(SKILLSHOP_TEXT)
	welcomebox:SetMultiline( true )
	
	BlurMenu.Think = function ()
		gui.EnableScreenClicker(true)
		
		if MySelf:KeyDown(IN_FORWARD) or MySelf:KeyDown(IN_BACK) or MySelf:KeyDown(IN_MOVELEFT) or MySelf:KeyDown(IN_MOVERIGHT) then
			DoSkillShopMenu()
		end
	end
	
	InvisiblePanel = vgui.Create("DFrame")
	InvisiblePanel:SetSize(w,h)
	InvisiblePanel:SetPos(0,0)
	InvisiblePanel:SetDraggable ( false )
	InvisiblePanel:SetTitle ("")
	InvisiblePanel:SetSkin("ZSMG")
	InvisiblePanel:ShowCloseButton (false)
	InvisiblePanel.Paint = function() 
		-- override this
	end
	
	MainPanelW,MainPanelH = TopMenuW, ScaleH(500)
	
	MainPanel = vgui.Create("DFrame")
	MainPanel:SetSize(MainPanelW,MainPanelH)
	MainPanel:SetPos(TopMenuX,TopMenuY+TopMenuH+ScaleH(20))
	MainPanel:SetDraggable ( false )
	MainPanel:SetTitle("")
	MainPanel:SetSkin("ZSMG")
	MainPanel:ShowCloseButton (false)
	MainPanel:SetDraggable ( false )
	MainPanel:SetSizable(false)
	
	SortingBox = vgui.Create("DComboBox",MainPanel)
	SortingBox:SetSize(180,20)
	SortingBox:SetPos(MainPanelW-1-180,1)
	-- SortingBox:Dock(RIGHT)
	-- SortingBox:DockMargin(0,1,1,0)
	for name,tbl in pairs(Sorting) do
		SortingBox:AddChoice(tbl[1],name)
	end
	
	local def = "available"
	local choice = Sorting[def][1]
	if Sorting[SortByCVar:GetString()] then
		choice = Sorting[SortByCVar:GetString()][1]
	end
	
	SortingBox:ChooseOption(choice)
	
	SortingBox.OnSelect = function(self, ind, val, data)
		if Sorting[data] then
			--Set sorting
			RunConsoleCommand("zs_skillshop_sort",data)
		end
	end
	
	MainSheetW,MainSheetH = MainPanelW-10, MainPanelH-35
	
	MainSheet = vgui.Create( "DPropertySheet", MainPanel )
	MainSheet:SetPos( 5, 30 )
	MainSheet:SetSize( MainSheetW,MainSheetH )
 
	InsertWeaponsTab()
 
	InsertAmmoTab()
	
	CloseButtonX, CloseButtonY = TopMenuX, TopMenuY+TopMenuH+ScaleH(20)+MainPanelH+ScaleH(20) -- nice and shiny
	CloseButtonW, CloseButtonH = TopMenuW/5, ScaleH(76)
	
	local CloseButton = vgui.Create("DButton",InvisiblePanel)
	CloseButton:SetText("")
	CloseButton:SetPos(CloseButtonX, CloseButtonY)
	CloseButton:SetSize (CloseButtonW, CloseButtonH)
	
	CloseButton.PaintOver = function ()
		draw.SimpleTextOutlined("Close" , "ArialBoldTwelve", CloseButtonW/2, CloseButtonH/2, Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end
	CloseButton.DoClick = function()
		DoSkillShopMenu()
	end	
	
	local AmmoButtonX = CloseButtonX + CloseButtonW + ScaleH( 20 )
	local AmmoButtonW = TopMenuW / 2.4
	
	-- Greencoins to Skillpoints button
	local btnAutoBuyAmmo = vgui.Create("DButton", InvisiblePanel)
	btnAutoBuyAmmo:SetText("")
	btnAutoBuyAmmo:SetSkin("ZSMG")
	btnAutoBuyAmmo:SetPos(AmmoButtonX, CloseButtonY)
	btnAutoBuyAmmo:SetSize(AmmoButtonW, CloseButtonH)
	btnAutoBuyAmmo.PaintOver = function( self )
		draw.SimpleTextOutlined("Auto-Buy Ammo", "ArialBoldTwelve", AmmoButtonW / 2, CloseButtonH / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255) )
	end
	btnAutoBuyAmmo.DoClick = function()
		RunConsoleCommand("zs_skillshop_buy", "current-ammo")
	end
	
	--Skillpoints label
	SPLabelX, SPLabelY = AmmoButtonX + AmmoButtonW + ScaleH(20), CloseButtonY
	SPLabelW, SPLabelH = TopMenuW-( CloseButtonW + AmmoButtonW + ScaleH(40) ), CloseButtonH
	
	local SPLabel = vgui.Create("DLabel",InvisiblePanel)
	SPLabel:SetText("")
	SPLabel:SetSkin("ZSMG")
	SPLabel:SetPos(SPLabelX, SPLabelY)
	SPLabel:SetSize(SPLabelW, SPLabelH) 
	SPLabel.Paint = function()
		DrawPanelBlackBox(0, 0, SPLabelW, SPLabelH)
		draw.SimpleTextOutlined(MySelf:GetScore() .." SP", "ArialBoldTwelve", SPLabelW/2, SPLabelH/2, Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end

	btnCoinsToPoints = vgui.Create( "DButton", InvisiblePanel )
	btnCoinsToPoints:SetText("")
	btnCoinsToPoints:SetSkin("ZSMG")
	btnCoinsToPoints:SetPos(SPLabelX, SPLabelY + SPLabelH + 5)
	btnCoinsToPoints:SetSize(SPLabelW, SPLabelH/2)
	
	btnCoinsToPoints.PaintOver = function( self )
		if not MySelf:CanBuyPointsWithCoins() then
			if self:IsVisible() then
				self:SetVisible(false)
			end
		else
			if not self:IsVisible() then
				self:SetVisible(true)
			end
			draw.SimpleTextOutlined("Buy ".. BuyPointsAmount:GetInt() .."SP for ".. BuyPointsCost:GetInt() .."GC", "ArialBoldNine", SPLabelW/2, SPLabelH/4, Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255) )
		end
	end
	
	btnCoinsToPoints.DoClick = function()
		if not MySelf:HasBoughtPointsWithCoins() then
			MySelf:SetBoughtPointsWithCoins(true)
			RunConsoleCommand("zs_skillshop_buypoints")   
		end  
	end
end

function CloseSkillShop()
	--Disable the cursor
	gui.EnableScreenClicker(false)
	
	if IsValid(BlurMenu) then
		BlurMenu:Close()
	end
	
	if IsValid(InvisiblePanel) then
		InvisiblePanel:Close()
	end
	
	if IsValid(MainPanel) then
		MainPanel:Close()
	end
end

function IsSkillShopOpen()
	return IsSkillShopNowOpen
end

function DoSkillShopMenu()
	--Toggle
	IsSkillShopNowOpen = not IsSkillShopNowOpen

	--Inform server
	if not IsSkillShopOpen() then
		net.Start("PlayerSkillShopStatus")
		net.WriteBool(false)
		net.SendToServer()
	end

	--This is not wrong
	if IsSkillShopOpen() then
		--Play funky sound
		surface.PlaySound("items/ammocrate_open.wav")

		--
		DrawSkillShop()
	else
		--Play funky sound
		surface.PlaySound("items/ammocrate_close.wav")

		--
		CloseSkillShop()
	end
end