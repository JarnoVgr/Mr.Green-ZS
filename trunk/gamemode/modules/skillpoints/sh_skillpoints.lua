-- Nothing to see here yet
-- Blah blah blah... I need some ideas D:
-- Main table where you can add skillshots

SkillPointsTable = {}
-- Skillpoints for humans
SkillPointsTable["Humans"] = {}
--Some hidden skillshots that doesnt need to be drawed
SkillPointsTable["Humans"]["zombiekill"] = {Name = "Zombie down", Description = "Kill a zombie",Color = "LightGrey", Points = 15}
SkillPointsTable["Humans"]["headcrabkill"] = {Name = "Headcrab down", Description = "Kill a headcrab",Color = "LightGrey", Points = 5}
SkillPointsTable["Humans"]["poisonzombiekill"] = {Name = "P. zombie down", Description = "Kill a poison zombie",Color = "LightGrey", Points = 25}
SkillPointsTable["Humans"]["howlerkill"] = {Name = "Howler down", Description = "Kill a howler",Color = "LightGrey", Points = 10}
SkillPointsTable["Humans"]["zombinekill"] = {Name = "Zombine down", Description = "Kill a zombine",Color = "LightGrey", Points = 30}
SkillPointsTable["Humans"]["killassist"] = {Name = "Kill assist", Description = "",Color = "LightGrey", Points = 10}
SkillPointsTable["Humans"]["hkillassist"] = {Name = "Kill assist", Description = "",Color = "LightGrey", Points = 5}
--
SkillPointsTable["Humans"]["headshot"] = {Name = "Headshot", Description = "Title says it all",Color = "LightGrey", Points = 25}
SkillPointsTable["Humans"]["turretheadshot"] = {Name = "Mini headshot", Description = "Title says it all",Color = "LightGrey", Points = 5}
--SkillPointsTable["Humans"]["deadflight"] = {Name = "DEAD FLIGHT", Description = "Kill a fast zombie while he is in mid-air!",Color = "DarkBlue", Points = 300}
--SkillPointsTable["Humans"]["handsoff"] = {Name = "HANDS OFF", Description = "Tear away a hand from zombie!",Color = "LightGrey", Points = 15}
--SkillPointsTable["Humans"]["legssoff"] = {Name = "LEGLESS", Description = "Tear away a leg or legs from zombie!",Color = "LightGrey", Points = 15}
SkillPointsTable["Humans"]["decapitation"] = {Name = "DECAPITATION", Description = "There can be only one!",Color = "Red", Points = 30}
SkillPointsTable["Humans"]["meatshower"] = {Name = "Dismembered", Description = "Turn zombie into million pieces of delicious meat!",Color = "DarkRed", Points = 15}
--SkillPointsTable["Humans"]["sector"] = {Name = "SECTOR IS SECURED", Description = "Kill zombine with your turret!",Color = "DarkRed", Points = 200}
SkillPointsTable["Humans"]["hero"] = {Name = "Adrenaline", Description = "Get a kill as last human!",Color = "LightGrey", Points = 15}
--SkillPointsTable["Humans"]["naild"] = {Name = "KARMA NAIL'D", Description = "Kill a zombie with hammer!",Color = "Purple", Points = 150, Hidden = true}
--SkillPointsTable["Humans"]["bulletproof"] = {Name = "BULLETPROOF", Description = "Kill a howler-charged zombie!",Color = "Red", Points = 200}
--SkillPointsTable["Humans"]["pants"] = {Name = "PANTS OF DOOM", Description = "Unleash the BoomStick power!",Color = "Red", Points = 100}
--SkillPointsTable["Humans"]["pierced"] = {Name = "PIERCED", Description = "Kill 3 zombies with one bolt!",Color = "Red", Points = 85}
--SkillPointsTable["Humans"]["boom"] = {Name = "BOOM!", Description = "Kill 10 zombies with one mine!",Color = "Orange", Points = 45}
--SkillPointsTable["Humans"]["quickdraw"] = {Name = "QUICK DRAW", Description = "Kill 3 zombies in 6 seconds with pistol!",Color = "White", Points = 60}
--SkillPointsTable["Humans"]["potato"] = {Name = "HOT POTATO", Description = "Kill 4 with one grenade!",Color = "Orange", Points = 55}
-- TODO: MORE!

-- Skillpoints for zombies
SkillPointsTable["Zombies"] = {}
--[=[SkillPointsTable["Zombies"]["propkill"] = {Name = "PROP KILL", Description = "Title says it all",Color = "Orange", Points = 230}
SkillPointsTable["Zombies"]["screamtherapy"] = {Name = "SCREAM THERAPY", Description = "Explode human's head as howler!",Color = "DarkBlue", Points = 200}
SkillPointsTable["Zombies"]["bleeder"] = {Name = "BLEEDER", Description = "Kill a human with poison spit!",Color = "DarkGreen", Points = 300}
SkillPointsTable["Zombies"]["freshfood"] = {Name = "FRESH FOOD", Description = "Just kill a human.",Color = "LightGrey", Points = 30}
SkillPointsTable["Zombies"]["backbreaker"] = {Name = "BACKBREAKER", Description = "Kill a human from behind!",Color = "Yellow", Points = 50}
SkillPointsTable["Zombies"]["brainsucker"] = {Name = "BRAIN SUCKER", Description = "Kill a human as headcrab (normal)!",Color = "DarkRed", Points = 300}
SkillPointsTable["Zombies"]["crime"] = {Name = "CRIME AND PUNISHMENT", Description = "Kill berserker as a howler!",Color = "White", Points = 200, Hidden = true}
SkillPointsTable["Zombies"]["noregrets"] = {Name = "NO REGRETS", Description = "Kill an admin when he is a human!",Color = "Purple", Points = 30, Hidden = true}
SkillPointsTable["Zombies"]["detoxication"] = {Name = "DETOXICATION", Description = "Kill an infected human!",Color = "DarkGreen", Points = 250}]=]
-- TODO: MUCH MORE!