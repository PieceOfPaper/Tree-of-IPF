function BLACKMARKET_ON_INIT(addon, frame)

	
end

function BLACKMARKET_ADD_REQITEM_TEXT(txt, reqCls, propName)
	local propValue = reqCls[propName];
	if propValue == "None" then
		return txt;
	end

	local cls = GetClass("Item", propValue);
	if txt == "" then
		txt = txt .. " " .. string.format("{img %s 24 24}", cls.Icon) .. " " .. cls.Name;
	else
		txt = txt .. "{nl}" .. string.format("{img %s 24 24}", cls.Icon) .. " " .. cls.Name;
	end
	return txt;
end

function BLACKMARKET_SHOW_DETAIL(bg, ctrl)
	
	local beforeDetail = bg:GetChild("DETAIL");
	
	local className = ctrl:GetUserValue("ClassName");
	if beforeDetail ~= nil and beforeDetail:GetUserValue("ClassName") == className then
		bg:RemoveChild("DETAIL");
	else
		bg:RemoveChild("DETAIL");
		local ctrlSet = bg:CreateControlSet("blackmarket_detail", "DETAIL", ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		ctrlSet:SetUserValue("ClassName", className);

		local childIndex = bg:GetChildIndex(ctrl:GetName());
		bg:MoveChildBefore(ctrlSet, childIndex + 1);

		local cls = GetClass("Request", className);
		local mapname = ctrlSet:GetChild("mapname");
		local mapName = cls.StartMap;
		local mapCls = GetClass("Map", mapName);
		
		world.PreloadMinimap(mapName);
		local pic_gbox = ctrlSet:GetChild("pic_gbox");
		local pic = GET_CHILD(pic_gbox, "map", "ui::CPicture");
		pic:SetImage(mapName .. "_fog");
		
		UPDATE_MAP_BY_NAME(pic_gbox, mapName, pic);
		MAKE_MAP_AREA_INFO(pic_gbox, mapName, "{s15}")
		
		mapname:SetTextByKey("value", ClMsg("Location") .. " : " .. mapCls.Name);
		local detailtext = ctrlSet:GetChild("detailtext");
		local rank = ctrlSet:GetChild("rank");
		rank:SetTextByKey("value", ClMsg("Ranking") .. " : " .. cls.Rank);
		local txt = "{@st42}" .. ClMsg("DetailInfo") .. " : " .. cls.DetailInfo;
		detailtext:SetText(txt);
	end	
	
	bg:UpdateData();
	GBOX_AUTO_ALIGN(bg, 20, 3, 10, true, false);
	bg:GetTopParentFrame():Invalidate();

end

function BLACKMARKET_UPDATE(frame)

	local bg = frame:GetChild("bg");
	bg:RemoveAllChild();

	local req_list, req_cnt = GetClassList("Request")
    for i = 0, req_cnt - 1 do
        local reqCls = GetClassByIndexFromList(req_list, i);
		local ctrlSet = bg:CreateControlSet("blackmarketcontrol", reqCls.ClassName, ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		ctrlSet:SetUserValue("ClassName", reqCls.ClassName);
		ctrlSet:SetEventScript(ui.LBUTTONUP, "BLACKMARKET_SHOW_DETAIL");
		local name = ctrlSet:GetChild("name");
		local desc = ctrlSet:GetChild("desc");
		name:SetTextByKey("value", reqCls.Name);
		
		local sumDesc = reqCls.SummaryInfo;
		sumDesc = sumDesc.. "{nl}".. ClMsg("Deposit") .. " : ";
		local reqItemText = "";
		if reqCls.ReqSilver > 0 then 
			reqItemText = reqItemText .. " " .. GET_MONEY_IMG(24) .. " " .. reqCls.ReqSilver;
		end

		for j = 1 , 2 do
			reqItemText = BLACKMARKET_ADD_REQITEM_TEXT(reqItemText, reqCls, "ReqItem" .. j);
		end

		sumDesc = sumDesc .. reqItemText;
		desc:SetTextByKey("value", sumDesc);
		local y = GET_CHILD_MAX_Y(ctrlSet);
		ctrlSet:Resize(ctrlSet:GetWidth(), y + 10);
        
    end
	
	GBOX_AUTO_ALIGN(bg, 20, 3, 10, true, false);
	frame:Invalidate();
end


