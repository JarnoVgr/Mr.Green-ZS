--[==[local PANEL = {}

Derma_Hook( PANEL, 	"Paint", 				"Paint", 	"VoiceNotify" )
Derma_Hook( PANEL, 	"ApplySchemeSettings", 	"Scheme", 	"VoiceNotify" )
Derma_Hook( PANEL, 	"PerformLayout", 		"Layout", 	"VoiceNotify" )
	
function PANEL:Init()

	self.LabelName = vgui.Create( "DLabel", self )
	self.Avatar = vgui.Create( "AvatarImage", self )
	self.Color = color_transparent

end

function PANEL:Setup( ply )

	self.LabelName:SetText( ply:Nick() )
	self.Avatar:SetPlayer( ply )
	
	self.Color = team.GetColor( ply:Team() )
	
	self:InvalidateLayout()

end

derma.DefineControl( "VoiceNotify", "", PANEL, "DPanel" )

local PlayerVoicePanels = {}

function GM:PlayerStartVoice( ply )

	if (not IsValid( g_VoicePanelList ) ) then return end
	
	--  There'd be an exta one if voice_loopback is on, so remove it.
	GAMEMODE:PlayerEndVoice( ply )

	if ( not IsValid( ply ) ) then return end

	local pnl = vgui.Create( "VoiceNotify" )
	pnl:Setup( ply )
	
	g_VoicePanelList:AddItem( pnl )
	
	PlayerVoicePanels[ ply ] = pnl
	
end


local function VoiceClean()

	for k, v in pairs( PlayerVoicePanels ) do
	
		if ( not IsValid( k ) ) then
			GAMEMODE:PlayerEndVoice( k )
		end
	
	end

end

timer.Create( "VoiceClean", 10, 0, VoiceClean )


function GM:PlayerEndVoice( ply )
	
	if ( IsValid( PlayerVoicePanels[ ply ] ) ) then
		g_VoicePanelList:RemoveItem( PlayerVoicePanels[ ply ] )
		PlayerVoicePanels[ ply ]:Remove()
		PlayerVoicePanels[ ply ] = nil
	end
	
end


local function CreateVoiceVGUI()

	g_VoicePanelList = vgui.Create( "DPanelList" )

	g_VoicePanelList:ParentToHUD()
	
	g_VoicePanelList:SetPos( 10, 150 )
	g_VoicePanelList:SetSize( 200, ScrH() - 200 )
	
	g_VoicePanelList:SetDrawBackground( false )
	g_VoicePanelList:SetSpacing( 8 )
	g_VoicePanelList:SetBottomUp( false )


end

hook.Add( "InitPostEntity", "CreateVoiceVGUI", CreateVoiceVGUI )]==]
local PANEL = {}
local PlayerVoicePanels = {}

function PANEL:Init()

	self.LabelName = vgui.Create( "DLabel", self )
	self.LabelName:SetFont( "GModNotify" )
	self.LabelName:Dock( FILL )
	self.LabelName:DockMargin( 8, 0, 0, 0 )
	self.LabelName:SetTextColor( Color( 255, 255, 255, 255 ) )

	self.Avatar = vgui.Create( "AvatarImage", self )
	self.Avatar:Dock( LEFT );
	self.Avatar:SetSize( 32, 32 )

	self.Color = color_transparent

	self:SetSize( 250, 32 + 8 )
	self:DockPadding( 4, 4, 4, 4 )
	self:DockMargin( 2, 2, 2, 2 )
	self:Dock( TOP )

end

function PANEL:Setup( ply )

	self.ply = ply
	self.LabelName:SetText( ply:Nick() )
	self.Avatar:SetPlayer( ply )
	
	self.Color = team.GetColor( ply:Team() )
	
	self:InvalidateLayout()

end

function PANEL:Paint( w, h )

	if ( not IsValid( self.ply ) ) then return end
	draw.RoundedBox( 4, 0, 0, w, h, Color( 0, self.ply:VoiceVolume() * 255, 0, 240 ) )

end

function PANEL:Think( )

	if ( self.fadeAnim ) then
		self.fadeAnim:Run()
	end

end

function PANEL:FadeOut( anim, delta, data )
	
	if ( anim.Finished ) then
	
		if ( IsValid( PlayerVoicePanels[ self.ply ] ) ) then
			PlayerVoicePanels[ self.ply ]:Remove()
			PlayerVoicePanels[ self.ply ] = nil
			return
		end
		
	return end
			
	self:SetAlpha( 255 - (255 * delta) )

end

derma.DefineControl( "VoiceNotify", "", PANEL, "DPanel" )



function GM:PlayerStartVoice( ply )

	if ( not IsValid( g_VoicePanelList ) ) then return end
	
	-- There'd be an exta one if voice_loopback is on, so remove it.
	GAMEMODE:PlayerEndVoice( ply )


	if ( IsValid( PlayerVoicePanels[ ply ] ) ) then

		if ( PlayerVoicePanels[ ply ].fadeAnim ) then
			PlayerVoicePanels[ ply ].fadeAnim:Stop()
			PlayerVoicePanels[ ply ].fadeAnim = nil
		end

		PlayerVoicePanels[ ply ]:SetAlpha( 255 )

		return;

	end

	if ( not IsValid( ply ) ) then return end

	local pnl = g_VoicePanelList:Add( "VoiceNotify" )
	pnl:Setup( ply )
	
	PlayerVoicePanels[ ply ] = pnl
	
end


local function VoiceClean()

	for k, v in pairs( PlayerVoicePanels ) do
	
		if ( not IsValid( k ) ) then
			GAMEMODE:PlayerEndVoice( k )
		end
	
	end

end

timer.Create( "VoiceClean", 10, 0, VoiceClean )


function GM:PlayerEndVoice( ply )
	
	if ( IsValid( PlayerVoicePanels[ ply ] ) ) then

		if ( PlayerVoicePanels[ ply ].fadeAnim ) then return end

		PlayerVoicePanels[ ply ].fadeAnim = Derma_Anim( "FadeOut", PlayerVoicePanels[ ply ], PlayerVoicePanels[ ply ].FadeOut )
		PlayerVoicePanels[ ply ].fadeAnim:Start( 2 )

	end
	
end


local function CreateVoiceVGUI()

	g_VoicePanelList = vgui.Create( "DPanel" )

	g_VoicePanelList:ParentToHUD()
	g_VoicePanelList:SetPos( 15, 180 )
	g_VoicePanelList:SetSize( 250, ScrH() - 200 )
	g_VoicePanelList:SetDrawBackground( false )

end

hook.Add( "InitPostEntity", "CreateVoiceVGUI", CreateVoiceVGUI )