--------------------
-- STBase
-- By Spacetech
--------------------

SLOGBlocked = {
	"dump_hooks",
	"se fail",
	"npc_thinknow",
	"soundscape_flush",
	"hammer_update_entity",
	"physics_constraints",
	"physics_debug_entity",
	"physics_select",
	"physics_budget",
	"sv_soundemitter_flush",
	"rr_reloadresponsesystems",
	"sv_soundemitter_filecheck",
	"sv_soundscape_printdebuginfo",
	"dumpentityfactories",
	"dump_globals",
	"dump_entity_sizes",
	"dumpeventqueue",
	"dbghist_addline",
	"dbghist_dump",
	"groundlist",
	"report_simthinklist",
	"report_entities",
	"npc_thinknow",
	"server_game_time"
}

local DontShow = {
	"bhop_levelselect",
	"headcrab",
	"say",
	"sf_",
	"_ping",
	"~sf_",
	"setpassword",
	"linkaccount",
	"cnc",
	"dr_",
	"st_",
	"rp_",
	"rs_",
	"wire_",
	"gms_",
	"status",
	"kill",
	"myinfo",
	"phys_swap",
	"+ass_menu",
	"-ass_menu",
	"explode",
	"suitzoom",
	"feign_death",
	"gm_showhelp",
	"gm_showteam",
	"gm_showspare1",
	"gm_showspare2",
	"+gm_special",
	"-gm_special",
	"vban",
	"vmodenable",
	"se auth",
	"ulib_cl_ready",
	"noclip",
	"kill",
	"undo",
	"jukebox",
	"debugplayer",
	"achievementRefresh",
	"kcheatfound",
	"_command",
	"gmod_undo",
	"act",
	"+use_action_slot_item",
	"-use_action_slot_item",
	"save_replay",
	"cl_trigger_first_notification",
}

function Cmd_RecvCommand(Name, Buffer)
	local Ply = false
	for k,v in ipairs(player.GetAll()) do
		if(v and v:IsValid()) then
			if(v:GetName() == Name) then
				Ply = v
				break
			end
		end
	end
	
	local Return = false
	local StringMessage = false
	local BlockedMessage = false
	local Trimed = string.Trim(Buffer)
	local Buffer = string.lower(Trimed)
	
	if(!Ply or !Ply:IsValid()) then
		if(string.find(Buffer, "say") != nil) then
			return true
		end
	end
	
	local Search = true
	for k,v in pairs(DontShow) do
		local vString = string.Trim(string.lower(v))
		local vLength = string.len(vString)
		if(string.sub(Buffer, 1, vLength) == vString) then
			Search = false
			break
		end
	end
	
	-- if(Buffer == "+sh_menu" and IsValid(Ply)) then
		-- if(SethHackMissing) then
			-- SethHackMissing(Ply)
		-- end
		-- return true
	-- end
	
	if(!Search) then
		return false
	end
	
	-- if(string.sub(Buffer, 1, 3) == "act") then
		-- return true
	-- end
	
	for k,v in pairs(SLOGBlocked) do
		local vString = string.Trim(string.lower(v))
		if(Buffer == vString or string.find(Buffer, vString) != nil) then
			Return = true
			if(Ply) then
				BlockedMessage = true
				StringMessage = "#Found Blocked Command: "..string.format("%s (%s) Ran: %s\n", Ply:CName(), Ply:SteamID(), Trimed)
			end
		end
	end
	
	if(Ply and Ply:IsValid()) then
		local Log = string.format("[%s] %s (%s) Ran: %s\n", os.date("%c"), Ply:CName(), Ply:SteamID(), Trimed)
		AppendLog(string.Replace(Ply:SteamID(), ":", "_"), Log)
		if(BlockedMessage) then
			AppendLog("Blocked", Log)
		else
			StringMessage = "#"..Log
		end
	else
		local Log = string.format("[%s] %s Ran: %s\n", os.date("%c"), "UNKOWN PLAYER", Trimed)

		AppendLog("UNKNOWN", Log)
	end
	
	if(Ply and Ply:IsValid() and !Ply:IsSuperAdmin() and string.find(Buffer, "lua_run_cl")) then --and (string.find(Buffer, "select v from ratings") or string.find(Buffer, "http") or string.find(Buffer, "runstring") or string.find(Buffer, "timer"))) then
		Ply:ChatPrint("Malicious Key Bind! Do Game Menu->Options->Keyboard->Use Defaults")
		return Return
	end
	
	if(StringMessage) then
		local SendTo = {SPACETECH, SASSAFRASS, COLD, UGLY, AZUI, AARON}
		for k,v in pairs(SendTo) do
			if(v and v:IsValid()) then
				if(BlockedMessage) then
					v:PrintMessage(HUD_PRINTTALK, StringMessage)
				else
					v:PrintMessage(HUD_PRINTCONSOLE, StringMessage)
				end
			end
		end
	end
	
	return Return
end

-- Debug stuff starts now
if(true) then
	return
end

local oldcall = hook.Call

local ignore = {
	"Think",
	"Tick",
	"SetupMove",
	"SetupPlayerVisibility",
	"UpdateAnimation",
	"Move",
	"FinishMove",
	"SetPlayerAnimation",
	"GetGameDescription",
	"PlayerFootstep",
	"PlayerStepSoundTime",
	"KeyPress",
	"KeyRelease",
	"EntityKeyValue",
	-- "PlayerCanPickupWeapon",
	-- "EntityTakeDamage",
	"WeaponEquip",
	"PlayerSwitchFlashlight",
	"PlayerDeathSound",
	"PlayerDeathThink",
	"PlayerCanHearPlayersVoice",
	-- "ScalePlayerDamage",
	-- "PlayerShouldTakeDamage",
	-- "PlayerTraceAttack",
	-- "PlayerHurt",
	"PlayerSay",
	"PlayerUse"
}

local FileName = "SafeEntity"

function logme(name, gm, ... )
	local arg = {...}
	if !ignore or !table.HasValue(ignore, name) then
		local String = tostring(name)
		local MiniString = ""
		if(arg) then
			for k,v in pairs(arg) do
				MiniString = MiniString.."|"..tostring(v)
			end
			MiniString = string.sub(MiniString, 2)
		end
		local FullString = String
		if(MiniString != "" and MiniString != "0") then
			FullString = FullString..": "..MiniString
		end
		AppendLog(FileName, FullString.."\n")
	end
end

function hook.Call( name, gm, ... )
	local arg = {...}
	logme(name, gm, unpack(arg))
	return oldcall(name, gm, unpack(arg))
end

/*
timer.Simple(5, function()
	for k,v in pairs(hook.GetTable()) do
		-- print(k, v)
		if(k == "Think") then
			for k2,v2 in pairs(v) do
				-- print("Hooked", k2)
				hook.Add("Think", k2, function(...)
					AppendLog(FileName, k2.."\n")
					return v2(unpack({...}))
				end)
			end
		end
	end
end)
*/
