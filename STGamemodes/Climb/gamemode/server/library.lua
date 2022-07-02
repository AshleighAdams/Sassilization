--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes:OnStoreInit(ply)
	ply:ChatPrint("Store: Loading... Please Wait..")
end

function STGamemodes:OnStoreLoad(ply)
	ply.CanPlay = true
end

function STGamemodes:InitHostages()
	if(!self.HostageEntities) then
		return
	end
	
	local Pos, Angles
	
	if(self.Hostages) then
		for k,v in pairs(self.Hostages) do
			if(STValidEntity(v)) then
				v:Remove()
			end
		end
	end
	
	self.Hostages = {}
	
	for k,v in pairs(self.HostageEntities) do
		local Continue = true
		
		if(STValidEntity(v)) then
			Angles = v:GetAngles()
			Pos = v:GetPos() + Vector(0, 0, 5)
		else
			Angles = v.Angles
			Pos = v.Pos
		end
		
		if(self.RemoveHostages) then
			for k2,v2 in pairs(self.RemoveHostages) do
				if(Pos:Distance(v2) < 200) then
					Continue = false
				end
			end
		end
		
		if(Continue) then
			local Trace = {}
			Trace.start = Pos + Vector(0, 0, 20)
			Trace.endpos = Pos - Vector(0, 0, 20)
			Trace.mask = MASK_SOLID_BRUSHONLY
			local tr = util.TraceLine(Trace)
			
			local Hostage = ents.Create("npc_citizen")
			
			Hostage:SetAngles(Angles)
			Hostage:SetPos(tr.HitPos + Vector(0, 0, 6))
			
			Hostage:SetMoveType(MOVETYPE_NONE)
			Hostage:SetSchedule(SCHED_IDLE_STAND)
			Hostage:SetKeyValue("spawnflags", bit.bor(16 , 128 , 16384)) 
			Hostage:Spawn() //Appears to reset the movetype
			Hostage:SetMoveType(MOVETYPE_NONE) //Sets movetype back to none so those helicopter or other end-map thing don't push hostages.
			Hostage:Activate()
			
			Hostage.UsedHostage = {}
			
			if(k < 5) then
				Hostage:SetModel("models/characters/hostage_0"..tostring(k)..".mdl")
			else
				Hostage:SetModel("models/characters/hostage_0"..tostring(math.random(1, 4))..".mdl")
			end
			
			table.insert(self.Hostages, Hostage)
		end
	end
end

function STGamemodes:CreateHostage(Pos, Angles)
	if(!STGamemodes.HostageEntities) then
		STGamemodes.HostageEntities = {}
	end
	table.insert(STGamemodes.HostageEntities, {
		Pos = Pos,
		Angles = Angles
	})
end

hook.Add( "InitPostEntity", "GM.GetMapID", function() GAMEMODE:GetMapID( game.GetMap() ) end )

function GM:GetMapID( mapname )
	
	tmysql.query("SELECT id FROM cl_maps WHERE name = '"..mapname.."'", function( res, stat, err )
		if(err != 0) then
			Error(err)
		end
		if(!(res and res[1])) then
			tmysql.query("INSERT INTO main.cl_maps (name) VALUES ('"..mapname.."')", function( res, stat, err )
				self:GetMapID( mapname )
			end )
		else
			self.MapID = res[1][1]
		end
	end)

end

local WinMessage
function STGamemodes:OnWin(ply)
	if(self.Winners[ply:SteamID()]) then
		return
	end
	
	ply:EndTime()
	
	self.Winners[ply:SteamID()] = true
	
	local TotalTime = math.Round(ply:GetTotalTime(), 2)
	local WinMessage = ply:CName().." made it to the end in "..STGamemodes:SecondsToFormat(TotalTime, true)	

	ply.Winner = true
	ply:SetNWString("ScoreboardStatus", "Winner")
	ply:Give("st_jetpack")
	ply.CanHaveTrail = true
	ply:CreateTrail()
	ply:SetNWFloat("WinTime", TotalTime)

	if (!self.NoSaveBonus[ply:SteamID()]) then		
	    WinMessage = WinMessage.." without using any saves!"	
	end
	
	WinMessage = WinMessage..' Total Jump Count: '..ply:GetJumpCount()..' Total Fail Count: '..ply:GetFailCount()
	
	STGamemodes.Logs:ParseLog( WinMessage.."("..game.GetMap()..")" )

	local EmitIt = self.WinSounds[math.random(1, table.Count(self.WinSounds))]
	
	for k,v in pairs(player.GetAll()) do
		v:ChatPrint(WinMessage)
		v:EmitSound(EmitIt, 250)
	end
	
	ply:ChatPrint("If you want to replay the map type /climbrestart in chat")

	local Record = STGamemodes.Records:CheckNew(ply, TotalTime)
	
	STAchievements:AddCount(ply, "Rescuer")
	if(!self.NoSaveBonus[ply:SteamID()]) then
		STAchievements:AddCount(ply, "No Saves Required")
		STAchievements:AddCount(ply, "No Saver")
	end
	
	if( GAMEMODE.MapID ) then
		tmysql.query("INSERT INTO cl_times (pid, map, time, date) VALUES ('"..ply.PlayerID.."', '"..tostring(GAMEMODE.MapID).."', '"..tostring(TotalTime).."', '"..tostring(os.time()).."')")
	end

	if Record then
		STGamemodes.Records:Load() -- Reload them
		STGamemodes.Records:AwardFame( ply )
	end
	
	ply:ResetFailCount() //Reset them now just cause.
	ply:ResetJumpCount()
end

function STGamemodes:GetWinAmts(ply, Both) 
	local HostyCount = table.Count((STGamemodes.HostageEntities or {"hi"}))
	local RecieveMoney = GAMEMODE.WinMoney/HostyCount
	if(!ply:IsVIP()) then
		RecieveMoney = RecieveMoney * 0.75
	end
	local Nosave, Save 
	if(self.NoSaveBonus[ply:SteamID()] or Both) then
		Save = math.Round(RecieveMoney/100)*100 
		if !Both then 
			return Save 
		end  
		Save = Save * HostyCount
	end  
	if !self.NoSaveBonus[ply:SteamID()] or Both then 
		if GAMEMODE.NoSaveWinMoney then
			RecieveMoney = GAMEMODE.NoSaveWinMoney/HostyCount
			if !ply:IsVIP() then RecieveMoney = RecieveMoney*0.75 end
		else
			RecieveMoney = RecieveMoney * 3.5
		end
		
		Nosave = math.Round(RecieveMoney/100)*100
		if !Both then 
			return Nosave 
		end 
		Nosave = Nosave * HostyCount 
	end
	return Save, Nosave
end 


local Wins = {}
function STGamemodes:OnHostage(ply, ent)
	if(ent.UsedHostage[ply:SteamID()]) then
		return
	end

	ent.UsedHostage[ply:SteamID()] = true

    if (Wins[ply:SteamID()]) then		
        Wins[ply:SteamID()] = Wins[ply:SteamID()] + 1		
    else		
        Wins[ply:SteamID()] = 1		
    end

	ply:ChatPrint(self.WinnerMessages[math.random(1, table.Count(self.WinnerMessages))])

	local RecieveMoney = STGamemodes:GetWinAmts(ply, Both)
	if self.NoSaveBonus[ply:SteamID()] then
		ply:GiveMoney(RecieveMoney, "The hostage gave you %s dough")
	else
		ply:GiveMoney(RecieveMoney, "The hostage gave you %s dough for not using any saves!")
	end
end

function STGamemodes:OnRestart(ply)
	local SteamID = ply:SteamID()

    if(Wins[SteamID]) then
        if (Wins[SteamID] >= #self.Hostages*3) then
            ply:ChatPrint("You can only restart 2 times per map!")	
            return	
        end	
    end

    self.TeleportPos[ply:SteamID()] = nil
	
	self.Winners[SteamID] = nil
	
	if self.Hostages then 
		for k,v in pairs(self.Hostages) do
			if(v.UsedHostage and v.UsedHostage[SteamID]) then
				v.UsedHostage[SteamID] = nil
			end
		end
	end 
	
	ply.Winner = nil
	ply.CanHaveTrail = nil
	
	self.Climbs[SteamID] = {}
	self.NoSaveBonus[SteamID] = nil
	
	self.Slots[SteamID] = {}
	self.Slots[SteamID].Slot = 0
	self.Slots[SteamID].SaveSlot = 0
	self.Slots[SteamID].LastSlot = 0
	
	ply:StartTime(true)
	
	ply:SetNWString("ScoreboardStatus", "Playing")
	
	ply:Spawn()
	
	ply:ChatPrint("You can now start climbing again!")
end
