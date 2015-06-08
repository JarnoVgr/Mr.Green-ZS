-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- store convars here
ClientsideConvars = {}
ClientsideConvars["_zs_enablehints"] = {Value = 1, ShouldSave = true, UserData = false, CanChange = true, Category = "hud", Description = "Game Hints"}
ClientsideConvars["_zs_enablebeats"] = {Value = 1, ShouldSave = true, UserData = false, CanChange = true, Category = "hud", Description = "Beats"}
ClientsideConvars["_zs_enablemusic"] = {Value = 1, ShouldSave = true, UserData = false, CanChange = true, Category = "hud", Description = "Music"}
--ClientsideConvars["_zs_damage"] = {Value = 0, ShouldSave = true, UserData = false, CanChange = true, Category = "hud", Description = "Print damage output"}
ClientsideConvars["_zs_enableironsightblur"] = {Value = 1, ShouldSave = true, UserData = false, CanChange = false, Category = "hud", Description = "Blur while in ironsight"}
ClientsideConvars["_zs_ironsight"] = {Value = 0, ShouldSave = true, UserData = false, CanChange = true, Category = "hud", Description = "Crosshair while in ironsight"}
ClientsideConvars["_zs_enablehats"] = {Value = 1, ShouldSave = true, UserData = false, CanChange = true, Category = "hud", Description = "Hats"}
ClientsideConvars["_zs_headbob"] = {Value = 1, ShouldSave = true, UserData = false, CanChange = false, Category = "hud", Description = "Head-bobbing"}
ClientsideConvars["cl_legs"] = {Value = 1, ShouldSave = true, UserData = false, CanChange = true, Category = "hud", Description = "Show legs"}
ClientsideConvars["zs_hidehud"] = {Value = 0, ShouldSave = true, UserData = false, CanChange = true, Category = "hud", Description = "Hide HUD"}
ClientsideConvars["_zs_hidecrosshair"] = {Value = 0, ShouldSave = true, UserData = false, CanChange = true, Category = "hud", Description = "Disable crosshair"}
ClientsideConvars["zs_drawcrateoutline"] = {Value = 1, ShouldSave = true, UserData = false, CanChange = true, Category = "hud", Description = "Supply Crate outline"}
ClientsideConvars["zs_drawarrow"] = {Value = 1, ShouldSave = true, UserData = false, CanChange = true, Category = "hud", Description = "Draw arrow leading to Supply Crate"}
ClientsideConvars["zs_drawcolourmod"] = {Value = 1, ShouldSave = true, UserData = false, CanChange = true, Category = "hud", Description = "Colour mod"}
ClientsideConvars["zs_drawsharpeneffect"] = {Value = 1, ShouldSave = true, UserData = false, CanChange = true, Category = "hud", Description = "Sharpen effect as near Undead indicator"}


ClientsideConvars["_zs_autoredeem"] = {Value = 1, ShouldSave = true, UserData = true, CanChange = true, Category = "gmp", Description = "Automatic redeem"}
ClientsideConvars["_zs_humanspawn"] = {Value = 1, ShouldSave = true, UserData = true, CanChange = true, Category = "gmp", Description = "Spawn on Survivors when possible"}


-- finally get rid of readding shitload of code for single fucking convar
for convarname,args in pairs(ClientsideConvars) do
	if ConVarExists(convarname) then
		continue
	end
	
	CreateClientConVar(convarname, args.Value, args.ShouldSave, args.UserData)
end

CreateClientConVar("_zs_defaultsuit", "none", true, true)
CreateClientConVar("_zs_equippedhats", "none", true, true)

CreateClientConVar("_zs_hatpcolR", 255, true, true)
CreateClientConVar("_zs_hatpcolG", 255, true, true)
CreateClientConVar("_zs_hatpcolB", 255, true, true)

CreateConVar( "cl_playercolor", "0.24 0.34 0.41", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )
CreateConVar( "cl_weaponcolor", "0.30 1.80 2.10", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )

--Predicting spawn/death
local function PredictSpawn()
	for k,v in pairs(player.GetAll()) do
		if IsEntityValid(v) then
			if v:Deaths() == PREDICT_SPAWN then 
			     v.bSpawning = nil 
			     if v.bSpawned == nil then 
    			     timer.Simple(0.1, function() 
    			         if IsEntityValid(v) then 
    			             gamemode.Call("PlayerSpawn", v) 
    			         end 
    			     end)
    			     v.bSpawned = true 
    			end 
			elseif v:Deaths() == PREDICT_SPAWN_END then 
			    if v.bSpawning == nil then 
			        v.bSpawned = nil
					v.bSpawning = true 
			    end 
		    end
			
			--Predict health loss
			if v.LastHealth and v.LastHealth ~= v:Health() and v:Alive() then 
				local iAdd = v.LastHealth - v:Health()
				if iAdd > 0 then
					gamemode.Call("PlayerTakeDamage", v, nil, iAdd)
				end
			end
			v.LastHealth = v:Health()
		end
	end
end
--hook.Add("Think", "PredictSpawn", PredictSpawn)

-- Semi-predicted damage function
function GM:PlayerTakeDamage(pl, attacker, damage)
end

-- Redeem
function GM:OnPlayerRedeem(pl)
end

-- Called on first spawn
function GM:PlayerInitialSpawn(pl)
end

-- Called on player spawn
function GM:PlayerSpawn(pl)	
	--Play player spawn sound
	if pl == MySelf then
		pl:PlaySpawnMusic()
	end
	
	if not pl.InitialSpawn then
		gamemode.Call("PlayerInitialSpawn", pl)
		pl.InitialSpawn = true
	end
	
	Debug("[SPAWN] "..tostring ( pl ).." spawned")
end

-- Called on player death
function GM:DoPlayerDeath( pl, attacker, inflictor, assist )
	if not pl.InitialDeath then
		gamemode.Call ( "DoPlayerFirstDeath", pl, attacker )
		pl.InitialDeath = true
	end
	Debug("[DEATH] "..tostring(pl).." died killed by ".. tostring(attacker) .." with assist/or not from "..tostring(assist))
end

-- Called on first death
function GM:DoPlayerFirstDeath(pl, attacker)
end

--[==[----------------------------------------------------
      Initialize some variables for supply crates
------------------------------------------------------]==]
local function InitializeCrateVars()
	-- Precache the gib models
	for i = 1, 9 do
		util.PrecacheModel("models/items/item_item_crate_chunk0"..i..".mdl")
	end
	
	-- Precache main model
	util.PrecacheModel("models/items/item_item_crate.mdl")
end
hook.Add("Initialize", "InitVars", InitializeCrateVars)

local boss = {}
boss.duration = 0
boss.endTime = 0

function GM:GetBossEndTime()
	return boss.endTime or 0
end

function GM:SetBoss(value,isInsane,duration)
	if LASTHUMAN or ENDROUND then
		return
	end
	
	--print("SetBoss: ".. tostring(value))

	-- Set client unlife correspondenly
	BOSSACTIVE = value
	
	-- Stop sounds and delay the unlife song (Automtically loops)
	-- Disable unlife music for a while
	if BOSSACTIVE then
	
		--Play music
			--timer.Simple(0.3, function()
			--playBossMusic()
		--end)
			--end
	
		boss.duration = duration
		boss.endTime = CurTime() + duration

		--Alert the local player
		--if GAMEMODE:IsBossAlive() then
		timer.Simple(0.5, function()
			local bossPl = GAMEMODE:GetBossZombie()
			--print("bossPl: ".. bossPl)
			if bossPl and IsValid(bossPl) then		
				--surface.PlaySound(Sound("ambient/creatures/town_zombie_call1.wav"))						
				GAMEMODE:Add3DMessage(140, bossPl:Name() .." has risen as ".. ZombieClasses[bossPl:GetZombieClass()].Name, Color(255,255,255,220), "ssNewAmmoFont6.5")
			end
		end)
		
	
		Debug("[CLIENT] Boss has risen")
	else
		--
		--timer.Destroy("LoopBossMusic") --Duby: This loops the boss music
	
		--Stop music
		--RunConsoleCommand("stopsound")
		
		Debug("[CLIENT] Boss ran off")
	end
end

net.Receive("StartBoss", function(len)
	local isInsane = tobool(net.ReadBit())
	local bossDuration = net.ReadFloat()
	GAMEMODE:SetBoss(true,isInsane,bossDuration)
end)

net.Receive("unlife", function(len)
	local unlife = tobool(net.ReadBit())

	if unlife and not LASTHUMAN then
		playDragulaMusic()
	end
end)


net.Receive("StopBoss", function(len)
	GAMEMODE:SetBoss(false)
--	RunConsoleCommand("sv_alltalk", "0")
end)

--[==[---------------------------------------------------------
       Used to receive player and chat title index
---------------------------------------------------------]==]
local function ReceiveChatTitles ( um )
	if not IsValid ( MySelf ) then
		return
	end

	local tbStart, tbEnd = um:ReadShort(), um:ReadShort()
	for i = tbStart, tbEnd do
		local pl = um:ReadEntity()
		if IsValid ( pl ) then
			local HumanIndex, ZombieIndex = um:ReadShort(), um:ReadShort()
		
			-- Regular players
			pl.HumanChatTitle = GAMEMODE.ChatTitles.Human[HumanIndex]
			pl.ZombieChatTitle = GAMEMODE.ChatTitles.Undead[ZombieIndex]
			
			-- Admins
			if pl:IsAdmin() or pl:IsSuperAdmin() then
				pl.HumanChatTitle, pl.ZombieChatTitle = GAMEMODE.ChatTitles.Admin[HumanIndex], GAMEMODE.ChatTitles.Admin[HumanIndex] 
			end
		end
	end
	
	Debug ( "[CLIENT] Succesfully recieved chat titles." )
end
usermessage.Hook("ReceiveChatTitles", ReceiveChatTitles)

--[==[---------------------------------------------------------
        Add titles before the player's name
---------------------------------------------------------]==]
local function ManageChatTitles ( pl, Text, TeamOnly, PlayerIsDead )
	local tab = {}
		
	if ( PlayerIsDead ) then
		table.insert( tab, Color( 255, 30, 40 ) )
		table.insert( tab, "*DEAD* " )
	end
 
	if ( TeamOnly ) then
		table.insert( tab, Color( 30, 160, 40 ) )
		table.insert( tab, "(TEAM) " )
	end
	
	if pl:IsSuperAdmin() then
		table.insert( tab, Color( 100, 255, 200 ) )
		table.insert( tab, "(ZS) " )		
	elseif pl:IsAdmin() then
		table.insert( tab, Color( 100, 180, 140 ) )
		table.insert( tab, "(ZS) " )		
	end
	
	--PrintTable(pl.DataTable["Achievements"])

	--if pl.MasterZS then
	--	table.insert( tab, Color( 255, 235, 40 ) )
	--	table.insert( tab, "(:V :V :V) " )		
	--end


	
	if IsValid(pl) then
		local ColorToApply = Color ( 221, 219, 26 )

		if  pl:IsSuperAdmin() then
			ColorToApply = Color(0, 0, 225)	
		elseif pl:IsAdmin() then
			ColorToApply = Color ( 255,0,0 )
		end
		
		if pl.Title ~= nil and pl.Title ~= "" then
			table.insert( tab, ColorToApply )
			table.insert( tab, "["..pl.Title.."] " )	
		end
	end
	
	if ( IsValid( pl ) ) then
		table.insert( tab, pl )
	else
		table.insert( tab, "Unloaded" )
	end
 
	table.insert( tab, Color( 255, 255, 255 ) )
	table.insert( tab, ": "..Text )
 
	chat.AddText( unpack(tab) )
 
	return true
end
hook.Add ( "OnPlayerChat", "ManageChatTitle", ManageChatTitles )
-- TODO: Use spawn prediction instead
local function ChangeHullSize(um)
	if not IsValid ( MySelf ) then return end
	local pl = um:ReadEntity()
	local vecmin = um:ReadVector()
	local vecmax = um:ReadVector()
	if IsValid(pl) then
		pl:SetHull(vecmin,vecmax)
	end
end
usermessage.Hook ( "ChangeHullSize", ChangeHullSize )

local function ChangeOffset(um)
	if not IsValid ( MySelf ) then return end
	local pl = um:ReadEntity()
	local vec1 = um:ReadVector()
	local vec2 = um:ReadVector()
	if IsValid(pl) then
		pl:SetViewOffset(vec1)
		pl:SetViewOffsetDucked(vec2)
	end
end
usermessage.Hook ( "ChangeOffset", ChangeOffset )

--Better Messages for vote commands--------

local DrawVote = false
local distapproach = 0
local vwide, vtall = ScaleW(232), ScaleH(156)
local xpos = -vwide
local whiner, target,votetype, countyes, countno, timeleft = "", "", "", 0, 0, 0

-- Called when vote begins
local function OpenVoteWindow(um)
if not IsValid ( MySelf ) then return end

	target = um:ReadEntity():Name()
	votetype = um:ReadString()
	timeleft = CurTime() + 20
	DrawVote = true
	
	surface.PlaySound("buttons/button4.wav")
	
end
usermessage.Hook ( "OpenVoteWindow", OpenVoteWindow )

-- Called when someone votes yes or no
local function AddVote(um)
if not IsValid ( MySelf ) then return end

local vote = um:ReadString()

	if vote == "yes" then
		countyes = countyes + 1
	else
		countno = countno + 1
	end
	
	surface.PlaySound("UI/hint.wav")
	
end
usermessage.Hook ( "AddVote", AddVote )

-- Called at the end of vote
local function CloseVoteWindow()
if not IsValid ( MySelf ) then return end

	target,votetype,countyes,countno, timeleft = "", "", 0, 0, 0
	DrawVote = false
	
	surface.PlaySound("buttons/button14.wav")
end
usermessage.Hook ( "CloseVoteWindow", CloseVoteWindow )

-- Draw the vote message with results
function DrawVoteMessage()
	if not IsValid ( MySelf ) or ENDROUND then
		return
	end

	if DrawVote then distapproach = -1 else distapproach = -vwide end

	xpos = math.Clamp(math.Approach(xpos,distapproach, FrameTime()*300),-vwide,-1)

	local ypos = ScrH()/2-120

	if xpos == -vwide then return end
	
	DrawBlackBox(xpos, ypos, vwide, vtall)
	
	ypos = ypos+4
	
	draw.SimpleTextOutlined(""..string.upper(votetype).." player "..target.."?" , "ArialBoldFive", xpos + vwide/2 , ypos, Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
	ypos = ypos +26
	
	draw.SimpleTextOutlined("(Press F1 for YES or F2 for NO)" , "ArialBoldFive", xpos + vwide/2 , ypos, Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
	ypos = ypos +31
	
	draw.SimpleTextOutlined("YES" , "ArialBoldTwelve", xpos + vwide/4 , ypos, Color (0,255,0,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
	draw.SimpleTextOutlined("NO" , "ArialBoldTwelve", xpos + 3*vwide/4 , ypos, Color (255,0,0,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
	ypos = ypos +27
	
	draw.SimpleTextOutlined(countyes , "ArialBoldTwelve", xpos + vwide/4 , ypos, Color (0,255,0,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
	draw.SimpleTextOutlined(countno , "ArialBoldTwelve", xpos + 3*vwide/4 , ypos, Color (255,0,0,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
	ypos = ypos +27
	
	draw.SimpleTextOutlined("(Time left: "..math.Clamp(math.Round(timeleft - CurTime()),0,20)..")" , "ArialBoldFive", xpos + vwide/2 , ypos, Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
	
	
end
hook.Add( "HUDPaint", "DrawVoteMessage", DrawVoteMessage )


--------------------------------------------------------

--Usermessage for custom messages by Overv------

net.Receive( "CustomChatAdd", function( len )
	
	local argc = net.ReadDouble( )
	local args = { }
	
	for i = 1, argc / 2, 1 do
		table.insert( args, Color( net.ReadDouble( ), net.ReadDouble( ), net.ReadDouble( ), net.ReadDouble( ) ) )
		table.insert( args, net.ReadString( ) )
	end
         
	chat.AddText( unpack( args ) )


end)

local function CustomChatAdd(um)

	local argc = um:ReadShort( )
	local args = { }
	
	for i = 1, argc / 2, 1 do
		table.insert( args, Color( um:ReadShort( ), um:ReadShort( ), um:ReadShort( ), um:ReadShort( ) ) )
		table.insert( args, um:ReadString( ) )
	end
         
	chat.AddText( unpack( args ) )

end
usermessage.Hook( "CustomChatAdd",CustomChatAdd)

----------------------------------------------------------------

local function UpdateObjStage(um)

	GAMEMODE:SetObjStage(um:ReadShort())

end
usermessage.Hook("UpdateObjStage",UpdateObjStage)
