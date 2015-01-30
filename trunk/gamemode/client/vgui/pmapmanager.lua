--I think dis gonna b gud

MapCycle_cl = {}
MapProperties_cl = {}

MapTab = {}
PropTab = {}


MapSelected = nil
MapSelectedProp = nil

function OpenMapManager()
	
	MapPanelW,MapPanelH = ScaleW(450), ScaleH(500)
	
	MapPanel = vgui.Create("DFrame")
	MapPanel:SetSize(MapPanelW,MapPanelH)
	MapPanel:SetPos(w/2-MapPanelW/2,h/2-MapPanelH/2)
	MapPanel:SetTitle ("Map Manager 3000")
	MapPanel:SetSkin("ZSMG")
	MapPanel:ShowCloseButton (true)
	MapPanel:SetDraggable ( false )
	MapPanel:SetSizable(false)
	
	MapPanel:MakePopup()
	
	
	MapSheet = vgui.Create( "DPropertySheet", MapPanel )
	MapSheet:SetPos( 5, 30 )
	MapSheet:SetSize( MapPanelW-10, MapPanelH-35 )
	
	-- -----------------------------------------
	
	Sheet_MapCycle()
	
	Sheet_MapProperties()
	
	Sheet_Crates()
	
	Sheet_Exploits()
	
	
end

--Map Cycle---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Sheet_MapCycle()
	
	DMapLabel = vgui.Create( "DLabel")
	DMapLabel:SetText("")
	DMapLabel:SizeToContents()
	
	DMapList = vgui.Create( "DPanelList",DMapLabel)
	DMapList:SetSize((MapPanelW-10)*0.5, MapPanelH-75)
	DMapList:SetSkin("ZSMG")
	DMapList:SetSpacing(0)
	DMapList:SetPadding(0)
	DMapList:EnableHorizontal( false )
	DMapList:EnableVerticalScrollbar( true )
	DMapList.Paint = function()
	
	end
	
	--Thing that helps us
	DMapProp = vgui.Create( "DPanelList",DMapLabel)
	DMapProp:SetSize((MapPanelW-10)*0.4, MapPanelH-75)
	DMapProp:SetPos((MapPanelW-10)*0.55,0)
	DMapProp:SetSkin("ZSMG")
	DMapProp:SetSpacing(0)
	DMapProp:SetPadding(5)
	DMapProp:EnableHorizontal( false )
	DMapProp:EnableVerticalScrollbar( true )
	DMapProp.Paint = function()
		surface.SetDrawColor( 30, 30, 30, 200 )
		surface.DrawOutlinedRect( 0, 0,DMapProp:GetWide(), DMapProp:GetTall())
		surface.SetDrawColor( 30, 30, 30, 255 )
		surface.DrawOutlinedRect( 1, 1, DMapProp:GetWide()-2, DMapProp:GetTall()-2 )
	end
	
	
	--Small label that describes what's in here
	DMapPropLabel = vgui.Create( "DLabel")
	DMapPropLabel:SetSize(DMapProp:GetWide(), ScaleH(30))
	-- DMapPropLabel:SetPos(0,0)
	DMapPropLabel:SetText("")
	DMapPropLabel.Paint = function()
		draw.SimpleTextOutlined ( "Map name", "WeaponNames", DMapPropLabel:GetWide()/2, DMapPropLabel:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end
	
	DMapProp:AddItem(DMapPropLabel)
	
	--Text entry
	DMapPropName = vgui.Create("DTextEntry")
	DMapPropName:SetSize(DMapProp:GetWide(), ScaleH(25))
	-- DMapPropName:SetPos(0,ScaleH(25))
	DMapPropName:SetValue("")
	DMapPropName:SetSkin("ZSMG")
	DMapPropName:SetTextColor(Color(255,255,255))
	DMapPropName:SetEditable(true)
	DMapPropName:SetMultiline( false )
	DMapPropName:SetEnterAllowed( true )

	DMapPropName.OnEnter = function()
		if MapSelected then
			if DMapPropName:GetValue() ~= "" then
				MapCycle_cl[MapSelected].MapName = DMapPropName:GetValue()
				local tbl = {tostring(MapSelected),tostring(DMapPropName:GetValue())}
				RunConsoleCommand("zs_mapmanager_renewname",unpack(tbl))
			end
		end
	end
	DMapPropName.Think = function()
		if not MapSelected then
			DMapPropName:SetValue("")
		end
	end
	
	
	DMapProp:AddItem(DMapPropName)
	
	DMapPropLabel2 = vgui.Create( "DLabel")
	DMapPropLabel2:SetSize(DMapProp:GetWide(), ScaleH(30))
	-- DMapPropLabel2:SetPos(0,ScaleH(60))
	DMapPropLabel2:SetText("")
	DMapPropLabel2.Paint = function()
		draw.SimpleTextOutlined ( "Map filename", "WeaponNames", DMapPropLabel2:GetWide()/2, DMapPropLabel2:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end
	
	DMapProp:AddItem(DMapPropLabel2)
	
	--Text entry
	DMapPropName2 = vgui.Create("DTextEntry")
	DMapPropName2:SetSize(DMapProp:GetWide(), ScaleH(25))
	-- DMapPropName2:SetPos(0,ScaleH(85))
	DMapPropName2:SetValue("")
	DMapPropName2:SetSkin("ZSMG")
	DMapPropName2:SetTextColor(Color(255,255,255))
	DMapPropName2:SetEditable(true)
	DMapPropName2:SetMultiline( false )
	DMapPropName2:SetEnterAllowed( true )
	DMapPropName2.OnEnter = function()
		if MapSelected then
			if DMapPropName2:GetValue() ~= "" then
				MapCycle_cl[MapSelected].Map = DMapPropName2:GetValue()
				local tbl = {tostring(MapSelected),tostring(DMapPropName2:GetValue())}
				RunConsoleCommand("zs_mapmanager_renewfilename",unpack(tbl))
			end
		end
	end
	
	DMapPropName2.Think = function()
		if not MapSelected then
			DMapPropName2:SetValue("")
		end
	end
	
	DMapProp:AddItem(DMapPropName2)
	
	--[==[EmptySpace = vgui.Create( "DLabel")
	EmptySpace:SetSize(DMapProp:GetWide(), ScaleH(50))
	EmptySpace:SetText("")
	
	DMapProp:AddItem(EmptySpace)]==]
	
	--Obsolete
	--[[DMapSButton = vgui.Create("DButton")
	DMapSButton:SetSize(DMapProp:GetWide(), ScaleH(25))
	DMapSButton:SetText("Shuffle Map Cycle")
	DMapSButton:SetSkin("ZSMG")
	DMapSButton.DoClick = function()
		RunConsoleCommand("zs_mapmanager_shuffle")
	end
	
	DMapProp:AddItem(DMapSButton)]]
	
	DMapLoadButton = vgui.Create("DButton")
	DMapLoadButton:SetSize(DMapProp:GetWide(), ScaleH(25))
	DMapLoadButton:SetText("Load Map Cycle from server")
	DMapLoadButton:SetSkin("ZSMG")
	DMapLoadButton.DoClick = function()
		LoadMapCycle()
	end
	
	DMapProp:AddItem(DMapLoadButton)
	
	
	--Add new map---------------------------------------------------------------------
	DMapPropLabel3 = vgui.Create( "DLabel")
	DMapPropLabel3:SetSize(DMapProp:GetWide(), ScaleH(40))
	DMapPropLabel3:SetText("")
	DMapPropLabel3.Paint = function()
		draw.SimpleTextOutlined ( "-------------Add new map-------------", "WeaponNames", DMapPropLabel3:GetWide()/2, DMapPropLabel3:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end
	
	DMapProp:AddItem(DMapPropLabel3)
	
	DMapPropName3 = vgui.Create("DTextEntry")
	DMapPropName3:SetSize(DMapProp:GetWide(), ScaleH(25))
	DMapPropName3.DefValue = "< New Map Name >"
	DMapPropName3:SetValue(DMapPropName3.DefValue)
	DMapPropName3:SetSkin("ZSMG")
	DMapPropName3:SetTextColor(Color(255,255,255))
	DMapPropName3:SetEditable(true)
	DMapPropName3:SetMultiline( false )
	DMapPropName3:SetEnterAllowed( true )
	DMapPropName3.OnGetFocus = function(self)
		if self:GetValue() == self.DefValue then
			self:SetValue("")
		end
	end
	DMapPropName3.OnLoseFocus = function(self)
		if self:GetValue() == "" then
			self:SetValue(DMapPropName3.DefValue)
		end
	end
	
	DMapProp:AddItem(DMapPropName3)
	
	DMapPropName4 = vgui.Create("DTextEntry")
	DMapPropName4:SetSize(DMapProp:GetWide(), ScaleH(25))
	DMapPropName4.DefValue = "< zs_mynewmap >"
	DMapPropName4:SetValue(DMapPropName4.DefValue)
	DMapPropName4:SetSkin("ZSMG")
	DMapPropName4:SetTextColor(Color(255,255,255))
	DMapPropName4:SetEditable(true)
	DMapPropName4:SetMultiline( false )
	DMapPropName4:SetEnterAllowed( true )
	DMapPropName4.OnGetFocus = function(self)
		if self:GetValue() == self.DefValue then
			self:SetValue("")
		end
	end
	DMapPropName4.OnLoseFocus = function(self)
		if self:GetValue() == "" then
			self:SetValue(DMapPropName4.DefValue)
		end
	end
	
	DMapProp:AddItem(DMapPropName4)
	
	DMapAddButton = vgui.Create("DButton")
	DMapAddButton:SetSize(DMapProp:GetWide(), ScaleH(25))
	DMapAddButton:SetText("Add new map into Map Cycle")
	DMapAddButton:SetSkin("ZSMG")
	DMapAddButton:SetDisabled(true)
	DMapAddButton.DoClick = function()
		Map_Add()
	end
	
	DMapProp:AddItem(DMapAddButton)
	
	EmptySpace2 = vgui.Create( "DLabel")
	EmptySpace2:SetSize(DMapProp:GetWide(), ScaleH(60))
	EmptySpace2:SetText("")
	
	DMapProp:AddItem(EmptySpace2)
	
	DMapSaveButton = vgui.Create("DButton")
	DMapSaveButton:SetSize(DMapProp:GetWide(), ScaleH(45))
	DMapSaveButton:SetText("Save all changes on server (important!)")
	DMapSaveButton:SetSkin("ZSMG")
	DMapSaveButton.DoClick = function()
		local AllExist = true
		for i=1, #MapCycle_cl do
			if not MapCycle_cl[i] or not MapCycle_cl[i].Exists then
				chat.AddText(Color( 255, 0, 0), "Failed to save map cycle. Map '".. MapCycle_cl[i].Map .."' doesn't exist on the server.")
				AllExist = false
			end
		end

		if not AllExist then
			surface.PlaySound(Sound("buttons/button10.wav"))
			return
		end

		RunConsoleCommand("zs_mapmanager_save")
		surface.PlaySound(Sound("buttons/button24.wav"))
	end
	
	DMapProp:AddItem(DMapSaveButton)
	
	MapSheet:AddSheet( "Map Cycle", DMapLabel, nil, false, false, nil )
end

--Import maps----------------------------------

usermessage.Hook("SendMapList",function(um)
	
	local index = um:ReadShort()
	local map = um:ReadString()
	local mapname = um:ReadString()
	local exists = um:ReadBool()
	
	MapCycle_cl[index] = {Map = map, MapName = mapname, Exists = exists}
	
end)

net.Receive( "MapManager-UpdateInfo", function( len )
	local ID = net.ReadInt(32)

	MapCycle_cl[ID] = net.ReadTable()
end) 

function RefreshMapProp()
	if MapSelected then
		DMapPropName:SetText(MapCycle_cl[MapSelected].MapName)
		DMapPropName2:SetText(MapCycle_cl[MapSelected].Map)
	end
end

function RebuildMapCycle()
	
	DMapList:Clear()
	
	MapTab = {}
	
	for i=1, #MapCycle_cl do
				
		MapTab[i] = vgui.Create("DLabel")
		MapTab[i]:SetText("")-- MapCycle_cl[i].Map
		MapTab[i]:SetSize(DMapList:GetWide(),(MapPanelH-35)/10)
		MapTab[i].OnCursorEntered = function() 
			MapTab[i].Overed = true 
			-- surface.PlaySound ("UI/buttonrollover.wav") 
		end
		MapTab[i].OnCursorExited = function () 
			MapTab[i].Overed = false
		end
		MapTab[i].OnMousePressed = function() 
			MapSelected = i
			RefreshMapProp()
		end
		MapTab[i].Paint = function()
			if MapTab[i].Overed or i == MapSelected then
				surface.SetDrawColor( 255, 255, 255, 255)
				surface.DrawOutlinedRect( 0, 0,MapTab[i]:GetWide(), MapTab[i]:GetTall())
				surface.DrawOutlinedRect( 1, 1, MapTab[i]:GetWide()-2, MapTab[i]:GetTall()-2 )
			else
				surface.SetDrawColor( 30, 30, 30, 200 )
				surface.DrawOutlinedRect( 0, 0,MapTab[i]:GetWide(), MapTab[i]:GetTall())
				surface.SetDrawColor( 30, 30, 30, 255 )
				surface.DrawOutlinedRect( 1, 1, MapTab[i]:GetWide()-2, MapTab[i]:GetTall()-2 )
			end
					
			-- index
			draw.SimpleTextOutlined ( i, "WeaponNames", 5, MapTab[i]:GetTall()*0.25, Color(255, 255, 255, 255) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
					
			--Pretty Name if exists
			draw.SimpleTextOutlined ( MapCycle_cl[i].MapName, "WeaponNames", 25, MapTab[i]:GetTall()*0.25, Color(255, 255, 255, 255) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
			
			local col, borderCol
			local ExtraStr = ""
			if MapCycle_cl[i].Exists then
				col = Color(255, 255, 255, 255)
				borderCol = Color(0,0,0,255)
			else
				col = Color(255, 0, 0, 255)
				borderCol = Color(255, 255, 255,255)
				ExtraStr = " (missing)"
			end

			--Actual filename
			draw.SimpleTextOutlined ( MapCycle_cl[i].Map .. ExtraStr, "WeaponNames", 25, MapTab[i]:GetTall()*0.75, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, borderCol)
					
		end
		
		--Delete button		
		MapTab[i].Del = vgui.Create("DButton", MapTab[i])
		MapTab[i].Del:SetSkin("ZSMG")
		MapTab[i].Del:SetFont("Marlett")
		MapTab[i].Del:SetText("r")
		MapTab[i].Del:SetSize(MapTab[i]:GetTall()/2.1,MapTab[i]:GetTall()/2.1)
		MapTab[i].Del:SetPos(MapTab[i]:GetWide()-(MapTab[i]:GetTall()/2.1) - 36,MapTab[i]:GetTall()/2-(MapTab[i]:GetTall()/2.1)/2)
		MapTab[i].Del.DoClick = function()
			Map_Delete(i)
		end
		
				
		DMapList:AddItem(MapTab[i])
	end
end

function Map_Delete(index)
	
	DMapList:Clear()
	
	RunConsoleCommand("zs_mapmanager_delete",tostring(index))
	
	MapSelected = nil
	
	MapCycle_cl[index] = nil
	-- MapTab[index] = nil
	
	table.Resequence ( MapCycle_cl )
		
	RebuildMapCycle()
	
	RefreshMapProp()
	
	-- TODO: add serverside support
	
end

function Map_Add()
	local name = DMapPropName3:GetValue() or "Invalid Name!"
	local filename = DMapPropName4:GetValue() or "zs_please" -- lol
	
	DMapList:Clear()
	
	local tbl = {tostring(filename),tostring(name)}
	
	RunConsoleCommand("zs_mapmanager_add",unpack(tbl))
	
	MapCycle_cl[#MapCycle_cl+1] = {Map = filename, MapName = name, Exists = false}
	
	RebuildMapCycle()
end 

function LoadMapCycle()
	
	RunConsoleCommand("send_maplist")
	DMapLoadButton:SetText("Loading...")
	
	DMapList:Clear()
	
	timer.Simple(1, function()
		
		-- PrintTable(MapCycle_cl)
		
		DMapLoadButton:SetText("Load Map Cycle from server")
		DMapAddButton:SetDisabled(false)
		
		RebuildMapCycle()
			
	end)
	
	
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Map Properties----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Sheet_MapProperties()
	
	DPropLabel = vgui.Create( "DLabel")
	DPropLabel:SetText("")
	DPropLabel:SizeToContents()
	
	DPropList = vgui.Create( "DPanelList",DPropLabel)
	DPropList:SetSize((MapPanelW-10)*0.35, MapPanelH-75)
	DPropList:SetSkin("ZSMG")
	DPropList:SetSpacing(0)
	DPropList:SetPadding(0)
	DPropList:EnableHorizontal( false )
	DPropList:EnableVerticalScrollbar( true )
	DPropList.Paint = function() end
	
	
	--Left List 
	
	DLeftList = vgui.Create( "DPanelList",DPropLabel)
	DLeftList:SetSize((MapPanelW-10)*0.25, MapPanelH-75)
	DLeftList:SetPos(DPropList:GetWide()+5,0)
	DLeftList:SetSkin("ZSMG")
	DLeftList:SetSpacing(0)
	DLeftList:SetPadding(0)
	DLeftList:EnableHorizontal( false )
	DLeftList:EnableVerticalScrollbar( true )
	DLeftList.Paint = function() end
	
	--Remove entities-----------------------------------------------------------
	DRmvEnts = vgui.Create( "DPanelList")
	DRmvEnts:SetSize((MapPanelW-10)*0.25, (MapPanelH-75)*0.4)
	--DRmvEnts:SetPos(DPropList:GetWide()+15,0)
	DRmvEnts:SetSkin("ZSMG")
	DRmvEnts:SetSpacing(0)
	DRmvEnts:SetPadding(0)
	DRmvEnts:EnableHorizontal( false )
	DRmvEnts:EnableVerticalScrollbar( true )
	DRmvEnts.Paint = function() 
		surface.SetDrawColor( 30, 30, 30, 200 )
		surface.DrawOutlinedRect( 0, 0,DRmvEnts:GetWide(), DRmvEnts:GetTall())
		surface.SetDrawColor( 30, 30, 30, 255 )
		surface.DrawOutlinedRect( 1, 1, DRmvEnts:GetWide()-2, DRmvEnts:GetTall()-2 )
	end
	
	DLeftList:AddItem(DRmvEnts)
	
	DRmvEntsText = vgui.Create("DTextEntry")
	DRmvEntsText:SetSize(DRmvEnts:GetWide(),ScaleH(20))
	DRmvEntsText:SetSkin("ZSMG")
	
	DLeftList:AddItem(DRmvEntsText)
	
	DRmvEntsBtn = vgui.Create("DButton")
	DRmvEntsBtn:SetText("Remove entity by class")
	DRmvEntsBtn:SetSkin("ZSMG")
	DRmvEntsBtn:SetSize(DRmvEnts:GetWide(),ScaleH(20))
	DRmvEntsBtn.DoClick = function()
		if DRmvEntsText:GetValue() ~= "" then
			AddItemToSubList(DRmvEntsText,DRmvEnts,1)
		end
	end
	
	DLeftList:AddItem(DRmvEntsBtn)
	
	
	--Exclude entities----------------------------------------------------------------
	DRmvExEnts = vgui.Create( "DPanelList")
	DRmvExEnts:SetSize((MapPanelW-10)*0.25, (MapPanelH-75)*0.4)
	--DRmvExEnts:SetPos(DPropList:GetWide()+15,(MapPanelH-75)*0.3 + 5 + ScaleH(40))
	DRmvExEnts:SetSkin("ZSMG")
	DRmvExEnts:SetSpacing(0)
	DRmvExEnts:SetPadding(0)
	DRmvExEnts:EnableHorizontal( false )
	DRmvExEnts:EnableVerticalScrollbar( true )
	DRmvExEnts.Paint = function() 
		surface.SetDrawColor( 30, 30, 30, 200 )
		surface.DrawOutlinedRect( 0, 0,DRmvExEnts:GetWide(), DRmvExEnts:GetTall())
		surface.SetDrawColor( 30, 30, 30, 255 )
		surface.DrawOutlinedRect( 1, 1, DRmvExEnts:GetWide()-2, DRmvExEnts:GetTall()-2 )
	end
	
	DLeftList:AddItem(DRmvExEnts)
	
	DRmvExEntsText = vgui.Create("DTextEntry")
	DRmvExEntsText:SetSize(DRmvExEnts:GetWide(),ScaleH(20))
	DRmvExEntsText:SetSkin("ZSMG")
	
	DLeftList:AddItem(DRmvExEntsText)
	
	DRmvExEntsBtn = vgui.Create("DButton")
	DRmvExEntsBtn:SetText("Exclude removing by class")
	DRmvExEntsBtn:SetSkin("ZSMG")
	DRmvExEntsBtn:SetSize(DRmvExEnts:GetWide(),ScaleH(20))
	DRmvExEntsBtn.DoClick = function()
		if DRmvExEntsText:GetValue() ~= "" then
			AddItemToSubList(DRmvExEntsText,DRmvExEnts,2)
		end
	end
	
	DLeftList:AddItem(DRmvExEntsBtn)
	
	--Right List ----------------------------
	
	DRightList = vgui.Create( "DPanelList",DPropLabel)
	DRightList:SetSize((MapPanelW-10)*0.3, MapPanelH-75)
	DRightList:SetPos(DPropList:GetWide()*1.8+10,0)
	DRightList:SetSkin("ZSMG")
	DRightList:SetSpacing(0)
	DRightList:SetPadding(0)
	DRightList:EnableHorizontal( false )
	DRightList:EnableVerticalScrollbar( true )
	DRightList.Paint = function() end
	
	--Remove entities by model-----------------------------------------------------------
	DRmvEntsM = vgui.Create( "DPanelList")
	DRmvEntsM:SetSize((MapPanelW-10)*0.3, (MapPanelH-75)*0.4)
	DRmvEntsM:SetSkin("ZSMG")
	DRmvEntsM:SetSpacing(0)
	DRmvEntsM:SetPadding(0)
	DRmvEntsM:EnableHorizontal( false )
	DRmvEntsM:EnableVerticalScrollbar( true )
	DRmvEntsM.Paint = function() 
		surface.SetDrawColor( 30, 30, 30, 200 )
		surface.DrawOutlinedRect( 0, 0,DRmvEntsM:GetWide(), DRmvEntsM:GetTall())
		surface.SetDrawColor( 30, 30, 30, 255 )
		surface.DrawOutlinedRect( 1, 1, DRmvEntsM:GetWide()-2, DRmvEntsM:GetTall()-2 )
	end
	
	DRightList:AddItem(DRmvEntsM)
	
	DRmvEntsMText = vgui.Create("DTextEntry")
	DRmvEntsMText:SetSize(DRmvEntsM:GetWide(),ScaleH(20))
	DRmvEntsMText:SetSkin("ZSMG")
	
	DRightList:AddItem(DRmvEntsMText)
	
	DRmvEntsMBtn = vgui.Create("DButton")
	DRmvEntsMBtn:SetText("Remove entity by model")
	DRmvEntsMBtn:SetSkin("ZSMG")
	DRmvEntsMBtn:SetSize(DRmvEntsM:GetWide(),ScaleH(20))
	DRmvEntsMBtn.DoClick = function()
		if DRmvEntsMText:GetValue() ~= "" then
			AddItemToSubList(DRmvEntsMText,DRmvEntsM,3)
		end
	end
	
	DRightList:AddItem(DRmvEntsMBtn)
	
	local Empty = vgui.Create( "DLabel")
	Empty:SetSize(DRightList:GetWide(), ScaleH(40))
	Empty:SetText("")
	
	DRightList:AddItem(Empty)
	
	--Remove Glass checkbox-------------------
	DRmvGlass = vgui.Create( "DCheckBoxLabel")
	DRmvGlass:SetText("Remove glass from map")
	DRmvGlass:SetSize(DRightList:GetWide(),ScaleH(20))
	DRmvGlass:SetValue( 0 )
	
	DRightList:AddItem(DRmvGlass)
	
	DSpawnProtection = vgui.Create("DNumSlider")
	DSpawnProtection:SetText("Z. Spawn Protection")
	DSpawnProtection:SizeToContents()-- SetSize(DRightList:GetWide(),ScaleH(20))
	DSpawnProtection:SetValue(3)
	DSpawnProtection:SetMin(0)
	DSpawnProtection:SetMax(30)
	DSpawnProtection:SetDecimals(0)
	
	DRightList:AddItem(DSpawnProtection)
	
	--Small texbox for adding new map
	DNewMapText = vgui.Create("DTextEntry")
	DNewMapText:SetSize(DRightList:GetWide(),ScaleH(25))
	DNewMapText:SetSkin("ZSMG")
	DNewMapText:SetValue("< Add new map here >")
	DNewMapText:SetEnterAllowed( true )
	DNewMapText.OnEnter = function()
		AddNewMapProp()
	end
	
	DRightList:AddItem(DNewMapText)
	
	DRmvLoadBtn = vgui.Create("DButton")
	DRmvLoadBtn:SetText("Load Map Properties")
	DRmvLoadBtn:SetSkin("ZSMG")
	DRmvLoadBtn:SetSize(DRightList:GetWide(),ScaleH(30))
	DRmvLoadBtn.DoClick = function()
		LoadMapProperties()
	end
	
	DRightList:AddItem(DRmvLoadBtn)
	
	DRmvSaveBtn = vgui.Create("DButton")
	DRmvSaveBtn:SetText("Save changes for this map!")
	DRmvSaveBtn:SetSkin("ZSMG")
	DRmvSaveBtn:SetSize(DRightList:GetWide(),ScaleH(55))
	DRmvSaveBtn.DoClick = function()
		SaveMapProp()
	end
	
	DRightList:AddItem(DRmvSaveBtn)
	
	MapSheet:AddSheet( "Map Properties", DPropLabel, nil, false, false, nil )

end

usermessage.Hook("SendMapProperties",function(um)
	
	local map = um:ReadString()
	local data = um:ReadString()

	local decoded = util.JSONToTable(data)
	
	MapProperties_cl[map] = decoded	
end)

function LoadMapProperties()
	
	RunConsoleCommand("send_mapproperties")
	
	DPropList:Clear()
	
	DRmvLoadBtn:SetText("Loading...")
	
	timer.Simple(1, function()
				
		DRmvLoadBtn:SetText("Load Map Properties")
		
		RebuildMapProperties()
			
	end)

end

function RefreshSubLists()
	
	if MapSelectedProp then
		
		local tbl = MapProperties_cl[MapSelectedProp]
		
		if not tbl then return end
		
		local remove = tbl[1] or {}
		local exclude = tbl[2] or {}
		local removemdl = tbl[3] or {}
		local glass = tbl[4] or false
		local sp = tbl[5] or 3
		
		--checkbox!
		DRmvGlass:SetValue(glass)
		DRmvGlass.OnChange = function(pSelf, fValue)
			MapProperties_cl[MapSelectedProp][4] = fValue
		end
		
		--slider
		
		DSpawnProtection:SetValue(sp)
		DSpawnProtection.ValueChanged = function(pSelf, fValue)
			MapProperties_cl[MapSelectedProp][5] = fValue
		end
		
		if remove then
			PropTab[MapSelectedProp].Rmv = {}
			DRmvEnts:Clear()
			
			for k, v in pairs(remove) do
				
				PropTab[MapSelectedProp].Rmv[v] = vgui.Create("DLabel")
				PropTab[MapSelectedProp].Rmv[v]:SetSize(DRmvEnts:GetWide(),ScaleH(15))
				PropTab[MapSelectedProp].Rmv[v]:SetText(v)
				PropTab[MapSelectedProp].Rmv[v].OnCursorEntered = function() 
					if PropTab[MapSelectedProp].Rmv[v] then
						PropTab[MapSelectedProp].Rmv[v].Overed = true 
					end
				end
				PropTab[MapSelectedProp].Rmv[v].OnCursorExited = function () 
					if PropTab[MapSelectedProp].Rmv[v] then
						PropTab[MapSelectedProp].Rmv[v].Overed = false
					end
				end
				
				PropTab[MapSelectedProp].Rmv[v].OnMousePressed = function()
					RemoveItemFromSubList(MapSelectedProp,PropTab[MapSelectedProp].Rmv[v],v,DRmvEnts,1)
				end
				
				PropTab[MapSelectedProp].Rmv[v].Paint = function()
					if PropTab[MapSelectedProp].Rmv[v].Overed then
						draw.SimpleTextOutlined ( "[X]", "WeaponNames", PropTab[MapSelectedProp].Rmv[v]:GetWide()-25, PropTab[MapSelectedProp].Rmv[v]:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
					end
				end
				
				DRmvEnts:AddItem(PropTab[MapSelectedProp].Rmv[v])
				
			end
		end
		
		if exclude then
			PropTab[MapSelectedProp].Ex = {}
			DRmvExEnts:Clear()
			
			for k, v in pairs(exclude) do
				
				PropTab[MapSelectedProp].Ex[v] = vgui.Create("DLabel")
				PropTab[MapSelectedProp].Ex[v]:SetSize(DRmvEnts:GetWide(),ScaleH(15))
				PropTab[MapSelectedProp].Ex[v]:SetText(v)
				
				PropTab[MapSelectedProp].Ex[v].OnCursorEntered = function() 
					if PropTab[MapSelectedProp].Ex[v] then	
						PropTab[MapSelectedProp].Ex[v].Overed = true 
					end
				end
				PropTab[MapSelectedProp].Ex[v].OnCursorExited = function () 
					if PropTab[MapSelectedProp].Ex[v] then
						PropTab[MapSelectedProp].Ex[v].Overed = false
					end
				end
				
				PropTab[MapSelectedProp].Ex[v].OnMousePressed = function()
					RemoveItemFromSubList(MapSelectedProp,PropTab[MapSelectedProp].Ex[v],v,DRmvExEnts,2)
				end
				
				PropTab[MapSelectedProp].Ex[v].Paint = function()
					if PropTab[MapSelectedProp].Ex[v].Overed then
						draw.SimpleTextOutlined ( "[X]", "WeaponNames", PropTab[MapSelectedProp].Ex[v]:GetWide()-25, PropTab[MapSelectedProp].Ex[v]:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
					end
				end
				
				DRmvExEnts:AddItem(PropTab[MapSelectedProp].Ex[v])
				
			end
		end
		
		if removemdl then
			PropTab[MapSelectedProp].Mdl = {}
			DRmvEntsM:Clear()
			
			for k, v in pairs(removemdl) do
				
				PropTab[MapSelectedProp].Mdl[v] = vgui.Create("DLabel")
				PropTab[MapSelectedProp].Mdl[v]:SetSize(DRmvEnts:GetWide(),ScaleH(15))
				PropTab[MapSelectedProp].Mdl[v]:SetText(v)
				
				PropTab[MapSelectedProp].Mdl[v].OnCursorEntered = function() 
					if PropTab[MapSelectedProp].Mdl[v] then
						PropTab[MapSelectedProp].Mdl[v].Overed = true 
					end
				end
				PropTab[MapSelectedProp].Mdl[v].OnCursorExited = function () 
					if PropTab[MapSelectedProp].Mdl[v] then
						PropTab[MapSelectedProp].Mdl[v].Overed = false
					end
				end
				PropTab[MapSelectedProp].Mdl[v].OnMousePressed = function()
					RemoveItemFromSubList(MapSelectedProp,PropTab[MapSelectedProp].Mdl[v],v,DRmvEntsM,3)
				end
				
				
				PropTab[MapSelectedProp].Mdl[v].Paint = function()
					if PropTab[MapSelectedProp].Mdl[v].Overed then
						draw.SimpleTextOutlined ( "[X]", "WeaponNames", PropTab[MapSelectedProp].Mdl[v]:GetWide()-25, PropTab[MapSelectedProp].Mdl[v]:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
					end
				end
				
				DRmvEntsM:AddItem(PropTab[MapSelectedProp].Mdl[v])
				
			end
		end
		
	end

end

function AddItemToSubList(text,list,num)
	
	if MapSelectedProp then
	
		local value = text:GetValue()
		
		MapProperties_cl[MapSelectedProp][num] = MapProperties_cl[MapSelectedProp][num] or {}
		
		list:Clear()
		
		table.insert(MapProperties_cl[MapSelectedProp][num],value)
		
		RefreshSubLists()
		
		text:SetValue("")
	
	end
end

function RemoveItemFromSubList(map,item,sub,list,num)
	
	if map then
		
		
		list:Clear()
		
		--item = nil
		
		MapProperties_cl[map][num] = MapProperties_cl[map][num] or {}
		
		for i,v in pairs(MapProperties_cl[map][num]) do
			if MapProperties_cl[map][num][i] == sub then
				MapProperties_cl[map][num][i] = nil
			end
		end
	
		RefreshSubLists()
	end
	
end

function AddNewMapProp()
	
	local name = DNewMapText:GetValue()
	
	MapProperties_cl[name] = { {} , {}, {}, false, 3}
	
	RebuildMapProperties()
	
end

function SaveMapProp()
	
	if MapSelectedProp then
		
		local name = tostring(MapSelectedProp)
		local stuff = tostring(util.TableToJSON(MapProperties_cl[name]))
		
		-- print("Clientside encoded: "..stuff)
		
		local test = util.JSONToTable(stuff)
		-- print("Clientside decoded: ")
		-- PrintTable(test)
		
		local tbl = {name, stuff}
		
		RunConsoleCommand("send_back_mapproperties",unpack(tbl))
	end
	
end

function RebuildMapProperties()
	
	DPropList:Clear()
	
	PropTab = {}
	
	for map, stuff in pairs(MapProperties_cl) do
				
		PropTab[map] = vgui.Create("DLabel")
		PropTab[map]:SetText("")-- MapCycle_cl[i].Map
		PropTab[map]:SetSize(DPropList:GetWide(),(MapPanelH-35)/15)
		PropTab[map].OnCursorEntered = function() 
			PropTab[map].Overed = true 
		end
		PropTab[map].OnCursorExited = function () 
			PropTab[map].Overed = false
		end
		PropTab[map].OnMousePressed = function() 
			MapSelectedProp = map
			RefreshSubLists()
		end
		PropTab[map].Paint = function()
			if PropTab[map].Overed or map == MapSelectedProp then
				surface.SetDrawColor( 255, 255, 255, 255)
				surface.DrawOutlinedRect( 0, 0,PropTab[map]:GetWide(), PropTab[map]:GetTall())
				surface.DrawOutlinedRect( 1, 1, PropTab[map]:GetWide()-2, PropTab[map]:GetTall()-2 )
			else
				surface.SetDrawColor( 30, 30, 30, 200 )
				surface.DrawOutlinedRect( 0, 0,PropTab[map]:GetWide(), PropTab[map]:GetTall())
				surface.SetDrawColor( 30, 30, 30, 255 )
				surface.DrawOutlinedRect( 1, 1, PropTab[map]:GetWide()-2, PropTab[map]:GetTall()-2 )
			end
					
			draw.SimpleTextOutlined ( map, "WeaponNames", 10, PropTab[map]:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
					
		end
						
		DPropList:AddItem(PropTab[map])
	end

end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Crates----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CrateTable = {}
CrateLabel = {}
function Sheet_Crates()
	
	DCrateLabel = vgui.Create("DLabel")
	DCrateLabel:SetText("")
	DCrateLabel:SizeToContents()
		
	DCrateInfoLabel = vgui.Create("DLabel",DCrateLabel)
	-- DCrateInfoLabel:SetPos(0,0)
	DCrateInfoLabel:SetText([[
	If you want to upload homemade files to server follow the steps:
	
	> 1. Create all nessesary crate files at your server ('data/zombiesurvival/crates' folder).
	> 2. Put them into your garry's mod ('garrysmod/data/zombiesurvival/crates' folder). Create folder if nessesary.
	> 3. Press 'Scan for clientside crate files' button and wait
	> 4. In the list you will see all avalaible files. Use 'Upload to server' button to overwrite serverside files.
	
	> Also there is no need to press 'Convert old map files to new', because it requires only one use!]])
	DCrateInfoLabel:SizeToContents()
	DCrateInfoLabel.Paint = function()
		surface.SetDrawColor( 30, 30, 30, 200 )
		surface.DrawOutlinedRect( 0, 0,DCrateInfoLabel:GetWide(), DCrateInfoLabel:GetTall())
		surface.SetDrawColor( 30, 30, 30, 255 )
		surface.DrawOutlinedRect( 1, 1, DCrateInfoLabel:GetWide()-2, DCrateInfoLabel:GetTall()-2 )
	end
	-- DCrateInfoLabel:SetSize(DCrateLabel:GetWide(),DCrateLabel:GetTall())
	
	--le button
	DCrateScanBtn = vgui.Create("DButton",DCrateLabel)
	DCrateScanBtn:SetText("Scan for clientside crate files")
	DCrateScanBtn:SetSkin("ZSMG")
	DCrateScanBtn:SetPos(0,DCrateInfoLabel:GetTall()+10)-- (0,ScaleH(300)+2)
	DCrateScanBtn:SetSize(DCrateInfoLabel:GetWide()-6,ScaleH(25))-- (DCrateLabel:GetWide()*0.9,ScaleH(20))
	DCrateScanBtn.DoClick = function()
		Crates_Scan()
	end
	
	--list
	DCrateFiles = vgui.Create( "DPanelList",DCrateLabel)
	DCrateFiles:SetSize(DCrateInfoLabel:GetWide()-6, ScaleH(200))
	DCrateFiles:SetPos(0,DCrateInfoLabel:GetTall()+20+DCrateScanBtn:GetTall())
	DCrateFiles:SetSkin("ZSMG")
	DCrateFiles:SetSpacing(0)
	DCrateFiles:SetPadding(0)
	DCrateFiles:EnableHorizontal( false )
	DCrateFiles:EnableVerticalScrollbar( true )
	DCrateFiles.Paint = function() 
		surface.SetDrawColor( 30, 30, 30, 200 )
		surface.DrawOutlinedRect( 0, 0,DCrateFiles:GetWide(), DCrateFiles:GetTall())
		surface.SetDrawColor( 30, 30, 30, 255 )
		surface.DrawOutlinedRect( 1, 1, DCrateFiles:GetWide()-2, DCrateFiles:GetTall()-2 )
	end
	
	DCrateConvBtn = vgui.Create("DButton",DCrateLabel)
	DCrateConvBtn:SetText("Convert old map files into new on server (DON'T PRESS IF STUFF WAS CONVERTED ALREADY!)")
	DCrateConvBtn:SetSkin("ZSMG")
	DCrateConvBtn:SetPos(0,DCrateInfoLabel:GetTall()+30+DCrateScanBtn:GetTall()+DCrateFiles:GetTall())-- (0,ScaleH(300)+2)
	DCrateConvBtn:SetSize(DCrateInfoLabel:GetWide()-6,ScaleH(45))-- (DCrateLabel:GetWide()*0.9,ScaleH(20))
	DCrateConvBtn.DoClick = function()
		-- Crates_Scan()
		RunConsoleCommand("zs_convertcrates")
	end
	
	
	MapSheet:AddSheet( "Crates", DCrateLabel, nil, false, false, nil )
	
end

function Crates_Scan()
	
	DCrateFiles:Clear()
	
	CrateTable = {}
	
	DCrateScanBtn:SetText("Please wait...")
	
	timer.Simple(1,function()
	
		for i,filename in pairs(file.Find("zombiesurvival/crates/*.txt","DATA")) do
			
			local name = string.sub(filename,1,-5)
			
			local stuff = file.Read("zombiesurvival/crates/"..filename)
			
			CrateTable[name] = util.JSONToTable(stuff)
			
			-- print(name)
			CrateLabel[name] = vgui.Create("DLabel")
			CrateLabel[name]:SetText("")
			CrateLabel[name]:SetSize(DCrateFiles:GetWide(),DCrateFiles:GetTall()/8)
			
			CrateLabel[name].OnCursorEntered = function() 
				CrateLabel[name].Overed = true 
			end
			CrateLabel[name].OnCursorExited = function () 
				CrateLabel[name].Overed = false
			end
					
			CrateLabel[name].OnMousePressed = function()
				Crates_Send(name)
			end
					
			CrateLabel[name].Paint = function()
				if CrateLabel[name].Overed then
					draw.SimpleTextOutlined ( "<<-------[Press to upload]", "WeaponNames", CrateLabel[name]:GetWide()-105, CrateLabel[name]:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				end
				if CrateLabel[name].Uploaded then
					draw.SimpleTextOutlined ( "<-Uploaded!->", "WeaponNames", CrateLabel[name]:GetWide()-25, CrateLabel[name]:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				end
				draw.SimpleTextOutlined ( name, "WeaponNames", 35, CrateLabel[name]:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))			
			end
			
			DCrateFiles:AddItem(CrateLabel[name])
			
		end
		
		DCrateScanBtn:SetText("Scan for clientside crate files")
		
		-- PrintTable(CrateTable)
	
	end)
	
end

function Crates_Send(name)
	
	if CrateTable[name] then
		for i, stuff in pairs(CrateTable[name]) do
			local tbl = {name,util.TableToJSON(stuff)}
			RunConsoleCommand("zs_importcrates",unpack(tbl))
		end
		RunConsoleCommand("zs_importcrates_confirm")
		surface.PlaySound("buttons/button24.wav")
		CrateLabel[name].Uploaded = true
	end
	
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Exploits----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ExploitTable = {}
ExploitLabel = {}
function Sheet_Exploits()
	
	DExploitLabel = vgui.Create("DLabel")
	DExploitLabel:SetText("")
	DExploitLabel:SizeToContents()
		
	DExploitInfoLabel = vgui.Create("DLabel",DExploitLabel)

	DExploitInfoLabel:SetText([[
	If you want to upload homemade files to server follow the steps:
	
	> 1. Create all nessesary crate files at your server ('data/zombiesurvival/exploits' folder).
	> 2. Put them into your garry's mod ('garrysmod/data/zombiesurvival/exploits' folder). Create folder if nessesary.
	> 3. Press 'Scan for clientside exploit boxes files' button and wait
	> 4. In the list you will see all avalaible files. Use 'Upload to server' button to overwrite serverside files.
	
	> Also there is no need to press 'Convert old map files to new', because it requires only one use!]])
	DExploitInfoLabel:SizeToContents()
	DExploitInfoLabel.Paint = function()
		surface.SetDrawColor( 30, 30, 30, 200 )
		surface.DrawOutlinedRect( 0, 0,DExploitInfoLabel:GetWide(), DExploitInfoLabel:GetTall())
		surface.SetDrawColor( 30, 30, 30, 255 )
		surface.DrawOutlinedRect( 1, 1, DExploitInfoLabel:GetWide()-2, DExploitInfoLabel:GetTall()-2 )
	end

	DExploitScanBtn = vgui.Create("DButton",DExploitLabel)
	DExploitScanBtn:SetText("Scan for clientside exploit boxes files")
	DExploitScanBtn:SetSkin("ZSMG")
	DExploitScanBtn:SetPos(0,DExploitInfoLabel:GetTall()+10)-- (0,ScaleH(300)+2)
	DExploitScanBtn:SetSize(DExploitInfoLabel:GetWide()-6,ScaleH(25))-- (DCrateLabel:GetWide()*0.9,ScaleH(20))
	DExploitScanBtn.DoClick = function()
		Exploits_Scan()
	end
	
	--list
	DExploitFiles = vgui.Create( "DPanelList",DExploitLabel)
	DExploitFiles:SetSize(DExploitInfoLabel:GetWide()-6, ScaleH(200))
	DExploitFiles:SetPos(0,DExploitInfoLabel:GetTall()+20+DExploitScanBtn:GetTall())
	DExploitFiles:SetSkin("ZSMG")
	DExploitFiles:SetSpacing(0)
	DExploitFiles:SetPadding(0)
	DExploitFiles:EnableHorizontal( false )
	DExploitFiles:EnableVerticalScrollbar( true )
	DExploitFiles.Paint = function() 
		surface.SetDrawColor( 30, 30, 30, 200 )
		surface.DrawOutlinedRect( 0, 0,DExploitFiles:GetWide(), DExploitFiles:GetTall())
		surface.SetDrawColor( 30, 30, 30, 255 )
		surface.DrawOutlinedRect( 1, 1, DExploitFiles:GetWide()-2, DExploitFiles:GetTall()-2 )
	end
	
	DExploitConvBtn = vgui.Create("DButton",DExploitLabel)
	DExploitConvBtn:SetText("Convert old map files into new on server (DON'T PRESS IF STUFF WAS CONVERTED ALREADY!)")
	DExploitConvBtn:SetSkin("ZSMG")
	DExploitConvBtn:SetPos(0,DExploitInfoLabel:GetTall()+30+DExploitScanBtn:GetTall()+DExploitFiles:GetTall())-- (0,ScaleH(300)+2)
	DExploitConvBtn:SetSize(DExploitInfoLabel:GetWide()-6,ScaleH(45))-- (DExploitLabel:GetWide()*0.9,ScaleH(20))
	DExploitConvBtn.DoClick = function()
		-- Crates_Scan()
		RunConsoleCommand("zs_convertexploits")
	end
	
	
	MapSheet:AddSheet( "Exploit Boxes", DExploitLabel, nil, false, false, nil )
	
end

function Exploits_Scan()
	
	DCrateFiles:Clear()
	
	ExploitTable = {}
	
	DExploitScanBtn:SetText("Please wait...")
	
	timer.Simple(1,function()
	
		for i,filename in pairs(file.Find("zombiesurvival/exploits/*.txt","DATA")) do
			
			local name = string.sub(filename,1,-5)
			
			local stuff = file.Read("zombiesurvival/exploits/"..filename)
			
			ExploitTable[name] = util.JSONToTable(stuff)
			
			-- print(name)
			ExploitLabel[name] = vgui.Create("DLabel")
			ExploitLabel[name]:SetText("")
			ExploitLabel[name]:SetSize(DExploitFiles:GetWide(),DExploitFiles:GetTall()/8)
			
			ExploitLabel[name].OnCursorEntered = function() 
				ExploitLabel[name].Overed = true 
			end
			ExploitLabel[name].OnCursorExited = function () 
				ExploitLabel[name].Overed = false
			end
					
			ExploitLabel[name].OnMousePressed = function()
				Exploits_Send(name)
			end
					
			ExploitLabel[name].Paint = function()
				if ExploitLabel[name].Overed then
					draw.SimpleTextOutlined ( "<<-------[Press to upload]", "WeaponNames", ExploitLabel[name]:GetWide()-105, ExploitLabel[name]:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				end
				if ExploitLabel[name].Uploaded then
					draw.SimpleTextOutlined ( "<-Uploaded!->", "WeaponNames", ExploitLabel[name]:GetWide()-25, ExploitLabel[name]:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
				end
				draw.SimpleTextOutlined ( name, "WeaponNames", 35, ExploitLabel[name]:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))			
			end
			
			DExploitFiles:AddItem(ExploitLabel[name])
			
		end
		
		DExploitScanBtn:SetText("Scan for clientside exploit boxes files")
		
		-- PrintTable(CrateTable)
	
	end)
	
end

function Exploits_Send(name)
	
	if ExploitTable[name] then
		for i, stuff in pairs(ExploitTable[name]) do
			local tbl = {name,util.TableToJSON(stuff)}
			RunConsoleCommand("zs_importexploits",unpack(tbl))
		end
		RunConsoleCommand("zs_importexploits_confirm")
		surface.PlaySound("buttons/button24.wav")
		ExploitTable[name].Uploaded = true
	end
	
end