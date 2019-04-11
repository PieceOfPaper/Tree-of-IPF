

function ENTER_COL_SKL(actor)

	local destPos = actor:GetMoveDestPos();
	local colPos = actor:GetArgPos(0);
		
	local curPos = actor:GetPos();
	local colDist = imcMath.Vec3Dist(colPos, curPos);
	
	local skillSec = actor:GetMoveFSMTime();
	local moveSpeed = colDist / skillSec;
	actor:SetDirMoveSpeed(moveSpeed);
	actor:SetDirMoveAccel(moveSpeed);
	actor:SetFSMArg1(0.0);

end


function UPDATE_COL_SKL(actor, elapsedTime)

	local curPos = actor:GetPos();
	local fsmArg = actor:GetFSMArg1();

	if fsmArg == 0 then
		local destPos = actor:GetArgPos(0);
		local radius = actor:GetRadius() * 0.5;

		local beforeDist = imcMath.Vec3Dist(destPos, curPos) - radius;

		actor:SetDirDestPos(destPos);
		actor:ProcessDirMove(elapsedTime);
	
		local dist = imcMath.Vec3Dist( destPos, actor:GetPos() );
		dist = dist - radius;
		
		if dist <= 1.0 or beforeDist < dist then
			actor:SetFSMArg1(1);
			actor:Jump(100.0);
			
			local PAUSE_TIME = 0.2;
			
			actor:SetPause(PAUSE_TIME);
			actor:SetFSMTime( imcTime.GetAppTime() + PAUSE_TIME);

			actor:SetArgPos(0, actor:GetPos());
		end
		
	elseif fsmArg == 1 then
		local ratio = (imcTime.GetAppTime() - actor:GetFSMTime()) * 2.0;
		if ratio >= 1.0 then
		
			actor:SetPos(actor:GetMoveDestPos());
			actor:MoveStop();
			return;
			
		else
			
			local destPos = actor:GetMoveDestPos();
			local colPos = actor:GetArgPos(0);
			
			local nextPos =	imcMath.Vec3RatioPoint(destPos, colPos, ratio, 1 - ratio);
			nextPos.y = actor:GetPos().y;
			actor:SetPos(nextPos);
		
		end
	end
	
	actor:ProcessVerticalMove(elapsedTime);

end