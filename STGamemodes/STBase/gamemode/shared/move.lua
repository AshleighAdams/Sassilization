--------------------
-- STBase
-- By Spacetech
--------------------

-- Original by Azui; Edited by Spacetech

-- Don't use this file without my (Spacetech) permission
-- gamemovement.cpp

---------------------------------------
-- Spacetech
GM.TeamSpeeds = {}

function GM:TeamSetupSpeed(Team, Speed)
	self.TeamSpeeds[Team] = Speed
end

-- From GM:Spawn()
function GM:InitSpeed(ply)
	local Speed = ply.CustomSpeed or self.TeamSpeeds[ply:Team()] or self.CSSSpeed
	if(self.VIPSpeed == nil and ply:IsVIP()) then
		Speed = Speed + 20
	end
	ply:SetRunSpeed(Speed)
	ply:SetWalkSpeed(Speed)
	ply:SetMaxSpeed(Speed)
end

-- sv_accelerate
function GM:Accelerate(Move, current, wishdir, wishspeed, accel)
	local addspeed = wishspeed - current
	
	if(addspeed <= 0) then
		return
	end
	
	local accelspeed = accel * wishspeed * FrameTime()
	
	if(accelspeed > addspeed) then
		accelspeed = addspeed
	end
	
	Move:SetVelocity(Move:GetVelocity() + (wishdir * accelspeed))
end

---------------------------------------

---------------------------------------
-- Azuisleet -> sv_airaccelerate

function GM:AirAccelerate(Move, current, wishdir, wishspeed, accel)
	local wishspd = wishspeed
	
	wishspd = math.Clamp(wishspd, 0, 30)
	
	local addspeed = wishspd - current
	
	if(addspeed <= 0) then
		return
	end
	
	local accelspeed = accel * wishspeed * FrameTime()
	
	if(accelspeed > addspeed) then
		accelspeed = addspeed
	end
	
	Move:SetVelocity(Move:GetVelocity() + (wishdir * accelspeed))
end

---------------------------------------

function GM:Move(ply, Move)
	if(SERVER) then
		self:AFKCommand(ply)
	end
	
	local aim = Move:GetMoveAngles()
	local forward, right = aim:Forward(), aim:Right()
	local fmove = Move:GetForwardSpeed()
	local smove = Move:GetSideSpeed()
	
	forward.z, right.z = 0,0
	forward:Normalize()
	right:Normalize()
	
	local wishvel = forward * fmove + right * smove
	wishvel.z = 0
	
	local wishspeed = wishvel:Length()
	
	if(wishspeed > Move:GetMaxSpeed()) then
		wishvel = wishvel * (Move:GetMaxSpeed()/wishspeed)
		wishspeed = Move:GetMaxSpeed()
	end
	
	local wishdir = wishvel:GetNormal()
	local current = Move:GetVelocity():Dot(wishdir)
	
	if(ply:IsOnGround()) then
		if(self.svAccelerate != 0) then
			self:Accelerate(Move, current, wishdir, wishspeed, self.svAccelerate) 
		end
		-- if(self.SlowJumpLanding) then
			-- if(ply.WasInAir) then
				-- if(ply.WasInAir >= CurTime()) then
					-- Move:SetVelocity(Move:GetVelocity() * 0.5)
				-- else
					-- ply.WasInAir = nil
				-- end
			-- end
		-- end
	else
		if(self.svAirAccelerate != 0) then
			self:AirAccelerate(Move, current, wishdir, wishspeed, self.svAirAccelerate)
		end
		-- if(self.SlowJumpLanding) then
			-- ply.WasInAir = CurTime() + 0.6
		-- end
	end
	
	if(self.OnMove) then
		self:OnMove(ply, Move)
	end
end

-- Damnit gmod
-- VERY RARE: ply:SetPos seems to fail sometimes
-- function GM:FinishMove(ply, Move)
	-- if(ply.ForcePos) then
		-- Move:SetOrigin(ply.ForcePos)
		-- ply.ForcePos = nil
	-- end
-- end
