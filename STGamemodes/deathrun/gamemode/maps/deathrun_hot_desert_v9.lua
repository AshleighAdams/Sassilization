--------------------
-- STBase
-- By Spacetech
--------------------

-- Replaces the AK47 with a Sass SMG spawner.
hook.Add("OnRoundChange", "WeaponHandler", function()
	local ak = ents.FindByClass("weapon_ak47")[1]
	local gun = ents.Create("weapon_spawn")
	gun:SetPos(ak:GetPos())
	gun:Spawn()
	gun:Activate()
	ak:Remove()
end)

-- Gives players grenades for the Fight minigame.
hook.Add("WeaponEquip", "WeaponGiver", function(weapon)
	if weapon:GetClass() == "weapon_deagle" then
		timer.Simple(0, function()
			weapon:GetOwner():Give("weapon_frag")
		end)
	end
end)

STGamemodes.KeyValues:AddChange( "CT_tel_*", "OnStartTouch", "lost_vert,Kill,,0,-1" )
STGamemodes.KeyValues:AddChange( "CT_tel_*", "OnStartTouch", "sicret_teleporta,Kill,,0,-1" )
STGamemodes.KeyValues:AddChange( "CT_tel_*", "OnStartTouch", "lost_b,Kill,,0,-1" )
STGamemodes.KeyValues:AddChange( "sicret_teleporta", "OnStartTouch", "lost_vert,Kill,,0,-1" )
STGamemodes.KeyValues:AddChange( "sicret_teleporta", "OnStartTouch", "lost_b,Kill,,0,-1" )