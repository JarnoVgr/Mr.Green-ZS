/*-------------------------------
Green-Coins system
cl_greencoins.lua
Client
--------------------------------*/

include( 'sh_greencoins.lua' )

function ReceiveGC( um )
	local tab = {}
	tab["amount_current"] = um:ReadLong()

	LocalPlayer().GCData = tab
end
usermessage.Hook("SendGC",ReceiveGC)

function ConnectionRQ( um )
	forum_id = um:ReadLong()
	forum_name = um:ReadString()
	CreateRequestPopup(forum_id, forum_name)
end
usermessage.Hook("ConnectionRequest",ConnectionRQ)

function CreateRequestPopup( id, name )
	local frame
	frame = vgui.Create("DFrame")
	frame:SetPos(w/2-150,h/2-50) 
	frame:SetSize(400, 100) 
    frame:SetTitle( "Green-Coins account connection request" ) 
    frame:SetVisible( true )
	frame:SetSizable(false)
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
    frame:MakePopup() 
	
	local buttonCon = vgui.Create("DButton",frame)
	buttonCon:SetText( "Confirm")
	buttonCon:SetPos(10,70)
	buttonCon:SetSize(100,20)
	buttonCon.DoClick = function( btn) 
		RunConsoleCommand("game_conn_answer","yes") 
		frame:Close()
	end
	
	-- Create class button
	local buttonRej = vgui.Create("DButton",frame)
	buttonRej:SetText( "Reject")
	buttonRej:SetPos(290,70)
	buttonRej:SetSize(100,20)
	buttonRej.DoClick = function( btn ) 
		RunConsoleCommand("game_conn_answer","no") 
		frame:Close()
	end
	
	local lab = vgui.Create("DLabel",frame)
	lab:SetText( [[
	A connection from your Steam ID to the Left4Green forum account of user 
	]]..name..[[ (id ]]..id..[[) has been requested. Please confirm to connect 
	Green-Coins management to the mentioned account.]] )
	lab:SetPos(10,23)
	lab:SetSize(280,60)
	lab:SizeToContents()
end

// ZS already has its own draw functions
/*function DrawGC()
	local MySelf = LocalPlayer()
	if not (MySelf:IsValid() and MySelf.Class and MySelf.Class ~= 0) then return end
	if ENDROUND then return end
	local coins = MySelf:GreenCoins()
	draw.RoundedBox(5, 3, 120, 200, 24, Color(0, 0, 0, 180))
	local drawcol = Color(115,160,150,185)
	draw.DrawText("Green-Coins: "..coins, "InfoSmall", 10, 124, drawcol, TEXT_ALIGN_LEFT)
	draw.DrawText("Green-Coins: "..coins, "InfoSmall", 10, 124, drawcol, TEXT_ALIGN_LEFT)
end
hook.Add("HUDPaint","DrawGreenCoins",DrawGC)*/