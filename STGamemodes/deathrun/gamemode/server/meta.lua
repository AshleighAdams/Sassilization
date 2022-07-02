--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes.PlayerMeta:GoTeam(Team, NextRound, RoundCheck)
	if(!self or !self:IsValid()) then
		return
	end
	local CurrentTeam = self:Team()
	if(Team and CurrentTeam == Team) then
		return
	end
	
	if(NextRound and Team) then
		self:SetVar("ChangeTeam", Team)
	else
		if(Team) then
			if(CurrentTeam == TEAM_DEATH) then
				self:SetVar("WasDeath", true)
			end
			self:SetTeam(Team)
		end
		self:KillTrail()
		self:Spawn()
	end
	
	if(RoundCheck != false) then
		GAMEMODE:RoundChecks()
	end
end

function STGamemodes.EntityMeta:UpdateClaimed()
	if self:IsLinkedButton() then
		self = self:GetRootNode()
	end
	
	local Claimer = self:GetClaimed()
	local Claimed = Claimer and true or false
	
	local rp = RecipientFilter()
	for k,v in pairs(player.GetAll()) do
		if(v:Team() == TEAM_DEATH) then
			rp:AddPlayer(v)
		end
	end
	umsg.Start("STGamemodes.ClaimButton", rp)
		if self:IsLinkedButton() then --If a linked button
			local btns = self:LinkedToTable() --From the root node, get all of htem in a table
			-- PrintTable(btns)
			local num = table.maxn(btns) --Get the number of buttons.
			umsg.Short(num) --Send it to he plyer for looping
			for k,v in pairs(btns) do --Loop through all buttons
				umsg.Entity(v) --Adding the button
			end
			umsg.Bool(Claimed) --Whether the initial one was claimed
			if(Claimed) then --And if claimed add its claimer, no need to send 3 times as its considered a group.
				umsg.Entity(Claimer)
			end
		else
			umsg.Short(1)
			umsg.Entity(self)
			umsg.Bool(Claimed)
			if(Claimed) then
				umsg.Entity(Claimer)
			end
		end
	umsg.End()
end

function STGamemodes.PlayerMeta:LastManStanding(bool)
	local id = self:UniqueID()
	
	if bool then
		if !self.IsLastManStanding then
			self.IsLastManStanding = true
			self:SetColor(Color(255, 0, 0, 255))
			self:KillHat()
			STGamemodes.ShrinkScale(self, 2)
			STGamemodes:PrintAll(self:CName().." is the Last Man Standing!")

			umsg.Start("LastManStanding.Overlay", self)
				umsg.Bool(true)
			umsg.End()
			
			timer.Create("LastManStanding_"..id, 0.5, 0, function()
				if IsValid(self) and self:Alive() then
					local hp = self:Health() + 5
					if hp <= self:GetMaxHealth() then
						self:SetHealth(hp)
					end
				else
					self:LastManStanding(false)
					timer.Destroy("LastManStanding_"..id)
				end
			end)
		end
	else
		if self.IsLastManStanding then
			self.IsLastManStanding = false
			self:SetColor(color_white)
			STGamemodes.ShrinkScale(self, 1)
			
			umsg.Start("LastManStanding.Overlay", self)
				umsg.Bool(false)
			umsg.End()
			
			timer.Destroy("LastManStanding_"..id)
		end
	end
end
