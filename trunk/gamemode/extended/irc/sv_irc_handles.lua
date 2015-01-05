
irc.Handles = {}

---
-- Handle the PING command response telling the server we're alive
-- 
irc.Handles["PING"] = function( response )
	irc:Raw( "PONG" )
end

---
-- Handle the ERROR command
-- 
irc.Handles["ERROR"] = function( response )
	local message = response.Trailing
	
	if ( message:lower():find( "registration timeout" ) ) then
		hook.Call( "irc.OnRegisterTimeout", nil, message, response )
	end
	
	hook.Call( "irc.OnError", nil, message, response )
end

---
-- Handle the ERR_NICKNAMEINUSE command
-- @usage Triggered after trying to change nickname to one already taken
-- 
irc.Handles["433"] = function( response )
	local message, nick = response.Trailing, response.Parameters[2]
	hook.Call( "irc.OnNickTaken", nil, nick, message )
end

---
-- Handle the ERR_ERRONEUSNICKNAME command
-- @usage Triggered after trying to change nickname to one already taken
-- 
irc.Handles["432"] = function( response )
	local message, nick = response.Trailing, response.Parameters[2]
	hook.Call( "irc.OnNickError", nil, nick, message )
end

---
-- Handle the RPL_WELCOME command
-- @usage Triggered after the client registration
-- 
irc.Handles["001"] = function( response )
	hook.Call( "irc.OnWelcome", nil, response )
end

---
-- Handle the JOIN command
-- @usage Triggered when self or another user joins a channel
-- 
irc.Handles["JOIN"] = function( response )
	local channel, user = response.Trailing, irc:ParsePrefix( response.Prefix )
	hook.Call( "irc.OnUserJoin", nil, user, channel )
end

---
-- Handle the PRIVMSG command
-- @usage Triggered when somebody says something in a public channel or private message to self
-- 
irc.Handles["PRIVMSG"] = function( response )
	local message, user = response.Trailing, irc:ParsePrefix( response.Prefix )
	local destination = response.Parameters[1]
	
	-- Access modifiers
	if ( irc:IsChannel( destination ) ) then
		hook.Call( "irc.OnPublicMessage", nil, message, user, destination )
	else
		hook.Call( "irc.OnPrivateMessage", nil, message, user, destination )
	end
end

---
-- Handle the PART command
-- @usage Triggered when a user or self parts a channel
-- 
irc.Handles["PART"] = function( response )
	local user, channel = irc:ParsePrefix( response.Prefix ), response.Parameters[1]
	hook.Call( "irc.OnUserPart", nil, user, channel )
end

---
-- Handle the QUIT command
-- @usage Triggered only when a user quits, not including self
-- 
irc.Handles["QUIT"] = function( response )
	local user, reason = irc:ParsePrefix( response.Prefix ), response.Trailing
	hook.Call( "irc.OnUserQuit", nil, user, reason )
end