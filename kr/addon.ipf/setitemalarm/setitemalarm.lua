SETITEM_TITLE_STYLE = "{@st41}";
SETITEM_LIST_STYLE = "{@st41}";
SETITEM_ICON_START_Y = 80;

function SETITEMALARM_ON_INIT(addon, frame)
	addon:RegisterMsg('INV_ITEM_ADD', 'SETITEM_INV_ITEM_ADD');
end

function SETITEM_INV_ITEM_ADD(frame, msg, addType, invIndex)

	if addType == "UNEQUIP" then
		return;
	end

	local invitem = session.GetInvItem(invIndex);
	SETITEM_CHECK(frame, invitem.type);

end

function SETITEM_CHECK(frame, itemType)

	local cnt = GET_TOTAL_ITEM_CNT(itemType);
	if cnt > 1 then
		return;
	end

	local set = GET_SET_INFO(itemType);
	if set == nil then
		return;
	end
		
	if IsExistItemInAdventureBook(nil, itemType) == 'NO' then		
		UPDATE_SETITEMALARM(frame, set, itemType);			
	end
end

function GET_SET_INFO(itemType)

	local itemProp = geItemTable.GetProp(itemType);
	local set = itemProp.setInfo;
	return set;

end

SETITEM_SLOT_SIZE = 42;


function UPDATE_SETITEMALARM(frame, set, getItemType)

	HIDE_CHILD_BYNAME(frame, "SELECT_");
	HIDE_CHILD_BYNAME(frame, "TEXT_");

	local ctrlLength = SETITEM_SLOT_SIZE + 15;

	local x = 10;
	local y = SETITEM_ICON_START_Y;

	local cnt =	set:GetItemCount();
	for i = 0, cnt -1 do
		local clsName = set:GetItemClassName(i);
		SETITEM_CRE_CTRL_SET(frame, x, y, clsName, getItemType, i);
		y = y + ctrlLength;
	end

	UPDATE_SETITEM_TITLE(frame, set);
	--UPDATE_SETITEM_DESC(frame, set);

	frame:Resize(frame:GetWidth(), y + 30);
	frame:ShowWindow(1);
	frame:SetDuration(3.0);

end

function UPDATE_SETITEM_TITLE(frame, set)

	local title = frame:GetChild("title");
	local text = GET_ITEM_SET_TITLE_TEXT(set);
	title:SetText("{#FFFFFF}{s16}".. text ..ScpArgMsg("Auto_SeupDeug"));

end

function UPDATE_SETITEM_DESC(frame, set)

	local desc = frame:GetChild("desc");
	local text = SETITEM_LIST_STYLE .. GET_ITEM_SET_LIST_TEXT(set, 0) .. "{/}";

	--text = text .. SETITEM_EFFECT_STYLE .. "{nl}{nl}" .. GET_ITEM_SET_EFFECT_TEXT(set, 1) .. "{/}";

	desc:SetText(text);

end

function SETITEM_CRE_CTRL_SET(box, x, y, clsName, getItemType, index)

	local cls = GetClass("Item", clsName);
	local haveItem = 0;
	if GET_TOTAL_ITEM_CNT(cls.ClassID) > 0 then
		haveItem = 1;
	end

	local slot = box:CreateOrGetControl('slot', "SELECT_" .. index , x+20, y, SETITEM_SLOT_SIZE, SETITEM_SLOT_SIZE);
	local text = box:CreateOrGetControl('richtext', "TEXT_" .. index , x + SETITEM_SLOT_SIZE + 30, y + SETITEM_SLOT_SIZE / 2 - 10, 200, 24);
	tolua.cast(slot, "ui::CSlot");
	slot:ShowWindow(1);
	text:ShowWindow(1);


	local imgName = GET_ICON_BY_NAME(cls.ClassName);
	local icon = SET_SLOT_ICON(slot, imgName);

	MAKE_HAVE_ITEM_TOOLTIP(icon, cls.ClassID);

	slot:ReleaseBlink();
	if cls.ClassID == getItemType then
		slot:SetBlink(600000, 0.5, "FFFFFF00");
	elseif haveItem == 0 then
		icon:SetColorTone("FF555555");
	else
		icon:SetColorTone("FFFFFFFF");
	end

	SETITEM_SET_ITEM_TEXT(text, cls);
end

function SETITEM_SET_ITEM_TEXT(ctrl, cls)
	local itemTxt = "";
	if GET_TOTAL_ITEM_CNT(cls.ClassID) > 0 then
		itemTxt = string.format("{b}{#FFCC66}%s (1/1)", cls.Name);
	else
		itemTxt = string.format("{b}{#555555}%s (0/1)", cls.Name);
	end

	ctrl:SetText(itemTxt);
end


function SET_SLOT_ICON(slot, imgName)

	if slot == nil then
		return nil;
	end

	if slot:GetIcon() == nil then
		CreateIcon(slot);
	end

	local icon = slot:GetIcon();
	icon:SetImage(imgName);
	return icon;

end

