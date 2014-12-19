-- Piece of art

--include("sh_skillpoints.lua")

include ( "sh_skillpoints.lua" )


SKILLPOINTS = true
if not SKILLPOINTS then return end

local skillshot_fadeout_time = CreateConVar("_skillshot_fadeout_time", "3", FCVAR_REPLICATED)

skillpoints = {}

skillpoints.Victims = {} -- I need this table to apply bunch of messages to each victim instead of drawing shitload of messages at same place
skillpoints.CachedVictims = {}

skillpoints.Colors = {}
skillpoints.Colors["DarkRed"] = Color(176,0,0,255)
skillpoints.Colors["Red"] = Color(255,0,0,255)
skillpoints.Colors["DarkGreen"] = Color(43,152,0,255)
skillpoints.Colors["LightGrey"] = Color(206,206,206,255)
skillpoints.Colors["Orange"] = Color(216,81,0,255)
skillpoints.Colors["DarkBlue"] = Color(0,102,255,255)
skillpoints.Colors["Yellow"] = Color(162,186,0,255)
skillpoints.Colors["Purple"] = Color(108,0,255,255)
skillpoints.Colors["White"] = Color(255,255,255,255)

-- Get skillshot info from server
function skillpoints.ReceiveSkillShot(um)

	if not IsValid(MySelf) then return end

	local SkillShotName = um:ReadString()
	local SkillShotCol = um:ReadString()
	local SkillShotPoints = um:ReadShort()
	local SkillShotVictim = um:ReadEntity()
	local SkillShotVictimPos = um:ReadVector()

	skillpoints.AddMessage(SkillShotName,SkillShotCol,SkillShotPoints,SkillShotVictim,SkillShotVictimPos)
	
end
usermessage.Hook("skillpoints.ReceiveSkillShot",skillpoints.ReceiveSkillShot)

-- Get amount of skillpoints from server
function skillpoints.UpdateSkillPoints(um)

	if not IsValid(MySelf) then return end

	MySelf.SkillPoints = MySelf.SkillPoints or 40

	local SkillShotPoints = um:ReadShort()

	MySelf.SkillPoints = SkillShotPoints
	
end
usermessage.Hook("skillpoints.UpdateSkillPoints",skillpoints.UpdateSkillPoints)

-- Insert a message into quene
function skillpoints.AddMessage(name,col,amount,victim,pos)

  if not IsValid(victim) then return end
  
  Victim = {}
  
  Victim.Player = victim
  Victim.Pos = pos
  Victim.Message = {}
  
  Message = {}
  Message.Name = name
  Message.Amount = amount
  Message.Time = CurTime()
  Message.Color = col
  
  -- Check if victim is already in the table - add another message
	if table.HasValue(skillpoints.CachedVictims, victim) then
		for k,v in pairs(skillpoints.Victims) do 
			if v.Player == victim then
				Message.Time = CurTime()+0.5 * #v.Message --  force small delay
				table.insert(v.Message, Message) -- Find the nessesary table entry and insert a message inside
				break
			end
		end
	else
		table.insert(Victim.Message, Message)
		table.insert(skillpoints.Victims, Victim)
		table.insert(skillpoints.CachedVictims, victim)
	end  
end

function markup.DoColorText ( sText, Color )
	return "<color="..Color.r..","..Color.g..","..Color.b..","..Color.a..">"..( sText or "" ).."</color>"
end

-- Draw a single message
local function skillpointsDraw(x,y,message,skillshot_fadeout_time)

	local fadeout = ( message.Time + skillshot_fadeout_time ) - CurTime()

	--message.Color.a = math.Round ( math.Clamp( fadeout * 255, 0, 255 ) )

	local ToDraw
	local ColorToDraw = skillpoints.Colors["LightGrey"]

	local NameToDraw = message.Name
	local AmountToDraw = message.Amount

	ToDraw = NameToDraw.." "..AmountToDraw.."+"
	ToDraw = markup.DoColorText(ToDraw,ColorToDraw)

	local mMarkMessage = markup.Parse( "<font=NewZombieFont17>"..ToDraw.."</font>" )

	mMarkMessage:Draw( x - (mMarkMessage:GetWidth())/2 + math.Rand(-1,1), y+math.Rand(-1,1) ) --w * 0.7 - mMarkMessage:GetWidth()

	return y + ScaleH(math.Rand(31,35))

end

-- Draw all cached messages
function skillpoints.DrawMessage()

	if not IsEntityValid ( MySelf ) then return end

	if ENDROUND then return end

	local skillshot_fadeout_time = skillshot_fadeout_time:GetFloat()

	for _, Victim in pairs( skillpoints.Victims ) do 
		if not Victim.Pos then return end

		Victim.x = Victim.Pos:ToScreen().x
		Victim.y = Victim.Pos:ToScreen().y
	
		for k, Message in pairs( Victim.Message ) do
			if Message.Time + skillshot_fadeout_time > CurTime() then
				if Message.lerp then
					Victim.x = Victim.x * 0.3 + Message.lerp.x * 0.7
					Victim.y = Victim.y * 0.3 + Message.lerp.y * 0.7
				end

				Message.lerp = Message.lerp or {}
				Message.lerp.x = Victim.x
				Message.lerp.y = Victim.y
				
				Victim.y = skillpointsDraw( Victim.x, Victim.y, Message, skillshot_fadeout_time )
			end
		end
	end

	for _, Victim in pairs( skillpoints.Victims ) do
		for k, Message in pairs(Victim.Message) do
				if Message.Time + skillshot_fadeout_time > CurTime() then
					return
				end
		end
	end
	

	skillpoints.Victims = {}
	skillpoints.CachedVictims = {}
	
end
hook.Add( "HUDPaint", "skillpoints.DrawMessage", skillpoints.DrawMessage )

-- Draw amount of skillpoints on HUD
function skillpoints.DrawSkillPoints()
-- TODO: Maybe make a better version
	if not IsEntityValid ( MySelf ) then return end
	if not MySelf:Alive() then return end
	if not MySelf.ReadySQL then return end
	if IsClassesMenuOpen() then return end
	if IsSkillShopOpen() then return end
	if ENDROUND then return end

	local xshake,yshake = 0,0

	MySelf.SkillPoints = MySelf.SkillPoints or 40
	MySelf.OldSkillPoints = MySelf.OldSkillPoints or MySelf.SkillPoints

	MySelf.CheckTimer = MySelf.CheckTimer or CurTime()
	
	if MySelf.CheckTimer < CurTime() then
		MySelf.OldSkillPoints = MySelf.SkillPoints
		MySelf.CheckTimer = CurTime() + 2
	end
	
	if MySelf.OldSkillPoints ~= MySelf.SkillPoints then
		xshake,yshake = math.Rand(-1,1),math.Rand(-1,1)
		MySelf.OldSkillPoints = math.Approach(MySelf.OldSkillPoints,MySelf.SkillPoints,1)
	end

	local mSPLeft = markup.Parse( "<font=CorpusCareSeven>"..markup.DoColorText("sp",Color(255,255,255,255)).."</font>" )
	local mSPRight = markup.Parse( "<font=CorpusCareFifteen>"..markup.DoColorText(MySelf.OldSkillPoints,Color(255,255,255,255)).."</font>" )

	mSPLeft:Draw(ScaleW(172),ScaleH(826)) 
	mSPRight:Draw(ScaleW(172) + mSPLeft:GetWidth() + 9 + xshake,ScaleH(809)+yshake) 
	if MySelf:IsHuman() then
	-- local infow,infoh = ScaleW(180), ScaleH(80)
	-- draw.RoundedBoxEx( 8, 0 , ScaleH(10), infow,infoh, Color(1,1,1,230), false, true, false, true )
	if ( (#WeaponsInCart.Weapons <=0 or #WeaponsInCart.Ammo <= 0) or (#WeaponsInCart.Weapons <=0 and #WeaponsInCart.Ammo <= 0) ) then
		draw.RoundedTextBox ( "Press F2 to open a SkillShop", "ArialBoldFive", -1, h * 0.05, 0.45, Color ( 1,1,1,190 ), Color ( 255,255,255,255 ), nil, TEXT_ALIGN_TOP )
	end
	end
	
	-- draw.SimpleText("Fkin speed "..math.Round(MySelf:GetVelocity():Length()), "CorpusCareFifteen", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

end
-- hook.Add( "HUDPaint", "skillpoints.DrawSkillPoints", skillpoints.DrawSkillPoints )


function MakeSkillShotsList()
	if not MySelf then return end
	if pList then
		pList:Remove()
		pList = nil
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
	pList = Window
	
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(COLOR_WHITE)
	label:SetFont("CorpusCareThirteen")
	label:SetText("SkillShots Database")
	label:SetPos(16, 22)
	surface.SetFont("CorpusCareThirteen")
	local texw, texh = surface.GetTextSize("SkillShots Database")
	label:SetSize(texw, texh)
	
	local xpos = (pList:GetWide()*0.05)/3
	local ypos = 70

	local label1 = vgui.Create("DLabel", Window)
	label1:SetTextColor(Color(0, 160, 255))
	label1:SetFont("CorpusCareTen")
	label1:SetText("Human's SkillShots")
	surface.SetFont("CorpusCareTen")
	local texw, texh = surface.GetTextSize("Human's SkillShots:")
	label1:SetSize(texw, texh)
	label1:SetPos( xpos,ypos )
	
	ypos = ypos + 40
	
	local tblSkillShots1 = SkillPointsTable["Humans"]

	
	DermaList = vgui.Create( "DPanelList", pList )
	DermaList:SetPos( xpos,ypos )
	DermaList:SetSize( pList:GetWide()*0.95, pList:GetTall()/2 *0.7 )
	DermaList:SetSpacing( 1 )
	DermaList:EnableHorizontal( false )
	DermaList:EnableVerticalScrollbar( true )

	
	for k,v in pairs(tblSkillShots1) do
	local desc
		if v.Name ~= "" then
		if v.Hidden and v.Hidden == true then
			desc = "&^%$SECRET(*#&%#ONE11!!*@&#^"
		else
			desc = v.Description
		end
	
			surface.SetFont("CorpusCareSeven")
			local tw, th = surface.GetTextSize("  "..v.Name.." ("..v.Points.."+) - "..desc)
			local skills = vgui.Create("DLabel", Window)
			skills:SetFont("CorpusCareSeven")
			skills:SetText("  "..v.Name.." ("..v.Points.."+) - "..desc)
			skills:SizeToContents()
			DermaList:AddItem( skills )
		end
		
	end
	ypos = ypos + DermaList:GetTall() + 30
	
	local label2 = vgui.Create("DLabel", Window)
	label2:SetTextColor(Color(0, 255, 0))
	label2:SetFont("CorpusCareTen")
	label2:SetText("Zombie's SkillShots")
	surface.SetFont("CorpusCareTen")
	local texw, texh = surface.GetTextSize("Zombie's SkillShots:")
	label2:SetSize(texw, texh)
	label2:SetPos( xpos,ypos )
	
	ypos = ypos + 40
	
	local tblSkillShots2 = SkillPointsTable["Zombies"]

	
	DermaList2 = vgui.Create( "DPanelList", pList )
	DermaList2:SetPos( xpos,ypos )
	DermaList2:SetSize( pList:GetWide()*0.95, pList:GetTall()/2 *0.7 )
	DermaList2:SetSpacing( 1 )
	DermaList2:EnableHorizontal( false )
	DermaList2:EnableVerticalScrollbar( true )

	
	for k,v in pairs(tblSkillShots2) do
	local desc
		if v.Name ~= "" then
		if v.Hidden and v.Hidden == true then
			desc = "&^%$SECRET(*#&%#ONE11!!*@&#^"
		else
			desc = v.Description
		end
	
			surface.SetFont("CorpusCareSeven")
			local tw, th = surface.GetTextSize("  "..v.Name.." ("..v.Points.."+) - "..desc)
			local skills = vgui.Create("DLabel", Window)
			skills:SetFont("CorpusCareSeven")
			skills:SetText("  "..v.Name.." ("..v.Points.."+) - "..desc)
			skills:SizeToContents()
			DermaList2:AddItem( skills )
		end
		
	end
	
	ypos = ypos + DermaList2:GetTall() + 25
	
	local label3 = vgui.Create("DLabel", Window)
	label3:SetTextColor(Color(255, 0, 0))
	label3:SetFont("HUDFontSmallAA")
	label3:SetText("Note: More SkillShots will be avalaible later")
	surface.SetFont("HUDFontSmallAA")
	local texw, texh = surface.GetTextSize("Note: More SkillShots will be available later")
	label3:SetSize(texw, texh)
	label3:SetPos( xpos,ypos )
	
	
	
end