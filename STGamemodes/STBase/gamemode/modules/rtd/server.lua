--------------------
-- STBase
-- By Spacetech
--------------------

STRTD.Enabled = false
STRTD.List = {}
STRTD.Used = {}
STRTD.RoundUsed = {}
STRTD.VIPCount = 1
STRTD.Total = 1
STRTD.SpeedEnt = false
STRTD.IsCleared = true
STRTD.Timers = {}
STRTD.Double = {}

STRTD.SlapSounds = {
	"physics/body/body_medium_impact_hard1.wav", 
	"physics/body/body_medium_impact_hard2.wav", 
	"physics/body/body_medium_impact_hard3.wav", 
	"physics/body/body_medium_impact_hard5.wav", 
	"physics/body/body_medium_impact_hard6.wav", 
	"physics/body/body_medium_impact_soft5.wav", 
	"physics/body/body_medium_impact_soft6.wav", 
	"physics/body/body_medium_impact_soft7.wav",
}

function STRTD:Add( name, func, rarity, viponly )
	rarity = rarity or 1000
	if !viponly then
		table.insert( self.List, {name, self.Total, rarity, func} )
	else
		table.insert( self.List, 1, {name, self.Total, rarity, func} )
		self.VIPCount = self.VIPCount + rarity
	end
	self.Total = self.Total + rarity
end

include( "rtd.lua" )

function STRTD:SendMsg( ply, Text, GeneralText )
	if !GeneralText then 
		Text = ply:CName() .." rolled the dice and ".. Text
		if !self:GetEnabled() then
			Text = "[DEV] ".. Text
		end
	end 

	umsg.Start( "STRTD.Chat" )
		umsg.String( Text )
	umsg.End()
end

function STRTD:GetEnabled()
	return (GAMEMODE.Name == "Deathrun" and self.Enabled)
end

function STRTD:IsSpecial( ply )
	return ply.DevMin or ply.GoodSuper
end

function STRTD:HasBonus( ply )
	if STRTD.Double[ply:SteamID()] and STRTD.Double[ply:SteamID()] > 0 then 
		return true 
	end 
	return false 
end 

function STRTD:Trigger( ply, RTD )
	-- math.randomseed(os.time())
	local number = math.random( ((ply:IsVIP() and 1) or self.VIPCount), self.Total )
	if RTD then number = 0 end
	for k,v in pairs( self.List ) do
		if RTD and RTD != "" and self:IsSpecial( ply ) then
			if v[1] == RTD then
				local status, error = pcall( v[4], ply )
				if !status then 
					STRTD:Trigger(ply)
					return 
				end 
				if error then return end  
				break
			end
		elseif number >= v[2] and number < v[2]+v[3] then
			local status, error = pcall( v[4], ply )
			if !status then 
				STRTD:Trigger(ply)
				return 
			end 
			if error then return end  
			break
		end
	end
	
	self.IsCleared = false
	if !STRTD:HasBonus(ply) or ply.DisableOneBonus then 
		local Time = 240
		if ply:IsVIP() then
			Time = 0
		end

		ply:TakeMoney( 100 )
		ply:SaveMoney()
		if ply.DisableOneBonus then ply.DisableOneBonus = nil end 
		
		self.Used[ply:SteamID()] = CurTime() + Time
		self.RoundUsed[ply:SteamID()] = !self:IsSpecial( ply )
	else
		STRTD.Double[ply:SteamID()] = STRTD.Double[ply:SteamID()] - 1
		STRTD:SendMsg( ply, ply:CName().. " used a bonus RTD ("..STRTD.Double[ply:SteamID()].." remaining)", true )
	end 
end

function STGamemodes.Commands.RTD( ply, cmd, args )
	if !ply:IsValid() then return end
	
	if !STRTD:GetEnabled() and !STRTD:IsSpecial( ply ) then
		ply:ChatPrint( "RTD is disabled on this server." )
		return
	end
	
	if STRTD.Total == 0 then
		ply:ChatPrint( "Something appears to have broke in RTD.  Report to Aaron!" )
		return
	end
	
	if !STRTD:HasBonus(ply) and STRTD.Used[ply:SteamID()] and CurTime() <= STRTD.Used[ply:SteamID()] then
		ply:ChatPrint( "You must wait ".. STGamemodes:SecondsToFormat(STRTD.Used[ply:SteamID()] - CurTime()) .." before using this again." )
		return
	end
	
	if !ply:Alive() then
		ply:ChatPrint( "You cannot RTD while dead." )
		return
	end

	if ply:IsFrozen() and !timer.Exists( ply:SteamID().."-unfreeze" ) then 
		ply:ChatPrint( "You cannot roll the dice while frozen" )
		return 
	end 
	
	if !STRTD:HasBonus(ply) and STRTD.RoundUsed[ply:SteamID()] then
		ply:ChatPrint( "You can only use this once per round." )
		return
	end
	
	if ply:GetMoney() < 100 then
		ply:ChatPrint( "Sorry, you do not have enough dough to RTD. (100 dough)" )
		return
	end
	
	STRTD:Trigger( ply, STRTD:IsSpecial( ply ) and args[1] or nil )
end
concommand.Add( "st_rtd", STGamemodes.Commands.RTD )

function STRTD:Toggle()
	self.Enabled = !self.Enabled
	if self.Enabled and (!self.SpeedEnt or !self.SpeedEnt:IsValid()) then
		self:CreateSpeedMod()
	end
end

function STGamemodes.Commands.RTDToggle( ply )
	if !STRTD:IsSpecial( ply ) then return end
	
	STRTD:Toggle()
	
	STGamemodes:PrintAll( STGamemodes.GetPrefix(ply).." "..ply:CName().." has ".. (STRTD.Enabled and "enabled" or "disabled") .." RTD!" )
end
concommand.Add( "st_rtdtoggle", STGamemodes.Commands.RTDToggle )

local VoteInProgress = false 
function STGamemodes.Commands.RTDVote( ply )
	if !ply:IsMod() then return end
	if GAMEMODE.Name != "Deathrun" then return end
	
	if STRTD.Enabled then
		STRTD:Toggle()
		STGamemodes:PrintAll( STGamemodes.GetPrefix(ply).." "..ply:CName().." has disabled RTD")
	elseif !VoteInProgress then 
		STGamemodes.Vote:Start("Enable RTD?", {{"Yes", true}, {"No", false}},
			function()
				VoteInProgress = true 
				STGamemodes:PrintAll( STGamemodes.GetPrefix(ply).." "..ply:CName().." has started vote to enable RTD" )
			end,
			function(Success, Ply, Canceled)
				if Canceled then 
					STGamemodes:PrintAll( "The RTD vote has been canceled by Administrator." )
				elseif Success then
					STRTD:Toggle()
					STGamemodes:PrintAll( STGamemodes.GetPrefix(ply).." "..ply:CName().." has enabled RTD!" )
				else
					STGamemodes:PrintAll( "The RTD vote has failed" )
				end
				VoteInProgress = false 
			end
		)
	else 
		ply:ChatPrint( "There is already a vote in progress" )
	end
end
concommand.Add( "st_rtdvote", STGamemodes.Commands.RTDVote )
	

hook.Add( "OnRoundChange", "RTDRoundReset", function()
	if STRTD:GetEnabled() then
		STRTD:CreateSpeedMod()
	end
	
	STRTD.RoundUsed = {}
	
	if !STRTD:GetEnabled() and STRTD.IsCleared then return end
	umsg.Start( "STRTD:ResetAll" )
	umsg.End()

	for k,v in pairs(STRTD.Timers) do 
		timer.Destroy(v)
	end 
	
	STRTD.IsCleared = true

	STRTD.RoundDelay = CurTime() + 5
end )

//////////////////////////////////////////////////////////////////////////////
//////////						     Slow Motion                    //////////
//////////					      Credit to Sonic                   //////////
//////////////////////////////////////////////////////////////////////////////
function STGamemodes.PlayerMeta:ModSpeed( Speed )
	if self:IsValid() and STRTD.SpeedEnt:IsValid() then
		STRTD.SpeedEnt:Input( "ModifySpeed", self, self, Speed )
	end
end

function STRTD:CreateSpeedMod( Override )
	if !self:GetEnabled() and !Override then
		return
	end
	
	self.SpeedEnt = ents.FindByClass('player_speedmod')[1] or nil
	if not self.SpeedEnt then
		self.SpeedEnt = ents.Create('player_speedmod')
		self.SpeedEnt:Spawn()
	end
end
//////////////////////////////////////////////////////////////////////////////

hook.Add("Move", "blockTest", function(ply, data)
	if (ply.LockPos) then
		data:SetMaxSpeed(0)
		return data
	end
end)


	