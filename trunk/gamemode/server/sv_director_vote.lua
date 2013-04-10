-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local table = table
local math = math
local string = string
local util = util
local pairs = pairs
local team = team
local player = player
local timer = timer
local umsg = umsg

local VoteType, VoteCooldown = "none", 0
local VOTES, VOTING_PLAYERS, TARGET_PLAYER, IS_VOTE_IN_PROGRESS = { YES = {}, NO = {} }, {}, NULL, false
local GaggedTbl, MutedTbl = {}, {}

local metaPlayer = FindMetaTable("Player")
if not metaPlayer then return end

-- Gag
function metaPlayer:Gag()
	self.IsGagged = true
	GaggedTbl[self:SteamID()] = true
end

-- Ungag
function metaPlayer:UnGag( )
	self.IsGagged = false
	GaggedTbl[self:SteamID()] = nil
end

-- Handle gag
local function HandleGag( ply, sText )
	if GaggedTbl[ply:SteamID()] then
		if ply:IsAdmin() and string.find( sText, "ungag" ) then
			ply:UnGag( ply )
			return sText
		end
		
		return ""
	end
end
hook.Add( "PlayerSay", "HandleGag", HandleGag )

-- Mute
function metaPlayer:Mute( )
	self.IsMuted = true
	MutedTbl[self:SteamID()] = true
end

-- Unmute
function metaPlayer:UnMute( )
	self.IsMuted = false
	MutedTbl[self:SteamID()] = nil
end

-- Handle mute
local function HandleMute( listener, talker )
	if MutedTbl[talker:SteamID()] then
	--if talker.IsMuted then
		-- The talker is muted, let the listener not hear him
		return false
	end
end
hook.Add( "PlayerCanHearPlayersVoice", "HandleMute", HandleMute )

--[==[-------------------------------------------------------------
    Check the chat to see if someone triggers a vote	
--------------------------------------------------------------]==]
function Vote ( pl, text) 
	if pl:Team() == TEAM_SPECTATOR then return end
	
	-- First string is the command, second the arguments
	local tbString = string.Explode( " ", text )
	
	if text:sub(1,1) == "!" then
		if tbString[1] == "!zsvotemute" or tbString[1] == "!zsvotegag" then
		
			if VoteCooldown > CurTime() then pl:CustomChatPrint ( {nil, Color(213,84,0),"[VOTE] ",Color(213,213,213),"You have to wait "..math.Round( VoteCooldown - CurTime() ).." seconds before starting a new vote!"} ) return "" end
			if VoteInProgress() then pl:CustomChatPrint ( {nil, Color(213,84,0),"[VOTE] ",Color(213,213,213),"Another vote is already in progress!"} ) return "" end
			
			local strActionToTake = text:sub( 8,11 )
			if string.find ( strActionToTake, "gag" ) then
				strActionToTake = "gag"
			end
			
			-- You can't start a vote with 4 players.
			if #player.GetAll() < 4 then pl:CustomChatPrint ( {nil, Color(213,84,0),"[VOTE] ",Color(213,213,213),"You can't start a vote with less than 4 players!"} ) return "" end
			
			-- Set the type of the vote
			VoteType = strActionToTake
			
			if #tbString <= 1 then pl:PrintMessage ( HUD_PRINTTALK, "The command format is !zsvote"..strActionToTake.. " < player name >" ) return "" end
			local Target = GetPlayerByName( tbString[2] )
			
			-- Found nothing
			if Target == -1 or Target == -2 then pl:PrintMessage ( HUD_PRINTTALK, "Multiple or no entries have been found." ) return "" end
			
			-- You can't votekick yourself
			if Target == pl then pl:CustomChatPrint ( {nil, Color(213,84,0),"[VOTE] ",Color(213,213,213),"You can't vote"..strActionToTake.." yourself!"} ) return "" end
			
			-- Start the event
			if Target:IsPlayer() then
				if Target:Team() == TEAM_SPECTATOR then pl:CustomChatPrint ( {nil, Color(213,84,0),"[VOTE] ",Color(213,213,213),"You can't vote"..strActionToTake.." spectators!"} ) return "" end
				
				-- Update some global vars ( Vote, Player )
				IS_VOTE_IN_PROGRESS, TARGET_PLAYER, VOTING_PLAYERS = true, Target, player.GetAll()
				
				-- Notify players about votestart
				for k,p in pairs(player.GetAll()) do
					p:CustomChatPrint ( {nil, Color(213,84,0),"[VOTE] ",Color(213,213,213),""..pl:Name().." started a vote"..strActionToTake.." for player "..Target:Name().." ! ",Color(213,213,213),"Press F1 for ",Color(0,255,0),"YES",Color(213,213,213)," or F2 for ",Color(255,0,0),"NO."} )
				end
				
				umsg.Start("OpenVoteWindow")
					umsg.Entity(Target)
						if strActionToTake == "gag" then
							umsg.String("gag")
						else
							umsg.String("mute")
						end
				umsg.End()
				
				-- Vote results
				timer.Simple ( 20, function() DoVoteResults ( #player.GetAll(), Initiator, Target, strActionToTake ) end )
				VoteCooldown = CurTime() + 140
				
				return ""
			end
		end
	end
end		
--hook.Add ( "PlayerSay", "Vote", Vote )

--[==[------------------------------------------
    Process the results from the vote
-------------------------------------------]==]
function DoVoteResults ( PlayerCount, Initiator, Target, VoteType )
	IS_VOTE_IN_PROGRESS = false
	
	-- Compensate for letter
	local Type = VoteType
	if Type == "mute" then Type = "mut" end
	
	umsg.Start("CloseVoteWindow")
	umsg.End()

	-- Targeted player has left the game
	if not ValidEntity ( Target ) then 
		for k,p in pairs(player.GetAll()) do
			p:CustomChatPrint ( {nil, Color(213,84,0),"[VOTE] ",Color(213,213,213),"Vote failed because target player has disconnected!"} ) 
		end
	return end

	-- Get yes and no counts
	local YesCounts, NoCounts, VoteResult = #VOTES.YES, #VOTES.NO, false
	local Message = "Voting has finished. Results: "..Target:Name().." didn't get "..Type.."ed because votes were in his favour."
	
	-- Reset votes table
	VOTES = { YES = {}, NO = {} }
	
	-- Total counts
	local PlayersVoted = YesCounts + NoCounts
	
	--  if yes counts are more or equal to 50% of the sv population on the vote start time, then kick
	if PlayersVoted >= math.Round ( PlayerCount / 2 ) then
		if YesCounts >= math.Round ( PlayerCount / 2 ) then
			VoteResult = true
		end
	end
	
	--  if players that vote are less than half the total then split that number and get the result
	if PlayersVoted < math.Round ( PlayerCount / 2 ) then
		if YesCounts >= math.Round ( PlayersVoted / 2 ) then
			VoteResult = true
		end
	end		
	
	if PlayersVoted <= 2 then 
		for k,p in pairs(player.GetAll()) do
			p:CustomChatPrint ( {nil, Color(213,84,0),"[VOTE] ",Color(213,213,213),"Voting has failed. Not enough votes. Need atleast 3!"} ) 
		end
		return 
	end
	
	--  Kick/mute/gag him!
	if VoteResult then
	
		--Message = "Voting has finished. Results: Player "..Target:Name().." has been "..Type.."ed !"
		for k,p in pairs(player.GetAll()) do
			p:CustomChatPrint ( {nil,Color(213,84,0),"[VOTE] ",Color(213,213,213),"Voting has finished. Results: Player "..Target:Name().." has been "..Type.."ed !"} )
		end
		
		-- Do the dirty shit!
		if Type == "kick" then Target:Kick ( "Kicked on vote!" ) end
		if Type == "mut" then Target:Mute() end
		if Type == "gag" then Target:Gag() end
	else
		for k,p in pairs(player.GetAll()) do
			p:CustomChatPrint ( {nil,Color(213,84,0),"[VOTE] ",Color(213,213,213),"Voting has finished. Results: "..Target:Name().." didn't get "..Type.."ed because votes were in his favour."} )
		end
	end
	
	-- Notify the players about the result

end

--[==[------------------------------------------------------------
               Called when the player pressed F1
------------------------------------------------------------]==]
function PlayerVoteYes ( pl )
	if not table.HasValue ( GetActiveVotePlayers(), pl ) then return end
	if not VoteInProgress() or pl:HasVoted( VOTES ) then return end
	
	-- Vote type
	local Type = GetVoteType()
	if Type == "none" then pl:PrintMessage ( HUD_PRINTTALK, "Something went wrong during voting. Your vote has failed." ) return end
	
	if ValidEntity ( TARGET_PLAYER ) then
		for k,p in pairs(player.GetAll()) do
			p:CustomChatPrint ( {nil,Color(213,213,213), "Player "..pl:Name().." voted ",Color(0,255,0),"YES",Color(213,213,213)," to "..Type.." player "..TARGET_PLAYER:Name().." !"} )
		end
		table.insert ( VOTES.YES, pl )
		umsg.Start("AddVote")
			umsg.String("yes")
		umsg.End()
	end
end

--[==[---------------------------------------------------------
              Called when the player pressed F2
---------------------------------------------------------]==]
function PlayerVoteNo ( pl )
	if not table.HasValue ( GetActiveVotePlayers(), pl ) then return end
	if not VoteInProgress() or pl:HasVoted( VOTES ) then return end
	
	-- Vote type
	local Type = GetVoteType()
	if Type == "none" then pl:PrintMessage ( HUD_PRINTTALK, "Something went wrong during voting. Your vote has failed." ) return end

	if ValidEntity ( TARGET_PLAYER ) then
		for k,p in pairs(player.GetAll()) do
			p:CustomChatPrint ( {nil,Color(213,213,213), "Player "..pl:Name().." voted ",Color(255,0,0),"NO",Color(213,213,213)," to "..Type.." player "..TARGET_PLAYER:Name().." !"} )
		end
		table.insert ( VOTES.NO, pl )
		umsg.Start("AddVote")
			umsg.String("no")
		umsg.End()
	end
end

--[==[---------------------------------------------------------
       Bypass main F1 call - first vote, then other
---------------------------------------------------------]==]
function GM:ShowHelp ( pl )
	if ( VoteInProgress() and pl:HasVoted ( VOTES ) ) or not VoteInProgress() or not table.HasValue ( GetActiveVotePlayers(), pl )  then
		OnPressF1 ( pl )
	end
	
	PlayerVoteYes ( pl )
end

--[==[---------------------------------------------------------
       Bypass main F2 call - first vote, then other
---------------------------------------------------------]==]
function GM:ShowTeam ( pl ) 
	if ( VoteInProgress() and pl:HasVoted ( VOTES ) ) or not VoteInProgress() or not table.HasValue ( GetActiveVotePlayers(), pl ) then
		OnPressF2 ( pl )
	end
	
	PlayerVoteNo ( pl )
end

--[==[------------------------------------------------
   Check too see if there a vote in progress
-------------------------------------------------]==]
function VoteInProgress()
	return IS_VOTE_IN_PROGRESS
end

--[==[------------------------------------------------
   Returns table with players ( and votes )
-------------------------------------------------]==]
function GetPlayerVotes()
	return VOTES
end

--[==[------------------------------------------------
     Returns vote type (kick/mute/gag)
-------------------------------------------------]==]
function GetVoteType()
	return VoteType
end

--[==[------------------------------------------------------
  Returns players that existen when vote started
-------------------------------------------------------]==]
function GetActiveVotePlayers()
	return VOTING_PLAYERS
end

Debug ( "[MODULE] Loaded VoteMute/Gag file." )