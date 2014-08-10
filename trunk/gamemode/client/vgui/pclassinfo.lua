-- Nothing to see here yet!

local ZInfoTable = {}
ZInfoTable[1] = {Desc1 = "Attack with claws", Desc2 = "Moan", Seq1 = "Idle01", Seq2 = "FireWalk", AnimSpeed1 = 1, AnimSpeed2 = 0.5, Cam = Vector( 58, 68, 40 ), Ang = Vector( 0, 0, 40 ) }
ZInfoTable[2] = {Desc1 = "Attack with claws", Desc2 = "Leap/Climb the walls", Seq1 = "Melee", Seq2 = "LeapStrike", AnimSpeed1 = 0.5, AnimSpeed2 = 0.5, Cam = Vector( 58, 68, 40 ), Ang = Vector( 0, 0, 40 ) }
ZInfoTable[3] = {Desc1 = "Attack with claws", Desc2 = "Moan", Seq1 = "Idle01", Seq2 = "FireWalk", AnimSpeed1 = 1, AnimSpeed2 = 0.5, Cam = Vector( 58, 68, 40 ), Ang = Vector( 0, 0, 40 ) }
ZInfoTable[4] = {Desc1 = "Attack with claws", Desc2 = "Invisibility", Seq1 = "idle2", Seq2 = "walk", AnimSpeed1 = 1, AnimSpeed2 = 0, Cam = Vector( 58, 68, 40 ), Ang = Vector( 0, 0, 40 ) }
ZInfoTable[5] = {Desc1 = "Pull objects/players with scream", Desc2 = "Push objects/players with scream", Seq1 = "FireIdle", Seq2 = "FireIdle", AnimSpeed1 = 1, AnimSpeed2 = 1, Cam = Vector( 58, 68, 40 ), Ang = Vector( 0, 0, 40 ) }
ZInfoTable[6] = {Desc1 = "Attack", Desc2 = "Emit a lovely sound", Seq1 = "Run1", Seq2 = "Idle01", AnimSpeed1 = 1, AnimSpeed2 = 1, Cam = Vector( 45, 45, 35 ), Ang = Vector( 0, 0, 0 )}
ZInfoTable[7] = {Desc1 = "Spit a green poison ball", Desc2 = "Spit a red poison ball", Seq1 = "IdleSniff", Seq2 = "IdleSumo", AnimSpeed1 = 1, AnimSpeed2 = 1, Cam = Vector( 45, 45, 35 ), Ang = Vector( 0, 0, 0 ) }
ZInfoTable[8] = {Desc1 = "Attack with claws", Desc2 = "Pull out grenade ", Seq1 = "Walk_All", Seq2 = "Run_All_grenade", AnimSpeed1 = 0.8, AnimSpeed2 = 0.8, Cam = Vector( 58, 68, 40 ), Ang = Vector( 0, 0, 40 ) }
ZInfoTable[20] = {Desc1 = "Attack with claws", Desc2 = "Very fast!", Seq1 = "Walk_All", Seq2 = "Run_All_grenade", AnimSpeed1 = 0.8, AnimSpeed2 = 0.8, Cam = Vector( 58, 68, 40 ), Ang = Vector( 0, 0, 40 ) }

local function SetSeqModel( self, strModelName, seq )

	if ( IsValid( self.Entity ) ) then
			self.Entity:Remove()
			self.Entity = nil              
	end
 
	if ( not ClientsideModel ) then return end
 
	self.Entity = ClientsideModel( strModelName, RENDER_GROUP_OPAQUE_ENTITY )
	if ( not IsValid(self.Entity) ) then return end
 
	self.Entity:SetNoDraw( true )
	
	self.Entity:SetBodygroup( 1, 1 )
 
	local iSeq = 0
	if seq then
		iSeq = self.Entity:LookupSequence( seq )
	end
	if (iSeq <= 0) then iSeq = self.Entity:LookupSequence( seq ) end
	--if (iSeq <= 0) then iSeq = self.Entity:LookupSequence( "WalkUnarmed_all" ) end
	--if (iSeq <= 0) then iSeq = self.Entity:LookupSequence( "walk_all_moderate" ) end
 
	if (iSeq > 0) then self.Entity:ResetSequence( iSeq ) end
	end

function MakeZClassInfo()
	if not MySelf then return end
	if pInfo then
		pInfo:Remove()
		pInfo = nil
	end

	local Window = vgui.Create("DFrame")
	local wide = h * 0.75
	local tall = h * 0.5
	Window:SetSize(wide, tall)
	local wide1 = (w - wide) * 0.5
	local tall1 = (h - tall) * 0.5
	Window:SetPos(wide1, tall1)
	Window:SetTitle(" ")
	Window:SetSkin("ZSMG")
	Window:SetVisible(true)
	Window:SetDraggable(false)
	Window:SetBackgroundBlur( true )
	Window:MakePopup()
	--Window:SetDeleteOnClose(false)
	--Window:SetCursor("pointer")
	--Window.Paint = function()
	--	surface.SetDrawColor( 0, 0, 0, 255 )
	--	surface.DrawOutlinedRect( 0, 0, Window:GetWide(), Window:GetTall())
	--	draw.RoundedBox( 0, 0, 0, Window:GetWide(), Window:GetTall() , Color (1,1,1,200) )
	--end
	pInfo = Window
	
	local iClass = MySelf:GetZombieClass() or 1
	
		
	local InfoNamePanel = vgui.Create("DLabel", pInfo)
	InfoNamePanel:SetFont("ArialBoldTwelve")
	InfoNamePanel:SetText(""..ZombieClasses[iClass].Name.."")
	surface.SetFont("ArialBoldTwelve")
	local texw, texh = surface.GetTextSize(""..ZombieClasses[iClass].Name.."")
	InfoNamePanel:SetSize(texw, texh)
	InfoNamePanel:SetPos(wide/2-texw/2, 23)
	
	local InfoLeftPanel = vgui.Create("DLabel")
	InfoLeftPanel:SetSize(wide/2.5,tall/1.5)
	InfoLeftPanel:SetPos(wide/2-(wide/2.2),tall*0.15)
	InfoLeftPanel:SetText("")
	InfoLeftPanel:SetParent(pInfo)
	InfoLeftPanel.Paint = function()
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawOutlinedRect( 0, 0, InfoLeftPanel:GetWide(), InfoLeftPanel:GetTall())
		draw.RoundedBox( 0, 0, 0, InfoLeftPanel:GetWide(), InfoLeftPanel:GetTall() , Color (1,1,1,200) )
	end
	
	local InfoRightPanel = vgui.Create("DLabel")
	InfoRightPanel:SetSize(wide/2.5,tall/1.5)
	InfoRightPanel:SetPos(wide/1.8,tall*0.15)
	InfoRightPanel:SetText("")
	InfoRightPanel:SetParent(pInfo)
	InfoRightPanel.Paint = function()
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawOutlinedRect( 0, 0, InfoRightPanel:GetWide(), InfoRightPanel:GetTall())
		draw.RoundedBox( 0, 0, 0, InfoRightPanel:GetWide(), InfoRightPanel:GetTall() , Color (1,1,1,200) )
	end
	
	local LeftModel = vgui.Create( "DModelPanel", pInfo )
	-- Do I really need to overrisde this function twice?
	LeftModel.SetModel = SetSeqModel

	function LeftModel:LayoutEntity(Entity)
		self:RunAnimation()
		Entity:SetAngles( Angle( 0, 35, 0) )
	end

	LeftModel:SetModel( LocalPlayer():GetModel(), ZInfoTable[iClass].Seq1 )	
	LeftModel:SetAnimSpeed(ZInfoTable[iClass].AnimSpeed1)
	LeftModel:SetSize( InfoLeftPanel:GetTall(), InfoLeftPanel:GetTall())
	LeftModel:SetPos( wide/2-(wide/2.2)-8,tall*0.15)
	LeftModel:SetCamPos( ZInfoTable[iClass].Cam )
	LeftModel:SetLookAt( ZInfoTable[iClass].Ang )
	LeftModel:SetFOV(64)
	
	local RightModel = vgui.Create( "DModelPanel", pInfo )
	RightModel.SetModel = SetSeqModel
	
	function RightModel:LayoutEntity(Entity)
		self:RunAnimation()
		Entity:SetAngles( Angle( 0, 35, 0) )
	end
	RightModel:SetModel( LocalPlayer():GetModel(), ZInfoTable[iClass].Seq2 )	
	RightModel:SetAnimSpeed(ZInfoTable[iClass].AnimSpeed2)
	RightModel:SetSize( InfoRightPanel:GetTall(), InfoRightPanel:GetTall())
	RightModel:SetPos( wide/1.8-8,tall*0.15)
	RightModel:SetCamPos( ZInfoTable[iClass].Cam )
	RightModel:SetLookAt( ZInfoTable[iClass].Ang )
	RightModel:SetFOV(64)
	
	--local LeftText = [[
	--Left mouse button:
	--]]..ZInfoTable[iClass].Desc1..[[
	--]]
	
	local LeftName = vgui.Create("DLabel", pInfo)
	LeftName:SetFont("ArialBoldTen")
	LeftName:SetText("LMB:")
	surface.SetFont("ArialBoldTen")
	local texw1, texh1 = surface.GetTextSize("LBM:")
	LeftName:SetSize(texw1, texh1)
	LeftName:SetPos(wide/2-(wide/2.2)-4, tall*0.15+InfoLeftPanel:GetTall() + 4)
	
	local LeftText = ZInfoTable[iClass].Desc1
	
	local LeftNamePanel = vgui.Create("DLabel", pInfo)
	LeftNamePanel:SetFont("ArialBoldFive")
	LeftNamePanel:SetText(""..LeftText.."")
	surface.SetFont("ArialBoldFive")
	local texw, texh = surface.GetTextSize(""..LeftText.."")
	LeftNamePanel:SetSize(texw, texh)
	LeftNamePanel:SetPos(wide/2-(wide/2.2)-4, tall*0.15+InfoLeftPanel:GetTall() + texh1 + 8)
	
	--local RightText = [[
	--Left mouse button:
	--]]..ZInfoTable[iClass].Desc2..[[
	--]]

	local RightText = ZInfoTable[iClass].Desc2
	
	local RightName = vgui.Create("DLabel", pInfo)
	RightName:SetFont("ArialBoldTen")
	RightName:SetText("RMB:")
	surface.SetFont("ArialBoldTen")
	local texw2, texh2 = surface.GetTextSize("RMB:")
	RightName:SetSize(texw2, texh2)
	RightName:SetPos(wide/1.8-4, tall*0.15+InfoRightPanel:GetTall() + 4)
	
	local RightNamePanel = vgui.Create("DLabel", pInfo)
	RightNamePanel:SetFont("ArialBoldFive")
	RightNamePanel:SetText(""..RightText.."")
	surface.SetFont("ArialBoldFive")
	local texw, texh = surface.GetTextSize(""..RightText.."")
	RightNamePanel:SetSize(texw, texh)
	RightNamePanel:SetPos(wide/1.8-4,tall*0.15+InfoLeftPanel:GetTall() + texh2 + 8)

	
end