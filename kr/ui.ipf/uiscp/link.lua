--- link.lua

function GET_ITEM_FULLNAME_BY_TAG_INFO(props, clsID)

	local newobj = CreateIESByID("Item", clsID);
	if props ~= 'nullval' then
		local propInfo = StringSplit(props, '#');
		SetModifiedPropertiesString(newobj, propInfo[1]);
	end

	if IS_SKILL_SCROLL_ITEM(newobj) == 1 then
		local skillType, level = GetSkillScrollProperty(props);
		newobj.SkillType = skillType
		newobj.SkillLevel = level
	end

	local ret = GET_FULL_NAME(newobj);
	DestroyIES(newobj);
	return ret;

end

function SLI(props, clsID)
	local itemFrame = ui.GetFrame("wholeitem_link");
	if itemFrame == nil then
		itemFrame = ui.GetNewToolTip("wholeitem_link", "wholeitem_link");
	else
		CLOSE_LINK_TOOLTIP(itemFrame)
	end

	local skillFrame = ui.GetFrame("skill_link");
	if skillFrame == nil then
		skillFrame = ui.GetNewToolTip("skill", "skill_link");
	else
		CLOSE_LINK_TOOLTIP(skillFrame)
	end

	tolua.cast(itemFrame, 'ui::CTooltipFrame');
	tolua.cast(skillFrame, 'ui::CTooltipFrame');

	local currentFrame = nil;

	local baseCls = GetClassByType('Item', clsID);
	if IS_SKILL_SCROLL_ITEM(baseCls) == 0 then -- 스킬 스크롤이 아니면
		if props == 'nullval' then
			props = nil;
		end
		local linkInfo = session.link.CreateOrGetGCLinkObject(clsID, props);
		itemFrame:SetTooltipType('wholeitem')
		local newobj = GetIES(linkInfo:GetObject());
		local pobj = tolua.cast(newobj, "imcIES::IObject");		
		itemFrame:SetTooltipIESID(GetIESID(newobj));
		itemFrame:SetTooltipStrArg('link');
		
		currentFrame = itemFrame;
	else
		local skillType, level = GetSkillScrollProperty(props);
		skillFrame:SetTooltipType('skill');
		skillFrame:SetTooltipArg("Level", skillType, level);
		currentFrame = skillFrame;
	end

	currentFrame:RefreshTooltip();
	currentFrame:ShowWindow(1);

	ui.ToCenter(currentFrame);
end

function SLM(infoString)
	local argStrings = StringSplit(infoString, "#");
	local mapID = argStrings[1];
	local x = argStrings[2];
	local z = argStrings[3];

	local mapCls = GetClassByType("Map", mapID);
	SCR_SHOW_LOCAL_MAP(mapCls.ClassName, true, x, z);
end

function CLOSE_LINK_TOOLTIP(frame)
	frame:ShowWindow(0)
end

function GET_ITEM_LINK_COLOR(rank)
	return "{#BF6DC6}"; 
end

function SET_LINK_TEXT(linkstr)
	
	local chatFrame = GET_CHATFRAME();
	local edit = chatFrame:GetChild('mainchat');

	local editCtrl 	= tolua.cast(edit, "ui::CEditControl");
	local curLinkCount = editCtrl:GetLinkCount();
	if curLinkCount >= 3 then
		ui.MsgBox(ScpArgMsg("Auto_LingKeuui_KaeSuNeun_3KaeLeul_Neomeul_Su_eopSeupNiDa."));
		return;
	end

	local left = editCtrl:GetCursurLeftText();
	local right = editCtrl:GetCursurRightText();
	local resultText = string.format("%s%s%s", left, linkstr, right);
	SET_CHAT_TEXT(resultText);
end

function LINK_ITEM_TEXT(invitem)

	local chatFrame = GET_CHATFRAME();
	local edit = chatFrame:GetChild('mainchat');
	local imgheight = edit:GetOriginalHeight();

	local itemobj = GetIES(invitem:GetObject());

	local imgtag =  "";
	local imageName = GET_ITEM_ICON_IMAGE(itemobj);
	
	local imgtag = string.format("{img %s %d %d}", imageName, imgheight, imgheight);

	local properties = "";

	local itemName = GET_FULL_NAME(itemobj);

	if IS_SKILL_SCROLL_ITEM(itemobj) == 1 then		
		local sklCls = GetClassByType("Skill", itemobj.SkillType)
		itemName = itemName .. "(" .. sklCls.Name ..")";
		properties = GetSkillItemProperiesString(itemobj);
	else
		properties = GET_MODIFIED_PROPERTIES_STRING(itemobj);
	end
	
	if properties == "" then
		properties = 'nullval'
	end
	local itemrank_num = itemobj.ItemStar

	local linkstr = string.format("{a SLI %s %d}{#0000FF}%s%s{/}{/}{/}", properties, itemobj.ClassID, imgtag, itemName);
	SET_LINK_TEXT(linkstr);

end

function MAKE_LINK_MAP_TEXT(mapName, x, z)

	local mapprop = geMapTable.GetMapProp(mapName);
	return string.format("{a SLM %d#%d#%d}{#0000FF}{img link_map 24 24}%s[%d,%d]{/}{/}{/}", mapprop.type, x, z, mapprop:GetName(), x, z);	

end

function MAKE_LINK_MAP_TEXT_NO_POS(mapName, x, z)

	local mapprop = geMapTable.GetMapProp(mapName);
	return string.format("{a SLM %d#%d#%d}{#0000FF}{img link_map 24 24}%s{/}{/}{/}", mapprop.type, x, z, mapprop:GetName());	

end

function MAKE_LINK_MAP_TEXT_NO_POS_NO_FONT(mapName, x, z)

	local mapprop = geMapTable.GetMapProp(mapName);
	return string.format("{a SLM %d#%d#%d}{img link_map 24 24}%s{/}{/}{/}", mapprop.type, x, z, mapprop:GetName());	

end


function LINK_MAP_POS(mapName, x, z)

	local linkstr = MAKE_LINK_MAP_TEXT(mapName, x, z);
	SET_LINK_TEXT(linkstr);

end

function SLC(linktext)

	local sstart, send = string.find(linktext,"@@@")

	if sstart == nil or send == nil then
		return;
	end

	local aid = string.sub(linktext,0,sstart -1)
	local roomid = string.sub(linktext,send + 1)

	ui.GroupChatEnterRoomByTag(roomid,aid)

end


function SLP(partyID)
	local pcparty = session.party.GetPartyInfo();
	if pcparty ~= nil then
		if pcparty.info ~= nil then 
			if pcparty.info:GetPartyID() == partyID then
				ui.SysMsg(ClMsg("HadMyPartySame"));
			else
				ui.SysMsg(ClMsg("HadMyPartyOther"));
			end
		end
		return;
	end

	party.JoinPartyByLink(PARTY_NORMAL, partyID);

end



