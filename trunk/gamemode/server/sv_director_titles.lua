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

end