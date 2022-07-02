--------------------
-- STBase
-- By Spacetech
--------------------

local finished = false

hook.Add("OnRoundChange", "VariableSetter", function()
	ending = false
end)

hook.Add("WeaponEquip", "EndingSetup", function(weapon)
	if weapon:GetClass() == STGamemodes.RunGun then
		ending = true
		local tele = ents.FindByName("to 2nd room")[1]
		for k,v in pairs(ents.FindInBox(Vector(-459, 24, 4), Vector(795, 602, 123))) do
			if v:IsPlayer() and v:Team() == TEAM_DEATH then
				v:SetPos(tele:GetPos())
				v:SetEyeAngles(tele:GetAngles())
			end
		end
		for k,v in pairs(ents.FindByClass("trigger_teleport")) do
			if !(v:GetName() == "NICE1") then
				v:Fire("Disable")
			end
		end
	end
end)

-- Prevents deaths from camping the runner teleport destination.
STGamemodes.TouchEvents:Setup(ents.FindByName("NICE1"):GetPos() + Vector(0, 0, 64), 128, function(ply)
	ply:SetPos(Vector(-384, 896, 3))
end)