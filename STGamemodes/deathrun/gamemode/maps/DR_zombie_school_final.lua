--------------------
-- STBase
-- By Spacetech
--------------------

GM.RunnerWeapon = "weapon_crowbar"

STGamemodes.Weapons:Remove(Vector(608, 32.0001, 218.376))
STGamemodes.Weapons:Remove(Vector(608, -96, 218))
STGamemodes.Weapons:Remove(Vector(606, 160, 216))

-- Prevents the door in the death zone from playing the annoying sound.
hook.Add("EntityKeyValue", "KeyValueChanger", function(ent, key, value)
	if ent:GetClass() == "prop_door_rotating" then
		if key == "spawnflags" then
			return "4096"
		elseif key == "soundmoveoverride" then
			return ""
		end
	end
end)

--[[ -- Prevents the door in the death zone from playing the annoying sound.
hook.Add("OnRoundChange", "KeyValueChanger", function()
	ents.FindByClass("prop_door_rotating")[1]:SetKeyValue("spawnflags", "4096")
end) ]]

STGamemodes.KeyValues:AddChange( "trap9_moveblock", "blockdamage", "1000" )
STGamemodes.KeyValues:AddChange( "trap11_move", "blockdamage", "1000" )
STGamemodes.KeyValues:AddChange( "trap12_move", "blockdamage", "10" )
STGamemodes.KeyValues:AddChange( "trap13_hurt", "damagetype", "0" )

-- Kill volume for the pit near the finish.
STGamemodes.TouchEvents:Setup(Vector(544, 1152, -736), Vector(768, 1248, -672), function(ply)
	ply:Kill()
end)

-- Kills players if the try jumping onto the playerclip that's supposed to prevent them from surfing the side walls on the BHop minigame.
STGamemodes.TouchEvents:Setup(Vector(2288, -512, -192), Vector(2320, 256, -128), function(ply)
	ply:Kill()
end)