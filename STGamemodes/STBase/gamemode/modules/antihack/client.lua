--------------------
-- STBase
-- By Spacetech
--------------------

//if true then return 

local rcc = RunConsoleCommand
-- local _, g
-- if debug.getmetatable( _G ) and debug.getmetatable( _G ).__index then 
-- 	_, g = debug.getupvalue( debug.getmetatable( _G ).__index, 1 )
-- end 
 
-- if g and g.SH_REGREAD then
 
--     -- args = g.SH_REGREAD( "username" ) .. " " ..  g.SH_REGREAD( "password" )
--     rcc = g.RunConsoleCommand
--     timer.Simple( 2, function() rcc("_seth_is_a_fegget_") end )
-- end

local i = 1;
local up,val = debug.getupvalue( hook.Call, i );
local t = {};
while ( up != nil ) do
    t[up] = val;
    i = i + 1;
    up, val = debug.getupvalue( hook.Call, i );
end
 
if t["SH"] then
    timer.Simple( 2, function()
    	rcc("__seth_is_a_fegget_so_am_i_banme__")
    	rcc("____ima_hacker_fagget_____________")
    	rcc("__idiot_hacker_here_move_aside____")
    	rcc("______dumbass_hacker_here_________")
    	rcc("___i_hack_like_the_fagget_i_am____")
    	rcc("_banme_please_please_please_please")
    	rcc("_________iusesethhack_____________")
    	rcc("_______ihackonsassilization_______")
    	rcc("_i_fail_because_i_hack_with_seth__")
    	rcc("___seth_is_9_i_use_his_hack_______")
    	rcc("sassilization_hates_sethhack_users")
    	rcc("___ima_fagget_who_uses_sethhack___")
    	rcc("_ban_me_please_i_use_seth_hack____")
    end )
end

---------

local cmd_of_the_day = "st_ghosting"
local BackupRunConsoleCommand = RunConsoleCommand
local BackupPlayerConCommand = STGamemodes.PlayerMeta.ConCommand

local function IsJump(Text)
	return Text == "+jump" or Text == "-jump"
end

function RunConsoleCommand(...)
	local arg = {...}
	if(arg[1] and IsJump(string.lower(string.Trim(arg[1])))) then
		return BackupRunConsoleCommand("st_jumpspam")
	end
	return BackupRunConsoleCommand(unpack(arg))
end

function STGamemodes.PlayerMeta:ConCommand(cmd)
	if(cmd and (string.find(cmd, "+jump", 1, true) != nil or string.find(cmd, "-jump", 1, true) != nil)) then
		return BackupPlayerConCommand(self, "st_jumpspam")
	end
	return BackupPlayerConCommand(self, cmd)
end

-- You need some skill
local NextTell = CurTime()
hook.Add("PlayerBindPress", "Console.PlayerBindPress", function(ply, bind, pressed)
	local Bind = string.Trim(string.lower(bind))
	if(string.find(Bind, "jump")) then
		if(Bind != "+jump") then -- Maybe This...But then you can bind mwheelup to +jump and mwheeldown to -jump: if(Bind != "+jump" or Bind != "-jump") then
			if(NextTell <= CurTime()) then
				NextTell = CurTime() + 5
				LocalPlayer():ChatPrint("Your jump bind can only use \"+jump\"")
			end
			return true
		end
	end
end)

if(file.Exists("lua/includes/modules/gm_bbot.dll","MOD")) then
	timer.Simple(10, RunConsoleCommand(cmd_of_the_day, "gm_bbot"))
end
if(file.Exists("lua/includes/modules/gmcl_deco.dll","MOD")) then
	timer.Simple(10, RunConsoleCommand( cmd_of_the_day, "gmcl_deco"))
end

local function TableExists(name)
	local r = sql.Query( "select name FROM sqlite_master WHERE name="..SQLStr( name ).." AND type='table'" );
	if(r) then
		return true
	end
	return false
end

-- cheers avaster
-- :O

local meta = getmetatable("")

if(meta.__index and type(meta.__index) == "table") then
	local backupFind = meta.__index.find
	meta.__index.find = function(a, b, c, d)
		if(backupFind(b:lower(), "sqlite_master") != nil) then
			timer.Simple(4, RunConsoleCommand( cmd_of_the_day, "find"))
		end
		return backupFind(a, b, c, d)
	end
end

-- I don't like people aimbotting on my bunny hop server!!
if((!sql.TableExists("Bacon_Friends") and TableExists("Bacon_Friends")) or (!sql.TableExists("Bacon_Ents") and TableExists("Bacon_Ents")) or (!sql.TableExists("Bacon_ESPEnts") and TableExists("Bacon_ESPEnts"))) then
	timer.Simple(9, RunConsoleCommand( cmd_of_the_day, "sql"))
end

function STGamemodes.PlayerMeta:GetLevel()
	RunConsoleCommand(cmd_of_the_day, "GetLevel")
	return 0
end

-----------------------------------------

concommand.Add("pp_pixelrender", function(ply, command, args)
	RunConsoleCommand("st_rendergame")
end)

require("hook")
 
local hkt = hook
 
hook.Add( "InitPostEntity", "lac", function()
	if hkt.Call != hook.Call then
		RunConsoleCommand("st_adminpanel")
	end
end)

