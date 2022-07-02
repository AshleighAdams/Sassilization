--------------------
-- STBase
-- By Spacetech
--------------------

local children = {{}, {}}

GM.RunnerWeapon = "weapon_crowbar"

hook.Add("EntityKeyValue", "KeyValueChanger", function(ent, key, value)
	-- Assigns the grenades' children to other parents so they don't get removed along with the grenades.
	if key == "parentname" then
		if value == "grenade1" then
			table.insert(children[1], ent)
			return "rotating7"
		elseif value == "grenade2" then
			table.insert(children[2], ent)
			return "rotating8"
		end
	end
	
	-- Makes the pushing wall trap stick out a bit so that players can't walk along the edge.
	if key == "origin" and value == "-1280 896 64" then
		return "-1280 897 64"
	end
end)

hook.Add("OnRoundChange", "EntityHandler", function()
	local rots = {ents.FindByName("rotating7")[1], ents.FindByName("rotating8")[1]}
	local teles = {ents.FindByName("teleport16")[1], ents.FindByName("teleport18")[1]}
	
	-- Spawns crowbars which allow runners to teleport out of the secret areas.
	for i=1,2 do
		local wep = ents.Create("weapon_crowbar")
		wep:SetPos(rots[i]:GetPos())
		wep:SetAngles(Angle(-90, 0, 0))
		wep:SetKeyValue("spawnflags", "1")
		wep:SetKeyValue("OnPlayerPickup", teles[i]:GetName()..",Enable,,1.5,-1")
		wep:Spawn()
		wep:GetPhysicsObject():EnableMotion(false)
		for k,v in pairs(children[i]) do
			if v and v:IsValid() then
				v:SetParent(wep)
			end
		end
	end
	
	--[[ -- Makes various breakables around the map not require a crowbar to be broken.
	for k,v in pairs(ents.FindByClass("func_breakable")) do
		if v:GetName() == "" then
			v:SetKeyValue("spawnflags", "6")
		end
	end ]]
end)

-- Makes sure that players are able to pick up the crowbars which allow them to teleport out of the secret areas.
hook.Add("PlayerCanPickupWeapon", "WeaponHandler", function(ply, weapon)
	if weapon and weapon:IsValid() then
		local class = weapon:GetClass()
		if class == "weapon_crowbar" and ply:HasWeapon(class) then
			ply:StripWeapon(class)
			return true
		end
	end
end)

STGamemodes.KeyValues:AddChange( "door2", "blockdamage", "1000" )
STGamemodes.KeyValues:AddChange( "finish2", "OnStartTouch", "door8,Unlock,,0,1" )
STGamemodes.KeyValues:AddChange( "finish2", "OnStartTouch", "door8,Open,,2,1" )

-- Kill volume for various grate pits around the map.
STGamemodes.TouchEvents:Setup(Vector(-1600, 960, -640), Vector(2240, 5056, -576), function(ply)
	ply:Kill()
end)

-- Kill volume for the grate pit in the bridge area.
STGamemodes.TouchEvents:Setup(Vector(2880, 960, -416), Vector(3008, 1088, -352), function(ply)
	ply:Kill()
end)