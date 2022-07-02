--------------------
-- STBase
-- By Spacetech
--------------------

AddCSLuaFile("deathrun_family_guy_gm_cl.lua")

-- Prevents the trigger_once in the dumpster from making the activating player invisible.
hook.Add("EntityKeyValue", "KeyValueChanger", function(ent, key, value)
	if value == "!activator,Alpha,0,0.01,-1" then
		return ""
	end
end)

-- Sets the model of the first player that jumps into the dumpster to Brian.
STGamemodes.TouchEvents:Setup(Vector(5364, -6448, 24), Vector(5404, -6368, 36), function(ply)
	local brian = ents.FindByName("nade_2_pb")[1]
	if brian and brian:IsValid() then
		local mdl = brian:GetModel()
		table.insert(STGamemodes.InvalidPlayerModels, mdl)
		ply:StripWeapons()
		ply:KillHat()
		ply:SetModel(mdl)
		brian:Remove()
	end
end)

-- Gives crowbars for the Knife minigame.
STGamemodes.TouchEvents:Setup(Vector(-849, -4481, -1), Vector(-839, -4351, 193), function(ply)
	if !ply:HasWeapon("weapon_crowbar") then
		ply:Give("weapon_crowbar")
	end
end)

STGamemodes.Buttons:SetupLinkedButtons(16)