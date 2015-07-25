--Log lua errors
timer.Simple(1, function()
	RunConsoleCommand("lua_log_sv", "1")
end)

--Disable Team Voice
timer.Simple(1, function()
	RunConsoleCommand("sv_alltalk", "0")
end)

--Saves debug to file at every entry
TURBO_DEBUGGER = false

--Enable editor spawn mode
EDITOR_SPAWN_MODE = false

--Custom debug system save to file interval
DEBUG_SAVE_FILE_TIME = 3

-- Exchange rate coins for killing humans/zombies == Double GC for Holidays! (Halloween, Easter etc)
COINS_PER_ZOMBIE = 1
COINS_PER_HUMAN = 5

--Double XP for everything
DOUBLE_XP = true

--IRC Relay
IRC_RELAY_ENABLED = CreateConVar("zs_irc", "0", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Enable IRC. Requires mapchange."):GetBool()
cvars.AddChangeCallback("zs_irc", function(cvar, oldvalue, newvalue)
	IRC_RELAY_ENABLED = (tonumber(newvalue) == 1)
end)
IRC_RELAY_NICK = "MrGreenZS"
IRC_RELAY_SERVER = "irc.gtanet.com"
IRC_RELAY_CHANNEL = "#mrgreen.zs"
IRC_IDLE_CHANNEL = nil --"#mrgreen"

--Supply Crate recharge time
SUPPLYCRATE_RECHARGE_TIME = 180