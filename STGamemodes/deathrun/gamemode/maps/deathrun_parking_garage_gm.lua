--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Buttons:SetupLinkedButtons({"carbutton"})

hook.Add("OnRoundChange", "WeaponDestroyer", function()
	ents.FindByClass("weapon_smg1")[1]:Remove()
end)