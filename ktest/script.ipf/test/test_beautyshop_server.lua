-- test_beautyshop.lua

function TEST_PRINT_HAIR(pc)
   local etc = GetETCObject(pc)
    if etc ~= nil then
       local CurHairName = etc['CurHairName'];
        local CurHairColorName = etc['CurHairColorName'];
        local StartHairName = etc['StartHairName'];
        local StartHairColorName = etc['StartHairColorName'];
        local BeautyshopStartHair= etc['BeautyshopStartHair'];
        
        print("CurHairName : "..CurHairName);
        print("CurHairColorName : "..CurHairColorName);
        print("StartHairName : "..StartHairName);
        print("StartHairColorName : "..StartHairColorName);
        print("BeautyshopStartHair : "..BeautyshopStartHair);
  
    end
end

function TEST_DEFUALT_HAIR(pc, hairName, hairColorName, shopChange )

    local tx = TxBegin(pc);

    TxChangeDefaultHair(tx, hairName, hairColorName, shopChange );
    
    local ret = TxCommit(tx);
    if ret ~= "SUCCESS" then
        print("tx fail");
        return;
    end

    InvalidateStates(pc); -- 이걸 해주면 헤어검사를 다시 한다. CheckHeadIndexByHairItem() 호출됨.
end

function TEST_FAKE_EQUIP(pc, itemClassname, SpotName)
    
    --	EquipDummyItemSpotByName(self, self, lycanHat, "HAT", 0, 1);
    --	EquipDummyItemSpotByName(self, self, lycanHair, "HAIR", 0, 1);
    -- EquipDummyItemSpotByName(self, self, lycanOuter, "OUTER", 0, 1);
    
    -- 장비될타겟, 보여질타겟,  ItemClassName, SoptName, 타겟에만보낼지, 원래모양을 숨길지.        
    EquipDummyItemSpotByName(pc, pc, itemClassname, SpotName, 0, 0); 
end

function TEST_FAKE_UNEQUIP(pc,  SpotName)
    
    --	EquipDummyItemSpotByName(self, self, lycanHat, "HAT", 0, 1);
    --	EquipDummyItemSpotByName(self, self, lycanHair, "HAIR", 0, 1);
    --	EquipDummyItemSpotByName(self, self, lycanOuter, "OUTER", 0, 1);
    
    -- 장비될타겟, 보여질타겟,  ItemClassName, SoptName, 타겟에만보낼지, 원래모양을 숨길지.        
    EquipDummyItemSpotByName(pc, pc, "", SpotName, 0, 0); -- 반드시영이 1이면 보여질타겟에만 패킷전송함.
end


function TEST_TRY_IT_ON_SERVER(pc)

    -- test list
    classNameList 	= { "HAIR_F_133", "costume_war_f_009", "HAIR_F_115", "Premium_hairColor_03" } -- 헤어, 코스튬, 가발, 가발 염색
    hairColorList 	= { "red", "None", "None", "None"}
    equipTypeList 	= { "hair", "costume", "Wig", "Wig_Dye" } --  lower 필요.
    visibleList 	= { 1, 1, 1, 1 }        -- 보여주기/안보여주기, 보통 가발에만 적용 현재 가발 안보여주기.

    SCR_TRY_IT_ON(pc, classNameList, hairColorList, equipTypeList, visibleList  )
end

function TEST_PRINT_BEAUTYSHOP_EVENT_PROPERTY(pc)

    local accountObj = GetAccountObj(pc);
	local eventBeautyBuyCheck = TryGetProp(accountObj, 'EVENT_BEAUTY_BUY_CHECK');
	if eventBeautyBuyCheck == nil then
        return
    end
    
    print("EVENT_BEAUTY_BUY_CHECK :", eventBeautyBuyCheck)
	
end
    

function TEST_PRINT_COUPON_STAMP(pc)
    local count = GetBeautyShopStampCount(pc)
    print("COUPON_STAMP : "..count)
end