MAX_BARRACK_LAYER = 3
MAX_BARRACK_LAYER_CHAR = 16


function PUB_CREATECHAR_ON_INIT(addon, frame)
	
	addon:RegisterMsg("BARRACK_NEWCHARACTER", "PUB_BARRACK_NEWCHARACTER");

end

function PUB_CANCEL_CREATECHAR(frame)

	frame:ShowWindow(0);
	GetBarrackPub():EnableFocusChar(false);

end

local function _CREATE_STAT_GAUGE(box, ypos, stat, value, onImg, offImg, style, gaugeMarginX, gaugeLeftMarginX)	
	local statText = box:CreateControl('richtext', 'statText_'..stat, 0, ypos, 300, 30);
	statText:SetText(style..ClMsg(stat));

	local MAX_STAT_VALUE = 5;
	local IMG_WIDTH = 60;
	local xpos = gaugeLeftMarginX;
	for i = 1, MAX_STAT_VALUE do
		local bg = box:CreateControl('picture', 'statBg_'..stat..'_'..i, xpos, ypos, IMG_WIDTH, 30);
		AUTO_CAST(bg);
		bg:SetImage(offImg);		
		
		if i <= value then
			local img = box:CreateControl('picture', 'statImg_'..stat..'_'..i, xpos, ypos, IMG_WIDTH, 30);
			AUTO_CAST(img);
			img:SetImage(onImg);
		end
		xpos = xpos + IMG_WIDTH + gaugeMarginX;
	end

	ypos = ypos + statText:GetHeight() + 5;
	return ypos;
end

local function _PUB_CREATE_UPDATE_JOB_SPECIAL_STAT(frame, jobCls)
	local jobSpecialStatBox = GET_CHILD_RECURSIVELY(frame, 'jobSpecialStatBox');	
	local jobSpecialStatListBox = GET_CHILD(jobSpecialStatBox, 'jobSpecialStatListBox');
	jobSpecialStatListBox:RemoveAllChild();

	local JOB_SPECIAL_FONT = frame:GetUserConfig('JOB_SPECIAL_FONT');
	local GAUGE_LEFT_MARGIN_X = tonumber(frame:GetUserConfig('GAUGE_LEFT_MARGIN_X'));
	local GAUGE_INTERVAL_MARGIN_X = tonumber(frame:GetUserConfig('GAUGE_INTERVAL_MARGIN_X'));
	local caption = jobCls.Caption2;
	local infos = StringSplit(caption, '/');
	local ypos = 0;
	for i = 1, #infos, 2 do
		local stat = infos[i];
		local value = infos[i + 1];
		ypos = _CREATE_STAT_GAUGE(jobSpecialStatListBox, ypos, stat, tonumber(value), 'stat_gauge_bar', 'stat_gauge_frame', JOB_SPECIAL_FONT, GAUGE_INTERVAL_MARGIN_X, GAUGE_LEFT_MARGIN_X);
	end
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
		ratingstr_arg[i] = ratingstr_arg[i] + 0;
	end

	local classimage = GET_CHILD_RECURSIVELY(frame, "classImage", "ui::CPicture");
	classimage:SetImage(jobCls.Icon);

	local job_title = maingroup:GetChild("job_title");
	job_title:SetTextByKey("value", jobCls.Name);

	local job_desc = maingroup:GetChild("job_desc");
	job_desc:SetTextByKey("value", jobCls.Caption1);
	
	_PUB_CREATE_UPDATE_JOB_SPECIAL_STAT(frame, jobCls);
	SET_HEAD_NAME(frame, gender, headType);
end

function SET_HEAD_COLOR_NAME(frame, gender, headType)
	local Rootclasslist = imcIES.GetClassList('HairType');
	local Selectclass = Rootclasslist:GetClass(gender);
	local Selectclasslist = Selectclass:GetSubClassList();
	local cnt = Selectclasslist:Count();

	for i = 0, cnt-1 do
		local Changeclass = Selectclasslist:GetByIndex(i);	
		local index = imcIES.GetINT(Changeclass, 'Index');
		local type = imcIES.GetString(Changeclass, 'Color');

		if index == headType then
			local customgroup = GET_CHILD_RECURSIVELY(frame, "customgroup");
			local color = customgroup:GetChild("title_hairColorList");
			color:SetTextByKey("value", type);
			return;
		end
	end
end

function SET_HEAD_NAME(frame, gender, headType)
	local Rootclasslist = imcIES.GetClassList('HairType');
	local Selectclass = Rootclasslist:GetClass(gender);
	local Selectclasslist = Selectclass:GetSubClassList();
	local cnt = Selectclasslist:Count();

	for i = 0, cnt do
		local Changeclass	= Selectclasslist:GetByIndex(i);	
		if nil == Changeclass then
			return;
		end

		local index = imcIES.GetINT(Changeclass, 'Index');
		local type = imcIES.GetString(Changeclass, 'Type');
		if index == headType then
			local customgroup = GET_CHILD_RECURSIVELY(frame, "customgroup");
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

function OPEN_PUB_CREATECHAR(frame)

end

function CLOSE_PUB_CREATECHAR(frame)

end

function IS_FULL_SLOT_CURRENT_LAYER()
    local frame = ui.GetFrame("barrack_charlist")
    local child = GET_CHILD(frame, 'scrollBox')
    local char_cnt = child:GetChildCount() - 1
    if char_cnt >= MAX_BARRACK_LAYER_CHAR then        
        return true
    end
    return false
end


function PUB_EXEC_CREATECHAR(parent, ctrl)    
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

    local make_layer = current_layer
    if make_layer < 1 or make_layer > 3 then
        make_layer = 1
    end

	local actor = GetBarrackPub():GetSelectedActor();
	barrack.RequestCreateCharacter(text, actor, make_layer);
	GetBarrackPub():EnablePlayOpening(viewOpening);

end