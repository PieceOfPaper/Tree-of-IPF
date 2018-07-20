-- inun.lua
function INDUN_ON_INIT(addon, frame)
end

function INDUN_UI_OPEN(frame)
	INDUN_DRAW_CATEGORY(frame);

	-- resize frame for using system menu and quickslot
	local bg3 = frame:GetChild('bg3');
	--frame:Resize(frame:GetWidth(), bg3:GetY() + bg3:GetHeight());
end

function INDUN_DRAW_CATEGORY(frame)
	local categBox = GET_CHILD_RECURSIVELY(frame, "categBox", "ui::CGroupBox");
	local cateList = GET_CHILD_RECURSIVELY(categBox, "cateList", "ui::CGroupBox");
	cateList:RemoveAllChild();
	 
	local etcObj = GetMyEtcObject();
	if nil == etcObj then
		return;
	end

	local isPremiumState = session.loginInfo.IsPremiumState(ITEM_TOKEN);
	local clslist, cnt = GetClassList("Indun");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);
		local child = cateList:GetChild('CTRLSET_' .. cls.PlayPerResetType)
		if child == nil and cls.Category ~= 'None' then
			local ctrlSet = cateList:CreateControlSet("indun_cate_ctrl", "CTRLSET_" .. cls.PlayPerResetType, ui.LEFT, 0, 0, 0, 0, i*50);
			local name = ctrlSet:GetChild("name");
			name:SetTextByKey("value", cls.Category);

			local cnt = ctrlSet:GetChild("cnt");
			local etcType = "InDunCountType_"..tostring(cls.PlayPerResetType);
			cnt:SetTextByKey("cnt", TryGetProp(etcObj, etcType));
			local maxPlayCnt = cls.PlayPerReset;
			if true == isPremiumState then 
				maxPlayCnt = maxPlayCnt + cls.PlayPerReset_Token;
				if cls.PlayPerReset_Token > 0 then
					ctrlSet:SetUserValue("SHOW_INDUN_TEXT", "YES");
					ctrlSet:SetUserValue('TOKEN_BONUS', cls.PlayPerReset_Token);
				end
			end

			cnt:SetTextByKey("max", maxPlayCnt);
			ctrlSet:SetUserValue('RESET_TYPE', cls.PlayPerResetType)

			if i == 0 then
				local btn = ctrlSet:GetChild("button");
				INDUN_CATE_LBTN_CILK(ctrlSet, btn)
			end
		end
	end
	GBOX_AUTO_ALIGN(cateList, 0, -6, 0, true, false);
end

function INDUN_CATE_LBTN_CILK(frame, ctrl)
	local topFrame = frame:GetTopParentFrame();
	local preSeletType = topFrame:GetUserValue('SELECT');
	local preSelect = GET_CHILD_RECURSIVELY(topFrame, "CTRLSET_" .. preSeletType);
	if nil ~= preSelect then
		local button = preSelect:GetChild("button");
		button:SetSkinName("base_btn"); -- / baseyellow_btn
	end

	local nowType = frame:GetUserValue('RESET_TYPE');
	topFrame:SetUserValue('SELECT', nowType);
	ctrl:SetSkinName("baseyellow_btn");

	-- 추가 입장 관련된 애 눌렀을 때만 안내 메세지 나올 수 있도록
	local indunText = topFrame:GetChild('indunText');
	local cateCtrl = ctrl:GetParent();
	if cateCtrl:GetUserValue("SHOW_INDUN_TEXT") == "YES" then
		local msg = ScpArgMsg("IndunMore{COUNT}ForTOKEN", "COUNT", cateCtrl:GetUserValue('TOKEN_BONUS'));
		indunText:SetTextByKey("value", msg);
		indunText:ShowWindow(1);
	else
		indunText:ShowWindow(0);
	end
	INDUN_SHOW_INDUN_LIST(topFrame, tonumber(nowType))
end

function INDUN_SHOW_INDUN_LIST(frame, indunType)
	local lvUpCheckBox = GET_CHILD(frame, "levelUp", "ui::CCheckBox");
	local lvDownCheckBox = GET_CHILD(frame, "levelDown", "ui::CCheckBox");

	if lvUpCheckBox:IsChecked() == 0 and lvDownCheckBox:IsChecked() == 0 then		
		lvUpCheckBox:SetCheck(1) -- default option
	end

	local clslist, cnt = GetClassList("Indun");
	local indunTable = {};
	-- sort by level
	local indunTable = {}
	for i = 0, cnt - 1 do
		indunTable[i + 1] = GetClassByIndexFromList(clslist, i);
	end

	if lvUpCheckBox:IsChecked() == 1 then
		table.sort(indunTable, SORT_BY_LEVEL);
	else
		table.sort(indunTable, SORT_BY_LEVEL_REVERSE);
	end

	local listgBox = GET_CHILD_RECURSIVELY(frame, "listgBox", "ui::CGroupBox");
	local indunList = GET_CHILD_RECURSIVELY(listgBox, "indunList", "ui::CGroupBox");
	indunList:RemoveAllChild();

	local mylevel = info.GetLevel(session.GetMyHandle());

	for i = 1 , cnt do
		local cls = indunTable[i]
		if cls.PlayPerResetType == indunType and TryGetProp(cls, 'Category') ~= 'None' then
			local ctrlSet = indunList:CreateControlSet("indun_detail_ctrl", "CTRLSET_" .. i, ui.LEFT, 0, 0, 0, 0, i*50);
			local name = ctrlSet:GetChild("name");
			name:SetTextByKey("value", cls.Name);

			local lv = ctrlSet:GetChild("lv");
			lv:SetTextByKey("value", cls.Level);

			local map = ctrlSet:GetChild("map");
			local sList = StringSplit(cls.StartMap, "/");
			if nil ~= sList then
				local mapName = ''
				for j = 1, #sList do
					local mapCls = GetClass('Map', sList[j])	
					if nil ~= mapCls then
						mapName = mapName .. string.format("{img %s %d %d} ", "link_map", 20, 20) .. mapCls.Name .. '{nl}'

						-- minimap tooltip
						map:SetTooltipType('indun_tooltip')
						map:SetTooltipStrArg(cls.StartMap)
						map:SetTooltipNumArg(cls.ClassID)
					end
				end
				map:SetTextByKey("value",mapName);
			else
				map:ShowWindow(0);
			end

			if #sList > 1 then
				ctrlSet:Resize(ctrlSet:GetWidth(), ctrlSet:GetHeight() + 30);
			end

			local starImg = '';
			local star = cls.Level/ 100 
			for i = 0, star do
				starImg = starImg .. string.format("{img %s %d %d}", "star_mark", 20, 20) 
			end

			local grade = ctrlSet:GetChild("grade");
			grade:SetTextByKey("value", starImg);

			local button = ctrlSet:GetChild("button");
			if tonumber(cls.Level) < mylevel then -- 연두라인
				button:SetColorTone("FFC4DFB8");	
			elseif tonumber(cls.Level) > mylevel then -- 빨간라인
				button:SetColorTone("FFFFCA91");
			else
				button:SetColorTone("FFFFFFFF");	
			end

			local offset = (#sList - 1) * 20
			ctrlSet:Resize(ctrlSet:GetWidth(), ctrlSet:GetOriginalHeight() + offset );
			button:Resize(ctrlSet:GetWidth(), ctrlSet:GetOriginalHeight() + offset );
		end
	end
	GBOX_AUTO_ALIGN(indunList, 0, -6, 0, false, false);
end

function GID_CANTFIND_MGAME(msg)
	ui.SysMsg(ScpArgMsg(msg));
end

-- 레벨순정렬
function INDUN_SORT_OPTIN_CHECK(frame, ctrl)
	local lvUpCheckBox = GET_CHILD(frame, "levelUp", "ui::CCheckBox");
	local lvDownCheckBox = GET_CHILD(frame, "levelDown", "ui::CCheckBox");

	if lvUpCheckBox:GetName() == ctrl:GetName() then
		lvUpCheckBox:SetCheck(1)
		lvDownCheckBox:SetCheck(0)
	else
		lvUpCheckBox:SetCheck(0)
		lvDownCheckBox:SetCheck(1)
	end

	local topFrame = frame:GetTopParentFrame();
	local nowSelect = topFrame:GetUserValue('SELECT');
	INDUN_SHOW_INDUN_LIST(topFrame, tonumber(nowSelect));
end