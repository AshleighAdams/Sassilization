--------------------
-- STBase
-- By Spacetech
--------------------

local function Available()
	local month = os.date("%m")
	local day = os.date("%d")

	if month == "12" then 
		day = tonumber(day)
		if day > 25 and (day - 25) <= 4 then 
			return true 
		elseif day < 25 and (25 - day) <= 4 then 
			return true 
		else 
			return false 
		end 
	end 
end 

STGamemodes.Trails = {}

--STGamemodes.Trails[""]	= {"trails/", }

-- PERSONAL
STGamemodes.Trails["Space"]			= {"trails/space26", -1}
STGamemodes.Trails["Waffle"]		= {"trails/Waffle4", -1}
STGamemodes.Trails["Hue"]			= {"trails/hue", -1}

-- PUBLIC
STGamemodes.Trails["!"]				= {"trails/ExclamationMark2", 6500}
STGamemodes.Trails["$"]				= {"trails/dollarsign", 5000}
STGamemodes.Trails["8 Bit Arrow"]	= {"trails/8bitarrow", 45000}
STGamemodes.Trails["? Box"]			= {"trails/QBox", 11000}
STGamemodes.Trails["Arrow Strip"] 	= {"trails/arrowstrip", 100000} -- Animated
STGamemodes.Trails["Arrow"] 		= {"trails/arrow", 5000}
STGamemodes.Trails["Auro"]			= {"trails/Auro", 10000}
STGamemodes.Trails["Awesome Face"]	= {"trails/AwesomeFace", 17500}
STGamemodes.Trails["Bacon"]			= {"trails/Bacon", 15000}
STGamemodes.Trails["Black Laser 1"]	= {"trails/BlackLaser", 10000}
STGamemodes.Trails["Black Laser 2"]	= {"trails/BlackLaser2", 10000}
STGamemodes.Trails["Bubbles 2"]		= {"trails/Bubbles2", 5000}
STGamemodes.Trails["Bullseye"]		= {"trails/Bullseye", 9000}
STGamemodes.Trails["Bundle"]		= {"trails/mcbundle", 105000} -- Animated
STGamemodes.Trails["Burger"]		= {"trails/Burger", 1500}
STGamemodes.Trails["CareBear"]  	= {"trails/carebear", 10000}
STGamemodes.Trails["Checker Board"]	= {"trails/CheckerBoard", 6000}
STGamemodes.Trails["Chip"]			= {"trails/Chip", 8000}
STGamemodes.Trails["Clam"]			= {"trails/Clam", 7000}
STGamemodes.Trails["Coffee"]		= {"trails/Coffee2", 1500}
STGamemodes.Trails["Companioncube"] = {"trails/companioncube", 35000}
STGamemodes.Trails["Crazy"]			= {"trails/Crazy3", 12000}
STGamemodes.Trails["Creeper"]		= {"trails/creeper", 8000}
STGamemodes.Trails["Crowbar"]		= {"trails/Crowbar", 6000}
STGamemodes.Trails["Dark Smoke"]	= {"trails/DarkSmoke", 7500}
STGamemodes.Trails["Dash"]			= {"trails/Dash", 7000}
STGamemodes.Trails["Dots"]			= {"trails/Dots", 8000}
STGamemodes.Trails["Dubstep"]		= {"trails/dubstep", 10000}
STGamemodes.Trails["Earth"]			= {"trails/Earth", 50000}
STGamemodes.Trails["Electric"] 		= {"trails/electric", 5000}
STGamemodes.Trails["Endless Map"]	= {"trails/EndlessMap", 5000}
STGamemodes.Trails["Epiclulz"] 		= {"trails/epiclulz", 6000}
STGamemodes.Trails["Failure"]		= {"trails/failure", 6000}
STGamemodes.Trails["Fire"]			= {"trails/fire", 2000}
STGamemodes.Trails["Forbidden"]		= {"trails/Forbidden", 5000}
STGamemodes.Trails["French Toast"] 	= {"trails/FrenchToast", 15000}
STGamemodes.Trails["GMod"]			= {"trails/GMod", 7000}
STGamemodes.Trails["Goat Print"]	= {"trails/goatprint", 30000}
STGamemodes.Trails["Goats!"]		= {"trails/goat", 50000}
STGamemodes.Trails["Goomba"]		= {"trails/Goomba", 7000}
STGamemodes.Trails["Guns"]			= {"trails/guns", 75000}
STGamemodes.Trails["Handy"] 		= {"trails/handy", 7500}
STGamemodes.Trails["I Came"]		= {"trails/I Came", 6500}
STGamemodes.Trails["Keke"]			= {"trails/Keke2", 6000}
STGamemodes.Trails["Konota"]		= {"trails/konota", 30000}
STGamemodes.Trails["Ladder"]		= {"trails/minecraftladder", 15000}
STGamemodes.Trails["Laser"]  		= {"trails/laser", 7500}
STGamemodes.Trails["Lava"]			= {"trails/lava_128", 80000} -- Animated
STGamemodes.Trails["LoL"]  			= {"trails/lol", 6000}
STGamemodes.Trails["Lolipop"]		= {"trails/Lolipop", 10000}
STGamemodes.Trails["Love"] 			= {"trails/love", 5000}
STGamemodes.Trails["Luigi"]			= {"trails/Luigi", 10000}
STGamemodes.Trails["Mario"]			= {"trails/Mario", 10000}
STGamemodes.Trails["Megaman"]		= {"trails/Megaman", 10000}
STGamemodes.Trails["Money"]			= {"trails/Money", 7500}
STGamemodes.Trails["Monster"]		= {"trails/monster", 6500}
STGamemodes.Trails["Mudkip"]		= {"trails/mudkip", 15000}
STGamemodes.Trails["Mushroom"]		= {"trails/Mushroom", 13000}
STGamemodes.Trails["Musical Notes"]	= {"trails/MusicalNotes", 3500}
STGamemodes.Trails["My Suck"]		= {"trails/YCEMS", 6500}
STGamemodes.Trails["Nyan Rainbow"]	= {"mrgiggles/trails/nyan__rainbow", 10000}
STGamemodes.Trails["Obso1337"]		= {"trails/Obso1337", 5500}
STGamemodes.Trails["P. Mushroom"]	= {"trails/PoisonMushroom", 15000}
STGamemodes.Trails["Pacman"]		= {"trails/pacman", 7500}
STGamemodes.Trails["Pancake"]		= {"trails/Pancake", 15000}
STGamemodes.Trails["Pedobear"]		= {"trails/Pedobear", 10000}
STGamemodes.Trails["PewPew"]		= {"trails/PewPew3", 6000}
STGamemodes.Trails["PhysBeam"] 		= {"trails/physbeam", 5000}
STGamemodes.Trails["Plasma"] 		= {"trails/plasma", 5000}
STGamemodes.Trails["Pokeball"]		= {"trails/Pokeball", 5000}
STGamemodes.Trails["QQ"]			= {"trails/QQ2", 5000}
STGamemodes.Trails["Rail"]			= {"trails/minecraftrails", 15000}
STGamemodes.Trails["Rainbow"]  		= {"trails/rainbow", 10000}
STGamemodes.Trails["Redstone"]		= {"trails/mcredstone", 40000}
STGamemodes.Trails["Road"]			= {"trails/Road2", 5000}
STGamemodes.Trails["Shoop"]			= {"trails/shoop", 20000}
STGamemodes.Trails["Smoke"]  		= {"trails/smoke", 7500}
STGamemodes.Trails["Space Invader"]	= {"trails/SpaceInvader2", 12000}
STGamemodes.Trails["Space Invaders"]= {"trails/spaceinvaders", 20000}
STGamemodes.Trails["Spade"]			= {"trails/Spade", 7000}
STGamemodes.Trails["Speed"]			= {"trails/Speed3", 5000}
STGamemodes.Trails["Stars"]			= {"trails/Stars", 3000}
STGamemodes.Trails["Stop Sign"]		= {"trails/StopSign3", 5500}
STGamemodes.Trails["TF2 Logo"]		= {"trails/tf2_logo", 25000}
STGamemodes.Trails["TNT"]			= {"trails/mctnt", 55000} -- Animated
STGamemodes.Trails["Train Track"]	= {"trails/TrainTrack", 5000}
STGamemodes.Trails["Troll Face"]	= {"trails/trollface", 17500}
STGamemodes.Trails["Tube"] 			= {"trails/tube", 5000}
STGamemodes.Trails["Turd"]			= {"trails/Turd", 7000}
STGamemodes.Trails["Turtle"]		= {"trails/turtle", 50000}
STGamemodes.Trails["Ugly"]			= {"trails/Ugly", 5000}
STGamemodes.Trails["Weed"]			= {"trails/Weed", 5000}
STGamemodes.Trails["Ying Yang"]		= {"trails/YingYang", 6000}
STGamemodes.Trails["Angry"] 		= {"trails/angry", 2000} -- Being Redone
STGamemodes.Trails["Happy"]  		= {"trails/happy", 2000} -- Being Redone
STGamemodes.Trails["Sass"]			= {"trails/sass", 5000} -- Being redone
STGamemodes.Trails["Star"]  		= {"trails/star", 2000} -- Being Redone
STGamemodes.Trails["Footprint"]		= {"trails/footprint2", 5000} -- Being Redone
STGamemodes.Trails["Pikachu"]		= {"trails/Pikachu", 10000} -- Being Redone

-- Operating System Logos/Computer Related Logos
STGamemodes.Trails["Android"]		= {"trails/Android", 25000}
STGamemodes.Trails["Apple"]			= {"trails/Apple", 25000}
STGamemodes.Trails["Windows"]		= {"trails/Windows", 25000}
STGamemodes.Trails["Linux"]			= {"trails/Linux", 25000}
STGamemodes.Trails["Steam"]			= {"trails/steam", 25000}
STGamemodes.Trails["Suse"]			= {"trails/Suse", 25000}
STGamemodes.Trails["Razor"]			= {"trails/Razor", 25000}

-- FLAGS
STGamemodes.Trails["Australia"]		= {"trails/Flag_Australia", 10000}
STGamemodes.Trails["Belgium"]		= {"trails/flag_belgium", 10000}
STGamemodes.Trails["Canada"]		= {"trails/Flag_Canada", 10000}
STGamemodes.Trails["China"]			= {"trails/flag_china", -1} -- Missing from content
STGamemodes.Trails["Denmark"]		= {"trails/flag_denmark", 10000}
STGamemodes.Trails["France"]		= {"trails/flag_france", 10000}
STGamemodes.Trails["Germany"]		= {"trails/Flag_Germany", 10000}
STGamemodes.Trails["Ireland"]		= {"trails/flag_ireland", 10000}
STGamemodes.Trails["Isle Of Man"]	= {"trails/flag_isleofman", 10000}
STGamemodes.Trails["Italy"]			= {"trails/Flag_Italy", 10000}
STGamemodes.Trails["Netherlands"]	= {"trails/Netherlands", 10000}
STGamemodes.Trails["Poland"]		= {"trails/Flag_Poland", 10000}
STGamemodes.Trails["Russia"]		= {"trails/Russia", 10000}
STGamemodes.Trails["Serbia"]		= {"trails/flag_serbia", 10000}
STGamemodes.Trails["Scotland"]		= {"trails/Flag_Scotland", 10000}
STGamemodes.Trails["SKorea"]		= {"trails/SKorea", 10000}
STGamemodes.Trails["UK"]			= {"trails/Flag_UK", 10000}
STGamemodes.Trails["USA"]			= {"trails/Flag_USA", 10000}

-- CHRISTMAS
STGamemodes.Trails["Snow Flake"]	= {"trails/snowflake", Available() and 5000 or -1}
STGamemodes.Trails["Snow"]			= {"trails/Snow", Available() and 7500 or -1}
STGamemodes.Trails["X-Mas Lights"]	= {"trails/xmaslights", Available() and 10000 or -1}
STGamemodes.Trails["X-Mas Tree"]	= {"trails/xmastree", Available() and 15000 or -1}
STGamemodes.Trails["Santa Hat Trail"] = {"trails/SantaHat", Available() and 12000 or -1}
STGamemodes.Trails["Reindeer"]		= {"trails/Reindeer", Available() and 20000 or -1}
STGamemodes.Trails["Presents"]		= {"trails/Presents", Available() and 10000 or -1}

-- EASTER
STGamemodes.Trails["Easter Egg"]	= {"trails/EasterEgg", os.date("%m") == "04" and 5000 or -1}

-- Discontinued
STGamemodes.Trails["Bubbles"]		= {"trails/bubbles", -1} -- Horrible
STGamemodes.Trails["Smouch"]  		= {"trails/smouch", -1} -- Horrible
STGamemodes.Trails["Ponytail"]		= {"trails/Ponytail", -1} -- Horrible