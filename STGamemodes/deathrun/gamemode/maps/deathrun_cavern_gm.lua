--------------------
-- STBase
-- By Spacetech
--------------------

hook.Add("EntityKeyValue", "KeyValueChanger", function(ent, key, value)
	-- Makes the func_tracktrains around the map kill people who get in their way.
	if ent:GetClass() == "func_tracktrain" and key == "spawnflags" then
		return "18"
	end
	
	-- Moves the spike kill trigger on the rolling column trap up so that players can't crouch on the spikes without dying.
	if key == "origin" and value == "226 2368 1248" then
		return "226 2368 1249"
	end
end)

hook.Add("OnRoundChange", "EntityHandler", function()
	-- Makes the func_rotatings around the map kill people who get in their way.
	for k,v in pairs(ents.FindByClass("func_rotating")) do
		v:SetKeyValue("dmg", "10")
	end
	
	-- Names the func_physboxes on the falling debris trap in the "underground" section.
	for k,v in pairs(ents.FindInSphere(Vector(224, -1325, 1269), 192)) do
		if v:GetClass() == "func_physbox" then
			v:SetName("rock_fall_phys")
		end
	end
end)

-- Creates extra deagles and crossbows for the "<<" and "Y" minigames respectively.
hook.Add("WeaponEquip", "WeaponSpawner", function(weapon)
	local class = weapon:GetClass()
	if class == "weapon_deagle" or class == "weapon_crossbow" then
		local gun = ents.Create(class)
		gun:SetPos(weapon:GetPos())
		gun:Spawn()
	end
end)

-- Kills players around the exploding boxes in the "underground" section.
hook.Add("EntityRemoved", "PlayerKiller", function(ent)	
	if ent:GetClass() == "prop_dynamic" and ent:GetModel() == "models/props/de_prodigy/prodcratesb.mdl" then
		for k,v in pairs(ents.FindInSphere(ent:GetPos(), 100)) do
			if v:IsPlayer() and v:Team() == TEAM_RUN then
				v:Kill()
			end
		end
	end
end)

STGamemodes.KeyValues:AddChange( "rock_fall_button", "OnPressed", "rock_fall_phys,Break,,5,-1" )

--[[ -- Teleporter for the secret bhop area in the start area pit.
STGamemodes.TouchEvents:Setup(Vector(-564.13201904297, -3282.2272949219, 776.03125), 150, function(ply)
	ply:SetPos(Vector(-575.09783935547, -1532.5523681641, 1491.7545166016))
end) ]]

-- Kill volume for the start area pit.
STGamemodes.TouchEvents:Setup(Vector(-664, -1936, -1858), Vector(-472, -1712, -1794), function(ply)
	ply:Kill()
end)

-- Prevents players from jumping onto the spikes on the "only the penitent man shall pass" trap.
STGamemodes.TouchEvents:Setup(Vector(-400, 2898, 1575), Vector(84, 2944, 1591), function(ply)
	ply:SetLocalVelocity(Vector(0, 0, 0))
end)

-- Kill volume for the pit after the rolling column trap.
STGamemodes.TouchEvents:Setup(Vector(64, 1472, 160), Vector(380, 1728, 224), function(ply)
	ply:Kill()
end)

-- Gives crowbars for the Knife minigame.
STGamemodes.TouchEvents:Setup(Vector(966, 2818, 1664), Vector(990, 2874, 1776), function(ply)
	if !ply:HasWeapon("weapon_crowbar") then
		ply:Give("weapon_crowbar")
	end
end)

STGamemodes.Buttons:SetupLinkedButtons(16)