--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(6105, 10486, 64))

-- Disables the physics props' motion.
hook.Add("InitPostEntity", "InputCaller", function()
	for k,v in pairs(ents.FindByClass("prop_physics")) do
		v:Fire("DisableMotion")
	end
end)