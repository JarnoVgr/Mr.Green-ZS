-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Global table
notice = {}

-- Sounds
notice.Sounds = { Sound ( "hud/notice_soft.wav" ), Sound ( "mrgreen/beep22.wav" ) }

-- Cache table
notice.Cache, notice.Draw = {}, {}

-- Materials
notice.Mats = { surface.GetTextureID( "hud3/hud_warning2" ), surface.GetTextureID( "hud3/hud_warning1" ), surface.GetTextureID( "zombiesurvival/hud/danger_sign" ) }

-- Vars
notice.bAddNext, notice.Size, notice.MaxSize, notice.Alpha, notice.TextPos, notice.ImgPos = false, 58, 67, 0, h * 0.6, h * 0.6

--[==[-----------------------------------------------------------------------------------
	                    Add the message to a table (cache) 
------------------------------------------------------------------------------------]==]
function notice.Message( sText, tbColor, iType, iDuration )
	if not IsValid( MySelf ) then
		return 
	end
	
	if not MySelf.ReadySQL then
		return
	end
	
	if util.tobool(GetConVarNumber("_zs_hidenotify")) then return end

	if not notice.Timer then 
		notice.Timer = 0 
	end	
	
	for k, v in pairs (notice.Cache) do
		if (v.sText == sText) then
			return
		end	
	end

	for k, v in pairs (notice.Draw) do
		if (v.sText == sText) then
			return
		end	
	end
	
	-- Add it to the draw table
	if notice.Timer <= CurTime() then
		if ( #notice.Draw == 0 ) then
			table.insert( notice.Draw, { sText = sText, MessageTime = CurTime(), iType = iType or 1, iDuration = iDuration or 1 } )
			notice.Timer = CurTime() + ( iDuration )
			
			-- Play sound
			if notice.Sounds[iType] then
				surface.PlaySound ( notice.Sounds[iType or 1] )
			end
		end
	else
	
		-- Add it to cache
		table.insert( notice.Cache, { sText = sText, iType = iType or 1, iDuration = iDuration or 4 } )
	end
end

--[==[-------------------------------------------------------
	 Receive draw notice order from server
-------------------------------------------------------]==]

net.Receive("notice.GetNotice", function( len )
	if not IsValid(MySelf) then
		return
	end

	local sText = net.ReadString()
	local iType = net.ReadDouble()
	local sColor = net.ReadString()
	local iDuration = net.ReadDouble()
		
	if iDuration == -1 then
		iDuration = 4
	end
	
	--Add it to list
	notice.Message(sText, Color(255, 255, 255, 255), iType, iDuration)
end)

--[==[--------------------------------------------------
	       Draws the messages
--------------------------------------------------]==]
function notice.DrawMessage()
	if not IsEntityValid ( MySelf ) then return end
	
	-- Not on endround
	if ENDROUND then return end
	
	-- No mesage while dead
	if not MySelf:Alive() then return end
	
	-- Clear the already used messages
	if notice.Timer and notice.Timer <= CurTime() then
		notice.Draw = {}
		
		-- Reset some stats
		notice.Size, notice.Alpha, notice.TextPos, notice.ImgPos = 58, 0, h * 0.6, h * 0.6
		
		-- Get latest entry from cache
		if #notice.Cache > 0 and not notice.bAddNext then
		
			-- So it doesn't loop
			notice.bAddNext = true
			
			-- Delay for next message in cache
			timer.Simple ( 0.5, function()
				if #notice.Cache > 0 then			
					table.insert( notice.Draw, { sText = notice.Cache[1].sText, MessageTime = CurTime(), iType = notice.Cache[1].iType or 1, iDuration = notice.Cache[1].iDuration or 3.5 } )
					
					-- Cooldown
					notice.Timer = CurTime() + (1.5)
					
					-- Play sound
					surface.PlaySound ( notice.Sounds[iType or 1] )
						
					-- Delete cached and resequence
					notice.Cache[1] = nil
					table.Resequence ( notice.Cache )
					
					-- Loop thing
					notice.bAddNext = false
				end
			end )
		end
	end
	
	-- No messages
	if #notice.Draw == 0 then return end
	
	local iType = notice.Draw[1].iType
	
	-- Get text size
	surface.SetFont ( "Trebuchet24" )
	local wText, hText = surface.GetTextSize ( notice.Draw[1].sText )
			
	-- Make it go down the screen
	notice.TextPos = math.Approach( notice.TextPos, ScaleH(732), ( FrameTime() * 150 ) )
	notice.ImgPos = math.Approach( notice.ImgPos, ScaleH(749), ( FrameTime() * 150 ) )
				
	-- Create text module
	notice.HintText = CreateText ( notice.Draw[1].sText, "Trebuchet24", ScaleW(669), notice.TextPos, Color ( 255,255,255, notice.Alpha ), ALIGN_CENTER )
	notice.HintText:Draw()

	-- Get notice texture
	local matNotice, iOffset = notice.Mats[iType], ScaleW(36)
	if iType == 2 then iOffset = ScaleW(23) end
	
	-- Pulsate size
	notice.Size = math.Approach( notice.Size, notice.MaxSize, math.sin ( FrameTime() * 100 ) )
	
	-- Create image module thing
	if iType == 3 then 
		surface.SetDrawColor( Color( 46, 121, 0, notice.Alpha ) )
	else
		surface.SetDrawColor( Color( 255, 255, 255, notice.Alpha ) )
	end
	surface.SetTexture ( matNotice )
	surface.DrawTexturedRectRotated ( ScaleW(669) - ( ( wText / 2 ) + iOffset ), notice.TextPos + math.Round ( hText / 2 ) , notice.Size, notice.Size, 0 )
				
	-- Change the size so it looks like it's pulsating
	if notice.Size >= 67 then notice.MaxSize = 50 elseif notice.Size <= 50 then notice.MaxSize = 67 end
			
	-- Make it fade disappear/appear
	if CurTime() > notice.Timer - 0.2 then
		notice.Alpha = math.Approach( notice.Alpha,0,( FrameTime() * 300 ) )
	else
		notice.Alpha = math.Approach( notice.Alpha,255,( FrameTime() * 120 ) )
	end
end
hook.Add( "HUDPaint", "notice.DrawNotice", notice.DrawMessage )

----------------------------------------------------

local CachedMarkups = {}

for i=2,3 do
	util.PrecacheSound("physics/body/body_medium_break"..i..".wav")
end

local CachedMessages = {}

local ToDraw1 = {}
local DrawTime1 = 0
local DrawY1 = 0
local PlayedSound = false
local t1,t2 = 1,2

local BloodStuff = {}
for i=1,8 do
	BloodStuff[i] = surface.GetTextureID( "Decals/Blood"..i.."" )
end

local function Draw3DMessage()
	if not DrawTime1 then
		return
	end

	if CurTime() > DrawTime1 then
		hook.Remove("PostDrawViewModel", "Draw3DVMMessage")
		PlayedSound = false
		DrawTime1 = nil
		ToDraw1 = {}
		return
	end

	local dh = DrawY1
	local ang = EyeAngles()
	local p, y, r = ang.p, ang.y, ang.r
	ang:RotateAroundAxis(ang:Up(), -90)
	ang:RotateAroundAxis(ang:Forward(), 90)
	--[=[ang.p = ang.p + 180
	ang.y = r + 90
	ang.r = y -90]=]
	
	local delta = DrawTime1 - CurTime()	
	local delta2 = ((5-delta)/0.5) -- when it equals 0 that means that our message arrived
	
	if delta < 4.5 and not PlayedSound then
		surface.PlaySound("physics/body/body_medium_break"..math.random(2,3)..".wav")
		PlayedSound = true
	end
	
	
	local rotation = math.Clamp(200*delta2,0,200)
	
	ang:RotateAroundAxis(ang:Up(), 200-rotation)
	
	local pos = math.Clamp(270*delta2,0,270)
	
	local alpha = 255
	
	if delta < 0.5 then
		alpha = 255*math.Clamp(delta/1,0,1)
	end

	--Somehow it goes wrong at times
	if not MySelf:GetAimVector() then
		return
	end
	
	cam.Start3D2D(EyePos()+MySelf:GetAimVector()*(310-pos),ang,0.05)
	cam.IgnoreZ(true)

		for i, msg in pairs(ToDraw1) do
		
			local txt, col, font = msg.String, msg.Color, msg.Font
			
			surface.SetFont(font)
			local tw,th = surface.GetTextSize(txt)
			
			col.a = alpha
			
			if i == 1 then
				surface.SetTexture ( BloodStuff[t1] )
				local sw, sh = surface.GetTextureSize( BloodStuff[t1] )
				surface.SetDrawColor(255,255,255,alpha)
				surface.DrawTexturedRectRotated ( -60, dh ,sw*1.2, sh*1.2, 0 )
				
				surface.SetTexture ( BloodStuff[t2] )
				local sw, sh = surface.GetTextureSize( BloodStuff[t2] )
				surface.SetDrawColor(255,255,255,alpha)
				surface.DrawTexturedRectRotated ( 60, dh ,sw*1.2, sh*1.2, 0 )
			end
			
			draw.SimpleTextOutlined(txt, font, 0, dh, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,alpha))
			
			dh = dh + th
			
		end
	cam.IgnoreZ(false)	
	cam.End3D2D()
	
end

function GM:Add3DMessage(y, msg, col, font)
	if util.tobool(GetConVarNumber("_zs_hidenotify")) then
		return
	end

	local Cached1 = true
	
	if not col then
		col = Color(255,255,255,255)
	end

	local Message = {}
	Message.String = msg
	Message.Color = col
	Message.Font = font

	t1,t2 = math.random(1,3), math.random(4,8)

	DrawTime1 = CurTime() + 5
	DrawY1 = y

	
	table.insert(ToDraw1, Message)

	hook.Add("PostDrawViewModel", "Draw3DMessage", Draw3DMessage)
end
-------------------------------------------------------
local CachedMarkups2 = {}

local ToDraw2 = {}
local DrawTime2 = 0
local DrawY2 = 0

local function DrawHintMessage()
	local curtime = CurTime()

	if curtime > DrawTime2 then
		hook.Remove("HUDPaint", "DrawHintMessage")
		DrawTime2 = nil
		return
	end

	local dh = DrawY2

	for i, marked in ipairs(ToDraw2) do
		local delta = DrawTime2 - curtime

		local th = marked.totalHeight
		local tw = marked.totalWidth
		
		local mid = w * 0.5 - tw * 0.5
		local alpha = math.min(1, delta) * 255
		marked:Draw(mid, dh,nil,nil,alpha)

		dh = dh + th
	end
end

function GM:HintMessage(y, arg)
	if not (ENABLE_HINTS) then return end
	local Cached2 = true

	for i=1,#arg do
		local str = arg[i]
		if not CachedMarkups2[str] then
			CachedMarkups2[str] = markup.Parse(str)
		end
	end

	ToDraw2 = {}

	DrawTime2 = CurTime() + 25
	DrawY2 = y

	for i=1, #arg do
		table.insert(ToDraw2, CachedMarkups2[ arg[i] ])
	end

	hook.Add("HUDPaint", "DrawHintMessage", DrawHintMessage)
end