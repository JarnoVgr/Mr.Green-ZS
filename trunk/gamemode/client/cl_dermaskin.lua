-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local SKIN = {}

SKIN.bg_color 					= Color( 0,0,0,250 )

SKIN.control_color 				= Color( 90, 90, 90, 255 )
SKIN.control_color_highlight	= Color( 150, 150, 150, 255 )
SKIN.control_color_active 		= Color( 110, 150, 250, 255 )
SKIN.control_color_bright 		= Color( 225, 150, 80, 255 )
SKIN.control_color_dark 		= Color( 80, 80, 80, 255 )

SKIN.colButtonBorder			= Color( 20, 20, 20, 255 )
SKIN.colButtonBorderHighlight	= Color( 255, 255, 255, 50 )
SKIN.colButtonBorderShadow		= Color( 0, 0, 0, 100 )

SKIN.fontButton					= "Default"
SKIN.colButtonText				= Color( 255, 255, 255, 255 )
SKIN.colButtonTextDisabled		= Color( 255, 255, 255, 55 )

SKIN.tooltip					= Color(40,40,40,140)

local Gradient = surface.GetTextureID( "gui/center_gradient" )

function SKIN:PaintFrame(panel)
		
	 self:DrawGenericBackground( 0, 0, panel:GetWide(), panel:GetTall(), Color(40,40,40,140) ) 
	 	 
	 surface.SetDrawColor( 30, 30, 30, 255 ) 
	 surface.DrawRect( 1, 21, panel:GetWide()-2, 1 ) 
end

function SKIN:DrawGenericBackground( x, y, w, h, color ) 
	--[=[
	surface.DrawRect(x,y,w,h)
	draw.RoundedBox( 4, x, y, w, h, color ) 
	draw.RoundedBox( 4, x, y, w, h, color ) 
]=]
		surface.SetDrawColor( Color( 0, 0, 0, 240 ) )
		surface.DrawRect( x, y, w, h )
		
		local Quad = {} 
		Quad.texture 	= Gradient
		Quad.color		= color
 
		Quad.x = x
		Quad.y = y
		Quad.w = w
		Quad.h = h
		draw.TexturedQuad( Quad )
		
		surface.SetDrawColor( 30, 30, 30, 200 )
		surface.DrawOutlinedRect( x, y, w, h )
		surface.SetDrawColor( 30, 30, 30, 255 )
		surface.DrawOutlinedRect( x+1, y+1, w-2, h-2 )
end
 
function SKIN:PaintTextEntry( panel ) 

	if ( panel.m_bBackground ) then 

		surface.SetDrawColor( 60, 60, 60, 240 ) 
		surface.DrawRect( 0, 0, panel:GetWide(), panel:GetTall() ) 

	end 

	panel:DrawTextEntryText( panel.m_colText, panel.m_colHighlight, panel.m_colCursor ) 

	if ( panel.m_bBorder ) then 

		surface.SetDrawColor( 50, 50, 50, 255 ) 
		surface.DrawOutlinedRect( 0, 0, panel:GetWide(), panel:GetTall() ) 
		
		surface.SetDrawColor( 10, 10, 10, 200 ) 
		surface.DrawOutlinedRect( 1, 1, panel:GetWide()-2, panel:GetTall()-2 ) 
	end 


end 
 
function SKIN:SchemeTextEntry( panel ) 

	panel:SetTextColor( Color( 200, 200, 200, 255 ) ) 
	panel:SetHighlightColor( Color( 20, 200, 250, 255 ) ) 
	panel:SetCursorColor( Color( 0, 0, 100, 255 ) ) 

end

--[==[---------------------------------------------------------
   DrawButtonBorder
---------------------------------------------------------]==]
function SKIN:DrawButtonBorder( x, y, w, h, depressed )

	if ( not depressed ) then
	
		surface.SetDrawColor( 1,1,1,180 )
		surface.DrawRect( x, y, w, h )
		
		surface.SetDrawColor(Color(0,0,0,255) )
		surface.DrawOutlinedRect( x, y, w, h )
		
	else
		surface.SetDrawColor( 1,1,1,180 )
		surface.DrawRect( x, y, w, h )
		
		surface.SetDrawColor(Color(200,200,200,255) )
		surface.DrawOutlinedRect( x, y, w, h )
		
	end	



end

--[==[---------------------------------------------------------
	Button
---------------------------------------------------------]==]
function SKIN:PaintButton( panel )

	local w, h = panel:GetSize()

	if ( panel.m_bBackground ) then
	
		local col = Color(1,1,1,180)
		local col2 = Color(30, 30, 30, 200)
		
		if ( panel:GetDisabled() ) then
			col = Color(1,1,1,220)
			col2 = Color(30, 30, 30, 200)
		elseif ( panel.Depressed or panel:GetToggle() ) then
			col = Color(1,1,1,180)
			col2 = Color(30, 30, 30, 200)
		elseif ( panel.Hovered ) then
			col = Color(1,1,1,180)
			col2 = Color(200,200,200,255)
		end
		
		surface.SetDrawColor(col )
		surface.DrawRect( 0, 0, w, h )
		
		local Quad = {} 
		Quad.texture 	= Gradient
		Quad.color		= Color(40,40,40,140)
 
		Quad.x = 0
		Quad.y = 0
		Quad.w = w
		Quad.h = h
		draw.TexturedQuad( Quad )
		
		surface.SetDrawColor(col2 )
		surface.DrawOutlinedRect( 0, 0, w, h )
		surface.SetDrawColor( col2 )
		surface.DrawOutlinedRect( 0+1, 0+1, w-2, h-2 )
	
	end

end

function SKIN:PaintTooltip( panel )

	local w, h = panel:GetSize()
	
	DisableClipping( true )
	
	--  This isn't great, but it's not like we're drawing 1000's of tooltips all the time
	for i=1, 4 do
	
		local BorderSize = i*2
		local BGColor = Color( 0, 0, 0, (255 / i) * 0.3 )
		
		self:DrawGenericBackground( BorderSize, BorderSize, w, h, BGColor )
		panel:DrawArrow( BorderSize, BorderSize )
		self:DrawGenericBackground( -BorderSize, BorderSize, w, h, BGColor )
		panel:DrawArrow( -BorderSize, BorderSize )
		self:DrawGenericBackground( BorderSize, -BorderSize, w, h, BGColor )
		panel:DrawArrow( BorderSize, -BorderSize )
		self:DrawGenericBackground( -BorderSize, -BorderSize, w, h, BGColor )
		panel:DrawArrow( -BorderSize, -BorderSize )
		
	end


	self:DrawGenericBackground( 0, 0, w, h, Color(40,40,40,140) )
	panel:DrawArrow( 0, 0 )

	DisableClipping( false )
end

function SKIN:SchemeButton( panel )

	panel:SetFont( self.fontButton )
	
	if ( panel:GetDisabled() ) then
		panel:SetTextColor( self.colButtonTextDisabled )
	else
		panel:SetTextColor( self.colButtonText )
	end
	
	DLabel.ApplySchemeSettings( panel )

end

--[==[---------------------------------------------------------
	PropertySheet
---------------------------------------------------------]==]
function SKIN:PaintPropertySheet( panel )

	local ActiveTab = panel:GetActiveTab()
	local Offset = 0
	if ( ActiveTab ) then Offset = ActiveTab:GetTall() end
	
	--  This adds a little shadow to the right which helps define the tab shape..
	-- draw.RoundedBox( 0, 0, Offset, panel:GetWide(), panel:GetTall()-Offset, Color(60, 60, 60, 240) )
	
	surface.SetDrawColor( 30, 30, 30, 200 )
	surface.DrawOutlinedRect( 0, Offset, panel:GetWide(), panel:GetTall()-Offset ) 
		
	surface.SetDrawColor( 30, 30, 30, 255 )
	surface.DrawOutlinedRect( 1, Offset+1, panel:GetWide()-2, panel:GetTall()-Offset-2 ) 
	
end

--[==[---------------------------------------------------------
	CategoryHeader
---------------------------------------------------------]==]
function SKIN:PaintCollapsibleCategory( panel )
	
	if ( panel:GetExpanded() ) then
	
		surface.SetDrawColor( 205, 205, 205, 200 )
		surface.DrawOutlinedRect( 0, 0, panel:GetWide(), panel:GetTall()) 
				
		surface.SetDrawColor( 205, 205, 205, 255 )
		surface.DrawOutlinedRect( 1, 1, panel:GetWide()-2, panel:GetTall()-2 ) 
	
	else

		surface.SetDrawColor( 30, 30, 30, 200 )
		surface.DrawOutlinedRect( 0, 0, panel:GetWide(), panel:GetTall()) 
				
		surface.SetDrawColor( 30, 30, 30, 255 )
		surface.DrawOutlinedRect( 1, 1, panel:GetWide()-2, panel:GetTall()-2 ) 
	
	end
	
end

--[==[---------------------------------------------------------
	Tab
---------------------------------------------------------]==]
function SKIN:PaintTab( panel )

	if ( panel:GetPropertySheet():GetActiveTab() == panel ) then
	
		surface.SetDrawColor( 255, 255, 255, 200 )
		surface.DrawOutlinedRect( 0, 0, panel:GetWide(), panel:GetTall() + 8 ) 
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawOutlinedRect( 1, 1, panel:GetWide()-2, panel:GetTall()+6 ) 
	else
		surface.SetDrawColor( 30, 30, 30, 200 )
		surface.DrawOutlinedRect( 0, 0, panel:GetWide(), panel:GetTall() + 8 ) 
		
		surface.SetDrawColor( 30, 30, 30, 255 )
		surface.DrawOutlinedRect( 1, 1, panel:GetWide()-2, panel:GetTall()+6 ) 
	end
	
end

function SKIN:SchemeTab( panel )

	panel:SetFont( self.fontTab )

	local ExtraInset = 10

	if ( panel.Image ) then
		ExtraInset = ExtraInset + panel.Image:GetWide()
	end
	
	panel:SetTextInset( ExtraInset )
	panel:SizeToContents()
	panel:SetSize( panel:GetWide() + 10, panel:GetTall() + 8 )
	
	local Active = panel:GetPropertySheet():GetActiveTab() == panel
	
	if ( Active ) then
		panel:SetTextColor( self.colTabText )
	else
		panel:SetTextColor( Color( 120, 120, 120, 255 ) )
	end
	
	panel.BaseClass.ApplySchemeSettings( panel )
		
end
	
derma.DefineSkin("ZSMG", "Derma skin for Mr. Green Zombie Survival", SKIN, "Default")

RunConsoleCommand("derma_skin", "ZSMG")
