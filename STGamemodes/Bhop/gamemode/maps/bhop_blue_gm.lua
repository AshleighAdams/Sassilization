--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(192, 192, 208))

hook.Add("PostKeyValues", "EntityDestroyer", function()
	for k,v in pairs(ents.FindByClass("env_fire")) do
		v:Remove()
	end
end)