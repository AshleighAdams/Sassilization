--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(-386.76580810547, -7481.0405273438, -95.96875))

-- Disables the chair's motion.
hook.Add("InitPostEntity", "InputCaller", function()
	ents.FindByClass("prop_physics")[1]:Fire("DisableMotion")
end)