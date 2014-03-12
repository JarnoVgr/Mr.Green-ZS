-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Add our needed files
AddCSLuaFile ( "cl_friends.lua" )

ENABLE_FRIENDS_SV = false
if not ENABLE_FRIENDS_SV then return end

-- Function table
friends = {}

-- Materials we need
resource.AddFile ( "materials/zombiesurvival/hud/hud_friend_splash.vtf" )
resource.AddFile ( "materials/zombiesurvival/hud/hud_friend_splash.vmt" )
resource.AddFile ( "materials/zombiesurvival/hud/second_splash.vtf" )
resource.AddFile ( "materials/zombiesurvival/hud/second_splash.vmt" )

-- Has friend check function
function friends.HasFriend ( pl )
	local DataTable = pl:GetDataTable()
	if not DataTable then return false end
	
	-- No friend entry in his file
	if not DataTable["friend"] then return false end
	
	-- Friend entry is empty
	if DataTable["friend"] == "" then return false end
	
	return true
end

-- Get friend
function friends.GetFriend ( pl )
	if not friends.HasFriend ( pl ) then return end
	return pl.Friend
end

function friends.IsOnlineFriend ( pl )
	return IsEntityValid ( pl.Friend )
end


-- Called on friend disconnect
function friends.OnDisconnect ( pl )

	-- Disable query status
	if pl.InQuery then pl.InQuery = false end
	
	-- Notify friend about exiting game
	if friends.IsOnlineFriend ( pl ) then 
		local Friend = friends.GetFriend ( pl )
		Friend:ChatPrint ( "[FRIENDS] "..tostring ( pl:Name() ).." is now OFFLINE!" )
	end
end
hook.Add ( "PlayerDisconnected", "FriendDisconnect", friends.OnDisconnect )

-- Called on friend connect
function friends.OnJoinFriend ( pl )
	timer.Simple ( 0.1, function ( )
		if not IsEntityValid ( pl ) then return end
		
		print ( "---"..tostring ( pl ).." joined game. He has friend "..tostring ( pl.Friend ) )
		
		if not friends.IsOnlineFriend ( pl ) then return end
		
		-- Get friend
		local Friend = friends.GetFriend( pl )
		Friend.Friend = pl
		
		-- Update player with his friend (if he has one)
		umsg.Start ( "friends.ConfirmFriends", Friend )
			umsg.Short ( pl:EntIndex() )
		umsg.End()
		
		-- Update friend with his friend (if he has one)
		umsg.Start ( "friends.ConfirmFriends", pl )
			umsg.Short ( Friend:EntIndex() )
		umsg.End()
		
		-- Notice his friend
		Friend:ChatPrint ( "[FRIENDS] "..tostring ( pl:Name() ).." is now ONLINE!" )
	end )
end
hook.Add ( "PlayerReady", "ReadyFriend", friends.OnJoinFriend )

-- Can invite player
function friends.CanInvitePlayer ( Inviter, Invited )
	if not IsEntityValid ( Inviter ) and not IsEntityValid ( Invited ) then return 0 end
	
	-- Already has friend
	if friends.HasFriend ( Inviter ) or friends.HasFriend ( Invited ) then return 0 end
	
	-- Only humans or zombies
	if Inviter:IsSpectator() or Invited:IsSpectator() then return -1 end
	
	-- In query
	if Inviter.InQuery or Invited.InQuery then return -1 end
	
	-- Fighting zombos lol
	if Invited:IsHuman() then
		local iZombos = Invited:GetNearUndead(300)
		if iZombos > 0 then return -1 end
	end
	
	return 1
end

-- Invites a player
function friends.InvitePlayer ( Inviter, Invited )
	
	-- Query status
	Inviter.InQuery, Invited.InQuery = true, true
	
	-- Notification
	Inviter:ChatPrint ( "[FRIENDS] An invitation has been sent to "..tostring ( Invited:Name() ).."!" )
	
	-- Send message to invited with the inviter
	umsg.Start ( "friends.GetInvitation", Invited )
		umsg.Short ( Inviter:EntIndex() )
	umsg.End()
end


-- Check out the chat for commands
function friends.ChatFriends ( pl, sText, bTeam )
	if not pl:IsHuman() and not pl:IsZombie() then return end
	
	-- Check for command
	if string.sub ( sText, 1, 7 ) == "!friend" then 
	
		-- Comand doens't have paramter
		local sExplode = string.Explode ( " ", sText )
		if not sExplode[2] then pl:ChatPrint ( "[FRIENDS] The command structure is: !friend < player name >" ) return "" end
		
		-- We got a second argument
		local m_Player = GetPlayerByName ( sExplode[2] )
		if not IsEntityValid ( m_Player ) then if m_Player == - 1 then pl:ChatPrint ( "[FRIENDS] The player you are trying to add has not been found!" ) elseif m_Player == -2 then pl:ChatPrint ( "[FRIENDS] Multiple players with similar names have been found. Refine your search!" ) end return "" end
		
		-- You can't invite yourself
		if m_Player == pl then pl:ChatPrint ( "[FRIENDS] You can't invite yourself!" ) return "" end
		
		-- Invite the player
		local iCanInvite = friends.CanInvitePlayer ( pl, m_Player )
		if iCanInvite == 1 then friends.InvitePlayer ( pl, m_Player ) elseif iCanInvite == -1 then pl:ChatPrint ( "[FRIENDS] The player you are trying to invite is rather busy! Try later!" ) else pl:ChatPrint ( "[FRIENDS] The player you are trying to invite isn't online or already has a friend!" ) end
			
		return ""
	end
	
	-- Check for friend remove command
	if string.sub ( sText, 1, 13 ) == "!removefriend" then
		
	end
end
hook.Add ( "PlayerSay", "ChatFriend", friends.ChatFriends )


-- Friend accept callback
function friends.CallbackAdd ( pl, cmd, args )
	if not IsEntityValid ( pl ) or not args[1] then return end
	
	-- Not in query
	if not pl.InQuery then return end
	
	-- Get 
	local Accepted = Entity ( tonumber ( args[1] ) )
	if not IsEntityValid ( Accepted ) then return end
	
	-- Player already got friend
	if friends.IsOnlineFriend ( pl ) or friends.IsOnlineFriend ( Accepted ) then return end
	
	-- Disable query status
	Accepted.InQuery, pl.InQuery = false, false
	
	-- Make them friends
	pl.Friend = Accepted
	Accepted.Friend = pl	
	
	-- Save friend in text file
	pl.DataTable["friend"] = tostring ( pl.Friend:SteamID() ) or ""
	Accepted.DataTable["friend"] = tostring ( Accepted.Friend:SteamID() ) or ""
	
	-- Send both players a usermessage confirming they are friends
	umsg.Start ( "friends.ConfirmFriends", Accepted )
		umsg.Short ( pl:EntIndex() )
	umsg.End()
	
	umsg.Start ( "friends.ConfirmFriends", pl )
		umsg.Short ( Accepted:EntIndex() )
	umsg.End()
end
concommand.Add ( "friends_add", friends.CallbackAdd )


-- Friend deny callback
function friends.CallbackDeny ( pl, cmd, args )
	if not IsEntityValid ( pl ) or not args[1] then return end
	
	-- Not in query
	if not pl.InQuery then return end
	
	-- Get 
	local Denied = Entity ( tonumber ( args[1] ) )
	if not IsEntityValid ( Denied ) then return end
	
	-- Disable query status
	Denied.InQuery, pl.InQuery = false, false
		
	-- Notification
	Denied:ChatPrint ( "[FRIENDS] "..tostring ( pl:Name() ).." has denied your invitation!" ) 
end
concommand.Add ( "friends_deny", friends.CallbackDeny )