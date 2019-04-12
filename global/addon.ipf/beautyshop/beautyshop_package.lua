-- beautyshop_package.lua
local packageItemList = nil

function PACKAGESHOP_OPEN()
	
    local topFrame = ui.GetFrame("beautyshop");
	if topFrame == nil then
		return
	end
	
	-- open 전에  BEAUTYSHOP_SET_GENDER() 함수를 사용해서 gender를 설정한다.
	local shopName = topFrame:GetUserConfig("packageShopName_male");

	local gender = BEAUTYSHOP_GET_GENDER()
	if gender == 2 then
		shopName = topFrame:GetUserConfig("packageShopName_female");
	end
	BEAUTYSHOP_SET_TITLE(shopName)
	topFrame:ShowWindow(1) -- 이것만해도 BEAUTYSHOP_OPEN() 함수가 호출 됨.

	-- 뷰티샵이 열리고나서 이 함수가 호출 되어야함.
	PACKAGESHOP_INIT_FUNCTIONMAP()
	
	PACKAGESHOP_GET_SHOP_ITEM_LIST(BEAUTYSHOP_GET_GENDER()) -- 아이템 목록 읽기 

end

function PACKAGESHOP_INIT_FUNCTIONMAP()
	-- Function Map 등록
	beautyShopInfo.functionMap["UPDATE_SUB_ITEMLIST"] = nil
	beautyShopInfo.functionMap["DRAW_ITEM_DETAIL"] = PACKAGESHOP_DRAW_ITEM_DETAIL
	beautyShopInfo.functionMap["POST_SELECT_ITEM"]= PACKAGESHOP_POST_SELECT_ITEM
	beautyShopInfo.functionMap["SELECT_SUBITEM"]= nil
	beautyShopInfo.functionMap["POST_ITEM_TO_BASKET"] = nil
	beautyShopInfo.functionMap["POST_BASKETSLOT_REMOVE"] = nil
end

function PACKAGESHOP_GET_SHOP_ITEM_LIST(gender)
	PACKAGESHOP_MAKE_ITEMLIST(gender)
end

function PACKAGESHOP_REGISTER_ITEM_LIST()
	-- Beauty_Shop_Package_Cube.xml의 정보.
	
	if packageItemList == nil then
		packageItemList={}
		packageItemList["Male"] ={}
		packageItemList["Female"]={}

		local clsList, cnt = GetClassList('Beauty_Shop_Package_Cube');
		
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
                IDSpace = 'Beauty_Shop_Package_Cube',
                ClassName = cls.ClassName,
			}
			
			if data.Gender == "M" then
				table.insert(packageItemList["Male"], data)
			elseif data.Gender == "F" then
				table.insert(packageItemList["Female"], data)
			elseif data.Gender == "None" then -- None일 경우 남여 둘다 추가.
				table.insert(packageItemList["Male"], data)
				table.insert(packageItemList["Female"], data)
			end
			
		end
	end
	return packageItemList
end
 
 function PACKAGESHOP_MAKE_ITEMLIST(gender)
	
	local list = PACKAGESHOP_REGISTER_ITEM_LIST()
	local genderStr = "Male"
	if gender == 2 then
		genderStr = "Female"
	end

    local useList = list[genderStr]

	BEAUTYSHOP_UPDATE_ITEM_LIST(useList, #useList)
end

-- 헤어 아이템의 장착 타입을 가져옴.
function PACKAGESHOP_GET_ITEM_EQUIPTYPE(Gender, ItemClassName)

	local genderStr = "Female"
    if Gender == 1 then
        genderStr = "Male"
    end
    
    local list = PACKAGESHOP_REGISTER_ITEM_LIST()
    local useList =  list[genderStr]
    
    for i=1, #useList do
        local data = useList[i]
    
        if data.ItemClassName == ItemClassName then
            return data.EquipType
        end
    end
    
    return nil
end

function PACKAGESHOP_POST_SELECT_ITEM(frame, ctrl)
	-- 패키지 샵은 여기서 패키지 목록을 띄워준다.

	local ctrlSet = ctrl:GetParent()
	local gender = ctrlSet:GetUserIValue("GENDER")
	local itemClassName = ctrlSet:GetUserValue("ITEM_CLASS_NAME")
	local idSpace = ctrlSet:GetUserValue('IDSPACE')
	local indexName = ctrlSet:GetUserValue("INDEX_NAME");

	local topFrame = ui.GetFrame("beautyshop");
	if topFrame == nil or topFrame:IsVisible() == 0 then
		return
	end

	local packageItemID = BEAUTYSHOP_GET_ITEMID_BY_ITEM_NAME(idSpace, itemClassName);
	
	if packageItemID ~= nil then
		-- package item의 정보를 가져옴
		local packageItemCls = GetClassByType(idSpace, packageItemID);
		local argStr = string.format('%d;%d;', packageItemID, packageItemCls.Price);
		local itemProp = geItemTable.GetPropByName(itemClassName);
		if itemProp:IsEnableUserTrade() == true then					
			argStr = argStr..'T';
		else
			argStr = argStr..'F';
		end
		
		-- index Name 넣어줌
		argStr = argStr..';'..indexName;
		
		-- PACKAGELIST_SHOW를 위한 데이터 변형
		local showItemClassName = itemClassName
		-- 패키지 샵에서는 패키지 아이템으로부터 PackageList를 검사하고 
		-- none이 아니면 해당하는 아이템의 클래스 ID를  PACKAGELIST_SHOW에 전달한다.
		if packageItemCls ~= nil then
			local packageList = TryGetProp(packageItemCls,'PackageList')
			if packageList ~= nil then
				if packageList ~= 'None' then
					showItemClassName = packageList
				end
			end
		end

		-- id를 넘길 때는 idSpace='Item' 에 있는 ClassID를 넘긴다.
		local itemCls = GetClass('Item', showItemClassName)		
		PACKAGELIST_SHOW(itemCls.ClassID, argStr)
	end
end

function PACKAGESHOP_DRAW_ITEM_DETAIL(obj, itemobj, ctrlset)

	-- gender 설정.
	if TryGetProp(itemobj, "UseGender") ~= nil then
		if itemobj.UseGender == "Female" then
			ctrlset:SetUserValue("GENDER", 2 ) 
		elseif itemobj.UseGender =="Both" then
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
