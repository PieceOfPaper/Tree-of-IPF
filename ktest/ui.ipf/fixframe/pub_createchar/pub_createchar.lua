
function PUB_CREATECHAR_ON_INIT(addon, frame)
	
	addon:RegisterMsg("BARRACK_NEWCHARACTER", "PUB_BARRACK_NEWCHARACTER");

end

function PUB_CANCEL_CREATECHAR(frame)

	frame:ShowWindow(0);
	selectMap = 0;
	GetBarrackPub():EnableFocusChar(false);

end

function PUB_CHARFRAME_UPDATE(frame, actor)
	local apc = actor:GetPCApc();

	local gender = apc:GetGender();
	local job = apc:GetJob();
	local headType = apc:GetHeadType();

	local jobCls = GetClassByType("Job", job);

	local ratingstr = jobCls.Rating;
	ratingstr_arg = {}

	local maingroup = frame:GetChild("maingroup");
	for i = 1, 4 do -- 혹시 별점 항목이 늘어난다면 이 3을 늘릴 것
		ratingstr_arg[i] = string.sub(ratingstr,2*i-1,2*i-1)
		ratingstr_arg[i] = ratingstr_arg[i] + 0

		local gauge = GET_CHILD(maingroup, "gauge_rating_" .. i, "ui::CGauge");
		gauge:SetPoint(ratingstr_arg[i], 5);
	end

	local classimage = GET_CHILD_RECURSIVELY(frame, "classImage", "ui::CPicture");
	classimage:SetImage(jobCls.Icon);

	local job_title = maingroup:GetChild("job_title");
	job_title:SetTextByKey("value", jobCls.Name);

	local job_desc = maingroup:GetChild("job_desc");
	job_desc:SetTextByKey("value", jobCls.Caption1);

	SET_HEAD_NAME(frame, gender, headType);
	--SET_HEAD_COLOR_NAME(frame, gender, headType);


	if selectMap == 0 then
		local KlaipeBtn_mark = GET_CHILD_RECURSIVELY(frame, "KlaipeBtn_mark", "ui::CPicture");
		local OrshaBtn_mark = GET_CHILD_RECURSIVELY(frame, "OrshaBtn_mark", "ui::CPicture");
		KlaipeBtn_mark:ShowWindow(0);
		OrshaBtn_mark:ShowWindow(0);

		local klaipeBtn = GET_CHILD_RECURSIVELY(frame, "KlaipeBtn")
		local orshaBtn = GET_CHILD_RECURSIVELY(frame, "OrshaBtn")
		klaipeBtn:SetEnable(1);
		orshaBtn:SetEnable(1);
	end

	
end

function SET_HEAD_COLOR_NAME(frame, gender, headType)
	local Rootclasslist = imcIES.GetClassList('HairType');
	local Selectclass   = Rootclasslist:GetClass(gender);
	local Selectclasslist = Selectclass:GetSubClassList();
	local cnt		      = Selectclasslist:Count();

	for i = 0, cnt-1 do
		local Changeclass	= Selectclasslist:GetByIndex(i);	
		local index			= imcIES.GetINT(Changeclass, 'Index');
		local type		= imcIES.GetString(Changeclass, 'Color');

		if index == headType then
			local customgroup = frame:GetChild("customgroup");
			local color = customgroup:GetChild("title_hairColorList");
			color:SetTextByKey("value", type);
			return;
		end
	end
end

function SET_HEAD_NAME(frame, gender, headType)
	local Rootclasslist = imcIES.GetClassList('HairType');
	local Selectclass   = Rootclasslist:GetClass(gender);
	local Selectclasslist = Selectclass:GetSubClassList();
	local cnt		      = Selectclasslist:Count();

	for i = 0, cnt do
		local Changeclass	= Selectclasslist:GetByIndex(i);	
		if nil == Changeclass then
			return;
		end

		local index		= imcIES.GetINT(Changeclass, 'Index');
		local type		= imcIES.GetString(Changeclass, 'Type');
		if index == headType then
			local customgroup   = frame:GetChild("customgroup");
			local title_hairtype = customgroup:GetChild("title_hairtype");
			title_hairtype:SetTextByKey("value", type);
			return;
		end
	end
end

function PUB_NEXT_HEAD(parent, ctrl)
	local actor = GetBarrackPub():GetSelectedActor();
	local apc = actor:GetPCApc();
	local headType = apc:GetHeadType();

	local Rootclasslist = imcIES.GetClassList('HairType');
	local Selectclass   = Rootclasslist:GetClass(apc:GetGender());
	local Selectclasslist = Selectclass:GetSubClassList();
	local cnt		      = Selectclasslist:Count();
	
	

	for i = headType, cnt do
		local nextCls = Selectclasslist:GetByIndex(i);
		local currCls = Selectclasslist:GetByIndex(headType-1);
		if nextCls == nil then
			if cnt <= i then
				for j = 0, headType do
					nextCls = Selectclasslist:GetByIndex(j);
					if nextCls ~= nil then
						if imcIES.GetString(nextCls, 'Type') ~= imcIES.GetString(currCls, 'Type') and
						   imcIES.GetString(nextCls, 'UseableBarrack') ==  'YES' then
						   headType = j + 1;
						   break;
						end
					end
				end
			end
		else
			if imcIES.GetString(nextCls, 'Type') ~= imcIES.GetString(currCls, 'Type') and
			   imcIES.GetString(nextCls, 'UseableBarrack') ==  'YES' then
				headType = i + 1;
				break;
			end
		end
	end

	
	GetBarrackPub():ChangeHair(headType);
	local frame = parent:GetTopParentFrame();
	SET_HEAD_NAME(frame, apc:GetGender(), headType);
end

function PUB_PREV_HEAD(parent, ctrl)

    local actor = GetBarrackPub():GetSelectedActor();
    local apc = actor:GetPCApc();
    local headType = apc:GetHeadType();
    
	local Rootclasslist = imcIES.GetClassList('HairType');
	local Selectclass   = Rootclasslist:GetClass(apc:GetGender());
	local Selectclasslist = Selectclass:GetSubClassList();
	local cnt		      = Selectclasslist:Count();
    
	if headType-2 < 0 then
		for I = cnt-1, 0, -1 do
			local nextCls = Selectclasslist:GetByIndex(I);
			local currCls = Selectclasslist:GetByIndex(headType-1);
    		
			if imcIES.GetString(nextCls, 'Type') ~= imcIES.GetString(currCls, 'Type') and
				imcIES.GetString(nextCls, 'UseableBarrack') ==  'YES' then
					headType = I + 1;
					break;
			end
    	end
	else
		for i = headType-2, 0, -1 do
    		local nextCls = Selectclasslist:GetByIndex(i);
			local currCls = Selectclasslist:GetByIndex(headType-1);

			if  imcIES.GetString(nextCls, 'Type') ~= imcIES.GetString(currCls, 'Type') and
				imcIES.GetString(nextCls, 'UseableBarrack') ==  'YES' then
    				headType = i + 1;
    				break;
    		end
		end
    end

    GetBarrackPub():ChangeHair(headType);
    local frame = parent:GetTopParentFrame();
    SET_HEAD_NAME(frame, apc:GetGender(), headType);

end

function PUB_PREV_COLOR(parent, ctrl)
	local actor = GetBarrackPub():GetSelectedActor();
	local apc = actor:GetPCApc();
	local headType = apc:GetHeadType();
	
	local colorCount = headType - 1;
	local Rootclasslist = imcIES.GetClassList('HairType');
	local Selectclass   = Rootclasslist:GetClass(apc:GetGender());
	local Selectclasslist = Selectclass:GetSubClassList();
	local count		      = Selectclasslist:Count();

	local currCls = Selectclasslist:GetByIndex(colorCount);

	if 0 == colorCount then
		for i = colorCount+1, count do
			local nextCls = Selectclasslist:GetByIndex(i);
			if imcIES.GetString(nextCls, 'Color') == imcIES.GetString(currCls, 'Color')	then
				headType = i;
				break;
			end
		end
	else
		local prevCls = Selectclasslist:GetByIndex(colorCount-1);
		-- 아직 뒤에 자리가 있어, 근데 이름이 같아
		if imcIES.GetString(prevCls, 'Type') == imcIES.GetString(currCls, 'Type') then
			headType = headType - 1;
		else -- 이름이 달라
			for i = colorCount + 1, count-1 do
				local nextCls = Selectclasslist:GetByIndex(i);
				if imcIES.GetString(nextCls, 'Color') == imcIES.GetString(currCls, 'Color')	then
					headType = i - 1;
					break;
				end

				if count-1 == i then
					headType = count;
					break;
				end
			end
		end
	end

	GetBarrackPub():ChangeHair(headType);
	local frame = parent:GetTopParentFrame();
	SET_HEAD_COLOR_NAME(frame, apc:GetGender(), headType);
end

function PUB_NEXT_COLOR(parent, ctrl)
	local actor = GetBarrackPub():GetSelectedActor();
	local apc = actor:GetPCApc();
	local headType = apc:GetHeadType();
	
	local colorCount = headType - 1;
	local Rootclasslist = imcIES.GetClassList('HairType');
	local Selectclass   = Rootclasslist:GetClass(apc:GetGender());
	local Selectclasslist = Selectclass:GetSubClassList();
	local count		      = Selectclasslist:Count();

	local currCls = Selectclasslist:GetByIndex(colorCount);
	local nextCls = Selectclasslist:GetByIndex(colorCount+1);

	if nextCls == nil then
		for i = headType - 1, 0, -1 do
			local prevCls = Selectclasslist:GetByIndex(i);
			if prevCls ~= nil and
				imcIES.GetString(prevCls, 'Type') ~= imcIES.GetString(currCls, 'Type')	then
				headType = i + 2;
				break;
			end
		end
	else
		-- 뒤에 자리가 있어, 그런데 이름이 같아
		if imcIES.GetString(nextCls, 'Type') == imcIES.GetString(currCls, 'Type')  then
			headType = headType + 1;
		else -- 헤어 이름이 달라
			for i = colorCount - 1, 0, -1 do

				local prevCls = Selectclasslist:GetByIndex(i);
				if prevCls ~= nil and
					imcIES.GetString(prevCls, 'Type') ~= imcIES.GetString(currCls, 'Type')	then
					headType = i + 2;
					break;
				end

				if 0 == i then
					headType = 1;
					break;
				end
			end
		end
	end


	GetBarrackPub():ChangeHair(headType);
	local frame = parent:GetTopParentFrame();
	SET_HEAD_COLOR_NAME(frame, apc:GetGender(), headType);

end

function PUB_NEXT_DIRECTION(parent, ctrl)
	GetBarrackPub():ChangeDirection(1);

end

function PUB_PREV_DIRECTION(parent, ctrl)
	GetBarrackPub():ChangeDirection(2);
end

function PUB_CLICK_ACTOR(actor)

	GetBarrackPub():EnableFocusChar(true, 0);

	local frame = ui.GetFrame("pub_createchar");
	frame:ShowWindow(1);
	PUB_CHARFRAME_UPDATE(frame, actor);	
	
end

-- run script from code CBarrackPub Class

function PUB_RBTNDOWN()
	local frame = ui.GetFrame("pub_createchar");
	if frame:IsVisible() == 0 then
		return;
	end

	PUB_CANCEL_CREATECHAR(frame);
end

function PUB_MOUSE_OFF(actor)
	-- actor:GetAnimation():PlayFixAnim("PUB_SIT_STD", 1.0, 1, 0);	
end

function PUB_MOUSE_ON(actor)
	-- actor:GetAnimation():PlayFixAnim("PUB_LOOK", 1.0, 1, 0);		
end

function PUB_BARRACK_NEWCHARACTER(frame)
	frame:ShowWindow(0);
	local input_name = GET_CHILD(frame, "input_name", "ui::CEditControl");
	input_name:ClearText();
end
selectMap = 0;

function OPEN_PUB_CREATECHAR(frame)

	local OrshaBtn_mark = GET_CHILD_RECURSIVELY(frame, "OrshaBtn_mark")
	local KlaipeBtn_mark = GET_CHILD_RECURSIVELY(frame, "KlaipeBtn_mark")

	KlaipeBtn_mark:ShowWindow(0);
	OrshaBtn_mark:ShowWindow(0);

	local klaipeBtn = GET_CHILD_RECURSIVELY(frame, "KlaipeBtn")
	local orshaBtn = GET_CHILD_RECURSIVELY(frame, "OrshaBtn")
	klaipeBtn:SetEnable(1);
	orshaBtn:SetEnable(1);
	selectMap = 0;

end

function CLOSE_PUB_CREATECHAR(frame)

end

function PUB_EXEC_CREATECHAR(parent, ctrl)

	if selectMap == 0 then
		ui.SysMsg(ClMsg("NotChooseStartMap"));
		return;
	end

	local accountInfo = session.barrack.GetMyAccount();
	if accountInfo:GetPCCount() > 0 then
		
		local msg = ScpArgMsg("WillYouSeeOpeningAgain?");
		ui.MsgBox(msg, "_PUB_EXEC_CREATECHAR(1)", "_PUB_EXEC_CREATECHAR(0)");

	else
		_PUB_EXEC_CREATECHAR(1)
	end
end

function _PUB_EXEC_CREATECHAR(viewOpening)

	local frame = ui.GetFrame("pub_createchar");

	local input_name = GET_CHILD(frame, "input_name", "ui::CEditControl");
	local text = input_name:GetText();

	local actor = GetBarrackPub():GetSelectedActor();
	barrack.RequestCreateCharacter(text, actor, selectMap);
	GetBarrackPub():EnablePlayOpening(viewOpening, selectMap);

end

function SELECT_START_MAP_KLAIPE(parent, ctrl)
	ctrl:SetEnable(0);
	local KlaipeBtn_mark = parent:GetChild("KlaipeBtn_mark");
	local OrshaBtn_mark = parent:GetChild("OrshaBtn_mark");
	
	OrshaBtn_mark:ShowWindow(0);
	KlaipeBtn_mark:ShowWindow(1);

	local orshaBtn = parent:GetChild("OrshaBtn");
	orshaBtn:SetEnable(1);
	selectMap = 1;
end

function SELECT_START_MAP_ORSHA(parent, ctrl)
	ctrl:SetEnable(0);
	local OrshaBtn_mark = parent:GetChild("OrshaBtn_mark");
	local KlaipeBtn_mark = parent:GetChild("KlaipeBtn_mark");

	KlaipeBtn_mark:ShowWindow(0);
	OrshaBtn_mark:ShowWindow(1);

	local klaipeBtn = parent:GetChild("KlaipeBtn");
	klaipeBtn:SetEnable(1);
	selectMap = 2;
end