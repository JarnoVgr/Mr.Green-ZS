-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Global player table
metaPlayer = FindMetaTable("Player")

-- Get redeem time
function metaPlayer:GetLastRedeemTime()
	return self.LastRedeemTime
end

-- Redeems a player
function metaPlayer:Redeem(Causer)
	gamemode.Call("OnPlayerRedeem", self, Causer)
end