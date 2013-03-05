-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local table = table
local math = math
local pairs = pairs
local team = team
local umsg = umsg

util.AddNetworkString( "SendTitles" )

--[==[---------------------------------------------------------
          Used to update titles on clientside
---------------------------------------------------------]==]
function GM:SendTitle ( from, to )
	
	local send = {}
	
	for _, pl in ipairs(from) do
		table.insert(send,{pl:EntIndex(),pl.Title or ""})
	end
	
	net.Start("SendTitles")
		net.WriteTable(send)
	net.Send(to)

	--[==[local tab = {}
	
	if #from > 5 then
		for k = 1, math.ceil( #from/5 ) do
			tab[k] = {}
			for nr = 1,5 do
				if #from >= 5 * ( k - 1 ) + nr then
					tab[k][nr] = from [ 5 * ( k - 1 ) + nr ]
				else 
					break
				end
			end
		end
	else
		tab[1] = table.Copy( from )
	end
	
	for key, subt in pairs( tab ) do
		umsg.Start( "SendTitles",to )
			umsg.Short( #subt )
			for k, v in pairs( subt ) do
				umsg.Entity( v )
				umsg.String( v.Title or "" )
			end	
		umsg.End()
	end]==]
end