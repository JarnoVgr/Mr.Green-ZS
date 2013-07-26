
---
-- Callback for irc:Connect()
-- 
function irc.OnConnectCallback( sock, error )
	if ( error == GLSOCK_ERROR_SUCCESS ) then
		irc.Connected = true
		hook.Call( "irc.OnConnect" )
	else
		hook.Call( "irc.OnConnectError", nil, error )
	end
end

---
-- Callback for socket transmiting
-- Calls irc.OnCallbackRead to read the response
-- 
function irc.OnCallback( sock, length, error )
	if ( error == GLSOCK_ERROR_SUCCESS ) then
		sock:Read( 4064, irc.OnCallbackRead ) 
	else
		hook.Call( "irc.OnSocketError", nil, error )
	end
end

---
-- Callback for socket reading
-- Keeps reading afterward
-- 
function irc.OnCallbackRead( sock, buffer, error )
	if ( error == GLSOCK_ERROR_SUCCESS ) then
		local count, string
		if ( buffer ) then
			count, string = buffer:Read( buffer:Size() ) 
			if ( #string > 0 ) then
				local responses = string.Explode( "\r\n", string )
				
				for k, text in ipairs( responses ) do
					if ( #text > 0 ) then
						local response = irc:Parse( text )
--						PrintTable( response )
--						print( "\n")
						
						-- Handle available responses
						if ( irc.Handles[response.Command] ) then
							irc.Handles[response.Command]( response )
						end
					end
				end
			end
		end		
		
		-- Keep reading
		sock:Read( 4064, irc.OnCallbackRead ) 
	end
end

---
-- Parse an IRC response message into pieces: prefix, command, parameters, trailing
-- 
function irc:Parse( str )
	local prefix, trailing = str:match( "^:([^ ]*) " ), str:match( " :(.*)$" )
	local command, parameters = str:match( ( prefix and "%s" or "^" ).."(%w+)%s?([^:]*)" )
	
	local response = {
		Prefix = prefix,
		Command = command
	}

	-- Check trailing and trim
	if ( trailing and #trailing > 0 ) then
		response.Trailing = string.Trim( trailing )
	end
	
	-- Check parameters and split
	if ( parameters and #parameters > 0 ) then
		response.Parameters = string.Explode( "\32", string.Trim( parameters ) )
	end	

	return response
end

---
-- Parse an IRC nick!host@ip type message
-- Incomplete
-- 
function irc:ParsePrefix( prefix )
	local user = prefix:match( "^([^!]*)" )
	
	return {
		Name = user
	}
end
