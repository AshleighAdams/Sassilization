--------------------
-- STBase
-- By Spacetech
--------------------

-- Makes the starting trigger increase the deaths' speed 4 times instead of 2.
hook.Add("EntityKeyValue", "KeyValueChanger", function(ent, key, value)
	if ent:GetClass() == "trigger_multiple" and key == "OnStartTouch" and value == "speedmod,ModifySpeed,2,0,-1" then
		return "speedmod,ModifySpeed,4,0,-1"
	end
end)

-- Randomizes the runner teleport position for the Old minigame, thus making it harder for deaths to camp the spawn.
STGamemodes.TouchEvents:Setup(Vector(-5273, -659, 65), Vector(-5264, -579, 184), function(ply)
	ply:SetPos(Vector(math.random(-3006, -2850), math.random(4083, 5806), 176))
end)

-- Gives crowbars for the Knife minigame.
STGamemodes.TouchEvents:Setup(Vector(-6973, 2439, 64), Vector(-6893, 2447, 184), function(ply)
	if !ply:HasWeapon("weapon_crowbar") then
		ply:Give("weapon_crowbar")
	end
end)