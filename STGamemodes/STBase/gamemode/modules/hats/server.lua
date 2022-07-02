--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes.PlayerMeta:SetupHat()
	if(!STValidEntity(self)) then
		return
	end
	self:KillHat()
	if(!self:Alive()) then
		return
	end
	local Name = STGamemodes.Store:GetItemInfo(self, "Hats", "Selected")

	if self:IsFake() then 
		local Hat = self.FakeHat or ""
		if Hat and Hat != "" then 
			Name = Hat 
		else 
			return 
		end 
	end 

	if(!Name or !STGamemodes.Hats[Name]) then
		return
	end
	if !self.Frozen then
		self:Freeze(true)
	end
	self.Hat = ents.Create("st_hat")
	self.Hat:SpawnHat(self, Name)
	self.Hat:Spawn()
	self.Hat:Activate()
	if !self.Frozen then
		self:Freeze(false)
	end
end

function STGamemodes.PlayerMeta:KillHat()
	if self.Hat and self.Hat:IsValid() then
		self.Hat:Remove()
	end
end

function STGamemodes.PlayerMeta:RemoveHat()
	if !self:IsValid() then return end 
	self:KillHat()

	if self:IsFake() then 
		ply:ChatPrint("Please disable fakename before doing this") 
		return 
	end 

	if(!STGamemodes.Store:GetItemInfo(self, "Hats", "Selected")) then
		self:ChatPrint("Your hat has already been removed!")
		return
	end
	self.Hat = false
	STGamemodes.Store:SetItemInfo(self, "Hats", "Selected", false)
	STGamemodes.Store:SendCatItem(self, "Hats", "Selected")
	self:ChatPrint("Your hat has been removed")
end
