-- beautyshop_server.lua

local DRT_TYPE =  {
	NONE = 0,
	COSTUME =1,
	HAIR =2
}

local DRT_DELAY = {
	COSTUME = 5000,
	 HAIR = 3000,
}

local DRT_POS = {
--	COSTUME = {x=34.79, y=6.98, z=1098.98}, -- 미사용
	HAIR = {x=-18.381889, y=4.7181091, z=2.6478555},
}

function IS_EXIST_ITEM_IN_BEAUTYSHOP_IDSpace(info)
	local retValue = false
	local cacheList = BEAUTYSHOP_MAKE_ITEM_CACHELIST(info.IDSpace);
	if cacheList[info.ClassName] ~= nil then
		-- 혹시 모르니까 한번 더 확인
		local cls = GetClass(info.IDSpace, cacheList[info.ClassName]);
		if cls ~= nil then
			retValue = true
		end
	end
	return retValue
end


function IS_BEAUTYSHOP_HAIR_SELLING_PERIOD(info)

	-- 그냥 헤어는 기본 아이템과 구조가 같음.
	local checkHair = IS_BEAUTYSHOP_ITEM_SELLING_PERIOD(info)
	if checkHair == false then
		-- 헤어 구매 기간이 아님.
		return false
	end

	-- 헤어 컬러의 구매 가능 기간 검사
	local cacheList = BEAUTYSHOP_MAKE_HAIR_COLOR_CACHELIST(info.ClassName)
	if cacheList ~= nil then
		local cls = GetClass("Hair_Dye_List", cacheList[info.ColorEngName])
		if cls ~= nil then
			local sellStartTime = TryGetProp(cls, "DyeSellStartTime")
			local sellEndTime = TryGetProp(cls, "DyeSellEndTime");
			if sellStartTime ~= nil and sellEndTime ~= nil then
				if sellStartTime ~= 'None' and sellEndTime ~= 'None' then
					local startTimeStamp = CONVERT_DATESTR_TO_TIME_STAMP(sellStartTime)
					local endTimeStamp = CONVERT_DATESTR_TO_TIME_STAMP(sellEndTime)
					local currentTimeStamp = GET_CURRENT_DB_TIME_STAMP()
					if startTimeStamp > currentTimeStamp or currentTimeStamp > endTimeStamp then
						return false
					end
				end
			end
		end
	end

	return true
end

function IS_BEAUTYSHOP_ITEM_SELLING_PERIOD(info)
	local cacheList = BEAUTYSHOP_MAKE_ITEM_CACHELIST(info.IDSpace)

	if cacheList[info.ClassName] ~= nil then
		local cls = GetClass(info.IDSpace, cacheList[info.ClassName])
		if cls ~= nil then
			local sellStartTime = TryGetProp(cls, "SellStartTime")
			local sellEndTime = TryGetProp(cls, "SellEndTime");
			if sellStartTime ~= nil and sellEndTime ~= nil then
				if sellStartTime ~= 'None' and sellEndTime ~= 'None' then
					local startTimeStamp = CONVERT_DATESTR_TO_TIME_STAMP(sellStartTime)
					local endTimeStamp = CONVERT_DATESTR_TO_TIME_STAMP(sellEndTime)
					local currentTimeStamp = GET_CURRENT_DB_TIME_STAMP()
					if startTimeStamp > currentTimeStamp or currentTimeStamp > endTimeStamp then
						return false
					end
				end
			end
		end
	end

	return true
end
-- 넘어온 목록중에 구매 제한 품목이 있는지 확인.
function IS_PURCHASE_LIMIT(pc, productList)
	local hairList ={}

	-- 넘어온 목록중 hair는 한개만 존재 해야 한다. 
	for i = 1, #productList do
		local info = productList[i];
		-- 해당 IDSpace에 정보가 존재해야한다.
		local isExist = IS_EXIST_ITEM_IN_BEAUTYSHOP_IDSpace(info);
		if isExist == false then
			IMC_LOG("INFO_NORMAL", "IS_PURCHASE_LIMIT: not exist item - aid["..GetPcAIDStr(pc).."]".." item["..info.ClassName.."] IDSpace["..info.IDSpace.."]");
			return true
		end	

		-- 헤어일 경우 처리
		if info.IDSpace == "Beauty_Shop_Hair" then
			-- 헤어 목록에 넣는다.
			table.insert(hairList, info)

			-- 헤어의 판매 기간을 검사한다.
			if IS_BEAUTYSHOP_HAIR_SELLING_PERIOD(info) == false then
				-- 판매 기간이 아니라면 구매한 목록 확인.
				if IS_ALREADY_PURCHASED_HAIR(pc, info.ClassName, info.ColorEngName) == false then
					--구매한 목록도 아닌데 여기에 리스트로 넘어오면 문제가 있는 것. 실패처리
					IMC_LOG("INFO_NORMAL", "CHECK_PURCHASE_LIMIT: hair not for sale - aid["..GetPcAIDStr(pc).."] hairClassName["..info.ClassName.."] hairColor["..info.ColorEngName.."]");
					return true
				end
			end
		else 
			-- 헤어가 아닐 경우 처리
			if IS_BEAUTYSHOP_ITEM_SELLING_PERIOD(info) == false then
				-- 판매기간이 아니면
				IMC_LOG("INFO_NORMAL", "IS_PURCHASE_LIMIT: item not for sale - aid["..GetPcAIDStr(pc).."] itemClassName["..info.ClassName.."]");
				return true
			end
		end
	end

	-- 헤어 리스트의 갯수가 1개넘으면 오류!
	local hairCount = 0;
	for k,v in pairs(hairList) do
		hairCount = hairCount +1
		if hairCount > 1 then
			IMC_LOG("INFO_NORMAL", "CHECK_PURCHASE_LIMIT: Only one hair is available - aid["..GetPcAIDStr(pc).."]");
			return true
		end
	end

	return false -- false 가 정상
end

-- 이미 구매한 헤어 인지 확인함
function IS_ALREADY_PURCHASED_HAIR(pc, itemClassName, ColorName)
	local isAlready = IsAlreadyPurchasedHair(pc, itemClassName,ColorName )
	if isAlready == 1 then
		return true
	end

	return false
end

-- IsEnableEquipCostume 이 있지만 뷰티샵 특화로 루아로 제작
function BEAUTYSHOP_IS_ENABLE_EQUIP_COSTUME(pc, itemClassName)
	local cls = GetClass("Beauty_Shop_Costume", itemClassName)
	if cls == nil then
		return false
	end

	-- 직업 체크
	local jobOnly = TryGetProp(cls, "JobOnly")
	if jobOnly == nil then
		return false
	end
	
	if jobOnly ~= "None" then
		local jobHistoryStr = GetJobHistoryString(pc);
		if string.find(jobHistoryStr, jobOnly) == nil then
			return false
		else
			return true
		end
	end

	-- 성별 체크
	local gender = TryGetProp(cls, "Gender")
	if gender == nil then
		return false
	end

	if gender ~= "None" then
		local pcGenderStr = "M"
		if pc.Gender == 2 then
			pcGenderStr = "F"
		end

		if gender == pcGenderStr then
			return true
		else
			return false
		end
	end

	return true
end

function GET_BEAUTYSHOP_DIRECTION(pc, productList)
	local isHairChange = false
	local isBuyCoustume = false
	for k,v in pairs(productList) do			
		if v.IDSpace == "Beauty_Shop_Costume" then
			isBuyCoustume = BEAUTYSHOP_IS_ENABLE_EQUIP_COSTUME(pc, v.ClassName)
		elseif v.IDSpace == "Beauty_Shop_Hair" then
			isHairChange = true
		end
	end

	local gender = pc.Gender	
	if isHairChange == true then  -- 첫번째는 헤어 연출.
		if gender == 1 then
			return "BARBER_TRACK_2", DRT_TYPE.HAIR -- 남캐 헤어 연출
		else
			return "BARBER_TRACK_1", DRT_TYPE.HAIR -- 여캐 헤어 연출
		end
	elseif isBuyCoustume == true then -- 두번째가 코스튬
		return "DRESS_TRACK_1", DRT_TYPE.COSTUME -- 코스튬 연출
	end

	return "None" , DRT_TYPE.NONE
end

function CHECK_COUPON_ITEM(pc, couponItemGuid)
	local couponItem = nil;
	if couponItemGuid ~= '0' then
		couponItem = GetInvItemByGuid(pc, couponItemGuid);
		if couponItem == nil then
			return false, nil;
		end
		if IsFixedItem(couponItem) == 1 then
			SendSysMsg(pc, 'MaterialItemIsLock');
			return false, nil;
		end
	end
	return true, couponItem;
end

function SCR_TX_BEAUTYSHOP_PURCHASE(pc, idSpaceList, classNameList, colorClassNameList, hairCouponGuid, dyeCouponGuid)
	if #idSpaceList < 1 then
		return;
	end
	if #idSpaceList ~= #classNameList or  #idSpaceList ~= #colorClassNameList then		
		return;
	end

	local retHair, hairCouponItem = CHECK_COUPON_ITEM(pc, hairCouponGuid);
	local retDye, dyeCouponItem = CHECK_COUPON_ITEM(pc, dyeCouponGuid);
	if retHair == false or retDye == false then
		return;
	end

	-- 넘어온 list 합치기
	local productList = {};
	for i = 1, #idSpaceList do		
		local colorName = 'None';
		-- idSpace 가 hair이면서 ColorClassName이 'None'일 경우 default다.
		-- 이렇게 default로 바꿔줘야 startHairColorName이 변경되고 캐릭터 설정의 염색 컬러가 제대로 설정된다.		
		if idSpaceList[i] == 'Beauty_Shop_Hair' and colorClassNameList[i] == 'None' then
			colorName = 'default'
		end

		local colorCls = GetClass('Hair_Dye_List', colorClassNameList[i]);
		if colorCls ~= nil then
			colorName = colorCls.DyeName;
		end
	
		productList[i] = {
			IDSpace =  idSpaceList[i],
			ClassName = classNameList[i],
			ColorClassName = colorClassNameList[i],
			ColorEngName = colorName,
			Price = 0, -- for log
			HairDiscountValue  = 0, -- for log
			DyeDiscountValue = 0, -- for log
		};
	end
	
	-- 구매 제한 검증
	local isLimit = IS_PURCHASE_LIMIT(pc, productList);
	if isLimit == true then
		IMC_LOG("ERROR_LOGIC", "SCR_TX_BEAUTYSHOP_PURCHASE: purchase limit - aid["..GetPcAIDStr(pc).."]");
		return
	end

	local totalPrice = GET_PRICE_INFO_BY_LIST(pc, productList, hairCouponItem, dyeCouponItem);
	if totalPrice < 0 then
		return;
	end

	-- 보유 TP로 구매 할 수 있는지 확인
	if 0 > GetPCTotalTPCount(pc) - totalPrice then
		IMC_LOG("ERROR_LOGIC", "SCR_TX_BEAUTYSHOP_PURCHASE: not enough TP - aid["..GetPcAIDStr(pc).."], have["..GetPCTotalTPCount(pc)..'], totalPrice['..totalPrice..']');
		return
	end

	local aobj = GetAccountObj(pc);
	if aobj == nil then
		IMC_LOG("ERROR_LOGIC", "SCR_TX_BEAUTYSHOP_PURCHASE: account obj nil - aid["..GetPcAIDStr(pc).."]");
		return 
	end

	local etc = GetETCObject(pc);
	if etc == nil then
		IMC_LOG("ERROR_LOGIC", "SCR_TX_BEAUTYSHOP_PURCHASE: etc obj nil - aid["..GetPcAIDStr(pc).."]");
		return;
	end

	local stampCnt = GET_TOTAL_STAMP_COUNT(pc, productList);
	if stampCnt < 0 then
		return;
	end

	-- for log T_T	
	local hairCouponName = TryGetProp(hairCouponItem, 'ClassName', 'None');
	local dyeCouponName = TryGetProp(dyeCouponItem, 'ClassName', 'None');
	local appliedHairDiscount = false;
	local appliedDyeDiscount = false;
	local preHairName = etc.StartHairName;
	local hairEngName = 'None';
	local targetColorEngName = 'None';
	for i = 1, #productList do
		local info = productList[i];
		if info.HairDiscountValue > 0 then
			appliedHairDiscount = true;
		end
		if info.DyeDiscountValue > 0 then
			appliedDyeDiscount = true;
		end

		local itemObj = GetClass("Item", info.ClassName)
		if itemObj == nil then
			IMC_LOG("ERROR_LOGIC", "SCR_TX_BEAUTYSHOP_PURCHASE: item Obj nil - aid["..GetPcAIDStr(pc).."]");
			return 
		end
	end

	-- tx 전에 연출을 실행한다. tx전에 모든 조건 검사가 완료 되어야 함.
	local directionName, directionType = GET_BEAUTYSHOP_DIRECTION(pc, productList)
	if directionName ~= "None" then
		if directionType == DRT_TYPE.HAIR then 
			-- 헤어 연출일 경우 가발을 벗겨주세요
			UnEquipItemSpot(pc, 'HAIR')
			sleep(500)   -- 벗겨지는 것 잠시 대기
			-- 헬멧도 벗겨주세요.
			UnEquipItemSpot(pc, 'HELMET') 
			sleep(500)   -- 벗겨지는 것 잠시 대기
		end

		PlayDirection(pc, directionName);
		SendAddOnMsg(pc, "BEAUTYSHOP_DIRECTION_START", "", 0);
		-- 코스튬일 경우 TX 돌기전에 딜레이를 준다.
		if directionType == DRT_TYPE.COSTUME then
			sleep(DRT_DELAY.COSTUME); 
		elseif directionType == DRT_TYPE.HAIR then 
			-- 더미 아이템 벗겨서 양머리 없어짐. 여기도 딜레이를 준다.
			sleep(DRT_DELAY.HAIR); 
		end
	end

	-- 구매 처리 TX
	local success = true;
	local costumeItemGuid = nil;
	for k,v in pairs(productList) do
		local tx = TxBegin(pc);
		local preDyeName = 'None';

		if appliedHairDiscount == true then
			TxTakeItemByObject(tx, hairCouponItem, 1, 'BeautyShop');
		end

		if appliedDyeDiscount == true then
			TxTakeItemByObject(tx, dyeCouponItem, 1, 'BeautyShop');
		end

		local medalLog = 'BeautyShop';
		local cmdIdx = 0;
		if v.IDSpace == "Beauty_Shop_Hair" then
			local itemCls = GetClass('Item', v.ClassName);
			hairEngName = itemCls.StringArg;
			if v.ColorClassName ~= 'None' then				
				medalLog = 'HairTotal';
				if itemCls.StringArg == preHairName then
					medalLog = 'HairDye';
				end
				preDyeName = etc.StartHairColorName;
				if preDyeName == 'None' then
					preDyeName = 'default';
				end
				targetColorEngName = v.ColorEngName;
			else				
				medalLog = 'HairChange';
			end

			TxChangeDefaultHair(tx, hairEngName, v.ColorEngName, 1);

			if IS_ALREADY_PURCHASED_HAIR(pc, v.ClassName, v.ColorEngName) == false then				
				TxAddBeuatyshopPurchaseHair(tx, v.ClassName, v.ColorEngName);
			end

			-- 헤어구매의 경우 이벤트 프로퍼티 설정
			TX_SET_BEAUTYSHOP_EVENT_PROPERTY(tx, pc)

		else
			-- Beauty_Shop_Costume, Beauty_Shop_Lens, Beauty_Shop_Package_Cube Beauty_Shop_Wig
			local itemCls = GetClass('Item', v.ClassName);			
			cmdIdx = TxGiveItem(tx, v.ClassName, 1, "BeautyShop");

			local classType = TryGetProp(itemCls, 'ClassType', 'None');
			local giveItemGuid = TxGetGiveItemID(tx, cmdIdx);
			if classType == 'Outer' then
				costumeItemGuid = giveItemGuid;
			end
			medalLog = medalLog..':'..itemCls.ClassID..':'..giveItemGuid;
		end

		local _productList = {};
		_productList[1] = v;
		local _price = GET_PRICE_INFO_BY_LIST(pc, _productList, hairCouponItem, dyeCouponItem);

		TxAddIESProp(tx, aobj, "Medal", -_price, medalLog, cmdIdx, hairEngName, targetColorEngName);

		local _stampCnt = GET_TOTAL_STAMP_COUNT(pc, _productList);
		if _stampCnt > 0 then
			TxAddBeautyShopStamp(tx, _stampCnt);
		end
		
		local ret = TxCommit(tx);
		if ret == "SUCCESS" then		
			WRITE_BEAUTY_SHOP_LOG(pc, _productList, _stampCnt, preHairName, preDyeName, hairCouponName, dyeCouponName);
		else
			success = false;
		end
	end

	if success == true then
		InvalidateStates(pc); -- 이거해야 머리바뀜
		AddBuff(pc, pc, 'BEAUTY_HAIR_BUY_BUFF'); -- tx 성공후 버프 걸어줌.

		-- 재생된 연출이 코스튬일 때만 해야함. 동시에 사는경우 헤어 연출인데 중간에 포즈 바껴서 양 머리벗겨짐.
		if directionType == DRT_TYPE.COSTUME and costumeItemGuid ~= nil then
			local poseCls = GetClass('Pose', 'DOUBLEGUNS');			
			EquipItemSpot(pc, costumeItemGuid, 'OUTER');
			sleep(1000); -- Equip 처리도 Request이고 포즈도 리퀘스트라서 바로 하면 씹힘..
			PlayPose(pc, poseCls.ClassID);
		end

		BEAUTYSHOP_EQUIP_DUMMY_ITEM_CLEAR(pc);
	end

	-- 구매 후처리. 
	BEAUTYSHOP_PURCHASE_POST_ACTION(pc,directionType )
	
end

function BEAUTYSHOP_PURCHASE_POST_ACTION(pc, directionType )

	-- 연출을 확인하고 연출이 끝난뒤에 위치를 변경해준다. (1층 미용실만 이상하므로 여기만 땜빵 처리한다 - 진씨의 요청!)
	if directionType ~= DRT_TYPE.NONE then
		-- 최대 20초 기다려줌. 
		local maxLoop = 2000
		for i=0, maxLoop-1 do
			
			sleep(10)
			if IsPlayingDirection(pc) == 0 then
				if  directionType == DRT_TYPE.HAIR then 
					SetPos(pc, DRT_POS.HAIR.x,DRT_POS.HAIR.y,DRT_POS.HAIR.z)

					-- 연출이 끝나면 어차피 줌 인/아웃이 초기화 되므로 카메라 위치와 줌 인/아웃도 다시 설정한다.
					FixCamera(pc, -7.83 , 4.81, 13.42, 240);
					CustomWheelZoom(pc, 1, 80, 240, 50)
				elseif directionType == DRT_TYPE.COSTUME then 
					FixCamera(pc, 34.79, 6.98, 1098.98, 240);
					CustomWheelZoom(pc, 1, 80, 240, 50)
				end
				SendAddOnMsg(pc, "BEAUTYSHOP_DIRECTION_END", "", 0);
				break
			end
		end
	end

end

-- 이벤트 후에 내용을 주석하자.
function TX_SET_BEAUTYSHOP_EVENT_PROPERTY(tx, pc)
	local accountObj = GetAccountObj(pc);
	local eventBeautyBuyCheck = TryGetProp(accountObj, 'EVENT_BEAUTY_BUY_CHECK');
	if eventBeautyBuyCheck == nil then
        IMC_LOG('ERROR_LOGIC', 'TX_SET_BEAUTYSHOP_EVENT_PROPERTY: account property error! plz check account.xml or classkey!');
        return
	end
	
	if eventBeautyBuyCheck == 'YES' then
		return
	end

	TxSetIESProp(tx, accountObj, 'EVENT_BEAUTY_BUY_CHECK', 'YES');

end

function GET_PRICE_INFO_BY_LIST(pc, productList, hairCouponItem, dyeCouponItem)	
	local hairPrice = 0;
	local dyePrice = 0;
	local normalItemPrice = 0;
	for i = 1, #productList do
		local info = productList[i];
		local price, _hairPrice, _dyePrice, hairDiscountValue, dyeDiscountValue = GET_BEAUTYSHOP_ITEM_PRICE(pc, info, hairCouponItem, dyeCouponItem);		
		if price == -1 then
			IMC_LOG("ERROR_LOGIC", "SCR_TX_BEAUTYSHOP_PURCHASE: item price abnormal - aid["..GetPcAIDStr(pc)..'], idSpace['..info.IDSpace..'], className['..info.ClassName..'], color['..info.ColorClassName..']');
			return -1;
		end
		if info.IDSpace == 'Beauty_Shop_Hair' then
			dyePrice = dyePrice + _dyePrice;
			hairPrice = hairPrice + _hairPrice;
			productList[i].Price = _hairPrice + _dyePrice;
			productList[i].HairDiscountValue = hairDiscountValue;
			productList[i].DyeDiscountValue = dyeDiscountValue;
		else
			normalItemPrice = normalItemPrice + price;
			productList[i].Price = price;
		end
	end
	local totalPrice = hairPrice + dyePrice + normalItemPrice;
	return totalPrice, hairPrice, dyePrice, normalItemPrice;
end

function SCR_GO_BEAUTYSHOP(pc, itemGuid, argList)
	local curZone = GetZoneName(pc);
	local mapCls = GetClass('Map', curZone);
	if IS_BEAUTYSHOP_MAP(mapCls) == false then
		return;
	end

	if IsAutoSellerState(pc) == 1 then
		SendSysMsg(pc, 'Orgel_MSG4');
		return;
	end
	MoveZone(pc, 'c_Klaipe', -1061, 240, 616);
end

function GET_TOTAL_STAMP_COUNT(pc, productList)
	local stampCnt = 0;
	for i = 1, #productList do
		local info = productList[i];
		local beautyshopCls = GetClass(info.IDSpace, info.ClassName);
		if beautyshopCls == nil then
			IMC_LOG('ERROR_LOGIC', 'GET_TOTAL_STAMP_COUNT: invalid beautyshop class- idspace['..info.IDSpace..'], className['..info.ClassName..']');
			return -1;
		end

		local itemStampCnt = 0;
		local addStampCnt = 0;

		if info.IDSpace == 'Beauty_Shop_Hair' then
			-- 헤어의 경우 stamp 처리.
			local data = {
				ClassName = info.ClassName,
				ColorEngName = info.ColorEngName
			}
			local isSameCurrentHair = IS_SAME_CURRENT_HAIR(pc, data); 
			local isSameCurrentHairColor = IS_SAME_CURRENT_HAIR_COLOR(pc, data);

			-- 새로운 헤어 일 때.
			if isSameCurrentHair == false  then
				if info.ColorEngName == 'default' then 
					-- 기본 색일 떄 : hair의 stamp 적용.
					itemStampCnt = TryGetProp(beautyshopCls, 'StampCount', 0);
				else
					-- 기본 색이 아닐 때 : hair stamp + color stamp 적용
					itemStampCnt = TryGetProp(beautyshopCls, 'StampCount', 0);
					local colorCls = GetClass('Hair_Dye_List', info.ColorClassName);
					addStampCnt = TryGetProp(colorCls, 'StampCount', 0);
				end
			else -- 새로운 헤어가 아님. 염색만..
				local colorCls = GetClass('Hair_Dye_List', info.ColorClassName);
				addStampCnt = TryGetProp(colorCls, 'StampCount', 0);
			end
		else
			-- 그외에 해당 아이템의 stamp 적용.
			itemStampCnt = TryGetProp(beautyshopCls, 'StampCount', 0);
		end

		stampCnt = stampCnt + itemStampCnt + addStampCnt;
	end

	return stampCnt;
end

function BEAUTYSHOP_GET_EQUIP_SPOT_NAME_LIST()
	local list ={}
	list["costume"] 			= "OUTER"
	list["hair_costume_1"] 		= "HAT"
	list["hair_costume_2"] 		= "HAT_L"
	list["hair_costume_3"] 		= "HAT_T"
	list["lens"] 				= "LENS"
	list["wing"] 				= "WING"
	list["effect_costume"] 		= "EFFECTCOSTUME"
	list["armband"] 			= "ARMBAND"
	list["toy"] 				= "RH"   -- 오른손 맞나..?

	return list
end

function BEAUTYSHOP_GET_EQUIP_SPOT_NAME(equipType)

	local list = BEAUTYSHOP_GET_EQUIP_SPOT_NAME_LIST()
	return list[equipType]
end

function SCR_TRY_IT_ON(pc, classNameList, hairColorList, equipTypeList, visibleList)

	-- pc가 뷰티샵에 없으면 실패
	local curMapName = GetZoneName(pc)
	if curMapName ~= 'c_barber_dress' then
		IMC_LOG("INFO_NORMAL", "SCR_TRY_IT_ON: not beautyshop map - aid["..GetPcAIDStr(pc).."]");
		return
	end

	local itemCount = #classNameList;
	if itemCount < 1 or  itemCount ~= #hairColorList or  itemCount ~= #equipTypeList or itemCount ~= #visibleList then
		IMC_LOG("INFO_NORMAL", "SCR_TRY_IT_ON: argError- aid["..GetPcAIDStr(pc).."]");
		return
	end

	-- 넘어온 list 합치기
	local productList = {}
	for i = 1, itemCount do
			productList[i] = {
			className 	= classNameList[i],
			color 		= hairColorList[i],
			equipType 	= string.lower(equipTypeList[i]),
			visible 	= visibleList[i],
		}
	end


	local dummyEquipList ={} -- 헤어를 제외한 리스트를 먼저 담고, 나중에 헤어를 하나로 만들어서 담음.
	
	local hairChangelist = {}
	local isHairChange = false -- hair가 있는지.
	local isWigVisible = false -- 가발이 있으면서 보이기 되어 있는경우.
	
	-- 헤어 데이터 추출
	for k, v in pairs(productList) do
		-- 1. hair의 경우 다음과 같이 처리한다.
		if v.equipType == "hair" then 
			-- 1) equipType이 hair이면 hairColor가 같이 온다.
			hairChangelist["hair"] ={}
			hairChangelist["hair"].hairClassName = v.className
			hairChangelist["hair"].hairColorName = v.color
			isHairChange = true
		elseif v.equipType == "wig" then 
			-- 2) equipType이 wig이면 가발인데 다음 타입으로 wig_color이 올 수 있다 이 두개는 합쳐야함.
			if hairChangelist["wig"] == nil then
				hairChangelist["wig"] = {}
			end
			hairChangelist["wig"].hairClassName = v.className
			isHairChange = true
			if v.visible == 1 then
				isWigVisible = true
			end
		elseif v.equipType == "wig_dye" then
			if hairChangelist["wig"] == nil then
				hairChangelist["wig"] = {}
			end
			hairChangelist["wig"].hairColorName = "BLANK"
			local cls = GetClass("Item",v.className )
			if cls ~= nil then
				local prop = TryGetProp(cls, "StringArg")
				if prop ~= nil then
					hairChangelist["wig"].hairColorName =prop
				end
			end
		else
			if v.visible == 1 then
				local data = {
					className = v.className,
					equipSpotName = BEAUTYSHOP_GET_EQUIP_SPOT_NAME(v.equipType),
					optionColor = v.color,
				}
				table.insert(dummyEquipList,data)
			end
		end
	end

	-- 헤어 데이터 최종 넣기
	if isHairChange == true then
		local hairClassName = "None"
		local hairColorName = "BLANK"
		if isWigVisible == true then
			-- 가발이 보이기라면.
			hairClassName = hairChangelist["wig"].hairClassName
			if hairChangelist["wig"].hairColorName ~= nil then
				hairColorName = hairChangelist["wig"].hairColorName
			end
		else 
			-- 가발만 보냈는데 보이기 OFF상태로 보냈으면 "hair"가 nil이다.
			if hairChangelist["hair"] == nil then
				isHairChange = false
			end	
			hairClassName = hairChangelist["hair"].hairClassName
			hairColorName = hairChangelist["hair"].hairColorName
		end
	
		-- 한번 더 헤어 변경인지 검사한다 (중간에 바뀔 수 있음)
		if isHairChange == true then
			local data ={
				className = hairClassName,
				equipSpotName = "HAIR",
				optionColor = hairColorName
			}
			
			table.insert(dummyEquipList, data)
		end
	end

	-- 더미 아이템 장착전에 모두 제거
	BEAUTYSHOP_EQUIP_DUMMY_ITEM_CLEAR(pc)
	
	-- 입어보기전에 연출과 똑같이 가발과 헬멧을 벗긴다!
	UnEquipItemSpot(pc, 'HAIR')
	sleep(500)   -- 벗겨지는 것 잠시 대기
	UnEquipItemSpot(pc, 'HELMET') 
	sleep(500)   -- 벗겨지는 것 잠시 대기

	-- 더미 아이템 장착
	for k,v in pairs(dummyEquipList) do
		EquipDummyItemSpotByName(pc, pc, v.className, v.equipSpotName, 0, 0, v.optionColor);
	end

end

function BEAUTYSHOP_EQUIP_DUMMY_ITEM_CLEAR(pc)

	local equipSlotList = BEAUTYSHOP_GET_EQUIP_SPOT_NAME_LIST()
	EquipDummyItemSpotByName(pc, pc, '', 'HAIR', 0, 0, 'BLANK'); -- hair 초기화
	for k,name in pairs(equipSlotList) do
		EquipDummyItemSpotByName(pc, pc, '', name, 0, 0, 'None'); -- 나머지 초기화
	end

end

function SCR_TRY_IT_ON_CANCEL(pc)
	
	-- pc가 뷰티샵에 없으면 실패
	local curMapName = GetZoneName(pc)
	if curMapName ~= 'c_barber_dress' then
		IMC_LOG("INFO_NORMAL", "SCR_TRY_IT_ON_CANCEL: not beautyshop map - aid["..GetPcAIDStr(pc).."]");
		return
	end

	BEAUTYSHOP_EQUIP_DUMMY_ITEM_CLEAR(pc)
end

function SCR_EXCHANGE_BEAUTYSHOP_COUPON(pc, stampCnt)
	local curStampCnt = GetBeautyShopStampCount(pc);
	if curStampCnt < stampCnt then
		return;
	end

	local info = GET_STAMP_EXHCANGE_INFO(stampCnt);
    if info == nil then
        return;
    end

	if IsRunningScript(pc, 'TX_EXCHANGE_BEAUTYSHOP_COUPON') ~= 1 then
		TX_EXCHANGE_BEAUTYSHOP_COUPON(pc, info);
	end
end

function TX_EXCHANGE_BEAUTYSHOP_COUPON(pc, info)
	local rewardItemCls = GetClass('Item', info.rewardItemName);
	if rewardItemCls == nil then
		IMC_LOG('ERROR_LOGIC', 'TX_EXCHANGE_BEAUTYSHOP_COUPON: rewardItem class is null- itemName['..info.rewardItemName..']');
		return;
	end

	local tx = TxBegin(pc);
	if tx == nil then
		return;
	end

	TxAddBeautyShopStamp(tx, -info.stampCount);
	TxGiveItem(tx, info.rewardItemName, 1, 'BeautyShop_CouponExchange');
	local ret = TxCommit(tx);
	if ret ~= 'SUCCESS' then
		IMC_LOG('ERROR_LOGIC', 'TX_EXCHANGE_BEAUTYSHOP_COUPON: TxFail- aid['..GetPcAIDStr(pc)..'], stampCnt['..info.stampCount..']');
		return;
	end

	local totalStampCnt = GetBeautyShopStampCount(pc);
	SendAddOnMsg(pc, 'UPDATE_BEAUTY_COUPON_STAMP', 'None', totalStampCnt);
	BeautyShopExchangeLog(pc, rewardItemCls.ClassID, rewardItemCls.ClassName, info.stampCount, totalStampCnt);
end

function WRITE_BEAUTY_SHOP_LOG(pc, productList, stampCnt, preHairName, preDyeName, hairCouponName, dyeCouponName)	
	for i = 1, #productList do
		local info = productList[i];
		local beautyShopCls = GetClass(info.IDSpace, info.ClassName);
		local colorCls = nil;
		local basicPrice = beautyShopCls.Price;
		if info.IDSpace == 'Beauty_Shop_Hair' then			
			local hairCls = GetClass('Item', info.ClassName);
			local curHairName = hairCls.StringArg;
			if preHairName == curHairName then
				basicPrice = 0; -- 머리 똑같은 경우
			end
			if info.ColorClassName ~= 'None' then
				colorCls = GetClass('Hair_Dye_List', info.ColorClassName);
				basicPrice = basicPrice + colorCls.Price;
			end
			BeautyShopHairLog(pc, preHairName, curHairName, preDyeName, TryGetProp(colorCls, 'DyeName', 'None'), stampCnt, GetBeautyShopStampCount(pc), info.Price, basicPrice, beautyShopCls.PriceRatio, TryGetProp(colorCls, 'PriceRatio', 0), hairCouponName, dyeCouponName, info.HairDiscountValue, info.DyeDiscountValue);				
		else
			local itemCls = GetClass('Item', info.ClassName);
			BeautyShopItemLog(pc, itemCls.ClassName, itemCls.ClassID, info.Price, basicPrice, beautyShopCls.PriceRatio);
		end
	end
end

function IS_PC_BEAUTYSHOP_FIRST_FLOOR(pc)
	if GetZoneName(pc) ~= 'c_barber_dress' then
		return false;
	end

    local x, y, z = GetPos(pc);
    local cx, cy, cz = -4, 4, -3; -- 1층 중간점
	if IsInRange(x, y, z, cx, cy, cz, 200) ~= 1 then
		return false;
	end

	return true;
end

-- 여기부터 테스트
function TEST_GET_HAIR_STATE(pc)
	local etc = GetETCObject(pc);
	local chatmsg = 'StartHair['..etc.StartHairName..'], CurHairName['..etc.CurHairName..'] 컬러['..etc.StartHairColorName..'], 가발보이기['..etc.HAIR_WIG_Visible..']';
	Chat(pc, chatmsg);
end