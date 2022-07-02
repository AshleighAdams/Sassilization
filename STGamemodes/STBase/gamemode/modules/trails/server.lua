--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes.PlayerMeta:CreateTrail(TrailMat, Message, Override)
	if(STGamemodes.DisableTrails and !Override and !self.CanHaveTrail) then
		-- if(Message) then
		-- 	self:ChatPrint("This gamemode does not support trails")
		-- end
		return
	end
	if(self.Trail and self.Trail:IsValid()) then
		self.Trail:Remove()
	end
	local Mat = TrailMat or STGamemodes.Store:GetItemInfo(self, "Trails", "Selected")
	local Col = STGamemodes.Store:GetItemInfo(self, "Trails", "Col")

	if self:IsFake() then 
		local mat = self.FakeTrail or ""
		if mat and mat != "" then 
			Mat = mat 
			Col = Color(255, 255, 255, 255)
		else 
			Mat = false 
			Col = false 
		end 
	end 

	if(STGamemodes.Trails[Mat]) then
		Mat = STGamemodes.Trails[Mat][1]
	end

	if(!Col or !Mat) then
		return
	end
	if(Message) then
		--self:ChatPrint("Your trail has been updated")
	end
	if(!self:Alive()) then
		return
	end
	self.Trail = ents.Create("st_trailpoint")
	self.Trail:SetPos(self:GetPos() + Vector(0, 0, 5) + (self:GetAimVector() * -25))
	self.Trail:Spawn()
	self.Trail:Activate()
	self.Trail:SetParent(self)
	self.Trail:SetTrail(util.SpriteTrail(self.Trail, 0, Col, false, 15, 1, 6, .025, Mat..".vmt"))
end

function STGamemodes.PlayerMeta:KillTrail()
	if(IsValid(self.Trail)) then
		self.Trail:Remove()
	end
end

function STGamemodes.PlayerMeta:RemoveTrail()
	if(self.Trail and self.Trail:IsValid()) then
		self.Trail:Remove()
	end
	if(!self.Trail) then
		self:ChatPrint("Your trail has already been removed!")
		return
	end
	self.Trail = false
	STGamemodes.Store:SetItemInfo(self, "Trails", "Selected", false)
	STGamemodes.Store:SendCatItem(self, "Trails", "Selected")
	self:ChatPrint("Your trail has been removed")
end
