function LISTSELECT_UI_ON_INIT(addon, frame)
	addon:RegisterMsg('UPDATE_ATTENDANCE_REWARD', 'ATTENDANCE_LIST_CHECK');
end

function LISTSELECT_UI_CREATE(list_ID)
	local frame = ui.GetFrame('listselect_ui');
	if frame ~= nil and frame:IsVisible() == 1 then
		ui.CloseFrame('listselect_ui');
		return;
	end

	ui.OpenFrame("listselect_ui");
	local frame = ui.GetFrame("listselect_ui");
	if frame == nil then
        return;
	end

	if list_ID == "attendance" then
		local title =  GET_CHILD_RECURSIVELY(frame, 'title');
		title:SetTextByKey("value", "{@st42}{s20}"..ScpArgMsg(list_ID));	
		ATTENDANCE_LIST_CHECK(frame);	
	end

end

function LISTSELECT_UI_CLOSE_CLICK(frame)
	ui.CloseFrame("listselect_ui");

end

-- 현재 진행 중인 출석 체크 후 UI에 list 출력
function ATTENDANCE_LIST_CHECK(frame)
	local list = GET_CHILD_RECURSIVELY(frame, 'list');
	list:RemoveAllChild();

	local height = ui.GetControlSetAttribute("listselect", "height");

    local Attendancelist, cnt = GetClassList('TPEventAttendance');
	if Attendancelist == nil then
		return false;
	end

	local curcnt = 0;
	for i = 0, cnt - 1 do
		local cls = GetClassByIndexFromList(Attendancelist, i);
		local attendanceData = session.attendance.GetAttendanceData(cls.ClassID);
		if attendanceData ~= nil then
			local ctrlset = list:CreateOrGetControlSet("listselect", "listselect_"..cls.ClassID, 0, curcnt*height);
			AUTO_CAST(ctrlset);
			ATTENDANCE_CTRLSET(list, ctrlset, cls.ClassID, cls.Name);
			curcnt = curcnt +1;
		end

	end

end

-- 출석 리스트 컨트롤 셋 설정
function ATTENDANCE_CTRLSET(list, classCtrl, AttendanceID, AttendanceName)
    local data_text = GET_CHILD_RECURSIVELY(classCtrl, "data_text");
	data_text:SetTextByKey("value", "{@st42}{s16}"..AttendanceName);    -- 출석 이름 출력

	-- 리스트 배경, 출석 이름, 확인 버튼을 클릭했을때 발생하는 스크립트 정의
	local addgb = GET_CHILD_RECURSIVELY(classCtrl, "gb");
	addgb:EnableHitTest(1);
	addgb:SetEventScript(ui.LBUTTONUP, "ATTENDANCE_TOGGLE_UI");
	addgb:SetEventScriptArgNumber(ui.LBUTTONUP, AttendanceID);
	addgb:SetOverSound('button_over');
	addgb:SetClickSound('button_click_big');

	local addtext = GET_CHILD_RECURSIVELY(classCtrl, "data_text");
	addtext:EnableHitTest(1);
    addtext:SetEventScript(ui.LBUTTONUP, "ATTENDANCE_TOGGLE_UI");
	addtext:SetEventScriptArgNumber(ui.LBUTTONUP, AttendanceID);
	addtext:SetOverSound('button_over');
	addtext:SetClickSound('button_click_big');
	
	local addBtn = GET_CHILD_RECURSIVELY(classCtrl, "select_btn");
	addBtn:SetText(ClMsg("attendance_word"));
	addBtn:EnableHitTest(1);
	addBtn:SetEventScript(ui.LBUTTONUP, "ATTENDANCE_TOGGLE_UI");
	addBtn:SetEventScriptArgNumber(ui.LBUTTONUP, AttendanceID);
	addBtn:SetOverSound('button_over');
	addBtn:SetClickSound('button_click_big');

	-- 버튼 색 지정
	local LastRewardData = session.attendance.GetLastRewardData(AttendanceID);
	if LastRewardData ~= nil then
		local diffDays = imcTime.AfterDayNowFromTargetTime(LastRewardData.registerTime);
		if diffDays == 1 then
			local attendanceData = session.attendance.GetAttendanceData(AttendanceID);	
			if attendanceData == nil then
				return;
			end

			local attendanceCls = GetClassByType('TPEventAttendance', AttendanceID);
			local todayDayOffset;
			if attendanceCls.AttendancePass == 'YES' then
				todayDayOffset = imcTime.GetDifDaysFromNow(attendanceData.startTime);
			else
				todayDayOffset = LastRewardData.dayOffset + 1;
			end						
			
			local attendanceClassData = session.attendance.GetAttendanceClassData(AttendanceID, todayDayOffset);
			if attendanceClassData ~= nil then			
				addBtn:SetSkinName('test_red_button');
			end

		end		
	else
		addBtn:SetSkinName('test_red_button');
	end

end
