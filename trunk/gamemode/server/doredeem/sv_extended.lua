-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Global player table
metaPlayer = FindMetaTable( "Player" )

-- Can a player redeem
-- function metaPlayer:CanRedeem()
	-- return ( self:IsZombie() and not ENDROUND and not LASTHUMAN and ( ( self:Frags() >= 6 and self:HasBought( "quickredemp" ) ) or ( self:Frags() >= 8 and not self:HasBought( "quickredemp" ) ) ) )
-- end

-- Get redeem time
function metaPlayer:GetLastRedeemTime()
	return self.LastRedeemTime
end

-- Redeems a player
function metaPlayer:Redeem ( Causer )
	-- if self:CanRedeem() then 
		gamemode.Call( "OnPlayerRedeem", self, Causer )
	-- end
end



