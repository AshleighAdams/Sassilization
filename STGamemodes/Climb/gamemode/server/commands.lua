--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Slots = {}
STGamemodes.Climbs = {}
STGamemodes.NoSave = {}
STGamemodes.NoSaveBonus = {}

concommand.Add("st_payout", function(ply) 
	ply:PayoutMsg()
end)
STGamemodes:AddChatCommand( "payout", "st_payout" )

concommand.Add("st_climbrestart", function(ply, cmd, args)
	--if(!STGamemodes.Winners[ply:SteamID()]) then
		--ply:ChatPrint("You can't restart until you win!")
		--return
	--end
	STGamemodes:OnRestart(ply)
end)

concommand.Add("st_climbnosave", function(ply, cmd, args)
	if(STGamemodes.NoSave[ply:SteamID()]) then
		STGamemodes.NoSave[ply:SteamID()] = false
		ply:ChatPrint("NoSave: Disabled. You can now save your positions")
	else
		STGamemodes.NoSave[ply:SteamID()] = true
		ply:ChatPrint("NoSave: Enabled. You can no longer save your positions")
	end
end)

STGamemodes:AddChatCommand("climbrestart", "st_climbrestart")
STGamemodes:AddChatCommand("nosave", "st_climbnosave")

function STGamemodes:ClimbCommand(ply, cmd, args)
	local Command = args[1]
	
	if(!Command) then
		return
	end
	
	local Text = ""
	local TableSelect = false
	local SteamID = ply:SteamID()
	
	if(STGamemodes.NoSave[SteamID]) then
		ply:ChatPrint("You have NoSave enabled, you must disable it to save")
		return
	end
	
	if(!self.Climbs[SteamID]) then
		self.Climbs[SteamID] = {}
	end
	
	if(!self.Slots[SteamID]) then
		self.Slots[SteamID] = {}
	end
	
	if(self.Slots[SteamID].Slot == nil) then
		self.Slots[SteamID].Slot = 0
	end
	
	if(self.Slots[SteamID].SaveSlot == nil) then
		self.Slots[SteamID].SaveSlot = 0
	end
	
	if(self.Slots[SteamID].LastSlot == nil) then
		self.Slots[SteamID].LastSlot = 0
	end
	
	if(ply:Team() != TEAM_CLIMB) then
		Text = "You must be playing to use this command"
	elseif(Command == "1") then //Save counter if  I add one.
		if !ply:Alive() then 
			Text = "You must be alive to save your position" 
		elseif(!ply:OnGround()) then
			Text = "You must be on the ground to use this command"
		elseif(ply:Crouching()) then
			local Trace = {}
			Trace.start = ply:GetPos()
			Trace.endpos = Trace.start + Vector(0, 0, 150)
			Trace.mask = MASK_SOLID_BRUSHONLY
			local tr = util.TraceLine(Trace)
			if(tr.HitWorld) then
				Text = "You can't save your position while crouching!"
			end
		end 
		if(Text == "") then
			Text = "You have saved your current position"
			if(self.Slots[SteamID].SaveSlot >= 20) then
				self.Slots[SteamID].SaveSlot = 0
			end
			self.Slots[SteamID].SaveSlot = self.Slots[SteamID].SaveSlot + 1
			self.Slots[SteamID].Slot = self.Slots[SteamID].SaveSlot
			self.Slots[SteamID].LastSlot = self.Slots[SteamID].SaveSlot
			self.Climbs[SteamID][self.Slots[SteamID].SaveSlot] = {Pos = ply:GetPos(), EyeAngle = ply:EyeAngles(), Gravity = ply:GetGravity()}
			if(!self.NoSaveBonus[SteamID]) then
				self.NoSaveBonus[SteamID] = true
			end
			STAchievements:AddCount(ply, "Can't Survive Without Saves")
		end
	elseif(Command == "2") then //Teleport counter goes around in or below here depending on the command.
		TableSelect = self.Slots[SteamID].LastSlot
	elseif(Command == "3") then
		if(self.Slots[SteamID].Slot >= table.Count(self.Climbs[SteamID])) then
			self.Slots[SteamID].Slot = 0
		end
		self.Slots[SteamID].Slot = self.Slots[SteamID].Slot + 1
		TableSelect = self.Slots[SteamID].Slot
	elseif(Command == "4") then
		self.Slots[SteamID].Slot = self.Slots[SteamID].Slot - 1
		if(self.Slots[SteamID].Slot <= 0) then
			self.Slots[SteamID].Slot = math.Max(table.Count(self.Climbs[SteamID]), 1)
		end
		TableSelect = self.Slots[SteamID].Slot
	elseif(Command == "5") then
		self.Climbs[SteamID] = {}
		self.Slots[SteamID].Slot = nil
		self.Slots[SteamID].SaveSlot = nil
		self.Slots[SteamID].LastSlot = nil
		Text = "Your saves have been cleared"
	end
	
	if(TableSelect) then
		local Table = self.Climbs[SteamID][TableSelect]
		if(Table) then
			ply:SetGravity(Table.Gravity)
			ply:SetVelocity(Vector(0, 0, 0))
			ply:SetLocalVelocity(Vector(0, 0, 0))
			ply:SetPos(Table.Pos)
			ply:SetEyeAngles(Table.EyeAngle)
		end
	end
	
	ply:ChatPrint(Text)
end
concommand.Add("st_climbcmd", function(ply, cmd, args) STGamemodes:ClimbCommand(ply, cmd, args) end)
