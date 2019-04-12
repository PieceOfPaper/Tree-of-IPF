function ATTENDANCE_ON_INIT(addon, frame)
   addon:RegisterMsg('GAME_START', 'ON_ATTENDANCE_RESULT');
   addon:RegisterMsg('UPDATE_ATTENDANCE_REWARD', 'ON_ATTENDANCE_RESULT');
end

function GET_ATTENDANCE_ID_NEED_TO_SHOW(argNum)		
    local attendanceID = 0;
    if argNum > 0 then
    	attendanceID = argNum;
    else
    	attendanceID = session.attendance.GetNeedToShow();    	
    end
	if attendanceID == 0 then
		return 0;
	end

    local attendanceData = session.attendance.GetAttendanceData(attendanceID);	
	if attendanceData == nil then
		return 0;
	end

    return attendanceID;
end

function ON_ATTENDANCE_RESULT(frame, msg, argStr, argNum)	
	local attendanceID = GET_ATTENDANCE_ID_NEED_TO_SHOW(argNum);
    if attendanceID == 0 then
        return;
    end

	ATTENDANCE_INIT_COMMON_INFO(frame, attendanceID);
	ATTENDANCE_INIT_REWARD(frame, attendanceID);
	frame:ShowWindow(1);
end

function ATTENDANCE_INIT_COMMON_INFO(frame, attendanceID)
	local attendanceCls = GetClassByType('TPEventAttendance', attendanceID);
	if attendanceID == nil then
		return;
	end

	local attendanceData = session.attendance.GetAttendanceData(attendanceID);	
	if attendanceData == nil then
		return;
	end

	local titleText = GET_CHILD_RECURSIVELY(frame, 'titleText');
	titleText:SetTextByKey('name', attendanceCls.Name);

	local periodText1 = GET_CHILD_RECURSIVELY(frame, 'periodText1');	
	local dateStr = string.format('%04d.%02d.%02d', attendanceData.startTime.wYear, attendanceData.startTime.wMonth, attendanceData.startTime.wDay);
	periodText1:SetText(dateStr);

	local periodText2 = GET_CHILD_RECURSIVELY(frame, 'periodText2');
	dateStr = string.format('%04d.%02d.%02d', attendanceData.endTime.wYear, attendanceData.endTime.wMonth, attendanceData.endTime.wDay);
	periodText2:SetTextByKey('date', dateStr);

	local diffDays = imcTime.GetDifDaysFromNow(attendanceData.startTime);
	frame:SetUserValue('TODAY_DAY_OFFSET', diffDays);
end

function ATTENDANCE_INIT_REWARD(frame, attendanceID)
	local attendanceCls = GetClassByType('TPEventAttendance', attendanceID);
	if attendanceCls == nil then
		return;
	end
	local passMode = attendanceCls.AttendancePass == 'YES';

	local NORMAL_BG = frame:GetUserConfig('NORMAL_BG');
	local SPECIAL_BG = frame:GetUserConfig('SPECIAL_BG');
	local SPECIAL_DATE_FONTNAME = frame:GetUserConfig('SPECIAL_DATE_FONTNAME');
	local REWARD_MARGIN_HORZ = tonumber(frame:GetUserConfig('REWARD_MARGIN_HORZ'));
	local REWARD_MARGIN_VERT = tonumber(frame:GetUserConfig('REWARD_MARGIN_VERT'));
	local todayDayOffset = frame:GetUserIValue('TODAY_DAY_OFFSET');

	local rewardBox = GET_CHILD_RECURSIVELY(frame, 'rewardBox');
	rewardBox:RemoveAllChild();

	local COL = 7;
	local totalReward = attendanceCls.TotalNumberDays;
	for i = 0, totalReward - 1 do
		local attendanceClassData = session.attendance.GetAttendanceClassData(attendanceID, i);
        local itemList, cntList = GetAttendanceRewardList(attendanceID, i);
		if attendanceClassData ~= nil and itemList ~= nil then
			local colOffset = i % COL;
			local rowOffset = math.floor(i / COL);
			local ctrlSet = rewardBox:CreateOrGetControlSet('attendance_reward', 'ITEM_'..i, 0, 0);			
			ctrlSet:SetOffset(colOffset * (ctrlSet:GetWidth() + REWARD_MARGIN_HORZ), rowOffset * (ctrlSet:GetHeight() + REWARD_MARGIN_VERT));
                        
			local dayOffsetText = ctrlSet:GetChild('dayOffsetText');
			dayOffsetText:SetText(i + 1);

			local bgPic = GET_CHILD(ctrlSet, 'bgPic');
			if attendanceClassData:GetGrade() == 'S' then
				bgPic:SetImage(SPECIAL_BG);
				dayOffsetText:SetFontName(SPECIAL_DATE_FONTNAME);
			else
				bgPic:SetImage(NORMAL_BG);
			end

            -- item info
            local itemName = itemList[1];
            local itemCls = GetClass('Item', itemList[1]); -- 일단 한 개만 줄거라고 하셔서 이렇게 처리함            
            local itemPic = GET_CHILD(ctrlSet, 'itemPic');
            itemPic:SetImage(itemCls.Icon);

            if itemName ~= MONEY_NAME then
            	SET_ITEM_TOOLTIP_BY_NAME(itemPic, itemName);
            	itemPic:SetTooltipOverlap(1);
            end

            local cntText = GET_CHILD(ctrlSet, 'cntText');
            cntText:SetTextByKey('cnt', cntList[1]);

            -- get info
            local getPic = GET_CHILD(ctrlSet, 'getPic');
            local receiptData = session.attendance.GetReceiptData(attendanceID, i);
            if receiptData == nil then
            	getPic:ShowWindow(0);

            	if todayDayOffset > i and attendanceCls.AttendancePass == 'YES' then
            		cntText:SetColorTone('FF444444');
            		ctrlSet:SetColorTone('FF444444');
            	end
            else -- animation
            	local diffDays = imcTime.GetDifDaysFromNow(receiptData.registerTime);
                if diffDays == 0 then                
                    UI_PLAYFORCE(getPic, "sizeUpAndDown");
                end
            end
		end
	end
end

function ATTENDANCE_TOGGLE_VAKARINE_UI()
	local vakarineCls = GetClass('TPEventAttendance', 'VakarinePackage');
	local frame = ui.GetFrame('attendance');
	if frame ~= nil and frame:IsVisible() == 1 then
		ui.CloseFrame('attendance');
		return;
	end
	ON_ATTENDANCE_RESULT(frame, '', '', vakarineCls.ClassID);
end

function ATTENDANCE_OPEN_CHECK()
	local list, cnt = GetClassList('TPEventAttendance');
	if list == nil then
		return false;
	end
	for i = 0, cnt - 1 do
		local cls = GetClassByIndexFromList(list, i);
		if GET_ATTENDANCE_ID_NEED_TO_SHOW(cls.ClassID) > 0 then
			return true;
		end
	end

	return false;
end