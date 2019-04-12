--- link.lua


function GET_ITEM_FULLNAME_BY_TAG_INFO(props, clsID)

	local newobj = CreateIESByID("Item", clsID);
	if props ~= 'nullval' then
		SetModifiedProperiesString(newobj, props);
	end

	local ret = GET_FULL_NAME(newobj);
	DestroyIES(newobj);
	return ret;

end

function SLI(props, clsID)

	local tooltipType = GET_ITEM_TOOLTIP_TYPE(clsID);

	local tframe = nil ;
	
	if 910001 ~= clsID then -- 스킬 스크롤이 아니면
		tframe = ui.CreateToolTip('wholeitem_link', "item_link");
		local newobj = CreateIESByID("Item", clsID);
		if props ~= 'nullval' then
			SetModifiedProperiesString(newobj, props);
		end

		tframe:SetTooltipType('wholeitem')
		local pobj = tolua.cast(newobj, "imcIES::IObject");
		tframe:SetToolTipObject(pobj);
	else
		local skillType, level = GetSkillScrollProperty(props);
		tframe = ui.CreateToolTip('skill_link', "skil_link");
		tframe:SetTooltipType('skill');
		tframe:SetTooltipArg("Level", skillType, level);
	end
	tframe:RefreshTooltip();
	tframe:ShowWindow(1);

	ui.ToCenter(tframe);

end

function SLM(infoString)
	local argStrings = StringSplit(infoString, "#");
	local mapID = argStrings[1];
	local x = argStrings[2];
	local z = argStrings[3];

	local mapCls = GetClassByType("Map", mapID);
	SCR_SHOW_LOCAL_MAP(mapCls.ClassName, true, x, z);
end

function CLOSE_LINK_TOOLTIP(frame, slot)
	
	frame:ShowWindow(0)
end

function GET_ITEM_LINK_COLOR(rank)

	--[[local ret = GET_ITEM_FONT_COLOR(rank); -- 링크 컬러 통일
	if ret == "{#FFFFFF}" then
		return "{#FFCC00}";
	end]]--

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
	local imgheight = edit:GetHeight();

	local itemobj = GetIES(invitem:GetObject());

	local imgtag =  "";
	local imageName = GET_ITEM_ICON_IMAGE(itemobj);
	
	local imgtag = string.format("{img %s %d %d}", imageName, imgheight, imgheight);

	local properties = "";

	local itemName = GET_FULL_NAME(itemobj);

	if itemobj.ClassName == 'Scroll_SkillItem' then		
		local sklCls = GetClassByType("Skill", itemobj.SkillType)
		itemName = itemName .. "(" .. sklCls.Name ..")";
		properties = GetSkillItemProperiesString(itemobj);
	else
		properties = GetModifiedProperiesString(itemobj);
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

function SLP(partyID)
	local pcparty = session.party.GetPartyInfo();
	if pcparty ~= nil then
		ui.SysMsg( ClMsg("HadMyParty") );
		return;
	end

	party.JoinPartyByLink(PARTY_NORMAL, partyID);

end



