
AddCSLuaFile()

---
-- @description AppID translation table
-- @usage Used for translating function with appid parameters
-- 
engine.Games = 
{
    ["Counter-Strike"] = 240,
    ["Half-Life 2"] = 220,
    ["Day of Defeat"] = 300,
    ["Team Fortress 2"] = 440,
    ["Half-Life 2: Episode 2"] = 420,
    ["Half-Life 2: Episode 1"] = 380,
    ["Half-Life 2: Lost Coast"] = 340,
    ["Half-Life: Source"] = 280,
    ["Half-Life Deathmatch: Source"] = 360,
    ["Portal"] = 400,
    ["Left 4 Dead 2"] = 550,
    ["Left 4 Dead"] = 500,
    ["Portal 2"] = 620    
}

---
-- @description Returns if a game is mounted in the filesystem
-- @param appid An integer specifying AppID. See engine.Games
-- 
function engine.IsGameMounted( appid )
    for k,tab in pairs( engine.GetGames() ) do
        if ( tab.depot == appid ) then
            return tab.mounted
        end
    end
    
    return false
end

---
-- @description Returns if a game is installed in the filesystem
-- @param appid An integer specifying AppID. See engine.Games
-- 
function engine.IsGameInstalled( appid )
    for k,tab in pairs( engine.GetGames() ) do
        if ( tab.depot == appid ) then
            return tab.installed
        end
    end
    
    return false
end

---
-- @description Returns if a game is bought/owned
-- @param appid An integer specifying AppID. See engine.Games
-- 
function engine.IsGameBought( appid )
    for k,tab in pairs( engine.GetGames() ) do
        if ( tab.depot == appid ) then
            return tab.owned
        end
    end
    
    return false
end



