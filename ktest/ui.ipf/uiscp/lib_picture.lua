-- lib_picture.lua --

function GET_PORTRAIT_IMG_NAME(job, gender)

	local ret = job;
	if gender == 1 then
		return ret .. "_M";
	else
		return ret .. "_F";
	end

end

imcPicture = {
	SetCharacterImage = function(self, picture, dirType, apc)
		local dirTypeCandidate = {front = 0, right = 1, left = 2};
		if dirTypeCandidate[dirType] == nil then
			print("invalid dirtype: "..dirType);
			return;
		end

		if apc == nil then
			local pcSession = session.GetMySession()		
			if pcSession == nil then
				return;
			end

			apc = pcSession:GetPCDummyApc();		
		end
		
		local imgName = '';
		if app.IsBarrackMode() == true then
			local MAX_DIR_COUNT = 8;
			local curDir = picture:GetUserIValue('CUR_CHARACTER_DIR');
			if dirType == 'left' then
				curDir = curDir - 1;
				if curDir < 0 then
					curDir = MAX_DIR_COUNT - 1;
				end
			elseif dirType == 'right' then
				curDir = (curDir + 1) % MAX_DIR_COUNT;
			else
				curDir = 7;
			end
			imgName = ui.CaptureSomeonesFullStdImage(apc, curDir);
			picture:SetUserValue('CUR_CHARACTER_DIR', curDir);			
		else
			imgName = ui.CaptureMyFullStdImageByAPC(apc, dirTypeCandidate[dirType], 1);
		end
		picture:SetImage(imgName);
		return imgName;
	end,	
};

imcUIAnim = {
	PlayMoveExponential = function(self, ctrl, dirType, isHorz, totalOffset, coeff, isLoop)
		local dirTypeCandidate = {left = -1, right = 1, top = -1, bottom = 1 };
		if dirTypeCandidate[dirType] == nil then
			print("invalid dirtype: "..dirType);
			return;
		end

		ctrl:SetUserValue('TOTAL_OFFSET', totalOffset);
		ctrl:SetUserValue('ACCUMULATE_OFFSET', 0);
		ctrl:SetUserValue('COUNT', 0);
		ctrl:SetUserValue('COEFF', coeff);
		if isHorz == true then
			ctrl:SetUserValue('MOVE_X', dirTypeCandidate[dirType]);
		else
			ctrl:SetUserValue('MOVE_Y', dirTypeCandidate[dirType]);
		end
		if isLoop == true then
			ctrl:SetUserValue('LOOP_ANI', 'YES');
		end
		ctrl:RunUpdateScript('UPDATE_IMC_UI_ANIM_MOVE_EXPONENTIAL', 0.005);
	end,
};

function UPDATE_IMC_UI_ANIM_MOVE_EXPONENTIAL(ctrl)
	local totalOffset = tonumber(ctrl:GetUserValue('TOTAL_OFFSET'));
	local accumulateOffset = tonumber(ctrl:GetUserValue('ACCUMULATE_OFFSET'));
	if accumulateOffset >= totalOffset then
		local oriMargin = ctrl:GetOriginalMargin();
		ctrl:SetMargin(oriMargin.left, oriMargin.top, oriMargin.right, oriMargin.bottom);
		if ctrl:GetUserValue('LOOP_ANI') == 'YES' then
			ctrl:SetUserValue('ACCUMULATE_OFFSET', 0);
			ctrl:SetUserValue('COUNT', 0);
			return 1;
		end
		return 0;
	end

	local count = ctrl:GetUserIValue('COUNT');
	local coeff = tonumber(ctrl:GetUserValue('COEFF'));
	local moveX = ctrl:GetUserValue('MOVE_X');
	if moveX == nil or moveX == 'None' then
		moveX = 0;
	else
		moveX = tonumber(moveX);
	end
	local moveY = ctrl:GetUserValue('MOVE_Y');	
	if moveY == nil or moveY == 'None' then
		moveY = 0;
	else
		moveY = tonumber(moveY);
	end
	local deltaOffset = coeff * count * count;
	ctrl:SetUserValue('COUNT', count + 1);
	ctrl:SetUserValue('ACCUMULATE_OFFSET', accumulateOffset + deltaOffset);
	ctrl:Move(moveX * deltaOffset, moveY * deltaOffset);
	return 1;
end