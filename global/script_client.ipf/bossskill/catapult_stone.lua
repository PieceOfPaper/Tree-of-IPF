

function ENTER_CATA_STONE(actor)

	local rideObj = actor:GetRideActor();
	rideObj:GetFSMActor():PlayFixAnim("ATK", 1.0, 1);
	
	mg.TargetCam(actor:GetHandleVal());	
	actor:SetFSMArg1(0);
	
	actor:SetFSMTime( imcTime.GetAppTime());
	actor:SetFSMArg2( 0.7 );
	
end

function CATA_STONE_TO_DEST_POS(actor)

	local curPos = actor:GetPos();
	actor:UnRide();
	actor:SetMoveFromPos(curPos);

	actor:ReserveArgPos(1);
	actor:SetArgPos(0, curPos);

	local destPos = actor:GetMoveDestPos();
	local dist = imcMath.Vec3Dist(destPos, curPos);
	local moveSpeed = 100.0;
	actor:SetFSMTime( imcTime.GetAppTime());
	
	local moveToTime = dist / moveSpeed;
	actor:SetFSMArg2(moveToTime + 0.3);
	
	local gravityA = 150;
	local jumpPower = gravityA * moveToTime * 2; 
	actor:ActorJump(jumpPower, 0);
	
end

function UPDATE_CATA_STONE_THROW(actor, elapsedTime)

	local curPos = actor:GetPos();
	local startPos = actor:GetArgPos(0);
	local destPos = actor:GetMoveDestPos();

	local endTime = actor:GetFSMArg2();
	local ratio = ((imcTime.GetAppTime() - actor:GetFSMTime()) / endTime  );
	
	local nextPos =	imcMath.Vec3RatioPoint(destPos, startPos, ratio, 1 - ratio);
	nextPos.y = curPos.y;
	
	actor:SetPos(nextPos);
	actor:ProcessVerticalMove(elapsedTime);
			
	if ratio >= 1.0 and actor:GetVerticalSpeed() == 0.0 then
		actor:SetFSMTime( imcTime.GetAppTime());
		actor:SetFSMArg1(2);
		actor:SetFSMArg2(1);
		actor:GetForce():FlushNotShootedForceDamage();
		return;
	end
	
end

function UPDATE_CATA_STONE_READY(actor, elapsedTime)

	local ridePos = actor:GetRidePos();
	actor:SetPos(ridePos);
	if (imcTime.GetAppTime() - actor:GetFSMTime()) > actor:GetFSMArg2() then
		actor:SetFSMArg1(1);
		CATA_STONE_TO_DEST_POS(actor, elapsedTime);
	end
	
	
end

function UPDATE_CATA_STONE_DELAY(actor, elapsedTime)

	if (imcTime.GetAppTime() - actor:GetFSMTime()) > actor:GetFSMArg2() then
		actor:MoveStop();
		mg.NormalCam();	
		ui.CloseFrame("mg_catapult");
		return;
	end
end

function UPDATE_CATA_STONE(actor, elapsedTime)

	local arg = actor:GetFSMArg1();
	if arg == 0 then
		UPDATE_CATA_STONE_READY(actor, elapsedTime);
	elseif arg == 1 then
		UPDATE_CATA_STONE_THROW(actor, elapsedTime);
	else
		UPDATE_CATA_STONE_DELAY(actor, elapsedTime);
	end
	
end