-- quest_filter.lua

function QUEST_FILTER_OPEN(questframe, optionBtnCtrl)		
	if questframe == nil or optionBtnCtrl == nil then
		return
	end

	local x = questframe:GetGlobalX() + questframe:GetWidth() - 5;
	local y = optionBtnCtrl:GetGlobalY();
	local frame = ui.GetFrame("quest_filter");	
	
	-- frame이 현재 보여지는 상태면 닫는다.
	if frame:IsVisible() == 1 then
		QUEST_FILTER_CLOSE()
	else 
		local options = GET_QUEST_MODE_OPTION()
		SET_QUEST_FILTER_LIST(options)
		frame:SetOffset(x,y);
		frame:ShowWindow(1);
	end
end

function QUEST_FILTER_CLOSE()
	local frame = ui.GetFrame("quest_filter");	
	frame:ShowWindow(0);
end

local s_checkCtrlTable = nil;
local function _GET_QUEST_FILTER_CHECK_TABLE()
	if s_checkCtrlTable == nil then
		s_checkCtrlTable = 
		{
			{ name = "mode_main_check",   type = "Main" },
			{ name = "mode_sub_check", 	  type = "Sub" },
			{ name = "mode_repeat_check", type = "Repeat" },
			{ name = "mode_party_check",  type = "Party" },
			{ name = "mode_keyitem_check",type = "KeyItem" },
			{ name = "mode_chase_check",  type = "Chase" },
		};
	end
	return s_checkCtrlTable;
end

function QUEST_FILTER_UPDATE(frame, ctrl, argStr, argNum)
	
	AUTO_CAST(ctrl)
	if ctrl:GetName() == "mode_all_check" then
		local isChecked = ctrl:IsChecked();
		local list = _GET_QUEST_FILTER_CHECK_TABLE()
		for k,v in pairs(list) do
			local _checkbox = GET_CHILD(frame, v.name, "ui::CCheckBox");
			if _checkbox ~= nil then
				_checkbox:SetCheck(isChecked);
			end

		end
	end

	UPDATE_QUEST_FILTER_ALLCHECK()

	-- make options
	local options = GET_QUEST_FILTER_OPTION_LIST();
	SET_QUEST_MODE_OPTION(options)
	QUEST_RESERVE_DRAW_LIST(nil)
end

function GET_QUEST_FILTER_OPTION_LIST()
	local frame = ui.GetFrame("quest_filter");
	if frame == nil then
		return 
		{ -- 기본값 리턴.
			Main = true,
			Sub = false,
			Repeat = false,
			Party = false,
			KeyItem = false,
			Chase = true, -- 가상 모드(추적중인 항목만 보여주기 위한 모드)
		}
	end

	local options = {}
	local list = _GET_QUEST_FILTER_CHECK_TABLE()
	for k, v in pairs(list) do
		local _checkbox = GET_CHILD_RECURSIVELY(frame, v.name);
		AUTO_CAST(_checkbox)
		options[v.type] = false;
		if _checkbox ~= nil then			
			options[v.type] = _checkbox:IsChecked() == 1;
		end
	end
	return options;
end

-- 옵션 테이블을 받아서 체크박스를 동기화 한다.
function SET_QUEST_FILTER_LIST(options)
	local frame = ui.GetFrame("quest_filter");
	if frame == nil then
		return
	end

	local list = _GET_QUEST_FILTER_CHECK_TABLE()
	for k, v in pairs(list) do
		local isChecked = 1;
		if options[v.type] == false then
			isChecked = 0;
		end
		local _checkbox = GET_CHILD_RECURSIVELY(frame, v.name);
		AUTO_CAST(_checkbox)
		if _checkbox ~= nil then			
			_checkbox:SetCheck(isChecked);
		end
	end

	UPDATE_QUEST_FILTER_ALLCHECK();
end

-- AllCheck 
function UPDATE_QUEST_FILTER_ALLCHECK()
	local frame = ui.GetFrame("quest_filter");
	if frame == nil then
		return
	end

	local allChecked = true;
	local list = _GET_QUEST_FILTER_CHECK_TABLE()
	for k, v in pairs(list) do

		local _checkbox = GET_CHILD_RECURSIVELY(frame, v.name);
		AUTO_CAST(_checkbox)

		if _checkbox ~= nil and _checkbox:IsChecked() == 0 then
			allChecked = false;		
		end
	end

	local _allcheckbox = GET_CHILD_RECURSIVELY(frame, "mode_all_check");
	if _allcheckbox ~= nil then
		if allChecked == true then
			_allcheckbox:SetCheck(1)
		else
			_allcheckbox:SetCheck(0)
		end
	end
end
