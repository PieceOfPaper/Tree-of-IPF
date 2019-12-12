-- beautyshop_hair.lua
local HairItemList = nil
local HairSubItemList = nil

function HAIRSHOP_OPEN()
    local topFrame = ui.GetFrame("beautyshop");
	if topFrame == nil then
		return
	end
	
	-- open 전에  BEAUTYSHOP_SET_GENDER() 함수를 사용해서 gender를 설정한다.
	local shopName = topFrame:GetUserConfig("hairShopName_male");

	local gender = BEAUTYSHOP_GET_GENDER()
	if gender == 2 then
		shopName = topFrame:GetUserConfig("hairShopName_female");
	end
	BEAUTYSHOP_SET_TITLE(shopName);
	BEAUTYSHOP_HAIR_INIT_INFOTEXT(topFrame);
	topFrame:ShowWindow(1) -- 이것만해도 BEAUTYSHOP_OPEN() 함수가 호출 됨.	

	-- 뷰티샵이 열리고나서 이 함수가 호출 되어야함.
	HAIRSHOP_INIT_FUNCTIONMAP()
	
	-- 한정템 목록을 요청
	session.beautyshop.RequestPurchasedHairList();
end

function BEAUTYSHOP_HAIR_INIT_INFOTEXT(frame)
	local infoText = GET_CHILD_RECURSIVELY(frame, 'infoText');
	infoText:ShowWindow(1);

	local gbSubItem = GET_CHILD_RECURSIVELY(frame, 'gbSubItem');
	gbSubItem:ShowWindow(0);
end

function ON_BEAUTYSHOP_PURCHASED_HAIR_LIST(frame, msg, strArg, numArg)
	HAIRSHOP_GET_SHOP_ITEM_LIST(BEAUTYSHOP_GET_GENDER()) -- 아이템 목록 읽기 요청
end

function HAIRSHOP_INIT_FUNCTIONMAP()
	-- Function Map 등록
	beautyShopInfo.functionMap["UPDATE_SUB_ITEMLIST"] = HAIRSHOP_UPDATE_SUB_ITEMLIST
	beautyShopInfo.functionMap["DRAW_ITEM_DETAIL"] = HAIRSHOP_DRAW_ITEM_DETAIL
	beautyShopInfo.functionMap["POST_SELECT_ITEM"]= HAIRSHOP_POST_SELECT_ITEM
	beautyShopInfo.functionMap["SELECT_SUBITEM"]= HAIRSHOP_SELECT_SUBITEM
	beautyShopInfo.functionMap["POST_ITEM_TO_BASKET"] = HAIRSHOP_POST_ITEM_TO_BASKET
	beautyShopInfo.functionMap["POST_BASKETSLOT_REMOVE"] = HAIRSHOP_POST_BASKETSLOT_REMOVE
end

function HAIRSHOP_GET_SHOP_ITEM_LIST(gender)
	HAIRSHOP_MAKE_ITEMLIST(gender)
end

function HAIRSHOP_REGISTER_ITEM_LIST()
	-- Beauty_Shop_Hair.xml의 정보.
	if HairItemList == nil then
		HairItemList={}
		HairItemList["Male"] ={}
		HairItemList["Female"]={}

		local clsList, cnt = GetClassList('Beauty_Shop_Hair');
		
		for i = 0, cnt - 1 do
			local cls = GetClassByIndexFromList(clsList, i);
			local data = {
                IDSpace = 'Beauty_Shop_Hair',
                ClassName = cls.ClassName,
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
			}

			if data.Gender == "M" then
				table.insert(HairItemList["Male"], data)
			elseif data.Gender == "F" then
				table.insert(HairItemList["Female"], data)
			end
			
		end
	end
	return HairItemList
end

function HAIRSHOP_MAKE_ITEMLIST_PURCHASE_OVERRIDE(originList, gender)
	-- 한정판 헤어를 구매 했다면 추가한다.
	local genderStr = 'M'
	if gender == 2 then
		genderStr = 'F'
	end

	local cacheList = {}
	-- 캐싱 리스트 (key=ItemClassName, Value = ClassID )
	local clsList, cnt = GetClassList('Beauty_Shop_Hair');
	for i = 0, cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		if cacheList[cls.ItemClassName] == nil then
			cacheList[cls.ItemClassName] = cls.ClassID
		end
	end

	-- 순회 하면서 gender에 해당하는 목록을 뽑는다. 머리이므로 같은 헤어 이름이라면 1개만 추가.
	local count = session.beautyshop.GetPurchasedHairCount();
	local purchasedHairList = {}
	for i=0, count-1 do	
		local info = session.beautyshop.GetPurchasedHair(i)
		local hairClassName = info:GetHairClassName();
		local classID = cacheList[hairClassName]
		local cls = GetClassByType('Beauty_Shop_Hair', classID )
		if cls ~= nil then
			if cls.Gender == genderStr then -- 성별이 같아야하고.
				if purchasedHairList[hairClassName] == nil then
					purchasedHairList[hairClassName] = true -- set 처럼사용해서 체크해서 다시 못넣게 함.
					local originItem = HAIRSHOP_FIND_HAIR_ITEM_FROM_LIST(originList, hairClassName) -- 원래 목록에 있는지 확인.
					if originItem  == nil then -- 원래 목록에 없으면 추가.
						local data = {
							IDSpace = 'Beauty_Shop_Hair',
							ClassName = cls.ClassName,
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
						}
						table.insert(originList, data)
					end
				end
			end
		end	
	end

	return originList;
end

function HAIRSHOP_FIND_HAIR_ITEM_FROM_LIST(list, hairClassName)
	
	for k,v in pairs(list) do
		if v.ItemClassName == hairClassName then
			return v
		end
	end

	return nil
end
 
function HAIRSHOP_MAKE_ITEMLIST(gender)    
	local list = HAIRSHOP_REGISTER_ITEM_LIST();	
	local genderStr = "Male";
	if gender == 2 then
		genderStr = "Female";
	end

	local useList = list[genderStr];
	local realList = HAIRSHOP_MAKE_ITEMLIST_PURCHASE_OVERRIDE(useList, gender);	
	BEAUTYSHOP_UPDATE_ITEM_LIST(realList, #realList);
end

function HAIRSHOP_UPDATE_SUB_ITEMLIST()
	
	local maxListCount = #subItemInfo.subItemList
	
	-- 서브 아이템의 저장 개수가 1개이상 없으면 리턴함.
	if maxListCount < 1 then
		return 
	end
    
	-- 서브 아이템 그룹박스 들고옴.
	local topFrame = ui.GetFrame("beautyshop");
    local gbSubItemList = GET_CHILD_RECURSIVELY(topFrame,"gbSubItemList");	
	if gbSubItemList == nil then
		return
    end
	
	-- 그룹박스내의 subitem_로 시작하는 항목들을 제거 - 기존에 들어가있던 항목 제거.
	local subitemPrefix = "subitem_"
	DESTROY_CHILD_BYNAME(gbSubItemList, subitemPrefix);

	local maxControlCount = subItemInfo.maxControlCount
	local endCount = subItemInfo.subItemViewStartIndex + maxControlCount 
	if maxListCount < endCount then
		endCount = maxListCount + 1
	end
	
	local x = 0
	local width = ui.GetControlSetAttribute("beautyshop_subitem", "width")
	local index =0

	-- 가운데 정렬
	local diffCount = endCount - subItemInfo.subItemViewStartIndex
	local alignOffset = (maxControlCount - diffCount) * (width / 2)

	for i = subItemInfo.subItemViewStartIndex, endCount - 1 do
		x = alignOffset + ( (index) % maxControlCount) * width
		local ctrlSet = gbSubItemList:CreateOrGetControlSet("beautyshop_subitem", subitemPrefix .. i, x,  0 );
		ctrlSet:SetUserValue("SUB_INDEX_NAME",  subitemPrefix .. i)
		HAIRSHOP_SET_HAIR_DYE(ctrlSet, subItemInfo.subItemList[i])
		index = index +1
	end
end

function HAIRSHOP_GET_TRANSLATE_DYE_NAME(Gender, ItemClassName, DyeColorEngName)

	-- 헤어 Index 구함
	local hairIndex = BEAUTYSHOP_GET_HEADINDEX(Gender, ItemClassName, DyeColorEngName)
	
	local PartClass = imcIES.GetClass("CreatePcInfo", "Hair");
	local GenderList = PartClass:GetSubClassList();
	local Selectclass   = GenderList:GetClass(Gender);
	local Selectclasslist = Selectclass:GetSubClassList();

	local nowHairCls = Selectclasslist:GetClass(hairIndex); -- 현재 head 클래스 들고옴
	if nowHairCls == nil then
		return DyeColorEngName
	end

	local nowColor = imcIES.GetString(nowHairCls, "Color")
	if nowColor == nil then
		return DyeColorEngName
	end
	
	return nowColor
end


function HAIRSHOP_SET_HAIR_DYE(ctrlSet, hairInfo)

	local picHair = GET_CHILD_RECURSIVELY(ctrlSet, "picHair", "ui::CPicture");
	local picCheck = GET_CHILD_RECURSIVELY(ctrlSet, "picCheck", "ui::CPicture");
	if picHair ~= nil then

		local imgName = hairInfo.dye_icon_name
		-- tooltip 은 번역해서.
		local translateColorName = HAIRSHOP_GET_TRANSLATE_DYE_NAME(hairInfo.dye_gender,hairInfo.hair_itemClassName, hairInfo.dye_color_name )
		picHair:SetTextTooltip(translateColorName);
		picHair:SetImage(imgName);

	end
	
	-- check 확인.
	local parent = ctrlSet:GetTopParentFrame(); -- beautyShop frame
	local sub_select = parent:GetUserValue("SUB_SELECT")
	if picCheck ~= nil then
		picCheck:SetVisible(0)	

		if sub_select ~= 'None' then
			local ctrlSetName = ctrlSet:GetName()
			if ctrlSetName == sub_select then
				picCheck:SetVisible(1)	
			end
		end
	end

	ctrlSet:SetUserValue("COLOR", hairInfo.dye_color_name)
	ctrlSet:SetUserValue("SUB_ITEM_CLASS_NAME", hairInfo.hair_itemClassName)
	ctrlSet:SetUserValue("SUB_ITEM_GENDER", hairInfo.dye_gender)
	ctrlSet:SetUserValue('IDSPACE', 'Hair_Dye_List');
	ctrlSet:SetUserValue('SHOP_CLASSNAME', hairInfo.ClassName);
	ctrlSet:SetUserValue('COLOR_CLASS_NAME', hairInfo.ColorClassName);
	ctrlSet:SetUserValue('GENDER', hairInfo.dye_gender);

    
	-- 가격 설정
	local nxp = GET_CHILD_RECURSIVELY(ctrlSet,"nxp")
	if nxp ~= nil then				
		local price = HAIRSHOP_GET_DYE_PRICE(hairInfo.hair_itemClassName, hairInfo.dye_color_name);
		local beautyShopCls = GetClass('Hair_Dye_List', hairInfo.ColorClassName);
		local style = '';
		local originPrice = price;
		local isSale_mark = GET_CHILD_RECURSIVELY(ctrlSet, 'isSale_mark');		
		if beautyShopCls.PriceRatio > 0 then			
			price = math.floor(price * (100 - beautyShopCls.PriceRatio) / 100);
			style = parent:GetUserConfig('DISCOUNT_COLOR')..'{cl}'..originPrice..'{/}{/} ';
		else
			isSale_mark:ShowWindow(0);
		end
		nxp:SetTextByKey("value", style..'{@st43}{s16}'..price);
	end
	-- 장바구니 버튼에 컬러 이름 기록.
	local btnToBasket = GET_CHILD_RECURSIVELY(ctrlSet, "btnToBasket");
	btnToBasket:SetEventScriptArgString(ui.LBUTTONUP, hairInfo.dye_color_name); -- dye_color_name

	local pc = GetMyPCObject()
	local data ={
		ClassName = hairInfo.hair_itemClassName,
		ColorEngName = hairInfo.dye_color_name,
	}

	-- 염색 장바구니 표시 유무 처리
	local isSameCurrentHair = IS_SAME_CURRENT_HAIR(pc, data)
	local isSameCurrentHairColor = IS_SAME_CURRENT_HAIR_COLOR(pc, data)

	-- hair가 다른 경우. defualt의 장바구니를 표시하지 않음.
	if isSameCurrentHair == false then
		if hairInfo.dye_color_name == "default" then
			btnToBasket:SetVisible(0)
		end
	else
		-- 헤어는 같은데 컬러도 같은 경우 장바구니를 표시하지 않음.
		if isSameCurrentHairColor == true then
			btnToBasket:SetVisible(0)
		end
	end
end

function HAIRSHOP_POST_SELECT_ITEM(frame, ctrl)
	local infoText = GET_CHILD_RECURSIVELY(frame, 'infoText');
	local gbSubItem = GET_CHILD_RECURSIVELY(frame, 'gbSubItem');
	infoText:ShowWindow(0);
	gbSubItem:ShowWindow(1);

	local ctrlSet = ctrl:GetParent()
	local gender = ctrlSet:GetUserIValue("GENDER")
	local itemClassName = ctrlSet:GetUserValue("ITEM_CLASS_NAME")
	
	-- 염색 데이터 만들고
	HAIRSHOP_INIT_SUB_ITEMLIST(gender, itemClassName);

	-- Sub아이템 1번 선택하게 한다. (1번이 default 헤어)
	local startSubItemName = "subitem_1"
	frame:SetUserValue("SUB_SELECT", startSubItemName )	 
	HAIRSHOP_UPDATE_SUB_ITEM_SELECT(true)
end

-- 헤어 아이템의 장착 타입을 가져옴.
function HAIRSHOP_GET_ITEM_EQUIPTYPE(gender, itemClassName)
	local genderStr = "Female"
    if gender == 1 then
        genderStr = "Male"
    end
    
    local list = HAIRSHOP_REGISTER_ITEM_LIST()
    local useList =  list[genderStr]
    
    for i=1, #useList do
        local data = useList[i]
    
        if data.ItemClassName == itemClassName then
            return data.EquipType
        end
    end
    
	return nil
end

-- 염색약의 가격을 알아오기 
function HAIRSHOP_GET_DYE_PRICE(ItemClassName, DyeColorName)
	local hairDyeList = HAIRSHOP_REGISTER_HAIR_DYE_LIST(ItemClassName)
	local dyeList = hairDyeList[ItemClassName]

	-- dyeName만 목록으로 만듬.
	if dyeList ~= nil then
		for i=1, #dyeList do
			if dyeList[i].DyeName == DyeColorName then
				return dyeList[i].Price
			end
		end
	end

	return 0;
end

function HAIRSHOP_REGISTER_HAIR_DYE_LIST()	
	if HairSubItemList == nil then
		HairSubItemList = {}
		local clsList, cnt = GetClassList('Hair_Dye_List');
		
		for i = 0, cnt - 1 do
			local cls = GetClassByIndexFromList(clsList, i);

			local data = {
				Group = cls.Group, 
				DyeName = cls.DyeName, 
				IconName = cls.IconName,
				DefaultDye = cls.DefaultDye,
				LimitedDye = cls.LimitedDye,
				DyeSellStartTime = cls.DyeSellStartTime,
				DyeSellEndTime = cls.DyeSellEndTime,
				Price = tonumber(cls.Price),
				PriceRatio = tonumber(cls.PriceRatio),
                IDSpace = 'Hair_Dye_List',
                ClassName = cls.ClassName,
			};
			
			if HairSubItemList[data.Group] == nil then
				HairSubItemList[data.Group] = {}
			end
			
			table.insert(HairSubItemList[data.Group], data);
		end
	end
	return HairSubItemList
end

function HAIRSHOP_FIND_SUBITEM_FROM_LIST(subList, hairColorName)

	for k,v in pairs(subList) do
		if v.DyeName == hairColorName then
			return v
		end
	end

	return nil
end

function HAIRSHOP_GET_DYE_LIST_PURCHASE_OVERRIDE(originList, itemClassName)
	-- 이미 구매한 목록이 있으면 추가 한다

	-- 캐싱 리스트 (Key= Color, Value = ClassID) - 넘어온 itemClassName에 해당하는 목록만 캐싱
	local cacheList = {}
	local clsList, cnt = GetClassList('Hair_Dye_List');
	for i = 0, cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		if cls.Group == itemClassName then
			if cacheList[cls.DyeName] == nil then
				cacheList[cls.DyeName] = cls.ClassID
			end
		end
	end

	-- 넘어온 리스트는 ItemClassName에 해당하는 subItemList이다.
	local count = session.beautyshop.GetPurchasedHairCount();
	for i=0, count-1 do	
		local info = session.beautyshop.GetPurchasedHair(i)
		local hairClassName = info:GetHairClassName();
		local hairColorName = info:GetHairColorName();
		
		if itemClassName == hairClassName then
			local alreadyColor = HAIRSHOP_FIND_SUBITEM_FROM_LIST(originList,hairColorName )
			if alreadyColor == nil then -- 없는 색이면 추가.
				if cacheList[hairColorName] ~= nil then -- 캐시리스트에 없는 색이 아니어야한다.
					local cls = GetClassByType('Hair_Dye_List', cacheList[hairColorName])
					if cls ~= nil then
						
					local data = {
						Group = cls.Group, 
						DyeName = cls.DyeName, 
						IconName = cls.IconName,
						DefaultDye = cls.DefaultDye,
						LimitedDye = cls.LimitedDye,
						DyeSellStartTime = cls.DyeSellStartTime,
						DyeSellEndTime = cls.DyeSellEndTime,
						Price = tonumber(cls.Price),
						PriceRatio = tonumber(cls.PriceRatio),
                        ColorClassName = cls.ClassName,
					};

					table.insert(originList, data);

					end
				end
			end
		end
	end

	return originList;
end

function HAIRSHOP_GET_DYE_LIST(ItemClassName)
	local hairDyeList = HAIRSHOP_REGISTER_HAIR_DYE_LIST()
    local dyeList = hairDyeList[ItemClassName]
    if dyeList == nil then        
         return nil
    end
 
	local realList = HAIRSHOP_GET_DYE_LIST_PURCHASE_OVERRIDE(dyeList, ItemClassName)
    return realList
end

-- 염색 리스트를 생성한다.
function HAIRSHOP_INIT_SUB_ITEMLIST(gender, ItemClassName)
	local topFrame = ui.GetFrame("beautyshop");
	if topFrame == nil or topFrame:IsVisible() == 0 then
		return
	end

	local dyeList = HAIRSHOP_GET_DYE_LIST(ItemClassName)
	
	subItemInfo.subItemList = {};
	for i = 1, #dyeList  do
		local info = dyeList[i]
        local hairColorE = info.DyeName
		local iconName = info.IconName
		
		subItemInfo.subItemList[i] = { dye_gender = gender,
									   dye_color_name = hairColorE,
									   hair_itemClassName = ItemClassName,
									   dye_icon_name = iconName,
                                       ClassName = info.ClassName,
                                       IDSpace = info.IDSpace,
                                       ColorClassName = info.ClassName,
									};							 
	end	
	
	subItemInfo.subItemViewStartIndex = 1

	HAIRSHOP_UPDATE_SUB_ITEMLIST()
end

function HAIRSHOP_SELECT_SUBITEM(parent, control)

	local ctrlSet = control:GetParent()
	local name = ctrlSet:GetName()
	local parent = control:GetTopParentFrame(); -- beautyShop frame

	local slot = BEAUTYSHOP_GET_PREIVEW_SLOT(gender, itemClassName)
	if slot ~= nil then
		-- 슬롯에 있는 정보를 날린다.
		slot:ClearText();
		slot:ClearIcon();
		slot:SetUserValue("CLASSNAME", "None");
		slot:RemoveChild('HAIR_DYE_PALETTE')	
	end
	
	-- 새로 선택된 항목 적용.
	parent:SetUserValue("SUB_SELECT", name )

	-- 미리보기 슬롯에 장착
	HAIRSHOP_UPDATE_SUB_ITEM_SELECT(false)
	
end

-- 서브 아이템을 순회 하면서 체크 이미지를 설정하고 미리보기에 아이템을 등록한다.
function HAIRSHOP_UPDATE_SUB_ITEM_SELECT(postSelect)
	local topFrame = ui.GetFrame("beautyshop");
	if topFrame == nil or topFrame:IsVisible() == 0 then
		return
	end

	local gbSubItemList = GET_CHILD_RECURSIVELY(topFrame,"gbSubItemList");	
	if gbSubItemList == nil then
		return
	end

	local sub_select = topFrame:GetUserValue("SUB_SELECT")
	local subitemPrefix = "subitem_"
	for i = 1, #subItemInfo.subItemList do
		local name = "subitem_" .. i
		local ctrlSet = gbSubItemList:GetChild(name);
		if ctrlSet ~= nil then
			local picCheck = ctrlSet:GetChild("picCheck")
			if name == sub_select then
				picCheck:SetVisible(1)
				-- 프리뷰 장착.
				local colorName = ctrlSet:GetUserValue("COLOR")
				local itemClassname = ctrlSet:GetUserValue("SUB_ITEM_CLASS_NAME")
				local gender = ctrlSet:GetUserIValue("SUB_ITEM_GENDER")
				local colorClassName = 	ctrlSet:GetUserValue("COLOR_CLASS_NAME")
				HAIRSHOP_PREVIEWSLOT_EQUIP(gender, itemClassname, colorName, colorClassName, postSelect )
			else
				picCheck:SetVisible(0)
			end
		end
	end

	topFrame:Invalidate()

end

function HAIRSHOP_PREVIEWSLOT_EQUIP(gender, itemClassName, colorName, colorClassName, postSelect )
	local topFrame = ui.GetFrame("beautyshop");
	if topFrame == nil or topFrame:IsVisible() == 0 then
		return
	end

	--  자신의 apc와 아이템의 성별이 맞을 것.
	local allowGender = BEAUTYSHOP_CHECK_MY_GENDER(gender)
	if allowGender == false then
		return 
	end

	local equipType = HAIRSHOP_GET_ITEM_EQUIPTYPE(gender, itemClassName)	-- itemClassName을 가지고 equipType을 가져옴.
	if equipType == nil then
		return 
	end
	
	-- 자신의 헤어와 동일한 헤어이면 미리보기 불가.
	if BEAUTYSHOP_IS_CURRENT_HAIR(itemClassName, colorName) == true then
		if postSelect == false then
			ui.MsgBox(ClMsg('Hair_Dye_Check'));
		end
		-- 그래도 미리보기는 갱신해야 함.
		local frame = ui.GetFrame("beautyshop");
		BEAUTYSHOP_SET_PREVIEW_APC_IMAGE(frame, 99);
		return;
	end

	local slot = BEAUTYSHOP_GET_PREIVEW_SLOT(equipType, itemClassName)
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
	if equipType == "hair" then
		slot:SetUserValue("COLOR_NAME", colorName)
		slot:SetUserValue("COLOR_CLASS_NAME",colorClassName)
	end

	-- 미리보기 슬롯에 넣기. (default 선택)
	BEAUTYSHOP_PREVIEWSLOT_EQUIP(topFrame, slot, itemobj )
end

function HAIRSHOP_DRAW_ITEM_DETAIL(obj, itemobj, ctrlset)

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
    BEAUTYSHOP_DETAIL_SET_PRICE_TEXT(ctrlset, beautyShopCls);

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
	if IS_ENABLE_EQUIP_AT_BEAUTYSHOP(itemobj, beautyShopCls) == false then
		buyBtn:ShowWindow(0);
	end

	local itemClassName = ctrlSet:GetUserValue("ITEM_CLASS_NAME")
	buyBtn:SetEventScriptArgString(ui.LBUTTONUP, itemClassName); --ItemClassName	
end

function BEAUTYSHOP_GET_HAIR_FULLNAME(name, itemClassName, colorName, Gender)
	local genderValue = Gender
	if Gender == nil then
		genderValue = beautyShopInfo.gender
	end

    local ret = name;
    if colorName ~= nil and colorName ~= 'None' then
        ret = ret..' + '..HAIRSHOP_GET_TRANSLATE_DYE_NAME(genderValue, itemClassName, colorName);
    end
    return ret;
end

function HAIRSHOP_POST_ITEM_TO_BASKET(ItemClassName, ItemClassID, slot, SubItemStrArg)
	local colorName = SubItemStrArg
	if SubItemStrArg == nil then
		colorName = 'default'
	end

	local item = GetClassByType("Item", ItemClassID)
	if item == nil then
		return;
	end

	local name = TryGetProp(item, 'Name');
	local icon = slot:GetIcon();
    local hairFullName = BEAUTYSHOP_GET_HAIR_FULLNAME(name, ItemClassName, colorName, nil);
	icon:SetTextTooltip(hairFullName);
	
	slot:SetUserValue("COLOR_NAME",colorName )

	-- 염색일 경우 염색 팔레트 붙이기
	if colorName ~= 'default' then
		local topFrame = ui.GetFrame("beautyshop");
		if topFrame == nil then
			return
		end

		local paletteImageName = topFrame:GetUserConfig('HAIR_DYE_PALETTE_IMAGE_NAME')
		local pic = slot:CreateControl('picture', 'HAIR_DYE_PALETTE', 0,0, slot:GetWidth(), slot:GetHeight())
		pic = tolua.cast(pic, 'ui::CPicture');
		pic:SetImage(paletteImageName);
		pic:EnableHitTest(0);
		pic:SetEnableStretch(1);
		pic:ShowWindow(1);
	end
end

function HAIRSHOP_POST_BASKETSLOT_REMOVE(parent, control, strarg, numarg)
	control:RemoveChild('HAIR_DYE_PALETTE')
end
