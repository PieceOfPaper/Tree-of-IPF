function BARRACK_CAHRNAME_ON_INIT(addon, frame)
	addon:RegisterMsg('BARRACK_GOSELECT', 'CREATECHAR_ON_MSG');


	REFRESH_PORTRAIT_SKIN(frame, 2);	
	UPDATE_INPUT_CREATE_CHAR(frame);

	--local startAnim = GET_CHILD(frame, 'start_anim', 'ui::CAnimPicture');
	--startAnim:PlayAnimation();


end

function UPDATE_INPUT_CREATE_CHAR(frame, edit)

	frame = ui.GetFrame('barrack_charname')
	if edit == nil then
		edit = frame:GetChild("NameTextEdit01");
	end

	edit = tolua.cast(edit, "ui::CEditControl");

	frame = ui.GetFrame('barrack_charcreate')
	local creBtn = GET_CHILD(frame, "createCharBtn", "ui::CButton");
	local inputNameLen = string.len(edit:GetText());
	if inputNameLen < GetMinNameLen() then	
		creBtn:SetEnable(0);
	else
		creBtn:SetEnable(1);
	end


end

function CREATECHAR_ON_MSG(frame, msg, argStr, argNum)
	if msg == 'BARRACK_GOSELECT' then
		CREATECHAR_REQUEST_CANCEL(frame, nil, '', 0);
	end
end

function REFRESH_PORTRAIT_SKIN(f, gender)

	local frame = ui.GetFrame('barrack_customize')
	frame = tolua.cast(frame, 'ui::CFrame')

	local jobCnt = 5;
	for i = 1 , jobCnt  do
		local skinObj = frame:GetChild('radioJobSel0' .. i);
		if skinObj == nil then
			break;
		end
		
		local skinCtrl = tolua.cast(skinObj, 'ui::CRadioButton');
		if skinCtrl ~= nil then
			local skinName = 'Char_lock';

			skinName = GET_PORTRAIT_NAME(i, gender);
			skinCtrl:SetSkinName(skinName);
		end
	end

	frame:Invalidate();

end


-- 직업을 선택한다
function CREATECHAR_SELECT_JOB(frame, object, argStr, argNum)
    if argNum == nil then
        argNum = 1
	elseif argNum == 0 then
		return;
    end

	barrack.SelectJob(argNum);
end

-- 성별을 선택한다
function CREATECHAR_SELECT_GENDER(frame, slot, argStr, argNum)
	local genderIndex = argNum;

	if genderIndex == nil then
		genderIndex = 1;
	end

	
	REFRESH_PORTRAIT_SKIN(frame, genderIndex);
	barrack.SelectGender(genderIndex);
end

-- 헤어를 선택한다
function CREATECHAR_SELECT_HAIR(frame, slot, argStr, argNum)
	local hairIndex = argNum;

	if hairIndex == nil then
		hairIndex = 1
	end

	barrack.SelectParts(0, hairIndex);

end

-- 캐릭터 방향을 회전한다
function CREATECHAR_SELECT_DIRECTION(frame, slot, argStr, argNum)
	local dirIndex = argNum;

if dirIndex == nil then
		dirIndex = 1
	end

	barrack.SelectDir(0, dirIndex);

end


-- 캐릭터를 생성한다
function CREATECHAR_REQUEST_CREATE(frame, obj, argStr, argNum)

	frame = ui.GetFrame('barrack_charname')
	local nameObj	= GET_CHILD(frame, 'NameTextEdit01', "ui::CEditControl");
	--local name = nameObj:GetUTF8Text();
	local name = nameObj:GetText();

	barrack.RequestCreateCharacter(name);
end

-- 캐릭터 생성을 취소한다
function CREATECHAR_REQUEST_CANCEL(frame, obj, argStr, argNum)

	barrack.GoSelect();
end

function CREATECHAR_OPEN(frame, ctrl, argStr, argNum)

	frame = ui.GetFrame('barrack_charname')
	local editCtrl = GET_CHILD(frame, 'NameTextEdit01', 'ui::CEditControl');
	editCtrl:AcquireFocus();
end

