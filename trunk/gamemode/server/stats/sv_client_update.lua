-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local table = table
local math = math
local string = string
local util = util
local pairs = pairs
local team = team
local umsg = umsg

util.AddNetworkString( "SetAchievementsData" )

function stats.SendAchievementsData( from, to )
	if IsValid( to ) and IsValid( from ) and not from:IsBot() then
		
		net.Start("SetAchievementsData")
			net.WriteEntity(from)
			net.WriteTable(from.DataTable["Achievements"])
		net.Send(to)
	
		--[==[umsg.Start( "SetAchievementsData", to )
			umsg.Entity( from )
			for k, v in ipairs( achievementDesc ) do
				umsg.Bool( from.DataTable["Achievements"][k] )
			end
		umsg.End()]==]
	end
end

util.AddNetworkString( "SetStatsData" )

function stats.SendStatsData( from, to )
	if IsValid( to ) and IsValid( from ) and not from:IsBot() then
		if from.DataTable then
			for k,v in pairs( from.DataTable ) do
				if type( v ) ~= "table" then
					
					net.Start("SetStatsData")
						net.WriteEntity(from)
						net.WriteString(tostring( k ))
						net.WriteString(tostring( v ))
					net.Send(to)
					--[==[umsg.Start( "SetStatsData", to )
						umsg.Entity( from )
						umsg.String( tostring( k ) )
						umsg.String( tostring( v ) )
					umsg.End()]==]
				end
			end
		end
	end
end

function stats.SendRecordsData( from, to )

	-- Set achievement data for player
	stats.SendAchievementsData( from, to )
	
	-- TODO RECORD DATA
	stats.SendStatsData( from, to )
end

util.AddNetworkString( "SendClassData" )

function stats.SendClassDatastream( to )
	if IsValid( to ) and not to:IsBot() then
		if ( to.DataTable ) and ( to.DataTable["ClassData"] ) then
			
			to:ValidateXP()

			net.Start("SendClassData")
				net.WriteTable(to.DataTable["ClassData"])
			net.Send(to)
			
			--[==[umsg.Start( "SendClassData", to )
				for k, v in pairs( classData ) do
					for _,keys in pairs ( v ) do
						local Value = 0
						if ( to.DataTable["ClassData"][k] ) then
							Value = to.DataTable["ClassData"][k][_] or 0
						end
						umsg.Long( Value )
					end
				end
			umsg.End()]==]
		end
	end
end

util.AddNetworkString( "SetShopData" )

function stats.SendShopData( from, to )
	if IsValid(to) and IsValid( from ) then
		if not to:IsBot() and not from:IsBot() then	
			net.Start("SetShopData")
				net.WriteEntity(from)
				net.WriteTable(from.DataTable["ShopItems"])
			net.Send(to)
		end
	end
end

util.AddNetworkString( "SendUpgradeNumbers" )

function GM:SendUpgradeNumber ( to )
	if IsValid( to ) then
		net.Start("SendUpgradeNumbers")
			net.WriteDouble(to.TotalUpgrades or 0)
		net.Broadcast()
	
		--[==[umsg.Start ( "SendUpgradeNumbers", to )
			umsg.Short ( to.TotalUpgrades or 0 )
		umsg.End()]==]
	end
end