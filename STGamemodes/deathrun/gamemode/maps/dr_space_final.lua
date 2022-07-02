--------------------
-- STBase
-- By Spacetech
--------------------

local sprite

STGamemodes.Weapons:Add(Vector(623, -2322, 103))

hook.Add("OnRoundChange", "EntityHandler", function()
	teleporterEnabled = true
	teleported = false
	STRTD:CreateSpeedMod(true)
	
	-- Creates a sprite marking the teleporter to the melee minigame.
	sprite = ents.Create("env_sprite")
	sprite:SetPos(Vector(414, -2383, 132))
	sprite:SetKeyValue("rendermode", "5")
	sprite:SetKeyValue("spawnflags", "1")
	sprite:SetKeyValue("model", "sprites/glow.spr")
	sprite:Spawn()
	sprite:Activate()
	
	-- Prevents players from getting stuck in the back wall of the spawn.
	for k,v in pairs(ents.FindByClass("info_player_counterterrorist")) do
		v:SetPos(v:GetPos() + Vector(-12, 0, 0))
	end
	
	-- Prevents the rolling boulder from being destroyed before it can hurt players.
	for k,v in pairs(ents.FindInSphere(Vector(-1851, 704.5, 188.01), 1)) do
		v:SetPos(Vector(-1851, 688.5, 188.01))
	end
	
	-- Gets rid of the rotating M249 model and the trigger that spawns guns.
	for k,v in pairs(ents.FindInSphere(Vector(623, -2318, 143), 64)) do
		if v:GetClass() == "func_rotating" or v:GetClass() == "trigger_multiple" then
			v:Remove()
		end
	end
	
	-- Makes the ending trigger increase the runners' speed 2 times instead of 4.
	for k,v in pairs(ents.FindInSphere(Vector(745, -2321, 188.02), 1)) do
		STGamemodes.KeyValues:AddChange( v, "OnStartTouch", "Terrorist_speed,ModifySpeed,2,0,-1" )
	end
end)

-- Makes sure that the game_player_equip (Fegyo) doesn't give players grenades on spawn.
hook.Add("EntityKeyValue", "KeyValueChanger", function(ent, key, value)
	if ent:GetClass() == "game_player_equip" and key == "spawnflags" then
		return "1"
	end
end)

-- Disables the melee minigame teleporter once runners go through to the deaths' side.
hook.Add("WeaponEquip", "VariableChanger", function(weapon)
	if weapon:GetClass() == "weapon_frag" then
		teleporterEnabled = false
		sprite:Remove()
	end
end)

STGamemodes.KeyValues:AddChange( "Fegyo", "weapon_frag", "1" )
STGamemodes.KeyValues:AddChange( "teleport", "OnStartTouch", "Fegyo,Use,,0,1" )
STGamemodes.KeyValues:AddChange( "komp_track", "MoveSoundMinPitch", "100" )
STGamemodes.KeyValues:AddChange( "komp_track", "MoveSoundMaxPitch", "100" )

function teleportDeaths()
	if !teleported then
		for k,v in pairs(player.GetAll()) do
			if v:Team() == TEAM_DEATH then
				v:SetPos(Vector(-695, -724.5, 155))
				v:SetEyeAngles(Angle(0, 45, 0))
			end
		end
		teleported = true
	end
end

-- Sets up a melee minigame in the big spaceship.
STGamemodes.TouchEvents:Setup(Vector(414, -2383, 132), 32, function(ply)
	if teleporterEnabled then
		ply:SetPos(Vector(-348, -1812, 25))
		ply:SetEyeAngles(Angle(0, 120, 0))
		ply:StripWeapons()
		ply:Give("weapon_crowbar")
		ply:ModSpeed(2)
		teleportDeaths()
		ents.FindByName("teleport")[1]:Fire("Disable")
	end
end)