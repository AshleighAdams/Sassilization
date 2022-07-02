--------------------
-- STBase
-- By Spacetech
--------------------

hook.Add("OnRoundChange", "WeaponDestroyer", function()
	for k,v in pairs(ents.FindByClass("weapon_frag")) do
		v:Remove()
	end
end)