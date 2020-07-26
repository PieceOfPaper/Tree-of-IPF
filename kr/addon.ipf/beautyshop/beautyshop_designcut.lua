-- beautyshop_designcut.lua
local DesigncutItemList = nil
local DesigncutSubItemList = nil

function DESIGNCUTSHOP_OPEN()
    local topFrame = ui.GetFrame("beautyshop");
	if topFrame == nil then
		return;
	end
	
	local gender = BEAUTYSHOP_GET_GENDER();

	local shopName = topFrame:GetUserConfig("DesigncutShopName_male");
	if gender == 2 then
		shopName = topFrame:GetUserConfig("DesigncutShopName_female");
	end

	BEAUTYSHOP_SET_TITLE(shopName);
	BEAUTYSHOP_DESIGNCUTSHOP_INIT_INFOTEXT(topFrame);
	topFrame:ShowWindow(1);

	DESIGNCUTSHOP_INIT_FUNCTIONMAP();
	DESIGNCUTSHOP_GET_SHOP_ITEM_LIST(gender);
end

function BEAUTYSHOP_DESIGNCUTSHOP_INIT_INFOTEXT(frame)
	local infoText = GET_CHILD_RECURSIVELY(frame, "infoText");
	infoText:ShowWindow(1);

	local gbSubItem = GET_CHILD_RECURSIVELY(frame, "gbSubItem");
	gbSubItem:ShowWindow(0);
end

function DESIGNCUTSHOP_INIT_FUNCTIONMAP()
	beautyShopInfo.functionMap["UPDATE_SUB_ITEMLIST"] = DESIGNCUTSHOP_UPDATE_SUB_ITEMLIST
	beautyShopInfo.functionMap["DRAW_ITEM_DETAIL"] = DESIGNCUTSHOP_DRAW_ITEM_DETAIL
	beautyShopInfo.functionMap["POST_SELECT_ITEM"]= DESIGNCUTSHOP_POST_SELECT_ITEM
	beautyShopInfo.functionMap["SELECT_SUBITEM"]= DESIGNCUTSHOP_SELECT_SUBITEM
	beautyShopInfo.functionMap["POST_ITEM_TO_BASKET"] = nil
	beautyShopInfo.functionMap["POST_BASKETSLOT_REMOVE"] = nil
end

function DESIGNCUTSHOP_GET_SHOP_ITEM_LIST(gender)
	DESIGNCUTSHOP_MAKE_ITEMLIST(gender);
end

-- 디자인 컷 아이템 리스트
function DESIGNCUTSHOP_REGISTER_ITEM_LIST()
	if DesigncutItemList == nil then
		DesigncutItemList = {};
		DesigncutItemList["Male"] = {};
		DesigncutItemList["Female"] = {};

		local clsList, cnt = GetClassList("Beauty_Shop_Designcut");
		for i = 0, cnt - 1 do
			local cls = GetClassByIndexFromList(clsList, i);
			local data = {
                IDSpace 		= "Beauty_Shop_Designcut",
                ClassName 		= cls.ClassName,
				Category 		= cls.Category,
				Gender			= cls.Gender,
				ItemClassName	= cls.ItemClassName,
				EquipType		= cls.EquipType,
				JobOnly			= cls.JobOnly,
				SellStartTime	= cls.SellStartTime,
				SellEndTime		= cls.SellEndTime,
				StampCount		= tonumber(cls.StampCount),
				PackageList		= cls.PackageList,
				IsPremium		= cls.IsPremium,
				TAG				= cls.TAG,
				ItemAddDate		= cls.ItemAddDate,
			}

			if data.Gender == "M" then
				table.insert(DesigncutItemList["Male"], data);
			elseif data.Gender == "F" then
				table.insert(DesigncutItemList["Female"], data);
			end			
		end
	end

	return DesigncutItemList;
end

-- 염색 정보 리스트
function DESIGNCUTSHOP_REGISTER_DESIGNCUT_DYE_LIST()	
	if DesigncutSubItemList == nil then
		DesigncutSubItemList = {};
		
		local clsList, cnt = GetClassList("Designcut_Dye_List");
		for i = 0, cnt - 1 do
			local cls = GetClassByIndexFromList(clsList, i);
			local data = {
				Group = cls.Group, 
				DyeName = cls.DyeName, 
				IconName = cls.IconName,
                IDSpace = "Designcut_Dye_List",
                ClassName = cls.ClassName,
			};
			
			if DesigncutSubItemList[data.Group] == nil then
				DesigncutSubItemList[data.Group] = {};
			end
			
			table.insert(DesigncutSubItemList[data.Group], data);
		end
	end

	return DesigncutSubItemList;
end
 
function DESIGNCUTSHOP_MAKE_ITEMLIST(gender)    
	local list = DESIGNCUTSHOP_REGISTER_ITEM_LIST();	
	local genderStr = "Male";
	if gender == 2 then
		genderStr = "Female";
	end

	local useList = list[genderStr];
	BEAUTYSHOP_UPDATE_ITEM_LIST(useList, #useList);
end

function DESIGNCUTSHOP_GET_ITEM_EQUIPTYPE(gender, itemClassName)
	local genderStr = "Female";
    if gender == 1 then
        genderStr = "Male";
    end
    
    local list = DESIGNCUTSHOP_REGISTER_ITEM_LIST();
    local useList =  list[genderStr];
    
    for i=1, #useList do
        local data = useList[i];
    
        if data.ItemClassName == itemClassName then
            return data.EquipType;
        end
    end
    
	return nil;
end

-- 염색약
function DESIGNCUTSHOP_UPDATE_SUB_ITEMLIST()
	local maxListCount = #subItemInfo.subItemList;
	if maxListCount < 1 then
		return;
	end
    
	local topFrame = ui.GetFrame("beautyshop");
    local gbSubItemList = GET_CHILD_RECURSIVELY(topFrame,"gbSubItemList");	
	if gbSubItemList == nil then
		return;
    end
	
	local subitemPrefix = "subitem_";
	DESTROY_CHILD_BYNAME(gbSubItemList, subitemPrefix);	-- 이전 염색약 gb 삭제

	local maxControlCount = subItemInfo.maxControlCount;
	local endCount = subItemInfo.subItemViewStartIndex + maxControlCount;
	if maxListCount < endCount then
		endCount = maxListCount + 1;
	end
	
	local x = 0;
	local width = ui.GetControlSetAttribute("beautyshop_subitem", "width");
	local index = 0;

	-- 가운데 정렬
	local diffCount = endCount - subItemInfo.subItemViewStartIndex;
	local alignOffset = (maxControlCount - diffCount) * (width / 2);

	for i = subItemInfo.subItemViewStartIndex, endCount - 1 do
		x = alignOffset + ((index) % maxControlCount) * width;

		local ctrlSet = gbSubItemList:CreateOrGetControlSet("beautyshop_subitem", subitemPrefix .. i, x, 0);
		ctrlSet:SetUserValue("SUB_INDEX_NAME",  subitemPrefix .. i);
		DESIGNCUTSHOP_SET_HAIR_DYE(ctrlSet, subItemInfo.subItemList[i]);

		index = index + 1;
	end
end

function DESIGNCUTSHOP_SET_HAIR_DYE(ctrlSet, hairInfo)
	local picHair = GET_CHILD_RECURSIVELY(ctrlSet, "picHair", "ui::CPicture");
	local picCheck = GET_CHILD_RECURSIVELY(ctrlSet, "picCheck", "ui::CPicture");
	if picHair ~= nil then
		local imgName = hairInfo.dye_icon_name;
		local translateColorName = DESIGNCUTSHOP_GET_TRANSLATE_DYE_NAME(hairInfo.dye_gender, hairInfo.hair_itemClassName, hairInfo.dye_color_name);
		picHair:SetTextTooltip(translateColorName);
		picHair:SetImage(imgName);
	end
	
	local parent = ctrlSet:GetTopParentFrame(); -- beautyShop frame
	local sub_select = parent:GetUserValue("SUB_SELECT");
	if picCheck ~= nil then
		picCheck:SetVisible(0);

		if sub_select ~= "None" then
			local ctrlSetName = ctrlSet:GetName();
			if ctrlSetName == sub_select then
				picCheck:SetVisible(1);
			end
		end
	end

	ctrlSet:SetUserValue("COLOR", hairInfo.dye_color_name);
	ctrlSet:SetUserValue("SUB_ITEM_CLASS_NAME", hairInfo.hair_itemClassName);
	ctrlSet:SetUserValue("SUB_ITEM_GENDER", hairInfo.dye_gender);
	ctrlSet:SetUserValue("IDSPACE", "Designcut_Dye_List");
	ctrlSet:SetUserValue("SHOP_CLASSNAME", hairInfo.ClassName);
	ctrlSet:SetUserValue("COLOR_CLASS_NAME", hairInfo.ColorClassName);
	ctrlSet:SetUserValue("GENDER", hairInfo.dye_gender);

	-- 디자인 컷은 염색약 가격 관련 UI 표시 안함
	local btnStaticTP = GET_CHILD_RECURSIVELY(ctrlSet,"btnStaticTP");
	local isSale_mark = GET_CHILD_RECURSIVELY(ctrlSet, "isSale_mark");
	local btnToBasket = GET_CHILD_RECURSIVELY(ctrlSet, "btnToBasket");
	btnStaticTP:ShowWindow(0);
	isSale_mark:ShowWindow(0);	
	btnToBasket:ShowWindow(0);
end

function DESIGNCUTSHOP_POST_SELECT_ITEM(frame, ctrl)
	local infoText = GET_CHILD_RECURSIVELY(frame, 'infoText');
	local gbSubItem = GET_CHILD_RECURSIVELY(frame, 'gbSubItem');
	infoText:ShowWindow(0);
	gbSubItem:ShowWindow(1);

	local ctrlSet = ctrl:GetParent();
	local gender = ctrlSet:GetUserIValue("GENDER");
	local itemClassName = ctrlSet:GetUserValue("ITEM_CLASS_NAME");
	
	-- 염색 데이터 만들고
	DESIGNCUTSHOP_INIT_SUB_ITEMLIST(gender, itemClassName);

	-- Sub아이템 1번 선택하게 한다. (1번이 default 헤어)
	local startSubItemName = "subitem_1";
	frame:SetUserValue("SUB_SELECT", startSubItemName);
	DESIGNCUTSHOP_UPDATE_SUB_ITEM_SELECT(true);
end

function DESIGNCUTSHOP_GET_DYE_LIST(ItemClassName)
	local hairDyeList = DESIGNCUTSHOP_REGISTER_DESIGNCUT_DYE_LIST();
    local dyeList = hairDyeList[ItemClassName];
    if dyeList == nil then
        return nil;
    end
 
    return dyeList;
end

function DESIGNCUTSHOP_INIT_SUB_ITEMLIST(gender, ItemClassName)
	local topFrame = ui.GetFrame("beautyshop");
	if topFrame == nil or topFrame:IsVisible() == 0 then
		return;
	end

	subItemInfo.subItemList = {};

	local dyeList = DESIGNCUTSHOP_GET_DYE_LIST(ItemClassName);
	for i = 1, #dyeList do
		local info = dyeList[i];
        local hairColorE = info.DyeName;
		local iconName = info.IconName;
		
		subItemInfo.subItemList[i] = { dye_gender = gender,
									   dye_color_name = hairColorE,
									   hair_itemClassName = ItemClassName,
									   dye_icon_name = iconName,
                                       ClassName = info.ClassName,
                                       IDSpace = info.IDSpace,
                                       ColorClassName = info.ClassName,
									};							 
	end	
	
	subItemInfo.subItemViewStartIndex = 1;

	DESIGNCUTSHOP_UPDATE_SUB_ITEMLIST();
end

function DESIGNCUTSHOP_SELECT_SUBITEM(parent, control)
	local ctrlSet = control:GetParent();
	local name = ctrlSet:GetName();
	local parent = control:GetTopParentFrame(); -- beautyShop frame

	local slot = BEAUTYSHOP_GET_PREIVEW_SLOT(gender, itemClassName);
	if slot ~= nil then
		slot:ClearText();
		slot:ClearIcon();
		slot:SetUserValue("CLASSNAME", "None");
	end
	parent:SetUserValue("SUB_SELECT", name);

	-- 미리보기 슬롯에 장착
	DESIGNCUTSHOP_UPDATE_SUB_ITEM_SELECT(false);	
end

function DESIGNCUTSHOP_UPDATE_SUB_ITEM_SELECT(postSelect)
	local topFrame = ui.GetFrame("beautyshop");
	if topFrame == nil or topFrame:IsVisible() == 0 then
		return;
	end

	local gbSubItemList = GET_CHILD_RECURSIVELY(topFrame,"gbSubItemList");	
	if gbSubItemList == nil then
		return;
	end

	local sub_select = topFrame:GetUserValue("SUB_SELECT");
	local subitemPrefix = "subitem_";
	for i = 1, #subItemInfo.subItemList do
		local name = "subitem_" .. i;
		local ctrlSet = gbSubItemList:GetChild(name);
		if ctrlSet ~= nil then
			local picCheck = ctrlSet:GetChild("picCheck");
			if name == sub_select then
				picCheck:SetVisible(1);

				-- 미리보기
				local colorName = ctrlSet:GetUserValue("COLOR");
				local itemClassname = ctrlSet:GetUserValue("SUB_ITEM_CLASS_NAME");
				local gender = ctrlSet:GetUserIValue("SUB_ITEM_GENDER");
				local colorClassName = 	ctrlSet:GetUserValue("COLOR_CLASS_NAME");
				DESIGNCUTSHOP_PREVIEWSLOT_EQUIP(gender, itemClassname, colorName, colorClassName, postSelect);
			else
				picCheck:SetVisible(0);
			end
		end
	end

	topFrame:Invalidate();
end

function DESIGNCUTSHOP_PREVIEWSLOT_EQUIP(gender, itemClassName, colorName, colorClassName, postSelect)
	local topFrame = ui.GetFrame("beautyshop");
	if topFrame == nil or topFrame:IsVisible() == 0 then
		return;
	end

	local allowGender = BEAUTYSHOP_CHECK_MY_GENDER(gender);
	if allowGender == false then
		return;
	end

	local equipType = DESIGNCUTSHOP_GET_ITEM_EQUIPTYPE(gender, itemClassName);
	if equipType == nil then
		return;
	end
	
	local slot = BEAUTYSHOP_GET_PREIVEW_SLOT(equipType, itemClassName);
	if slot == nil then
		return;
	end

	slot:ClearText();
	slot:ClearIcon();
	slot:SetUserValue("CLASSNAME", "None");
	slot:RemoveChild('HAIR_DYE_PALETTE');

	local itemobj = GetClass("Item", itemClassName);
	if itemobj == nil then
		return;
	end

	slot:SetUserValue("TYPE", equipType);
	slot:SetUserValue("COLOR_NAME", colorName);
	slot:SetUserValue("COLOR_CLASS_NAME",colorClassName);

	BEAUTYSHOP_PREVIEWSLOT_EQUIP(topFrame, slot, itemobj);
end

function DESIGNCUTSHOP_DRAW_ITEM_DETAIL(obj, itemobj, ctrlset)
	if TryGetProp(itemobj, "UseGender") ~= nil then
		if itemobj.UseGender == "Female" then
			ctrlset:SetUserValue("GENDER", 2);
		elseif itemobj.UseGender =="Both" then
			ctrlset:SetUserValue("GENDER", 0);
		else 
			ctrlset:SetUserValue("GENDER", 1);
		end	
	else 
		ctrlset:SetUserValue("GENDER", 0);
	end

	-- 프리미엄 여부에 따라 분류되느 UI
	local title = GET_CHILD_RECURSIVELY(ctrlset,"title");		
	local nxp = GET_CHILD_RECURSIVELY(ctrlset,"nxp")
    local slot = GET_CHILD_RECURSIVELY(ctrlset, "icon");
    local picCheck = GET_CHILD_RECURSIVELY(ctrlset, "picCheck");
	local pre_Line = GET_CHILD_RECURSIVELY(ctrlset,"noneBtnPreSlot_1");
	local pre_Box = GET_CHILD_RECURSIVELY(ctrlset,"noneBtnPreSlot_2");

    picCheck:SetVisible(0);

	local itemName = itemobj.Name;
	local itemclsID = itemobj.ClassID;
	local tpitem_clsName = obj.ClassName;
    local tpitem_clsID = obj.ClassID;
 
 	title:SetText(itemName);

    local beautyShopCls = GetClass(ctrlset:GetUserValue("IDSPACE"), ctrlset:GetUserValue("SHOP_CLASSNAME"));
 	BEAUTYSHOP_DETAIL_PREMIUM(ctrlset, itemobj, beautyShopCls);
    BEAUTYSHOP_DETAIL_TAG(ctrlset, itemobj, beautyShopCls);
    BEAUTYSHOP_DETAIL_SET_PRICE_TEXT(ctrlset, beautyShopCls);

	SET_SLOT_IMG(slot, GET_ITEM_ICON_IMAGE(itemobj));
			
	local icon = slot:GetIcon();
	icon:SetTooltipType("wholeitem");
	icon:SetTooltipArg("", itemclsID, 0);
    icon:SetTooltipOverlap(1);

	local lv = GETMYPCLEVEL();
	local job = GETMYPCJOB();
	local gender = GETMYPCGENDER();
	local prop = geItemTable.GetProp(itemclsID);
	local result = prop:CheckEquip(lv, job, gender);

	local desc = GET_CHILD_RECURSIVELY(ctrlset,"desc");
	if result == "OK" then
		desc:SetText(GET_USEJOB_TOOLTIP(itemobj));
	else
		desc:SetText("{#990000}"..GET_USEJOB_TOOLTIP(itemobj).."{/}");
	end

	local tradeable = GET_CHILD_RECURSIVELY(ctrlset,"tradeable");
	local itemProp = geItemTable.GetPropByName(itemobj.ClassName);
	if itemProp:IsEnableUserTrade() == true then
		tradeable:ShowWindow(0);
	else
		tradeable:ShowWindow(1);
	end

	local buyBtn = GET_CHILD_RECURSIVELY(ctrlset, "buyBtn");
	if IS_ENABLE_EQUIP_AT_BEAUTYSHOP(itemobj, beautyShopCls) == false then
		buyBtn:ShowWindow(0);
	end

	local itemClassName = ctrlSet:GetUserValue("ITEM_CLASS_NAME")
	buyBtn:SetEventScriptArgString(ui.LBUTTONUP, itemClassName);
end


function DESIGNCUTSHOP_GET_TRANSLATE_DYE_NAME(Gender, ItemClassName, DyeColorEngName)
	local hairIndex = BEAUTYSHOP_GET_HEADINDEX(Gender, ItemClassName, DyeColorEngName);
	
	local PartClass = imcIES.GetClass("CreatePcInfo", "Hair");
	local GenderList = PartClass:GetSubClassList();
	local Selectclass   = GenderList:GetClass(Gender);
	local Selectclasslist = Selectclass:GetSubClassList();

	local nowHairCls = Selectclasslist:GetClass(hairIndex);
	if nowHairCls == nil then
		return DyeColorEngName;
	end

	local nowColor = imcIES.GetString(nowHairCls, "Color");
	if nowColor == nil then
		return DyeColorEngName;
	end
	
	return nowColor;
end
