-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

function MakepShop()
	if pShop then
		pShop:SetVisible(true)
		pShop:MakePopup()
		updateHatList()
		return
	end
	
	local Window = vgui.Create("DFrame")
	local tall = h * 0.95
	Window:SetSize(640, tall)
	local wide = (w - 640) * 0.5
	local tall = (h - tall) * 0.5
	Window:SetPos(wide, tall)
	Window:SetTitle(" ")
	Window:SetSkin("ZSMG")
	Window:SetVisible(true)
	Window:SetDraggable(false)
	Window:MakePopup()
	Window:SetDeleteOnClose(false)
	Window:SetCursor("pointer")
	pShop = Window
	--[=[
	function Window:Paint()
		draw.RoundedBox( 8, 0, 0, 640, Window:GetTall(), Color( 106, 103, 121, 250 ) )
	end
	]=]
	local curItemSelected = ""
	local curHatSelected = ""
	
	local button = vgui.Create("DButton", Window)
	button:SetPos(240, Window:GetTall() - 64)
	button:SetSize(160, 32)
	button:SetText("Close")
	button.DoClick = function(btn) btn:GetParent():SetVisible(false) end
	
	local donbutton = vgui.Create("DButton", Window)
	donbutton:SetPos(420, 320)
	donbutton:SetSize(80, 28)
	donbutton:SetText("Donate!")
	donbutton.DoClick = function(btn) 
		btn:GetParent():SetVisible(false) 
		MakepHelp(5)
	end
	
	local shoplabel = vgui.Create("DLabel",Window)
	shoplabel:SetText( [[HOW TO GET GREEN-COINS:
	
	- Kill a zombie (as human): 1 GC
	
	- Kill a human (as zombie): 3 GC
	
	- Every euro you donate: 1000 GC
	
	]] )
	shoplabel:SetPos( 380, 145 ) 
	shoplabel:SetSize( 180, 200 )
	
	--  SHOP
	
	local itemlistlabel = vgui.Create("DLabel",Window)
	itemlistlabel:SetText( "Shop Items - You currently got "..tostring ( MySelf.TotalUpgrades ).." upgrades over 2000 GC!" )
	itemlistlabel:SetPos( 16, 30 ) 
	itemlistlabel:SizeToContents()
		
	local itemlist = vgui.Create("DComboBox",Window) 
	itemlist:SetPos( 16, 60 ) 
	itemlist:SetSize( 180, Window:GetTall()*0.45 )

	local itemnamelabel = vgui.Create("DLabel",Window)
	itemnamelabel:SetText( "ITEM:" )
	itemnamelabel:SetPos( 220, 60 ) 
	itemnamelabel:SetSize( 180, 22 )
	
	local itemcostlabel = vgui.Create("DLabel",Window)
	itemcostlabel:SetText( "COST:" )
	itemcostlabel:SetPos( 220, 80 ) 
	itemcostlabel:SetSize( 180, 22 )
	
	local itemdesclabel = vgui.Create("DLabel",Window)
	itemdesclabel:SetText( "DESCRIPTION:" )
	itemdesclabel:SetPos( 220, 100 ) 
	itemdesclabel:SetSize( 180, 22 )
	
	local itemdescfield = vgui.Create("DTextEntry",Window)
	itemdescfield:SetText( "< none >" )
	itemdescfield:SetPos( 220, 120 ) 
	itemdescfield:SetSize( 400, 50 )
	itemdescfield:SetEditable( false )
	itemdescfield:SetMultiline( true )
	
	local hatprevlabel = vgui.Create("DLabel",Window)
	hatprevlabel:SetText( "Item preview" )
	hatprevlabel:SetPos( 220, 180 ) 
	hatprevlabel:SetSize( 200, 22 )
	
	local previewmodel = vgui.Create("DModelPanel",Window)
	previewmodel:SetPos( 220, 200 ) 
	previewmodel:SetSize( 150, 150 )
	previewmodel:SetCamPos( Vector( 15, 15, 15 ) )
	previewmodel:SetLookAt( Vector( 0, 0, 0 ) )
	
	local buybutton = vgui.Create("DButton", Window)
	buybutton:SetPos(400, 60)
	buybutton:SetSize(100, 50)
	buybutton:SetText("")
	buybutton.DoClick = function(btn) 
		if curItemSelected == "" then return end
		RunConsoleCommand("mrgreen_buyitem",curItemSelected)
		timer.Simple(0.7,function()
			updateItemList()
			updateHatList()
		end)
	end
	
	local sellbutton = vgui.Create("DButton", Window)
	sellbutton:SetPos(510, 60)
	sellbutton:SetSize(100, 50)
	sellbutton:SetText("")
	sellbutton.DoClick = function(btn) 
		if curItemSelected == "" then return end
		RunConsoleCommand("mrgreen_sellitem",curItemSelected)
		timer.Simple(0.7,function()
			updateItemList()
			updateHatList()
		end)
	end
	
	-- HATS
	
	local hatlistlabel = vgui.Create("DLabel",Window)
	hatlistlabel:SetText( "Hats --------------------------------------------------------------------------------------------------------------------------" )
	hatlistlabel:SetPos( 16, Window:GetTall()*0.45+70 ) 
	hatlistlabel:SetSize( 600, 25 )	

	local hatlist = vgui.Create("DComboBox",Window) 
	hatlist:SetPos( 16, Window:GetTall()*0.45+100 ) 
	hatlist:SetSize( 180, Window:GetTall()-(Window:GetTall()*0.45+100)-100 )
	
	local hatmodellabel = vgui.Create("DLabel",Window)
	hatmodellabel:SetText( "Model preview" )
	hatmodellabel:SetPos( 220, Window:GetTall()*0.45+100 ) 
	hatmodellabel:SetSize( 200, 20 )	
	
	local hatmodel = vgui.Create("DModelPanel",Window)
	hatmodel:SetPos( 220, Window:GetTall()*0.45+120 ) 
	hatmodel:SetSize( 150, 150 )
	hatmodel:SetCamPos( Vector( 15, 15, 15 ) )
	hatmodel:SetLookAt( Vector( 0, 0, 0 ) )

	local hatmodellabel = vgui.Create("DLabel",Window)
	hatmodellabel:SetText( "Current hat" )
	hatmodellabel:SetPos( 400, Window:GetTall()*0.45+100 ) 
	hatmodellabel:SetSize( 200, 20 )
		
	local curhatmodel = vgui.Create("DModelPanel",Window)
	curhatmodel:SetPos( 400, Window:GetTall()*0.45+120 ) 
	curhatmodel:SetSize( 150, 150 )
	curhatmodel:SetCamPos( Vector( 15, 15, 15 ) )
	curhatmodel:SetLookAt( Vector( 0, 0, 0 ) )
	
	local button = vgui.Create("DButton", Window)
	button:SetPos(250, Window:GetTall()*0.45+270)
	button:SetSize(90, 24)
	button:SetText("Set hat")
	button.DoClick = function(btn)
		if curHatSelected == "" or MySelf:Team() == TEAM_UNDEAD then return end
		RunConsoleCommand("mrgreen_hat_set",curHatSelected)
		timer.Simple(0.7,function()
			updateHatList()
		end)
	end
	
	local button = vgui.Create("DButton", Window)
	button:SetPos(430, Window:GetTall()*0.45+270)
	button:SetSize(90, 24)
	button:SetText("Drop hat")
	button.DoClick = function(btn) 
		if not ValidEntity(LocalPlayer().Hat) then return end
		RunConsoleCommand("mrgreen_hat_drop")
		timer.Simple(0.7,function()
			updateHatList()
		end)
	end
	
	--[=[-------------------------------
				Functions
	-------------------------------]=]
	
	function updateItemList()
		itemlist:Clear()
		local item
		for k, v in pairs(shopData) do
			local itemID = util.GetItemID( k )
			if not shopData[k].AdminOnly or MySelf:IsAdmin() then
				if MySelf.DataTable["ShopItems"][k] then
					item = itemlist:AddItem( v.Name.." (BOUGHT)" )
				else
					item = itemlist:AddItem( v.Name )
				end
				
				item.ItemType = k
				item.DoClick = itemDoClick
				shopData[k].Item = item
			end
		end
		
		-- Select a item if not already selected
		local itemID = curItemSelected
		if not shopData[itemID] then
			shopData[util.GetItemID( "egg" )].Item:Select() -- Calls DoClick
			itemlist:SelectItem(shopData[util.GetItemID( "egg" )].Item)
		else
			shopData[itemID].Item:Select() -- Calls DoClick
			itemlist:SelectItem(shopData[itemID].Item)	
		end
		
		
	end
	
	function updateHatList()
		hatlist:Clear()
		local hat
		for k, v in pairs(hats) do --  correct to the ones that were bought
			local itemID = util.GetItemID( k )
			if MySelf.DataTable["ShopItems"][itemID] then
				hat = hatlist:AddItem( shopData[itemID].Name )
				hat.HatType = k
				hat.DoClick = hatDoClick
				hats[k].Item = hat
			end
		end
		
		if hat then -- Select a hat if not already selected
			if not hats[curHatSelected] then
				hat:Select() -- Calls DoClick
				itemlist:SelectItem(hat)
			else
				hats[curHatSelected].Item:Select()
				itemlist:SelectItem(hats[curHatSelected].Item)
			end
		end
		
		-- Update the model of the hat you're currently wearing
		if ValidEntity(LocalPlayer().Hat) then
			local model = MySelf.Hat:GetModel()
			
			if model == "models/nova/w_headcrab.mdl" then
				curhatmodel:SetModel("models/headcrabclassic.mdl")
				curhatmodel:SetCamPos (Vector (15,35,15))  
			else
				curhatmodel:SetModel(MySelf.Hat:GetModel())
				curhatmodel:SetCamPos (Vector (15,15,15)) 
			end
			
			local hatname = shopData[ util.GetItemID( MySelf.Hat:GetHatType() ) ].Name or "Unknown"
			curhatmodel:SetText( hatname )
		else
			if ( IsValid( curhatmodel.Entity ) ) then
				curhatmodel.Entity:Remove()
				curhatmodel.Entity = nil		
			end
			if MySelf:Team() == TEAM_HUMAN then
				curhatmodel:SetText("None")
			else
				curhatmodel:SetText("Zombie can't wear hats.\nThey don't even fit.")
			end
		end
	end
	
	--[=[--------------------------------
		DoClick functions and others
	--------------------------------]=]
	
	function itemDoClick(btn)
		local item = btn.ItemType
		
		curItemSelected = item
		local k = item
		local itemID = util.GetItemTableByKey( item )
		if (shopData[k].Cost == 0) then
			itemcostlabel:SetText("COST: -")
		else
			itemcostlabel:SetText("COST: "..shopData[k].Cost.." GC")
		end
		itemnamelabel:SetText("ITEM: "..shopData[k].Name)
		itemdescfield:SetText(shopData[k].Desc)
		
		if (MySelf.DataTable["ShopItems"][k] and shopData[k].Sell > 0) then
			buybutton:SetDisabled(true)
			sellbutton:SetDisabled(false)
			sellbutton:SetText("Sell this\nfor ".. shopData[k].Sell .." GC")
			buybutton:SetText("You got\nthis already!")
		elseif (MySelf.DataTable["ShopItems"][k]) then
			buybutton:SetDisabled(true)
			sellbutton:SetDisabled(true)
			sellbutton:SetText("")
			buybutton:SetText("You got\nthis already!")
		elseif (shopData[k].Cost == -1) then -- No buyable anymore
			buybutton:SetDisabled(true) -- disable button if you can't buy it
			sellbutton:SetDisabled(true)
			sellbutton:SetText("")
			buybutton:SetText("Can't be bought\nat this moment")
		elseif (MySelf:GreenCoins() < shopData[k].Cost) then
			buybutton:SetDisabled(true) -- disable button if you can't buy it
			sellbutton:SetDisabled(true)
			sellbutton:SetText("")
			buybutton:SetText("You're too poor")
		elseif shopData[k].Requires and MySelf.TotalUpgrades < shopData[k].Requires then
			buybutton:SetDisabled(true)
			sellbutton:SetDisabled(true)
			sellbutton:SetText("")
			buybutton:SetText("You need "..(shopData[k].Requires-MySelf.TotalUpgrades).."\nupgrade(s) to \nbuy this!")
		elseif (shopData[k].Requires and MySelf.TotalUpgrades >= shopData[k].Requires) and (shopData[k].NeedUpgrade and not MySelf:HasBought(shopData[k].NeedUpgrade)) then
			buybutton:SetDisabled(true)
			sellbutton:SetText("")
			sellbutton:SetDisabled(true)
			buybutton:SetText("You need \n"..shopData[shopData[k].NeedUpgrade].Name.."to \nbuy this!")
		else
			buybutton:SetDisabled(false)
			sellbutton:SetText("")
			sellbutton:SetDisabled(true)
			buybutton:SetText("Buy this item!")
		end
		
		-- Set hat preview if a hat is selected
		if (hats[itemID]) then
			if hats[itemID].Model == "models/Nova/w_headcrab.mdl" then
				previewmodel:SetModel("models/headcrabclassic.mdl")
				previewmodel:SetCamPos (Vector (15,35,15))  
			else
				previewmodel:SetModel(hats[itemID].Model)
				previewmodel:SetCamPos (Vector (15,15,15)) 
			end

			previewmodel:SetText(shopData[k].Name)
		else
			if ( IsValid( previewmodel.Entity ) ) then
				previewmodel.Entity:Remove()
				previewmodel.Entity = nil		
			end
			previewmodel:SetText("Not available")
		end
	end
	
	function hatDoClick(btn)
		local hat = btn.HatType
		
		curHatSelected = hat
		if hat == "crab" then
			hatmodel:SetModel("models/headcrabclassic.mdl") --  update model view
			hatmodel:SetCamPos (Vector (15,35,15)) 
		else
			hatmodel:SetModel(hats[hat].Model) --  update model view
			hatmodel:SetCamPos (Vector (15,15,15)) 
		end
		local itemID = util.GetItemID( hat )
		hatmodel:SetText(shopData[itemID].Name)
	end
	
	updateHatList()
	updateItemList()
end

-----------------------------------------------------------------------------------------------------------------

-- Stuff
CreateClientConVar("_zs_previewrotation", 35, true, false)

local function HatsToString()
	local str = ""
	for k, hat in pairs(CurrentHats) do
		str = str.."$"..hat
	end
	return str
end

local function GetCurrentHatId(str)
	for k, hat in pairs(CurrentHats) do
		if hat == str then
			return k
		end
	end
end

function GetActualHats()
	local c = 0
	for k,v in pairs(CurrentHats) do
		if hats[v] then
			c = c + 1
		end
	end
	return c
end

local tf2_icon = Material("games/16/tf.png")

function InsertHats()
	
	HatList = vgui.Create( "DPanelList")
	HatList:SetSize(ShopSheetW,ShopSheetH)
	HatList:SetSkin("ZSMG")
	HatList:SetSpacing(0)
	HatList:SetPadding(0)
	HatList:EnableHorizontal( false )
	HatList:EnableVerticalScrollbar( true )
	HatList.Paint = function()
	
	end
	
	local HatTab = {}
	
	for key, tab in pairs(shopData) do
		-- not hidden and hat
		if (tab.Type and (tab.Type == "hat" or tab.Type == "other")) and not tab.Hidden and (not tab.AdminOnly or MySelf:IsAdmin()) and (not tab.EventOnly or MySelf.DataTable["ShopItems"][tab.ID]) then
			local itemID = tab.Key
			HatTab[itemID] = vgui.Create("DLabel")
			HatTab[itemID]:SetText("")
			HatTab[itemID]:SetSkin("ZSMG")
			HatTab[itemID]:SetSize(ShopSheetW,ShopSheetH/4.5)
			HatTab[itemID].TF2 = string.find(hats[itemID] and hats[itemID]["1"] and hats[itemID]["1"].model or " ","models/player/items")
			HatTab[itemID].OnCursorEntered = function() 
				HatTab[itemID].Overed = true 
				surface.PlaySound ("UI/buttonrollover.wav") 
			end
			HatTab[itemID].OnCursorExited = function () 
				HatTab[itemID].Overed = false
			end
			
			HatTab[itemID].OnMousePressed = function () 
				SelectedItem = tab
				UpdateModelPanel()
			end
			
			HatTab[itemID].Paint = function()
			
				draw.SimpleTextOutlined ( tab.Name, "WeaponNames", 10,HatTab[itemID]:GetTall()/6, Color(255, 255, 255, 255) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				if MySelf.DataTable["ShopItems"][tab.ID] then
					if GetCurrentHatId(tab.Key) then
						draw.SimpleTextOutlined ( "EQUIPPED "..(GetActualHats() or 0).."/4", "WeaponNames", HatTab[itemID]:GetWide() - 140,HatTab[itemID]:GetTall()/6, Color(35, 255, 35, 255) , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
					else
						draw.SimpleTextOutlined ( "PURCHASED!", "WeaponNames", HatTab[itemID]:GetWide() - 140,HatTab[itemID]:GetTall()/6, Color(35, 155, 35, 255) , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
					end
				else
					draw.SimpleTextOutlined ( "Price: "..tab.Cost, "WeaponNames", HatTab[itemID]:GetWide() - 140,HatTab[itemID]:GetTall()/6, Color(255, 255, 255, 255) , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				end
				
				if HatTab[itemID].Overed then
					surface.SetDrawColor( 255, 255, 255, 255)
					surface.DrawOutlinedRect( 0, 0,HatTab[itemID]:GetWide(), HatTab[itemID]:GetTall())
					surface.DrawOutlinedRect( 1, 1, HatTab[itemID]:GetWide()-2, HatTab[itemID]:GetTall()-2 )
				else
					surface.SetDrawColor( 30, 30, 30, 200 )
					surface.DrawOutlinedRect( 0, 0,HatTab[itemID]:GetWide(), HatTab[itemID]:GetTall())
					surface.SetDrawColor( 30, 30, 30, 255 )
					surface.DrawOutlinedRect( 1, 1, HatTab[itemID]:GetWide()-2, HatTab[itemID]:GetTall()-2 )
				end
				if HatTab[itemID].TF2 then
					surface.SetDrawColor( 155, 155, 155, 255)
					surface.SetMaterial(tf2_icon)
					surface.DrawTexturedRect(HatTab[itemID]:GetWide()-35-100,(HatTab[itemID]:GetTall()/6)/2,16,16)
				end
			end
			
			-- Description
			HatTab[itemID].Desc = vgui.Create("DTextEntry",HatTab[itemID])
			HatTab[itemID].Desc:SetPos( 10, 2.3*HatTab[itemID]:GetTall()/6 ) 
			HatTab[itemID].Desc:SetSize( HatTab[itemID]:GetWide()-45, HatTab[itemID]:GetTall()/2 ) 
			HatTab[itemID].Desc:SetEditable( false )
			HatTab[itemID].Desc:SetValue(tab.Desc or [[No data!]])
			HatTab[itemID].Desc:SetMultiline( true )
			
			-- Button
			
			HatTab[itemID].Btn = vgui.Create("DButton",HatTab[itemID])
			HatTab[itemID].Btn:SetSize(100, HatTab[itemID]:GetTall()/5)
			HatTab[itemID].Btn:SetPos(HatTab[itemID]:GetWide()-35-100, (HatTab[itemID]:GetTall()/6)/2)
			HatTab[itemID].Btn.Think = function()
				if MySelf.DataTable["ShopItems"][tab.ID] then
					if ValidEntity(MySelf.Hat) then 
						if GetCurrentHatId(tab.Key) then-- MySelf.Hat:GetHatType() == tab.Key
							HatTab[itemID].Btn:SetText("Drop")
						else
							HatTab[itemID].Btn:SetText("Equip")
						end
					else
						HatTab[itemID].Btn:SetText("Equip")
					end
					HatTab[itemID].Btn:SetEnabled(true)
					HatTab[itemID].Btn:SetDisabled(false)
				else
					if MySelf:GreenCoins() < tab.Cost then
						HatTab[itemID].Btn:SetText("You're too poor")
						
						HatTab[itemID].Btn:SetEnabled(false)
						HatTab[itemID].Btn:SetDisabled(true)
					else
						HatTab[itemID].Btn:SetText("Buy this shit!")
						
						HatTab[itemID].Btn:SetEnabled(true)
						HatTab[itemID].Btn:SetDisabled(false)
					end
				end
			end
			
			HatTab[itemID].Btn.OnMousePressed = function()
				if MySelf.DataTable["ShopItems"][tab.ID] then
					-- Drop
					if ValidEntity(MySelf.Hat) then 
						if GetCurrentHatId(tab.Key) then-- MySelf.Hat:GetHatType() == tab.KeyCurrentHats[tab.Key]
							CurrentHats[GetCurrentHatId(tab.Key)] = nil
							RunConsoleCommand("mrgreen_hat_drop")
							RunConsoleCommand("_zs_equippedhats",HatsToString())
							if #CurrentHats > 0 then
								RunConsoleCommand("mrgreen_hat_set",HatsToString())
							end
						else
							if not MySelf:IsZombie() then
								if not table.HasValue(CurrentHats,tab.Key) and GetActualHats() < 4 then
									if PureHats[tab.Key] then
										for k,v in pairs(CurrentHats) do
											if PureHats[v] then
												CurrentHats[k] = nil
											end
										end
									end
									table.insert(CurrentHats,tab.Key)
									RunConsoleCommand("_zs_equippedhats",HatsToString())
									RunConsoleCommand("mrgreen_hat_set",HatsToString())
								end
							end
						end
					else
						if not MySelf:IsZombie() then
							if not table.HasValue(CurrentHats,tab.Key) and GetActualHats() < 4 then
								table.insert(CurrentHats,tab.Key)
								RunConsoleCommand("_zs_equippedhats",HatsToString())
								RunConsoleCommand("mrgreen_hat_set",HatsToString())
							end
						end
					end
				else
					if MySelf:GreenCoins() >= tab.Cost then
						Derma_Query("Purchase this item? '"..tab.Name.."'", "Warning!","Yes!",function() RunConsoleCommand("mrgreen_buyitem",tab.ID) end, "No", function() end)
						
						-- RunConsoleCommand("mrgreen_buyitem",tab.ID)
					end
				end
			end
			-- add
			HatList:AddItem(HatTab[itemID])
			
		end
	end
	ShopSheet:AddSheet( "Hats and Accessories", HatList, nil, false, false, nil )

end

-- suits
function InsertSuits()
	
	SuitList = vgui.Create( "DPanelList")
	SuitList:SetSize(ShopSheetW,ShopSheetH)
	SuitList:SetSkin("ZSMG")
	SuitList:SetSpacing(0)
	SuitList:SetPadding(0)
	SuitList:EnableHorizontal( false )
	SuitList:EnableVerticalScrollbar( true )
	SuitList.Paint = function()
	
	end
	
	local SuitTab = {}
	
	for key, tab in pairs(shopData) do
		-- not hidden and hat
		if (tab.Type and tab.Type == "suit") and not tab.Hidden and (not tab.AdminOnly or MySelf:IsAdmin()) then
			local itemID = tab.Key
			SuitTab[itemID] = vgui.Create("DLabel")
			SuitTab[itemID]:SetText("")
			SuitTab[itemID]:SetSkin("ZSMG")
			SuitTab[itemID]:SetSize(ShopSheetW,ShopSheetH/4.5)
			SuitTab[itemID].OnCursorEntered = function() 
				SuitTab[itemID].Overed = true 
				surface.PlaySound ("UI/buttonrollover.wav") 
			end
			SuitTab[itemID].OnCursorExited = function () 
				SuitTab[itemID].Overed = false
			end
			
			SuitTab[itemID].OnMousePressed = function () 
				SelectedItem = tab
				UpdateModelPanel()
			end
			
			SuitTab[itemID].Paint = function()
			
				draw.SimpleTextOutlined ( tab.Name, "WeaponNames", 10,SuitTab[itemID]:GetTall()/6, Color(255, 255, 255, 255) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				
				if MySelf.DataTable["ShopItems"][tab.ID] then
					draw.SimpleTextOutlined ( "PURCHASED!", "WeaponNames", SuitTab[itemID]:GetWide() - 140,SuitTab[itemID]:GetTall()/6, Color(35, 155, 35, 255) , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				else
					draw.SimpleTextOutlined ( "Price: "..tab.Cost, "WeaponNames", SuitTab[itemID]:GetWide() - 140,SuitTab[itemID]:GetTall()/6, Color(255, 255, 255, 255) , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				end
				
				if SuitTab[itemID].Overed then
					surface.SetDrawColor( 255, 255, 255, 255)
					surface.DrawOutlinedRect( 0, 0,SuitTab[itemID]:GetWide(), SuitTab[itemID]:GetTall())
					surface.DrawOutlinedRect( 1, 1, SuitTab[itemID]:GetWide()-2, SuitTab[itemID]:GetTall()-2 )
				else
					surface.SetDrawColor( 30, 30, 30, 200 )
					surface.DrawOutlinedRect( 0, 0,SuitTab[itemID]:GetWide(), SuitTab[itemID]:GetTall())
					surface.SetDrawColor( 30, 30, 30, 255 )
					surface.DrawOutlinedRect( 1, 1, SuitTab[itemID]:GetWide()-2, SuitTab[itemID]:GetTall()-2 )
				end
			end
			
			-- Description
			SuitTab[itemID].Desc = vgui.Create("DTextEntry",SuitTab[itemID])
			SuitTab[itemID].Desc:SetPos( 10, 2.3*SuitTab[itemID]:GetTall()/6 ) 
			SuitTab[itemID].Desc:SetSize( SuitTab[itemID]:GetWide()-45, SuitTab[itemID]:GetTall()/2 ) 
			SuitTab[itemID].Desc:SetEditable( false )
			SuitTab[itemID].Desc:SetValue(tab.Desc or [[No data!]])
			SuitTab[itemID].Desc:SetMultiline( true )
			
			-- Button
			
			SuitTab[itemID].Btn = vgui.Create("DButton",SuitTab[itemID])
			SuitTab[itemID].Btn:SetSize(100, SuitTab[itemID]:GetTall()/5)
			SuitTab[itemID].Btn:SetPos(SuitTab[itemID]:GetWide()-35-100, (SuitTab[itemID]:GetTall()/6)/2)
			SuitTab[itemID].Btn.Think = function()
				if MySelf.DataTable["ShopItems"][tab.ID] then
					if ValidEntity(MySelf.Suit) then  
						if MySelf.Suit:GetHatType() == tab.Key then
							SuitTab[itemID].Btn:SetText("Drop")
						else
							SuitTab[itemID].Btn:SetText("Equip")
						end
					else
						SuitTab[itemID].Btn:SetText("Equip")
					end
					SuitTab[itemID].Btn:SetEnabled(true)
					SuitTab[itemID].Btn:SetDisabled(false)
				else
					if MySelf:GreenCoins() < tab.Cost then
						SuitTab[itemID].Btn:SetText("You're too poor")
						
						SuitTab[itemID].Btn:SetEnabled(false)
						SuitTab[itemID].Btn:SetDisabled(true)
					else
						SuitTab[itemID].Btn:SetText("Buy this shit!")
						
						SuitTab[itemID].Btn:SetEnabled(true)
						SuitTab[itemID].Btn:SetDisabled(false)
					end
				end
			end
			
			SuitTab[itemID].Btn.OnMousePressed = function()
				if MySelf.DataTable["ShopItems"][tab.ID] then
					-- Drop
					if ValidEntity(MySelf.Suit) then  
						if MySelf.Suit:GetHatType() == tab.Key then
							RunConsoleCommand("mrgreen_suit_drop")
						else
							if not MySelf:IsZombie() then
								RunConsoleCommand("mrgreen_suit_set",tab.Key)
							end
						end
					else
						if not MySelf:IsZombie() then
							RunConsoleCommand("mrgreen_suit_set",tab.Key)
						end
					end
				else
					if MySelf:GreenCoins() >= tab.Cost then
						-- RunConsoleCommand("mrgreen_buyitem",tab.ID)
						Derma_Query("Purchase this item? '"..tab.Name.."'", "Warning!","Yes!",function() RunConsoleCommand("mrgreen_buyitem",tab.ID) end, "No", function() end)
					end
				end
			end
			-- add
			SuitList:AddItem(SuitTab[itemID])
			
		end
	end
	ShopSheet:AddSheet( "Suits", SuitList, nil, false, false, nil )

end

-- misc
function InsertOther()
	
	MiscList = vgui.Create( "DPanelList")
	MiscList:SetSize(ShopSheetW,ShopSheetH)
	MiscList:SetSkin("ZSMG")
	MiscList:SetSpacing(0)
	MiscList:SetPadding(0)
	MiscList:EnableHorizontal( false )
	MiscList:EnableVerticalScrollbar( true )
	MiscList.Paint = function()
	
	end
	
	local MiscTab = {}
	
	for key, tab in pairs(shopData) do
		-- not hidden and hat
		if (tab.Type and tab.Type == "misc") and not tab.Hidden and (not tab.AdminOnly or MySelf:IsAdmin()) then
			local itemID = tab.Key
			MiscTab[itemID] = vgui.Create("DLabel")
			MiscTab[itemID]:SetText("")
			MiscTab[itemID]:SetSkin("ZSMG")
			MiscTab[itemID]:SetSize(ShopSheetW,ShopSheetH/4.5)
			MiscTab[itemID].OnCursorEntered = function() 
				MiscTab[itemID].Overed = true 
				surface.PlaySound ("UI/buttonrollover.wav") 
			end
			MiscTab[itemID].OnCursorExited = function () 
				MiscTab[itemID].Overed = false
			end
			
			MiscTab[itemID].OnMousePressed = function () 
				SelectedItem = tab
				UpdateModelPanel()
			end
			
			MiscTab[itemID].Paint = function()
			
				draw.SimpleTextOutlined ( tab.Name, "WeaponNames", 10,MiscTab[itemID]:GetTall()/6, Color(255, 255, 255, 255) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				
				if MySelf.DataTable["ShopItems"][tab.ID] then
					draw.SimpleTextOutlined ( "PURCHASED!", "WeaponNames", MiscTab[itemID]:GetWide() - 140,MiscTab[itemID]:GetTall()/6, Color(35, 155, 35, 255) , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				else
					draw.SimpleTextOutlined ( "Cost: "..tab.Cost .." GC", "WeaponNames", MiscTab[itemID]:GetWide() - 140,MiscTab[itemID]:GetTall()/6, Color(255, 255, 255, 255) , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				end
				
				if MiscTab[itemID].Overed then
					surface.SetDrawColor( 255, 255, 255, 255)
					surface.DrawOutlinedRect( 0, 0,MiscTab[itemID]:GetWide(), MiscTab[itemID]:GetTall())
					surface.DrawOutlinedRect( 1, 1, MiscTab[itemID]:GetWide()-2, MiscTab[itemID]:GetTall()-2 )
				else
					surface.SetDrawColor( 30, 30, 30, 200 )
					surface.DrawOutlinedRect( 0, 0,MiscTab[itemID]:GetWide(), MiscTab[itemID]:GetTall())
					surface.SetDrawColor( 30, 30, 30, 255 )
					surface.DrawOutlinedRect( 1, 1, MiscTab[itemID]:GetWide()-2, MiscTab[itemID]:GetTall()-2 )
				end
			end
			
			-- Description
			MiscTab[itemID].Desc = vgui.Create("DTextEntry",MiscTab[itemID])
			MiscTab[itemID].Desc:SetPos( 10, 2.3*MiscTab[itemID]:GetTall()/6 ) 
			MiscTab[itemID].Desc:SetSize( MiscTab[itemID]:GetWide()-45, MiscTab[itemID]:GetTall()/2 ) 
			MiscTab[itemID].Desc:SetEditable( false )
			MiscTab[itemID].Desc:SetValue(tab.Desc or [[No data!]])
			MiscTab[itemID].Desc:SetMultiline( true )
			
			-- Button
			
			MiscTab[itemID].Btn = vgui.Create("DButton",MiscTab[itemID])
			MiscTab[itemID].Btn:SetSize(100, MiscTab[itemID]:GetTall()/5)
			MiscTab[itemID].Btn:SetPos(MiscTab[itemID]:GetWide()-35-100, (MiscTab[itemID]:GetTall()/6)/2)
			MiscTab[itemID].Btn.Think = function()
				if MySelf.DataTable["ShopItems"][tab.ID] then
					MiscTab[itemID].Btn:SetText("You have this already")
					
					MiscTab[itemID].Btn:SetEnabled(false)
					MiscTab[itemID].Btn:SetDisabled(true)
				else
					if MySelf:GreenCoins() < tab.Cost then
						MiscTab[itemID].Btn:SetText("You're too poor")
						
						MiscTab[itemID].Btn:SetEnabled(false)
						MiscTab[itemID].Btn:SetDisabled(true)
					else
						MiscTab[itemID].Btn:SetText("BUY")
						
						MiscTab[itemID].Btn:SetEnabled(true)
						MiscTab[itemID].Btn:SetDisabled(false)
					end
				end
			end
			
			MiscTab[itemID].Btn.OnMousePressed = function()
				if MySelf.DataTable["ShopItems"][tab.ID] then
				-- nothing
				else
					if MySelf:GreenCoins() >= tab.Cost then
						-- RunConsoleCommand("mrgreen_buyitem",tab.ID)
						Derma_Query("Purchase this item? '"..tab.Name.."'", "Warning!","Yes!",function() RunConsoleCommand("mrgreen_buyitem",tab.ID) end, "No", function() end)
					end
				end
			end
			-- add
			MiscList:AddItem(MiscTab[itemID])
			
		end
	end
	ShopSheet:AddSheet( "Misc", MiscList, nil, false, false, nil )

end

---------------------------------------------------
RenderOrder = nil

local function GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel ~= "") then
			
			local v = basetab[tab.rel]
			
			if (not v) then return end

			pos, ang = GetBoneOrientation( basetab, v, ent )
			
			if (not pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (not bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
		end
		
		return pos, ang
end

function DrawModels(self)
	
	if (not self.Hat) then return end
		
		if (not RenderOrder) then

			RenderOrder = {}

			for k, v in pairs( self.Hat ) do
				if (v.type == "Model") then
					table.insert(RenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(RenderOrder, k)
				end
			end

		end
		
		if (ValidEntity(self.Entity)) then
			bone_ent = self.Entity
		end
		
		for k, name in pairs( RenderOrder ) do
		
			local v = self.Hat[name]
			if (not v) then RenderOrder = nil break end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = GetBoneOrientation( self.Hat, v, bone_ent )
			else
				pos, ang = GetBoneOrientation( self.Hat, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (pos) then 
			
    			local model = v.modelEnt
    			local sprite = v.spriteMaterial
    			
    			if (v.type == "Model" and ValidEntity(model)) then
    
    				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
    				ang:RotateAroundAxis(ang:Up(), v.angle.y)
    				ang:RotateAroundAxis(ang:Right(), v.angle.p)
    				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
    
    				local size = (v.size.x + v.size.y + v.size.z)/3
    				
    				model:SetAngles(ang)
    				model:SetModelScale(size,0)
    				
    				if (v.material == "") then
    					model:SetMaterial("")
    				elseif (model:GetMaterial() ~= v.material) then
    					model:SetMaterial( v.material )
    				end
    				
    				if (v.skin and v.skin ~= model:GetSkin()) then
    					model:SetSkin(v.skin)
    				end
    				
    				if (v.bodygroup) then
    					for k, v in pairs( v.bodygroup ) do
    						if (model:GetBodygroup(k) ~= v) then
    							model:SetBodygroup(k, v)
    						end
    					end
    				end
    				
    				if (v.surpresslightning) then
    				-- 	render.SuppressEngineLighting(true)
    				end
    				
    				-- render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
    				-- render.SetBlend(v.color.a/255)
    				model:DrawModel()
    				-- render.SetBlend(1)
    				-- render.SetColorModulation(1, 1, 1)
    				
    				if (v.surpresslightning) then
    				-- 	render.SuppressEngineLighting(false)
    				end
    				
    			elseif (v.type == "Sprite" and sprite) then
    				
    				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
    				render.SetMaterial(sprite)
    				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
    			end
			end
		end
	
end

---------------------------------------------------

function CreateModels(self,tab)
	RenderOrder = nil
	-- self.
	if type(self.Hat) == "table" then
		for k, v in pairs( self.Hat ) do
			if (ValidEntity( v.modelEnt )) then v.modelEnt:Remove() end
		end
		self.Hat.Key = nil 
		self.Hat = nil  
	end
	if not tab then return end
	if not tab.Type then return end
	
	local tbl = hats
	
	if tab.Type == "suit" then
		tbl = suits
	end
	
	local key = tab.Key
		
	if not tbl[key] then return end
	
	self.Hat = table.Copy(tbl[key]) or {}
	
	-- PrintTable(self.Hat)
	
	for k, v in pairs( self.Hat ) do
			if (v.type == "Model" and v.model and v.model ~= "" and (not ValidEntity(v.modelEnt) or v.createdModel ~= v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model,"GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (ValidEntity(v.modelEnt)) then
					v.modelEnt:SetPos(self.Entity:GetPos())
					v.modelEnt:SetAngles(self.Entity:GetAngles())
					v.modelEnt:SetParent(self.Entity)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
					v.modelEnt.SuitProp = true
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite ~= "" and (not v.spriteMaterial or v.createdSprite ~= v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt","GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				--  make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
	
	
	
end



function CreateHat(self,tab)
	if ( IsValid( self.Hat ) ) then
		self.Hat:Remove()
		self.Hat.Key = nil 
		self.Hat = nil  
	else
		if type(self.Hat) == "table" then
			for i, stuff in pairs(self.Hat) do
				stuff:Remove()
			end
			self.Hat.Key = nil 
			self.Hat = nil  
		end
	end
	if not tab then return end
	if not tab.Type then return end
	if tab.Type == "hat" then 
		local key = tab.Key
		
		if not hats[key] then return end
		
		self.Hat = ClientsideModel( hats[key].Model, RENDER_GROUP_OPAQUE_ENTITY )
		if ( not IsValid(self.Hat) ) then return end
		
		self.Hat.Key = key
		
		self.Hat:SetNoDraw( true )
		self.Hat:SetParent(self.Entity)

	elseif tab.Type == "suit" then 	
		CreateSuit(self,tab)
	end

end

function CreateSuit(self,tab)
	
	if ( IsValid( self.Hat ) ) then
		self.Hat:Remove()
		self.Hat.Key = nil 
		self.Hat = nil  
	else
		if type(self.Hat) == "table" then
			for i, stuff in pairs(self.Hat) do
				stuff:Remove()
			end
			self.Hat.Key = nil 
			self.Hat = nil  
		end
	end
	
	if not tab then return end
	if not tab.Type then return end
	if tab.Type == "suit" then 
		
		local key = tab.Key
		
		if not suits[key] then return end
		
		self.Hat = {}
		
		for i, stuff in pairs(suits[key]) do
			self.Hat[i] = ClientsideModel( stuff.model, RENDER_GROUP_OPAQUE_ENTITY )
			self.Hat[i].scale = stuff.scale
			self.Hat[i].bone = stuff.bone
			self.Hat[i].pos = stuff.pos
			self.Hat[i].ang = stuff.ang
			if stuff.mat then
				self.Hat[i]:SetMaterial(stuff.mat)
			end
			self.Hat[i]:SetNoDraw( true )
			self.Hat[i]:SetParent(self.Entity)
		end

		if ( not IsValid(self.Hat) ) then return end
		
		self.Hat.Key = key
	end

end

function DrawSuit(self)
	
	if not self.Hat then return end
	if type(self.Hat) == "CSEnt" then return end
	
	for i, prop in pairs(self.Hat) do
		
		if prop.scale then
			prop:SetModelScale(prop.scale)
		end
		
		local bonename = prop.bone
		
		local bone = self.Entity:LookupBone(bonename)  
		if bone then  
			local position, angles = self.Entity:GetBonePosition(bone)
			
			local localpos = prop.pos
			local localang = prop.ang

			local newpos, newang = LocalToWorld( localpos, localang, position, angles ) 

			prop:SetPos(newpos)  
			prop:SetAngles(newang)  

			prop:DrawModel()
		end 
	
	end
	
end

function DrawHat(self)
	
	if not self.Hat then return end
	if type(self.Hat) == "table" then 
	
	DrawSuit(self)
	
	return end
	
	self.Hat.WearType = self.Hat.WearType or "Normal"
	
	-- Set global different positions for combine and CSS models
	if self.Hat.addX == nil then
		self.Hat.addX = 0
		self.Hat.addY = 0
		if table.HasValue(CombineModels,string.lower(self.Entity:GetModel())) then
			self.Hat.addX = 2.6
			self.Hat.addY = -2
			self.Hat.WearType = "Combine"
		elseif table.HasValue(TModels,string.lower(self.Entity:GetModel())) then 
			self.Hat.addX = 3.2
			if self.Entity:GetModel() == "models/player/leet.mdl" then
				self.Hat.addX = 3.5
			end
			self.Hat.WearType = "CSS"
		elseif table.HasValue(CTModels,string.Replace(self.Entity:GetModel(),".mbl",".mdl")) then 
			self.Hat.Hat.addX = 4
			self.Hat.WearType = "CSS"
		end
		if self.Entity:GetModel() == "models/Police.mdl" then
			self.Hat.addX = 2
			self.Hat.WearType = "Combine"
		end
	end
	
	if self.Hat.RelPos == nil then
		-- If there are special coordinates for combine or CSS models, use those
		if self.Hat.WearType == "Combine" and hats[self.Hat.Key].CombPos then
			self.Hat.RelPos = hats[self.Hat.Key].CombPos
			self.Hat.addX = 0
			self.Hat.addY = 0
		elseif self.Hat.WearType == "CSS" and hats[self.Hat.Key].CSSPos then
			self.Hat.RelPos = hats[self.Hat.Key].CSSPos
			self.Hat.addX = 0
			self.Hat.addY = 0
		else
			self.Hat.RelPos = hats[self.Hat.Key].Pos
		end
		if hats[self.Hat.Key].SCK then
			self.Hat.RelAng = Angle(hats[self.Hat.Key].Ang.r,hats[self.Hat.Key].Ang.y,hats[self.Hat.Key].Ang.p)
		else
			self.Hat.RelAng = hats[self.Hat.Key].Ang
		end
	end
	
	if self.Hat.Scale == nil then
		if hats[self.Hat.Key].ScaleVector then
			self.Hat.Scale = hats[self.Hat.Key].ScaleVector
		end
	end
	
	if hats[self.Hat.Key].SCK then
		-- local temp = self.Hat.RelAng.p
		-- self.Hat.RelAng.p = self.Hat.RelAng.r
		-- self.Hat.RelAng.r = temp
	end
	
	-- Draw it
	local boneindex = self.Entity:LookupBone("ValveBiped.Bip01_Head1")
	if boneindex then
		local pos, ang = self.Entity:GetBonePosition(boneindex)
		if pos and pos ~= self.Entity:GetPos() then
			-- pos = pos + (ang:Forward() * (self.Hat.RelPos.x + self.Hat.addX)) + (ang:Right() * (self.Hat.RelPos.y + self.Hat.addY)) + (ang:Up() * self.Hat.RelPos.z)
			self.Hat:SetPos(pos + (ang:Forward() * (self.Hat.RelPos.x + self.Hat.addX)) + (ang:Right() * (self.Hat.RelPos.y + self.Hat.addY)) + (ang:Up() * self.Hat.RelPos.z))
			ang:RotateAroundAxis(ang:Forward(), self.Hat.RelAng.p)
			ang:RotateAroundAxis(ang:Up(), self.Hat.RelAng.y)
			ang:RotateAroundAxis(ang:Right(), self.Hat.RelAng.r)
			self.Hat:SetAngles(ang)
			if hats[self.Hat.Key].ScaleVector then
				self.Hat:SetModelScale ( self.Hat.Scale )
			end
			self.Hat:DrawModel()
		end
	end
	
end

function UpdateModelPanel()
	local mdl = MySelf:GetModel()
	if not MySelf:IsHuman() then
		mdl = "models/player/kleiner.mdl"
	end
	ModelPanel:SetModel(mdl,"walk_all")
	ModelPanel.Entity.GetPlayerColor = function() return Vector( GetConVarString( "cl_playercolor" ) ) end
end

function ManagePreview()
	
	ModelPanel = vgui.Create( "DModelPanel", PreviewMenu )
	ModelPanel:SetSize(PreviewH-25,PreviewH-25)
	ModelPanel:SetPos(-((PreviewH-25)/3)/2,0)
	
	--Make Hat
	-- ModelPanel.SetHat = CreateHat
	
	--SetModel
	ModelPanel.SetModel = function( self, strModelName, seq )

		if ( IsValid( self.Entity ) ) then
				self.Entity:Remove()
				self.Entity = nil              
		end

		if ( not ClientsideModel ) then return end
	 
		self.Entity = ClientsideModel( strModelName, RENDER_GROUP_OPAQUE_ENTITY )
		if ( not IsValid(self.Entity) ) then return end
	 
		self.Entity:SetNoDraw( true )
		if SelectedItem then
		
			CreateModels(self,SelectedItem)
			--CreateHat(self,SelectedItem)
			-- CreateSuit(self,SelectedItem)
		end
	 
		local iSeq = MySelf:GetSequence() or 0
		if seq then
			iSeq = self.Entity:LookupSequence( seq )
		end
		if (iSeq <= 0) then iSeq = self.Entity:LookupSequence( seq ) end
		-- if (iSeq <= 0) then iSeq = self.Entity:LookupSequence( "WalkUnarmed_all" ) end
		-- if (iSeq <= 0) then iSeq = self.Entity:LookupSequence( "walk_all_moderate" ) end
	 
		if (iSeq > 0) then self.Entity:ResetSequence( iSeq ) end
		
	end
	--Paint
	ModelPanel.Paint = function(self)
		
		if ( not IsValid( self.Entity ) ) then return end
	
		local x, y = self:LocalToScreen( 0, 0 )
		
		self:LayoutEntity( self.Entity )
		
		cam.Start3D( self.vCamPos, (self.vLookatPos-self.vCamPos):Angle(), self.fFOV, x, y, self:GetSize() )
		cam.IgnoreZ( true )
		
		render.SuppressEngineLighting( true )
		render.SetLightingOrigin( self.Entity:GetPos() )
		render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
		render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
		render.SetBlend( self.colColor.a/255 )
		
		for i=0, 6 do
			local col = self.DirectionalLight[ i ]
			if ( col ) then
				render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
			end
		end
			
		self.Entity:DrawModel()
		
		DrawModels(self)
		--DrawHat(self)
		
		render.SuppressEngineLighting( false )
		cam.IgnoreZ( false )
		cam.End3D()
		
		self.LastPaint = RealTime()
	
	end
	
	ModelPanel:SetFOV( 60 )
	ModelPanel:SetAnimSpeed( -0.5 )
	local mdl = MySelf:GetModel()
	if not MySelf:IsHuman() then
		mdl = "models/player/kleiner.mdl"
	end
	ModelPanel:SetModel(mdl,"walk_all")
	ModelPanel.Entity.GetPlayerColor = function() return Vector( GetConVarString( "cl_playercolor" ) ) end
	ModelPanel.LayoutEntity = function(self,Entity)
		--self:RunAnimation()
		Entity:SetAngles( Angle( 0, GetConVarNumber("_zs_previewrotation") or 35, 0) )
		-- Entity:SetPoseParameter( "move_yaw",180)
		Entity:SetPoseParameter( "neck_trans",0)
		-- Entity:SetPoseParameter( "aim_yaw",0)
		-- Entity:SetPoseParameter( "aim_pitch",0)
		Entity:SetPoseParameter( "body_yaw",0)
		Entity:SetPoseParameter( "spine_yaw",0)
		Entity:SetPoseParameter( "head_yaw",0)
		Entity:SetPoseParameter( "head_pitch",2)
	end
	
	local slider = vgui.Create("DNumSlider",PreviewMenu)
	slider:SetSize(PreviewW-25,40)
	slider:SetPos(PreviewW/2-(PreviewW-25)/2,PreviewH-45)
	slider:SetDecimals(0)
	slider:SetMinMax(-180, 180)
	slider:SetConVar("_zs_previewrotation")
	slider:SetText("Rotate")
	-- slider.Wang.TextEntry.OnEnter = function(txt)
    --     slider:SetValue(tonumber(txt:GetValue()));
    -- end
	

	

end

function DrawGreenShop()
	
	SelectedItem = nil
	-- local h = string.Explode("$",GetConVarString("_zs_equippedhats"))
	CurrentHats = string.Explode("$",GetConVarString("_zs_equippedhats"))-- {}
	
	for key,v in pairs(CurrentHats) do
		if not hats[v] then
			CurrentHats[key] = nil
		end
	end
	
	TopMenuW,TopMenuH = ScaleW(550), 130 -- ScaleW(550)
	TopMenuX,TopMenuY = w/2-TopMenuW/2,h/5-TopMenuH/1.6

	TopMenuH1 = ScaleH(136)
	
	BlurMenu = vgui.Create("DFrame")
	BlurMenu:SetSize(TopMenuW,TopMenuH)
	BlurMenu:SetPos(TopMenuX,TopMenuY)
	BlurMenu:SetSkin("ZSMG")
	BlurMenu:SetTitle( "Zombie Survival GreenCoins Shop" ) 
	BlurMenu:SetDraggable ( false )
	BlurMenu:SetBackgroundBlur( true )
	BlurMenu:SetSizable(false)
	BlurMenu:SetDraggable(false)
	BlurMenu:ShowCloseButton(false)
	
	local welcomebox = vgui.Create("DTextEntry",BlurMenu)
	welcomebox:SetPos( 5, 25 ) 
	welcomebox:SetSize( TopMenuW-10, TopMenuH-30 ) 
	welcomebox:SetEditable( false )
	welcomebox:SetValue([[Please note that some hats/suits might look strange on few playermodels.
	You earn GreenCoins by playing this game, or by paying for them.
	More information regarding GreenCoins can be found on http://mrgreengaming.com
	]])
	welcomebox:SetMultiline( true )
	
	
	BlurMenu.Think = function ()
		gui.EnableScreenClicker(true)
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
	
	ShopMenuW,ShopMenuH = TopMenuW/1.7, ScaleH(510)
	
	ShopMenu = vgui.Create("DFrame")
	ShopMenu:SetSize(ShopMenuW,ShopMenuH)
	ShopMenu:SetPos(TopMenuX,TopMenuY+TopMenuH+ScaleH(20))
	ShopMenu:SetSkin("ZSMG")
	ShopMenu:SetTitle( "Shop items" ) 
	ShopMenu:SetDraggable ( false )
	ShopMenu:SetSizable(false)
	ShopMenu:SetDraggable(false)
	ShopMenu:ShowCloseButton(false)
	ShopMenu.Think = function()
		if ShopMenu and ShopMenu.SetTitle then
			ShopMenu:SetTitle( "Shop items | Your GreenCoins balance: "..(MySelf:GreenCoins() or 0) ) 
		end
	end
	
	ShopSheetW,ShopSheetH = ShopMenuW-10, ShopMenuH-35
	
	ShopSheet = vgui.Create( "DPropertySheet", ShopMenu )
	ShopSheet:SetPos( 5, 30 )
	ShopSheet:SetSize( ShopSheetW,ShopSheetH )
	
	--insert shit here
	InsertHats()
	
	InsertSuits()
	
	InsertOther()
	
	PreviewW,PreviewH = TopMenuW-(ShopMenuW+ScaleH(20)),ShopMenuH
	PreviewX,PreviewY = TopMenuX+ShopMenuW+ScaleH(20),TopMenuY+TopMenuH+ScaleH(20) 

	PreviewMenu = vgui.Create("DFrame")
	PreviewMenu:SetSize(PreviewW,PreviewH)
	PreviewMenu:SetPos(PreviewX,PreviewY)
	PreviewMenu:SetSkin("ZSMG")
	PreviewMenu:SetTitle( "Item preview" ) 
	PreviewMenu:SetDraggable( false )
	PreviewMenu:SetSizable(false)
	PreviewMenu:SetDraggable(false)
	PreviewMenu:ShowCloseButton(false)
	PreviewMenu.Think = function()
		PreviewMenu:SetTitle( "Item preview" ) 
		if not SelectedItem then return end
		if not SelectedItem.Type then return end
		if SelectedItem.Type == "hat" or SelectedItem.Type == "suit" then 
			PreviewMenu:SetTitle( "Item preview: "..SelectedItem.Name ) 
			--PreviewMenu:SetTitle( "PREVIEW IS UNDER HEAVY CONSTRUCTION!" ) 
		end
		
	end
	
	-- make model
	ManagePreview()
	
	-- small close button
	
	closeW,closeH = 22, 22
	closeX,closeY = TopMenuX + TopMenuW - 22,TopMenuY
	
	CloseButton = vgui.Create("DButton",InvisiblePanel)
	CloseButton:SetText("X")
	CloseButton:SetPos(closeX,closeY)
	CloseButton:SetSize (closeW,closeH)
	CloseButton.DoClick = function ()
		gui.EnableScreenClicker( false )
	
		if ( IsValid( ModelPanel.Hat ) ) then
			ModelPanel.Hat:Remove()
			ModelPanel.Hat.Key = nil 
			ModelPanel.Hat = nil  
		else
			if type(ModelPanel.Hat) == "table" then
				for k, v in pairs( ModelPanel.Hat ) do
					if (ValidEntity( v.modelEnt )) then v.modelEnt:Remove() end
				end
				ModelPanel.Hat.Key = nil 
				ModelPanel.Hat = nil  
			end
		end
		if ( IsValid( ModelPanel.Entity ) ) then
			ModelPanel.Entity:Remove()
			ModelPanel.Entity = nil 
		end
		
		BlurMenu:Close()
		InvisiblePanel:Close()
		ShopMenu:Close()
		PreviewMenu:Close()
	end	

end
