-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

ENABLE_FRIENDS_CL = false
if not ENABLE_FRIENDS_CL then return end

-- Function table
local friends = {}

-- Constants
COLOR_HUD_HEALTHY = Color ( 20,151,20,255 )
COLOR_HUD_SCRATCHED = Color( 35, 130, 0, 255 )
COLOR_HUD_HURT = Color( 160, 160, 0, 255 )
COLOR_HUD_CRITICAL = Color( 220, 0, 0, 255 )

-- Our friends splash background
local matFirst = surface.GetTextureID ( "zombiesurvival/hud/hud_friend_splash" )
local matSecond = surface.GetTextureID ( "zombiesurvival/hud/second_splash" )

friends.Mats = { surface.GetTextureID ( "zombiesurvival/hud/hud_friend_splash" ), surface.GetTextureID ( "zombiesurvival/hud/second_splash" ) } 

function friends.InitFonts()
	
	-- Initialize fonts needed
	surface.CreateFont( "Arial", ScreenScale(8), 700, true, false, "FriendsArialThirteen" )
end
hook.Add ( "Initialize", "InitFriendsFont", friends.InitFonts() )

function friends.DrawFriend( xPos, yPos, mFriend, iNr ) 
	if not IsEntityValid ( MySelf ) or ENDROUND then return end
	
	-- Hud vars not loaded
	if not hud.hHealthSplash then return end
	
	-- No friend
	if not friends.HasFriend ( MySelf ) then return end
	local mFriend = friends.GetFriend ( MySelf ) 
	
	-- Conditions
	if not mFriend:IsHuman() or not mFriend:Alive() or not MySelf:Alive() or not MySelf:IsHuman() then return end
	
	-- Friend health
	local fHealth, fMaxHealth = mFriend:Health(), mFriend:GetMaximumHealth()
	local iPercentage = math.Clamp ( fHealth / fMaxHealth, 0, 1 )
	
	-- Color of healthbar
	local colHealthBar = COLOR_HUD_HEALTHY
	if 0.8 < iPercentage then colHealthBar = COLOR_HUD_HEALTHY elseif 0.6 < iPercentage then colHealthBar = COLOR_HUD_SCRATCHED elseif 0.3 < iPercentage then colHealthBar = COLOR_HUD_HURT else colHealthBar = COLOR_HUD_CRITICAL end
	
	-- Position vals
	local wSplash, hSplash = xPos, yPos
	local wHealthBar, hHealtHBar = wSplash - ScaleW(2), hSplash - ScaleH(5) 
	
	-- Draw the info material
	surface.SetDrawColor ( 147,10,10,255 )
	surface.SetTexture ( friends.Mats[iNr] )
	surface.DrawTexturedRectRotated( wSplash, hSplash, ScaleW(230), ScaleW(225), 0 )
	
	-- Draw health bar outbox
	surface.SetDrawColor ( Color ( 1,1,1,170 ) )
	surface.DrawRect ( wHealthBar - ( ScaleW(80) / 2 ), hHealtHBar - ( ScaleW(14) / 2 ), ScaleW(80), ScaleW(14) )
	
	-- Draw the backbox of health bar
	surface.SetDrawColor ( 74,87,70,255 )
	surface.DrawRect ( wHealthBar + ScaleW(4) - ( ScaleW(80) / 2 ), hHealtHBar + ScaleW(4) - ( ScaleW(14) / 2 ), ScaleW(80) - ( 2 * ScaleW(4) ), ScaleW(14) - ( 2 * ScaleW(4) ) )

	-- Draw the health bar
	surface.SetDrawColor ( colHealthBar )
	surface.DrawRect ( wHealthBar + ScaleW(4) - ( ScaleW(80) / 2 ), hHealtHBar + ScaleW(4) - ( ScaleW(14) / 2 ), ( ScaleW(80) * iPercentage ) - ( 2 * ScaleW(4) ), ScaleW(14) - ( 2 * ScaleW(4) ) )

	-- Draw friend name
	local sName, bLimited = string.Limit ( mFriend:Name(), "FriendsArialThirteen", ScaleW(80) )
	if bLimited then sName = sName..".." end
	draw.SimpleText ( tostring ( sName ), "FriendsArialThirteen", wHealthBar, hSplash + ScaleH(20), Color ( 210,210,210,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

-- Draw all your friends
function friends.DrawAll()
	if not IsEntityValid ( MySelf ) then return end
	
	-- Hud module not loaded
	if not hud or not hud.wXPSize then return end
	
	-- Friends
	local tbPos = { 1.6, 2.3, 2.6 }
	for i = 1, 2 do
		friends.DrawFriend( hud.wXPBar + ( hud.wXPSize * tbPos[i] ) , hud.hXPBar + ( hud.hXPSize * 2 ), MySelf, i )
	end
end
hook.Add ( "HUDPaint", "DrawAllFriends", friends.DrawAll )

-- Has friend check function
function friends.HasFriend ( pl )
	return IsEntityValid ( MySelf )
end

-- Get friend
function friends.GetFriend ( pl )
	if not friends.HasFriend ( pl ) then return end
	return MySelf
end

-- Confirm friends
function friends.ConfirmFriends( um )
	if not IsEntityValid ( MySelf ) then return end
	
	-- Get our friend
	local mFriend = Entity( um:ReadShort() )
	if not IsEntityValid ( mFriend ) then return end
	
	-- Status
	mFriend.Friend = MySelf
	MySelf.Friend = mFriend
end
usermessage.Hook ( "friends.ConfirmFriends", friends.ConfirmFriends )

-- Notification usermessage
function friends.GetInvitation( um )
	if not IsEntityValid ( MySelf ) then return end

	-- Get the inviter
	local Inviter = Entity ( um:ReadShort() )
	if not IsEntityValid ( Inviter ) then return end
	
	-- Have a text box appear
	gui.EnableScreenClicker ( true )
	Derma_Query( "[FRIENDS] Player "..tostring ( Inviter ).." has invited you to become friends. Accept?", "Friends Invitation","Yes", function() RunConsoleCommand ( "friends_add", tostring ( Inviter:EntIndex() ) ) gui.EnableScreenClicker ( false ) end, "No", function() RunConsoleCommand ( "friends_deny", tostring ( Inviter:EntIndex() ) ) gui.EnableScreenClicker ( false ) end )
end
usermessage.Hook ( "friends.GetInvitation", friends.GetInvitation )
