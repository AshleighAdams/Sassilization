--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Commands = {}
SetGlobalBool("funmode", false)

/*---------------------------------------------------------
   Fun Commands
---------------------------------------------------------*/

function STGamemodes.Commands.FunMode(ply, cmd, args) 
	if !ply:IsSuperAdmin() then return end 

	local val = args[1] 
	if !val or val != "0" or val != "1" then val = !GetGlobalBool("funmode", false) end 
	val = tobool(val)
	SetGlobalBool("funmode", val) 
	ply:ChatPrint("FunMode: ".. (val and "Enabled" or "Disabled")) 
end 
concommand.Add("st_funmode", STGamemodes.Commands.FunMode)

function STGamemodes.Commands.Shrink(ply, cmd, args)
	if !ply:IsSuperAdmin() then return end 

	local Target, Size = args[1], args[2]
	if !Target then
		ply:ChatPrint("Syntax: st_shrink PlayerName Size (1 default size)")
		return 
	end 

	if !Size then Size = 1 end 

	Target = STGamemodes.FindByPartial(Target) 

	if !STValidEntity(Target) then 
		ply:ChatPrint(Target) 
		return 
	end 

	STGamemodes.ShrinkScale(Target, tonumber(Size))
	ply:ChatPrint("Scaled ".. Target:Name() .."'s head!") 
end 
concommand.Add("st_shrink", STGamemodes.Commands.Shrink)

function STGamemodes.Commands.Bigme(ply, cmd, args) 
	if !ply:IsSuperAdmin() then return end 

	STGamemodes:SetBigme(tobool(args[1])) 
end 
concommand.Add("st_bigme", STGamemodes.Commands.Bigme) 

function STGamemodes.Commands.SpawnEnt(ply, cmd, args)
	if(!ply:IsSuperAdmin() /*or !GetGlobalBool("funmode", false)*/) then
		return
	end
	local Class = args[1]
	if(!Class) then
		return
	end
	
	local Trace = {}
	Trace.start = ply:GetShootPos()
	Trace.endpos = Trace.start + (ply:GetAimVector() * 2048)
	Trace.filter = ply
	local tr = util.TraceLine(Trace)
	
	local ang = ply:EyeAngles()
	ang.yaw = ang.yaw + 180
	ang.roll = 0
	ang.pitch = 0
	
	local Ent = ents.Create(Class)
	if(Ent and IsValid(Ent)) then
		Ent:SetAngles(ang)
		Ent:SetPos(tr.HitPos + (tr.HitNormal * 16))
		Ent:Spawn()
		Ent:Activate()
		ply.LastEntSpawn = Ent
	end
end
concommand.Add("st_spawnent", STGamemodes.Commands.SpawnEnt)

function STGamemodes.Commands.UndoEnt(ply, cmd, args)
	if(!ply:IsSuperAdmin()) then
		return
	end
	if(STValidEntity(ply.LastEntSpawn)) then
		ply.LastEntSpawn:Remove()
	end
end
concommand.Add("st_undoent", STGamemodes.Commands.UndoEnt)


function STGamemodes.Commands.Random(ply, cmd, args)
	if !ply:IsAdmin() then return end
	
	local target = table.Random(player.GetAll()):CName()
	local msg = STGamemodes.GetPrefix(ply) .. " " .. ply:CName() .. " randomly picked " .. target
	
	if args[1] then
		-- Nice way of checking if the money was given. GiveMoney takes care of all the checks, and it returns the given amount if invoked by st_random.
		local givenAmt = STGamemodes.Commands.GiveMoney(ply, "st_random", {target, args[1]})
		if type(givenAmt) == "number" then
			msg = msg .. " and gave them " .. givenAmt .. " dough"
		end
	end
	
	STGamemodes:PrintAll(msg)
end
concommand.Add("st_random", STGamemodes.Commands.Random)

function STGamemodes.Commands.RandomizeModels(ply, cmd, args)	
	if !ply:IsSuperAdmin() then return end
	
	local models = {}
	
	if #args > 0 then
		local pattern = "models/.+\\.mdl"
		
		for k,v in pairs(args) do
			local mdl, ent
			local index = tonumber(v)
			
			if index then
				ent = ents.GetByIndex(index)
			else
				if string.match(v, pattern) then
					mdl = v
				else
					ent = ents.FindByName(v)[1]
				end
			end
			
			if ent and ent:IsValid() and string.match(ent:GetModel(), pattern) then
				mdl = ent:GetModel()
			end
			
			table.insert(models, mdl)
		end
	else
		models = STGamemodes.PlayerModels
	end
	
	if table.Count(models) > 0 then
		for k,v in pairs(player.GetAll()) do
			local cond = (GAMEMODE.Name == "STDeathrun" or GAMEMODE.Name == "STZombieEscape") and v:Team() == 3 or v:Alive()
			if cond then
				v:SetModel(table.Random(models))
			end
		end
	end
end
concommand.Add("st_randomize", STGamemodes.Commands.RandomizeModels)

function STGamemodes.Commands.PublicVote(ply, cmd, args)
	if(!ply:IsSuperAdmin()) then
		return
	end

	local Question = args[1]
	table.remove(args, 1)

	if !Question or !args[1] then 
		ply:ChatPrint( "Syntax: st_publicvote Question Options" )
		return 
	end 

	STGamemodes.Vote:Start(Question, args,
		function()
			STGamemodes:PrintAll(STGamemodes.GetPrefix(ply).." "..ply:CName().." has started a public vote")
		end,
		function(Choice, Ply, Canceled)
			if Canceled then 
				STGamemodes:PrintAll("The public vote has been canceled by Administrator")
			else 
				STGamemodes:PrintAll("The public has spoken! Their vote is: "..tostring(Choice)) 
			end 
		end
	, nil, true)
end
concommand.Add("st_publicvote", STGamemodes.Commands.PublicVote)

function STGamemodes.Commands.Me(ply, cmd, args)
	local Text = table.concat(args, " ")

	if !args[1] then 
		return
	elseif ply:IsCMuted() then
		ply:ChatPrint("You are muted.")
		return
	elseif STGamemodes:AntiChatSpam( ply, Text ) == "" then
		return
	end

	Text = "* "..ply:CName().." "..Text

	for _, v in pairs(player.GetAll()) do
		umsg.Start("STGamemodes.ChatBox.Me", v)
			umsg.String(Text)
		umsg.End()
	end
end
concommand.Add("st_me", STGamemodes.Commands.Me)

function STGamemodes.Commands.Act( ply, cmd, args)
	if(!args[1]) then
		return
	end
	
	umsg.Start( "STGamemodes.StartAct", ply )
		umsg.String( "act ".. args[1] )
	umsg.End()
end
concommand.Add("st_act", STGamemodes.Commands.Act )

function STGamemodes.Bring(ply, cmd, args)
	if(!STGamemodes.CanUseCommand(ply) and !ply:IsMapper()) then
		return
	end
	
	local PlayerName = args[1]
	
	if(!PlayerName) then
		ply:ChatPrint( "Syntax: /bring PlayerName" )
		return
	end
	
	local Target = STGamemodes.FindByPartial(PlayerName)
	
	if(type(Target) == "string") then
		ply:ChatPrint( Target )
	else
		Target:SetPos(ply:GetPos())
		ply:ChatPrint("You teleported "..Target:CName())
		Target:ChatPrint(STGamemodes.GetPrefix(ply).." "..ply:CName().." teleported you")
		STGamemodes.Logs:ParseLog("%s teleported %s", ply, Target)
	end
end
concommand.Add("st_bring", STGamemodes.Bring)

function STGamemodes.Goto(ply, cmd, args)
	if !(ply:IsWinner() /*and ply:IsVIP()*/ and (GAMEMODE.Name == "Bunny Hop" or GAMEMODE.Name == "Climb")) then 
		if !STGamemodes.CanUseCommand(ply) and !ply:IsMapper() then
			return
		end
	end 
	
	local PlayerName = args[1]
	
	if(!PlayerName) then 
		ply:ChatPrint( "Syntax: /goto PlayerName" )
		return
	end
	
	local Target = STGamemodes.FindByPartial(PlayerName)
	
	if(type(Target) == "string") then
		ply:ChatPrint( Target)
	else
		ply:SetPos(Target:GetPos())
		ply:ChatPrint("You teleported to "..Target:CName())
		STGamemodes.Logs:ParseLog("%s teleported to %s", ply, Target)
	end
end
concommand.Add("st_goto", STGamemodes.Goto)

function STGamemodes.Spawn(ply, cmd, args)
	if(!STGamemodes.CanUseCommand(ply)) then
		return
	end
	
	local PlayerName = args[1]
	
	if(!PlayerName) then
		ply:ChatPrint("Syntax: /spawn PlayerName")
		return
	end
	
	local Target = STGamemodes.FindByPartial(PlayerName)
	
	if(type(Target) == "string") then
		ply:ChatPrint(Target)
	else
		Target:SetTeam(TEAM_RUN)
		Target:Spawn()
		ply:ChatPrint("You spawned "..Target:CName())
		Target:ChatPrint(STGamemodes.GetPrefix(ply).." "..ply:CName().." spawned you")
		STGamemodes.Logs:ParseLog("%s spawned %s", ply, Target)
	end
end
concommand.Add("st_spawn", STGamemodes.Spawn)

function STGamemodes.Commands.Cannon(ply, cmd, args)
	if !ply:IsSuperAdmin() then return end
	
	local aim = ply:GetAimVector()
	
	local ball = ents.Create("sent_ball")
	ball:SetPos(ply:EyePos() + aim * 36)
	ball:Spawn()
	
	ball:GetPhysicsObject():ApplyForceCenter(aim * 2000)
	ply:EmitSound("weapons/grenade_launcher1.wav")
end
concommand.Add("st_cannon", STGamemodes.Commands.Cannon)

function STGamemodes.Commands.Launcher(ply, cmd, args)
	if !ply:IsSuperAdmin() then return end
	
	local aim = ply:GetAimVector()
	local ang = ply:Crouching() and Angle(0, 0, 90) or Angle(0, 0, 0)
	
	local prop = ents.Create("prop_physics")
	prop:SetModel("models/props_c17/oildrum001_explosive.mdl")
	prop:SetPos(ply:EyePos() + aim * 40)
	prop:SetAngles(ang + ply:EyeAngles())
	prop:SetKeyValue("physdamagescale", "4")
	prop:Spawn()
	
	local phys = prop:GetPhysicsObject()
	phys:ApplyForceCenter(aim * phys:GetMass() * 2000)
	ply:EmitSound("weapons/mortar/mortar_fire1.wav")
end
concommand.Add("st_launcher", STGamemodes.Commands.Launcher)

function STGamemodes.Commands.Nuke(ply, cmd, args)
	if !ply:IsSuperAdmin() then return end
	
	local aim = ply:GetAimVector()
	
	local prop = ents.Create("prop_physics")
	prop:SetModel("models/props_phx/misc/flakshell_big.mdl")
	prop:SetPos(ply:EyePos() + aim * 32)
	prop:SetAngles(Angle(90, 0, 0) + ply:EyeAngles())
	prop:SetKeyValue("physdamagescale", "4")
	prop:Spawn()
	
	local phys = prop:GetPhysicsObject()
	phys:ApplyForceCenter(aim * phys:GetMass() * 2000)
	ply:EmitSound("weapons/stinger_fire1.wav")
	
	local id = prop:GetCreationID()
	hook.Add("PropBreak", "NukeBreak_" .. id, function(ply1, prop1)
		if prop1 != prop then return end
		
		timer.Simple(1, function()
			for k,v in pairs(ents.FindByModel("models/props_phx/gibs/flakgib1.mdl")) do
				v:SetKeyValue("ExplodeDamage", "100")
				timer.Simple(k / 10, function() if v:IsValid() then v:Fire("Break") end end)
			end
		end)
		
		hook.Remove("PropBreak", "NukeBreak_" .. id)
	end)
end
concommand.Add("st_nuke", STGamemodes.Commands.Nuke)

/*---------------------------------------------------------
   Administration Commands
---------------------------------------------------------*/


function STGamemodes.Commands.CancelVote( ply )
	if !ply:IsMod() then return end
	if STGamemodes.Vote.Voting and (STGamemodes.Vote.CanCancel or ply:IsAdmin()) then
		STGamemodes.Vote:EndEarly() 
		STGamemodes:PrintMod(STGamemodes.GetPrefix(ply).." "..ply:CName().." canceled the vote (".. STGamemodes.Vote.Name ..")")
		STGamemodes.Logs:ParseLog("Vote canceled by %s", ply)
	elseif !STGamemodes.Vote.Voting then
		ply:ChatPrint( "There is no vote silly." )
	elseif !STGamemodes.Vote.CanCancel then
		ply:ChatPrint( "You cannot cancel this vote." )
	end 
end 
concommand.Add("st_cancelvote", STGamemodes.Commands.CancelVote )

function STGamemodes.Commands.FakeNamers(ply, cmd, args)
	if(!STGamemodes.FakeName:CanFakeName(ply)) then
		return
	end
	for k,v in pairs(player.GetAll()) do
		if(STGamemodes.FakeName:CanFakeName(v)) then
			ply:ChatPrint(v:GetName().." | "..v:CName())
		end
	end
end
concommand.Add("st_fakenamers", STGamemodes.Commands.FakeNamers)

/*---------------------------------------------------------
   Maps Commands
---------------------------------------------------------*/

function STGamemodes.Commands.StartVotemap(ply, cmd, args)
	if(!ply:IsMod()) then
		return
	end
	STGamemodes:PrintAll(STGamemodes.GetPrefix(ply).." "..ply:CName().." has started a votemap")
	STGamemodes.Maps:StartMaps(true)
end
concommand.Add("st_svm", STGamemodes.Commands.StartVotemap)
concommand.Add("st_startvotemap", STGamemodes.Commands.StartVotemap)

function STGamemodes.Commands.NextMap(ply, cmd, args)
	if(!ply:IsSuperAdmin()) then
		return
	end
	
	local MapList = STGamemodes.Maps:GetMapRotation()
	local CurrentMap = string.Trim(string.lower(game.GetMap()))
	local Index = false
	for k,v in pairs(MapList) do
		if(v == CurrentMap) then
			Index = k
		end
	end
	local NextMap = MapList[Index + 1]
	if(!NextMap) then
		return
	end
	if(!STGamemodes.Maps:IsValid(NextMap)) then
		STGamemodes:PrintAll("Nextmap is invalid: "..NextMap)
		return
	end
	STGamemodes:ChangeMap(ply, NextMap)
end
concommand.Add("st_nextmap", STGamemodes.Commands.NextMap)

function STGamemodes.Commands.Restart(ply, cmd, args)
	if(!ply:IsMod()) then
		return
	end
	STGamemodes:ChangeMap(ply, game.GetMap())
end
concommand.Add("st_restart", STGamemodes.Commands.Restart)

function STGamemodes.Commands.ChangeMap(ply, cmd, args)
	if(!ply:IsAdmin() and !ply:IsMapper()) then
		return
	end
	local NewMap = args[1]
	if(!NewMap or !STGamemodes.Maps:IsValid(NewMap)) then
		if NewMap then 
			ply:ChatPrint( "Invalid Map: ".. NewMap )
		end 
		return
	end
	STGamemodes:ChangeMap(ply, NewMap)
end
concommand.Add("st_changemap", STGamemodes.Commands.ChangeMap)

local ValidGMs = {"bhop", "climb", "zombieescape", "deathrun"}--, "surf"}
function STGamemodes.Commands.ChangeGamemode(ply, cmd, args)
	if !STGamemodes.GateKeeper.DevMode then return end 
	if !ply:IsAdmin() and !ply:IsMapper() then return end 

	local NewMap = args[1]
	local Gamemode = args[2]
	if(!NewMap or !STGamemodes.Maps:IsValid(NewMap)) then
		if NewMap then 
			ply:ChatPrint( "Invalid Map: ".. NewMap )
		end 
		return 
	end 

	if Gamemode and !ply:IsSuperAdmin() then 
		if !table.HasValue(ValidGMs, Gamemode) then 
			ply:ChatPrint("Invalid Gamemode: ".. Gamemode) 
			return 
		end 
	end 

	STGamemodes:ChangeGamemode(ply, NewMap, Gamemode)
end
concommand.Add("st_changegame", STGamemodes.Commands.ChangeGamemode)

/*---------------------------------------------------------
   Development Commands
---------------------------------------------------------*/

function STGamemodes.Commands.RoundRestart(ply, cmd, args)
	if(!ply:IsSuperAdmin()) then
		return
	end

	ply:ChatPrint(tostring(GAMEMODE:RoundRestart()))
end
concommand.Add("st_roundrestart", STGamemodes.Commands.RoundRestart)

function STGamemodes.Commands.Crowbars(ply, cmd, args)
	if !ply:IsAdmin() and !ply:IsMapper() then return end 
	if table.HasValue(STGamemodes.Maps:GetMapRotation(), game.GetMap()) then return end 
	for k,v in pairs(player.GetAll()) do 
		if v:Team() == TEAM_RUN and !v:HasWeapon("weapon_crowbar") then
			v:Give("weapon_crowbar")
		end 
	end 
	GAMEMODE.RunnerWeapon = "weapon_crowbar" 
end 
concommand.Add("st_crowbars", STGamemodes.Commands.Crowbars)

function STGamemodes.Commands.Info(ply, cmd, args)
	if !ply:IsMod() and !ply:IsMapper() then return end
	
	local entity = ply

	if !STValidEntity(entity) then ply:ChatPrint("This is not a valid entity!") return end
	
	local pos = entity:GetPos()
	local ang = entity:GetAngles()

	ply:ChatPrint("Entity: ".. tostring(entity))
	ply:ChatPrint("Name: ".. entity:GetName())
	ply:ChatPrint("Position: ".. math.Round( pos.x ) ..", ".. math.Round( pos.y ) ..", ".. math.Round( pos.z ) )
	ply:ChatPrint("Angle: ".. math.Round( ang.p ) ..", ".. math.Round( ang.y ) ..", ".. math.Round( ang.r ) )
end
concommand.Add("st_info", STGamemodes.Commands.Info)

function STGamemodes.Commands.EntInfo(ply, cmd, args)
	if !ply:IsMod() and !ply:IsMapper() then return end
	
	local entity = ply:GetEyeTrace().Entity
	if entity:IsPlayer() then return end

	if !STValidEntity(entity) then ply:ChatPrint("This is not a valid entity!") return end
	
	local pos = entity:GetPos()
	local ang = entity:GetAngles()

	ply:ChatPrint("Entity: ".. tostring(entity))
	ply:ChatPrint("Name: ".. entity:GetName())
	ply:ChatPrint("Position: ".. math.Round( pos.x ) ..", ".. math.Round( pos.y ) ..", ".. math.Round( pos.z ) )
	ply:ChatPrint("Angle: ".. math.Round( ang.p ) ..", ".. math.Round( ang.y ) ..", ".. math.Round( ang.r ) )
end
concommand.Add("st_entinfo", STGamemodes.Commands.EntInfo)

function STGamemodes.Commands.MapTest(ply, cmd, args)
	if !ply:IsAdmin() then return end
	if !args[1] then return end
	
	local Question = ""
	local maps = args
	local ValidMaps = {}

	if maps[2] then 
		for k,v in pairs( maps ) do 
			v = string.lower(v)
			if v == STGamemodes.Maps.CurrentMap then 
				v = "extend" 
			end 

			if (STGamemodes.Maps:IsValid(v) or v == "extend") then 
				if v == "extend" then 
					v = "Extend"
				end 

				if table.HasValue( ValidMaps, v ) then 
					ply:ChatPrint( "Repeated Map: ".. v )
				else
					if v != "Extend" or (v == "Extend" and (STGamemodes.Maps.Extended < STGamemodes.Maps.MaxExtensions)) then 
						table.insert(ValidMaps, v )
					else 
						ply:ChatPrint( "You cannot extend the map any further" )
					end 
				end 
			else 
				ply:ChatPrint( "Invalid Map: ".. v )
			end 

			if table.Count(ValidMaps) > 1 then maps = nil end 

			Question = "Pick a map to test..."
		end 
	end 

	if maps then
		maps = string.lower(maps[1])

		if !STGamemodes.Maps:IsValid(maps) then 
			ply:ChatPrint( "Invalid Map: ".. maps )
			return 
		end 
		ValidMaps = {{"Yes", maps}, {"No", false}}
		Question = "Test the map ".. maps .."?"
	end
	
	STGamemodes.Vote:Start( Question, ValidMaps, 
	function()
		STGamemodes.Maps.NextMap = false 
		STGamemodes:PrintAll(STGamemodes.GetPrefix(ply).." "..ply:CName().." has started a map test vote.")
	end,
	function(Choice, Ply, Canceled)
		if Canceled then 
			STGamemodes:PrintAll( "Map test vote canceled by Administrator" )
		elseif Choice then
			if(!STGamemodes.Maps:IsValid(Choice) and Choice != "Extend") then
				STGamemodes:PrintAll( Choice .." is an invalid map." )
				return
			end
			timer.Destroy("STGamemodes.MapAlert")
			timer.Destroy("STGamemodes.Votemap")
			timer.Destroy("STGamemodes.ChangeMap")
			STGamemodes.Maps:EndMaps(Choice, true)
		else 
			STGamemodes:PrintAll( "Map test vote failed." )
		end
	end, nil, true)
end
concommand.Add("st_maptest", STGamemodes.Commands.MapTest)

/*---------------------------------------------------------
   Misc Commands
---------------------------------------------------------*/

function STGamemodes.Commands.JumpSpam(ply, cmd, args)
	-- STGamemodes.Bans:AddMySQLBan(ply:SteamID(), 21600, ply:GetName(), "Exploit")
	STGamemodes.Logs:ParseLog("%s was kicked for jump spamming", ply)
	STGamemodes.SecretKick(ply, "Don't Spam Jump")
end
concommand.Add("st_jumpspam", STGamemodes.Commands.JumpSpam)

function STGamemodes.Commands.TimerThink(ply, cmd, args)
	STGamemodes.Logs:ParseLog("%s was kicked for TimerThink", ply)
	STGamemodes.SecretKick(ply, "How Dare You!")
end
concommand.Add("st_timerthink", STGamemodes.Commands.TimerThink)

function STGamemodes.Commands.ChangeSpec(ply, cmd, args)
	if(ply:GetVar("LastChangeSpec", CurTime() - 5) + 1 >= CurTime()) then
		return
	end
	GAMEMODE:SpectateNext(ply, 1)
	ply:SetVar("LastChangeSpec", CurTime())
end
concommand.Add("st_changespec", STGamemodes.Commands.ChangeSpec)

function STGamemodes.Commands.VoiceFromFile(ply, cmd, args)
	RunConsoleCommand("kickid", ply:UserID(), "No Playing Music")
end
concommand.Add("st_voicefromfile", STGamemodes.Commands.VoiceFromFile)

function STGamemodes.Commands.Spec(ply, command, args)

	if ply:Alive() then 
		if !ply:IsMod() and !ply:IsMapper() then 
			if GAMEMODE.Name == "STDeathrun" then 
				if ply:Team() == TEAM_DEATH then 
					ply:ChatPrint( "Deaths are not allowed to use this" )
					return
				elseif GAMEMODE.PickedUp then 
					ply:ChatPrint( "Please wait until a new round begins" )
					return 
				end 
			end 

			if ply.LastDamage and ply.LastDamage+10 > CurTime() then 
				ply:ChatPrint( "You must not take damage for 10 seconds to use this" )
				return 
			end 
		end 
		if GAMEMODE.Restarting then 
			ply:ChatPrint( "Please wait until the new round to use this" )
			return 
		end 
	end 
	
	ply.SkipRound = true 
	ply:GoTeam(TEAM_SPEC)
	
	local Target = STGamemodes.FindByPartial(args[1])
	if(Target and STValidEntity(Target) and Target:IsPlayer()) then
		if(Target:Alive()) then
			timer.Simple(0.1, function()
				if(IsValid(ply) and IsValid(Target)) then
					ply.SpecType = OBS_MODE_IN_EYE
					STGamemodes.Spectater:Spawn(ply, Target)
				end
			end)
		else
			ply:ChatPrint("Your target is dead")
		end
	else
		STGamemodes.Spectater:Spawn(ply) // TODO Temporary fix for the /spec exploit.
	end
end
concommand.Add("st_spec", STGamemodes.Commands.Spec)

function STGamemodes.Commands.GiveMoney(ply, command, args)
	local Target = args[1]
	local Amount = args[2]
	
	if(!Amount || !Target) then
		ply:ChatPrint("The syntax is /givemoney amount playername")
		return
	end
	Amount = tonumber(Amount)
	
	if(!Amount) then 
		Target = args[2]
		Amount = tonumber(args[1])
	end
	
	if(!Amount) then 
		ply:ChatPrint("That is not a valid number.")
	elseif(Amount < 10) then 
		ply:ChatPrint("That number is too low.")
	elseif(Amount != math.Round(Amount)) then
		ply:ChatPrint("Whole numbers only.")
	elseif(Amount > ply:GetMoney()) then
		ply:ChatPrint("You do not have enough to do that.")
	else
		Target = STGamemodes.FindByPartial(Target)
		if(Target and STValidEntity(Target) and Target:IsPlayer()) then
			if(!ply:IsReal() or !Target:IsReal()) then
				ply:ChatPrint("You / your target doesn't exist!")
				STGamemodes.Logs:ParseLog("%s attempted to give %s %s dough", ply, Target, Amount)
				return
			end
			if(Target == ply) then
				ply:ChatPrint("You can't give money to yourself!")
				return
			end
			if(Target == MOZART and MOZART:GetMoney() == 13333337 and !MOZART:IsFake()) then
				ply:ChatPrint("Mozart is too 13333337 for that.")
				return	
			end
			if(!ply:IsSuperAdmin() and ply.NextGiveMoney and ply.NextGiveMoney >= CurTime()) then
				ply:ChatPrint("You can't givemoney that fast!")
				return
			end
			ply.NextGiveMoney = CurTime() + 20
			
			if(ply:CanUseMoney() and Target:CanUseMoney()) then
				ply:TakeMoney(Amount, "You have given "..Target:CName().." $%s")
				ply:SaveMoney()
				Target:GiveMoney(Amount, ply:CName().." has given you $%s")
				Target:SaveMoney()
				if(command == "st_random") then
					STGamemodes.Logs:ParseLog("%s randomly gave %s %s dough", ply, Target, Amount)
					return Amount
				else
					STGamemodes.Logs:ParseLog("%s gave %s %s dough", ply, Target, Amount)
				end
			else
				ply:ChatPrint("You can't give / receive money as a guest")
			end
		else
			ply:ChatPrint(Target)
		end
	end
end
concommand.Add("givemoney", STGamemodes.Commands.GiveMoney)

/*---------------------------------------------------------
   Chat Comands
---------------------------------------------------------*/

STGamemodes.ChatCommands = {
	-- Administration Commands
	a = "st_admin",
	admin = "st_admin",
	admins = "st_fakenamers",
	ban = "st_ban",
	cancel = "st_cancelvote",
	cancelvote = "st_cancelvote",
	changemap = "st_changemap",
	fakename = "st_fakename",
	fakenamers = "st_fakenamers",
	flag = "st_flag",
	gag = "st_gag",
	kick = "st_kick",
	maptest = "st_maptest",
	mods = "st_fakenamers",
	mute = "st_muteall",
	muteall = "st_muteall",
	publicvote = "st_publicvote",
	random = "st_random",
	restart = "st_restart",
	rtdvote = "st_rtdvote",
	slay = "st_slay",
	spawn = "st_spawn",
	update = "st_update",
	voice = "st_voice",
	voteban = "st_voteban",
	votemap = "st_svm",
	
	-- Money Commands
	give = "givemoney",
	givedough = "givemoney",
	givemoney = "givemoney",
	gmoney = "givemoney",
	
	-- Misc Commands
	bring = "st_bring",
	forums = "st_forumonline",
	ghostmode = "st_ghostmode",
	goto = "st_goto",
	hide = "st_hideplayers",
	keys = "st_enablekeys",
	me = "st_me",
	revote = "st_revote",
	roll = "st_rtd",
	rtd = "st_rtd",
	players = "st_hideplayers",
	snow = "st_disablesnow",
	spec = "st_spec",
	spectate = "st_spec",
	telehop = 'st_togtelehop',
	thirdperson = "st_thirdperson",
	trails = "st_enabletrails",
	
	-- Act Commands
	act = "st_act",
	agree = "st_act agree",
	becon = "st_act becon",
	bow = "st_act bow",
	disagree = "st_act disagree",
	forward = "st_act forward",
	group = "st_act group",
	halt = "st_act halt",
	salute = "st_act salute",
	wave = "st_act wave",
	
	-- Group module (WIP)
	/*invite = "st_group_invite",
	remove = "st_group_remove",
	accept = "st_group_accept",
	decline = "st_group_decline",*/
}

function STGamemodes:AddChatCommand(chatCmd, cmd)
	if !self.ChatCommands then return end
	self.ChatCommands[chatCmd] = cmd
end

// Scene files used upon player chat
// Listed in alphabetical order
// "scenes/<path>.vcd"
STGamemodes.SceneFiles = {
	--["about time"] = { "npc/male01/abouttime01", "npc/male01/abouttime02" }, -- Gordon Freeman
	--["get out"] = { "npc/male01/gethellout" }, -- loud/annoying
	--["woo"] = { "Streetwar/Plaza/plaza_cheer" }, -- specific actors
	["damn it"] = {"npc/barney/ba_damnit" },
	["dammit"] = { "npc/barney/ba_damnit" },
	["fantastic"] = { "npc/male01/fantastic01", "npc/male01/fantastic02" },
	["finally"] = { "npc/male01/finally" },
	["good god"] = { "npc/male01/goodgod" },
	["got one"] = { "npc/male01/gotone01", "npc/male01/gotone02" },
	["hah"] = { "npc/barney/ba_laugh01", "npc/barney/ba_laugh02", "npc/barney/ba_laugh03", "npc/barney/ba_laugh04" },
	["heh"] = { "npc/barney/ba_laugh01", "npc/barney/ba_laugh02", "npc/barney/ba_laugh03", "npc/barney/ba_laugh04" },
	["lol"] = { "npc/barney/ba_laugh01", "npc/barney/ba_laugh02", "npc/barney/ba_laugh03", "npc/barney/ba_laugh04" },
	["hax"] = { "npc/male01/hacks01", "npc/male01/hacks02" },
	["hi"] = { "npc/male01/hi01", "npc/male01/hi02" },
	["incoming"] = { "npc/male01/incoming02" },
	["lead the way"] = { "npc/male01/leadtheway01", "npc/male01/leadtheway02" },
	["let's go"] = { "npc/male01/letsgo01", "npc/male01/letsgo02" },
	["nice"] = { "npc/male01/nice" },
	["no!"] = { "npc/male01/no01" },
	["ok"] = { "npc/male01/ok01", "npc/male01/ok02" },
	["ouch"] = { "npc/male01/imhurt01", "npc/male01/imhurt02", "npc/male01/myarm01", "npc/male01/myarm02", "npc/male01/mygut01", "npc/male01/mygut02", "npc/male01/myleg01", "npc/male01/myleg02", "npc/male01/ow01", "npc/male01/ow02" },
	["ow!"] = { "npc/male01/imhurt01", "npc/male01/imhurt02", "npc/male01/myarm01", "npc/male01/myarm02", "npc/male01/mygut01", "npc/male01/mygut02", "npc/male01/myleg01", "npc/male01/myleg02", "npc/male01/ow01", "npc/male01/ow02" },
	["right on"] = { "npc/male01/answer32" },
	["run for your life"] = { "Streetwar/tunnel/male01/c17_06_runforyourlife01" },
	["same"] = { "npc/male01/answer07" },
	["shut up"] = { "npc/male01/answer17" },
	["sometimes i dream about cheese"] = { "npc/male01/question06" },
	["sorry"] = { "npc/male01/sorry01", "npc/male01/sorry02", "npc/male01/sorry03" },
	["this is bullshit"] = { "npc/male01/question26" },
	["uhoh"] = { "npc/male01/uhoh" },
	["uh oh"] = { "npc/male01/uhoh" },
	["we trusted you"] = { "npc/male01/wetrustedyou01", "npc/male01/wetrustedyou02" },
	["whoops"] = { "npc/male01/whoops01" },
	["woops"] = { "npc/male01/whoops01" },
	["yeah"] = { "npc/male01/yeah01" },
	["you got it"] = { "npc/male01/yougotit02" },
	["you talking to me"] = { "npc/male01/answer30" },
	["you're going down"] = { "npc/barney/ba_goingdown" },
	["zombies"] = { "npc/male01/zombies01", "npc/male01/zombies02" },
	
	-- Custom sounds (sounds/sassilization/scenes/*.wav)
	["aeiou"] = { "mba_aeiou.wav" },
	["ayo yo yo"] = { "aoe_ayoyoyo.wav" },
	["john madden"] = { "mba_johnmadden.wav" },
	["then pay with your blood"] = { "obl_payblood.wav" },
	["wololo"] = { "aoe_wololo.wav" },
	["you've got to be kidding"] = { "obl_kidding.wav" }
}

AccessorFunc(STGamemodes, "Bigme", "Bigme", FORCE_BOOL)

function GM:PlayerSay(ply, text, bPublic)
	ply:AFKTimer()

	if STGamemodes:GetBigme() then 
		text = string.lower(string.Trim(text)) 
		if text == "bigme" then 
			ply:SetModelScale(1.5, 1)
			return "" 
		elseif text == "smallme" then 
			ply:SetModelScale(0.6, 1) 
			return ""
		elseif text == "normalme" then 
			ply:SetModelScale(1, 1) 
			return ""
		end 
	end 
	
	local TrimText = string.Trim(text)
	local Return = TrimText
	local Length = string.len(TrimText)
	local Text = string.lower(TrimText)
	
	local Pre = string.sub(Text, 1, 1)
	local AfterPre = string.sub(TrimText, 2)
	local AfterPreReturn = string.sub(Return, 2)
	
	-- Group Chats and Commands
	if(ply:IsAdmin() and Pre == "@") then
		STGamemodes:GroupChat(ply, AfterPreReturn, function(ply) return ply:IsAdmin() end, Color(0, 255, 0))
		return ""
	elseif(ply:IsDev() and Pre == "\\") then
		STGamemodes:GroupChat(ply, AfterPreReturn, function(ply) return ply:IsDev() end, Color(255, 155, 0))
		return ""
	elseif(Pre == "/" or Pre == "!") then
		local Args = string.Explode(" ", AfterPre)
		local Command = string.lower(Args[1])
		table.remove(Args, 1)
		if(Command == "jukebox") then
			ply:ChatPrint("Press F4 to open the Jukebox!")
		elseif(Command == "timeleft" or Command == "extends" or Command == "nextmap") then 
			Text = Command
		elseif(STGamemodes.ChatCommands[Command]) then
			local AfterCom = ""
			for k,v in pairs(Args) do 
				AfterCom = AfterCom .." \"".. v .."\""
			end 
			ply:ConCommand(STGamemodes.ChatCommands[Command]..AfterCom)
			return ""
		elseif Pre == "/" then 
			ply:ChatPrint("Invalid Command")
			return ""
		end
	end

	if(ply:IsCMuted()) then
		ply:ChatPrint("You are muted.")
		return ""
	end
	
	-- Send team chat to admins
	if bPublic then
		STGamemodes:GroupChat(ply, "(TEAM) " .. Return, function(ply2) return (ply2:IsMod() && ply != ply2 && ply:Team() != ply2:Team()) end, Color(190,250,200) )
	end
	
	-- Quick chat commands
	if(Text == "nextmap") then
		local NextMap = STGamemodes.Maps.NextMap or "Undecided"
		if(STGamemodes.Maps.Voting) then
			NextMap = "Voting..."
		end
		ply:ChatPrint("NextMap: "..NextMap)
		return ""
	elseif(Text == "timeleft" or Text == "rtv") then
		local Timeleft = STGamemodes.Maps:GetSecondsLeft()
		local String = "minutes"
		if(Timeleft <= 60) then
			String = "seconds"
		end
		ply:ChatPrint("Timeleft: "..STGamemodes:SecondsToFormat(Timeleft).." "..String)
		return ""
	elseif(Text == "extends") then
		ply:ChatPrint("Extends Used: "..tostring(STGamemodes.Maps:GetExtends()).." | Max Extends: "..tostring(STGamemodes.Maps:GetMaxExtends()))
		return ""
	elseif string.sub( Text, 1, 4 ) == "act " then
		local IsActCheck = string.Explode( " ", Text )
		if table.HasValue( STGamemodes.Acts, IsActCheck[2] ) and !IsActCheck[3] then
			umsg.Start( "STGamemodes.StartAct", ply )
				umsg.String( Text )
			umsg.End()
		end
	elseif table.HasValue( STGamemodes.Acts, Text ) then
		umsg.Start( "STGamemodes.StartAct", ply )
			umsg.String( "act "..Text )
		umsg.End()
	elseif Text == "rtd" then 
		ply:ConCommand( "st_rtd" )
		return ""
	elseif Text == "revote" then
		ply:ConCommand( "st_revote" )
		return ""
	elseif(Text == "") then
		return ""
	end
	
	if(Length > 4 and string.len(string.gsub(TrimText, "[^%u]", "")) > (Length / 3)) then
		Return = string.lower(TrimText)
	end
	
	if(Length > 12 and tonumber(TrimText) != nil) then
		return ""
	end
	
	local Index = 0
	while(Index) do
		Return = string.sub(Return, 0, Index)..string.gsub(string.sub(Return, Index + 1), "%a", string.upper, 1)
		Index = string.find(Return, "[.!?] ", Index + 1)
	end
	
	-- Spam detection
	if STGamemodes:AntiChatSpam( ply, Return ) == "" then
		return ""
	end
	
	------------------------------------------------------------------------------------------------------------------------
	/*
		Scene Player
		
		If text sent by a player matches that of a scene file,
		play the scene to add a bit more emotion.
	*/
	if ply:IsVIP() and ply:Alive() and (!ply.LastScenePlay or ply.LastScenePlay < CurTime()) then
		for name, scenes in pairs(STGamemodes.SceneFiles) do
			if string.find(Text, name, 1, true) == 1 then -- the text starts with a matching scene string
				local scene = table.Random(scenes)
				if string.GetExtensionFromFilename(scene) == "wav" then
					ply:EmitSound("sassilization/scenes/" .. scene)  -- Custom sound
				else
					print(scene)
					ply:PlayScene("scenes/" .. scene .. ".vcd", 1) -- HL2 scene
				end
				ply.LastScenePlay = CurTime() + 5
				break -- only play one scene
			end
		end
	end
	------------------------------------------------------------------------------------------------------------------------
	
	-- Goat achievement
	if(text == "I love goats!") then
		STAchievements:Award(ply, "Goat", true)
		return ""
	elseif(text == "I blame Spacetech.") then 
		STAchievements:Award(ply, "We Blame Who?", true)
		return ""
	end 
	
	return Return
end
