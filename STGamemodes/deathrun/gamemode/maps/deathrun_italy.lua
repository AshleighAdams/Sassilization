--------------------
-- STBase
-- By Spacetech
--------------------

hook.Add("EntityKeyValue", "KeyValueChanger", function(ent, key, value)
	-- Makes the starting trigger and Knife minigame trigger increase the deaths' speed 3 times instead of 2.
	if key == "OnTrigger" and value == "Terrorist_speed,ModifySpeed,2,0,-1" then
		return "Terrorist_speed,ModifySpeed,3,0,-1"
	end
	
	-- Raises the floor sides on the opening floor sides trap so they don't cause graphical glitches.
	if key == "origin" and string.match(value, "-1488 %d+ 32") then
		return string.gsub(value, string.Explode(" ", value)[3], "33")
	end	
end)

hook.Add("OnRoundChange", "EntityHandler", function()
	STRTD:CreateSpeedMod(true)
	for k,v in pairs(ents.FindByName("info_player_*")) do
		v:SetPos(v:GetPos() + Vector(-16, 0, 0))
	end
	--[[ for k,v in pairs(ents.FindByName("Old_equip")) do
		v:Remove()
	end ]]
end)

STGamemodes.KeyValues:AddChange( "laser_4", "origin", "-728 1260 948" )
STGamemodes.KeyValues:AddChange( "Top_destination", "origin", "-2512 816 64" )
STGamemodes.KeyValues:AddChange( "Cellar_destination", "origin", "-2512 816 -743" )
STGamemodes.KeyValues:AddChange( "cellar_boxtrap_*", "speed", "1999" )
STGamemodes.KeyValues:AddChange( "Cellar_trap3_door", "speed", "1999" )

-- Prevents players from jumping onto the moving boxes trap in the cellar, thus skipping it.
STGamemodes.TouchEvents:Setup(Vector(-2358, 352, -671), Vector(-2072, 436, -607), function(ply)
	ply:SetLocalVelocity(Vector(0, 0, 0))
end)

-- Prevents players from jumping onto the moving wine racks trap in the cellar, thus skipping it.
STGamemodes.TouchEvents:Setup(Vector(-4124, -344, -791), Vector(-3796, -308, -727), function(ply)
	ply:SetLocalVelocity(Vector(0, 0, 0))
end)

--[[ -- Gives guns for the Old minigame.
STGamemodes.TouchEvents:Setup(Vector(-4440, -1420, -864.11), Vector(-4360, -1412, -756.11), function(ply)
	ply:Give(STGamemodes.RunGun)
end) ]]

-- Gives crowbars for the Knife minigame.
STGamemodes.TouchEvents:Setup(Vector(-3316, -1700, 217), Vector(-3048, -1668, 289), function(ply)
	if(ply:Team() == TEAM_RUN and !ply:HasWeapon("weapon_crowbar")) then
		ply:Give("weapon_crowbar")
	end
end)

-- Resets the deaths' speed for the BHop minigame.
STGamemodes.TouchEvents:Setup(Vector(-460, -1316, 989), Vector(-428, -1284, 1061), function(ply)
	if(ply:Team() == TEAM_DEATH) then
		ply:ModSpeed(1)
	end
end)

--[[ -- Prevents deaths from camping the runner teleport destination on the Old minigame.
STGamemodes.TouchEvents:Setup(Vector(1274.67, 234.86, 944), 80, function(ply)
	if(ply:Team() == TEAM_DEATH) then
		ply:SetPos(Vector(916, 234, 881))
	end
end) ]]