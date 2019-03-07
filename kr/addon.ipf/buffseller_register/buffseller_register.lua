function BUFFSELLER_REGISTER_ON_INIT(addon, frame)
end

local function _BUFFSELLER_INIT_USER_PRICE(ctrlSet, autoSellerInfo, buffID)
	if autoSellerInfo ~= nil then
		buffID = autoSellerInfo.ClassID;
	end

	local priceinput = GET_CHILD(ctrlSet, 'priceinput');
	if priceinput == nil then
		return false;
	end

	PROCESS_USER_SHOP_PRICE('Pardoner_SpellShop', priceinput, buffID);

	if autoSellerInfo ~= nil then
		autoSellerInfo.price = tonumber(priceinput:GetText());
	end
	return true;
end

function SET_BUFFSELLER_CTRLSET(ctrlset, buffName, lv, sklName, price, remainCount)
	local buffCls = GetClass('Buff', buffName);
	local spendItemName, spendItemCnt = GetBuffSellerInfoByBuffName(buffName);
	ctrlset:SetUserValue('BUFF_CLASS_NAME', buffName);

	local skillname = GET_CHILD(ctrlset, 'skillname');		
	skillname:SetTextByKey('value', buffCls.Name);

	local skill_slot = GET_CHILD(ctrlset, 'skill_slot');	
	local skl_icon = imcSlot:SetImage(skill_slot, GET_BUFF_ICON_NAME(buffCls));
	skl_icon:SetTooltipType('skill_dummy');
	skl_icon:SetTooltipStrArg(sklName);
	skl_icon:SetTooltipNumArg(buffCls.ClassID);	
	skl_icon:SetTooltipIESID(tostring(lv)); -- numarg2로 쓰고 싶어서 씀. iesid로 사용안함

	local skilllevel = GET_CHILD(ctrlset, 'skilllevel');
	skilllevel:SetTextByKey('value', lv);

	local mat_item = GET_CHILD(ctrlset, 'mat_item');
	if mat_item ~= nil then
		local spendItemCls = GetClass('Item', spendItemName);
		imcSlot:SetImage(mat_item, spendItemCls.Icon);
		local icon = mat_item:GetIcon();
		if icon == nil then
			icon = CreateIcon(mat_item);
		end
		SET_ITEM_TOOLTIP_BY_NAME(icon, spendItemName);
	end

	if _BUFFSELLER_INIT_USER_PRICE(ctrlset, nil, buffCls.ClassID) == false then -- 손님
		local remaincount = GET_CHILD(ctrlset, 'remaincount');
		remaincount:SetTextByKey('value', remainCount);

		local priceCtrl = GET_CHILD(ctrlset, 'price');
		priceCtrl:SetTextByKey('value', price);
	end
end

local function _CREATE_SELL_LIST(frame, selllist)
	local sklName = 'Pardoner_SpellShop';
	local buffSellSkl = session.GetSkillByName(sklName);
	if buffSellSkl == nil then
		return;
	end
	local sklObj = GetIES(buffSellSkl:GetObject());

	local buffList = GetBuffSellerInfoList();
	for i = 1, #buffList do
		local ctrlset = selllist:CreateControlSet("buffseller_reg", "CTRLSET_NEW_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		SET_BUFFSELLER_CTRLSET(ctrlset, buffList[i], sklObj.Level, sklName);
	end
end

function BUFFSELLER_UPDATE_LIST(frame)
	local gbox = frame:GetChild("gbox");
	local selllist = gbox:GetChild("selllist");
	selllist:RemoveAllChild();

	local groupName = frame:GetUserValue("GroupName");
	local customScp = frame:GetUserValue("CUSTOM_SKILL");
	if customScp ~= "None" then
		session.autoSeller.ClearGroup(groupName);
		local skillType = frame:GetUserIValue("SKILL_TYPE");
		local info = session.autoSeller.CreateToGroup(groupName);
		info.classID = skillType;
		info.price = 0;
	end
	
	if customScp == "None" then
		_CREATE_SELL_LIST(frame, selllist);
	end

	GBOX_AUTO_ALIGN(selllist, 10, 10, 10, true, false);
end

function BUFFSELLER_REG_EXEC(frame)
	frame = frame:GetTopParentFrame();
	local groupName = frame:GetUserValue("GroupName");
	local serverGroupName = frame:GetUserValue("ServerGroupName");

	local gbox = frame:GetChild("gbox");
	local inputname = gbox:GetChild("inputname");
	if string.len( inputname:GetText() ) == 0 then
		ui.MsgBox(ClMsg("InputTitlePlease"));
		return;
	end
	
	local serverGroupName = frame:GetUserValue("ServerGroupName");
	if "" == inputname:GetText() then
		return;
	end
	
	if groupName == "PersonalShop" then
		if true == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
			return;
		end
	end

	session.autoSeller.ClearGroup(groupName);
	local selllist = GET_CHILD_RECURSIVELY(frame, 'selllist');
	local childCount = selllist:GetChildCount();
	local pc = GetMyPCObject();
	local sellCount = 0;
	for i = 0, childCount - 1 do
		local child = selllist:GetChildByIndex(i);
		if string.find(child:GetName(), 'CTRLSET_NEW_') ~= nil then
			local selectCheck = GET_CHILD(child, 'selectCheck');
			local buffClsName = child:GetUserValue('BUFF_CLASS_NAME');
			if selectCheck:IsChecked() == 1 then
				local spendItemName, spendItemCnt = GetBuffSellerInfoByBuffName(buffClsName);
				local myItemCount = GetInvItemCount(pc, spendItemName);
				if myItemCount < spendItemCnt then
					return;
				end

				local priceinput = GET_CHILD(child, 'priceinput');
				local buffCls = GetClass('Buff', buffClsName);
				local info = session.autoSeller.CreateToGroup(groupName);    
				info.classID = buffCls.ClassID;
				info.price = tonumber(priceinput:GetText());
				sellCount = sellCount + 1;
			end
		end
	end

	local pc = GetMyPCObject();
	local x, y, z = GetPos(pc);
	if 0 == IsFarFromNPC(pc, x, y, z, 50) then
		ui.SysMsg(ClMsg("TooNearFromNPC"));	
		return 0;
	end

	if serverGroupName == 'Buff' then -- case: pardoner_spell shop		
		local skl = session.GetSkillByName('Pardoner_SpellShop');
		if skl == nil then
			return;
		end

		if sellCount > GET_BUFF_SELLER_LIMIT_COUNT(GetMyPCObject(), GetIES(skl:GetObject())) then
			ui.SysMsg(ScpArgMsg('BuffSellCountLimit', 'COUNT', GET_BUFF_SELLER_LIMIT_COUNT()));
			session.autoSeller.ClearGroup(groupName);
			return;
		end
		
		session.autoSeller.RequestRegister(groupName, serverGroupName, inputname:GetText(), 'Pardoner_SpellShop');
	else
		session.autoSeller.RequestRegister(groupName, serverGroupName, inputname:GetText(), nil);
	end
end

function BUFFSELLER_REG_CANCEL(frame)
	frame = frame:GetTopParentFrame();
	frame:ShowWindow(0);
end

function BUFFSELLER_REG_OPEN(frame)
	local customSkill = frame:GetUserValue("CUSTOM_SKILL");
	if customSkill == "None" then
		frame:SetUserValue("GroupName", "BuffRegister");
		frame:SetUserValue("ServerGroupName", "Buff");
	else
		frame:SetUserValue("GroupName", customSkill);
		frame:SetUserValue("ServerGroupName", customSkill);
	end
	BUFFSELLER_UPDATE_LIST(frame);
end

function BUFFSELLER_INIT(frame)
	frame:SetUserValue("CUSTOM_SKILL", "None");
end


function BUFFSELLER_SET_CUSTOM_SKILL_TYPE(frame, clsName, skillType)
	frame:SetUserValue("CUSTOM_SKILL", clsName);
	if skillType ~= nil then
		frame:SetUserValue("SKILL_TYPE", skillType);
	end
end

function BUFFSELLER_CHECK_FOR_SELL(ctrlset, ctrl)
	if ctrl:IsChecked() == 1 then
		local pc = GetMyPCObject();
		local buffClsName = ctrlset:GetUserValue('BUFF_CLASS_NAME');
		local spendItemName, spendItemCnt = GetBuffSellerInfoByBuffName(buffClsName);
		local myItemCount = GetInvItemCount(pc, spendItemName);
		if myItemCount < spendItemCnt then
			ui.SysMsg(ClMsg('NotEnoughMaterial'));
			ctrl:SetCheck(0);
		end
	end
end

function UPDATE_SKILL_DUMMY_TOOLTIP(frame, strarg, numarg1, numarg2, userData, obj)
	local skl = session.GetSkillByName(strarg);
	local sklObj;
	local sklLv = 1;
	if skl == nil or skl:GetObject() == nil then
		sklObj = GetClass('Skill', strarg);
		sklLv = tonumber(numarg2);
	else
		sklObj = GetIES(skl:GetObject());
		sklLv = sklObj.Level;
	end
	
	local buffCls = GetClassByType('Buff', numarg1);
	local spendItemName, spendItemCount, captionTimeScp, captionList, captionRatioScpList = GetBuffSellerInfoByBuffName(buffCls.ClassName);

	DESTROY_CHILD_BYNAME(frame:GetChild('skill_desc'), 'SKILL_CAPTION_');

	local skill_desc = GET_CHILD(frame, "skill_desc");
	SET_SKILL_TOOLTIP_ICON_AND_NAME(skill_desc, buffCls, false);	
	SET_SKILL_TOOLTIP_CAPTION(skill_desc, captionList[1], captionList[1]);
    
	local icon = GET_CHILD(skill_desc, 'icon');
	local y = icon:GetY() + icon:GetHeight() + 20;

	local function _CREATE_DUMMY_SKILL_INFO(sklObj, skill_desc, y, lv, isNext, captionTime, captionList, captionRatioList)
		if isNext == true then
			lv = lv + 1;
		end

		local lvDescCtrlSet = skill_desc:CreateOrGetControlSet("skilllvdesc", "SKILL_CAPTION_"..tostring(lv), 0, y);
		lvDescCtrlSet = AUTO_CAST(lvDescCtrlSet);
		local LEVEL_FONTNAME = lvDescCtrlSet:GetUserConfig('LEVEL_FONTNAME');
		local LEVEL_NEXTLV_FONTNAME = lvDescCtrlSet:GetUserConfig('LEVEL_NEXTLV_FONTNAME');			
		local SKIN_NEXTLV_NAME = lvDescCtrlSet:GetUserConfig('SKIN_NEXTLV_NAME');
		local DESC_FONTNAME = lvDescCtrlSet:GetUserConfig('DESC_FONTNAME');
		local DESC_NEXTLV_FONTNAME = lvDescCtrlSet:GetUserConfig('DESC_NEXTLV_FONTNAME');

		-- off
		local cooltimeimg = GET_CHILD(lvDescCtrlSet, 'cooltimeimg');
		local pad_text = GET_CHILD(lvDescCtrlSet, 'pad_text');
		cooltimeimg:ShowWindow(0);
		pad_text:ShowWindow(0);

		-- level
		local descFont = '';
		local level = GET_CHILD(lvDescCtrlSet, 'level');
		if isNext == true then
			level:SetText(LEVEL_NEXTLV_FONTNAME..'Lv.'..tostring(lv));
			lvDescCtrlSet:SetSkinName(SKIN_NEXTLV_NAME);
			descFont = DESC_NEXTLV_FONTNAME;
		else
			level:SetText(LEVEL_FONTNAME..'Lv.'..tostring(lv));
			descFont = DESC_FONTNAME;
		end

		-- caption
		local function _MAKE_CAPTION_BY_DUMMY(skl, caption, captionTimeScp, captionRatioList)
			local retStr = '';
			local _caption = dic.getTranslatedStr(caption)
			while string.len(_caption) > 0 do
				local tagIdx = string.find(_caption, '#{');
				local tagEndIdx = string.find(_caption, '}#');
				if tagIdx == nil and tagEndIdx == nil then
					retStr = retStr.._caption;
					_caption = '';
				else
					retStr = retStr..string.sub(_caption, 0, tagIdx - 1);
					local captionProp = string.sub(_caption, tagIdx + 2, tagEndIdx -1);
					_caption = string.sub(_caption, tagEndIdx + 2);

					if string.find(captionProp, 'CaptionRatio') ~= nil then
						local captionRatioIndex = 1;
						if captionProp ~= 'CaptionRatio' then
							captionRatioIndex = tonumber(string.sub(captionProp, string.len('CaptionRatio') + 1));							
						end
						local captionRatioScp = captionRatioList[captionRatioIndex];
						local GetCaptionRatioFunc = _G[captionRatioScp];						
						local ratioValue = GetCaptionRatioFunc(skl);
						retStr = retStr..string.format('%.1f', ratioValue);
					else -- caption time
						local GetCaptionTimeFunc = _G[captionTimeScp];
						local timeValue = GetCaptionTimeFunc(skl);
						retStr = retStr..timeValue;
					end
				end
			end

			return retStr;
		end
		local cloneSklObj = CloneIES_UseCP(sklObj);
		cloneSklObj.Level = lv;
		SetExProp(cloneSklObj, 'BUFF_SELLER_OBJ', 1);
		local captionStr = _MAKE_CAPTION_BY_DUMMY(cloneSklObj, captionList[2], captionTime, captionRatioList);
		local desc = GET_CHILD(lvDescCtrlSet, 'desc');
		desc:SetText(descFont..captionStr);
		lvDescCtrlSet:Resize(lvDescCtrlSet:GetWidth(), desc:GetY() + desc:GetHeight() + 15);

		return y + lvDescCtrlSet:GetHeight();
	end

	y = _CREATE_DUMMY_SKILL_INFO(sklObj, skill_desc, y, sklLv, false, captionTimeScp, captionList, captionRatioScpList);
	y = _CREATE_DUMMY_SKILL_INFO(sklObj, skill_desc, y, sklLv, true, captionTimeScp, captionList, captionRatioScpList);

	skill_desc:Resize(frame:GetWidth(), y);
	frame:Resize(frame:GetWidth(), skill_desc:GetHeight());	
end