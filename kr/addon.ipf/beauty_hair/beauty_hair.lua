-- 미용실. 적용된 대가리 개수 8개
MAX_HAIR_COUNT = 82

function BEAUTY_HAIR_ON_INIT(addon, frame)

	addon:RegisterMsg('ROLLBACK_HEAD', 'ROLLBACK_HEAD_INDEX');	
end

function BEAUTY_HAIR_OPEN(frame)

	local curHairIndex = item.GetHeadIndex()
	
	frame:SetUserValue("PREV_HAIR", curHairIndex);
	frame:SetUserValue("SELECT_HAIR", curHairIndex);
end

function BEAUTY_HAIR_CLOSE(frame)

	local hairIndex = tonumber( frame:GetUserValue("SELECT_HAIR") );
	local prevHairIndex = tonumber( frame:GetUserValue("PREV_HAIR") );

	if hairIndex == prevHairIndex then
		return;
	end

	-- 구입한 머리 또는 처음 머리로 되돌리기
	local hairIndex = tonumber( frame:GetUserValue("PREV_HAIR") );
	item.ChangeHeadAppearance(hairIndex);

end
function ROLLBACK_HEAD_INDEX(frame, msg, argStr, argNum)

	item.ChangeHeadAppearance(argNum);
end

function PREV_HAIR_BTN(frame)
	
	local hairIndex = tonumber( frame:GetUserValue("SELECT_HAIR") );

	hairIndex = hairIndex - 1;

	if hairIndex <= 0 then
		hairIndex = MAX_HAIR_COUNT;
	end

	frame:SetUserValue("SELECT_HAIR", hairIndex);

	UPDATE_HAIR_CHANGE(frame)
end

function NEXT_HAIR_BTN(frame)


	local hairIndex = tonumber( frame:GetUserValue("SELECT_HAIR") );

	hairIndex = hairIndex + 1;

	if hairIndex > MAX_HAIR_COUNT then
		hairIndex = 1;
	end

	frame:SetUserValue("SELECT_HAIR", hairIndex);

	UPDATE_HAIR_CHANGE(frame)
end

function SELECT_HAIR_BTN(frame)

	local hairIndex = tonumber( frame:GetUserValue("SELECT_HAIR") );
	local prevHairIndex = tonumber( frame:GetUserValue("PREV_HAIR") );

	if hairIndex == prevHairIndex then
		return;
	end

	local yesScp = string.format("EXEC_SEL_HAIR(%d)", hairIndex);
	ui.MsgBox(ScpArgMsg("Auto_HeeoLeul_ByeonKyeongHaSiKessSeupNiKka?(MeDal_100_Pilyo)"), yesScp, "None");
	
end


function EXEC_SEL_HAIR(hairIndex)

	item.ReqChangeHead(hairIndex);
	
	local frame = ui.GetFrame("beauty_hair");
	frame:SetUserValue("PREV_HAIR", hairIndex);
	frame:ShowWindow(0);
end

function UPDATE_HAIR_CHANGE(frame)

	local hairIndex = tonumber( frame:GetUserValue("SELECT_HAIR") );
	if hairIndex > 0 and hairIndex <= MAX_HAIR_COUNT then
		item.ChangeHeadAppearance(hairIndex);
	end
end

