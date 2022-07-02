--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons = {}
STGamemodes.Weapons.Entities = {}
STGamemodes.Weapons.Positions = {}
STGamemodes.Weapons.RemovePositions = {}

function STGamemodes.Weapons:Add( Position, NoRemove )
	self.Positions[Position] = false
	self.ShouldRunRemoveAllGuns = NoRemove and false or true
end

function STGamemodes.Weapons:Remove(Position)
	table.insert(self.RemovePositions, Position)
end

function STGamemodes.Weapons:RemoveGuns(Distance)
	if(!self:RunRemoveAllGuns()) then
		for k,v in pairs(self.RemovePositions) do
			for k2,v2 in pairs(ents.FindInSphere(v, Distance or 50)) do
				if(v2 and v2:IsValid() and (v2:IsWeapon() or v2:GetClass() == "weapon_spawn")) then
					v2:Remove()
				end
			end
		end
	end
end

function STGamemodes.Weapons:RemoveAllGuns()
	self.ShouldRunRemoveAllGuns = true
end

local AllowedGuns = {"weapon_frag", "weapon_ak47", "weapon_deagle", "weapon_spawn"}
function STGamemodes.Weapons:RunRemoveAllGuns()
	if(!self.ShouldRunRemoveAllGuns) then
		return false
	end
	for k,v in pairs(ents.GetAll()) do
		if(v and v:IsValid() and (v:IsWeapon() and !table.HasValue(AllowedGuns, v:GetClass()))) then
			v:Remove()
		end
	end
	return true
end

function STGamemodes.Weapons:Spawn()
	for k,v in pairs(self.Positions) do
		if(!v or !v:IsValid()) then
			local Weapon = ents.Create("weapon_spawn")
			Weapon:SetPos(k)
			Weapon:Spawn()
			Weapon:Activate()
			self.Positions[k] = Weapon
		end
	end
end
