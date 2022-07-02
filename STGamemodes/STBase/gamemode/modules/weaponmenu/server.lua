--------------------
-- STBase
-- By Spacetech
--------------------

local Enabled = false

function STGamemodes.PlayerMeta:WeaponMenu(Type)
	if(!self:CanBuyWeapons()) then
		self:ChatPrint("You must be alive and near your spawn to use the weapon menu")
		return
	end
	umsg.Start("STGamemodes.WeaponMenu", self)
		umsg.Short(Type or WEAPON_PRIMARY)
	umsg.End()
end

function STGamemodes:SetWeaponMenuEnabled(Bool)
	Enabled = Bool
end

function STGamemodes:WeaponMenuEnabled()
	return Enabled
end

function STGamemodes:GiveWeapon(ply, Item)
	local ItemTable = self.WeaponsMenu[Item]
	if(!ItemTable) then
		return
	end
	
	ply:Give(Item)
	
	if ItemTable.Type == WEAPON_PRIMARY then
		ply:SelectWeapon(Item)
	end
	
	if(ItemTable.Ammo and ItemTable.Ammo > 0) then
		for k,v in pairs(ply:GetWeapons()) do
			if(self:FixString(v:GetClass()) == self:FixString(Item)) then
				ply:GiveAmmo(ItemTable.Ammo, v:GetPrimaryAmmoType())
			end
		end
	end
end

function STGamemodes.BuyWeapon(ply, command, args)
	if(!STGamemodes:WeaponMenuEnabled()) then
		return
	end
	
	if(!ply:CanBuyWeapons()) then
		ply:ChatPrint("You must be alive and near your spawn to buy a weapon!")
		return
	end
	
	local Item = args[1]
	if(!Item) then
		return
	end
	local ItemTable = STGamemodes.WeaponsMenu[Item]
	if(!ItemTable) then
		return
	end
	
	if(!ply.BuyWeapons) then
		ply.BuyWeapons = {}
	end
	
	local Type = ItemTable.Type
	local WeaponForType = ply.BuyWeapons[Type]
	
	if(WeaponForType != Item) then
		if(WeaponForType) then
			ply:StripWeapon(WeaponForType)
		end
		ply.BuyWeapons[Type] = Item
		STGamemodes:GiveWeapon(ply, Item)
	end
	
	if(Type == WEAPON_PRIMARY) then
		ply:WeaponMenu(WEAPON_SECONDARY)
	elseif(Type == WEAPON_SECONDARY) then
		ply:WeaponMenu(0)
		--ply:WeaponMenu(WEAPON_ADDON)
	end
	
	--ply:ChatPrint("You bought a weapon!")
end
concommand.Add("st_buyweapon", STGamemodes.BuyWeapon)
