-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information


--[==[---------------------------------------------------------
   Read the mapcycle.txt and build the cycle
---------------------------------------------------------]==]
MapCycle = {}
function GM:SetMapList()	
	local filename = "zombiesurvival/zsmapcycle.txt"
	
	if file.Exists(filename,"DATA") then
		self:LoadMapList()
	else
		self:MakeBlankMapList()
	end

	--Sort by filename
	table.SortByMember(MapCycle, "Map")
	
	self:MapProperties()
end

--[==[-----------------------------------------------------
        Strips the extension of a map file
-----------------------------------------------------]==]
function NameNormalize ( strMap )
	return string.gsub( strMap, ".bsp", "" ) or ""
end

--[==[-----------------------------------------------------
        Returns if a map is for zombie survival
-----------------------------------------------------]==]
function IsZombieMap(strMap)
	if strMap == nil then
		return
	end
	local bIsZombieMap = false
	
	-- First too letters are 'zs'
	if string.sub ( strMap, 1, 2 ) == "zs" or string.sub ( strMap, 1, 2 ) == "zm" or string.sub ( strMap, 1, 2 ) == "cs" then bIsZombieMap = true end
	
	return bIsZombieMap
end

--[==[---------------------------------------------------------
   Return first 6 maps in front of the current
---------------------------------------------------------]==]
VoteMaps = {}
function GM:GetVoteMaps()
	local VoteMaps = {}

	--Seed
	--math.randomseed(os.time())

	local randMapCycle = table.FullCopy(MapCycle)
	--randMapCycle = table.Shuffle(randMapCycle)
	
	--Get 6 random maps from the cycle
	--[[for i=1,6 do
		local map = randMapCycle[i]
		if not map then
			continue
		end

		table.insert(VoteMaps, {map.Map, map.MapName})
	end]]

	return randMapCycle
end

--[==[---------------------------------------------------------
	Return the next map in the cycle
---------------------------------------------------------]==]
function GM:GetMapNext()
	local map = game.GetMap()
	local nextmap = MapCycle[1].Map
	for k, v in pairs(MapCycle) do
		if v.Map == map and k < #MapCycle then
			nextmap = MapCycle[k+1].Map
		end
	end
	return nextmap
end



-- New shit

function GM:MakeBlankMapList()
		
	local filename = "zombiesurvival/zsmapcycle.txt"	
	local str = file.Read("../mapcycle.txt")
	local maps = string.Explode("\n",str)
	
	for _,v in pairs ( maps ) do
		if v == "" or string.len ( v ) <= 3 or not IsZombieMap( v ) then
			maps[_] = nil
		end
	end
	
	table.Resequence ( maps )
	
	for index=1,#maps do
		local MapFileName = maps[index]
		local Exists = file.Exists("maps/".. MapFileName ..".bsp", "GAME")
		MapCycle[index] = {Map = MapFileName, MapName = ((TranslateMapTable[maps[index]] and TranslateMapTable[maps[index]].Name) or maps[index]), Exists = Exists}
	end
	
	
	Debug("[MAPS] Created new Map List")
	
	file.Write(filename,util.TableToJSON(MapCycle))
end

function GM:LoadMapList()
	local filename = "zombiesurvival/zsmapcycle.txt"
	
	MapCycle = util.JSONToTable(file.Read(filename))
	
	--Check if map file really exists
	for i=1,#MapCycle do
		local v = MapCycle[i]
		v.Exists = file.Exists("maps/".. v.Map ..".bsp", "GAME")
	end		
	
	Debug("[MAPS] Loaded Map List")
end

function ShuffleMapList(pl,cmd,args)
	if not pl:IsAdmin() or not MapCycle then
		return
	end
	
	MapCycle = table.Shuffle(MapCycle)
end
concommand.Add("zs_mapmanager_shuffle",ShuffleMapList)

function SaveMapList(pl,cmd,args)
	if not pl:IsAdmin() or not MapCycle then
		return
	end
	
	local filename = "zombiesurvival/zsmapcycle.txt"
	
	file.Write(filename,util.TableToJSON(MapCycle))	
	Debug("[MAPS] Saved Map List")
end
concommand.Add("zs_mapmanager_save",SaveMapList)

--Send maps to client
function SendMapListToClient(pl, commandName, args)
	if not pl:IsAdmin() or not MapCycle then
		return
	end

	local x = 1
	for k, v in pairs( MapCycle ) do	
		umsg.Start( "SendMapList", pl )
			umsg.Short( x )
			umsg.String(v.Map)
			umsg.String(v.MapName)
			umsg.Bool(file.Exists("maps/".. v.Map ..".bsp", "GAME")) --Or use v.Exists
		umsg.End()
		x = x + 1
	end
end
concommand.Add("send_maplist",SendMapListToClient) 

--Map manipulation!

function Map_Swap(pl,cmd,args)
	
	if not pl:IsAdmin() or not MapCycle then
		return
	end
	
	local index = args[1]
	local down = args[2]
	
	if not index then
		return
	end
	
	local temp
	
	index = tonumber(index)
	
	if util.tobool(down) then
		temp = MapCycle[index+1] 
		MapCycle[index+1] = MapCycle[index]
		MapCycle[index] = temp
		temp = nil
	else
		temp = MapCycle[index-1] 
		MapCycle[index-1] = MapCycle[index]
		MapCycle[index] = temp
		temp = nil
	end
	
end
concommand.Add("zs_mapmanager_swap",Map_Swap) 

function Map_Delete(pl,cmd,args)
	if not pl:IsAdmin() or not MapCycle then
		return
	end
	
	local index = args[1]
	
	if not index then return end
	
	index = tonumber(index)
	
	MapCycle[index] = nil
	
	table.Resequence ( MapCycle )

end
concommand.Add("zs_mapmanager_delete",Map_Delete) 

function Map_AddNew(pl,cmd,args)
	
	if not pl:IsAdmin() then return end
	if MapCycle == nil then return end
	
	local filename = args[1]
	local name = args[2]
	
	if not filename or not name then return end
	
	local Exists = file.Exists("maps/".. filename ..".bsp", "GAME")
	MapCycle[#MapCycle+1] = {Map = filename, MapName = name, Exists = Exists}

	table.Resequence(MapCycle)


	net.Start("MapManager-UpdateInfo")
	net.WriteInt(#MapCycle, 32)
	net.WriteTable(MapCycle[#MapCycle])
	net.Send(pl)
end
concommand.Add("zs_mapmanager_add",Map_AddNew)

util.AddNetworkString("MapManager-UpdateInfo")

function Map_RenewName(pl,cmd,args)
	
	if not pl:IsAdmin() then return end
	if MapCycle == nil then return end
	
	local index = args[1]
	local name = args[2]
	
	if not index or not name then return end
	
	index = tonumber(index)
	
	MapCycle[index].MapName = name or "Invalid Name!"
	
	-- table.Resequence ( MapCycle )

end
concommand.Add("zs_mapmanager_renewname",Map_RenewName) 

function Map_RenewFileName(pl,cmd,args)
	
	if not pl:IsAdmin() then return end
	if MapCycle == nil then return end
	
	local index = args[1]
	local filename = args[2]
	
	if not index or not filename then return end
	
	index = tonumber(index)
	
	MapCycle[index].Map = filename or "zs_please"
	
	-- table.Resequence ( MapCycle )

end
concommand.Add("zs_mapmanager_renewfilename",Map_RenewFileName) 

--Map Properties!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

MapProperties = {}

function GM:MapProperties()
	
	local filename = "zombiesurvival/zsmapproperties.txt"
	
	if file.Exists(filename,"DATA") then
		self:LoadMapProperties()
	else
		self:MakeBlankMapProperties()
	end

end

function GM:MakeBlankMapProperties()
		
	local filename = "zombiesurvival/zsmapproperties.txt"
	
	for map,stuff in pairs(TranslateMapTable) do
		-- order -  Remove entities, Except removing,Remove by model, Remove Glass,spawn protection
		MapProperties[map] = { stuff.RemoveEntities or {}, stuff.ExceptEntitiesRemoval or {}, stuff.RemoveEntitiesByModel or {}, stuff.RemoveGlass or false, stuff.ZombieSpawnProtection or 3 }
	end
	
	print("-< Created new Map Properties! >-")
	
	file.Write(filename,util.TableToJSON(MapProperties))	
end

function GM:LoadMapProperties()
	local filename = "zombiesurvival/zsmapproperties.txt"
	
	MapProperties = util.JSONToTable(file.Read(filename))
	
	print("-< Loaded Map Properties! >-")
end

function SendMapPropertiesToClient ( pl,commandName,args )
	if not pl:IsAdmin() then
		return
	end
	
	if MapProperties == nil then
		return
	end
	
	for map, tables in pairs( MapProperties ) do	
		umsg.Start( "SendMapProperties", pl )
			umsg.String( map )
			umsg.String( util.TableToJSON(tables) )
		umsg.End()
	end
end
concommand.Add("send_mapproperties",SendMapPropertiesToClient) 

function ReceiveMapProperties(pl,cmd,args)
	
	if not pl:IsAdmin() then return end
	if MapProperties == nil then return end
	
	if not args then return end
	
	local map = tostring(args[1])
	local encoded = tostring(args[2])
	
	-- print("Received :"..map)
	-- print("Serverside encoded: "..encoded)
	
	local filename = "zombiesurvival/zsmapproperties.txt"
	
	local fixed = string.gsub(encoded,"'","\"")
	
	-- print("Serverside fixed: "..fixed)
	
	local decoded = util.JSONToTable(fixed)
	
	MapProperties[map] = decoded
	
	-- PrintTable(MapProperties[map])
	
	timer.Simple(0.1,function()	
		file.Write(filename,util.TableToJSON(MapProperties))	
		print("-< Saved Map Properties! >-")
	end)
	
end
concommand.Add("send_back_mapproperties",ReceiveMapProperties) 

Debug ( "[MODULE] Loaded map utilities file." )