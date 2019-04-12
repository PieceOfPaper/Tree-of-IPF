-- ui/uiscp/wiki.lua--

function WIKI_STATISTICS_VIEW(frame)
	local statGroupBox = GET_CHILD(frame, 'statistics', 'ui::CGroupBox');
	statGroupBox:ShowWindow(1);

	local clslist = GetClassList("Wiki");
	local index = 1;
	local totalWikiPoint = 0;
	local itemTotalWikiPoint = 0;
	local recipeTotalWikiPoint = 0;
	local areaTotalWikiPoint = 0;
	local achieveTotalWikiPoint = 0;

	local itemWikiPoint = 0;
	local recipeWikiPoint = 0;
	local areaWikiPoint = 0;
	local achieveWikiPoint = 0;

	local myWikiPoint = 0;
	while 1 do
		local cls = GetClassByIndexFromList(clslist, index);
		if cls == nil then
			break;
		end

		totalWikiPoint = totalWikiPoint + cls.WikiPoint;

		if cls.Category == 'Item' or cls.Category == 'SetItem' then
			itemTotalWikiPoint = itemTotalWikiPoint + cls.WikiPoint;
		elseif cls.Category == 'Recipe' then
			recipeTotalWikiPoint = recipeTotalWikiPoint + cls.WikiPoint;
		elseif cls.Category == 'Monster' or cls.Category == 'Map' then
			areaTotalWikiPoint = areaTotalWikiPoint + cls.WikiPoint;
		end

		local wikiIndex = session.GetWikiIndex(cls.ClassID);
		if wikiIndex ~= -1 then
			if cls.Category == 'Item' or cls.Category == 'SetItem' then
				itemWikiPoint = itemWikiPoint + cls.WikiPoint;
			elseif cls.Category == 'Recipe' then
				recipeWikiPoint = recipeWikiPoint + cls.WikiPoint;
			elseif cls.Category == 'Monster' or cls.Category == 'Map' then
				areaWikiPoint = areaWikiPoint + cls.WikiPoint;
			end
		end

		index = index + 1;
	end

	index = 1;
	local achievelist = GetClassList("Achieve");
	while 1 do
		local cls = GetClassByIndexFromList(achievelist, index);
		if cls == nil then
			break;
		end

		totalWikiPoint = totalWikiPoint + cls.WikiPoint;
		achieveTotalWikiPoint = achieveTotalWikiPoint + cls.WikiPoint;

		if HAVE_ACHIEVE_FIND(cls.ClassID) == 1 then
			achieveWikiPoint = achieveWikiPoint + cls.WikiPoint;
		end
		index = index + 1;
	end

	local infoGauge = GET_CHILD(statGroupBox, 'infogauge', 'ui::CInfoGauge');
	infoGauge:SetMaxValue(totalWikiPoint);

	infoGauge:AddInfo('Item', itemWikiPoint, 'FFcc9933');
	infoGauge:AddInfo('Recipe', recipeWikiPoint, 'FFff3333');
	infoGauge:AddInfo('Area', areaWikiPoint, 'ff6666cc');
	infoGauge:AddInfo('Achieve', achieveWikiPoint, 'ff669900');

	local totalInfoText = statGroupBox:CreateOrGetControl('richtext', 'totalInfo', 0, 0, 260, 40);
	tolua.cast(totalInfoText, 'ui::CRichText');
	totalInfoText:SetTextFixWidth(0);
	totalInfoText:EnableResizeByText(1);
	totalInfoText:SetText(ScpArgMsg('Auto_{@st42b}JeonChe_MoHeomJiSu')..'{nl}{@st53}'..totalWikiPoint);
	totalInfoText:SetTextAlign('center', 'top');
	totalInfoText:SetOffset(infoGauge:GetX() + infoGauge:GetWidth() / 2 - totalInfoText:GetWidth() / 2, infoGauge:GetY() - totalInfoText:GetHeight());

	local xPos = infoGauge:GetX() + infoGauge:GetWidth();
	local yPos = infoGauge:GetY() + infoGauge:GetHeight() - 100;
	WIKI_MAKE_POINT_INFO(statGroupBox, ScpArgMsg('Auto_aiTem'), 'Item', itemWikiPoint, itemTotalWikiPoint,  'FFcc9933', xPos, yPos);
	yPos = yPos - 100;
	WIKI_MAKE_POINT_INFO(statGroupBox, ScpArgMsg('Auto_JeJag'), 'Recipe', recipeWikiPoint, recipeTotalWikiPoint, 'FFff3333', xPos, yPos);
	yPos = yPos - 100;
	WIKI_MAKE_POINT_INFO(statGroupBox, ScpArgMsg('Auto_Jiyeog'), 'Area', areaWikiPoint, areaTotalWikiPoint, 'ff6666cc', xPos, yPos);
	yPos = yPos - 100;
	WIKI_MAKE_POINT_INFO(statGroupBox, ScpArgMsg('Auto_eopJeog'), 'Achieve', achieveWikiPoint, achieveTotalWikiPoint, 'ff669900', xPos, yPos);

	local myPointYPos = infoGauge:GetInfoPoint();
	local pictureSize = 20;
	myPointYPos = myPointYPos + infoGauge:GetY() - pictureSize / 2;
	local arrowPic = statGroupBox:CreateOrGetControl('picture', 'mypointarrow', infoGauge:GetX() - 20, myPointYPos, pictureSize, pictureSize);
	tolua.cast(arrowPic, 'ui::CPicture');
	arrowPic:SetImage('arrow_right');

	myWikiPoint = itemWikiPoint + recipeWikiPoint + areaWikiPoint + achieveWikiPoint;

	local myInfoText = statGroupBox:CreateOrGetControl('richtext', 'mypointinfo', 50, myPointYPos, 260, 40);
	tolua.cast(myInfoText, 'ui::CRichText');
	myInfoText:SetTextAlign('center', 'top');
	myInfoText:SetTextFixWidth(0);
	myInfoText:EnableResizeByText(1);
	myInfoText:SetText(ScpArgMsg('Auto_{@st42b}Nae_MoHeomJiSu')..'{nl}{@st53}'..myWikiPoint);

	local percentStr = string.format("%.2f%%", myWikiPoint / totalWikiPoint * 100);
	local percentText = statGroupBox:CreateOrGetControl('richtext', 'percentinfo', 0, 0, 260, 40);
	tolua.cast(percentText, 'ui::CRichText');
	percentText:SetTextFixWidth(0);
	percentText:EnableResizeByText(1);
	percentText:SetText('{@st42}'..percentStr);
	percentText:SetTextAlign('center', 'top');
	percentText:SetOffset(infoGauge:GetX() + infoGauge:GetWidth() / 2 - percentText:GetWidth() / 2, infoGauge:GetY() + infoGauge:GetHeight());
end

function WIKI_MAKE_POINT_INFO(groupBox, infoName, ctrlName, infoPoint, totalPoint, infoColor, xPos, yPos)
	local infoCtrlSet = groupBox:CreateOrGetControlSet('infogauge', ctrlName, xPos, yPos);
	local infoColorPic = GET_CHILD(infoCtrlSet, 'infocolor', 'ui::CPicture');
	infoColorPic:SetColorRect(infoColor);
	local infoText = GET_CHILD(infoCtrlSet, 'infoname', 'ui::CRichText');
	infoText:SetTextFixWidth(1);
	infoText:EnableResizeByText(1);
	infoText:SetText('{@st42b}'..infoName..'{nl}{s8} {nl}{@st41}'..infoPoint..'/'..totalPoint);
	infoText:SetLineMargin(-3);
	infoText:SetTextAlign('center', 'top');
end

function WIKI_ITEM_TROPHY_VIEW(frame)
	local itemPicasa = frame:GetChild('item_picasa');
	tolua.cast(itemPicasa, 'ui::CPicasa');
	itemPicasa:ShowWindow(1);

	local clslist = GetClassList("Wiki");
	local index = 1;
	while 1 do
		local cls = GetClassByIndexFromList(clslist, index);
		if cls == nil then
			break;
		end

		local wikiIndex = session.GetWikiIndex(cls.ClassID);
		if cls.Category == 'Item' and wikiIndex ~= -1 then
			local itemcls = GetClass("Item", cls.ClassName);
			if itemcls ~= nil then
				itemPicasa:AddCategory(itemcls.GroupName, itemcls.GroupName);
				local picasaItem = itemPicasa:AddItem(itemcls.GroupName, itemcls.ClassName, itemcls.TooltipImage, itemcls.Name, cls.Desc);
				if picasaItem ~= nil then
					tolua.cast(picasaItem, 'ui::CPicasaItem');
					picasaItem:SetValue(cls.ClassID);
				end
			end
		elseif cls.Category == 'SetItem' and wikiIndex ~= -1 then
			local setItemCls = GetClass("SetItem", cls.ClassName);
			if setItemCls ~= nil then
				local setItemPicasa = itemPicasa:AddCategory(ClientMsg(20051), ClientMsg(20051));
				local setItem = setItemPicasa:AddCategory(cls.ClassName, cls.Name);
				for cnt = 1, 7 do
					if setItemCls['ItemName_'..cnt] ~= 'None' then
						local itemCls = GetClass('Item', setItemCls['ItemName_'..cnt]);
						if itemCls ~= nil then
							local picasaItem = setItem:AddItem(itemCls.ClassName, itemCls.TooltipImage, itemCls.Name, cls.Desc);
							picasaItem:SetValue(cls.ClassID);
							picasaItem:SetValue2(itemCls.ClassID);
						end
					end
				end
			end
		end

		index = index + 1;
	end
end

function WIKI_RECIPE_TROPHY_VIEW(frame)

	local recipePicasa = frame:GetChild('recipe_picasa');
	tolua.cast(recipePicasa, 'ui::CPicasa');
	recipePicasa:ShowWindow(1);

	local clslist = GetClassList("Wiki");

	local index = 1;
	while 1 do
		local cls = GetClassByIndexFromList(clslist, index);
		if cls == nil then
			
			break;
		end

		local wikiIndex = session.GetWikiIndex(cls.ClassID);
		if cls.Category == 'Recipe' and wikiIndex ~= -1 then

			local recipecls = GetClass("Recipe", cls.TargetClassName);
			if recipecls ~= nil then
				local itemCls = GetClass("Item", recipecls.TargetItem);
				if itemCls ~= nil then
					
					local recipeCategory = recipePicasa:AddCategory(recipecls.Category, recipecls.Category);
					local picasaItem = recipeCategory:AddItem(recipecls.ClassName, itemCls.TooltipImage, itemCls.Name, cls.Desc);
					tolua.cast(picasaItem, 'ui::CPicasaItem');
					picasaItem:SetValue(cls.ClassID);

					local wiki = GetWiki(cls.ClassID);
					if wiki ~= nil then
						local teachPoint = GetWikiIntProp(wiki, "TeachPoint");

						if teachPoint > 0 then
							picasaItem:SetNoticeText(teachPoint);
							picasaItem:EnableDrag(true);
							local icon = picasaItem:GetIcon();
							icon:Set(itemCls.TooltipImage, 'Recipe', cls.ClassID, teachPoint);
						else
							picasaItem:SetNoticeText(-1);
							picasaItem:EnableDrag(false);
						end
					end
				end
			end
		end

		index = index + 1;
	end
end

function MAP_EVENT_GBOX_ADD(groupBoxWidth, detailGroupBox, mapCls, mapEventCls)
	local sObj = session.GetSessionObjectByName("SSN_MAPEVENTREWARD");
	if sObj == nil then
		return;
	end
	local obj = GetIES(sObj:GetIESObject());
	local yPos = 10;

	-- 검찰관 이벤트 관련
	if mapEventCls.QuestorPropCount ~= "None" then
		local questorCategory = detailGroupBox:CreateOrGetControlSet("mapEventCategory", "questor_explain", 0, yPos);
		local nameCtrl = GET_CHILD(questorCategory, "name", "ui::CRichText");
		nameCtrl:SetText(ClMsg("QuestorEvent"));

		local countCtrl = GET_CHILD(questorCategory, "count", "ui::CRichText");
		local propCount = mapEventCls.QuestorPropCount;
		local propReward = mapEventCls.QuestorPropReward;
		countCtrl:SetText(obj[propCount]);
		
		MAP_EVENT_REWARD_ADD(detailGroupBox, obj[propCount], obj[propReward], mapEventCls, "Questor", 150, yPos);
		yPos = yPos + questorCategory:GetHeight();
	end

	-- 돌발 이벤트 관련
	if mapEventCls.UnexpectedPropCount ~= "None" then
		local unexpectedCategory = detailGroupBox:CreateOrGetControlSet("mapEventCategory", "unexpected_explain", 0, yPos);
		local nameCtrl = GET_CHILD(unexpectedCategory, "name", "ui::CRichText");
		nameCtrl:SetText(ClMsg("UnexpectedEvent"));

		local countCtrl = GET_CHILD(unexpectedCategory, "count", "ui::CRichText");
		local propCount = mapEventCls.UnexpectedPropCount;
		local propReward = mapEventCls.UnexpectedPropReward;		
		countCtrl:SetText(obj[propCount]);
		
		MAP_EVENT_REWARD_ADD(detailGroupBox, obj[propCount], obj[propReward], mapEventCls, "Unexpected", 150, yPos);
		yPos = yPos + unexpectedCategory:GetHeight();
	end

	-- 단발 이벤트 관련
	if mapEventCls.OneShotPropCount ~= "None" then
		local oneShotCategory = detailGroupBox:CreateOrGetControlSet("mapEventCategory", "oneshot_explain", 0, yPos);
		local nameCtrl = GET_CHILD(oneShotCategory, "name", "ui::CRichText");
		nameCtrl:SetText(ClMsg("OneShotEvent"));

		local countCtrl = GET_CHILD(oneShotCategory, "count", "ui::CRichText");
		local propCount = mapEventCls.OneShotPropCount;
		local propReward = mapEventCls.OneShotPropReward;
		countCtrl:SetText(obj[propCount]);
		
		MAP_EVENT_REWARD_ADD(detailGroupBox, obj[propCount], obj[propReward], mapEventCls, "OneShot", 150, yPos);
		yPos = yPos + oneShotCategory:GetHeight();
	end

	detailGroupBox:Resize(groupBoxWidth, yPos + 10);
end

function MAP_EVENT_REWARD_ADD(gBox, propCount, propReward, mapEventCls, clsName, xPos, yPos)
	
	for i=1, 10 do
		local rewardPropName = clsName.."Reward"..i;
		local rewardCountName = clsName.."Count"..i;		
		if mapEventCls[rewardPropName] == "None" then
			return;
		end
		
		local typeStart, typeEnd = string.find(mapEventCls[rewardPropName], "/");
		
		local type = string.sub(mapEventCls[rewardPropName], 1, typeStart - 1);				
		local strRest = string.sub(mapEventCls[rewardPropName], typeEnd+1, string.len(mapEventCls[rewardPropName]));	
		
		local iconName = "None"
		local rewardCount = mapEventCls[rewardCountName];

		if i > 5 then
			yPos = yPos + 60;
		end
		xPos = xPos + ((i-1)*60);
		
		local rewardCtrl = gBox:CreateOrGetControlSet("mapEventReward", rewardPropName, xPos, yPos);
		if type == "Item" then
			local itemNameStart, itemNameEnd = string.find(strRest, "/");
			local itemName = string.sub(strRest, 1, itemNameStart - 1);
			local itemCount = string.sub(strRest, itemNameEnd + 1, string.len(strRest));
			
			local itemCls = GetClass("Item", itemName);	
			local picCtrl = GET_CHILD(rewardCtrl, "pic", "ui::CPicture");

			SET_ITEM_TOOLTIP_TYPE(picCtrl, itemCls.ClassID, itemCls);		
			picCtrl:SetTooltipArg('', itemCls.ClassID, 0);
			
			if propReward <= i then
				picCtrl:SetEventScript(ui.LBUTTONUP, "MAP_EVENT_REWARD_ITEM");				
				picCtrl:SetEventScriptArgString(ui.LBUTTONUP, clsName.."/"..mapEventCls.ClassID.."/"..i.."/"..itemCount);
				picCtrl:SetEventScriptArgNumber(ui.LBUTTONUP, itemCls.ClassID);
			end
			
			iconName = itemCls.Icon;
		elseif type == "Stat" then
			local statPoint = strRest;			
			local picCtrl = GET_CHILD(rewardCtrl, "pic", "ui::CPicture");			
			
			if propReward <= i then
				picCtrl:SetEventScript(ui.LBUTTONUP, "MAP_EVENT_REWARD_STAT");				
				picCtrl:SetEventScriptArgString(ui.LBUTTONUP, clsName.."/"..mapEventCls.ClassID.."/"..i);
				picCtrl:SetEventScriptArgNumber(ui.LBUTTONUP, statPoint);
			end
			
			iconName = "stat_up";			
		
		elseif type == "Exp" then	
			local expPoint = strRest;
			
			local picCtrl = GET_CHILD(rewardCtrl, "pic", "ui::CPicture");			
			
			if propReward <= i then
				picCtrl:SetEventScript(ui.LBUTTONUP, "MAP_EVENT_REWARD_EXP");
				picCtrl:SetEventScriptArgString(ui.LBUTTONUP, clsName.."/"..mapEventCls.ClassID.."/"..i);
				picCtrl:SetEventScriptArgNumber(ui.LBUTTONUP, expPoint);
			end
			
			iconName = "exp_up";
		end	
		
		local picCtrl = GET_CHILD(rewardCtrl, "pic", "ui::CPicture");
		picCtrl:SetImage(iconName);
		
		local countCtrl = GET_CHILD(rewardCtrl, "count", "ui::CRichText");
		countCtrl:SetText(rewardCount);
		
		if propCount < rewardCount then
			picCtrl:SetColorTone("FF333333");
			countCtrl:SetAlpha(50);
		else
			picCtrl:SetColorTone("FFFFFFFF");
			countCtrl:SetAlpha(100);
		end
	end
	
	return yPos;
end

function MAP_EVENT_REWARD_ITEM(frame, picCtrl, argStr, argNum)	
	local eventTypeStart, eventTypeEnd = string.find(argStr, "/");
	
	local eventType  = string.sub(argStr, 1, eventTypeStart - 1);
	local strRest = string.sub(argStr, eventTypeEnd+1, string.len(argStr));	
	
	local clsIdStart, clsIdEnd = string.find(strRest, "/");
	local eventClsId = string.sub(strRest, 1, clsIdStart-1);
	strRest = string.sub(strRest, clsIdEnd+1, string.len(strRest));
	
	local propNumStart, propNumEnd = string.find(strRest, "/");
	local propNum = string.sub(strRest, 1, propNumStart-1);
	local itemCount = string.sub(strRest, propNumEnd+1, string.len(strRest));
	
	local argList = "-1";
	if eventType == "Questor" then
		argList = string.format("%d %d %d %d", 0, eventClsId, propNum, itemCount);
	elseif eventType == "Unexpected" then
		argList = string.format("%d %d %d %d", 1, eventClsId, propNum, itemCount);
	elseif eventType == "OneShot" then
		argList = string.format("%d %d %d %d", 2, eventClsId, propNum, itemCount);
	end	
	pc.ReqExecuteTx_Item("SCR_MAP_EVENT_REWARD_ITEM", argNum, argList);
end

function MAP_EVENT_REWARD_STAT(frame, picCtrl, argStr, argNum)
	local eventTypeStart, eventTypeEnd = string.find(argStr, "/");
	
	local eventType  = string.sub(argStr, 1, eventTypeStart - 1);
	local strRest = string.sub(argStr, eventTypeEnd+1, string.len(argStr));	
	
	local clsIdStart, clsIdEnd = string.find(strRest, "/");	
	local eventClsId = string.sub(strRest, 1, clsIdStart-1);
	local propNum = string.sub(strRest, clsIdEnd+1, string.len(strRest));
	
	local argList = "-1";
	if eventType == "Questor" then
		argList = string.format("%d %d %d %d", 0, eventClsId, propNum, argNum);
	elseif eventType == "Unexpected" then
		argList = string.format("%d %d %d %d", 1, eventClsId, propNum, argNum);
	elseif eventType == "OneShot" then
		argList = string.format("%d %d %d %d", 2, eventClsId, propNum, argNum);
	end	
	pc.ReqExecuteTx_NumArgs("SCR_TX_MAP_EVENT_STAT_UP", argList);
end

function MAP_EVENT_REWARD_EXP(frame, picCtrl, argStr, argNum)
	local eventTypeStart, eventTypeEnd = string.find(argStr, "/");
	
	local eventType  = string.sub(argStr, 1, eventTypeStart - 1);
	local strRest = string.sub(argStr, eventTypeEnd+1, string.len(argStr));	
	
	local clsIdStart, clsIdEnd = string.find(strRest, "/");	
	local eventClsId = string.sub(strRest, 1, clsIdStart-1);
	local propNum = string.sub(strRest, clsIdEnd+1, string.len(strRest));
	
	local argList = "-1";
	if eventType == "Questor" then
		argList = string.format("%d %d %d %d", 0, eventClsId, propNum, argNum);
	elseif eventType == "Unexpected" then
		argList = string.format("%d %d %d %d", 1, eventClsId, propNum, argNum);
	elseif eventType == "OneShot" then
		argList = string.format("%d %d %d %d", 2, eventClsId, propNum, argNum);
	end	
	pc.ReqExecuteTx_NumArgs("SCR_TX_MAP_EVENT_EXP_UP", argList);
end

function WIKI_ACHIEVE_TROPHY_VIEW(frame)
	local achievePicasa = frame:GetChild('achieve_picasa');
	tolua.cast(achievePicasa, 'ui::CPicasa');
	achievePicasa:ShowWindow(1);

	local clslist = GetClassList("Achieve");
	local index = 1;
	while 1 do
		local cls = GetClassByIndexFromList(clslist, index);
		if cls == nil then
			break;
		end

		if HAVE_ACHIEVE_FIND(cls.ClassID) == 1 then
			local achieveSubCategory  = achievePicasa:AddCategory(cls.Category, cls.Category);
			local picasaItem = achieveSubCategory:AddItem(cls.ClassName, cls.Icon, cls.Name, cls.Desc);
			picasaItem:SetValue(-1);
			picasaItem:SetValue2(cls.ClassID);
		end
		index = index + 1;
	end
end

function WIKI_HELP_VIEW(frame)
	local helpPicasa = GET_CHILD(frame, "help_picasa", "ui::CPicasa");
	helpPicasa:ShowWindow(1);

	local picasaWidth = helpPicasa:GetWidth();

	local helpCount = session.GetHelpVecCount();
	for i=0, helpCount -1 do
		local helpType = session.GetHelpTypeByIndex(i);
		if helpType ~= -1 then
			local helpCls = GetClassByType("Help", helpType);
			if helpCls ~= nil then
				if helpPicasa:GetItem(helpCls.Category, helpCls.ClassName) == nil then
					local picasaCategory = helpPicasa:AddCategory(helpCls.Category, helpCls.Category);
					local picasaItem = helpPicasa:AddItem(helpCls.Category, helpCls.ClassName, "icon_item_Misc_00020", helpCls.Title.. ClMsg("Toward"), helpCls.SimpleExplain, 1);
					picasaCategory:SetViewType(ui.PVT_HIDE);

					local picasaItemGroupBox = picasaItem:GetGroupBox();
					local groupBoxWidth = picasaWidth - 20;
					HELPMSGBOX_ADD(groupBoxWidth, picasaItemGroupBox, helpCls);
				end
			end
		end
	end
end

function HELPMSGBOX_ADD(groupBoxWidth, detailGroupBox, helpCls)
	if detailGroupBox:GetChild("simple_explain") ~= nil then
		return;
	end
	local helpSimpleExplainCtrl = detailGroupBox:CreateOrGetControl("richtext", "simple_explain", 15, 15, groupBoxWidth, 24);
	tolua.cast(helpSimpleExplainCtrl, "ui::CRichText");
	helpSimpleExplainCtrl:Resize(groupBoxWidth -35, 40);
	helpSimpleExplainCtrl:EnableResizeByText(0);
	helpSimpleExplainCtrl:SetTextFixWidth(1);
	helpSimpleExplainCtrl:EnableSplitBySpace(0);
	helpSimpleExplainCtrl:SetText("{@st45tw5}"..helpCls.SimpleExplain.."{/}");

	local yPos = helpSimpleExplainCtrl:GetY() + helpSimpleExplainCtrl:GetHeight();
	for index = 1, 20 do
		yPos = HELPMSG_DETAIL_ADD(groupBoxWidth, detailGroupBox, helpCls, index, yPos);
	end

	detailGroupBox:Resize(groupBoxWidth -10, yPos + 10);
end

function HELPMSG_DETAIL_ADD(groupBoxWidth, groupBox, helpCls, index, yPos)
	if HasClassProperty("Help", helpCls.ClassID, "DetailExplain_"..index) == false then
		return yPos;
	end

	if helpCls["DetailExplain_"..index] == "None" then
		return yPos;
	end
	local xPos = 5;
	local detailCtrlSet = groupBox:CreateOrGetControlSet("helpCtrlSet", "detail"..helpCls["DetailExplain_"..index], xPos, yPos);

	local detailExplainCtrl = GET_CHILD(detailCtrlSet, "detailText", "ui::CRichText");
	local detailExplain = helpCls["DetailExplain_"..index];
	detailExplainCtrl:Resize(groupBoxWidth -40, 40);
	detailExplainCtrl:EnableResizeByText(0);
	detailExplainCtrl:SetTextFixWidth(1);
	detailExplainCtrl:EnableSplitBySpace(0);
	detailExplainCtrl:SetText("{@st45tw5}"..index..". "..detailExplain);
	detailExplainCtrl:SetOffset(15, 5);

	local ctrlSetHeight = detailExplainCtrl:GetHeight();

	local pictureCtrl 	= GET_CHILD(detailCtrlSet, "pic", "ui::CPicture");
	local detailPic		= helpCls["PictureAboutExplain_"..index];
	if detailPic == "None" then
		pictureCtrl:ShowWindow(0);
	else
		pictureCtrl:ShowWindow(1);
		pictureCtrl:SetImage(detailPic);
		pictureCtrl:Resize(20, detailExplainCtrl:GetY() + detailExplainCtrl:GetHeight(), pictureCtrl:GetImageWidth(), pictureCtrl:GetImageHeight());
		ctrlSetHeight = ctrlSetHeight + pictureCtrl:GetHeight();
	end

	local subExplainCtrl = GET_CHILD(detailCtrlSet, "picText", "ui::CRichText");
	local subExplain = helpCls["SubExplainAboutPicture_"..index];
	if subExplain == "None" then
		subExplainCtrl:ShowWindow(0);
	else
		subExplainCtrl:ShowWindow(1);
		subExplainCtrl:SetText("{@st45tw5}"..subExplain);
		subExplainCtrl:SetOffset(pictureCtrl:GetX(), pictureCtrl:GetY() + pictureCtrl:GetHeight());
		ctrlSetHeight = ctrlSetHeight + subExplainCtrl:GetHeight();
	end

	detailCtrlSet:Resize(groupBoxWidth - 10, ctrlSetHeight + 10);

	return yPos + detailCtrlSet:GetHeight();
end

function HELP_ALRAMNOTICE_LBTNUP(frame, ctrl, argStr, argNum)
	local wikiFrame = ui.GetFrame("wiki");
	WIKI_HELP_FOCUS(wikiFrame, argNum);

	ctrl:ShowWindow(0);
	frame:Invalidate();

	packet.ReqHelpReadType(argNum);
end

function WIKI_HELP_FOCUS(frame, helpType)
	local helpCls = GetClassByType("Help", helpType);
	if helpCls == nil then
		return;
	end

	local tabCtrl = GET_CHILD(frame, "itembox", "ui::CTabControl");
	tabCtrl:ChangeTab(5);
	WIKI_ALLTROPHY_VIEW(frame);

	local helpPicasa = GET_CHILD(frame, "help_picasa", "ui::CPicasa");
	local helpPicasaItem = helpPicasa:GetItem(helpCls.Category, helpCls.ClassName);
	helpPicasaItem:SetViewType(ui.PVT_DETAIL_IN_GROUPBOX);
	helpPicasa:SetFocusItem(helpCls.Category, helpCls.ClassName);

	frame:ShowWindow(1);
end

function WIKI_LOST_FOCUS(frame)
	local helpPicasa = GET_CHILD(frame, "help_picasa", "ui::CPicasa");
	helpPicasa:SetLostFocusItem();
end

function WIKIPAGE_ITEM_COMMON_OPT(itmeCls, groupBox, yPos)
	if itmeCls.STR ~= 0 then
		local strInfo = WIKIPAGE_ITEM_ABILITY(ScpArgMsg("STR"), itmeCls.STR);
		yPos =  WIKIPAGE_ITEM_ABILITY_ADD(groupBox, strInfo, yPos);
	end
	if itmeCls.DEX ~= 0 then
		local agiInfo = WIKIPAGE_ITEM_ABILITY(ScpArgMsg("DEX"), itmeCls.DEX);
		yPos =  WIKIPAGE_ITEM_ABILITY_ADD(groupBox, agiInfo, yPos);
	end
	if itmeCls.INT ~= 0 then
		local intInfo = WIKIPAGE_ITEM_ABILITY(ScpArgMsg("INT"), itmeCls.INT);
		yPos =  WIKIPAGE_ITEM_ABILITY_ADD(groupBox, intInfo, yPos);
	end
	if itmeCls.CON ~= 0 then
		local conInfo = WIKIPAGE_ITEM_ABILITY(ScpArgMsg("CON"), itmeCls.CON);
		yPos =  WIKIPAGE_ITEM_ABILITY_ADD(groupBox, conInfo, yPos);
	end
	if itmeCls.MNA ~= 0 then
		local conInfo = WIKIPAGE_ITEM_ABILITY(ScpArgMsg("MNA"), itmeCls.MNA);
		yPos =  WIKIPAGE_ITEM_ABILITY_ADD(groupBox, conInfo, yPos);
	end
	if itmeCls.MHP ~= 0 then
		local mhpInfo = WIKIPAGE_ITEM_ABILITY(ScpArgMsg("MHP"), itmeCls.MHP);
		yPos =  WIKIPAGE_ITEM_ABILITY_ADD(groupBox, mhpInfo, yPos);
	end
	if itmeCls.MSP ~= 0 then
		local mspInfo = WIKIPAGE_ITEM_ABILITY(ScpArgMsg("MSP"), itmeCls.MSP);
		yPos =  WIKIPAGE_ITEM_ABILITY_ADD(groupBox, mspInfo, yPos);
	end
	if itmeCls.CRTHR ~= 0 then
		local chrInfo = WIKIPAGE_ITEM_ABILITY(ScpArgMsg("CRTHR"), itmeCls.CRTHR);
		yPos =  WIKIPAGE_ITEM_ABILITY_ADD(groupBox, chrInfo, yPos);
	end
	if itmeCls.HR ~= 0 then
		local hrInfo = WIKIPAGE_ITEM_ABILITY(ScpArgMsg("HR"), itmeCls.HR);
		yPos =  WIKIPAGE_ITEM_ABILITY_ADD(groupBox, hrInfo, yPos);
	end
	if itmeCls.SR ~= 0 then
		local srInfo = WIKIPAGE_ITEM_ABILITY(ScpArgMsg("SR"), itmeCls.SR);
		yPos =  WIKIPAGE_ITEM_ABILITY_ADD(groupBox, srInfo, yPos);
	end
	if itmeCls.SkillPower ~= 0 then
		local skillPowerInfo = WIKIPAGE_ITEM_ABILITY(ScpArgMsg("SKILLPOWER"), itmeCls.SkillPower);
		yPos =  WIKIPAGE_ITEM_ABILITY_ADD(groupBox, skillPowerInfo, yPos);
	end

	return yPos;
end

function WIKIPAGE_ITEM_ABILITY(desc, itemMin, itemMax)
	if itemMin == 0 then
		return string.format("%s %s", desc ,ScpArgMsg("NONEINC"));
	elseif itemMax ~= nil then
		return string.format("{#050505}%s : %d ~ %d{/}", desc ,itemMin, itemMax);
	else
		return string.format("{#050505}%s + %d{/}", desc ,itemMin);
	end
end

function WIKIPAGE_ITEM_ABILITY_ADD(groupBox, strInfo, yPos)
	local cnt = groupBox:GetChildCount();
	local weaponDamage = groupBox:CreateOrGetControl('richtext', 'ex'..cnt, 15, yPos, 320, 20);
	tolua.cast(weaponDamage, 'ui::CRichText');
	weaponDamage:SetGravity(ui.CENTER_HORZ, ui.TOP);
	weaponDamage:SetTextFixWidth(1);
	weaponDamage:EnableResizeByText(1);
	weaponDamage:SetText(strInfo);
	return yPos + weaponDamage:GetHeight();
end

function UPDATE_WIKIDETAIL_TOOLTIP(tooltipframe, strarg, wikiType, numarg2)
	local wikiCls = GetClassByType('Wiki', wikiType);
	local itemCls = nil;

	if wikiCls == nil and wikiType ~= -1 then
		tooltipframe:ShowWindow(0);
		return;
	end

	tooltipframe:ShowWindow(1);

	local yPos = 0;

	if wikiType == -1 then
		local achieveCls = GetClassByType('Achieve', strarg);
		if achieveCls ~= nil then
			yPos = UPDATE_WIKIDETAIL_ACHIEVE_TOOLTIP(tooltipframe, achieveCls);
			tooltipframe:Resize(320, yPos);
			return;
		end
	end

	if wikiCls.Category == 'Item' then
		yPos = UPDATE_WIKIDETAIL_ITEM_TOOLTIP(tooltipframe, wikiCls);
	elseif wikiCls.Category == 'SetItem' then
		if strarg ~= 0 then
			itemCls = GetClassByType('Item', strarg);
			yPos = UPDATE_WIKIDETAIL_SETITEM_TOOLTIP(tooltipframe, wikiCls, itemCls);
		end
	elseif wikiCls.Category == 'Recipe' then
		yPos = UPDATE_WIKIDETAIL_RECIPE_TOOLTIP(tooltipframe, wikiCls);
	elseif wikiCls.Category == 'Monster' then
		yPos = UPDATE_WIKIDETAIL_MONSTER_TOOLTIP(tooltipframe, wikiCls);
	end

	tooltipframe:Resize(320, yPos);
end

function WIKIDETAIL_TOOLTIP_GROUPBOX_INIT(tooltipframe)
	local exinfoGroupBox = GET_CHILD(tooltipframe, 'exinfo', 'ui::CGroupBox');
	exinfoGroupBox:DeleteAllControl();

	return exinfoGroupBox;
end

function UPDATE_WIKIDETAIL_ITEM_TOOLTIP(tooltipframe, wikiCls)
	local itemcls = GetClass("Item", wikiCls.ClassName);
	local fullname = itemcls.Name;
	local itemrank_num = itemcls.ItemStar

	local FontColor = GET_ITEM_FONT_COLOR(itemrank_num);

	local itemPicCtrl = GET_CHILD(tooltipframe, 'itempic', 'ui::CPicture');
	itemPicCtrl:SetEnableStretch(1);
	itemPicCtrl:SetImage(itemcls.TooltipImage);

	local itemNameCtrl = GET_CHILD(tooltipframe, 'title', 'ui::CRichText');
	itemNameCtrl:SetText('{@st45}'..fullname);

	local itemDescCtrl = GET_CHILD(tooltipframe, 'desc', 'ui::CRichText');
	itemDescCtrl:EnableResizeByText(0);
	itemDescCtrl:Resize(260, 20);
	itemDescCtrl:SetTextAlign("left", "top");
	itemDescCtrl:SetGravity(ui.CENTER_HORZ, ui.TOP);
	itemDescCtrl:SetText('{s20}{#050505}'..wikiCls.Desc);

	local ypos = itemDescCtrl:GetY() + itemDescCtrl:GetHeight();

	local exinfoGroupBox = WIKIDETAIL_TOOLTIP_GROUPBOX_INIT(tooltipframe);
	exinfoGroupBox:SetOffset(0, ypos);
	local groupYpos = 5;
	if itemcls.ToolTipScp == 'WEAPON' then

		exinfoGroupBox:SetOffset(0, ypos);
		local weaponDamage = exinfoGroupBox:CreateOrGetControl('richtext', 'itematk', 15, groupYpos, 320, 20);
		tolua.cast(weaponDamage, 'ui::CRichText');
		weaponDamage:SetGravity(ui.LEFT, ui.TOP);
		weaponDamage:SetTextFixWidth(1);
		weaponDamage:EnableResizeByText(1);
		weaponDamage:SetText(ScpArgMsg('Auto_{s20}{#050505}KongKyeogLyeog_:_').. itemcls.MINATK.. ' ~ '..itemcls.MAXATK);
		groupYpos = groupYpos + weaponDamage:GetHeight();

		groupYpos = WIKIPAGE_ITEM_COMMON_OPT(itemcls, exinfoGroupBox, groupYpos);
	elseif itemcls.ToolTipScp == 'ARMOR' then
		exinfoGroupBox:SetOffset(0, ypos);
		if itemcls.DEF ~= 0 then
			local weaponDamage = exinfoGroupBox:CreateOrGetControl('richtext', 'itematk', 15, groupYpos, 320, 20);
			tolua.cast(weaponDamage, 'ui::CRichText');
			weaponDamage:SetGravity(ui.LEFT, ui.TOP);
			weaponDamage:SetTextFixWidth(1);
			weaponDamage:EnableResizeByText(1);
			weaponDamage:SetText(ScpArgMsg('Auto_{s20}{#050505}BangeoLyeog_:_').. itemcls.DEF);

			groupYpos = groupYpos + weaponDamage:GetHeight();
		end
		groupYpos = WIKIPAGE_ITEM_COMMON_OPT(itemcls, exinfoGroupBox, groupYpos);
	end

	groupYpos = WIKIDETAIL_ITEM_TOOLTIP(tooltipframe, wikiCls, groupYpos);

	ypos = ypos + groupYpos;

	return ypos + 30;
end

function WIKIDETAIL_ITEM_TOOLTIP(tooltipframe, wikiCls, yPos)
	local wiki = GetWiki(wikiCls.ClassID);

	if wiki == nil then
		return yPos;
	end

	local pairRank = session.GetPairWikiRank(wikiCls.ClassID);
	local intRank = session.GetIntWikiRank(wikiCls.ClassID);

	yPos = GET_WIKI_SORT_PROP_TXT(tooltipframe, wiki, wikiCls, ClientMsg(20021), "Mon_", MAX_WIKI_ITEM_MON, "GET_WIKI_ITEM_MON_TXT", yPos);
	yPos = GET_WIKI_INTPROP_TXT(tooltipframe, wiki, "Total", ClientMsg(20020), intRank, yPos);

	yPos = GET_WIKI_SORT_PROP_TXT(tooltipframe, wiki, wikiCls, ClientMsg(20022), "Q_", MAX_WIKI_ITEM_QUEST, "GET_WIKI_ITEM_QUEST_TXT", yPos);
	yPos = GET_WIKI_INTPROP_TXT(tooltipframe, wiki, "Buy", ClientMsg(20022), nil, yPos);
	yPos = GET_WIKI_INTPROP_TXT(tooltipframe, wiki, "Sell", ClientMsg(20023), nil, yPos);
	yPos = GET_WIKI_INTPROP_TXT(tooltipframe, wiki, "Exchange", ClientMsg(20025), nil, yPos);
	yPos = GET_WIKI_INTPROP_TXT(tooltipframe, wiki, "EquipChange", ClientMsg(20026), nil, yPos);
	yPos = GET_WIKI_INTPROP_TXT(tooltipframe, wiki, "Recipe", ClientMsg(20027), nil, yPos);
	yPos = GET_WIKI_INTPROP_TXT(tooltipframe, wiki, "Quest", ClientMsg(20028), nil, yPos);
	yPos = GET_WIKI_INTPROP_TXT(tooltipframe, wiki, "Bag", ClientMsg(20029), nil, yPos);
	yPos = GET_WIKI_INTPROP_TXT(tooltipframe, wiki, "Package", ClientMsg(20030), nil, yPos);
	yPos = GET_WIKI_INTPROP_TXT(tooltipframe, wiki, "GuildQuest", ClientMsg(20031), nil, yPos);
	yPos = GET_WIKI_INTPROP_TXT(tooltipframe, wiki, "Inn", ClientMsg(20032), nil, yPos);
	yPos = GET_WIKI_INTPROP_TXT(tooltipframe, wiki, "Rullet", ClientMsg(20033), nil, yPos);

	return yPos;
end

function GET_WIKI_ITEM_MON_TXT(frame, propValue, count, index, groupboxYPos, dropItemPicSize, dropItemTitleTextHeight, wikiCls)
	dropItemPicSize = 40;

	local cls = GetClassByType("Monster", propValue);
	if cls == nil then
		return groupboxYPos, 0, 0;
	end

	index = index - 1;

	local dropItemPicHorzCount = 3;
	local dropItemXPosInit = (250 - dropItemPicSize * 3) / (dropItemPicHorzCount+1);
	local dropItemXPos = (250 - dropItemPicSize * 3) / (dropItemPicHorzCount+1);

	local rem = index % dropItemPicHorzCount;
	if index ~= 0 and rem == 0 then
		groupboxYPos = groupboxYPos + dropItemPicSize + 5 + dropItemTitleTextHeight;
		dropItemXPos = dropItemXPosInit * (rem+1) + dropItemPicSize * rem;
	else
		dropItemXPos = dropItemXPosInit * (index+1) + dropItemPicSize * index;
	end

	local exinfoGroupBox = GET_CHILD(frame, 'exinfo', 'ui::CGroupBox');
	local ctrl = exinfoGroupBox:CreateOrGetControl('picture', "_WK_ICON_" .. index, dropItemXPos, groupboxYPos, dropItemPicSize, dropItemPicSize);
	tolua.cast(ctrl, "ui::CPicture");
	ctrl:SetEnableStretch(1);
	ctrl:SetImage(wikiCls.Illust);

	local dropItemNameCtrl = exinfoGroupBox:CreateOrGetControl('richtext', "_WI_ICON_TXT_" .. index, dropItemXPos, groupboxYPos + dropItemPicSize, 70, 20);
	tolua.cast(dropItemNameCtrl, 'ui::CRichText');
	dropItemNameCtrl:EnableResizeByText(1);
	dropItemNameCtrl:SetTextFixWidth(1);
	dropItemNameCtrl:SetLineMargin(-2);
	dropItemNameCtrl:SetTextAlign("center", "top");

	dropItemNameCtrl:SetText('{s18}{#050505}'.. cls.Name..'{nl}'..count..ClientMsg(20014));

	local itemTitleXPos = (dropItemNameCtrl:GetWidth() - dropItemPicSize) / 2;
	dropItemNameCtrl:SetOffset(dropItemXPos - itemTitleXPos, groupboxYPos + dropItemPicSize);

	dropItemTitleTextHeight = math.max(dropItemTitleTextHeight, dropItemNameCtrl:GetHeight());

	return groupboxYPos, dropItemTitleTextHeight, dropItemPicSize;
end

function GET_WIKI_ITEM_QUEST_TXT(frame, propValue, count, index, groupboxYPos, dropItemPicSize, dropItemTitleTextHeight)

	local ret = "";

	local cls = GetClassByType("QuestProgressCheck", propValue);
	if cls == nil then
		return groupboxYPos, 0, 0;
	end

	ret = string.format("{nl}%s : %d %s", cls.Name, count, ClientMsg(20014));

	return groupboxYPos, dropItemTitleTextHeight, dropItemPicSize;
end

function UPDATE_WIKIDETAIL_SETITEM_TOOLTIP(tooltipframe, wikiCls, itemcls)
	local fullname = itemcls.Name;
	local itemrank_num = itemcls.ItemStar

	local FontColor = GET_ITEM_FONT_COLOR(itemrank_num);

	local itemPicCtrl = GET_CHILD(tooltipframe, 'itempic', 'ui::CPicture');
	itemPicCtrl:SetEnableStretch(1);
	itemPicCtrl:SetImage(itemcls.TooltipImage);

	local itemNameCtrl = GET_CHILD(tooltipframe, 'title', 'ui::CRichText');
	itemNameCtrl:SetText('{@st45}'..fullname);

	local itemDescCtrl = GET_CHILD(tooltipframe, 'desc', 'ui::CRichText');
	itemDescCtrl:EnableResizeByText(0);
	itemDescCtrl:Resize(260, 20);
	itemDescCtrl:SetTextAlign("left", "top");
	itemDescCtrl:SetGravity(ui.CENTER_HORZ, ui.TOP);

	local itemWikiCls = GetClass('Wiki', itemcls.ClassName);
	if itemWikiCls ~= nil then
		itemDescCtrl:SetText('{s20}{#050505}'..itemWikiCls.Desc);
	end

	local ypos = itemDescCtrl:GetY() + itemDescCtrl:GetHeight();

	return ypos + 30;
end

function DRAW_RECIPE_MATERIAL(exinfoGroupBox, recipecls, ypos, drawStartIndex)

	if drawStartIndex == nil then
		drawStartIndex = 0;
	end

	local index = 0;
	local groupboxYPos = 5;
	local recipeItemPicSize = 40;
	local recipeItemPicHorzCount = 3;
	local recipeItemTitleTextHeight = 0;
	local recipeItemXPosInit = (250 - recipeItemPicSize * 3) / (recipeItemPicHorzCount+1);
	local recipeItemXPos = (250 - recipeItemPicSize * 3) / (recipeItemPicHorzCount+1);

	local drawIndex = 0;
	local recipeType = recipecls.RecipeType;

	local row = 1;
	while 1 do
		local col = 1;
		local propCnt = 0;
		while 1 do
			local propname = "Item_" .. row .. "_" .. col;
			local propvalue = recipecls[propname];
			local prop = GetPropType(recipecls, propname);
			if prop == nil or propvalue == "None" then
				break;
			end

			if drawIndex >= drawStartIndex then
				local rem = index % recipeItemPicHorzCount;
				if index ~= 0 and rem == 0 then
					groupboxYPos = groupboxYPos + recipeItemPicSize + 5 + recipeItemTitleTextHeight;
					recipeItemXPos = recipeItemXPosInit * (rem+1) + recipeItemPicSize * rem;
				else
					recipeItemXPos = recipeItemXPosInit * (index+1) + recipeItemPicSize * index;
				end

				local recipeItem = propvalue;
				local recipeItemCls = nil;
				local recipeImageName;
				local recipeItemName;
				if propname == 'NeedWiki' then
					recipeItemCls = GetClass('Wiki', recipeItem);
					recipeImageName = recipeItemCls.Illust;
					recipeItemName = recipeItemCls.Name;
				else
					recipeItemCls = GetClass('Item', recipeItem);
					recipeImageName = recipeItemCls.TooltipImage;
					recipeItemName = recipeItemCls.Name;
				end

				local recipeItemCnt, recipeItemLv = 0, 0;
				if propname == 'FromItem' or propname == 'NeedWiki' then
					recipeItemCnt = 1;
				else
					recipeItemCnt, recipeItemLv = GET_RECIPE_REQITEM_CNT(recipecls, propname);
				end

				local itemRecipePicCtrl = exinfoGroupBox:CreateOrGetControl('picture', recipeItem, recipeItemXPos, groupboxYPos, recipeItemPicSize, recipeItemPicSize);
				tolua.cast(itemRecipePicCtrl, 'ui::CPicture');
				itemRecipePicCtrl:SetEnableStretch(1);
				itemRecipePicCtrl:SetImage(recipeImageName);

				local itemRecipeNameCtrl = exinfoGroupBox:CreateOrGetControl('richtext', recipeItem..'itemName', recipeItemXPos, groupboxYPos + recipeItemPicSize, 70, 20);
				tolua.cast(itemRecipeNameCtrl, 'ui::CRichText');
				itemRecipeNameCtrl:EnableResizeByText(1);
				itemRecipeNameCtrl:SetTextFixWidth(1);
				itemRecipeNameCtrl:SetLineMargin(-2);
				itemRecipeNameCtrl:SetTextAlign("center", "top");

				local invItem = session.GetInvItemByType(recipeItemCls.ClassID);
				local invCnt = 0;
				if invItem == nil then
					if propname == 'NeedWiki' and recipeItemCls ~= nil then
						invCnt = 1;
					end
				else
					invCnt = GET_PC_ITEM_COUNT_BY_LEVEL(recipeItemCls.ClassID, recipeItemLv);
				end
			
				itemRecipeNameCtrl:SetText('{s18}{#050505}'.. GET_RECIPE_ITEM_TXT(recipeType, recipeItemName, recipeItemCnt, recipeItemLv, invCnt));
				local itemTitleXPos = (itemRecipeNameCtrl:GetWidth() - recipeItemPicSize) / 2;
				itemRecipeNameCtrl:SetOffset(recipeItemXPos - itemTitleXPos, groupboxYPos + recipeItemPicSize);

				recipeItemTitleTextHeight = math.max(recipeItemTitleTextHeight, itemRecipeNameCtrl:GetHeight());
				index = index + 1;
			end

			drawIndex = drawIndex + 1;

			propCnt = propCnt + 1;
			col = col + 1;
		end

		if propCnt == 0 then
			break;
		end
		row = row + 1
	end

	if index ~= 0 then
		groupboxYPos = groupboxYPos + recipeItemPicSize + recipeItemTitleTextHeight;
	end

	ypos = ypos + groupboxYPos;
	return ypos;
end

function UPDATE_WIKIDETAIL_RECIPE_TOOLTIP(tooltipframe, wikiCls)
	local recipecls = GetClass('Recipe', wikiCls.TargetClassName);
	local itemcls = GetClass("Item", recipecls.TargetItem);
	local fullname = itemcls.Name;
	local itemrank_num = itemcls.ItemStar

	local FontColor = GET_ITEM_FONT_COLOR(itemrank_num);

	local itemPicCtrl = GET_CHILD(tooltipframe, 'itempic', 'ui::CPicture');
	itemPicCtrl:SetEnableStretch(1);
	itemPicCtrl:SetImage(itemcls.TooltipImage);

	local itemNameCtrl = GET_CHILD(tooltipframe, 'title', 'ui::CRichText');
	itemNameCtrl:SetText('{@st45}'..fullname);

	local itemDescCtrl = GET_CHILD(tooltipframe, 'desc', 'ui::CRichText');
	itemDescCtrl:EnableResizeByText(0);
	itemDescCtrl:Resize(260, 20);
	itemDescCtrl:SetTextAlign("left", "top");
	itemDescCtrl:SetGravity(ui.CENTER_HORZ, ui.TOP);
	itemDescCtrl:SetText('{s20}{#050505}'..wikiCls.Desc);

	local ypos = itemDescCtrl:GetY() + itemDescCtrl:GetHeight();

	local exinfoGroupBox = WIKIDETAIL_TOOLTIP_GROUPBOX_INIT(tooltipframe);
	exinfoGroupBox:SetOffset(0, ypos);
	ypos = DRAW_RECIPE_MATERIAL(exinfoGroupBox, recipecls, ypos);
	
	return ypos + 30;
end

function GET_RECIPE_ITEM_TXT(recipeType, name, cnt, lv, invcnt)

	local color = '{b}{#003366}';

	if invcnt < cnt then
		color = '{b}{#880000}';
	end

	if lv == 0 then
		return string.format("%s {nl}%s(%d/%d)", name, color, invcnt, cnt);
	else
		return string.format("%s{nl}{#0000FF}(Lv%d){/}{nl}%s(%d/%d)", name, lv, color, invcnt, cnt);
	end

end

function WIKI_RBTNUP_ITEM_USE(wikiClsType)

	local wikiCls = GetClassByType('Wiki', wikiClsType);

	if wikiCls == nil then
		return;
	end

	if wikiCls.Category == 'Recipe' then
		WIKI_RBTNUP_RECIPE_ITEM_USE(wikiCls);
	elseif wikiCls.Category == 'Item' then
		WIKI_RBTNUP_ITEM_ITEM_USE(wikiCls);
	end
end

function WIKI_RBTNUP_RECIPE_ITEM_USE(wikiCls)
	session.ResetRecipeList();

	local recipecls = GetClass('Recipe', wikiCls.TargetClassName);

	local recipeType = recipecls.RecipeType;
	local cnt = GetEntryCount(recipecls);
	local index = 0;
	local isMakeRecipe = 0;

	if recipeType ~= 'Drag' then
		for i = 0 , cnt - 1 do
			local propname, propvalue, propType = GetEntryByIndex(recipecls, i);
			local recipeItem = IS_WIKI_RECIPE_PROP(recipeType, propname, propType);

			if 1 == recipeItem and propvalue ~= "None" then
				local recipeItem = propvalue;
				local recipeItemCls = GetClass('Item', recipeItem);
				local recipeItemCnt = 0;
				local recipeItemLv = 0;

				if propname == 'FromItem' then
					recipeItemCnt = 1;
					local invItem = session.GetInvItemByType(recipeItemCls.ClassID);
					if invItem ~= nil then
						session.AddRecipeInfo(invItem:GetIESID(), 0, -1, -1);
					else
						session.ResetRecipeList();
						isMakeRecipe = 0;
						break;
					end
				else
					recipeItemCnt, recipeItemLv = GET_RECIPE_REQITEM_CNT(recipecls, propname);
				end

				local invCnt = session.GetInvItemCountByType(recipeItemCls.ClassID);
				
				if recipeItemCnt <= invCnt then
					if string.find(propname, "Item_") ~= nil and string.find(propname, "_Cnt") == nil then
						local filter = "%d_%d";
						local mixerStr = string.sub(propname, string.find(propname, filter));

						local i = tonumber(string.sub(mixerStr, 1, 1));
						local j = tonumber(string.sub(mixerStr, 3));
						session.AddRecipeInfo(invItem:GetIESID(), recipeItemCnt, i - 1, j - 1);
					end
					isMakeRecipe = 1;
				else
					session.ResetRecipeList();
					isMakeRecipe = 0;
					break;
				end

				index = index + 1;
			end
		end

		if isMakeRecipe == 1 then
			local reqlist = session.GetRecipeList();
			item.ReqRecipeItem(reqlist, recipecls.ClassID);
		end
	else
		local dragMakeItem = GetClass('Item', recipecls.TargetItem);
		local invItemList = {};
		for i = 1 , 5 do
			if recipecls["Item_"..i.."_1"] ~= "None" then
				local recipeItemCnt, invItemCnt, dragRecipeItem, invItem, recipeItemLv = GET_RECIPE_MATERIAL_INFO(recipecls, i);
				if invItem ~= nil then
					if recipeItemCnt <= invItemCnt then
						isMakeRecipe = 1;
						invItemList[i] = invItem;
					else
						isMakeRecipe = 0;
						break;
					end
				else
					isMakeRecipe = 0;
					break;
				end
			else
				break;
			end
		end

		if isMakeRecipe == 1 then
			DRAGRECIPE_MSGBOX(invItemList, dragMakeItem, recipecls);
		end
	end

	if isMakeRecipe == 0 then
		ui.AddText("SystemMsgFrame", ClMsg('NotEnoughRecipe'));
	end
end

function WIKI_RBTNUP_ITEM_ITEM_USE(wikiCls)
	local socialFrame = ui.GetFrame("social");
	if socialFrame:IsVisible() == 0 then
		return;
	end

	local buyGbox = GET_CHILD(socialFrame, "buyGbox", "ui::CGroupBox");
	if buyGbox:IsVisible() == 0 then
		return;
	end

	if wikiCls.Category == "Item" then
		local itemCls = GetClass("Item", wikiCls.ClassName);

		if itemCls ~= nil then
			SOCIAL_BUY_ITEM_SET_FROM_WIKI(socialFrame, itemCls);
		end
	end
end

function UPDATE_WIKIDETAIL_MONSTER_TOOLTIP(tooltipframe, wikiCls)
	local targetNameStart, targetNameEnd = string.find(wikiCls.TargetClassName, '/');
	local monstercls = nil;

	if targetNameStart == nil then
		monstercls = GetClass("Monster", wikiCls.TargetClassName);
	else
		local targetName = string.sub(wikiCls.TargetClassName, 1, targetNameStart - 1);
		monstercls = GetClass("Monster", targetName);
	end

	if monstercls == nil then
		tooltipframe:ShowWindow(0);
		return;
	end

	local fullname = monstercls.Name;

	local monsterPicCtrl = GET_CHILD(tooltipframe, 'itempic', 'ui::CPicture');
	monsterPicCtrl:SetEnableStretch(1);
	monsterPicCtrl:SetImage(wikiCls.Illust);

	local monsterNameCtrl = GET_CHILD(tooltipframe, 'title', 'ui::CRichText');
	monsterNameCtrl:SetText('{@st45}'..fullname);

	local monsterDescCtrl = GET_CHILD(tooltipframe, 'desc', 'ui::CRichText');
	monsterDescCtrl:EnableResizeByText(0);
	monsterDescCtrl:Resize(260, 20);
	monsterDescCtrl:SetTextAlign("left", "top");
	monsterDescCtrl:SetGravity(ui.CENTER_HORZ, ui.TOP);
	monsterDescCtrl:SetText('{s20}{#050505}'..wikiCls.Desc);

	local ypos = monsterDescCtrl:GetY() + monsterDescCtrl:GetHeight();

	local exinfoGroupBox = WIKIDETAIL_TOOLTIP_GROUPBOX_INIT(tooltipframe);
	exinfoGroupBox:SetOffset(0, ypos);

	local groupYPos = WIKIDETAIL_MONSTER_KILL_TOOLTIP(tooltipframe, wikiCls);

	return ypos + groupYPos + 30;
end

function WIKIDETAIL_MONSTER_KILL_TOOLTIP(tooltipframe, wikiCls)
	local wiki = GetWiki(wikiCls.ClassID);

	if wiki == nil then
		return 0;
	end

	local pairRank = session.GetPairWikiRank(wikiCls.ClassID);
	local intRank = session.GetIntWikiRank(wikiCls.ClassID);

	local groupboxYPos = 5;

	groupboxYPos = GET_WIKI_SORT_PROP_TXT(tooltipframe, wiki, wikiCls, ClientMsg(20010), "DropItem_", MAX_WIKI_MON_DROPITEM, "GET_WIKI_MON_DROPITEM_TXT", groupboxYPos);
	groupboxYPos = GET_WIKI_INTPROP_TXT(tooltipframe, wiki, "KillCount", ClientMsg(20011), intRank, groupboxYPos);
	groupboxYPos = GET_WIKI_SORT_PROP_TXT(tooltipframe, wiki, wikiCls, ClientMsg(20016), "TopAtk_", MAX_WIKI_TOPATTACK, "GET_WIKI_TOPATK_TXT", groupboxYPos);

	return groupboxYPos;
end

function GET_WIKI_MON_DROPITEM_TXT(frame, propValue, count, index, groupboxYPos, dropItemPicSize, dropItemTitleTextHeight)
	dropItemPicSize = 40;
	local cls = GetClassByType("Item", propValue);
	if cls == nil then
		return 0, 0, 0;
	end

	index = index - 1;

	local dropItemPicHorzCount = 3;
	local dropItemXPosInit = (250 - dropItemPicSize * 3) / (dropItemPicHorzCount+1);
	local dropItemXPos = (250 - dropItemPicSize * 3) / (dropItemPicHorzCount+1);

	local rem = index % dropItemPicHorzCount;
	if index ~= 0 and rem == 0 then
		groupboxYPos = groupboxYPos + dropItemPicSize + 5 + dropItemTitleTextHeight;
		dropItemXPos = dropItemXPosInit * (rem+1) + dropItemPicSize * rem;
	else
		dropItemXPos = dropItemXPosInit * (index+1) + dropItemPicSize * index;
	end

	local icon = cls.Icon;
	local exinfoGroupBox = GET_CHILD(frame, 'exinfo', 'ui::CGroupBox');
	local ctrl = exinfoGroupBox:CreateOrGetControl('picture', "_WK_ICON_" .. index, dropItemXPos, groupboxYPos, dropItemPicSize, dropItemPicSize);
	tolua.cast(ctrl, "ui::CPicture");
	ctrl:SetEnableStretch(1);
	ctrl:SetImage(icon);

	local dropItemNameCtrl = exinfoGroupBox:CreateOrGetControl('richtext', "_WI_ICON_TXT_" .. index, dropItemXPos, groupboxYPos + dropItemPicSize, 70, 20);
	tolua.cast(dropItemNameCtrl, 'ui::CRichText');
	dropItemNameCtrl:EnableResizeByText(1);
	dropItemNameCtrl:SetTextFixWidth(1);
	dropItemNameCtrl:SetLineMargin(-2);
	dropItemNameCtrl:SetTextAlign("center", "top");

	if cls.ItemType ~= 'Money' then
		dropItemNameCtrl:SetText('{s18}{#050505}'.. cls.Name..'{nl}'..count..ClientMsg(20014));
	else
		dropItemNameCtrl:SetText('{s18}{#050505}'.. cls.Name);
	end
	local itemTitleXPos = (dropItemNameCtrl:GetWidth() - dropItemPicSize) / 2;
	dropItemNameCtrl:SetOffset(dropItemXPos - itemTitleXPos, groupboxYPos + dropItemPicSize);

	dropItemTitleTextHeight = math.max(dropItemTitleTextHeight, dropItemNameCtrl:GetHeight());

	return groupboxYPos, dropItemTitleTextHeight, dropItemPicSize;
end

function GET_WIKI_INTPROP_TXT(frame, wiki, propName, msgTxt, rankList, groupboxYPos)

	local cnt = GetWikiIntProp(wiki, propName);
	if cnt == 0 then
		return groupboxYPos;
	end

	local txt = msgTxt .. ' : ' .. cnt;

	local exinfoGroupBox = GET_CHILD(frame, 'exinfo', 'ui::CGroupBox');
	local killCountCtrl = exinfoGroupBox:CreateOrGetControl('richtext', propName, 15, groupboxYPos, 180, 20);
	tolua.cast(killCountCtrl, 'ui::CRichText');
	killCountCtrl:SetGravity(ui.CENTER_HORZ, ui.TOP);
	killCountCtrl:EnableResizeByText(1);
	killCountCtrl:SetTextFixWidth(1);
	killCountCtrl:SetLineMargin(-2);
	killCountCtrl:SetTextAlign("left", "top");
	killCountCtrl:SetText('{s18}{#050505}'.. txt);

	return groupboxYPos + killCountCtrl:GetHeight();
end

function GET_WIKI_SORT_PROP_TXT(frame, wiki, wikiCls, msg, nameHead, maxCnt, getFunc, groupboxYPos)

	local itemPicSize = 0;
	local itemTitleTextHeight = 0;

	local sortList = {};
	GET_WIKI_SORT_LIST(wiki, nameHead, maxCnt, sortList);

	if #sortList == 0 then
		return groupboxYPos;
	end

	local func = _G[getFunc];
	for i = 1, #sortList do
		local propValue = sortList[i]["Value"];
		local propCount = sortList[i]["Count"];
		groupboxYPos, itemTitleTextHeight, itemPicSize = func(frame, propValue, propCount, i, groupboxYPos, itemPicSize, itemTitleTextHeight, wikiCls);
	end

	groupboxYPos = groupboxYPos + itemPicSize + itemTitleTextHeight

	return groupboxYPos;
end

function GET_WIKI_TOPATK_TXT(frame, propValue, count, index, groupboxYPos, dropItemPicSize, dropItemTitleTextHeight)
	dropItemPicSize = 0;
	local cls = GetClassByType("Skill", propValue);
	if cls == nil then
		return groupboxYPos, dropItemTitleTextHeight, dropItemPicSize;
	end

	local ret = string.format("{nl}{img icon_%s 20 20} %s : %d", cls.Icon, cls.Name, count);

	local exinfoGroupBox = GET_CHILD(frame, 'exinfo', 'ui::CGroupBox');
	local killCountCtrl = exinfoGroupBox:CreateOrGetControl('richtext', 'TOPATK_'..index, 0, groupboxYPos, 180, 20);
	tolua.cast(killCountCtrl, 'ui::CRichText');
	killCountCtrl:EnableResizeByText(1);
	killCountCtrl:SetLineMargin(-2);
	killCountCtrl:SetTextAlign("left", "top");
	killCountCtrl:SetGravity(ui.CENTER_HORZ, ui.TOP);
	killCountCtrl:SetText('{s18}{#050505}'.. ret);

	--dropItemTitleTextHeight = dropItemTitleTextHeight + killCountCtrl:GetHeight();

	return groupboxYPos + killCountCtrl:GetHeight(), dropItemTitleTextHeight, dropItemPicSize;
end

function UPDATE_WIKIDETAIL_ACHIEVE_TOOLTIP(tooltipframe, achieveCls)
	local itemPicCtrl = GET_CHILD(tooltipframe, 'itempic', 'ui::CPicture');
	itemPicCtrl:SetEnableStretch(1);
	itemPicCtrl:SetImage(achieveCls.Icon);

	local fullname = achieveCls.Name;
	local itemNameCtrl = GET_CHILD(tooltipframe, 'title', 'ui::CRichText');
	itemNameCtrl:SetText('{@st45}'..fullname);

	local itemDescCtrl = GET_CHILD(tooltipframe, 'desc', 'ui::CRichText');
	itemDescCtrl:EnableResizeByText(0);
	itemDescCtrl:Resize(260, 20);
	itemDescCtrl:SetTextAlign("left", "top");
	itemDescCtrl:SetGravity(ui.CENTER_HORZ, ui.TOP);
	itemDescCtrl:SetText('{s20}{#050505}'..achieveCls.Desc);

	local ypos = itemDescCtrl:GetY() + itemDescCtrl:GetHeight();

	local exinfoGroupBox = WIKIDETAIL_TOOLTIP_GROUPBOX_INIT(tooltipframe);
	exinfoGroupBox:SetOffset(0, ypos);
	return ypos + 30;
end
