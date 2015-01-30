require( "glsock2" )

irc = {}

include( "sv_irc_utils.lua" )
include( "sv_irc_handles.lua" )

function irc:Connect( host, port )
	self.Socket = GLSock( GLSOCK_TYPE_TCP ) 
	return self.Socket:Connect( host or self.Host, port or 6667, self.OnConnectCallback )
end

function irc:IsConnected()
	return self.Connected and self.Socket ~= nil
end

---
-- Returns if a channel string is a valid channel name
-- 
function irc:IsChannel( channel )
	return channel:match( "^#(.*)" )
end

---
-- Sets the nick of the bot
-- @param string name ASCII encoded nickname without spaces or protocol punctuation (e.g. : etc)
-- 
function irc:SetNick( name )
	irc:Raw( "NICK "..name )
end

---
-- Starts registration process by setting both nick and registering
-- @usage irc:Register( "DuckMaster" ); to be used after connecting to the server
-- @param string name ASCII encoded nickname without spaces or protocol punctuation (e.g. : etc)
-- 
function irc:Register( name )
	irc:SetNick( name )
	irc:Raw( "USER "..name.." 0 0 :"..name )
end

---
-- Send a raw command to the server
-- 
function irc:Raw( arg, callback )
	local buffer = GLSockBuffer()
	buffer:Write( arg.."\r\n" )

	--Check if socket isn't available. Most likely because we have IRC disabled.
	if not self.Socket then
		return
	end

	-- Send raw
	self.Socket:Send( buffer, callback or self.OnCallback )
end

---
-- Attemps to join an array of channels or single channel
-- @usage irc:Join( { "#mrgreen" } ) or irc:Join( "#mrgreen" )
-- 
function irc:Join( channels )
	if ( type( channels ) == "table" ) then
		self:Raw( "JOIN "..table.concat( channels, "," ) )
	else
		self:Raw( "JOIN "..channels )
	end
end

---
-- Send either a public or a private message
-- @param string channel Channel name or name of the user 
-- 
function irc:Say( message, channel )
	self:Raw( "PRIVMSG "..channel.." "..message )
end

---
-- Disconnect from the current server and destroy socket
-- @usage irc:Disconnect( reason ) or irc:Disconnect()
-- 
function irc:Disconnect( arg )
	arg = arg or "User disconnected"
	self:Raw( "QUIT :"..arg )
	
	-- Destroy socket
	if ( self.Socket:Cancel() and self.Socket:Close() ) then
		self.Socket:Destroy()
		self.Socket = nil
	end
end