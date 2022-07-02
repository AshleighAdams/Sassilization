--------------------
-- STBase
-- By Spacetech
--------------------

local function NearChristmas()
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

-- YOU NEED TO ADD HAT POSITIONS TOO (Now done here!!!)

STGamemodes.Hats = {}

-- Example:
-- STGamemodes.Hats["NAME"] = { "MODEL", "ICON", PRICE, Backward, Down, ANGLE (OPTIONAL) }

STGamemodes.Hats["American Hat"] 	= {"models/americahat/americahat.mdl", "", 2500, -0.15, -4.55}
STGamemodes.Hats["Bunny Ears"] 		= {"models/bunnyears/bunnyears.mdl", "", 10000, 0.6, -7}
STGamemodes.Hats["Captains Hat"] 	= {"models/captainshat/captainshat.mdl", "", 5000, 0.2, -4.55}
STGamemodes.Hats["Cowboy Hat"] 		= {"models/viroshat/viroshat.mdl", "", 5000, 0.2, -4.3}
STGamemodes.Hats["Gay Police Hat"] 	= {"models/gaypolicehat/gaypolicehat.mdl", "", 2000, 0.4, -4.55}
STGamemodes.Hats["Headcrab Hat"] 	= {"models/nova/w_headcrab.mdl", "", 20000, -0.3, 0, Angle(80, -90, 0)}
STGamemodes.Hats["Mario Hat"] 		= {"models/mariohat/mariohat.mdl", "", 6500, 0.1, -4.65}
STGamemodes.Hats["Mushroom Hat"] 	= {"models/mushroom/mushroom.mdl", "", 15000, 0.2, -4.55}
STGamemodes.Hats["Paperbag Hat"] 	= {"models/paperbag/paperbag.mdl", "", 15000, -1.5, 3.2}
STGamemodes.Hats["Party Hat"] 		= {"models/partyhat/partyhat.mdl", "", 5000, 0.6, -6}
STGamemodes.Hats["Party Hat2"] 		= {"models/partyhat2/partyhat2.mdl", "", 5000, 0.6, -6}
STGamemodes.Hats["Police Hat"] 		= {"models/policehat/policehat.mdl", "", 2000, 0.4, -4.55}
STGamemodes.Hats["Salesman Hat"] 	= {"models/salesmanhat/salesmanhat.mdl", "", 2000, 0.1, -5.4}
STGamemodes.Hats["Top Hat"] 		= {"models/mrgiggles/sasshats/tophat.mdl", "", 8000, -0.15, -4.55}
STGamemodes.Hats["Visor"]	 		= {"models/solarthing/solarthing.mdl", "", 1000, 0.15, -4.55}

-- HL2 Models
STGamemodes.Hats["Watermelon"] 		= {"models/props_junk/watermelon01.mdl", "", 5000, -0.3, -2.2}
STGamemodes.Hats["Traffic Cone"]	= {"models/props_junk/TrafficCone001a.mdl", "", 9000, 0.95, -10}
STGamemodes.Hats["Bucket Head"]		= {"models/props_junk/MetalBucket01a.mdl", "", 7000, 0.5, -1.5, Angle(-180, 0, 0)}
STGamemodes.Hats["Lamp Shade"]		= {"models/props_c17/lampShade001a.mdl", "", 8000, -0.8, -7}

--  Sam
STGamemodes.Hats["Afro"] 			= {"models/sam/afro.mdl", "", 2500, -1, -5}
STGamemodes.Hats["Antlers"] 		= {"models/sam/antlers.mdl", "", -1, 0, -3}
STGamemodes.Hats["Astronaut Helmet"] = {"models/astronauthelmet/astronauthelmet.mdl", "", 100000, 0, 3}
STGamemodes.Hats["Beer Hat"] 		= {"models/sam/drinkcap.mdl", "", 10000, 0.1, -4.5}
STGamemodes.Hats["Cake Hat"] 		= {"models/cakehat/cakehat.mdl", "", 20000, 0, -3}
STGamemodes.Hats["Dunce Hat"] 		= {"models/duncehat/duncehat.mdl", "", 1000, 0, -3}
STGamemodes.Hats["Santa Hat"] 		= {"models/santahat/santahat.mdl", "", NearChristmas() and 7500 or -1, 0, -3}
STGamemodes.Hats["Sombrero"] 		= {"models/sombrero/sombrero.mdl", "", 20000, 0, -3.5}
STGamemodes.Hats["Viking Helmet"]	= {"models/vikinghelmet/vikinghelmet.mdl", "", 15000, 0, -3}

-- BMCha
STGamemodes.Hats["M1 Helmet"] 	= {"models/BMCha/m1helmet.mdl", "", 15000, 0, -4}
STGamemodes.Hats["Pickelhaube"] = {"models/BMCha/pickelhaube.mdl", "", 30000, 0, -3.5}
STGamemodes.Hats["Propeller"] 	= {"models/propellerhat/propellerhat.mdl", "", 25000, 0.2, -3.5}

-- cold
STGamemodes.Hats["Cheese Hat"] 	= {"models/cold/hats/cheesehat.mdl", "", 3000, -1.75, -5}
STGamemodes.Hats["Halo"] 		= {"models/cold/hats/halo.mdl", "", 30000, 0, -8}

// -Rusty-  http://www.facepunch.com/showthread.php?t=993887
STGamemodes.Hats["Get Out Frog"] = {"models/rusty/misc/frog.mdl", "", 250000, 0, 0}

-- Mr. Giggles
STGamemodes.Hats["Daft Punk (Thomas)"] = {"models/mrgiggles/sasshats/daftpunk_thomas.mdl", "", 250000, -1, -3}
STGamemodes.Hats["Deadmau5"] 	= {"models/mrgiggles/sasshats/deadmau5.mdl", "", 100000, 0, -2}
STGamemodes.Hats["Dev Hat"]		= {"models/mrgiggles/sasshats/devhat.mdl", "", -1, -0.5, -4}
STGamemodes.Hats["Diver Helm"] = {"models/mrgiggles/sasshats/diverhelmet.mdl", "", 250000, 0.25, -4}
STGamemodes.Hats["Mapping King"] = {"models/mrgiggles/sasshats/mapperking.mdl", "", -1, 0, -4}
STGamemodes.Hats["Pimp Hat"] = {"models/mrgiggles/sasshats/pimphat.mdl", "", 250000, 0, -4}
STGamemodes.Hats["Strobemau5"] = {"models/mrgiggles/sasshats/pulsemau5.mdl", "", 200000, 0, -2}
STGamemodes.Hats['Waffle Hat'] = {"models/mrgiggles/sasshats/wafflehat.mdl", "", -1, -1, -4}

--Mozart
--STGamemodes.Hats['Minecraft Cake'] = {"models/hats/minecraft/cakehat.mdl", " ", 40000, -1, -4}



for k,v in pairs(STGamemodes.Hats) do
	util.PrecacheModel(v[1])
end
