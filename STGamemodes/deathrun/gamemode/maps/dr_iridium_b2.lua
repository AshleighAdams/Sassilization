--------------------
-- STBase
-- By Spacetech
--------------------

-- Makes sure that the triggers which were intended to kill do so instantly.
hook.Add("EntityKeyValue", "KeyValueChanger", function(ent, key, value)
	if ent:GetClass() == "trigger_hurt" and key == "damage" and value == "200" then
		return "1000"
	end
end)

hook.Add("OnRoundChange", "EntityHandler", function()
	local trigger
	
	-- Assigns the trigger which will provide a brush model for the trigger_hurt on trap3.
	for k,v in pairs(ents.FindInSphere(Vector(1156, -486, 224), 1)) do
		if v:GetClass() == "trigger_multiple" then
			trigger = v
		end
	end
	
	-- Modifies the trigger_hurt on trap 3 so that it can actually kill people.
	if trigger and trigger:IsValid() then
		local hurt = ents.FindByName("trap3hurt")[1]
		hurt:SetModel(trigger:GetModel())
		hurt:SetPos(Vector(1480, -324, 54))
	end
	
	-- Gets rid of the normal death teleporters for the Pads minigame.
	for k,v in pairs(ents.FindByName("teleport_death_*")) do
		v:Remove()
	end
end)

hook.Add("Think", "OperationStopGhostsFromCrashingUs", function()
	for k,v in pairs(team.GetPlayers(TEAM_DEAD)) do
		if v:IsGhost() and v:GetPos():Distance(Vector(2424, -3476, -8)) <= 208 then
			v:ChatPrint("WARNING: This area is hazardous to ghosts! Do not enter!")
			v:Spawn()
			v.LastPos = nil
			v.LastEyeAngles = nil
		end 
	end
end)

--[[ STGamemodes.KeyValues:AddChange( "trap3hurt", "origin", "1480 -324 54" )

-- Enlarges the player's hull so they can't avoid the trigger_hurt on trap 3.
STGamemodes.TouchEvents:Setup(Vector(1416, -463, 0), Vector(1544, -185, 108), function(ply)
	ply:SetHull(Vector(-20, -20, 0), Vector(20, 20, 72))
	ply:SetHullDuck(Vector(-20, -20, 0), Vector(20, 20, 36))
end) ]]

-- Override for the death teleportation system on the Pads minigame.
STGamemodes.TouchEvents:Setup(Vector(-1881, -8901, -33), Vector(-1799, -8895, 97), function(ply)
	local deaths = team.GetPlayers(TEAM_DEATH)
	local teles = ents.FindByName("death_cannon_*")
	for i=1,#deaths do
		if teles[i] and teles[i]:IsValid() then
			deaths[i]:SetPos(teles[i]:GetPos())
		else
			deaths[i]:SetPos(ents.FindByName("cannon_tele")[1]:GetPos()
					+ Vector(math.random(-448, 448), math.random(-448, 448), 96))
			deaths[i]:StripWeapons()
		end
	end
end)

-- Strips players' weapons for the Jump minigame.
STGamemodes.TouchEvents:Setup(Vector(-3744, -8588, 176), 96, function(ply)
	ply:StripWeapons()
end)