-- collection_magic.lua

function COLLECTION_MAGIC_OPEN(collection_frame)		
	if collection_frame == nil then
		return
	end

	local btn_viewAllAddStatus = GET_CHILD_RECURSIVELY(collection_frame, "viewAllAddStatus", "ui::CButton");
	if btn_viewAllAddStatus == nil then
		return
	end

	local x = collection_frame:GetGlobalX() + collection_frame:GetWidth() - 5;
	local y = btn_viewAllAddStatus:GetGlobalY();
	local frame = ui.GetFrame("collection_magic");	

	-- frame이 현재 보여지는 상태면 닫는다.
	if frame:IsVisible() == 1 then
		COLLECTION_MAGIC_CLOSE()
	else 
		frame:SetOffset(x,y);
		frame:ShowWindow(1);
	end
end

function COLLECTION_MAGIC_CLOSE()
	local frame = ui.GetFrame("collection_magic");	
	frame:ShowWindow(0);
end


-- 리스트를 받고 리치텍스트에 입력한다.
function SET_COLLECTION_MAIGC_LIST(collection_frame, collectionCompleteMagicList, completeCount)
	local frame = ui.GetFrame("collection_magic");
	if frame == nil or collection_frame == nil then
		return
	end

	-- 넘어온 리스트로부터 sort할 리스트로 만든다.
	local index = 1;
	local list = {};
	for i,v in pairs(collectionCompleteMagicList) do
		list[index] = { name = i, value = v };
		index = index +1;
	end

	-- sort
	table.sort(list, SORT_MAGIC_PROP_NAME);

	-- make value
	local textlist = "";
	for i,v in pairs(list) do
		if i > 1 then
			textlist = textlist .. "{nl}";
		end
		textlist = textlist .. v.name .. " +" .. tostring(v.value);
	end
	
	local magictext = GET_CHILD(frame, "richtext_magic_list", "ui::CRichText");
	local magictitle = GET_CHILD(frame, "richtext_title", "ui::CRichText");
	if magictext == nil or magictitle == nil then
		return 
	end
	magictext:SetTextByKey("value", textlist);
	magictitle:SetTextByKey("value", completeCount);

	
	local height = frame:GetUserConfig("TITLE_MARGIN_Y") * 2  + magictitle:GetHeight(); -- title height
	height = height +frame:GetUserConfig("BODY_MARGIN_Y") * 2 + magictext:GetHeight();
	
	local gbox_bg = GET_CHILD(frame, "bg", "ui::CGroupBox");
	if gbox_bg ~= nil then
		gbox_bg:Resize(gbox_bg:GetWidth(), height);
	end
	
	frame:Resize(frame:GetWidth(), height);
end


function SORT_MAGIC_PROP_NAME(a,b)

	return a.name < b.name;
end