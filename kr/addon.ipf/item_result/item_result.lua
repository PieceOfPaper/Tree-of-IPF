function ITEM_RESULT_ON_INIT(addon, frame)
    addon:RegisterMsg('DRAW_ITEM_RESULT', 'ON_DRAW_ITEM_RESULT');
end

function GET_LAYOUT_GRAVITY_BY_STRING(string)
	local function _GET_GRAVITY_ENUM(gravityStr, isHorz)
		if gravityStr == 'left' then
			return ui.LEFT;
		elseif gravityStr == 'right' then
			return ui.RIGHT;
		elseif gravityStr == 'top' then
			return ui.TOP;
		elseif gravityStr == 'bottom' then
			return ui.BOTTOM;
		elseif gravityStr == 'center' then
			if isHorz == true then
				return ui.CENTER_HORZ;
			else
				return ui.CENTER_VERT;
			end
		else
			return nil;
		end
	end

	local layoutGravity = StringSplit(string, ' ');
	return _GET_GRAVITY_ENUM(layoutGravity[1]), _GET_GRAVITY_ENUM(layoutGravity[2]);
end

local function GET_ENCHANT_EFFECT_NAME(frame, itemName)
	local EFFECT_NAME = frame:GetUserConfig('EFFECT_NAME');
	local itemCls = GetClass('Item', itemName);
	if tonumber(itemCls.ItemGrade) == 3 then
		return EFFECT_NAME..'_puple';		
	elseif tonumber(itemCls.ItemGrade) == 4 then
		return EFFECT_NAME..'_red';
	elseif tonumber(itemCls.ItemGrade) == 5 then
		return EFFECT_NAME;
	end
	return 'None';
end

local function ADD_ITEM_RESULT_CTRL(frame, itemBgBox, xpos, itemClsName, cnt)
	local ITEM_PICTURE_SIZE = tonumber(frame:GetUserConfig('ITEM_PICTURE_SIZE'));
	local CTRLSET_WIDTH = tonumber(frame:GetUserConfig('CTRLSET_WIDTH'));
	local CTRLSET_HEIGHT = tonumber(frame:GetUserConfig('CTRLSET_HEIGHT'));
	local BG_PIC_SIZE = tonumber(frame:GetUserConfig('BG_PIC_SIZE'));	
	local TEXT_STYLE = frame:GetUserConfig('TEXT_STYLE');	

	local itemBox = itemBgBox:CreateControl('groupbox', 'BOX_'..itemClsName, xpos, 0, CTRLSET_WIDTH, CTRLSET_HEIGHT);
	AUTO_CAST(itemBox);
	itemBox:SetSkinName('None');

	local BG_PIC_MARGIN = frame:GetUserConfig('BG_PIC_MARGIN');
	local bgPicMargin = StringSplit(BG_PIC_MARGIN, ' ');
	local bgPic = itemBox:CreateControl('picture', 'bgPic', 0, 0, BG_PIC_SIZE, BG_PIC_SIZE);
	AUTO_CAST(bgPic);

	bgPic:SetImage(frame:GetUserConfig('BG_PIC_IMAGE'));
	local horzGravity, vertGravity = GET_LAYOUT_GRAVITY_BY_STRING(frame:GetUserConfig('BG_PIC_LAYOUT_GRAVITY'));
	bgPic:SetGravity(horzGravity, vertGravity);
	bgPic:SetMargin(bgPicMargin[1], bgPicMargin[2], bgPicMargin[3], bgPicMargin[4]);

	local itemCls = GetClass('Item', itemClsName);
	local itemPic = itemBox:CreateControl('picture', 'itemPic', 0, 0, ITEM_PICTURE_SIZE, ITEM_PICTURE_SIZE);
	local ITEM_PICTURE_MARGIN = frame:GetUserConfig('ITEM_PICTURE_MARGIN');
	local itemPicMargin = StringSplit(ITEM_PICTURE_MARGIN, ' ');
	AUTO_CAST(itemPic);
	itemPic:SetGravity(ui.CENTER_HORZ, ui.TOP);
	itemPic:SetImage(itemCls.Icon);
	horzGravity, vertGravity = GET_LAYOUT_GRAVITY_BY_STRING(frame:GetUserConfig('ITEM_PICTURE_LAYOUT_GRAVITY'));
	bgPic:SetGravity(horzGravity, vertGravity);
	itemPic:SetMargin(itemPicMargin[1], itemPicMargin[2], itemPicMargin[3], itemPicMargin[4]);
	itemPic:SetEnableStretch(1);

	local getText = itemBox:CreateControl('richtext', 'getText', 0, 0, ITEM_PICTURE_SIZE, CTRLSET_HEIGHT - ITEM_PICTURE_SIZE);
	AUTO_CAST(getText);
	getText:SetGravity(ui.CENTER_HORZ, ui.BOTTOM);
	getText:SetText(TEXT_STYLE..itemCls.Name..' x'..cnt..' '..ClMsg('Gain')..'!{/}');

	xpos = xpos + itemBox:GetWidth();
	return xpos, CTRLSET_HEIGHT, itemPic;
end

function ON_DRAW_ITEM_RESULT(frame, msg, itemInfoStr, argNum)	
	local itemBgBox = GET_CHILD_RECURSIVELY(frame, 'itemBgBox');
	itemBgBox:RemoveAllChild();

	local xpos = 0;
	local ypos = 0;
	local itemInfos = StringSplit(itemInfoStr, '@');
	local EFFECT_SIZE = tonumber(frame:GetUserConfig('EFFECT_SIZE'));
	for i = 1, #itemInfos do
		local _itemInfoStr = itemInfos[i];
		local _itemInfo = StringSplit(_itemInfoStr, '#');
		local itemClsName = _itemInfo[1];
		local cnt = _itemInfo[2];

		xpos, ypos, itemPic = ADD_ITEM_RESULT_CTRL(frame, itemBgBox, xpos, itemClsName, cnt);
		local effectName = GET_ENCHANT_EFFECT_NAME(frame, itemClsName);
		itemPic:StopUIEffect('ON_DRAW_ITEM_RESULT', true, 0.5);
		itemPic:PlayUIEffect(effectName, EFFECT_SIZE, 'ON_DRAW_ITEM_RESULT');		
	end
	itemBgBox:Resize(xpos, ypos);
	frame:ShowWindow(1);
end