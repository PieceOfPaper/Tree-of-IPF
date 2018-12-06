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