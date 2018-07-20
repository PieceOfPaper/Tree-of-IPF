-- beautyshop_wig.lua
local WigItemList = nil

function WIGSHOP_OPEN()
    local topFrame = ui.GetFrame("beautyshop");
	if topFrame == nil then
		return
	end
	
	-- open 전에  BEAUTYSHOP_SET_GENDER() 함수를 사용해서 gender를 설정한다.
	local shopName = topFrame:GetUserConfig("wigShopName_male");

	local gender = BEAUTYSHOP_GET_GENDER()
	if gender == 2 then
		shopName = topFrame:GetUserConfig("wigShopName_female");
	end
	BEAUTYSHOP_SET_TITLE(shopName)
	topFrame:ShowWindow(1) -- 이것만해도 BEAUTYSHOP_OPEN() 함수가 호출 됨.

	-- 뷰티샵이 열리고나서 이 함수가 호출 되어야함.
	WIGSHOP_INIT_FUNCTIONMAP()
	
	WIGSHOP_GET_SHOP_ITEM_LIST(BEAUTYSHOP_GET_GENDER()) -- 아이템 목록 읽기 
end

function WIGSHOP_INIT_FUNCTIONMAP()
	-- Function Map 등록
	beautyShopInfo.functionMap["UPDATE_SUB_ITEMLIST"] = nil
	beautyShopInfo.functionMap["DRAW_ITEM_DETAIL"] = WIGSHOP_DRAW_ITEM_DETAIL
	beautyShopInfo.functionMap["POST_SELECT_ITEM"]= WIGSHOP_POST_SELECT_ITEM
	beautyShopInfo.functionMap["SELECT_SUBITEM"]= nil
	beautyShopInfo.functionMap["POST_ITEM_TO_BASKET"] = nil
	beautyShopInfo.functionMap["POST_BASKETSLOT_REMOVE"] = nil
end

function WIGSHOP_GET_SHOP_ITEM_LIST(gender)
	WIGSHOP_MAKE_ITEMLIST(gender)
end

function WIGSHOP_REGISTER_ITEM_LIST()
	-- Beauty_Shop_Wig.xml의 정보.
	
	if WigItemList == nil then
		WigItemList={}
		WigItemList["Male"] ={}
		WigItemList["Female"]={}

		local clsList, cnt = GetClassList('Beauty_Shop_Wig');
		
		for i = 0, cnt - 1 do
			local cls = GetClassByIndexFromList(clsList, i);
			local data = {
				Category 		= cls.Category,
				Gender			= cls.Gender,
				ItemClassName	= cls.ItemClassName,
				EquipType		= cls.EquipType,
				Price			= tonumber(cls.Price),
				PriceRatio		= tonumber(cls.PriceRatio),
				JobOnly			= cls.JobOnly,
				SellStartTime	= cls.SellStartTime,
				SellEndTime		= cls.SellEndTime,
				StampCount		= tonumber(cls.StampCount),
				PackageList		= cls.PackageList,
				IsPremium		= cls.IsPremium,
				TAG				= cls.TAG,
				ItemAddDate		= cls.ItemAddDate,
                IDSpace = 'Beauty_Shop_Wig',
                ClassName = cls.ClassName,
			}

			if data.Gender == "M" then
				table.insert(WigItemList["Male"], data)
			elseif data.Gender == "F" then
				table.insert(WigItemList["Female"], data)
			else 
				table.insert(WigItemList["Male"], data)
				table.insert(WigItemList["Female"], data)
			end
		end
	end
	return WigItemList
end
 
 function WIGSHOP_MAKE_ITEMLIST(gender)
    
	local list = WIGSHOP_REGISTER_ITEM_LIST()
	local genderStr = "Male"
	if gender == 2 then
		genderStr = "Female"
	end

	local useList = list[genderStr]

	BEAUTYSHOP_UPDATE_ITEM_LIST(useList, #useList)
end

-- 헤어 아이템의 장착 타입을 가져옴.
function WIGSHOP_GET_ITEM_EQUIPTYPE(Gender, ItemClassName)

	local genderStr = "Female"
    if Gender == 1 then
        genderStr = "Male"
    end
    
    local list = WIGSHOP_REGISTER_ITEM_LIST()
    local useList =  list[genderStr]
    
    for i=1, #useList do
        local data = useList[i]
    
        if data.ItemClassName == ItemClassName then
            return data.EquipType
        end
    end
    
    return nil
end

function WIGSHOP_POST_SELECT_ITEM(frame, ctrl)
	
	local ctrlSet = ctrl:GetParent()
	local gender = ctrlSet:GetUserIValue("GENDER")
	local itemClassName = ctrlSet:GetUserValue("ITEM_CLASS_NAME")
	
	local topFrame = ui.GetFrame("beautyshop");
	if topFrame == nil or topFrame:IsVisible() == 0 then
		return
	end
	
	--  자신의 apc와 아이템의 성별이 맞을 것.
	local allowGender = BEAUTYSHOP_CHECK_MY_GENDER(gender)
	if allowGender == false then
		return 
	end
	
	local equipType = WIGSHOP_GET_ITEM_EQUIPTYPE(gender, itemClassName)	-- itemClassName을 가지고 equipType을 가져옴.
	if equipType == nil then
		return 
	end
	
	local slot = BEAUTYSHOP_GET_PREIVEW_SLOT(equipType)
	if slot == nil then
		return
	end

	-- 슬롯에 있는 정보를 날린다.
	slot:ClearText();
	slot:ClearIcon();
	slot:SetUserValue("CLASSNAME", "None");
	slot:RemoveChild('HAIR_DYE_PALETTE')	

	-- item obj가져오기
	local itemobj = GetClass("Item", itemClassName)
	if itemobj == nil then
		return
	end

	-- slot에 정보 넣기	
	slot:SetUserValue("TYPE", equipType)
	

	-- 미리보기 슬롯에 넣기. (default 선택)
	BEAUTYSHOP_PREVIEWSLOT_EQUIP(topFrame, slot, itemobj )

end

function WIGSHOP_DRAW_ITEM_DETAIL(obj, itemobj, ctrlset)

	-- gender 설정.
	if TryGetProp(itemobj, "UseGender") ~= nil then
		if itemobj.UseGender == "Female" then
			ctrlset:SetUserValue("GENDER", 2 ) 
		elseif itemobj.UseGender =="Both" then
			ctrlset:SetUserValue("GENDER", 0 ) 
		elseif itemobj.UseGender == "None" then
			ctrlset:SetUserValue("GENDER", 0 ) 
		else  
			ctrlset:SetUserValue("GENDER", 1 ) 
		end	
	else 
		ctrlset:SetUserValue("GENDER", 0 ) 	
	end

	-- 프리미엄 여부에 따라 분류되느 UI를 일괄적으로 받아오고
	local title = GET_CHILD_RECURSIVELY(ctrlset,"title");	
	local nxp = GET_CHILD_RECURSIVELY(ctrlset,"nxp")
    local slot = GET_CHILD_RECURSIVELY(ctrlset, "icon");
    local picCheck = GET_CHILD_RECURSIVELY(ctrlset, "picCheck");
	local pre_Line = GET_CHILD_RECURSIVELY(ctrlset,"noneBtnPreSlot_1");
	local pre_Box = GET_CHILD_RECURSIVELY(ctrlset,"noneBtnPreSlot_2");	
   
    -- 체크상자 우선 없앰 (임시로 아무거나 넣어둠 그림 나중에 바꿔야함.)
    picCheck:SetVisible(0);

	local itemName = itemobj.Name;
	local itemclsID = itemobj.ClassID;
	local tpitem_clsName = obj.ClassName;
    local tpitem_clsID = obj.ClassID;
    
    title:SetText(itemName);

    local beautyShopCls = GetClass(ctrlset:GetUserValue('IDSPACE'), ctrlset:GetUserValue('SHOP_CLASSNAME'));
 	BEAUTYSHOP_DETAIL_PREMIUM(ctrlset, itemobj, beautyShopCls);
    BEAUTYSHOP_DETAIL_TAG(ctrlset, itemobj, beautyShopCls);
    BEAUTYSHOP_DETAIL_SET_PRICE_TEXT(ctrlset, beautyShopCls)

	SET_SLOT_IMG(slot, GET_ITEM_ICON_IMAGE(itemobj));
			
	local icon = slot:GetIcon();
	icon:SetTooltipType("wholeitem");
	icon:SetTooltipArg("", itemclsID, 0);
    icon:SetTooltipOverlap(1)

	local lv = GETMYPCLEVEL();
	local job = GETMYPCJOB();
	local gender = GETMYPCGENDER();
	local prop = geItemTable.GetProp(itemclsID);
	local result = prop:CheckEquip(lv, job, gender);

	local desc = GET_CHILD_RECURSIVELY(ctrlset,"desc")
	if result == "OK" then
		desc:SetText(GET_USEJOB_TOOLTIP(itemobj))
	else
		desc:SetText("{#990000}"..GET_USEJOB_TOOLTIP(itemobj).."{/}")
	end

	local tradeable = GET_CHILD_RECURSIVELY(ctrlset,"tradeable")
	local itemProp = geItemTable.GetPropByName(itemobj.ClassName);
	if itemProp:IsEnableUserTrade() == true then
		tradeable:ShowWindow(0)
	else
		tradeable:ShowWindow(1)
	end

	-- 버튼에 Arg 설정.
	local buyBtn = GET_CHILD_RECURSIVELY(ctrlset, "buyBtn");
	local itemClassName = ctrlSet:GetUserValue("ITEM_CLASS_NAME")
	buyBtn:SetEventScriptArgString(ui.LBUTTONUP, itemClassName); --ItemClassName
end