--------------------
-- STBase
-- By Spacetech
--------------------

local ui

hook.Add("EntityKeyValue", "KeyValueChanger", function(ent, key, value)
	-- Override for the water and lava kill triggers' damage amount.
	if key == "damage" and (value == "50" or value == "100") then
		return "200"	
	end
	
	-- Override for the Creepers' explosion magnitude.
	if key == "iMagnitude" and value == "200" then
		return "500"
	end
end)

hook.Add("OnRoundChange", "EntityHandler", function()
	STRTD:CreateSpeedMod(true)
	
	-- Assigns the game_ui used to control the cannon.
	ui = ents.FindByClass("game_ui")[1]
	ui:SetKeyValue("PlayerOn", "!activator,AddOutput,targetname cannon_user,0,-1")
	ui:SetKeyValue("PlayerOff", "!activator,AddOutput,targetname ,0,-1")
	ui:SetKeyValue("UnpressedAttack2", "!self,Deactivate,,0,-1")
	
	-- Replaces the HL2 SMGs with Sass SMG spawners.
	for k,v in pairs(ents.FindByClass("weapon_smg1")) do
		local gun = ents.Create("weapon_spawn")
		gun:SetPos(v:GetPos())
		gun:Spawn()
		gun:Activate()
		v:Remove()
	end
end)

-- Disables the cannon once the player controlling it dies.
hook.Add("PlayerDeath", "InputCaller", function(ply)
	if ui and ui:IsValid() and ply == ents.FindByName("cannon_user")[1] then
		ui:Fire("Deactivate")
	end
end)

-- Triples the deaths' speed.
STGamemodes.TouchEvents:Setup(Vector(896, -160, 64), Vector(3328, 32, 292), function(ply)
	ply:ModSpeed(3)
end)

-- Prevents players from standing on each other's heads and jumping over the death zone playerclip.
STGamemodes.TouchEvents:Setup(Vector(864, -192, 292), Vector(3328, 64, 356), function(ply)
	ply:Teleport("ending_1_2")
end)

-- Randomizes the runner teleport position for the Old minigame, thus making it harder for deaths to camp the spawn.
STGamemodes.TouchEvents:Setup(Vector(4784, -704, 0), Vector(4801, -640, 96), function(ply)
	ply:SetPos(Vector(math.random(914, 3310), math.random(-110, 14), 144))
end)

-- Strips the deaths of their speed for the Deathmatch minigame.
STGamemodes.TouchEvents:Setup(Vector(416, -2720, 0), Vector(1344, -1984, 288), function(ply)
	ply:ModSpeed(1)
end)

-- Strips the deaths of their speed for the Cannon minigame.
STGamemodes.TouchEvents:Setup(Vector(3056, -2944, -256), Vector(4432, -2464, 256), function(ply)
	ply:ModSpeed(1)
end)