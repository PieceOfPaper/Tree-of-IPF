

function ENTER_CART_UNRIDE(actor)

	local cartObj = actor:GetRideActor();
	if cartObj == nil then
		actor:ActorMoveStop();
		return;
	end
	
	local cartPos = cartObj:GetPos();
	local curPos = actor:GetPos();

	local dir = imcMath.Vec3Sub(curPos, cartPos);
	local destPos = imcMath.Vec3Add(curPos, dir);
	destPos = world.GetValidPos(destPos);

	actor:SetMoveFromPos(curPos);
	actor:SetMoveDestPos(destPos);

	actor:SetFSMTime( imcTime.GetAppTime() );
	actor:ActorJump(100, 0);

end


function UPDATE_CART_UNRIDE(actor, elapsedTime)

	local ratio = (imcTime.GetAppTime() - actor:GetFSMTime()) * 2.0;
	if ratio >= 1.0 then
		ratio = 1.0;
	end

	local destPos = actor:GetMoveDestPos();			
	destPos.y = 0;
	local startPos = actor:GetMoveFromPos();
	startPos.y = 0;

	local nextPos =	imcMath.Vec3RatioPoint(destPos, startPos, ratio, 1 - ratio);
	nextPos.y = actor:GetPos().y;
	actor:SetPos(nextPos);

	actor:ProcessVerticalMove(elapsedTime);
	local curPos = actor:GetPos();
	local verSpd = actor:GetVerticalSpeed();
	
	if ratio >= 1.0 and (curPos.y <= destPos.y + 2 or verSpd == 0 ) then
		actor:ActorMoveStop();	
	end

end