-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--File optimization by Duby

local function PrintData()
	for k,v in pairs ( achievementDesc ) do
		Msg( "["..k.."] = { " )
		for i,j in pairs( v ) do
			local Value = tostring( j )
			if type( j ) == "string" then Value = [["]]..tostring( j )..[["]] end
			Value = string.Replace( Value, "\n", "" )
			Msg( i.." = "..Value..", " )
		end
		Msg( " }, \n" )
	end
end

shopData = {
	[1] = { Cost = 800, Type = "hat", AdminOnly = false, Desc = "Eating too many eggs in the morning? No problem. This is your solution! Now you can eat eggs, in-game, too!", Key = "egg", ID = 1, Sell = 0, Requires = 0, Name = "Egg Hat",  },
	[2] = { Cost = 800, Type = "hat", AdminOnly = false, Desc = "If you wear this, you'll look like that anime character,Kanti Sama.", Key = "monitor", ID = 2, Sell = 0, Requires = 0, Name = "TV Head",  },
	
	[3] = { Cost = 5000, Type = "misc", Hidden = false, AdminOnly = false, Desc = "[1/6] Join the group with your only friend, Mister .357 cal.", Key = "magnumman", ID = 3, Sell = 0, Requires = 0, Name = "Mysterious Stranger",  },
	
	--[4] = { Cost = 6000, AdminOnly = false, Desc = "You kill humans for a living. Literally. Restores a quarter of your HP after killing a human!", Key = "steamroller", ID = 4, Sell = 0, Requires = 0, Name = "Steamroller",  },
	--[5] = { Cost = 7500, Hidden = true, AdminOnly = false, Desc = "Get an additional weapon after redeeming. More zombies, better weapon.", Key = "comeback", ID = 5, Sell = 0, Requires = 0, Name = "Comeback",  },
	[6] = { Cost = 1000, Type = "other", AdminOnly = false, Desc = "Being a bit paranoid about those toxic fumes? No worries, carry this mask! (note: it doesn't work against toxis fumes).", Key = "mask", ID = 6, Sell = 0, Requires = 0, Name = "Mask",  },
	[7] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "Time to hit a homerun! All you need is a headcrab and a crowbar...", Key = "ushat", ID = 7, Sell = 0, Requires = 0, Name = "Baseball cap",  },
--	[8] = { Cost = 5000, Hidden = true, AdminOnly = false, Desc = "Human spines are like toothpicks to you. Do more damage when attacking a human from behind!", Key = "backbreaker", ID = 8, Sell = 0, Requires = 0, Name = "Backbreaker",  },
	[9] = { Cost = 500, Type = "hat", AdminOnly = false, Desc = "Trick 'r' treat! Make sure you put this hat on to look cool on Halloween :) (Permanent hat)", Key = "pumpkin", ID = 9, Sell = 0, Requires = 0, Name = "Pumpkin Hat",  },
	[10] = { Cost = 750, Type = "hat", AdminOnly = false, Desc = "Easter eggs. Lol.", Key = "bunnyears", ID = 10, Sell = 0, Requires = 0, Name = "Bunny Ears",  },
	[11] = { Cost = 5000, Hidden = true, AdminOnly = false, Desc = "Bringing your bare hands to a gun fight? Why not! You'll get an extra boost with melee weapons and your fists.", Key = "blessedfists", ID = 11, Sell = 0, Requires = 0, Name = "Blessed Fists",  },
	[12] = { Cost = 7500, Type = "misc", Hidden = false, AdminOnly = false, Desc = "God puts you on his express list. Redeem on 6 points instead of 8!", Key = "quickredemp", ID = 12, Sell = 0, Requires = 0, Name = "Quick Redemption",  },
	[13] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "You might experience a little IQ increase when inserting this thing in your head. Don't count on it though.", Key = "borghat", ID = 13, Sell = 0, Requires = 0, Name = "Borg hat",  },
	[14] = { Cost = 1, Type = "hat", AdminOnly = true, Desc = "Hat for admins! Nope, normal players cannot see this in the list.", Key = "greenshat", ID = 14, Sell = 0, Requires = 0, Name = "Greens Hat",  },
	[15] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "With this big eye-catching thing lodged on your head you're sure to attract some attention. Too bad it doesn't shoot lasers.", Key = "roboteye", ID = 15, Sell = 0, Requires = 0, Name = "Robot hat",  },
	
	--[17] = { Cost = 5000, Hidden = true, AdminOnly = false, Desc = "Rambo's your bitch. As last human you do more damage to zombie and receive the powerful M249!", Key = "lastmanstand", ID = 17, Sell = 0, Requires = 0, Name = "Last Man Stand",  },
	[18] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "Ho ho ho! Merry Christmas! It's that time of the year again .. (Permanent hat)", Key = "snowhat", ID = 18, Sell = 0, Requires = 0, Name = "Snowman Hat",  },
	[19] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "Greencoins make Santa Claus's World go round! That's why you should buy this lovely hat right from Santa's Bag!  .. (Permanent hat)", Key = "present", ID = 19, Sell = 0, Requires = 0, Name = "Present Hat",  },
	[20] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "A sawblade sombrero, how cool can it get? Chuck Norris has one you know.", Key = "sombrero", ID = 20, Sell = 0, Requires = 0, Name = "Sombrero",  },
	[21] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "You won't die of starvation with this thing on.", Key = "melonhead", ID = 21, Sell = 0, Requires = 0, Name = "Melonhead",  },
	[22] = { Cost = 8000,Type = "misc", AdminOnly = false, Desc = "You get twice as much ammunition from the Supply Crates!", Key = "ammoman", ID = 22, Sell = 0, Requires = 0, Name = "Ammunition Man",  },
	[23] = { Cost = 7000,Type = "misc", AdminOnly = false, Desc = "You become bloodthirsty! Receive a third of damage done with claws towards your health!", Key = "vampire", ID = 23, Sell = 0, Requires = 5, Name = "Blood Sucker",  },
	
	-- FREEMAN--egghat
	[24] = { Cost = 7500, Hidden = false, Type = "misc", AdminOnly = false, Desc = "[1/4] Start the round as THE Gordon Freeman!", Key = "gordonfreeman", ID = 24, Sell = 0, Requires = 0, Name = "Crowbar Wielding God",  },
	
	--[25] = { Cost = 5000, Hidden = true, AdminOnly = false, Desc = "When having low health you won't walk as slow as without adrenaline.", Key = "adrenaline", ID = 25, Sell = 0, Requires = 0, Name = "Adrenaline",  },
	--[26] = { Cost = 7500, Hidden = true, AdminOnly = false, Desc = "A few bandages should hold. Health regenerates when below 30 hp when you're still human!", Key = "quickcure", ID = 26, Sell = 0, Requires = 0, Name = "Quick Cure",  },
	[27] = { Cost = 4000, Type = "misc", AdminOnly = false, Desc = "Ability to change your player title in the Options (F4) menu.", Key = "titlechanging", ID = 27, Sell = 0, Requires = 0, Name = "Title Editor",  },
	[28] = { Cost = 7200, Hidden = true, AdminOnly = false, Desc = "When your health is 30 or below, and you get hit by zombies that do damage greater than 25, then you have a 30% chance to not take damage. Occurs once in 5 minutes. You must have atleast 4 upgrades to buy this one.", Key = "cheatdeath", ID = 28, Sell = 0, Requires = 4, Name = "Cheat Death",  },
	--[29] = { Cost = 3500, Hidden = true, AdminOnly = false, Desc = "Health vials and packs heal you for 50% more health.", Key = "surgery", ID = 29, Sell = 0, Requires = 3, Name = "Surgery",  },
	[30] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "A cooking pot is THE perfect household head protection when fighting anything unnatural!", Key = "pothat", ID = 30, Sell = 0, Requires = 0, Name = "Pot hat",  },
	--[31] = { Cost = 4000, Hidden = true, AdminOnly = false, Desc = "Cannibalism is healthy. Get more health from eating flesh gibs when zombie.", Key = "fleshfreak", ID = 31, Sell = 0, Requires = 0, Name = "Flesh Freak",  },
	[32] = { Cost = 2000, Type = "hat", AdminOnly = false, Desc = "Your ICING? Uhm, dude you got something on your head! This hat doesn't turn you into a zombie!", Key = "crab", ID = 32, Sell = 0, Requires = 0, Name = "Headcrab Hat",  },
	[33] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "Christmas, it's that time of the year again!", Key = "santahat", ID = 33, Sell = 0, Requires = 0, Name = "Santa hat",  },
	[34] = { Cost = 4000, Type = "misc", AdminOnly = false, Desc = "Luck is not for sale? Well it is here! The chance of a good outcome with roll-the-dice is increased.", Key = "ladyluck", ID = 34, Sell = 0, Requires = 0, Name = "Lady Luck",  },
	--[35] = { Cost = 5000, Hidden = true, AdminOnly = false, Desc = "Retrieve all weapons from your previous life after redeeming as zombie.", Key = "retrieval", ID = 35, Sell = 0, Requires = 0, Name = "Might Of A Previous Life ",  },
	[36] = { Cost = 2000, Type = "hat", AdminOnly = false, Desc = "You'd be Nicolas Cage - Death Rider with this hat on!", Key = "skull", ID = 36, Sell = 0, Requires = 0, Name = "Skull Hat",  },
	--[37] = { Cost = 5000, Hidden = true, AdminOnly = false, Desc = "As human, if you get hit by a poison headcrab spit or hump, you will get 40% less damage.", Key = "naturalimmunity", ID = 37, Sell = 0, Requires = 4, Name = "Natural Immunity",  },
	[38] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "Pirates are the mortal enemy of ninjas, but they love to pick off a zombie on their way.", Key = "piratehat", ID = 38, Sell = 0, Requires = 0, Name = "Pirate hat",  },
	[39] = { Cost = 1500, Type = "hat", AdminOnly = false, Desc = "Raises your intelligence-aura by 100%! Note that it does not scare off zombies.", Key = "tophat", ID = 39, Sell = 0, Requires = 0, Name = "Top hat",  },
	[40] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "Bring some old-fashioned style to the apocalypse. Probably stolen from a dead Brit.", Key = "homburg", ID = 40, Sell = 0, Requires = 0, Name = "Homburg hat",  },
	[41] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "A bucket hat. Works better than kevlar according to the local bums.", Key = "buckethat", ID = 41, Sell = 0, Requires = 0, Name = "Bucket hat",  },
	--[42] = { Cost = 5500, Hidden = true, AdminOnly = false, Desc = "As human, you receive [15 + your total score divided by 5] percent less damage from Normal and Poison zombies. Requires 7 other upgrades.", Key = "spartanu", ID = 42, Sell = 0, Requires = 7, Name = "Spartan",  },
	[43] = { Cost = 6500, Type = "misc", Hidden = false, AdminOnly = false, Desc = "Bring more destruction! You will deal 100% more damage to nailed props.", Key = "cadebuster", ID = 43, Sell = 0, Requires = 0, Name = "Cade Buster",  },
	[44] = { Cost = 7000, Type = "misc", AdminOnly = false, Desc = "Screw gravity! You have a 1 in 3 chance of not taking fall damage!", Key = "bootsofsteel", ID = 44, Sell = 0, Requires = 0, Name = "Boots of Steel",  },
	--[45] = { Cost = 7500, Hidden = true, AdminOnly = false, Desc = "Bonk! Receive additional 20% chance to decapitate a zombie! Requires 6 other upgrades.", Key = "homerun", ID = 45, Sell = 0, Requires = 6, Name = "Home Run (NEW)",  },
	--[46] = { Cost = 1100, Hidden = true, Type = "suit", AdminOnly = false, Desc = "Classic suit from IW!", Key = "testsuit", ID = 46, Sell = 0, Requires = 0, Name = "IW test suit",  },
	[47] = { Cost = 1, Type = "suit", AdminOnly = true, Desc = "Special suit just for admins! (not finished yet)", Key = "greenssuit", ID = 47, Sell = 0, Requires = 0, Name = "Admin's Suit",  },
	
	[53] = { Cost = 1600, Type = "other", AdminOnly = false, Desc = "It glows!", Key = "techeyes", ID = 53, Sell = 0, Requires = 0, Name = "Techno Eyes" },
	[54] = { Cost = 1800, Type = "hat", AdminOnly = false, Desc = "What the... How the hell you are still alive with that thing in your head?!", Key = "cleaver", ID = 54, Sell = 0, Requires = 0, Name = "Nasty Cleaver" },
	[55] = { Cost = 1200, Type = "hat", AdminOnly = false, Desc = "Augmentations ftw. However this hat will not increase your accuracy :O", Key = "magnlamp", ID = 55, Sell = 0, Requires = 0, Name = "Magnifying lamp" },
	[56] = { Cost = 2100, Type = "hat", AdminOnly = false, Desc = "It HUNGERS for more!", Key = "scannerhelm", ID = 56, Sell = 0, Requires = 0, Name = "Scanner Helmet" },
	[57] = { Cost = 5200, Type = "misc", AdminOnly = false, Desc = "Ability to change the color of your hat (not suit) in F4 menu!", Key = "hatpainter", ID = 57, Sell = 0, Requires = 0, Name = "Hat Painter" },--5200
	[58] = { Cost = 900, Type = "hat", AdminOnly = false, Desc = "'I love the smell of cooked zombies in the morning!'", Key = "chef", ID = 58, Sell = 0, Requires = 0, Name = "Chef's Hat" },
	[59] = { Cost = 2100, Type = "hat", AdminOnly = false, Desc = "Picking up cans since 2008", Key = "combinehelm", ID = 59, Sell = 0, Requires = 0, Name = "Combine Helmet" },
	[60] = { Cost = 2200, Type = "other", AdminOnly = false, Desc = "Looks like it was ripped off straight from Vaporizer Rifle... Or not?", Key = "termeye", ID = 60, Sell = 0, Requires = 0, Name = "Technology!" },
	[61] = { Cost = 1700, Type = "hat", AdminOnly = false, Desc = "A cute fez for your and your friends :O  (NOTE: Actually it is red by default, but preview aint showing it)", Key = "fez", ID = 61, Sell = 0, Requires = 0, Name = "Tiny Fez" },
	[62] = { Cost = 2100, Type = "other", AdminOnly = false, Desc = "ARE YOU MANLY ENOUGH TO WEAR THIS BEARD?! (Requires TF2)", Key = "beard", ID = 62, Sell = 0, Requires = 0, Name = "Beard" },
	[63] = { Cost = 4000, Type = "other", AdminOnly = false, Desc = "Remember, smoking kills (zombies). (Requires TF2)", Key = "cigar", ID = 63, Sell = 0, Requires = 0, Name = "Cigar" },
	[64] = { Cost = 0, Type = "hat", EventOnly = true, Type = "hat", AdminOnly = false, Desc = "Unlockable beanie! (Requires TF2)", Key = "wbeanie", ID = 64, Sell = 0, Requires = 0, Name = "Winter Beanie" },
	[65] = { Cost = 2000, Type = "hat", AdminOnly = false, Desc = "Now that is a proper hat for zombie apocalypse. (Requires TF2)", Key = "hellsing", ID = 65, Sell = 0, Requires = 0, Name = "Hellsing Hat" },
	[66] = { Cost = 1900, Type = "hat",Hidden = true, AdminOnly = false, Desc = "You're tought guy, huh?. (Requires TF2)", Key = "beanie", ID = 66, Sell = 0, Requires = 0, Name = "Beanie" },
	[67] = { Cost = 2500, Type = "hat", AdminOnly = false, Desc = "Just a normal hat. Nothing special... right?. (Requires TF2)", Key = "normalhat", ID = 67, Sell = 0, Requires = 0, Name = "Ordinary Hat" },
	[68] = { Cost = 2200, Type = "hat", AdminOnly = false, Desc = "At least everyone will know who you are. (Requires TF2)", Key = "medhelm", ID = 68, Sell = 0, Requires = 0, Name = "Medic's Helmet" },
	
	[70] = { Cost = 1900, Type = "hat", AdminOnly = false, Desc = "Classic cap for winter apocalypse. (Requires TF2)", Key = "wintercap", ID = 70, Sell = 0, Requires = 0, Name = "Winter Cap" },
	[71] = { Cost = 2300, Type = "hat", AdminOnly = false, Desc = "...and so stylish!. (Requires TF2)", Key = "socold", ID = 71, Sell = 0, Requires = 0, Name = "Im so cold..." },
	[72] = { Cost = 2000, Type = "other", AdminOnly = false, Desc = "Neither snow, neither zombies can stop you from wearing this. (Requires TF2)", Key = "winterhood", ID = 72, Sell = 0, Requires = 0, Name = "Winter Hood" },
	[73] = { Cost = 1900, Type = "hat", AdminOnly = false, Desc = "I love extreme stuff. (Requires TF2)", Key = "skihat", ID = 73, Sell = 0, Requires = 0, Name = "Ski Hat" },
	[74] = { Cost = 2000, Type = "hat", AdminOnly = false, Desc = "Pimp?. (Requires TF2)", Key = "hall", ID = 74, Sell = 0, Requires = 0, Name = "Hustler's Hallmark" },
	[75] = { Cost = 1200, Type = "other", AdminOnly = false, Desc = "Just a pair of cool glasses, I guess?. (Requires TF2)", Key = "copgl", ID = 75, Sell = 0, Requires = 0, Name = "Cop Glasses" },
	[76] = { Cost = 1600, Type = "other", AdminOnly = false, Desc = "Sometimes you just need a little more hair. (Requires TF2)", Key = "sidebrn", ID = 76, Sell = 0, Requires = 0, Name = "Sideburns" },
	[77] = { Cost = 200, Type = "other", AdminOnly = false, Desc = "Swag with burgers for ears, and guns for brains!", Key = "BurgerBuns", ID = 77, Sell = 0, Requires = 0, Name = "BurgerBuns" },
	[78] = { Cost = 500, Type = "other", AdminOnly = false, Desc = "Becoming a cyborg is fun.", Key = "RoboEars", ID = 78, Sell = 0, Requires = 0, Name = "RoboEars" },
	[79] = { Cost = 800, Type = "other", AdminOnly = false, Desc = "Being chased by zombies! No problem, attach this and play away! 'Doesn't actually do that'.", Key = "Helihead", ID = 79, Sell = 0, Requires = 0, Name = "HeliHead" },
	
	[84] = { Cost = 500, Type = "hat", AdminOnly = false, Desc = "I see you!", Key = "spotlight", ID = 84, Sell = 0, Requires = 0, Name = "Spotlight",  },
	[85] = { Cost = 350 , Type = "hat", AdminOnly = false, Desc = "Brum Brum beep beep outa my way you Kliener scum!", Key = "motorhead", ID = 85, Sell = 0, Requires = 0, Name = "Motor Head",  },
	[86] = { Cost = 1200, Type = "hat", AdminOnly = false, Desc = "I will never fall over! 'You will still have the fall down animation.'", Key = "gyrohead", ID = 86, Sell = 0, Requires = 0, Name = "Gyro Head",  },
	[87] = { Cost = 600, Type = "hat", AdminOnly = false, Desc = "Let there be light", Key = "brightidea", ID = 87, Sell = 0, Requires = 0, Name = "Bright Idea",  },
	[88] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "Its like I have a stalker suit, but isn't 1100GC!", Key = "lampshade", ID = 88, Sell = 0, Requires = 0, Name = "Lamp Shade",  },
	[89] = { Cost = 150, Type = "hat", AdminOnly = false, Desc = "I can tell whats on your mind with this.", Key = "tinfoil", ID = 89, Sell = 0, Requires = 0, Name = "Tin Foil",  },
	[90] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "A drunken night with Reiska is fun.", Key = "roadlock", ID = 90, Sell = 0, Requires = 0, Name = "Road Lock",  },
	[91] = { Cost = 1200, Type = "hat", AdminOnly = false, Desc = "A sheild against your head getting bitten off!", Key = "combinething", ID = 91, Sell = 0, Requires = 0, Name = "The Combine Thing",  },
	[92] = { Cost = 1000, Type = "hat", AdminOnly = false, Desc = "Blame Pufulet", Key = "fence", ID = 92, Sell = 0, Requires = 0, Name = "Da fence",  },
	[93] = { Cost = 650, Type = "hat", AdminOnly = false, Desc = "Jiggle Jiggle", Key = "noveltyhead", ID = 93, Sell = 0, Requires = 0, Name = "Novelty Head 1",  },
	[94] = { Cost = 200, Type = "hat", AdminOnly = false, Desc = "Boggle boggle", Key = "noveltyhead2", ID = 94, Sell = 0, Requires = 0, Name = "Novelty Head 2",  },
	[95] = { Cost = 560, Type = "hat", AdminOnly = false, Desc = "I am like valve but better! ^^", Key = "steamhead", ID = 95, Sell = 0, Requires = 0, Name = "Steam Head",  },
	
	
	--Suits
	[48] = { Cost = 9000, Type = "suit", AdminOnly = false, Desc = "Heal your comrads! For doing this you have extra health to stand the brutal battles which face you!", Key = "medicsuit", ID = 48, Sell = 0, Requires = 0, Name = "Medic's Suit",  }, --11000
	--[49] = { Cost = 9000, Type = "suit", AdminOnly = false, Desc = "Crush. Pound. Suit Bonus: Faster swing speed (heavy weapons only)", Key = "meleesuit", ID = 49, Sell = 0, Requires = 0, Name = "Berserker Suit",  },
	[50] = { Cost = 9000, Type = "suit", AdminOnly = false, Desc = "If shooting zombies aint enough - use more gun. Suit Bonus: Turret damage is increased by 25%!", Key = "techsuit", ID = 50, Sell = 0, Requires = 0, Name = "Engineer's Suit",  },
	[51] = { Cost = 9000, Type = "suit", AdminOnly = false, Desc = "If you've mastered cading skills - this suit is for you. Suit Bonus: More nail HP, more nails at one time.", Key = "supportsuit", ID = 51, Sell = 0, Requires = 0, Name = "Support's Suit",  },
	[52] = { Cost = 9000, Type = "suit", AdminOnly = false, Desc = "Nothing feels better than killing zombies over and over again. Suit Bonus: Increased grenade damage/radius", Key = "assaultsuit", ID = 52, Sell = 0, Requires = 0, Name = "Commando's Suit",  },
	[69] = { Cost = 9000, Type = "suit", AdminOnly = false, Desc = "'You can run, but you can't hide!'. Suit bonus: Hides your heartbeat when standing still.", Key = "stalkersuit", ID = 69, Sell = 0, Requires = 0, Name = "Sharpshooter's Suit" },
	[80] = { Cost = 9000, Type = "suit", AdminOnly = false, Desc = "You love zerking well this is the suit for you!! Gain hp for every melee kill depending on the weapon. ", Key = "gravedigger", ID = 80, Sell = 0, Requires = 0, Name = "Berserker's Rage",  },
--	[81] = { Cost = 1000, Type = "suit", AdminOnly = false, Desc = "Become one of the elite forces and fight for the Dubyans!", Key = "Combine", ID = 81, Sell = 0, Requires = 0, Name = "Combine the Zombine!",  },
--	[82] = { Cost = 4000, Type = "suit", AdminOnly = false, Desc = "Improves the Pulse rifle and smg ammo recharge rate!", Key = "freeman", ID = 82, Sell = 0, Requires = 0, Name = "Freeman Rage!",  },
--	[83] = { Cost = 4000, Type = "suit", AdminOnly = false, Desc = "Live for nothing or die for something. Reload more bullets in your shotgun at one time!", Key = "Rambo", ID = 83, Sell = 0, Requires = 0, Name = "Rambo Roar",  },
--	[96] = { Cost = 1, Type = "suit", AdminOnly = true, Desc = "", Key = "pistolsuit", ID = 96, Sell = 0, Requires = 0, Name = "Test suit",  },
	--[97] = { Cost = 20 , Type = "suit", AdminOnly = false, Desc = "Another day at the office...", Key = "officesuit", ID = 97, Sell = 0, Requires = 0, Name = "Office",  },
	[102] = { Cost = 2000, Type = "hat", AdminOnly = false, Desc = "", Key = "Ammo Hoarder", ID = 102, Sell = 0, Requires = 0, Name = "Ammo Hoarder",  },
	[103] = { Cost = 2000, Type = "hat", AdminOnly = false, Desc = "", Key = "Stoner", ID = 103, Sell = 0, Requires = 0, Name = "Stone Head",  },
	[104] = { Cost = 2000, Type = "hat", AdminOnly = false, Desc = "", Key = "BreenHead", ID = 104, Sell = 0, Requires = 0, Name = "Traffic Stop",  },
--	[105] = { Cost = , Type = "hat", AdminOnly = false, Desc = "", Key = "", ID = 105, Sell = 0, Requires = 0, Name = "",  },
--	[106] = { Cost = , Type = "hat", AdminOnly = false, Desc = "", Key = "", ID = 106, Sell = 0, Requires = 0, Name = "",  },
--	[107] = { Cost = , Type = "hat", AdminOnly = false, Desc = "", Key = "", ID = 107, Sell = 0, Requires = 0, Name = "",  },
--	[108] = { Cost = , Type = "hat", AdminOnly = false, Desc = "", Key = "", ID = 108, Sell = 0, Requires = 0, Name = "",  },
--	[109] = { Cost = , Type = "hat", AdminOnly = false, Desc = "", Key = "", ID = 109, Sell = 0, Requires = 0, Name = "",  },
--	[110] = { Cost = , Type = "hat", AdminOnly = false, Desc = "", Key = "", ID = 110, Sell = 0, Requires = 0, Name = "",  },


}

PureHats = {}

for i, tbl in pairs(shopData) do
	if tbl.Type == "hat" then
		PureHats[tbl.Key] = true
	end
end

hats = {
	["buckethat"] = {
		["1"] = { type = "Model", model = "models/props_junk/MetalBucket01a.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(6.15, 1.712, -0.144), angle = Angle(90, 0, 0), size = Vector(0.731, 0.731, 0.731), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["homburg"] = {
		["1"] = { type = "Model", model = "models/katharsmodels/hats/homburg/homburg.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(4.55, 0, 0), angle = Angle(-1.895, -82.101, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["tophat"] = {
		["1"] = { type = "Model", model = "models/tophat/tophat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(4.681, 0.731, 0), angle = Angle(-90, 0.856, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["piratehat"] = {
		["1"] = { type = "Model", model = "models/piratehat/piratehat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(5.093, 0, 0), angle = Angle(2.4, 105.175, 90), size = Vector(1.049, 1.049, 1.049), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["greenshat"] = {
		["1"] = { type = "Model", model = "models/greenshat/greenshat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(5.093, 0, 0), angle = Angle(2.4, 105.175, 90), size = Vector(1.049, 1.049, 1.049), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["santahat"] = {
		["1"] = { type = "Model", model = "models/cloud/kn_santahat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.457, 0, 0), angle = Angle(90, -90, 0), size = Vector(1.049, 1.049, 1.049), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["mask"] = {
		["1"] = { type = "Model", model = "models/Items/combine_rifle_ammo01.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(1.125, -0.838, 0), angle = Angle(90, 90, 0), size = Vector(0.805, 0.805, 0.805), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["ushat"] = {
		["1"] = { type = "Model", model = "models/props/cs_office/Snowman_hat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(5.031, -1.257, 0), angle = Angle(-90, 31.011, 0), size = Vector(0.824, 0.824, 0.824), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["roboteye"] = {
		["1"] = { type = "Model", model = "models/props/cs_office/projector.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(1.375, 2.469, 0), angle = Angle(-90, 8.869, 0), size = Vector(0.563, 0.563, 0.563), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["borghat"] = {
		["1"] = { type = "Model", model = "models/Manhack.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(7.198, -0.094, 0), angle = Angle(-127.388, 90, 90), size = Vector(1.019, 1.019, 1.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["pothat"] = {
		["1"] = { type = "Model", model = "models/props_interiors/pot02a.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(5.506, -5.282, 0), angle = Angle(-90, -170.381, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["sombrero"] = {
		["1"] = { type = "Model", model = "models/props_junk/sawblade001a.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(5.824, 0, 0), angle = Angle(90, 10.968, 0), size = Vector(0.606, 0.606, 0.606), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["melonhead"] = {
		["1"] = { type = "Model", model = "models/props_junk/watermelon01.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(3.049, 1.2, 0.305), angle = Angle(0, 0, 69.163), size = Vector(0.856, 0.856, 0.856), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["bunnyears"] = {
		["1"] = { type = "Model", model = "models/bunnyears/bunnyears.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(7.519, 0, 0), angle = Angle(-180, 108.094, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["monitor"] = {
		["1"] = { type = "Model", model = "models/props_lab/monitor02.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-3.164, 0.625, 0), angle = Angle(180, 90, 90), size = Vector(0.569, 0.569, 0.569), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["skull"] = {
		["1"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(3.674, 1.468, 0), angle = Angle(180, 77.625, 90), size = Vector(1.562, 1.562, 1.562), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2+"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(4.168, -2.162, 1.088), size = { x = 7.1, y = 7.1 }, color = Color(255, 255, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["2"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(3.956, 2.026, 1.088), size = { x = 7.1, y = 7.1 }, color = Color(255, 255, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
	},
	["crab"] = {
		["1"] = { type = "Model", model = "models/Nova/w_headcrab.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.537, 0.4, 0), angle = Angle(90, -90, 0), size = Vector(0.861, 0.861, 0.861), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["egg"] = {
		["1"] = { type = "Model", model = "models/props_phx/misc/egg.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-2.507, 4.212, 0), angle = Angle(-90, 18.35, 0), size = Vector(7.905, 7.905, 7.905), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["pumpkin"] = {
		["1"] = { type = "Model", model = "models/props_outland/pumpkin01.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(2.019, 0, 0), angle = Angle(0, 96.212, 90), size = Vector(0.912, 0.912, 0.912), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["snowhat"] = {
		["1"] = { type = "Model", model = "models/props/cs_office/snowman_face.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(2.525, 1.687, 0), angle = Angle(90, -180, 0), size = Vector(1.055, 1.055, 1.055), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["present"] = {
		["1"] = { type = "Model", model = "models/effects/bday_gib01.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(4.487, 0.725, 0), angle = Angle(-90, 7.086, 0), size = Vector(0.768, 0.768, 0.768), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["rpresent"] = {
		["1"] = { type = "Model", model = "models/effects/bday_gib02.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.801, 0, 0), angle = Angle(90, 180, 0), size = Vector(1.174, 0.744, 1.174), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["techeyes"] = {
		["1"] = { type = "Model", model = "models/props_combine/combine_light002a.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(4.282, 4.638, -2.914), angle = Angle(0, 105.625, 0), size = Vector(0.135, 0.172, 0.153), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["cleaver"] = {
		["1"] = { type = "Model", model = "models/props_lab/Cleaver.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(9.114, -5.792, -3.1), angle = Angle(-33.514, 82.587, 68.824), size = Vector(0.544, 0.544, 0.544), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["magnlamp"] = {
		["1"] = { type = "Model", model = "models/props_c17/light_magnifyinglamp02.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(3.736, 3.793, 0), angle = Angle(-49.095, -62.531, 0), size = Vector(0.18, 0.18, 0.18), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["scannerhelm"] = {
		["1"] = { type = "Model", model = "models/Gibs/Shield_Scanner_Gib3.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(6.599, -1.344, 0.675), angle = Angle(0, -93.638, -102.963), size = Vector(0.662, 0.662, 0.662), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["chef"] = {
		["1"] = { type = "Model", model = "models/chefHat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(4.311, -0.801, 0.126), angle = Angle(-180, -60.5, -89.213), size = Vector(1.169, 1.013, 0.843), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["combinehelm"] = {
		["1"] = { type = "Model", model = "models/Nova/w_headgear.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.037, 0.187, -0.013), angle = Angle(90, -80.687, 0), size = Vector(0.979, 0.979, 0.979), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["termeye"] = {
		["1"] = { type = "Model", model = "models/Gibs/manhack_gib03.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(4.206, 2.404, 1.812), angle = Angle(0, -76.82, 90), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(3.868, 0.388, 0.699), size = { x = 4.212, y = 4.212 }, color = Color(255, 255, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
	},
	["fez"] = {
		["1"] = { type = "Model", model = "models/props_junk/terracotta01.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(8.781, -1.196, -3.014), angle = Angle(-59.658, -180, -16.302), size = Vector(0.175, 0.175, 0.194), color = Color(188, 0, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["beard"] = {
		["1"] = { type = "Model", model = "models/player/items/demo/demo_beardpipe.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-1.32, 1.054, 0), angle = Angle(0, -74.849, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, particle = {"cig_burn","drg_pipe_smoke"}, particleatt = "cig_drg_smoke" }
	},
	["cigar"] = {
		["1"] = { type = "Model", model = "models/player/items/soldier/cigar.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.93, -0.127, -0.681), angle = Angle(0, -90, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, particle = {"drg_pipe_smoke"}, particleatt = "cig_drg_smoke" }
	},
	["wbeanie"] = {
		["1"] = { type = "Model", model = "models/player/items/pyro/pyro_beanie.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-73.206, 6.395, 0), angle = Angle(0, -80.63, -90), size = Vector(1.036, 1.036, 1.036), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["hellsing"] = {
		["1"] = { type = "Model", model = "models/player/items/sniper/hwn_sniper_hat.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-71.588, 26.731, -6.08), angle = Angle(3.259, -73.843, -85.499), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["beanie"] = {
		["1"] = { type = "Model", model = "models/player/items/scout/beanie.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-82.501, 27.982, 0), angle = Angle(0, -71.333, -90), size = Vector(1.195, 1.195, 1.195), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["normalhat"] = {
		["1"] = { type = "Model", model = "models/player/items/all_class/hm_disguisehat_scout.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.018, 0.717, 0), angle = Angle(0, -70.433, -90), size = Vector(1.042, 1.042, 1.042), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["medhelm"] = {
		["1"] = { type = "Model", model = "models/player/items/medic/fwk_medic_stahlhelm.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(1.151, -1.522, 0), angle = Angle(0, -78.809, -90), size = Vector(1.085, 1.085, 1.085), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["wintercap"] ={
		["1"] = { type = "Model", model = "models/player/items/all_class/all_earwarmer_demo.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.325, 0.836, 0), angle = Angle(0.527, -69.86, -90), size = Vector(1.044, 1.044, 1.044), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["socold"] = {
		["1"] = { type = "Model", model = "models/player/items/pyro/winter_pyro_mask.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-11.351, 0.377, 0), angle = Angle(0, -69.926, -90), size = Vector(1.169, 1.169, 1.169), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["winterhood"] = {
		["1"] = { type = "Model", model = "models/player/items/sniper/winter_sniper_hood.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-11.25, 6.46, 0), angle = Angle(0, -78.959, -90), size = Vector(1.034, 1.034, 1.034), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["skihat"] = {
		["1"] = { type = "Model", model = "models/player/items/soldier/soldier_skihat_s1.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(3.828, 0.705, 0), angle = Angle(0, -82.066, -90), size = Vector(1.014, 1.014, 1.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["hall"] = {
		["1"] = { type = "Model", model = "models/player/items/demo/hallmark.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.393, 0, 0), angle = Angle(0, -75.812, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["copgl"] = {
		["1"] = { type = "Model", model = "models/player/items/heavy/cop_glasses.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-1.244, -0.419, 0), angle = Angle(0, -71.531, -90), size = Vector(1, 0.962, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["sidebrn"] = {
		["1"] = { type = "Model", model = "models/player/items/all_class/winter_sideburns_medic.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.239, 0.344, 0), angle = Angle(-90, -56.035, 0), size = Vector(1.044, 1.044, 1.044), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {} }
	},
	["BurgerBuns"] = { --Made by Duby
	   ["hat2"] = { type = "Model", model = "models/food/burger.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(2.273, -1.364, 11.364), angle = Angle(-180, 17.385, -1.024), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
       ["hat1"] = { type = "Model", model = "models/food/burger.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(2.273, -1.364, -10.455), angle = Angle(0, 17.385, -1.024), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	},
	["RoboEars"] = { --Made by Duby 
	  ["belt"] = { type = "Model", model = "models/gibs/scanner_gib01.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(1.363, -9.546, 0), angle = Angle(180, 99.205, 97.158), size = Vector(0.72, 0.72, 0.72), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
      ["devider"] = { type = "Model", model = "models/gibs/scanner_gib05.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-1.364, -5, -0.456), angle = Angle(0, 0, 0), size = Vector(0.379, 0.379, 0.379), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	},
	["Helihead"] = {
		["head2"] = { type = "Model", model = "models/props_citizen_tech/windmill_blade004a.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(4.091, -3.182, 1.363), angle = Angle(5.113, 25.568, 0), size = Vector(0.094, 0.094, 0.094), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["spotlight"] = {
		["spotlight"] = { type = "Model", model = "models/props_wasteland/light_spotlight01_lamp.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(2.872, 1.33, -2.777), angle = Angle(0.98, -81.212, 0), size = Vector(0.736, 0.736, 0.736), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["motorhead"] = {
		["Motorhead2"] = { type = "Model", model = "models/maxofs2d/thruster_propeller.mdl", bone = "ValveBiped.Bip01_Head1", rel = "Motorhead", pos = Vector(-0.002, 1.307, 1.121), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Motorhead"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(4.013, 0.56, -0.028), angle = Angle(-95.013, 0, 0), size = Vector(0.584, 0.584, 0.584), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["gyrohead"] = {
		["Gyrohead"] = { type = "Model", model = "models/maxofs2d/hover_rings.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(2.401, 0.115, 0.144), angle = Angle(0, 0, 0), size = Vector(0.896, 0.896, 0.896), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["brightidea"] = {
		["Bright Idea"] = { type = "Model", model = "models/props/de_inferno/ceiling_light.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(22.645, -2.847, 1.465), angle = Angle(-90.204, 11.878, 0), size = Vector(0.703, 0.703, 0.703), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["lampshade"] = {
		["Lampshade"] = { type = "Model", model = "models/props_c17/lampShade001a.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(4.848, 0.773, 0.765), angle = Angle(-86.463, 0, 0), size = Vector(0.82, 0.82, 0.82), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["tinfoil"] = {
		["Tinfoil hat"] = { type = "Model", model = "models/props_wasteland/prison_lamp001c.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(8.314, 0.912, 0.081), angle = Angle(-87.541, 0, 0), size = Vector(0.686, 0.686, 0.686), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/cube", skin = 0, bodygroup = {} }
	},
	["roadlock"] = {
		["Roadblock"] = { type = "Model", model = "models/props_junk/TrafficCone001a.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(14.961, 0.465, 0.547), angle = Angle(-86.75, 0, 0), size = Vector(0.746, 0.746, 0.746), color = Color(255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	},
	["combinething"] = {
		["Combinething"] = { type = "Model", model = "models/Items/combine_rifle_ammo01.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-7.296, 0.967, 0.899), angle = Angle(-95.742, 0, 0), size = Vector(1.218, 1.218, 1.218), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	},
	["fence"] = {
		["Fence+"] = { type = "Model", model = "models/props_c17/handrail04_corner.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-5.862, 0.086, -1.081), angle = Angle(89.017, 164.348, 11.123), size = Vector(0.374, 0.374, 0.374), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Fence"] = { type = "Model", model = "models/props_c17/handrail04_corner.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-5.492, -0.788, 0.683), angle = Angle(-92.766, 0, 0), size = Vector(0.374, 0.374, 0.374), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	},
	["noveltyhead"] = {
		["Head"] = { type = "Model", model = "models/maxofs2d/balloon_gman.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-8.36, -0.35, 0.699), angle = Angle(-5.183, -86.738, -90.665), size = Vector(0.935, 0.935, 0.935), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	},
	["noveltyhead2"] = {
		["Head"] = { type = "Model", model = "models/maxofs2d/balloon_mossman.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-6.347, 0.15, 0.291), angle = Angle(-5.183, -86.738, -90.665), size = Vector(0.935, 0.935, 0.935), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["steamhead"] = {
		["Head2"] = { type = "Model", model = "models/props_pipes/valve003.mdl", bone = "ValveBiped.Bip01_Head1", rel = "Head", pos = Vector(1.958, 0.052, 2.691), angle = Angle(-92.111, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Head3"] = { type = "Model", model = "models/props_pipes/valve003.mdl", bone = "ValveBiped.Bip01_Head1", rel = "Head2", pos = Vector(0.407, -0.657, -4.515), angle = Angle(180, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Head"] = { type = "Model", model = "models/props_pipes/valvewheel001.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.667, 0.819, -0.392), angle = Angle(-88.527, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	--[""] = {
	--},
	["BreenHead"] = {
	["Breenhead"] = { type = "Model", model = "models/props_phx/misc/t_light_head.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-1.826, 1.641, 0.723), angle = Angle(5.691, -83.58, -91.034), size = Vector(0.634, 0.634, 0.634), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	
	["Stoner"] = {
	["actualbreenhead2"] = { type = "Model", model = "models/props_combine/breenbust_chunk04.mdl", bone = "ValveBiped.Bip01_Head1", rel = "actualbreenhead", pos = Vector(0.532, 0.522, 0.621), angle = Angle(0, 0, 0), size = Vector(0.953, 0.953, 0.953), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["actualbreenhead"] = { type = "Model", model = "models/props_combine/breenbust_chunk02.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-5.883, 2.135, -0.726), angle = Angle(-8.009, -73.658, -86.703), size = Vector(0.995, 0.995, 0.995), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	
	["Ammo Hoarder"] = {
	["AmmoBoxes2+++++"] = { type = "Model", model = "models/weapons/rifleshell.mdl", bone = "ValveBiped.Bip01_Spine", rel = "", pos = Vector(-1.576, -6.822, 3.306), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["AmmoBoxes2++++"] = { type = "Model", model = "models/weapons/rifleshell.mdl", bone = "ValveBiped.Bip01_Spine", rel = "", pos = Vector(-1.576, -7.906, 2.009), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["AmmoBoxes2"] = { type = "Model", model = "models/weapons/rifleshell.mdl", bone = "ValveBiped.Bip01_Spine", rel = "", pos = Vector(-1.339, -6.717, -4.428), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["AmmoBoxes2+++"] = { type = "Model", model = "models/weapons/rifleshell.mdl", bone = "ValveBiped.Bip01_Spine", rel = "", pos = Vector(-1.576, -7.906, 0.486), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["AmmoBoxes2++"] = { type = "Model", model = "models/weapons/rifleshell.mdl", bone = "ValveBiped.Bip01_Spine", rel = "", pos = Vector(-1.576, -7.906, -1.433), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["AmmoBoxes2+"] = { type = "Model", model = "models/weapons/rifleshell.mdl", bone = "ValveBiped.Bip01_Spine", rel = "", pos = Vector(-1.339, -7.523, -3.014), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["AmmoBoxes+"] = { type = "Model", model = "models/props_junk/TrashDumpster01a.mdl", bone = "ValveBiped.Bip01_Spine", rel = "", pos = Vector(-1.504, -3.793, 8.715), angle = Angle(83.204, 87.482, 88.873), size = Vector(0.145, 0.145, 0.145), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["AmmoBoxes2++++++"] = { type = "Model", model = "models/weapons/rifleshell.mdl", bone = "ValveBiped.Bip01_Spine", rel = "", pos = Vector(-1.576, -5.645, 4.77), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["AmmoBoxes"] = { type = "Model", model = "models/props_junk/TrashDumpster01a.mdl", bone = "ValveBiped.Bip01_Spine", rel = "", pos = Vector(-1.236, -1.321, -8.018), angle = Angle(83.204, 90.222, 88.873), size = Vector(0.145, 0.145, 0.145), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	
	
}



hats_old = {
	["buckethat"] = { Model = "models/props_junk/MetalBucket01a.mdl", Pos = Vector(5.2,-2,0), Ang = Angle(0,20,90) },
	["homburg"] = { Model = "models/katharsmodels/hats/homburg/homburg.mdl", Pos = Vector(3,0,0), Ang = Angle(-90,0,-70) },
	["tophat"] = { Model = "models/tophat/tophat.mdl", Pos = Vector(4.1,0.5,0), Ang = Angle(90,0,-75) },
	["piratehat"] = { Model = "models/piratehat/piratehat.mdl", Pos = Vector(4.1,0.5,0), Ang = Angle(90,0,-105) },
	["greenshat"] = { Model = "models/greenshat/greenshat.mdl", Pos = Vector(4.1,0.5,0), Ang = Angle(90,0,-105) },
	["santahat"] = { Model = "models/cloud/kn_santahat.mdl", Pos = Vector(0.5,-0.4,0), Ang = Angle(0,270,90), CombPos = Vector(0.5,-0.4,0) },
	["mask"] = { Model = "models/Items/combine_rifle_ammo01.mdl", Pos = Vector(0,1,0), Ang = Angle(-90,0,170) },
	["ushat"] = { Model = "models/props/cs_office/Snowman_hat.mdl", Pos = Vector(3.5,-2.3,0), Ang = Angle(0,50,-90), CombPos = Vector(3.8,-2.2,0), CSSPos = Vector(6.2,-2,0) },
	["roboteye"] = { Model = "models/props/cs_office/projector.mdl", Pos = Vector(0,0.5,0.5), Ang = Angle(0,0,-90), CombPos = Vector(0,0.5,0.5), CSSPos = Vector(1,0.5,0.5)  },
	["borghat"] = { Model = "models/Manhack.mdl", Pos = Vector(7,-1.8,0), Ang = Angle(-90,0,-70), CombPos = Vector(7.5,-1.8,0), CSSPos = Vector(8.2,-1.8,0) },
	["pothat"] = { Model = "models/props_interiors/pot02a.mdl", Pos = Vector(5.8,0.5,-5.2), Ang = Angle(90,0,80), CombPos = Vector(7.7,-1.2,-5.2), CSSPos = Vector(9,0.3,-5.2) },
	["sombrero"] = { Model = "models/props_junk/sawblade001a.mdl", Pos = Vector(4.6,0.5,0), Ang = Angle(-90,0,-75) },
	["melonhead"] = { Model = "models/props_junk/watermelon01.mdl", Pos = Vector(4.1,0.5,0), Ang = Angle(0,0,0), CombPos = Vector(4.1,0.5,0), CSSPos = Vector(4.1,0.5,0) },
	["bunnyears"] = { Model = "models/bunnyears/bunnyears.mdl", Pos = Vector(6.4,0.5,0), Ang = Angle(-90,0,-105) },
	["monitor"] = { Model = "models/props_lab/monitor02.mdl", Pos = Vector(-3.5,0.5,0.8), Ang = Angle(90,180,90), CombPos = Vector(-3.5,0.5,0.8), CSSPos = Vector(-3.5,0.5,0.8), ScaleVector = Vector (0.7,0.7,0.7)  },
	["skull"] = { Model = "models/Gibs/HGIBS.mdl", Pos = Vector(2.5,0,0), Ang = Angle(90,180,90), CombPos = Vector(3,0,0), CSSPos = Vector(3,0,0),ScaleVector = Vector (1.8,1.8,1.8) },	
	["crab"] = { Model = "models/Nova/w_headcrab.mdl", Pos = Vector(-2.5,0,0), Ang = Angle(0,-90,90), CombPos = Vector(-2,0,0), CSSPos = Vector(0.2,0,0),ScaleVector = Vector (1.1,1.1,1.1) },	
	["egg"] = { Model = "models/props_phx/misc/egg.mdl", Pos = Vector(-3,1.5,0), Ang = Angle(0,-180,90), CombPos = Vector(-3,1.2,0), CSSPos = Vector(-3,1.1,0),ScaleVector = Vector (0.5,0.5,0.5) },	
	["pumpkin"] = { Model = "models/props_outland/pumpkin01.mdl", Pos = Vector(4.1,0.5,0), Ang = Angle(0,-180,90), CombPos = Vector(4.1,0.5,0), CSSPos = Vector(4.1,0.5,0) },	
	["snowhat"] = { Model = "models/props/cs_office/snowman_face.mdl", Pos = Vector(4.1,0.5,0), Ang = Angle(0,-180,90), CombPos = Vector(4.1,0.5,0), CSSPos = Vector(4.1,0.5,0), ScaleVector = Vector (1.3,1.3,1.3) },					
	["present"] = { Model = "models/effects/bday_gib01.mdl", Pos = Vector(4.1,0.5,0), Ang = Angle(0,-180,90), CombPos = Vector(4.1,0.5,0), CSSPos = Vector(4.1,0.5,0) },
	["rpresent"] = { Model = "models/effects/bday_gib02.mdl", Pos = Vector(-2,0.5,0), Ang = Angle(0,-180,90), CombPos = Vector(-2,0.5,0), CSSPos = Vector(-2,0.5,0), ScaleVector = Vector (1.5,1.5,1.5)  },	
	["techeyes"] = { Model = "models/props_combine/combine_light002a.mdl", Pos = Vector(3.18, 4.012, -3.462), Ang = Angle(0, 90, 0), ScaleVector = Vector(0.174, 0.231, 0.174), SCK = true},
	["cleaver"] = { Model = "models/props_lab/Cleaver.mdl", Pos = Vector(10.187, -3.306, 3.98), Ang = Angle(123.305, -156.868, -3.119), ScaleVector = Vector(0.5, 0.5, 0.5), SCK = true},
	["magnlamp"] = { Model = "models/props_c17/light_magnifyinglamp02.mdl", Pos = Vector(2.911, 4.23, 0.238), Ang = Angle(-59.276, -53.07, -0.489), ScaleVector = Vector(0.194, 0.194, 0.194), SCK = true},
	["scannerhelm"] = { Model = "models/Gibs/Shield_Scanner_Gib3.mdl", Pos = Vector(5.711, 0.667, 1.105), Ang = Angle(173.292-90, 62.006+90, 87.013+33), ScaleVector = Vector(0.688, 0.688, 0.688), SCK = true},
}



suits = {


	["greenssuit"] = {
		--["1"] = { type = "Model", model = "models/weapons/w_sledgehammer.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(13.043, 2.974, -7.763), angle = Angle(51.706, -14.294, 16.419), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	["suit2.3"] = { type = "Model", model = "models/props_combine/breenlight.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(1.363, -5, 0.455), angle = Angle(5.113, 97.158, 82.841), size = Vector(0.435, 0.435, 0.435), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["suit2.1"] = { type = "Model", model = "models/props_combine/combine_intmonitor003.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-2.274, -1.364, -2.274), angle = Angle(9.204, -105.342, 91.023), size = Vector(0.209, 0.209, 0.209), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["suit2"] = { type = "Model", model = "models/props_combine/combine_lock01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-8.636, 0.455, 1.363), angle = Angle(0, 80.794, 82.841), size = Vector(0.72, 0.72, 0.72), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["suit2.2"] = { type = "Model", model = "models/props_combine/combine_light002a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-8.636, -0.456, -4.092), angle = Angle(1.023, 80.794, 86.931), size = Vector(0.264, 0.264, 0.264), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }

	},
	
	["gravedigger"] = { --Thanks brain dawg
	
	["GraveDigger"] = { type = "Model", model = "models/props_c17/gravestone_coffinpiece001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-7.329, 3.148, 0), angle = Angle(2.003, -4.893, 88.582), size = Vector(0.216, 0.216, 0.216), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["GraveDigger3"] = { type = "Model", model = "models/weapons/v_fza.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "GraveDigger2", pos = Vector(0.649, -6.95, 10.17), angle = Angle(116.171, 7.475, -4.185), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["GraveDigger2"] = { type = "Model", model = "models/props_junk/shovel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "GraveDigger", pos = Vector(3.476, 2.934, 0), angle = Angle(-91.389, 133.335, 3.608), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["GraveDigger2+"] = { type = "Model", model = "models/props_junk/shovel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "GraveDigger", pos = Vector(3.476, -1.982, 0.048), angle = Angle(-91.389, -127.024, 3.608), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }

	},
	
	["Combine"] = { --Thanks brain dawg
	
	["Combinesuit"] = { type = "Model", model = "models/props_combine/combine_dispenser.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-3.122, 8.189, 0.734), angle = Angle(-180, 103.22, 90.872), size = Vector(0.379, 0.379, 0.379), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Combinesuit3"] = { type = "Model", model = "models/props_combine/combine_teleportplatform.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Combinesuit", pos = Vector(-0.59, -0.806, -6.715), angle = Angle(0, 0, 0), size = Vector(0.134, 0.134, 0.134), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Combinesuit2+"] = { type = "Model", model = "models/props_combine/combine_light001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Combinesuit", pos = Vector(-0.889, 3.54, 3.464), angle = Angle(-4.244, -180, 0), size = Vector(0.303, 0.303, 0.303), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Combinesuit2"] = { type = "Model", model = "models/props_combine/combine_light001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Combinesuit", pos = Vector(-0.889, -4.875, 3.464), angle = Angle(-4.244, -180, 0), size = Vector(0.303, 0.303, 0.303), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	
	},
	
	["Rambo"] = { --Thanks brain dawg
	
	["Rambo5"] = { type = "Model", model = "models/weapons/w_katana.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "Rambo4", pos = Vector(1.899, -0.973, 11.468), angle = Angle(-2.427, 0, 0), size = Vector(0.735, 0.735, 0.735), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Rambo4"] = { type = "Model", model = "models/weapons/w_mach_m249para.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "Rambo3", pos = Vector(0.09, -1.209, -10.674), angle = Angle(0, 0, 0), size = Vector(0.843, 0.843, 0.843), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Rambo3"] = { type = "Model", model = "models/weapons/w_shot_xm1014.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "Rambo2", pos = Vector(1.628, 6.658, -1.53), angle = Angle(138.72, 77.566, 0), size = Vector(0.856, 0.856, 0.856), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Rambo2+"] = { type = "Model", model = "models/weapons/w_chainsaw.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-2.097, 4.592, -4.375), angle = Angle(0.032, 98.135, -43.984), size = Vector(0.474, 0.474, 0.474), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Rambo2"] = { type = "Model", model = "models/weapons/w_chainsaw.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-2.889, 4.27, 6.258), angle = Angle(3.181, 93.208, 41.905), size = Vector(0.488, 0.488, 0.488), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }

	
	},
	
	["freeman"] = { --Thanks brain dawg
	
	["Freeman Suit3"] = { type = "Model", model = "models/props_lab/hevplate.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "Freeman Suit2", pos = Vector(4.784, 1.077, -1.326), angle = Angle(88.183, 3.644, -59.925), size = Vector(0.642, 0.642, 0.642), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Freeman Suit"] = { type = "Model", model = "models/weapons/w_crowbar.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(0.634, 2.934, -1.288), angle = Angle(145.16, 0, 0), size = Vector(0.822, 0.822, 0.822), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Freeman Suit2"] = { type = "Model", model = "models/weapons/w_physics.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "Freeman Suit", pos = Vector(0.358, 1.312, -5.443), angle = Angle(91.292, -5.927, 91.043), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }

	
	},
	
	["pistolsuit"] = { --Thanks Pistol mags
	
	["things+"] = { type = "Model", model = "models/props_lighting/light_porch.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(0.518, 5.714, -10.91), angle = Angle(90, -106.364, -90), size = Vector(0.301, 0.301, 0.301), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["electro++"] = { type = "Model", model = "models/props_hydro/2pipe_straight_256.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-4.676, 4.675, -0.519), angle = Angle(1.169, -15.195, -1.17), size = Vector(0.107, 0.107, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["electro+"] = { type = "Model", model = "models/props_hydro/3pipe_straight_256.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-4.676, 1.557, -0.519), angle = Angle(-92.338, -106.364, -92.338), size = Vector(0.172, 0.172, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["electro+++"] = { type = "Model", model = "models/props_hydro/3pipe_jog_64.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-2.597, 5.714, -7.792), angle = Angle(1.169, -17.532, -1.17), size = Vector(0.107, 0.107, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["electro++++"] = { type = "Model", model = "models/props_hydro/3pipe_turn_90.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(4.675, 6.752, 9.869), angle = Angle(1.169, -17.532, -1.17), size = Vector(0.107, 0.107, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["things"] = { type = "Model", model = "models/props_lighting/lightfixture05.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-7.792, 3.7, 3), angle = Angle(-1.17, -104.027, 1.169), size = Vector(0.237, 0.237, 0.237), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["electro"] = { type = "Model", model = "models/z-o-m-b-i-e/st_electrohren.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-15.065, -0.519, -0.519), angle = Angle(-1.17, -106.364, -90), size = Vector(0.237, 0.237, 0.237), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["things++"] = { type = "Model", model = "models/props_lighting/light_porch.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(0.518, 5.714, -10.91), angle = Angle(90, -106.364, -90), size = Vector(0.301, 0.301, 0.301), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	
	},
	
	
	["officesuit"] = {
	
	["Suit"] = { type = "Model", model = "models/props_lab/harddrive02.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-4.585, 7.106, 4.994), angle = Angle(-84.15, 165.962, -5.211), size = Vector(0.333, 0.333, 0.333), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Suit7"] = { type = "Model", model = "models/props_combine/breenchair.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "Suit6", pos = Vector(3.779, 1.302, -9.386), angle = Angle(5.098, -173.189, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Suit3"] = { type = "Model", model = "models/props_combine/breenglobe.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "Suit4", pos = Vector(2.457, 4.105, 8.534), angle = Angle(1.511, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Suit6"] = { type = "Model", model = "models/props_combine/breenclock.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "Suit5", pos = Vector(-0.686, 4.942, 0.56), angle = Angle(24.391, 16.781, -1.037), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Suit4"] = { type = "Model", model = "models/props_combine/breendesk.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "Suit2", pos = Vector(3.786, -3.791, -11.171), angle = Angle(4.553, 180, -0.101), size = Vector(0.207, 0.207, 0.207), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Suit2"] = { type = "Model", model = "models/props_lab/monitor01a.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "Suit", pos = Vector(-1.583, -3.47, -0.445), angle = Angle(-2.797, 5.784, -90.705), size = Vector(0.222, 0.222, 0.222), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Suit5"] = { type = "Model", model = "models/props_lab/huladoll.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "Suit3", pos = Vector(-5.527, 1.838, -1.658), angle = Angle(-8.636, 156.192, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }

	},
	
	["medicsuit"] = {
		["1"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(-7.432, -1.969, -2.287), angle = Angle(-3.362, 180, -85.087), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["3"] = { type = "Model", model = "models/weapons/w_eq_eholster_elite.mdl", bone = "ValveBiped.Bip01_L_Thigh", rel = "", pos = Vector(11.281, -1.507, 2.78), angle = Angle(18.736, -92.639, 94.268), size = Vector(0.718, 0.718, 0.718), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/items/healthkit.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(6.775, 3.068, 2.299), angle = Angle(2.375, 171.6, -74.189), size = Vector(0.688, 0.688, 0.688), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["5"] = { type = "Model", model = "models/weapons/w_rif_sg552.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-3.22, 2.112, -6.369), angle = Angle(-1.589, -3.97, 26.544), size = Vector(0.593, 0.593, 0.593), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["4"] = { type = "Model", model = "models/weapons/w_defuser.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(0.723, 1.593, -6.757), angle = Angle(98.436, -92.312, 0.13), size = Vector(0.763, 0.763, 0.763), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["meleesuit"] = {
		["1"] = { type = "Model", model = "models/weapons/w_crowbar.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(0.418, 3.405, 1.769), angle = Angle(150.555, -0.988, -39.144), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["3"] = { type = "Model", model = "models/weapons/w_knife_ct.mdl", bone = "ValveBiped.Bip01_L_Thigh", rel = "", pos = Vector(5.935, 3.595, 1.768), angle = Angle(157.486, -126.381, -75.176), size = Vector(0.705, 0.705, 0.705), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/weapons/w_axe.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-2.632, 3.693, -3.856), angle = Angle(53.894, -180, 0), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["5"] = { type = "Model", model = "models/Items/grenadeAmmo.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "4", pos = Vector(3.437, 6.061, 0), angle = Angle(0.405, 0, 0), size = Vector(0.563, 0.563, 0.563), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["4"] = { type = "Model", model = "models/weapons/w_defuser.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(-5.08, -1.201, -5.888), angle = Angle(48.2, -6.587, -84.014), size = Vector(0.669, 0.669, 0.669), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["5+"] = { type = "Model", model = "models/Items/grenadeAmmo.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "4", pos = Vector(5.537, 6.567, 0), angle = Angle(0.405, 0, 0), size = Vector(0.563, 0.563, 0.563), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["techsuit"] = {
		["1"] = { type = "Model", model = "models/combine_turrets/floor_turret.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-24.925, -0.625, -4.42), angle = Angle(-97.112, 176.037, -173.445), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/Combine_Turrets/Floor_turret/floor_turret_citizen4", skin = 0, bodygroup = {} },
		["3"] = { type = "Model", model = "models/Weapons/w_annabelle.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(4.756, 3.042, 3.18), angle = Angle(7.794, 179.805, -171.65), size = Vector(0.794, 0.794, 0.794), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/weapons/w_pistol.mdl", bone = "ValveBiped.Bip01_L_Thigh", rel = "", pos = Vector(9.519, 2.732, 3.036), angle = Angle(1.743, 180, -103.357), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["5"] = { type = "Model", model = "models/props_combine/combine_light002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "4", pos = Vector(2.47, 0.025, 3.65), angle = Angle(0, -180, 0), size = Vector(0.059, 0.109, 0.109), color = Color(155, 155, 155, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["4"] = { type = "Model", model = "models/props_combine/combine_teleportplatform.mdl", bone = "ValveBiped.Bip01_R_Forearm", rel = "", pos = Vector(1.238, 0.194, 0.018), angle = Angle(-90.595, 0, 0), size = Vector(0.05, 0.05, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["supportsuit"] = {
		["1"] = { type = "Model", model = "models/props_debris/wood_board06a.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-0.47, 3.956, 3.206), angle = Angle(-169.258, -88.006, -90.407), size = Vector(0.4, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["3"] = { type = "Model", model = "models/Weapons/w_shotgun.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-3.5, 3.312, -4.514), angle = Angle(-4.051, 4.175, 11.831), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/items/boxsrounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(-1.619, 3.493, 0), angle = Angle(0, 0, -88.551), size = Vector(0.481, 0.768, 0.723), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["5"] = { type = "Model", model = "models/items/crossbowrounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "2", pos = Vector(0.361, 7.593, 3.305), angle = Angle(-85.857, 14.081, -27.32), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["4"] = { type = "Model", model = "models/weapons/w_hammer.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(-7.551, -0.163, -1.089), angle = Angle(-78.883, 3.611, 98.086), size = Vector(0.669, 0.669, 0.669), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["assaultsuit"] = {
		["1"] = { type = "Model", model = "models/weapons/w_rif_ak47.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-5.462, 1.725, 4.068), angle = Angle(-2.406, -8.273, 164.861), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["6+"] = { type = "Model", model = "models/Weapons/Shotgun_shell.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "3", pos = Vector(2.657, 6.25, 0.03), angle = Angle(-93.906, 10.026, 0), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["3"] = { type = "Model", model = "models/weapons/w_defuser.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(-6.613, 1.618, -3.718), angle = Angle(22.743, -0.019, -92.306), size = Vector(0.656, 0.656, 0.656), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/weapons/w_pist_deagle.mdl", bone = "ValveBiped.Bip01_L_Thigh", rel = "", pos = Vector(6.625, -1.576, 2.086), angle = Angle(3.819, -0.094, 84.574), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["5"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "4", pos = Vector(4.418, 3.562, 0.88), size = { x = 6.493, y = 6.493 }, color = Color(255, 255, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["4"] = { type = "Model", model = "models/Weapons/w_package.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(4.487, -2.833, 7.948), angle = Angle(-3.175, -6.601, -29.331), size = Vector(0.75, 0.75, 0.75), color = Color(115, 115, 115, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["6++"] = { type = "Model", model = "models/Weapons/Shotgun_shell.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "3", pos = Vector(3.763, 6.432, 0.03), angle = Angle(-93.906, 10.026, 0), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["6"] = { type = "Model", model = "models/Weapons/Shotgun_shell.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "3", pos = Vector(1.544, 5.943, 0.03), angle = Angle(-93.906, 10.026, 0), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
	["stalkersuit"] = {
		["4"] = { type = "Model", model = "models/weapons/w_eq_eholster_elite.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(7.691, 2.102, 1.12), angle = Angle(78.029, 95.286, -180), size = Vector(0.874, 0.874, 0.874), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["3+"] = { type = "Model", model = "models/weapons/w_defuser.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(-5.52, 0.703, -4.053), angle = Angle(22.438, 7.679, -92.752), size = Vector(0.839, 0.839, 0.839), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["5"] = { type = "Model", model = "models/props_junk/GlassBottle01a.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(-5.665, -0.12, 2.918), angle = Angle(2.697, 0.115, -90.807), size = Vector(0.742, 0.742, 0.742), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/props_combine/suit_charger001.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-2.362, 1.274, -1.663), angle = Angle(-11.079, -90.47, -94.134), size = Vector(0.54, 0.54, 0.54), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["3"] = { type = "Model", model = "models/weapons/w_defuser.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(4.645, 0.118, -5.936), angle = Angle(117.144, 7.679, -92.752), size = Vector(0.839, 0.839, 0.839), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/Weapons/W_crossbow.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-2.425, 2.528, 1.911), angle = Angle(-1.489, -1.742, 79.861), size = Vector(0.689, 0.689, 0.689), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
}
