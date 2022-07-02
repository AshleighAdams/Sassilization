--------------------
-- STBase
-- By Spacetech
--------------------

-- STGamemodes.Weapons:Add(Vector(1056, -2752, -16))

hook.Add("OnRoundChange", "DecalDestroyer", function()
	for k,v in pairs(ents.FindInSphere(Vector(-864, -256, -16), 192)) do
		if(v:GetClass() == "infodecal") then
			v:Remove()
		end
	end
end)