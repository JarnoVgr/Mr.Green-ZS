-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local function CheckChanged ( obj, strNewValue )
	strNewValue = tostring(strNewValue)
	if obj.m_strConVar and strNewValue ~= tostring(GetConVarNumber(obj.m_strConVar)) then
		RunConsoleCommand(string.sub(obj.m_strConVar, 2), strNewValue)
	end
end

-- Reset options panel when after buying title editor
function removeOptions()
	if pOptions then
		pOptions:Remove()
		pOptions = nil
	end
end
usermessage.Hook("removeOptions",removeOptions)


function MakepOptions()
	if not MySelf then return end
	if pOptions then
		pOptions:SetVisible(true)
		pOptions:MakePopup()
		return
	end
	
	local Window = vgui.Create("DFrame")
	local wide = w/4
	local tall = h/2
	Window:SetSize(wide, tall)
	local wide = (w - wide) * 0.5
	local tall = (h - tall) * 0.5
	Window:SetPos(wide, tall)
	Window:SetTitle("Options")
	Window:SetSkin("ZSMG")
	Window:SetVisible(true)
	Window:SetDraggable(false)
	Window:MakePopup()
	Window:SetDeleteOnClose(false)
	Window:SetCursor("pointer")
	pOptions = Window
	
	local winW,winH = pOptions:GetWide(), pOptions:GetTall()
	
	-- define our categories and lists
	local FrameList
	local Cat = {} -- no jokes
	local CatList = {}
	
	FrameList = vgui.Create( "DPanelList", pOptions )
	FrameList:SetSize( winW-10, winH-45 )
	FrameList:SetPos( winW/2-FrameList:GetWide()/2,35 )
	FrameList:SetSpacing( 1 )
	FrameList:EnableHorizontal( false )
	FrameList:EnableVerticalScrollbar( true )
	FrameList.Paint = function() end -- dont draw this
	
	-- HUD
	Cat["hud"] = vgui.Create("DCollapsibleCategory", pOptions)
	Cat["hud"]:SetSize( winW-10, 50 )
	Cat["hud"]:SetPos( winW/2-Cat["hud"]:GetWide()/2,50 )
	Cat["hud"]:SetExpanded( false )
	Cat["hud"]:SetLabel( "HUD and Sound" )
	-- Cat["hud"].Paint = function()

	-- end
	FrameList:AddItem( Cat["hud"] )
	
	-- Stuff for hud---------	
	CatList["hud"] = vgui.Create( "DPanelList" )
	CatList["hud"]:SetAutoSize( true )
	CatList["hud"]:SetSpacing( 3 )
	CatList["hud"]:SetPadding( 3 )
	CatList["hud"]:EnableHorizontal( false )
	CatList["hud"]:EnableVerticalScrollbar( true )
	CatList["hud"].Paint = function()
		
	end
	Cat["hud"]:SetContents( CatList["hud"] )	
	
	local slider = vgui.Create("DNumSlider")
	slider:SizeToContents()
	slider:SetDecimals(0)
	slider:SetMinMax(45, 125)
	slider:SetConVar("zs_wepfov")
	slider:SetText("Field Of View")
	CatList["hud"]:AddItem( slider )
	
	
	-- ---------------------------
	
	-- Gameplay and stuff
	Cat["gmp"] = vgui.Create("DCollapsibleCategory", pOptions)
	Cat["gmp"]:SetSize( winW-10, 50 )
	-- Cat["gmp"]:SetPos( winW/2-Cat["gmp"]:GetWide()/2,50 )
	Cat["gmp"]:SetExpanded( false )
	Cat["gmp"]:SetLabel( "Gameplay" )
	FrameList:AddItem( Cat["gmp"] )
	
	-- Stuff for gameplay---------	
	CatList["gmp"] = vgui.Create( "DPanelList" )
	CatList["gmp"]:SetAutoSize( true )
	CatList["gmp"]:SetSpacing( 3 )
	CatList["gmp"]:SetPadding( 3 )
	CatList["gmp"]:EnableHorizontal( false )
	CatList["gmp"]:EnableVerticalScrollbar( true )
	CatList["gmp"].Paint = function()
		
	end
	Cat["gmp"]:SetContents( CatList["gmp"] )	
	
	
	-- Misc
	Cat["misc"] = vgui.Create("DCollapsibleCategory", pOptions)
	Cat["misc"]:SetSize( winW-10, 50 )
	Cat["misc"]:SetExpanded( false )
	Cat["misc"]:SetLabel( "Miscellaneous" )
	FrameList:AddItem( Cat["misc"] )
	
	-- Stuff for gameplay---------	
	CatList["misc"] = vgui.Create( "DPanelList" )
	CatList["misc"]:SetAutoSize( true )
	CatList["misc"]:SetSpacing( 3 )
	CatList["misc"]:SetPadding( 3 )
	CatList["misc"]:EnableHorizontal( false )
	CatList["misc"]:EnableVerticalScrollbar( true )
	CatList["misc"].Paint = function()
		
	end
	Cat["misc"]:SetContents( CatList["misc"] )
	
	-- title editor	
	if ( MySelf.DataTable and MySelf.DataTable["ShopItems"][ util.GetItemID( "titlechanging" ) ] ) then
		
		local yh = 0
		
		local title = vgui.Create("DLabel")
		title:SetText("")
		title:SetSkin("ZSMG")
		
		
		local titleeditlabel = vgui.Create("DLabel",title)
		titleeditlabel:SetText( "Title editor" )
		titleeditlabel:SetPos( 3, 0 )--wide+32
		titleeditlabel:SizeToContents()

		local titlefield = vgui.Create("DTextEntry",title)
		titlefield:SetText( MySelf.Title )
		titlefield:SetPos( 3, titleeditlabel:GetTall() + 3 ) --wide+32
		titlefield:SetSize( 140, 20 )
		titlefield:SetEditable( true )
		titlefield:SetMultiline( false )
		
		local submitbutton = vgui.Create("DButton", title)
		submitbutton:SetPos(146, titleeditlabel:GetTall() + 3)--wide+175
		submitbutton:SetSize(80, 20)
		submitbutton:SetText("Submit")
		
		
		submitbutton.DoClick = function(btn) 
			-- ValidTitle can be found in shared.lua
			if ValidTitle(MySelf, titlefield:GetValue()) then
				RunConsoleCommand("mrgreen_settitle",titlefield:GetValue())
				titlefield:SetText("< Updating... >")
				titlefield:SetEditable( false )
				timer.Simple(0.5,function()
					if titlefield then
						titlefield:SetText(MySelf.Title)
						titlefield:SetEditable( true )
					end
				end)
			else
				titlefield:SetText("< Invalid title! >")
				titlefield:SetEditable( false )
				timer.Simple(1,function()
					if titlefield then
						titlefield:SetText(MySelf.Title)
						titlefield:SetEditable( true )
					end
				end)
			end
		end
		
		local infolabel = vgui.Create("DLabel",title)
		infolabel:SetText( "Max. title length is 24 characters. \nSome characters and words are disallowed." )
		infolabel:SetPos( 3, titleeditlabel:GetTall() + 26 )--wide+32
		infolabel:SetSize( 240, 50 )
		
		yh = yh + titleeditlabel:GetTall() + 76
		
		title:SetSize(300,yh)
		title:SizeToContentsX()
		
		CatList["misc"]:AddItem( title )
	end
	
	
	-- turret's name
		
		local title1 = vgui.Create("DLabel")
		title1:SetText("")
		title1:SetSkin("ZSMG")
		
		
		local titleeditlabel1 = vgui.Create("DLabel",title1)
		titleeditlabel1:SetText( "Turret's name" )
		titleeditlabel1:SetPos( 3, 0 )--wide+32
		titleeditlabel1:SizeToContents()

		local titlefield1 = vgui.Create("DTextEntry",title1)
		titlefield1:SetText( GetConVarString("_zs_turretnicknamefix") )
		titlefield1:SetPos( 3, titleeditlabel1:GetTall() + 3 ) --wide+32
		titlefield1:SetSize( 140, 20 )
		titlefield1:SetEditable( true )
		titlefield1:SetMultiline( false )
		
		local submitbutton1 = vgui.Create("DButton", title1)
		submitbutton1:SetPos(146, titleeditlabel1:GetTall() + 3)--wide+175
		submitbutton1:SetSize(80, 20)
		submitbutton1:SetText("Submit")
		submitbutton1.DoClick = function(btn) 
			-- ValidTitle can be found in shared.lua
			if ValidTurretNick(MySelf, titlefield1:GetValue()) then
				RunConsoleCommand("zs_turretnickname",titlefield1:GetValue())
				
				titlefield1:SetText("< Updating... >")
				titlefield1:SetEditable( false )
				timer.Simple(0.5,function()
					if titlefield1 then
						titlefield1:SetText(GetConVarString("_zs_turretnicknamefix"))
						titlefield1:SetEditable( true )
					end
				end)
			else
				titlefield1:SetText("< Invalid name! >")
				titlefield1:SetEditable( false )
				timer.Simple(1,function()
					if titlefield1 then
						titlefield1:SetText(GetConVarString("_zs_turretnicknamefix"))
						titlefield1:SetEditable( true )
					end
				end)
			end
		end
				
		title1:SetSize(300,titleeditlabel1:GetTall() + 26)
		title1:SizeToContentsX()
		
		CatList["misc"]:AddItem( title1 )

	if ( MySelf.DataTable and MySelf.DataTable["ShopItems"][ util.GetItemID( "hatpainter" ) ] ) then
	
		local hatp = vgui.Create( "DPanel" )	
		hatp:SetSkin("ZSMG")
		hatp.Paint = function() end
			
		local hatpainterlabel = vgui.Create("DLabel",hatp)
		hatpainterlabel:SetText( "Hat Painter (Re-equip hat to apply)" )
		hatpainterlabel:SetPos( 3, 0 )
		hatpainterlabel:SizeToContents()
		
		local colpicker = vgui.Create("DColorMixer",hatp)
		colpicker:SetConVarR("_zs_hatpcolR")
		colpicker:SetConVarG("_zs_hatpcolG")
		colpicker:SetConVarB("_zs_hatpcolB")
		colpicker:SetPos( 3, hatpainterlabel:GetTall() + 3 ) --wide+32
		colpicker:SetSize( Cat["misc"]:GetWide()-80, 74 )

		
		local hatpreview = vgui.Create( "DModelPanel",hatp )
		hatpreview:SetSize(colpicker:GetTall(),colpicker:GetTall())
		hatpreview:SetPos(colpicker:GetWide()+1,hatpainterlabel:GetTall() + 3)
		hatpreview.AutoCam = function(self)
			if IsValid(self.Entity) then
				local mins, maxs = self.Entity:GetRenderBounds()
				self:SetCamPos(mins:Distance(maxs) * Vector(0.75, 0.75, 0.5))
				self:SetLookAt((mins + maxs) / 2)
			end
		end
		
		hatpreview.Paint = function(self)
		
			if ( not IsValid( self.Entity ) ) then return end
			
			if self.Entity:GetModel() == "models/props_c17/doll01.mdl" then
				draw.SimpleTextOutlined ( "No hat", "WeaponNames", hatpreview:GetTall()/2,hatpreview:GetTall()/2, Color(255, 255, 255, 255) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
			end
		
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
			
			if self.Entity:GetModel() ~= "models/props_c17/doll01.mdl" then	
				self.Entity:DrawModel()
			end
					
			render.SuppressEngineLighting( false )
			cam.IgnoreZ( false )
			cam.End3D()
			
			self.LastPaint = RealTime()
	
		end

		hatpreview.Think = function()
			local col = colpicker:GetColor()
			hatpreview:SetColor(Color(col.r,col.g,col.b))
			if ValidEntity(MySelf.Hat) then
				local hat
				local h = string.Explode("$",MySelf.Hat:GetHatType())
				for k,v in pairs(h) do
					if hats[v] and PureHats[v] then
						hat = hats[v]["1"].model
					end
				end
				 -- = hats[MySelf.Hat:GetHatType()]["1"].model
				if hat then
					if not hatpreview.Entity then
						hatpreview:SetModel(hat)
						hatpreview:AutoCam()
					else
						if hatpreview.Entity:GetModel() ~= hat then
							hatpreview:SetModel(hat)
							hatpreview:AutoCam()
						end
					end
				end
			else
				if not hatpreview.Entity then
					hatpreview:SetModel("models/props_c17/doll01.mdl")
					hatpreview:AutoCam()
				else
					if hatpreview.Entity:GetModel() ~= "models/props_c17/doll01.mdl" then
						hatpreview:SetModel("models/props_c17/doll01.mdl")
						hatpreview:AutoCam()
					end
				end
			end
		end
		
		hatp:SetSize(300,hatpainterlabel:GetTall() + 80)
		hatp:SizeToContentsX()
		
		CatList["misc"]:AddItem( hatp )	
	end
	
	
	
	-- fill stuff with convars
	local Items = {}
	local counter = 1
	
	for convarname,args in pairs(ClientsideConvars) do
		if args.CanChange == true then
			Items[convarname] = vgui.Create( "DCheckBoxLabel" )
			Items[convarname]:SetText( args.Description )
			Items[convarname]:SetConVar( convarname )
			Items[convarname]:SetValue( GetConVarNumber(convarname) )
			Items[convarname]:SizeToContents()
			CatList[args.Category]:AddItem( Items[convarname] )
		end
	end
	
	
end

-- Hat drawing
-- CreateClientConVar("_zs_enablehats", 1, true, false)
ENABLE_HATS = util.tobool(GetConVarNumber("_zs_enablehats"))
local function EnableHats(sender, command, arguments)
	ENABLE_HATS = util.tobool(arguments[1])

	if ENABLE_HATS then
		RunConsoleCommand("_zs_enablehats", "1")
		MySelf:ChatPrint("Hat drawing enabled.")
	else
		RunConsoleCommand("_zs_enablehats", "0")
		MySelf:ChatPrint("Hat drawing disabled.")
	end
end
concommand.Add("zs_enablehats", EnableHats)

-- Auto redeem
-- CreateClientConVar("_zs_autoredeem", 1, true, false)
AUTOREDEEM = util.tobool( GetConVarNumber("_zs_autoredeem") )
local function EnableAutoRedeem(sender, command, arguments)
	AUTOREDEEM = util.tobool( arguments[1] )

	if AUTOREDEEM then
		RunConsoleCommand("_zs_autoredeem", "1")
		RunConsoleCommand("zs_setautoredeem", "1")
		MySelf:ChatPrint("Auto Redeem enabled.")
	else
		RunConsoleCommand("_zs_autoredeem", "0")
		RunConsoleCommand("zs_setautoredeem", "0")
		MySelf:ChatPrint("Auto Redeem disabled.")
	end
end
concommand.Add("zs_autoredeem", EnableAutoRedeem)




