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
	
	//define our categories and lists
	local FrameList
	local Cat = {} //no jokes
	local CatList = {}
	
	FrameList = vgui.Create( "DPanelList", pOptions )
	FrameList:SetSize( winW-10, winH-45 )
	FrameList:SetPos( winW/2-FrameList:GetWide()/2,35 )
	FrameList:SetSpacing( 1 )
	FrameList:EnableHorizontal( false )
	FrameList:EnableVerticalScrollbar( true )
	FrameList.Paint = function() end //dont draw this
	
	//HUD
	Cat["hud"] = vgui.Create("DCollapsibleCategory", pOptions)
	Cat["hud"]:SetSize( winW-10, 50 )
	Cat["hud"]:SetPos( winW/2-Cat["hud"]:GetWide()/2,50 )
	Cat["hud"]:SetExpanded( false )
	Cat["hud"]:SetLabel( "HUD and Sound Options" )
	//Cat["hud"].Paint = function()

	//end
	FrameList:AddItem( Cat["hud"] )
	
	//Stuff for hud---------	
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
	slider:SetConVar("_zs_wepfov")
	slider:SetText("Weapon's FOV")
	/*slider.Wang.TextEntry.OnEnter = function(txt)
        slider:SetValue(tonumber(txt:GetValue()));
    end*/
	CatList["hud"]:AddItem( slider )
	
	
	//---------------------------
	
	//Gameplay and stuff
	Cat["gmp"] = vgui.Create("DCollapsibleCategory", pOptions)
	Cat["gmp"]:SetSize( winW-10, 50 )
	//Cat["gmp"]:SetPos( winW/2-Cat["gmp"]:GetWide()/2,50 )
	Cat["gmp"]:SetExpanded( false )
	Cat["gmp"]:SetLabel( "Gameplay stuff" )
	FrameList:AddItem( Cat["gmp"] )
	
	//Stuff for gameplay---------	
	CatList["gmp"] = vgui.Create( "DPanelList" )
	CatList["gmp"]:SetAutoSize( true )
	CatList["gmp"]:SetSpacing( 3 )
	CatList["gmp"]:SetPadding( 3 )
	CatList["gmp"]:EnableHorizontal( false )
	CatList["gmp"]:EnableVerticalScrollbar( true )
	CatList["gmp"].Paint = function()
		
	end
	Cat["gmp"]:SetContents( CatList["gmp"] )	
	
	
	//Misc
	Cat["misc"] = vgui.Create("DCollapsibleCategory", pOptions)
	Cat["misc"]:SetSize( winW-10, 50 )
	Cat["misc"]:SetExpanded( false )
	Cat["misc"]:SetLabel( "Other options" )
	FrameList:AddItem( Cat["misc"] )
	
	//Stuff for gameplay---------	
	CatList["misc"] = vgui.Create( "DPanelList" )
	CatList["misc"]:SetAutoSize( true )
	CatList["misc"]:SetSpacing( 3 )
	CatList["misc"]:SetPadding( 3 )
	CatList["misc"]:EnableHorizontal( false )
	CatList["misc"]:EnableVerticalScrollbar( true )
	CatList["misc"].Paint = function()
		
	end
	Cat["misc"]:SetContents( CatList["misc"] )
	
	//title editor	
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
	
	
	//turret's name
		
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
		
			if ( !IsValid( self.Entity ) ) then return end
			
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
				 //= hats[MySelf.Hat:GetHatType()]["1"].model
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
	
	
	
	//fill stuff with convars
	local Items = {}
	local counter = 1
	
	for convarname,args in pairs(ClientsideConvars) do
		Items[convarname] = vgui.Create( "DCheckBoxLabel" )
		Items[convarname]:SetText( args.Description )
		Items[convarname]:SetConVar( convarname )
		Items[convarname]:SetValue( GetConVarNumber(convarname) )
		Items[convarname]:SizeToContents()
		CatList[args.Category]:AddItem( Items[convarname] )
	end
	
	
end
/*
function MakepOptions1()
	if not MySelf then return end
	if pOptions then
		pOptions:SetVisible(true)
		pOptions:MakePopup()
		return
	end

	local Window = vgui.Create("DFrame")
	local wide = w * 0.6
	local tall = h * 0.55
	Window:SetSize(wide, tall)
	local wide = (w - wide) * 0.5
	local tall = (h - tall) * 0.5
	Window:SetPos(wide, tall)
	Window:SetTitle(" ")
	Window:SetSkin("ZSMG")
	Window:SetVisible(true)
	Window:SetDraggable(false)
	Window:MakePopup()
	Window:SetDeleteOnClose(false)
	Window:SetCursor("pointer")
	pOptions = Window

	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(COLOR_RED)
	label:SetFont("HUDFontSmaller")
	label:SetText("Options")
	label:SetPos(16, 22)
	surface.SetFont("HUDFontSmaller")
	local texw, texh = surface.GetTextSize("Options")
	label:SetSize(texw, texh)

	local xpos = 32
	
	surface.SetFont("Default")
	local ___, defh = surface.GetTextSize("|")
	
	local slider = vgui.Create("DNumSlider", Window)
	slider:SetPos(xpos, 50)
	slider:SetSize(200, 48)
	slider:SetDecimals(0)
	slider:SetMinMax(45, 95)
	slider:SetConVar("_zs_wepfov")
	slider:SetText("Weapon's FOV")
	slider.Wang.TextEntry.OnEnter = function(txt)
            slider:SetValue(tonumber(txt:GetValue()));
    end
	
	local slider = vgui.Create("DNumSlider", Window)
	slider:SetPos(xpos, 110)
	slider:SetSize(200, 48)
	slider:SetDecimals(0)
	slider:SetMinMax(0, 1600)
	slider:SetConVar("cl_detaildist")
	slider:SetText("Detail distance")
	slider.Wang.TextEntry.OnEnter = function(txt)
            slider:SetValue(tonumber(txt:GetValue()));
    end
	
	local drawy = 140

	drawy = drawy+30
	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(xpos, drawy)
	check:SetSize(wide, 32)
	check:SetText("Draw flashlights")
	check:SetConVar("r_shadows")
	
	drawy = drawy+30
	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(xpos, drawy)
	check:SetSize(wide, 32)
	check:SetText("Draw hats")
	check:SetConVar("_zs_enablehats")
	check.Button.ConVarChanged = CheckChanged
	

	--[[drawy = drawy+30
	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(32, drawy)
	check:SetSize(wide, 32)
	check:SetText("Use new HUD")
	check:SetConVar("_zs_newhud")
	check.Button.ConVarChanged = CheckChanged]]
	
	--[[drawy = drawy+30
	local hudstyleslabel = vgui.Create("DLabel",Window)
	hudstyleslabel:SetText( "Available HUD styles:" )
	hudstyleslabel:SetPos( 32, drawy )
	hudstyleslabel:SetSize( wide, 32 )
	
	drawy = drawy+30
	local hudlist = vgui.Create("DComboBox",Window) 
	hudlist:SetPos( 32, drawy ) 
	hudlist:SetSize( 200, 50 ) -- 180, 395
	hudlist:SetMultiple(false)
	styleslist = {"Futuristic","Transparant (default)","Old Green"}
	hudlist:Clear()
	local item
	function itemDoClick(btn)
		local item = btn.ItemType
		RunConsoleCommand("zs_hudstyle",item)
	end
	for k, v in pairs(styleslist) do
		item = hudlist:AddItem(v)
		item.ItemType = k
		item.DoClick = itemDoClick
	end]]

	--local oldpaint = hudlist.Paint
	--[[hudstyleslabel.Paint = function()
		print("Test: ".. tonumberhudlist.GetSelected())
		--oldpaint()
		RunConsoleCommand("zs_newhud",1)
	end]]

	
	drawy = drawy+30
	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(xpos, drawy)
	check:SetSize(wide, 32)
	check:SetText("Enable additional healthbar (as human)")
	check:SetConVar("_zs_enablehpbar")
	check.Button.ConVarChanged = CheckChanged
	
	drawy = drawy+30
	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(xpos, drawy)
	check:SetSize(wide, 32)
	check:SetText("Enable auto redeem when zombie")
	check:SetConVar("_zs_autoredeem")
	check.Button.ConVarChanged = CheckChanged
	
	-- next column
	drawy = 80
	xpos = pOptions:GetWide()/2.3
	
	drawy = drawy+30
	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(xpos, drawy)
	check:SetSize(xpos, 32)
	check:SetText("Enable beats")
	check:SetConVar("_zs_enablebeats")
	check.Button.ConVarChanged = CheckChanged
	
	drawy = drawy+30
	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(xpos, drawy)
	check:SetSize(xpos, 32)
	check:SetText("Enable old beats")
	check:SetToolTip("Disables the new beats created by Little Nemo")
	check:SetConVar("_zs_enableoldbeats")
	check.Button.ConVarChanged = CheckChanged
	
	drawy = drawy+30
	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(xpos, drawy)
	check:SetSize(xpos, 32)
	check:SetText("Enable old zombie beats")
	check:SetConVar("_zs_enableoldbeats1")
	check.Button.ConVarChanged = CheckChanged
	
	drawy = drawy+30
	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(xpos, drawy)
	check:SetSize(xpos, 32)
	check:SetText("Enable HUD for horde-meter")
	check:SetConVar("_zs_showhorde")
	check.Button.ConVarChanged = CheckChanged
	
	drawy = drawy+30
	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(xpos, drawy)
	check:SetSize(xpos, 32)
	check:SetText("Enable dark color mod and bloom")
	check:SetToolTip("Only for humans")
	check:SetConVar("_zs_hcolormod")
	check.Button.ConVarChanged = CheckChanged
	
	--drawy = drawy+30
	--local check = vgui.Create("DCheckBoxLabel", Window)
	--check:SetPos(xpos, drawy)
	--check:SetSize(xpos, 32)
	--check:SetText("Enable screen blood")
	--check:SetConVar("_zs_enablescreenblood")
	--check.Button.ConVarChanged = CheckChanged
	
	drawy = 80
	xpos = pOptions:GetWide()/1.3
	--[[local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(wide + 32, drawy)
	check:SetSize(wide, 32)
	check:SetText("Disable ALL post processing effects")
	check:SetConVar("_disable_pp")
	check.Button.ConVarChanged = CheckChanged]]

	drawy = drawy+30
	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(xpos, drawy)
	check:SetSize(xpos, 32)
	check:SetText("Enable film grain")
	check:SetConVar("_zs_enablefilmgrain")
	check.Button.ConVarChanged = CheckChanged

	--[[drawy = drawy+30
	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(wide + 32, drawy)
	check:SetSize(wide, 32)
	check:SetText("Enable color modifications")
	check:SetConVar("_zs_enablecolormod")
	check.Button.ConVarChanged = CheckChanged]]

	drawy = drawy+30
	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(xpos, drawy)
	check:SetSize(xpos, 32)
	check:SetText("Enable all music")
	check:SetConVar("_zs_enablemusic")
	check.Button.ConVarChanged = CheckChanged
	
	drawy = drawy+30
	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(xpos, drawy)
	check:SetSize(xpos, 32)
	check:SetText("Enable crosshair while ironsight")
	check:SetConVar("_zs_ironsight")
	check.Button.ConVarChanged = CheckChanged
	
	drawy = drawy+30
	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetPos(xpos, drawy)
	check:SetSize(130, 32)
	check:SetText("Enable small fov")
	check:SetConVar("_zs_customweaponpos")
	check.Button.ConVarChanged = CheckChanged

	--[[local modellist = vgui.Create("DComboBox",Window) 
	modellist:SetPos( 32, drawy ) 
	modellist:SetSize( 200, 50 ) -- 180, 395
	modellist:SetMultiple(false)
	modelslist = {"Kleiner","Alyx","Mossman","Father Grigori","Rebel","Citizen","Eli"}
	hudlist:Clear()
	local item
	function modelDoClick(btn)
		local item = btn.ItemType
		RunConsoleCommand("cl_playermodel",item)
	end
	for k, v in pairs(modelslist) do
		item = hudlist:AddItem(v)
		item.ItemType = k
		item.DoClick = modelDoClick
	end]]

	if ( MySelf.DataTable and MySelf.DataTable["ShopItems"][ util.GetItemID( "titlechanging" ) ] ) then
		local titleeditlabel = vgui.Create("DLabel",Window)
		titleeditlabel:SetText( "Title editor" )
		titleeditlabel:SetPos( 32, 290 )--wide+32
		titleeditlabel:SetSize( 180, 22 )

		local titlefield = vgui.Create("DTextEntry",Window)
		titlefield:SetText( MySelf.Title )
		titlefield:SetPos( 32, 312 ) --wide+32
		titlefield:SetSize( 140, 20 )
		titlefield:SetEditable( true )
		titlefield:SetMultiline( false )
		
		local submitbutton = vgui.Create("DButton", Window)
		submitbutton:SetPos(182, 312)--wide+175
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
		
		local infolabel = vgui.Create("DLabel",Window)
		infolabel:SetText( "Max. title length is 24 characters. \nSome characters and words are disallowed." )
		infolabel:SetPos( 32, 330 )--wide+32
		infolabel:SetSize( 240, 50 )
	end
	
	
		local titleeditlabel1 = vgui.Create("DLabel",Window)
		titleeditlabel1:SetText( "Turret's name" )
		titleeditlabel1:SetPos( 330, 290 )--wide+32
		titleeditlabel1:SetSize( 180, 22 )

		local titlefield1 = vgui.Create("DTextEntry",Window)
		titlefield1:SetText( GetConVarString("_zs_turretnicknamefix") )
		titlefield1:SetPos( 330, 312 ) --wide+32
		titlefield1:SetSize( 140, 20 )
		titlefield1:SetEditable( true )
		titlefield1:SetMultiline( false )
		
		local submitbutton1 = vgui.Create("DButton", Window)
		submitbutton1:SetPos(490, 312)--wide+175
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
		
	
	--[[
	//Class button
	local ClassButton = vgui.Create("DButton",Window)
	ClassButton:SetText( "Redeem as: "..HumanClasses[GetConVarNumber("_zs_redeemclass")].Name.."" )
	ClassButton:SetPos(365, 312)
	ClassButton:SetSize(170, 38)
	ClassButton.DoClick = function(btn)
		local ClassMenu = DermaMenu()
		ClassMenu:AddOption("Medic", function() RunConsoleCommand("_zs_redeemclass", "1"); RunConsoleCommand("mrgreen_setredeemclass", "1"); ClassButton:SetText( "Redeem as: Medic" ) end )
		ClassMenu:AddOption("Commando", function() RunConsoleCommand("_zs_redeemclass", "2"); RunConsoleCommand("mrgreen_setredeemclass", "2"); ClassButton:SetText( "Redeem as: Commando" ) end )	
		ClassMenu:AddOption("Berserker", function() RunConsoleCommand("_zs_redeemclass", "3"); RunConsoleCommand("mrgreen_setredeemclass", "3"); ClassButton:SetText( "Redeem as: Berserker" ) end )	
		ClassMenu:AddOption("Engineer", function() RunConsoleCommand("_zs_redeemclass", "4"); RunConsoleCommand("mrgreen_setredeemclass", "4");	ClassButton:SetText( "Redeem as: Engineer" ) end )
		ClassMenu:AddOption("Support", function() RunConsoleCommand("_zs_redeemclass", "5"); RunConsoleCommand("mrgreen_setredeemclass", "5"); ClassButton:SetText( "Redeem as: Support" ) end )
		ClassMenu:Open()
	end
	]]
	
	local lbw,lbh = xpos, 220 
	local Classlabel = vgui.Create("DLabel",Window)
	Classlabel:SetText( "Change class:"  )
	Classlabel:SetPos( lbw, lbh )
	Classlabel:SetSize( 180, 22 )
	
	local ClassMenu = vgui.Create( "DComboBox", Window )
	ClassMenu:SetPos(lbw, lbh+20)
	ClassMenu:SetSize( 70, 117 )
	ClassMenu:SetMultiple( false )
	
	local item
	for k, v in pairs(HumanClasses) do
		if k == 3 then
			item = ClassMenu:AddItem( "Marksman" )
		else
			item = ClassMenu:AddItem( HumanClasses[k].Name )
		end
		item.DoClick = function(btn)
			RunConsoleCommand("_zs_redeemclass", ""..k.."") 
			RunConsoleCommand("mrgreen_setredeemclass", ""..k.."")
		end
	end
	local name
	if GetConVarNumber("_zs_redeemclass") == 3 then
		name = "Marksman"
	else
		name = HumanClasses[GetConVarNumber("_zs_redeemclass")].Name 
	end
	ClassMenu:SelectByName( name )
	
	local button = vgui.Create("DButton", Window)
	button:SetPos(pOptions:GetWide()/2-70, Window:GetTall() - 64)
	button:SetSize(140, 32)
	button:SetText("Close")
	button.DoClick = function(btn) btn:GetParent():SetVisible(false) end
end
*/


-- Hat drawing
//CreateClientConVar("_zs_enablehats", 1, true, false)
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
//CreateClientConVar("_zs_autoredeem", 1, true, false)
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




