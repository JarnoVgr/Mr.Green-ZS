-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information


local table = table
local surface = surface
local draw = draw
local math = math
local string = string
local util = util
local pairs = pairs
local team = team
local player = player


DRAW_BETA_HUD = true
if not DRAW_BETA_HUD then return end

-- Function table
hud = {}

-- Health indications
hud.HealthIndication = { [1] = { Text = "Healthy as a horse!", Percent = 1 }, [2] = { Text = "A few scratches..", Percent = 0.8 }, [3] = { Text = "Not looking good..", Percent = 0.6 }, [4] = { Text = "Search for a doctor!", Percent = 0.45 }, [5] = { Text = "You lost your guts!", Percent = 0.4 }, [6] = { Text = "Bleeding to death!", Percent = 0.25 } }
hud.ZombieHealthIndication = { [1] = { Text = "Hungry as hell!", Percent = 1 }, [2] = { Text = "It's just pain..", Percent = 0.8 }, [3] = { Text = "Not looking good..", Percent = 0.6 }, [4] = { Text = "Search for a poison aura!", Percent = 0.45 }, [5] = { Text = "I want gibs. NOW!", Percent = 0.4 }, [6] = { Text = "Crawling in my skin...", Percent = 0.25 } }

-- Temporal panic bar
hud.PanicBarColors = { [1] = { Percent = 1, Color = Color( 148,156,21,255 ) }, [2] = { Percent = 0.8, Color = Color( 179,145,42,255 ) }, [3] = { Percent = 0.6, Color = Color( 179,116,42,255 ) }, [4] = { Percent = 0.4, Color = Color( 191,77,26,255 ) }, [5] = { Percent = 0.2, Color = Color( 167,27,20,255 ) } }

-- Colors for danger sign
hud.DangerColors = { [1] = Color( 60, 132, 38, 255 ), [2] = Color( 108, 111, 39, 255 ), [3] = Color ( 115, 132, 38, 255 ), [4] = Color ( 143, 96, 15, 255 ), [5] = Color ( 130, 19, 19,255 ) }

-- Text for danger sign
hud.DangerText = { [1] = "Nothing to worry!", [2] = "Rotten meatbag..", [3] = "Zombie Fuck-up!", [4] = "HOLY SHI- F#$^", [5] = "ZOMBIELAND!" } -- Brainfest
hud.ZombieDangerText = { [1] = "Kill all humans!", [2] = "Fistful of flesh..", [3] = "Zombie Party!", [4] = "ARMY OF DEAD!", [5] = "DEAD RISING!" }

-- Textures needed
local matHealthSplash, matSplashTop = surface.GetTextureID ( "zombiesurvival/hud/splash_health" ), surface.GetTextureID ( "zombiesurvival/hud/splash_top" )

-- Avatar for classes
hud.AvatarClass = { 
	[1] = surface.GetTextureID ( "zombiesurvival/hud/avatar_medic" ),
	[2] = surface.GetTextureID ( "zombiesurvival/hud/avatar_commando" ),
	[3] = surface.GetTextureID ( "zombiesurvival/hud/avatar_berserker" ),
	[4] = surface.GetTextureID ( "zombiesurvival/hud/avatar_engineer" ),
	[5] = surface.GetTextureID ( "zombiesurvival/hud/avatar_support" ),
}

hud.ZombieAvatarClass = { 
	[1] = surface.GetTextureID ("zombiesurvival/classmenu/zombie"),
	[2] = surface.GetTextureID ("zombiesurvival/classmenu/fastzombie"),
	[3] = surface.GetTextureID ("zombiesurvival/classmenu/poisonzombie"),
	[4] = surface.GetTextureID ("zombiesurvival/classmenu/wraith"),
	[5] = surface.GetTextureID ("zombiesurvival/classmenu/howler"),
	[6] = surface.GetTextureID ("zombiesurvival/classmenu/headcrab"),
	[7] = surface.GetTextureID ("zombiesurvival/classmenu/poisonheadcrab"),
	[8] = surface.GetTextureID ("zombiesurvival/classmenu/zombine"),
}


--[==[----------------------------------------
	 Initialize fonts we need
-----------------------------------------]==]
function hud.InitFonts()

	-- Health indication font
	surface.CreateFont( "Arial", ScreenScale( 7.6 ), 600, true, true, "HUDBetaHealth" ) -- 14.6

	-- Level font
	surface.CreateFont( "Arial", ScreenScale( 7.6 ), 600, true, true, "HUDBetaLevel" ) -- 14.6
	
	-- Level font 4:3
	surface.CreateFont( "Arial", ScreenScale( 7.3 ), 600, true, true, "HUDBetaLevelNormal" ) -- 14.6
	
	-- Kills icon font
	surface.CreateFont( "csd", ScreenScale( 21.6 ), 500, true, true, "HUDBetaKills" ) -- 44.6
	
	-- Ammo regen icon font
	surface.CreateFont( "csd", ScreenScale( 17.6 ), 500, true, true, "HUDBetaAmmo" ) -- 36/6
	
	-- Kills and regen text font
	surface.CreateFont( "Arial", ScreenScale( 7.6 ), 500, true, true, "HUDBetaStats" ) -- 16
	
	-- Small level showout
	surface.CreateFont ( "Arial", ScreenScale( 7 ), 700, true, true, "HUDBetaCorner" ) -- 14
	
	-- How much to survive font
	surface.CreateFont ( "Arial", ScreenScale( 13 ), 500, true, true, "HUDBetaHeader" )
	
	-- Zombie count
	surface.CreateFont ( "Arial", ScreenScale( 17 ), 700, true, true, "HUDBetaZombieCount" )
	
	-- Infliction percentage font
	surface.CreateFont ( "Arial", ScreenScale( 10 ), 700, true, true, "HUDBetaInfliction" )
	
	-- Right upper box text font
	surface.CreateFont ( "Arial", ScreenScale( 9.6 ), 700, true, true, "HUDBetaRightBox" )
	
	surface.CreateFont ( "DS-Digital", ScreenScale( 7.6 ), 700, true, true, "NewAmmoFont7" )
	
	surface.CreateFont ( "DS-Digital", ScreenScale( 9 ), 700, true, true, "NewAmmoFont9" )
	
	surface.CreateFont ( "DS-Digital", ScreenScale( 13 ), 700, true, true, "NewAmmoFont13" )
	
	surface.CreateFont ( "DS-Digital", ScreenScale( 20 ), 700, true, true, "NewAmmoFont20" )
	
	--[=[surface.CreateFont ( "Sansation", ScreenScale( 7.6 ), 700, true, true, "sNewAmmoFont7" )
	
	surface.CreateFont ( "Sansation", ScreenScale( 9 ), 700, true, true, "sNewAmmoFont9" )
	
	surface.CreateFont ( "Sansation", ScreenScale( 13 ), 700, true, true, "sNewAmmoFont13" )
	
	surface.CreateFont ( "Sansation", ScreenScale( 20 ), 700, true, true, "sNewAmmoFont20" )]=]
	
	surface.CreateFont ( "Arial", ScreenScale( 7.6 ), 700, true, false, "ssNewAmmoFont7" )
	
	surface.CreateFont ( "Arial", ScreenScale( 7 ), 700, true, false, "ssNewAmmoFont6.5" )
	
	surface.CreateFont ( "Arial", ScreenScale( 9 ), 700, true, false, "ssNewAmmoFont9" )
	
	surface.CreateFont ( "Arial", ScreenScale( 13 ), 700, true, false, "ssNewAmmoFont13" )
	
	surface.CreateFont ( "Arial", ScreenScale( 20 ), 700, true, false, "ssNewAmmoFont20" )
	
	
	surface.CreateFont ( "Face Your Fears", ScreenScale( 17 ), 400, true, true, "NewZombieFont17",false,true )
	
	surface.CreateFont ( "Face Your Fears", ScreenScale( 15 ), 400, true, true, "NewZombieFont15",false,true )
	
	surface.CreateFont ( "Face Your Fears", ScreenScale( 13 ), 400, true, true, "NewZombieFont13",false,true )
	
	surface.CreateFont ( "Face Your Fears", ScreenScale( 27 ), 400, true, true, "NewZombieFont27",false,true )
	
	surface.CreateFont ( "Face Your Fears", ScreenScale( 23 ), 400, true, true, "NewZombieFont23",false,true )
	
	surface.CreateFont ( "Face Your Fears", ScreenScale( 19 ), 400, true, true, "NewZombieFont19",false,true )
	
	surface.CreateFont ( "Face Your Fears", ScreenScale( 14 ), 400, true, true, "NewZombieFont14",false,true )
	
	surface.CreateFont ( "Face Your Fears", ScreenScale( 10 ), 400, true, true, "NewZombieFont10",false,true )
	
end
hook.Add ( "Initialize", "hud.InitFonts", hud.InitFonts )

--[==[----------------------------------------
	     Human HUD main
-----------------------------------------]==]
function hud.HumanHUD()
	if not IsEntityValid ( MySelf ) or ENDROUND then return end
	
	-- SQL ready
	if not MySelf.ReadySQL then return end

	if not MySelf:Alive() then return end
	if IsClassesMenuOpen() then return end
	-- if IsSkillShopOpen() then return end
	
	-- Only humans
	if not MySelf:IsHuman() then return end
	
	if util.tobool(GetConVarNumber("_zs_hidehud")) then return end
	
	hud.DrawNewHumanHUD()
	
end
hook.Add ( "HUDPaint", "hud.HumanHUD", hud.HumanHUD )


local matDangerSign = surface.GetTextureID ( "zombiesurvival/hud/danger_sign" )

--[==[----------------------------------------
	     Zombie HUD main
-----------------------------------------]==]
function hud.ZombieHUD()
	if not IsEntityValid ( MySelf ) or ENDROUND then return end
	if not MySelf:Alive() then return end
	
	-- SQL ready
	if not MySelf.ReadySQL then return end
	
	if IsClassesMenuOpen() then return end
	if not MySelf:IsZombie() then return end
	if util.tobool(GetConVarNumber("_zs_hidehud")) then return end
	
	hud.DrawBossHealth()
	hud.DrawNewZombieHUD()
	
end
hook.Add ( "HUDPaint", "hud.ZombieHUD", hud.ZombieHUD )

hud.BossBackground = surface.GetTextureID ( "zombiesurvival/hud/splash_top" )
hud.texGradDown = surface.GetTextureID("VGUI/gradient_down")
function hud.DrawBossHealth()
	
	if not GAMEMODE:IsBossAlive() then return end
	
	local BW,BH = ScaleW(440), ScaleW(440)
	local BX,BY = w/2-BW/2, 0
	
	surface.SetDrawColor ( 119, 10, 10, 255 )
	surface.SetTexture ( hud.BossBackground )
	surface.DrawTexturedRect ( BX,BY,BW,BH ) 
	
	local BarW,BarH = BW*0.75, ScaleH(36)
	local BarX,BarY = w/2-BarW/2, ScaleH(100)
	
	surface.SetDrawColor( 0, 0, 0, 150)
	surface.DrawRect(BarX,BarY,BarW,BarH)
	surface.DrawRect(BarX+5, BarY+5, BarW-10, BarH-10)
	
	surface.SetDrawColor(125,29,21,255)
	
	if GAMEMODE:GetBossZombie() then
		local health = GAMEMODE:GetBossZombie():Health() or 0
		
		local TX,TY = BarX+BarW/5,BarY+7
		
		draw.SimpleText(ZombieClasses[GAMEMODE:GetBossZombie():GetZombieClass()].Name or GAMEMODE:GetBossZombie():Name(), "NewZombieFont23", TX,TY, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		
		local dif = math.Clamp(health/GAMEMODE:GetBossZombie():GetMaximumHealth(),0,1)
		
		surface.SetTexture(hud.texGradDown)
		surface.DrawTexturedRect(BarX+5, BarY+5, (BarW-10)*dif, BarH-10 )
		--surface.DrawRect(BarX+5, BarY+5, (BarW-10)*dif, BarH-10 )
	end	
	
end

local lastwarntim = -1
hud.ZombieOverlay = surface.GetTextureID ( "damageover3.vtf" )
hud.boostmat = surface.GetTextureID ( "zombiesurvival/hud/hud_friend_splash" )
local lastrefresh = -1
local cached_humans = 0
local cached_zombies = 0
function hud.DrawNewZombieHUD()
	
	if lastrefresh <= CurTime() then
		cached_humans = team.NumPlayers(TEAM_HUMAN)
		cached_zombies = team.NumPlayers(TEAM_UNDEAD)
		lastrefresh = CurTime() + 1
	end
	
	if GAMEMODE:IsRetroMode() then
		draw.SimpleTextOutlined("RETRO APOCALYPSE", "NewZombieFont13", w/2 , h-23*2, Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end
	
	surface.SetDrawColor ( 179, 0, 0, 255 )
	surface.SetTexture ( hud.ZombieOverlay )
	surface.DrawTexturedRect ( -90,-90, ScrW()+180, ScrH()+180 ) 
	
	local tw, th = surface.GetTextureSize( matHealthSplash )
	
	local x,y = 30, ScrH()-tw+190
	
	if not MySelf:IsFreeSpectating() then
	
	surface.SetDrawColor ( 119, 0, 0, 255 )
	surface.SetTexture ( matHealthSplash )
	surface.DrawTexturedRect ( x,y, tw, th ) 
	
	local Table = string.FormattedTime ( ROUNDTIME - CurTime() )

	if ( Table.s ) > 30 then Table.m = Table.m - 1 end
	
	if ( Table.m ) < 10 then Table.m = "0"..Table.m end
	if ( Table.s ) < 10 then Table.s = "0"..Table.s end

--	draw.SimpleText(Table.m..":"..Table.s, "NewZombieFont17", x+95, y+170, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	surface.SetDrawColor( 0, 0, 0, 150)
	surface.DrawRect(x+70 , y+195, 260, 30 )
	
	x,y = x+70 , y+195

	surface.DrawRect(x+5 , y+5, 260-10, 30-10 )	
	
	local fHealth, fMaxHealth = math.max(MySelf:Health(),0), MySelf:GetMaximumHealth()
	
	if not MySelf.HPBar then MySelf.HPBar = 1 end
	MySelf.HPBar = math.Clamp ( math.Approach ( MySelf.HPBar, fHealth / fMaxHealth, FrameTime() * 1.8 ), 0, 1 )
	
	local iPercentage = math.Clamp ( fHealth / fMaxHealth, 0, 1 )
	
	local colHealthBar = COLOR_HUD_HEALTHY
	if 0.8 < iPercentage then colHealthBar = Color( 136,29,21,255 ) elseif 0.6 < iPercentage then colHealthBar = Color( 125,29,21,255 ) elseif 0.3 < iPercentage then colHealthBar = Color( 110,11,11,255 ) else colHealthBar = Color ( 110,11,11,( math.sin(RealTime() * 8) * 127.5 ) + 127.5 ) end
	
	surface.SetDrawColor( colHealthBar)
	surface.DrawRect(x+5 , y+5, 250*MySelf.HPBar, 20 )
	
	--draw.SimpleText(fHealth, "NewZombieFont17", x+110, y+45, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleTextOutlined(fHealth, "NewZombieFont17", x+110, y+45, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
	
	draw.SimpleText("GREENCOINS: "..MySelf:GreenCoins(), "NewZombieFont13", x+108, y-11, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
	if REDEEM_PUNISHMENT then
		if GAMEMODE:GetWave() >= REDEEM_PUNISHMENT_TIME then
			draw.SimpleText("Redeem time has expired!", "NewZombieFont13", x, y+77, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end
	
	end
	-- WAVES
	
	local curwav = GAMEMODE:GetWave()
	
	surface.SetFont("NewZombieFont15")
	local fWide, fTall = surface.GetTextSize ( "Wave ".. curwav .. " out of ".. NUM_WAVES.."  |  " )
	
	local text1x, text1y = 10, 10
	local text2x, text2y = 10, text1y+fTall+1
	

	
	-- zero wave
	if curwav <= 0 then
		
		local timleft = math.max(0, WAVEZERO_LENGTH - CurTime())
		
		draw.SimpleTextOutlined("Prepare your asses...", "NewZombieFont15", text1x, text1y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
		
		if timleft < 10 then
			local glow = math.sin(RealTime() * 8) * 200 + 255
			draw.SimpleTextOutlined("Zombie invasion in: 0"..ToMinutesSeconds(timleft + 1), "NewZombieFont15", text2x, text2y, Color(255, glow, glow), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
			if lastwarntim ~= math.ceil(timleft) then
				lastwarntim = math.ceil(timleft)
				if 0 < lastwarntim then
					surface.PlaySound("mrgreen/ui/menu_countdown.wav")
				end
			end
		else
			draw.SimpleTextOutlined("Zombie invasion in: 0"..ToMinutesSeconds(timleft + 1), "NewZombieFont15", text2x, text2y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
		end
	elseif GAMEMODE:GetFighting() then
		local timleft = math.max(0, GAMEMODE:GetWaveEnd() - CurTime())
		if timleft <= 0 then
			--draw.SimpleTextOutlined(GAMEMODE:NumLivingZombies().." Zombies remaining", "ArialBoldSeven", text2x, text2y,  Color(255,155,155,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
		else
			if 10 < timleft then
				draw.SimpleTextOutlined("0"..ToMinutesSeconds(timleft + 1), "NewZombieFont15", text1x + fWide + 2, text1y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
			else
				local glow = math.sin(RealTime() * 8) * 200 + 255
				draw.SimpleTextOutlined("0"..ToMinutesSeconds(timleft + 1), "NewZombieFont15", text1x + fWide + 2, text1y, Color(255,glow,glow,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
				if lastwarntim ~= math.ceil(timleft) then
					lastwarntim = math.ceil(timleft)
					if 0 < lastwarntim then
						surface.PlaySound("mrgreen/ui/menu_countdown.wav")
					end
				end
			end
		end
		draw.SimpleTextOutlined("Wave ".. curwav .. " out of ".. NUM_WAVES.."  |  ", "NewZombieFont15", text1x, text1y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
		
		draw.SimpleTextOutlined("Infliction: ", "NewZombieFont15", text2x, text2y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
		
		local space1 = surface.GetTextSize ( "Infliction: " )
		
		draw.SimpleTextOutlined(cached_zombies, "NewZombieFont15", text2x+space1, text2y, team.GetColor(TEAM_UNDEAD), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
		
		local space2 = surface.GetTextSize ( cached_zombies )
		
		draw.SimpleTextOutlined("/", "NewZombieFont15", text2x+space1+space2+1, text2y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
		
		local space3 = surface.GetTextSize ( "/" )
		
		draw.SimpleTextOutlined(cached_humans, "NewZombieFont15", text2x+space1+space2+space3+2, text2y, team.GetColor(TEAM_HUMAN), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
		
		
	else
		local timleft = math.max(0, GAMEMODE:GetWaveStart() - CurTime())
		if timleft < 10 then
			local glow = math.sin(RealTime() * 8) * 200 + 255
			draw.SimpleTextOutlined("Next wave in: 0"..ToMinutesSeconds(timleft + 1), "NewZombieFont15", text2x, text2y,  Color(255, glow, glow,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
			if lastwarntim ~= math.ceil(timleft) then
				lastwarntim = math.ceil(timleft)
					if 0 < lastwarntim then
					surface.PlaySound("mrgreen/ui/menu_countdown.wav")
				end
			end
		else
			if GAMEMODE:NumLivingZombies() > 0 then
				draw.SimpleTextOutlined(GAMEMODE:NumLivingZombies().." Zombies remaining", "NewZombieFont15", text2x, text2y,  Color(255,100,100,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
			else
				draw.SimpleTextOutlined("Next wave in: 0"..ToMinutesSeconds(timleft + 1), "NewZombieFont15", text2x, text2y,  Color(255, 255, 255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
			end
		end
		draw.SimpleTextOutlined("Wave ".. curwav .. " out of ".. NUM_WAVES.."  ", "NewZombieFont15", text1x, text1y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
	end
	

	if drawZombieBoost == true then return end
	
	if not MySelf.HRBar then MySelf.HRBar = MySelf:GetHordeCount() end
	

	local HORDE = util.tobool( GetConVarNumber("_zs_showhorde") ) 
	
	if not HORDE then return end

	local max = math.min(cached_zombies,HORDE_MAX_ZOMBIES)
	
	MySelf.HRBar = math.Clamp ( math.Approach ( MySelf.HRBar, MySelf:GetHordeCount(), FrameTime() * 5 ), 0, math.Clamp(max-1,0,max ))

	if MySelf.HRBar <= 0 then return end
	--Draw Horde status
	
	local swide,stall = ScaleW(166), ScaleH(17)
	local sx,sy = w/2 - swide/2, 3.5*h/4
	
	--local matW, matH = surface.GetTextureSize( matSplash )
	local matW, matH = ScaleW(315), ScaleH(315)
	local matX, matY = w/2 - matW/2, 3.5*h/4 + stall/2 - matH/2
	
	local coefW, coefH = swide/matW,stall/matH
	
	surface.SetDrawColor ( 119, 10, 10, 255 )
	surface.SetTexture ( hud.boostmat )
	surface.DrawTexturedRect ( matX, matY, matW, matH ) 

	draw.SimpleTextOutlined("Damage resistance", "ArialBoldFive", w/2 , sy-3, Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	
	sy = sy+5
	
	--draw.RoundedBox( 0, sx,sy,swide,stall, Color (1,1,1,200) )
	
	surface.SetDrawColor( 0, 0, 0, 150)
	surface.DrawRect(sx,sy,swide,stall )
	
	surface.DrawRect(sx+3 , sy+2.5, swide-6, stall-6 )	
		
	
	surface.SetDrawColor( 230,1,1,160)
	
	if MySelf:GetHordeCount() == math.Clamp(max-1,0,max ) then
		surface.SetDrawColor( 230,1,1,( math.sin(RealTime() * 8) * 127.5 ) + 150.5 )
	end
	
	surface.DrawRect(sx+3 , sy+2.5, ((MySelf.HRBar)/math.Clamp(max-1,0,max ))*(swide-6),stall-6 )	
	

	

end

hud.LeftGradient = surface.GetTextureID( "gui/gradient" )
hud.Arrow = surface.GetTextureID( "gui/arrow" )
function hud.DrawNewHumanHUD()
	
	if lastrefresh <= CurTime() then
		cached_humans = team.NumPlayers(TEAM_HUMAN)
		cached_zombies = team.NumPlayers(TEAM_UNDEAD)
		lastrefresh = CurTime() + 1
	end
	
	--Draw!
	hud.DrawBossHealth()
	-- hud.DrawAmmo(ScrW()-205,ScrH()-100,175,70)
	hud.DrawAmmoPanel()
	
	hud.DrawHealthPanel()
	
	hud.DrawWavePanel()
	
	hud.DrawStatsPanel()
	
	hud.DrawZeroWaveMessage()
	
	local ENABLE_HPBAR = util.tobool(GetConVarNumber("_zs_enablehpbar"))
	if ENABLE_HPBAR then
	-- 	hud.SmallHPPanel(170,ScrH()-90,185,60)
	end
	
	if GAMEMODE:IsRetroMode() then
		draw.SimpleTextOutlined("RETRO APOCALYPSE", "NewZombieFont13", w/2 , h-23*2, Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end
		
	
	if not OBJECTIVE then return end
	
	surface.SetTexture(hud.LeftGradient)
	surface.SetDrawColor(0, 0, 0, 140)
	surface.DrawTexturedRect(0,0,ScaleW(370),ScaleH(60))
	
	draw.SimpleTextOutlined("Stage #"..GAMEMODE:GetObjStage().." out of "..#Objectives, "ArialBoldFive", 10, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
	draw.SimpleTextOutlined("Objective: "..Objectives[GAMEMODE:GetObjStage()].Info, "ArialBoldFive", 10, 25, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
		
	
end



function hud.DrawAmmoPanel()
	
	local ActiveWeapon = MySelf:GetActiveWeapon()
	if not ValidEntity ( ActiveWeapon ) then return end
	local PrimaryAmmo, SecondaryAmmo = MySelf:GetActiveWeapon():Clip1(), MySelf:GetAmmoCount( MySelf:GetActiveWeapon():GetPrimaryAmmoType() )
	
	--Options
	local AmmoStepX,AmmoStepY = 12,12
	local AmmoW,AmmoH = ScaleW(150), ScaleH(73)
	local AmmoX,AmmoY = ScrW()-AmmoW-AmmoStepX, ScrH()-AmmoH-AmmoStepY
	
	MySelf.WepX,MySelf.WepY = AmmoX, AmmoY+AmmoH
	MySelf.WepW,MySelf.WepH = AmmoW, AmmoH
	
	local w,h,x,y = AmmoW,AmmoH,AmmoX,AmmoY
	
	-- draw turret's ammo
	if ActiveWeapon:GetClass() == "weapon_zs_tools_remote" then
		for _,v in pairs (ents.FindByClass("zs_turret")) do
			if v:GetTurretOwner() and v:GetTurretOwner() == MySelf then
				PrimaryAmmo, SecondaryAmmo = v:GetDTInt(0),v:GetDTInt(2)
				break
			end
		end
	end
	
	if ActiveWeapon.NoHUD then return end
	
	if PrimaryAmmo ~= -1 then
	
		--Background
		-- DrawBlackBox(AmmoX,AmmoY,AmmoW,AmmoH)
		
		--Ammo
		
		local ToDraw1 = PrimaryAmmo
		
		local xpos = x+14
		-- for _,v in pairs(Numbers) do
		-- 	draw.SimpleText(v, "sNewAmmoFont20", xpos+w/2.5, y+h/2, Color(110,110,110,35), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		-- end
		
		draw.SimpleTextOutlined(ToDraw1, "ssNewAmmoFont20", xpos+w/2.5, y+h/2, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		if SecondaryAmmo > 0 then
		local fWide, fTall = surface.GetTextSize ( "/" )
		xpos = xpos + fWide
		
		draw.SimpleTextOutlined("/", "ssNewAmmoFont13", xpos+w/2.5, y+h/2, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		
		fWide, fTall = surface.GetTextSize ( "888" )
		xpos = xpos + fWide
		
		-- draw.SimpleText("888", "sNewAmmoFont13", xpos+w/2.5, y+h/2, Color(110,110,110,35), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleTextOutlined(SecondaryAmmo, "ssNewAmmoFont13", xpos+w/2.5, y+h/2, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		end
	end


end

local turreticon = surface.GetTextureID("killicon/turret")

function hud.DrawHealthPanel()
	
	--Options
	local HealthStepX,HealthStepY = 12,12
	local HealthW,HealthH = ScaleW(250), ScaleH(73)
	local HealthX,HealthY = HealthStepX, ScrH()-HealthH-HealthStepY
	
	--Background
	-- DrawBlackBox(HealthX,HealthY,HealthW,HealthH)
	
	--Health
	
	local ActualX = HealthX + ScaleW(5)
	local ActualY = HealthY + HealthH/2
	
	if GAMEMODE:IsRetroMode() then
		local ammotime = Entity(0) and Entity(0):GetDTFloat(0) or 0
		local TimeLeft = ammotime - CurTime()  
		draw.SimpleTextOutlined("Ammo regeneration: "..ToMinutesSeconds(TimeLeft + 1), "ssNewAmmoFont9", ActualX+6, HealthY-15, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM,1,Color(0,0,0,255))
	end
	
	local fHealth, fMaxHealth = math.max(MySelf:Health(),0), MySelf:GetMaximumHealth()

	local iPercentage = math.Clamp ( fHealth / fMaxHealth, 0, 1 )	
	
	draw.SimpleTextOutlined("F", "HUDBetaKills", ActualX, ActualY+ScaleH(12), Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	
	ActualX = ActualX + ScaleW(32)
	
	draw.SimpleTextOutlined(math.Round(100*iPercentage), "ssNewAmmoFont13", ActualX, ActualY, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	
	local HPBarSizeW,HPBarSizeH = ScaleW(160),HealthH*0.56
	
	ActualX = ActualX + ScaleW(42)
	ActualY = ActualY - HPBarSizeH/2
	
	
	if not MySelf.HPBar then MySelf.HPBar = 1 end
	MySelf.HPBar = math.Clamp ( math.Approach ( MySelf.HPBar, fHealth / fMaxHealth, FrameTime() * 1.8 ), 0, 1 )
	
	-- Color of healthbar
	local colHealthBar, sHealthIndication = COLOR_HUD_HEALTHY
	if 0.8 < iPercentage then colHealthBar = Color ( 255,255,255,235 ) elseif 0.6 < iPercentage then colHealthBar = Color ( 146,142,22,235 ) elseif 0.3 < iPercentage then colHealthBar = Color ( 166,79,3,235 ) else colHealthBar = Color ( 153,7,4,math.sin(RealTime() * 6) * 127.5 + 127.5 ) end
	
	if MySelf:IsHuman() then
		if MySelf:IsTakingDOT() then
			if iPercentage > 0.3 then 
				colHealthBar = COLOR_HUD_HURT 
			end
		end

		if MySelf:IsTakingDOT() or iPercentage < 0.3 then
			colHealthBar = Color( colHealthBar.r, colHealthBar.g, colHealthBar.b, math.abs( math.sin( RealTime() * 4 ) ) * 255 )
		end	
	end
	
	surface.SetDrawColor( 0, 0, 0, 150)
	surface.DrawRect(ActualX, ActualY, HPBarSizeW,HPBarSizeH )
	
	surface.DrawRect(ActualX+5 , ActualY+5,  HPBarSizeW-10, HPBarSizeH-10 )	
	
	surface.SetDrawColor(colHealthBar)
	surface.DrawRect(ActualX+5 , ActualY+5, (HPBarSizeW-10)*MySelf.HPBar, HPBarSizeH-10 )
	
	
	if IsValid(MySelf.MiniTurret) or IsValid(MySelf.Turret) then
		
		local tur = MySelf.MiniTurret or MySelf.Turret
		
		if not tur then return end
	
		ActualX = ActualX + HPBarSizeW + ScaleW(20)
	
		local th = HPBarSizeH
	
		surface.SetDrawColor( 0, 0, 0, 150)
		surface.DrawRect(ActualX, ActualY, ScaleW(80),HPBarSizeH )
		
		surface.SetTexture(turreticon)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(ActualX,ActualY,th,th)
		
		ActualX = ActualX + th + ScaleW(40)
		
		
		
		draw.SimpleTextOutlined(tur:GetAmmo().."/"..tur:GetMaxAmmo(), "ssNewAmmoFont6.5", ActualX, ActualY+th/2, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end
	
	--[=[[Stats
	
	local StatsW,StatsH = HealthW,HealthH/2
	local StatsX,StatsY = HealthX,HealthY-StatsH
	
	--Background
	DrawBlackBox(StatsX,StatsY,StatsW,StatsH)
	
	ActualX = StatsX + ScaleW(5)
	ActualY = StatsY + StatsH/2
	
	draw.SimpleTextOutlined("GC: "..MySelf:GreenCoins(), "ssNewAmmoFont7", ActualX, ActualY, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	
	ActualX = StatsX + StatsW/2 + ScaleW(5)
	local LIGHTHUD = util.tobool(GetConVarNumber("_zs_enablelighthud"))
	if not LIGHTHUD then
		surface.SetDrawColor( 30, 30, 30, 200 )
		surface.DrawOutlinedRect( StatsX + StatsW/2, StatsY, StatsW/2, StatsH )
		surface.SetDrawColor( 30, 30, 30, 255 )
		surface.DrawOutlinedRect( StatsX + StatsW/2+1, StatsY+1, StatsW/2-2, StatsH-2 )
	end
	
	MySelf.SkillPoints = MySelf.SkillPoints or 0
	
	draw.SimpleTextOutlined("SP: "..MySelf.SkillPoints, "ssNewAmmoFont7", ActualX, ActualY, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	]=]

end



local nextreward = -1
function hud.DrawStatsPanel()

	--Stats
	local StatsX,StatsY = 12+ScaleW(7),34+ScaleH(70)

	surface.SetFont("ssNewAmmoFont6.5")
	local fWide, fTall = surface.GetTextSize ( "GreenCoins" )
	
	draw.SimpleTextOutlined("GreenCoins: "..MySelf:GreenCoins(), "ssNewAmmoFont6.5", StatsX, StatsY, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	
	StatsY = StatsY + fTall + 2
	
	MySelf.SkillPoints = MySelf.SkillPoints or 0
	
	local text = "SkillPoints: "..MySelf:Frags()
	
	if GAMEMODE:IsRetroMode() then
		
		local frags = MySelf:Frags()
		if nextreward ~= 9999 and nextreward <= frags then
			local maxn = table.maxn(GAMEMODE.RetroUnlocks)
			for i=1, maxn do
				if GAMEMODE.RetroUnlocks[i] and frags < i then
					nextreward = i
					break
				elseif i == maxn then
					nextreward = 9999
				end
			end
		end
		
		if nextreward == 9999 then
			text = "Kills: "..frags
		else
			text = "Kills: "..frags.." | Needed: "..nextreward
		end
	end
	
	draw.SimpleTextOutlined(text, "ssNewAmmoFont6.5", StatsX, StatsY, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
end

function hud.DrawWavePanel()

	local WaveX,WaveY = 12,12
	local WaveW,WaveH = ScaleW(205),ScaleH(70)

	--Background
	-- DrawBlackBox(WaveX,WaveY,WaveW,WaveH)
	
	-- surface.SetTexture(hud.LeftGradient)
	-- surface.SetDrawColor(0, 0, 0, 140)
	-- surface.DrawTexturedRect(0,0,ScaleW(300),ScaleH(80))
		
	local curwav = GAMEMODE:GetWave()
	
	surface.SetFont("ArialBoldSeven")
	local fWide, fTall = surface.GetTextSize ( "Wave ".. curwav .. " out of ".. NUM_WAVES.."  |  " )
	
	local text1x, text1y = WaveX+ScaleW(7), WaveY+5
	local text2x, text2y = WaveX+ScaleW(7), text1y+fTall+5
	

	
	-- zero wave
	if curwav <= 0 then
		
		local timleft = math.max(0, WAVEZERO_LENGTH - CurTime())
		
		draw.SimpleTextOutlined("Prepare your asses...", "ArialBoldSeven", text1x, text1y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
		
		if timleft < 10 then
			local glow = math.sin(RealTime() * 8) * 200 + 255
			draw.SimpleTextOutlined("Zombie invasion in: 0"..ToMinutesSeconds(timleft + 1), "ArialBoldSeven", text2x, text2y, Color(255, glow, glow), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
			if lastwarntim ~= math.ceil(timleft) then
				lastwarntim = math.ceil(timleft)
				if 0 < lastwarntim then
					surface.PlaySound("mrgreen/ui/menu_countdown.wav")
				end
			end
		else
			draw.SimpleTextOutlined("Zombie invasion in: 0"..ToMinutesSeconds(timleft + 1), "ArialBoldSeven", text2x, text2y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
		end
	elseif GAMEMODE:GetFighting() then
		local timleft = math.max(0, GAMEMODE:GetWaveEnd() - CurTime())
		if timleft <= 0 then
			--draw.SimpleTextOutlined(GAMEMODE:NumLivingZombies().." Zombies remaining", "ArialBoldSeven", text2x, text2y,  Color(255,155,155,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
		else
			if 10 < timleft then
				draw.SimpleTextOutlined("0"..ToMinutesSeconds(timleft + 1), "ArialBoldSeven", text1x + fWide + 2, text1y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
			else
				local glow = math.sin(RealTime() * 8) * 200 + 255
				draw.SimpleTextOutlined("0"..ToMinutesSeconds(timleft + 1), "ArialBoldSeven", text1x + fWide + 2, text1y, Color(255,glow,glow,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
				if lastwarntim ~= math.ceil(timleft) then
					lastwarntim = math.ceil(timleft)
					if 0 < lastwarntim then
						surface.PlaySound("mrgreen/ui/menu_countdown.wav")
					end
				end
			end
		end
		draw.SimpleTextOutlined("Wave ".. curwav .. " out of ".. NUM_WAVES.."  |  ", "ArialBoldSeven", text1x, text1y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
		
		draw.SimpleTextOutlined("Infliction: ", "ArialBoldSeven", text2x, text2y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
		
		local space1 = surface.GetTextSize ( "Infliction: " )
		
		draw.SimpleTextOutlined(cached_zombies, "ArialBoldSeven", text2x+space1, text2y, team.GetColor(TEAM_UNDEAD), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
		
		local space2 = surface.GetTextSize ( cached_zombies )
		
		draw.SimpleTextOutlined("/", "ArialBoldSeven", text2x+space1+space2+1, text2y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
		
		local space3 = surface.GetTextSize ( "/" )
		
		draw.SimpleTextOutlined(cached_humans, "ArialBoldSeven", text2x+space1+space2+space3+2, text2y, team.GetColor(TEAM_HUMAN), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
		
		
	else
		local timleft = math.max(0, GAMEMODE:GetWaveStart() - CurTime())
		if timleft < 10 then
			local glow = math.sin(RealTime() * 8) * 200 + 255
			draw.SimpleTextOutlined("Next wave in: 0"..ToMinutesSeconds(timleft + 1), "ArialBoldSeven", text2x, text2y,  Color(255, glow, glow,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
			if lastwarntim ~= math.ceil(timleft) then
				lastwarntim = math.ceil(timleft)
					if 0 < lastwarntim then
					surface.PlaySound("mrgreen/ui/menu_countdown.wav")
				end
			end
		else
			if GAMEMODE:NumLivingZombies() > 0 then
				draw.SimpleTextOutlined(GAMEMODE:NumLivingZombies().." Zombies remaining", "ArialBoldSeven", text2x, text2y,  Color(255,50,50,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
			else
				draw.SimpleTextOutlined("Next wave in: 0"..ToMinutesSeconds(timleft + 1), "ArialBoldSeven", text2x, text2y,  Color(255, 255, 255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
			end
		end
		draw.SimpleTextOutlined("Wave ".. curwav .. " out of ".. NUM_WAVES.."  ", "ArialBoldSeven", text1x, text1y, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
	end
	
end

hud.GradientExample = surface.GetTextureID( "gui/center_gradient" )

function DrawBlackBox(x,y,w,h,overridealpha)
	local LIGHTHUD = util.tobool(GetConVarNumber("_zs_enablelighthud"))
	if LIGHTHUD then return end
	local a = 1
	
	if overridealpha then
		a = overridealpha
	end
	
	surface.SetDrawColor( Color( 0, 0, 0, 240*a ) )
	surface.DrawRect( x, y, w, h )
		
	local Quad = {} 
	Quad.texture 	= hud.GradientExample
	Quad.color		= Color(40,40,40,140*a)
 
	Quad.x = x
	Quad.y = y
	Quad.w = w
	Quad.h = h
	draw.TexturedQuad( Quad )
		
	surface.SetDrawColor( 30, 30, 30, 200*a )
	surface.DrawOutlinedRect( x, y, w, h )
	surface.SetDrawColor( 30, 30, 30, 255*a )
	surface.DrawOutlinedRect( x+1, y+1, w-2, h-2 )

end

local Quad = {} 
function DrawPanelBlackBox(x,y,w,h,overridealpha)
	
	local a = 1
	
	if overridealpha then
		a = overridealpha
	end
	
	surface.SetDrawColor( Color( 0, 0, 0, 240*a ) )
	surface.DrawRect( x, y, w, h )
		
	
	Quad.texture 	= hud.GradientExample
	Quad.color		= Color(40,40,40,140*a)
 
	Quad.x = x
	Quad.y = y
	Quad.w = w
	Quad.h = h
	draw.TexturedQuad( Quad )
		
	surface.SetDrawColor( 30, 30, 30, 200*a )
	surface.DrawOutlinedRect( x, y, w, h )
	surface.SetDrawColor( 30, 30, 30, 255*a )
	surface.DrawOutlinedRect( x+1, y+1, w-2, h-2 )

end

function hud.DrawZeroWaveMessage()
	
		local curtime = CurTime()
	
		if WAVEZERO_LENGTH >= curtime then
		
			surface.SetFont("ArialBoldSeven")
			local txtw, txth = surface.GetTextSize("Hi")
			draw.SimpleTextOutlined("Waiting for players... "..ToMinutesSeconds(math.max(0, WAVEZERO_LENGTH - curtime) + 1), "ArialBoldSeven", ScrW() * 0.5, ScrH() * 0.25, COLOR_GRAY,TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
			draw.SimpleTextOutlined("Go to an undead spawn area if you want to start as zombie", "ArialBoldSeven", ScrW() * 0.5, ScrH() * 0.25 + txth, COLOR_GRAY, TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER,1, Color(0,0,0,255))

			local vols = 0
			local voltab = {}
			local allplayers = player.GetAll()
			for _, gasses in pairs(ents.FindByClass("zs_poisongasses")) do
				local gaspos = gasses:GetPos()
				for _, ent in pairs(allplayers) do
					if ent:GetPos():Distance(gaspos) <= 272 and not table.HasValue(voltab, ent) then
						vols = vols + 1
						table.insert(voltab, ent)
					end
				end
			end

			for _, pl in pairs(allplayers) do
				if pl:Team() == TEAM_UNDEAD then
					vols = vols + 1
					table.insert(voltab, pl)
				end
			end

			local numplayers = #allplayers
			local desiredzombies = math.max(1, math.ceil(numplayers * WAVE_ONE_ZOMBIES))
			
			-- Client zombie spawn warning
            if ( table.HasValue( voltab, MySelf ) ) then
                draw.SimpleTextOutlined("You're currently volunteering as a zombie! Get out of that place if you don't want that!", "ArialBoldSeven", ScrW() * 0.5, ScrH() * 0.7 + txth, Color(235,50,50,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER,1, Color(0,0,0,255))              
            end

			draw.SimpleTextOutlined("Number of initial zombies this game ("..WAVE_ONE_ZOMBIES * 100 .."%): "..desiredzombies, "ArialBoldSeven", ScrW() * 0.5, ScrH() * 0.75, COLOR_GRAY, TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER,1, Color(0,0,0,255))

			draw.SimpleTextOutlined("Zombie volunteers: "..vols, "ArialBoldSeven", ScrW() * 0.5, ScrH() * 0.75 + txth, COLOR_GRAY, TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
			
			surface.SetFont("Default")
			local y = ScrH() * 0.75 + txth * 2
			txtw, txth = surface.GetTextSize("Hi")
			for _, pl in pairs(voltab) do
				if ScrH() - txth <= y then break else
					draw.SimpleTextOutlined(pl:Name(), "ArialBoldFour", ScrW() * 0.5, y, COLOR_GRAY, TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
					y = y + txth
				end
			end
		end
	
end

function hud.DrawObjMessages()
	


	
	if not IsEntityValid ( MySelf ) or ENDROUND then return end

	if not MySelf.ReadySQL then return end

	if not MySelf:Alive() then return end
	if IsClassesMenuOpen() then return end
	if IsSkillShopOpen() then return end

	if not MySelf:IsHuman() then return end
	
	if not OBJECTIVE then return end
	
	if Objectives[GAMEMODE:GetObjStage()].PaintObjective and #Objectives[GAMEMODE:GetObjStage()].PaintObjective > 0 then
		
		local objpos = Objectives[GAMEMODE:GetObjStage()].PaintObjective[2] + Vector(0,0,60)
		local arrowpos = Objectives[GAMEMODE:GetObjStage()].PaintObjective[2]
		local anim = math.Clamp(math.sin( RealTime()*3.2)*10,-20,20)
		
		local angle = (MySelf:GetPos() - objpos):Angle()
		angle.p = 0
		angle.y = angle.y + 90
		angle.r = angle.r + 90

		cam.Start3D2D(objpos,angle,0.5)
			surface.SetTexture(hud.Arrow)
	
			
			surface.SetDrawColor(0,0, 0, 255)
			surface.DrawTexturedRectRotated(0,ScaleW(60) + anim,ScaleW(77),ScaleW(65),180)
			
			surface.SetDrawColor(255,255, 255, 255)
			surface.DrawTexturedRectRotated(0,ScaleW(60) + anim,ScaleW(60),ScaleW(60),180)
			
			
			draw.SimpleTextOutlined(Objectives[GAMEMODE:GetObjStage()].PaintObjective[1], "ArialBoldTen", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
			
		cam.End3D2D()
	
	end
	
end
hook.Add("PostDrawOpaqueRenderables","hud.DrawObjMessages",hud.DrawObjMessages)

