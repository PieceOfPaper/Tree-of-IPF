-- test.lua

function TEST_FIXCAMERA(pc, x, y, z, dist)

    FixCamera(pc, x,y,z,dist)
end

function TEST_CANCEL_FIXCAMERA(pc)

    CancelFixCamera(pc)
end

function TEST_CUSTOM_WHEEL_ZOOM(pc, minDist, maxDist, zoomUnit)

    CustomWheelZoom(pc, 1,minDist, maxDist, zoomUnit )
end

function TEST_CANCEL_CUSTOM_WHEEL_ZOOM(pc)
    CustomWheelZoom(pc, 0)
end

-- 은둔자의 통로가서 무녀 마스터 앞에서 테스트.
-- TxHide 테스트
function TEST_TXHIDE(pc)
    local tx = TxBegin(pc);
    TxHideNPC(tx,"MIKO_MASTER")
  
	local ret = TxCommit(tx);
	if ret ~= "SUCCESS" then
        print("tx fail");
        return;
    end
end

-- TxUnHide 테스트
function TEST_TXUNHIDE(pc)
    local tx = TxBegin(pc);

    TxUnHideNPC(tx,"MIKO_MASTER")

    local ret = TxCommit(tx);
	if ret ~= "SUCCESS" then
       print("tx fail");
        return;
    end
end


function TEST_GET_ITEM_COUNT_PARTY_WARE_HOUSE(pc, partyType, itemClassName)
	if RequestLoadPartyInventory(pc, partyType) == 1 then
		for i = 0 , 100 do
			if IsPartyInventoryLoaded(pc, partyType) == 1 then
				break;
			end

			sleep(100);
		end
	end
	return GetItemCountInPartyWareHouse(pc, partyType, itemClassName);
end

function TEST_GIVE_GUILD_EVENT_REWARD(pc, eventID)
    if eventID == nil then
        return;
    end
    local guild = GetGuildObj(pc);
    if guild == nil then
        return;
    end
    local guildID = GetGuildID(pc);
    local eventCls = GetClassByType("GuildEvent", eventID);
    if eventCls == nil then
        return;
    end

    local itemlist, itemcount = SCR_GUILD_EVENT_GIVE_ITEM_LIST(pc, eventCls)
    if #itemlist <= 0 then
        return;
    end
    
    local printable = true;
    local beforeCountList = {};
    local afterCountList = {};
    for l = 1, #itemlist do
        local count = TEST_GET_ITEM_COUNT_PARTY_WARE_HOUSE(pc, PARTY_GUILD, itemlist[l])
        if count == nil then
            printable = false;
        end
        beforeCountList[#beforeCountList + 1] = count;
    end
    local tx = TxBegin(pc);
    for l = 1, #itemlist do
        _TxGiveItemToPartyWareHouse(tx, PARTY_GUILD, itemlist[l], itemcount[l], "GuildEventReward", 0, nil);
    end    
	local ret = TxCommit(tx);
	if ret ~= "SUCCESS" then
        return;
    end
    for l = 1, #itemlist do
        local count = TEST_GET_ITEM_COUNT_PARTY_WARE_HOUSE(pc, PARTY_GUILD, itemlist[l])
        if count == nil then
            printable = false;
        end
        afterCountList[#afterCountList + 1] = count;
    end
    if printable == true then
        for l = 1, #itemlist do
            if beforeCountList[l] + itemcount[l] ~= afterCountList[l] then
                local str = "check item count ";
                str = str .. "[guildID:" .. guildID .. "] ";
                str = str .. "[itemName:" .. itemlist[l] .. "] ";
                str = str .. "[itemcount:" .. itemcount[l] .. "] ";
                str = str .. "[before:" .. beforeCountList[l] .. "] ";
                str = str .. "[after:" .. afterCountList[l] .. "] ";

                IMC_LOG("WARNING_GUILD_EVENT", str);
            end
        end
    end
end

function TEST_GIVE_GUILD_EVENT_REWARD_LOOP(pc, loopCnt)
    local clsList, cnt = GetClassList('GuildEvent');
	for i=0, cnt-1 do
		local cls = GetClassByIndexFromList(clsList, i);
        for j=1, loopCnt do
            TEST_GIVE_GUILD_EVENT_REWARD(pc, cls.ClassID)
        end
    end
end

function SCR_GEN_EVENTNPC_CREATE(pc, column, value)
    local zone_name = GetZoneName(pc)
--    local column = 'ClassID'
--    local value = 'EVENT_1706_FREE_EXPUP_NPC'
--    local value = 'KLAPEDA_FISHING_MANAGER'
    local result2 = SCR_GET_XML_IES('GenType_'..zone_name, column, value)

    local result3
    if  result2 ~= nil and #result2 > 0 then
        result3 = SCR_GET_XML_IES('Anchor_'..zone_name, 'GenType', result2[1].GenType)
	end

    CREATE_NPC(pc, result2[1].ClassType, result3[1].PosX, result3[1].PosY, result3[1].PosZ, result3[1].Direction, result2[1].Faction, GetLayer(pc), result2[1].Name, result2[1].Dialog, result2[1].Enter, result2[1].Range, result2[1].Lv, result2[1].Leave, result2[1].Tactics, nil, nil, nil, result2[1].SimpleAI, result2[1].P_MaxDialog)
end

function TEST_CHAT_PET_EXP(self)
    ExecClientScp(self, "TEST_CLIENT_CHAT_PET_EXP()");
end

function TEST_SHOW_JUNK_SILVER_GACHA(self, invItem)
    ClearItemBalloon(self);
    ShowItemBalloon(self, "{@st43}", "JunkSilverGachaResultInRaidRewardSmall", "", invItem, 5, 1, "junksilvergacha_itembox");
end

function TEST_DUMMYPC_FOR_EXPROP(self,propName)
     local x, y, z = GetPos(self);
    local hp = self.MHP;
    CLEAR_DUMMYPC_FOR_EXPROP(self, propName) -- 한번에 하나만 존재하도록 한다.
    local dpc = CREATE_DUMMYPC_FOR_EXPROP(self,propName, x, y , z) -- 더미를 생성한다.
    if dpc ~= nil then
        _COLORTON_DUMMYPC(self, dpc, 50,50,50,200) -- 컬러톤 설정
        _KNOCKBACK_DUMMYPC(self, dpc, 0, 300,1) -- 넉백
        _PLAYANIM_DUMMYPC(self, dpc, "ASTD") -- 애님고정.
        _BUFF_DUMMYPC(self, dpc, "Bunshin_Debuff", 200)
       SET_HP_DUMMYPC(self, dpc, hp, hp)
    end
    --[[
    COLORTON_DUMMYPC_FOR_EXPROP(self, propName, 50,50,50,200) -- 컬러톤 설정
    KNOCKBACK_DUMMYPC_FOR_EXPROP(self, propName, 0, 300,1) -- 넉백
    PLAYANIM_DUMMYPC_FOR_EXPROP(self, propName, "ASTD") -- 애님고정.
    BUFF_DUMMYPC_FOR_EXPROP(self, propName, "Bunshin_Debuff", 200)
    SET_HP_DUMMYPC_FOR_EXPROP(self, propName,dpc, hp, hp)
    ]]--
end

function TEST_ORSHA(pc) --오르샤로 시작
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    sObj.QSTARTZONETYPE="StartLine2";
    Chat(pc, string.format("%s",sObj.QSTARTZONETYPE));
    ExecClientScp(pc, scp);
end

function TEST_COLONY_SPECIAL_BOSS(pc)
    SetColonyWarBoss(pc);
end

function TEST_COLONY_RESULT_UI(pc, isWin)
    local scp = string.format("COLONY_RESULT_OPEN(%d)", isWin);
    ExecClientScp(pc, scp);
end

function TEST_COLONY_CHANGE_STATE(pc, isStart)    
    TestSetColonyProgress(pc, isStart);
end

function TEST_COLONY_INFO_SET(pc)
    local guildObj = GetGuildObj(pc);
    SetColonyOccupationGuild(guildObj, 'f_rokas_30');
    SetColonyOccupationGuild(guildObj, 'd_abbey_22_4');
    SetColonyOccupationGuild(guildObj, 'd_catacomb_80_2');
    SetColonyOccupationGuild(guildObj, 'd_velniasprison_77_1');
    SetColonyOccupationGuild(guildObj, 'd_firetower_69_1');
    SetColonyOccupationGuild(guildObj, 'f_bracken_43_1');
end

function TEST_GIVE_GUILD_INVENTORY(pc)
    local tx = TxBegin(pc);
    if tx == nil then
        print("tx nil");
        return;
    end
    TxGiveItemToPartyWareHouse(tx, pc, PARTY_GUILD, 'MAC04_103', 1, 'Cheat', 0, nil);
    TxGiveItemToPartyWareHouse(tx, pc, PARTY_GUILD, 'Artefact_630026', 1, 'Cheat', 0, nil);
    TxGiveItemToPartyWareHouse(tx, pc, PARTY_GUILD, 'misc_goldbar', 100, 'Cheat', 0, nil);
    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
        print("success give item to guild inventory!");
    end
end

function TEST_LOG_IN_CPP()
    -- cpp 로깅 테스트
    local triedCount, reason = TestLogErrorCode(); -- 바인드 함수에서 남김.
    print("Result of TEST_LOG_IN_CPP", triedCount, reason);
end

function TEST_LOG_IN_LUA()
    -- lua 로깅 테스트
    local triedCount, stringList = TestGetErrorCode() -- 리스트만 가져옴.

    for i = 1 , triedCount do
        IMC_LOG(stringList[i], "TEST_LOG_IN_LUA");
    end
    print("Result of TEST_LOG_IN_LUA", triedCount, "logged in lua");
end

function TEST_ATTACH_BALLOON(pc)
    local balloon = 'artefact_balloon';
    local node = 'Dummy_balloon';
    AttachBalloon(pc, balloon, node)
end

function TEST_DETACH_BALLOON(pc)
    DetachBalloon(pc);
end

function TEST_BALLOON(pc)
    if IsAttachedBalloon(pc) == 1 then
        TEST_DETACH_BALLOON(pc);
    else
       TEST_ATTACH_BALLOON(pc);
    end
end

function TEST_INVALID_PARAM_TYPE(pc)
    ClearDPKCount(pc, pc);
end

function TEST_PET_RESET_STAMINA(pc)
	local pet = GetSummonedPet(pc);
	RunScript("RESET_PET_STAMINA", pet);
end

function TEST_SET_HIDDEN_QUEST(pc, jobName)
	local cls = GetClass("Job", jobName);
	if nil == cls then
		return;
	end
	if cls.HiddenJob == "NO" then
		return;
	end
	local etc = GetETCObject(pc);
	local tx = TxBegin(pc);
	TxSetIESProp(tx, etc, "HiddenJob_"..jobName, 300);
	local ret = TxCommit(tx);
	SendSysMsg(pc, "COMPLETE");
end

function TEST_SERVER_SCP(pc)
	
	ToAll(ScpArgMsg("GACHA_SITEM_GET_ALLMSG","PC", GetTeamName(pc),"ITEMNAME", "!!!!"))

end

function TEST_ADD_BUFF_MON(pc, buffName)
	local objList, objCount = SelectObject(pc, 200, 'ALL');
	for i = 1, objCount do
		local obj = objList[i];

		AddBuff(pc, obj, buffName);		
	end
end

function TEST_HOLD_HAWK(pc)
	local hawk = GetSummonedPet(pc, PET_HAWK_JOBID);
	SetHoldMonScp(hawk, 1);
end

function TEST_UNHOLD_HAWK(pc)
	local hawk = GetSummonedPet(pc, PET_HAWK_JOBID);
	SetHoldMonScp(hawk, 0);
end

function LUNCH_TEST()

	local bob={}
	bob[1] = "김천"
	bob[2] = "종김"
	bob[3] = "중국집"
	bob[4] = "소공동"
	bob[5] = "샌드위치"
	bob[6] = "한끼"
	bob[7] = "전주맛집"

	print(bob[IMCRandom(1, #bob)])
       end
function SCR_TEST_TP_SHOP_DIALOG(self, pc)

end

function TEST_GET_ACHIEVE_HAIR(pc)
	SCR_SET_ACHIEVE_POINT(pc, "HairColor1", 100)	-- 도제: 흰색
	SCR_SET_ACHIEVE_POINT(pc, "HairColor2", 25)		-- 파퀘: 파란색
	SCR_SET_ACHIEVE_POINT(pc, "HairColor3", 1)		-- 매너클: 분홍색
	SCR_SET_ACHIEVE_POINT(pc, "HairColor4", 500)	-- 하나밍: 검은색
end

function TEST_MANUAL(pc)
	local etc = GetETCObject(pc)
	print("AllowedHairColor", etc.AllowedHairColor)
end

function TEST_DIVIDE_ZERO(pc)
	TestDivideZero(0);
end

function TEST_GET_HAIR(pc)
local etc = GetETCObject(pc);
    local tx = TxBegin(pc);	
	SET_ALLOW_HAIRCOLOR(tx, etc,'black');
	SET_ALLOW_HAIRCOLOR(tx, etc,'blue');
	SET_ALLOW_HAIRCOLOR(tx, etc,'white');
	SET_ALLOW_HAIRCOLOR(tx, etc,'pink');
	local ret = TxCommit(tx);
	if ret == 'SUCCESS'  then
		SendSysMsg(pc, "GainAchieveHairBlack");
		SendSysMsg(pc, "GainAchieveHairBlue");
		SendSysMsg(pc, "GainAchieveHairWhite");
		SendSysMsg(pc, "GainAchieveHairPink");
	end
end

function TEST_LOOKAT(pc)
	RunScript('TEST_SKL_ABIL22', pc);

end

function TEST_SKL_ABIL22(pc)
	local skl = GetSkill(pc, 'Musketeer_HeadShot');
	if nil == skl then
		return;
	end

	local tx = TxBegin(pc);
	TxSetIESProp(tx, skl, "OverHeatGroup", 'HeadShot_OH');
	TxSetIESProp(tx, skl, "SklUseOverHeat", 22000);
	TxSetIESProp(tx, skl, "OverHeatDelay", 22000);
	local ret = TxCommit(tx);
end

function RAID_TEST_SET_ENTER_COUNT(pc)
	local etc = GetETCObject(pc);
	local tx = TxBegin(pc);
	if tx == nil then
		return ;
	end

	TxSetIESProp(tx, etc, 'IndunWeeklyEnteredCount_400', 0);
	print(tx, etc)
	local ret = TxCommit(tx);
	Chat(pc, "set count: "..ret);
end




function TEST_RESET_INDUN_COUNT(pc)
	RunScript("TX_TEST_RESET_INDUN_COUNT", pc);
end

function TX_TEST_RESET_INDUN_COUNT(pc)
	local clslist, cnt  = GetClassList("Indun");
	local tx = TxBegin(pc);
	local etcObj = GetETCObject(pc);
	for i = 0 , cnt do
		local cls = GetClassByTypeFromList(clslist, i);
		if cls ~= nil then
			local propName = 'InDunCountType_' .. cls.PlayPerResetType;
			if etcObj[propName] ~= 0 then
				TxSetIESProp(tx, etcObj, propName, 0);
			end
		end
	end;
	local ret = TxCommit(tx);
end


function TEST_NEXON_PC(pc, state)
	SetPremiumState(pc, state, NEXON_PC);
	if 1 == tonumber(state) then
		AddBuff(pc, pc, 'Premium_Nexon');
	else
		RemoveBuff(pc, 'Premium_Nexon');
	end
end

function TSET_RESET_TOKEN(pc)
	
	local aObj = GetAccountObj(pc);
	
	RunScript("TX_TSET_RESET_TOKEN", pc);
	--RunScript("TX_TSET_RESET_BOOST_TOKEN", pc);
end

function TX_TSET_RESET_TOKEN(pc)
	REMOVE_PREMIUM_BENEFIT(pc, ITEM_TOKEN);
	SetPremiumState(pc, 0, ITEM_TOKEN);
	PremiumItemMongoLog(pc, "TokenTime", "ChetEnd", 0);
end

function TEST_GET_ABILINFO(pc)

	if pc == nil then
		return
	end

	local fndList, fndCount = SelectObject(pc, 150, 'ALL');
	for i = 1, fndCount do
		local eachpc = fndList[i]
		if eachpc.ClassName == 'PC' then

			Chat(pc, "0 : "..eachpc.LearnAbilityID .." ".. eachpc.LearnAbilityTime)
			Chat(pc, "1 : "..eachpc.LearnAbilityID_1 .." ".. eachpc.LearnAbilityTime_1)
			Chat(pc, "2 : "..eachpc.LearnAbilityID_2 .." ".. eachpc.LearnAbilityTime_2)
			Chat(pc, "3 : "..eachpc.LearnAbilityID_3 .." ".. eachpc.LearnAbilityTime_3)
			Chat(pc, "4 : "..eachpc.LearnAbilityID_4 .." ".. eachpc.LearnAbilityTime_4)
			Chat(pc, "5 : "..eachpc.LearnAbilityID_5 .." ".. eachpc.LearnAbilityTime_5)
			
		end

	end
end

function TEST_LIKEIT(pc)
	RunScript('TEST_LIKEIT2', pc, '', 1, "")
end

function TEST_LIKEIT2(pc)

	local fndList, fndCount = SelectObject(pc, 350, 'ALL');
	for i = 1, fndCount do
		if fndList[i].ClassName == 'PC' then

			PLAY_LIKE_IT_DIRECTION(pc,fndList[i])
			break;

		end

	end

end

function TESTLIKEIT3(pc)
	RunScript('TESTLIKEIT2', pc, 'JOB_FLETCHER4_ITEM', 1, "Quest")
end

function TESTLIKEIT4(pc,b,c,d)
	print(b,c,d)
	--PlayEffect(pc, 'I_light012')
	PlayAnim(pc,'PUBLIC_THROW');
	--PlayEffect(pc, "I_force067_ice", 1, 0 , "TOP")

	local flyTime = 0.1;
	local delayTime = 0.2;

	local x, y, z = GetPos(pc);
	--[[
	CFdActor*			fromPosActor = GetThreadFdActor(context, 1);
	CHECK_NULL(fromPosActor);
	
	CFdActor*			target = GetThreadFdActor_Null(context, 2);
	CHECK_NULL(target);

	// ??????
	DWORD forceGuid = GenSkillForceGuid();

	imc::CStringID		eft = context->GetStringID(3, StrID::None);
	float				scale = context->GetFloat(4);
	imc::CStringID		snd = context->GetStringID(5, StrID::None);
	imc::CStringID		finEft = context->GetStringID(6, StrID::None);
	float				finScale = context->GetFloat(7);
	imc::CStringID		finSnd = context->GetStringID(8, StrID::None);
	imc::CStringID		destroy = context->GetStringID(9, StrID::None);
	float				fSpeed = context->GetFloat(10);
	float				easing = context->GetFloat(11);
	float				gravity = context->GetFloat(12);
	float				angle = context->GetFloat(13);
	int					hitIndex = context->GetInt(14);
	float				collRange = context->GetFloat(15);
	float				createLength = context->GetFloat(16);
	float				radiusSpd = context->GetFloat(17);
	]]--

	local fndList, fndCount = SelectObject(pc, 1000, 'ALL');
	for i = 1, fndCount do
	print(fndCount, fndList[i].ClassName )
		if fndList[i].ClassName == 'PC' then
			print('hi')
			PlayForceEffect(pc,fndList[i],"I_spread_out003_light",1.0,"None",
			"None",1.0,"None","None",10.0,
			10.0, 10.0, 10.0, 90, 1.0,
			1.0, 1.0)

		end
	end

	

	--ShootForce(pc, x+10, y+1, z+10, "I_force067_ice", 1.0, "I_light012", 1.4, 1.0, 1.0);
end



function TEST_SURFACE(pc)
	local surface = GetMatierlalItem(pc);
	print(surface);
--	GetClassByStrProp(")
	
end


function ssss(pc)
    PlayEffect(pc, 'I_light012')
end

function ZONE_USER_COUNT(operator, count)
	local txt = "Zone user count :";
	ChatLocal(operator, operator, string.format("%s %d", txt, count));
end

function TESTTEST22(pc)

	--SetPos(pc,-927,-79.949,120);

	local sObj = GetSessionObject(pc, 'ssn_klapeda')    	

	print(sObj.WARP_C_KLAIPE)

end

function layerchange(pc)
    while 1 do
        if GetLayer(pc) ~= 0 then
            SetLayer(pc, 0)
            print('Logic Layer : 0 / Now Layer : '..GetLayer(pc))
            sleep(3000)
        end
        local newlayer = GetNewLayer(pc);
        SetLayer(pc, newlayer)
        print('Logic Layer : '..newlayer..' / Now Layer : '..GetLayer(pc))
        sleep(3000)
    end
    
    
end

function TEST_PACKET(pc)
	--TestCZPacket(pc.Name, pc.JobName, GetJobLv(pc));
	print(pc.Name, pc.JobName, GetJobLv(pc));
end

function GGGAME(pc)
	--ShowSelDlg(pc,0, 'SIAU_FRON_NPC_02_basic02', ScpArgMsg("Auto_wae_PpalLaeLeul_HaLeo_KassNeunJi_MuleoBonDa."), ScpArgMsg("Auto_JongLyo"))
	print(ScpArgMsg("Auto_wae_PpalLaeLeul_HaLeo_KassNeunJi_MuleoBonDa."))
end

function TEST_FOG(pc)

	--print(GetMapFogSearchRate(pc,'f_siauliai_west'))
	--print(GetMapFogSearchRate(pc,'f_katyn_7'))

end

function TEST_SHOWINFO(pc)

	local paramList = {}
	paramList[#paramList + 1] = "MoveType" -- ????? ????
	paramList[#paramList + 1] = "MonRank" --?????
	paramList[#paramList + 1] = "RaceType" -- ????????
	paramList[#paramList + 1] = "Size" -- ?????
	paramList[#paramList + 1] = "ArmorMaterial" -- ????????
	paramList[#paramList + 1] = "Attribute" -- ???? ????
	paramList[#paramList + 1] = "EffectiveAtkType" -- ????????? ????

	local showParamCount = 1;
	local showTime = 6;
	local isShuffle = 1;

	local fndList, fndCount = SelectObject(pc, 300, 'ENEMY');
	for i = 1, fndCount do
		if fndList[i].ClassName ~= 'PC' then
			ShowMonInfoBySKill(fndList[i], paramList, showParamCount, showTime, isShuffle)
			--break;
		end
	end

end

function TEST_SOUND2(pc)

	PlaySound(pc, 'skl_archer_piedpiper_final_1',0);
end

function TEST_SOUND3(pc)

	StopSound(pc, 'skl_archer_piedpiper_final_1');
end

function PRINT_SPP(pc)
	print(pc.SP)
end

function GET_INV_BASEID(pc, classid)

	local temp = GetInvenBaseID(classid)
	print('baseid by zone : ', temp)

end

function RESET_ALL_SKILL(pc)

	print(pc.UsedStat)

	local clslist, cnt  = GetClassList("Skill");
	for i = 0 , cnt - 1 do

		local cls = GetClassByIndexFromList(clslist, i);
		local skillname = cls.ClassName

		print(skillname)

		local skillobj = GetSkill(pc, skillname);

		if skillobj ~= nil then

			local tx = TxBegin(pc);
			print(skillname)
			TxRemoveSkill(pc, skillname);
			--TxSetIESProp(tx, pc, "UsedStat", 0);
			local ret = TxCommit(tx);
			
			print(ret)
			if ret == 'SUCCESS' then
				InvalidateStates(pc);
			end

		end

	end
	
end

function TX_ROLLBACK_BUG_TEST(pc)
	
	local tx = TxBegin(pc);

	if nil == tx then
		return;
	end

		
	local etcObj = GetETCObject(pc);
	if nil == etcObj then
		return;
	end


	
	TxSetIESProp(tx, etcObj, "InDunCountType_100", 88);
	TxSetIESProp(tx, etcObj, "InDunCountType_200", 88);

	local ret = TxCommit(tx);

	


	local tx = TxBegin(pc);

	if nil == tx then
		return;
	end

	Chat(pc,"롤백 test 시작")
	Chat(pc,"테스트를 위해 InDunCountType_100, InDunCountType_200 값을 변경하여 사용합니다. 해당 계정의 인던 입장 횟수가 비정상적으로 늘어날 수 있습니다")
	Chat(pc,"현재 값 " .. etcObj["InDunCountType_100"] .. " " .. etcObj["InDunCountType_200"])
	Chat(pc,"88 88 을 99 99 로 바꾸려고 시도합니다.")


	TxSetIESProp(tx, etcObj, "InDunCountType_100", 99);
	--TxSetIESProp(tx, etcObj, "InDunCountType_200", 99);
	TxSetIESProp(tx, nil, "InDunCountType_200", 99);

	local ret = TxCommit(tx);
	Chat(pc,"트랜잭션 결과 : " .. ret)


	Chat(pc,"결과 값 " .. etcObj["InDunCountType_100"] .. " " .. etcObj["InDunCountType_200"])
	Chat(pc,"결과가 88 88  이거나 99 99 이어야 합니다. 88 99 이거나 99 88 인 경우 버그")



end


function TEST_ABIL(pc, abilName)
	local runCnt = 0;
	for i = 0, RUN_ABIL_MAX_COUNT do
		local prop = "None";
		if 0 == i then
			prop = "LearnAbilityID";
		else
			prop = "LearnAbilityID_" ..i;
		end
		if pc[prop] ~= nil and pc[prop] > 0 then
			runCnt = runCnt +1;
		end
	end

	local abilLevel = 1;
	local abilObj = GetAbilityIESObject(pc, abilName);
	if abilObj ~= nil then
		abilLevel = abilObj.Level + 1;
	end

	local tx = TxBegin(pc);
	if abilObj == nil then
		local idx = TxAddAbility(tx, abilName);
		TxAppendProperty(tx, idx, "Level", 1);
		local ablCls = GetClass("Ability", abilName)
		if ablCls ~= nil then
			local txScpName = TryGetProp(ablCls, 'ScriptTX')
			if nil ~= txScpName and 'None' ~= ablCls.ScriptTX then
				local func = _G[ablCls.ScriptTX];
				if false == func(pc, tx, 1) then
					TxRollBack(tx)
					return;
				end
			end
		end
	else
		TxSetIESProp(tx, abilObj, "Level", abilLevel);
	end
	local propID = "LearnAbilityID_" ..runCnt+1;
	if pc[propID] ~= 0 then
		TxSetIESProp(tx, pc, propID, 0);
	end
	local propTime = "LearnAbilityTime_" ..runCnt+1;
	if pc[propTime] ~= "None" then
		TxSetIESProp(tx, pc, propTime, "None");
	end

	local ret = TxCommit(tx);
		
	if ret == 'SUCCESS' then
		PlayEffect(pc, 'F_circle020_light', 1.0);
		local AbilityIES = GetClass("Ability", abilName);
		if AbilityIES ~= nil then
			local skillProp = GetClass("Skill", AbilityIES.SkillCategory);
			if skillProp ~= nil then
				UpdateSkillPropertyBySkillID(pc, skillProp.ClassID)
			end
		end
		
		InvalidateStates(pc);
		local shopName = GetExProp_Str(pc, "ABILSHOP_OPEN");
		SendAddOnMsg(pc, "RESET_ABILITY_UP", shopName, 0);
	end

end

function minmax(pc)
	--print(pc)
	--print(pc.Atk)

	SCR_Get_MINATK(pc)

	--print(pc[MAXATK],pc[MINATK],pc[ATK])
	
end

function asdd(pc)


	local qxwe = ScpArgMsg("Pc{Auto_1}MakeBidBy{Auto_2}Silver","Auto_1",123,"Auto_2","auto2");


	local qwe = ScpArgMsg("{Bidder}IsTopBidderOf{ItemName}", "Bidder", "asdd", "ItemName", "sdad");
	--local qwe = ScpArgMsg("Todays_Tip");
	print(qwe)
	print(qxwe)
end

function ttt(pc)
	--fff(ScpArgMsg('Auto_Han$CKeuli_KkyeoissDang_$BHiHiHi_duddjeh$A..'),1,ScpArgMsg('Auto_Heh'),3,4,5)

	local monCls = GetClassByType("Monster", 400001);
	SysMsg(pc, "Item", "asd");
	local temp2 = ScpArgMsg("Todays_Tip");
	print(temp2)
	

	local testtest = ClMsg("%sKilled%s");
	
	print (ClMsg("%sKilled%s"))

	fff(testtest)
end

function fff(msg, ...)

	local tempstr = msg
	local testtable = {...}
	
	for i = 1, #testtable do
		local tempchar = '$'..string.char(i+64);
		tempstr = string.gsub(tempstr, tempchar, testtable[i],1)
    end

	if tempstr ~= msg then
		print(ScpArgMsg('Auto_Sae_inJa_HyeongSigi_iss2Kun!'))
	else
		print(ScpArgMsg('Auto_Sae_inJa_HyeongSigi_eopKun!'))
	end

	print(tempstr)
end

function oifjwjfoiwejf(self)
	print('asd')
	local x,y,z = GetPos(self)
	ShowGroundMark(self, x, y, z, 230, 40);
end


function CHANGEJOB_OPEN()
	print('open');
end

function CHANGEJOB_CLOSE()
	print('close');
end

function HELPLIST(pc)
	UIOpenToPC(pc, 'helplist', 1);
end

function CJOBV_TEST(pc)
	print('hsi')
	local etcObj = GetETCObject(pc);
	print('hi2')
	print(etcObj)
	print(etcObj.JobChanging)
	--etcObj.JobChanging='HI'
end

function TEST_NOWLAYER(pc)
	local test2 = GetLayer(pc);
	print(GetLayer(pc));
	Chat(pc, test2);
end

function TEST_LL0(pc)
	SendAddOnMsg(pc, "NOTICE_Dm_!", "SSSSSSSSSSSSSSS", 5)
end

function TEST_LL1(pc)
	SetLayer(pc, 1)
end

function questtracknpcmove(pc, questname)
    local questautoIES = GetClass('QuestProgressCheck_Auto', questname)
    local questIES = GetClass('QuestProgressCheck', questname)
    local trackinfo = questautoIES.Track1
    local tracklist = SCR_STRING_CUT(trackinfo)
    if tracklist ~= nil and #tracklist > 2 then
        local state_zone
        local state_npc
        if tracklist[1] == 'SPossible' then
            state_zone = 'StartMap'
            state_npc = 'StartNPC'
        elseif tracklist[1] == 'SProgress' then
            state_zone = 'ProgMap'
            state_npc = 'ProgNPC'
        elseif tracklist[1] == 'SSuccess' then
            state_zone = 'EndMap'
            state_npc = 'EndNPC'
        end
        
        npcmove(pc, questIES[state_npc], questIES[state_zone])
    end
end

function tracktest(pc, questname)
    local questautoIES = GetClass('QuestProgressCheck_Auto', questname)
    local trackinfo = questautoIES.Track1
    local tracklist = SCR_STRING_CUT(trackinfo)
    if tracklist ~= nil and #tracklist > 2 then
        local quest_state
        if tracklist[1] == 'SPossible' then
            quest_state = 'Possible'
        elseif tracklist[1] == 'SProgress' then
            quest_state = 'Progress'
        elseif tracklist[1] == 'SSuccess' then
            quest_state = 'Success'
        end
        
        SCR_TRACK_START(pc, questname, trackinfo, quest_state)
    end
end

function TRACK_PARTY_TEST(pc, questname)

	SetLayer(pc, 0);
	
	local myParty = GetPartyObj(pc);
	if myParty == nil then
		tracktest(pc, questname);
		print('no party')
		return;
	end

	local partyPlayerList, cnt = GET_PARTY_ACTOR(pc, 0);
	if cnt <= 1 then
		tracktest(pc, questname);
		print('no party member')
		return;
	end

	local questautoIES = GetClass('QuestProgressCheck_Auto', questname);
	if questautoIES == nil then
		return;
	end

	local list = SCR_STRING_CUT(questautoIES.Track1);	
	if list[3] == nil then
		return;
	end

	local quest_track1 = _G[list[3]];
	local isdirection = IsDirectionExist(list[3])
    if quest_track1 ~= nil or isdirection == 1 then
        if list[5] ~= nil and list[5] ~= 'None' then
            PlayMusicQueueLocal(pc, list[5])
            sleep(100)
        end

        local pc_layer_1 = GetLayer(pc)
		local sObj = GetSessionObject(pc, 'ssn_klapeda')    	
    	local questIES = GetClass('QuestProgressCheck', questname)

    	if IsPlayingDirection(pc) > 0 then
    		return;
    	end
    	
		if questautoIES.Track_PartyPlay == 'YES' then
            for i = 1, cnt do
            	if IsSameActor(partyPlayerList[i], pc) == 'NO' then
                	if GetLayer(partyPlayerList[i]) == 0 and IsPlayingDirection(partyPlayerList[i]) ~= 1 then
                		local sObjPartyPC = GetSessionObject(partyPlayerList[i], 'ssn_klapeda')
                		sObjPartyPC.TRACK_QUEST_NAME = questname                    	
                	end
                else
                	sObj.TRACK_QUEST_NAME = questname
                end
            end
        end
        
    	if isdirection == 1 then
            PlayDirection(pc, list[3], 0, 1);
        elseif quest_track1 ~= nil then
            quest_track1(pc)
        end
                    
		local trackInPartyPC = 1
		if questautoIES.Track_PartyPlay == 'YES' then
            for i = 1, cnt do
            	if IsSameActor(partyPlayerList[i], pc) == 'NO' then
                	if GetLayer(partyPlayerList[i]) == 0 and IsPlayingDirection(partyPlayerList[i]) ~= 1 then
                		local sObjPartyPC = GetSessionObject(partyPlayerList[i], 'ssn_klapeda')
                		if sObjPartyPC.TRACK_QUEST_NAME == questname then                			
                    		RunZombieScript("SCR_TRACK_PARTYPLAY_CHEAT", partyPlayerList[i], pc, questname, list[1], i, isdirection);    		    			
                	    end
                	end
                end
            end
        end
               			
		if isdirection == 1 then			    					
			StartDirection(pc);
		end
		
		for i = 1, cnt do
			local sObjPartyPC = GetSessionObject(partyPlayerList[i], 'ssn_klapeda')
			if sObjPartyPC ~= nil then
    			if sObjPartyPC.TRACK_QUEST_NAME == questname then
    				sObjPartyPC.TRACK_QUEST_NAME = 'None'
    			end
    		end
		end
		
        SetTrackName(pc, questname);
        local pc_layer_2 = GetLayer(pc)
        if pc_layer_1 ~= pc_layer_2 then           			    
            if sObj ~= nil then
               	local tx = TxBegin(pc);
                if sObj[questIES.QuestPropertyName] < 0 then
                    local value = 11
                    TxSetIESProp(tx, sObj, questIES.QuestPropertyName, value);
					QuestStateMongoLog(pc, questIES.QuestPropertyName, "StateChange", "State", value);
                else
                    local value = sObj[questIES.QuestPropertyName] + 10
                    TxSetIESProp(tx, sObj, questIES.QuestPropertyName, value);
					QuestStateMongoLog(pc, questIES.QuestPropertyName, "StateChange", "State", value);
                end
                            
                            
                local quest_sObj
                if  questIES.Quest_SSN ~= 'None' and questIES.Quest_SSN ~= '' then
                    quest_sObj = GetSessionObject(pc, questIES.Quest_SSN);
                    if quest_sObj == nil then
                        TxCreateSessionObject(tx, questIES.Quest_SSN);
                    end
                end
                            
                            
                local ret = TxCommit(tx, 1);
                    		
                if ret == 'FAIL' then
                    print(questIES.Name,'SCR_TRACK_START Transaction FAIL')
                else
                    if questIES.Quest_SSN ~= 'None' and questIES.Quest_SSN ~= '' then
                    	if quest_sObj == nil then
                            quest_sObj = GetSessionObject(pc, questIES.Quest_SSN)
                        end
                        if quest_sObj ~= nil then
                            if GetPropType(quest_sObj,'Countdown_StartType') ~= nil and GetPropType(quest_sObj,'Countdown_Time') ~= nil then
                                if quest_sObj.Countdown_StartType == 'TrackStart' and quest_sObj.Countdown_Time > 0  then
                                    SCR_QUEST_COUNTDOWN_FUNC(pc, quest_sObj)
                                                
                                end
                            end
                        end
                    end
                end
            end
                		
            local obj = GetLayerObject(GetZoneInstID(pc), GetLayer(pc));
            if obj ~= nil then
                obj.EventName = questname
                obj.EventOwner = pc.Name
                BroadLayerObjectProp(pc, 'EventName')
                BroadLayerObjectProp(pc, 'EventOwner')
            end
        end   
    end
end

function SCR_TRACK_PARTYPLAY_CHEAT(partyPlayer, pc, questname, trackSteate, pcIndex, isdirection)

	if GetLayer(partyPlayer) == 0 and IsPlayingDirection(partyPlayer) ~= 1 then
        CloseDlg(partyPlayer)
		

		local pos_list = SCR_CELLGENPOS_LIST(pc, 'Basic5', 0)
		local zoneInsID = GetZoneInstID(pc)
                
		local x = pos_list[pcIndex%(#pos_list) + 1][1]
		local y = pos_list[pcIndex%(#pos_list) + 1][2] + 70
		local z = pos_list[pcIndex%(#pos_list) + 1][3]
        
		if IsValidPos(zoneInsID, x, y, z) == 'YES' then
		else
			local flag = 0
            
			for i = 1, 100 do
				local index = IMCRandom(1,#pos_list)
				x = pos_list[index][1]
				y = pos_list[index][2] + 30
				z = pos_list[index][3]
				if IsValidPos(zoneInsID, x, y, z) == 'YES' then
					flag = 100
					break
				end
			end
            
			if flag == 0 then
				x, y, z = GetPos(pc)
			end
		end  

		if GetLayer(partyPlayer) == 0 and IsPlayingDirection(partyPlayer) ~= 1 then

			if isdirection == 1 then
				AddDirectionPC(pc, partyPlayer);
			end
		
    		LookAt(partyPlayer, pc);
   	
			if isdirection ~= 1 then
    			SetLayer(partyPlayer, GetLayer(pc))	    
    		end

    		RunZombieScript("SCR_TRACK_PARTYPLAY_SOBJ", partyPlayer, questname, trackSteate);		

			if isdirection == 1 then
				sleep(500);
				PlayAnim(partyPlayer,'ASTD');
				sleep(500);
				ReadyDirectionPC(pc, partyPlayer);
				return;
    		end
		end

		sleep(500)
		PlayAnim(partyPlayer,'ASTD');
	
    end
end

function fadetest(pc)
  
    SetLayer(pc, 0)
  
end

function TEST_FILE(file_name, file_txt)
--    local text_w = io.open('c:\\'..file_name..'.txt','w')
    local text_w = io.open('..\\release\\questauto\\CCCC.txt','w')
    
    if text_w ~= nil then
        local t = text_w:read('*all')
        text_w:write(t,string.char(10),string.char(10),'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\',string.char(10),string.char(10));
        
        text_w:write("SSSS")
        io.close(text_w)
    end 
end
--
--
--    range = tonumber(range)
--    maxcount = tonumber(maxcount)
--    
--    if range ~= nil and maxcount ~= nil and maxcount > 0 and range > 0 then
--        local random_list = io.open('c:\\test_random.txt','w')
--        local i
--        
--        for i = 1, maxcount do
--            random_list:write(IMCRandom(1, range),string.char(10))
--        end
--        
--        io.close(random_list)
--    end
    
    
    
function BUFF_TEST(self, buffname)
    local list, Cnt = SelectObject(self, 150, 'ALL')
	print(list, Cnt)
    local i
    for i = 1, Cnt do
        if list[i].ClassName ~= 'PC' then
            AddBuff(self, list[i], buffname, 1, 1, 100000, 1)
        end
    end
end

function LYG_COLOR(self, pc)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER(self, "Beetle", x-30, y, z-30, 225, 'Monster', GetLayer(self), 39, 'MON_LYG_TEST', ScpArgMsg('Auto_SiDeuMaieong'), nil, nil, 0, nil, nil,'Dummy');
end

function help_test(pc,help_name)
    AddHelpByName(pc, 'TUTO_CAMPWARP')
end

function wmopen(pc, all)	
	
	local pcetc = GetETCObject(pc);
	local accObj = GetAccountObj(pc);

    local flag = "NO"
    local classCount = GetClassCount("Map")
	
	local tx = TxBegin(pc);

    for i = 0 , classCount -1 do
        local mapIES = GetClassByIndex("Map", i)
        if accObj['HadVisited_' .. mapIES.ClassID] ~= 1 and mapIES.WorldMap ~= 'None'  then
            if all == 1 then
				TxSetIESProp(tx, accObj, 'HadVisited_' .. mapIES.ClassID, 1);
        		flag = "YES"
        	else
        	    if mapIES.WorldMapPreOpen == 'YES' then
					TxSetIESProp(tx, accObj, 'HadVisited_' .. mapIES.ClassID, 1);
            		flag = "YES"
        	    end
        	end
    	end
    end

	TxCommit(tx);
    
    if flag == "YES" then
        SendUpdateWorldMap(pc);
    end
end

function lchs_test2(pc, str)
    AttachEffect(pc, 'I_cleric_zemina_mash_loop_blue_1', 0.5, 'BOT')
end
function lchs(pc, anim_name)
    DOTIMEACTION_R(pc, "AAA", "BURY", 2, nil)
--    print('AAAAAAAAA',GetTeamName(pc),GetPartyID(pc))
--    PlayDirection(pc, 'DRESS_TRACK_1')
--    local obj, cnt = GetWorldObjectList(pc, "PC", 300)
--    if cnt > 0 then
--        for i = 1, cnt do
--            local npc = obj[i]
--            PlayPose(pc, 38)
--        end
--    end

--    local tx = TxBegin(pc);
--    TxAddAchievePoint(tx, 'PlayCBT1', 1)
--    local ret = TxCommit(tx);
--    PlayDirection(pc, 'BARBER_TRACK_2')
--    local aObj = GetAccountObj(pc)
--    local teamNameFirstSet = TryGetProp(aObj, 'TeamNameFirstSet')
--    print('XXXXXXX',teamNameFirstSet)
--    SetHide(pc, 1)
--    RemoveBuff(pc, 'MISSION_SURVIVAL_EVENT2')
--    print('AAAAAAAA',IsBuffApplied(pc,'MISSION_SURVIVAL_EVENT2'),pc.MHP_BM)
--    AttachEffect(pc, 'I_force018_trail_black_800', 1, 'BOT')
--    AttachEffect(pc, 'F_pattern013_ground_white', 1, 'BOT')
--    PlayEffect(pc, "F_explosion054_green", 1.5)
--    local obj, cnt = GetWorldObjectList(pc, "MON", 200)
--    if cnt > 0 then
--        for i = 1, cnt do
--            local npc = obj[i]
--                InsertHate(npc, pc, 100)
--                TakeDamage(pc, npc, "None", 10, nil, nil, 'AbsoluteDamage');
----            ClearEffect(npc)
----            AttachEffect(npc, 'I_smoke001_dark_loop', 1, 'BOT')
--            print('AAAAA')
--        end
--    end
    
    
--    local result = DOTIMEACTION_R(pc, ScpArgMsg("KATYN14_SUB_08_MSG03"), 'WORSHIP', 5)
--    print(GetAccountPCCount(pc))
--    local list, Cnt = SelectObject(pc, 50, 'ALL')
--    local i
--    for i = 1, Cnt do
--        Chat(list[i], 'AAA'..GetCurrentFaction(list[i]), 5)
--    end
--    REQ_MOVE_TO_INDUN(pc, "MISSION_EVENT_1708_JURATE", 1)

--    ShowOkDlg(pc, 'EVENT_1707_COMPASS_DLG29', 1)
    
--    local couponValueList = {
--                            {'AAA',9,3},
--                            {'BBBB',2,4},
--                            {'CCC',10,5},
--                            {'DDD',100,6},
--                            {'EEE',3,7},
--                            {'FFF',6,8},
--                            {'GGG',73,9},
--                            }
--    for i = 1, #couponValueList - 1 do
--        for x = i + 1, #couponValueList do
--            if couponValueList[i][2] < couponValueList[x][2] then
--                local temp = {couponValueList[i][1],couponValueList[i][2],couponValueList[i][3]}
--                couponValueList[i] = {couponValueList[x][1],couponValueList[x][2],couponValueList[x][3]}
--                couponValueList[x] = temp
--            end
--        end
--    end
--    for i = 1, #couponValueList do
--        print(table.concat(couponValueList[i],"/"))
--    end
    
    
    
--    print('SSSSSSS')
--    local tx = TxBegin(pc);
--    TxAddAchievePoint(tx, 'EVENT_1707_USERWEDDING', 1)
--	local ret = TxCommit(tx)
--    PlayAnim(pc, "WORSHIP", 1);
--    REQ_MOVE_TO_INDUN(pc, "Request_Mission11", 1)
    
    
--    UIOpenToPC(pc,'fullblack',1)
--    
--    sleep(1000)
--    UIOpenToPC(pc,'fullblack',0)
    
--    for i = 201, 280 do
--        local itemList, monList = DROPITEM_REQUEST1_PROGRESS_CHECK_FUNC_SUB(pc, i)
--        print(i..' : '.. #itemList..' : '..#monList)
--    end
--    local missionID = OpenMissionRoom(pc, "catacomb_2", "");
--    print('AAA',missionID)
--    ReqMoveToMission(pc, missionID)


----    ChangePartyProp(pc, PARTY_NORMAL, 'P_PARTY_Q_070', 0)
--    local partyObj = GetPartyObj(pc)
--    for i = 1, 10 do
--        local test
--        if i < 10 then
--            test = 'P_PARTY_Q_0'..i..'0'
--        else
--            test = 'P_PARTY_Q_0'..i
--        end
----        print('AAA'..i..' : '..partyObj[test])
--        ChangePartyProp(pc, PARTY_NORMAL, test, 0)
--        print('BBB'..i..' : '..partyObj[test])
--    end
----    local now_time = GetServerDBTimeString()
----                local year = tonumber(string.sub(now_time,1,4))
----                local month = tonumber(string.sub(now_time,5,6))
----                local day = tonumber(string.sub(now_time,7,8))
----                local yday = SCR_MONTH_TO_YDAY(year,month,day)
----                local hour = tonumber(string.sub(now_time,9,10))
----                print('XXXXXXX',year, yday, hour)
end

function qa_test1(pc)
	print("123")
	print("Normal")
	print("test1")
	local asd = 123456;
	local str1 = "Hello "
	local str2 = "world!"
	IMCLOG_CONTENT("TagQATest", "AIDX : ", asd," " , str1, str2);
end

function test_random (pc,range,maxcount)
    range = tonumber(range)
    maxcount = tonumber(maxcount)
    
    if range ~= nil and maxcount ~= nil and maxcount > 0 and range > 0 then
        local random_list = io.open('c:\\test_random.txt','w')
        local i
        
        for i = 1, maxcount do
            random_list:write(IMCRandom(1, range),string.char(10))
        end
        
        io.close(random_list)
    end
end


function test_box1(pc)
    local x,y,z = GetPos(pc)
    CREATE_MONSTER(pc, 'Box1', x,y,z, 90, 'Monster', GetLayer(pc), 1, 'MON_DUMMY')
end

function skl_test(pc)
    local objList, objCount = SelectObject(pc, 30, 'ALL');
    for index = 1, objCount do
--        print(GetBTreeName(objList[index]))
--        print('AAA',objList[index].ClassName,GetBTreeName(objList[index]),GetUsingSkill(objList[index]).ClassName)
        if GetBTreeName(objList[index]) == 'Aos_Law_Archer' then
            if GetUsingSkill(objList[index]).ClassName == 'Archer_SweepShot' then
            end
        end
    end
end

function table_text(table1)
    local i
    for i = 1, #table1 do
        if #table1[i] > 0 then
            print(table1[i])
        else
            table_text(table1)
        end
    end
end

function getachieve(pc, pointname)
    print(pointname, 'Point: ',GetAchievePoint(pc,pointname))
end

function teste1(pc)
    RaiseMinigameEvent(pc)
end

function teste2(pc)
    local act_list, act_count = GetMinigameObjectList(pc)
    
    print(#act_list)
end

function test_notice(pc)
    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_aiTem_HoegDeug"), 2);
end

function hidenpc_test(pc)
    local x, y, z = GetPos(pc)
    HideNPC(pc, 'SIAULEI_CORPSE', x, z, 0)
end

function uistate(pc, uistate_property, value)
    print(pc.sysmenu)
    print(pc.quest)
    print(pc.quickslotnexpbar)
    print(pc.skillvan)
    print(pc.inventory)
    print(pc.status)
    print(pc.map)
    print(pc.minimap)
    if uistate_property ~= nil then
        local tx = TxBegin(pc);
        TxSetIESProp(tx, pc, uistate_property, tonumber(value))
        local ret = TxCommit(tx);
    	
	end

    print('^^^^^^^^^')
end

function GET_HIS_ABIL(pc)

    local list, Cnt = SelectObject(self, 150, 'ALL')
    local i
    for i = 1, Cnt do
        if list[i].ClassName == 'PC' then
			local str = tostring(list[i].LearnAbilityID)
            Chat(pc, tostring(list[i].LearnAbilityID).." "..tostring(list[i].LearnAbilityID_1).." "..tostring(list[i].LearnAbilityID_2).." "..tostring(list[i].LearnAbilityID_3).." "..tostring(list[i].LearnAbilityID_4).." "..tostring(list[i].LearnAbilityID_5));		
        end
    end
end


function find_test(pc, x1, z1, x2, z2)
    local zoneinstID = GetZoneInstID(pc);
    print(FindPath(zoneinstID, 1, x1, z1, x2, z2))
end

function PCDATA_OUT (pc,questname)
    pcdata_out = io.open('c:\\PCDATA_OUT_'..pc.Name..'.txt','w')


    pcdata_out:write('PC Name :','	',pc.Name,string.char(10))
    pcdata_out:write('PC Lv :','	',pc.Lv,string.char(10))

    local pcdata_sObj = GetSessionObject(pc, 'ssn_pcdata')

    local i
    local now_lv = pc.Lv

    if now_lv > 20 then
        now_lv = 20
    end

    for i = 1, now_lv do
        pcdata_out:write(i,ScpArgMsg('Auto_LeBele_Jugin_MonSeuTeo_Su_:'),'	',pcdata_sObj['KillCount_PCLv'..i],string.char(10))
    end

    pcdata_out:write(string.char(10))

    for i = 1, 20 do
        if pcdata_sObj['KillCount_MONLv'..i] > 0 then
            pcdata_out:write(ScpArgMsg('Auto_Jugin_'),i,ScpArgMsg('Auto_LeBel_MonSeuTeo_Su_:'),'	',pcdata_sObj['KillCount_MONLv'..i],string.char(10))
        end
    end

    pcdata_out:write(string.char(10))

    for i = 1, now_lv do
        if pcdata_sObj['KillTimeCountLv'..i] > 0 then
            pcdata_out:write(i,ScpArgMsg('Auto_LeBele_1MaLi_SaNyang_Si_PyeongKyun_SoMoSiKan_:'),'	',pcdata_sObj['KillTimeSumLv'..i]/pcdata_sObj['KillTimeCountLv'..i],ScpArgMsg('Auto_(Cho)'),string.char(10))
        end
    end

    pcdata_out:write(string.char(10))

    for i = 1, now_lv do
        if i < pc.Lv then
            if pcdata_sObj['KillTimeCountLv'..i] > 0 then
                pcdata_out:write(i,'->',i+1,ScpArgMsg('Auto_LeBeleope_KeolLin_SiKan_:'),'	',pcdata_sObj['KillTimeSumLv'..i]/pcdata_sObj['KillTimeCountLv'..i] * pcdata_sObj['KillCount_PCLv'..i],ScpArgMsg('Auto_(Cho)'),string.char(10))
            end
        end
    end

    io.close(pcdata_out)
end


function TEST_QUICKSLOT(pc)

	RegisterQuickSlot(pc, "Skill", "Swordman_Bash", -1);

end

function TEST_MONOWNER(pc)

	local x, y, z = GetPos(pc);
	local mon = CREATE_MONSTER(pc, "Goblin_Spear", x, y, z, -15, "Monster", 0, 12, "MON_SUMMON");
	SetOwner(mon, pc, 1);
	BroadcastRelation(mon);

	ChangeTacticsState(mon, "TS_BATTLE");
	
end

function TEST_MON_APC(pc, name)

	if name == nil then
		return;
	end

	local mon = GET_NEAR_MON(pc);
	if mon == nil then
		return;
	end

	ChangeModel(mon, name);


end

function TEST_MON_BUFF(pc)

	local mon = GET_NEAR_MON(pc);
	if mon == nil then
		return;
	end

	AddBuff(pc, mon, "CriticalWound");

end

function TEST_MONSOBJ(pc)

	local mon = GET_NEAR_MON(pc);
	if mon == nil then
		return;
	end

	Chat(mon, "CreateSObj");
	CreateSessionObject(mon, "ssn_feBoss");
	local sObj = GetSessionObject(mon, "ssn_feBoss");
	
end

function TEST_RULLET(pc)

	local zoneInst = GetZoneInstID(pc);
	RulletToPC(pc, "Basic", "Rullet");

end

function TEST_FINC(pc)
	local x, y, z = GetPos(pc);
	local mon = CREATE_MONSTER(pc, "Goblin_Spear", x, y, z, 0, "Monster", 0, 12, "MON_SAA");
	ChangeTacticsState(mon, "TS_BATTLE");

end


function money_hi_test(pc, mon_lv, cnt)

	if cnt == nil then
		cnt = 1;
	end
	for i = 1 , cnt do
    local iesObj
    local x, y, z = GetPos(pc);
	iesObj = CreateGCIES('Monster', 'Moneybag1');
	iesObj.ItemCount = 1;
	local item = CreateItem(pc, iesObj, x-20, y, z-20, 0, 5);

	if item ~= nil then
	    SetTacticsArgFloat(item, 0, 0, 100)
		local self_layer = GetLayer(pc);
		if self_layer ~= nil and self_layer ~= 0 then
			SetLayer(item, self_layer);
		end
	end
end
end

function md1(pc, mon_lv)
    local drop_sObj = GetSessionObject(pc, 'ssn_drop')
    print('Money_Hi_BN'..drop_sObj.Money_Hi_BN)
    print('Money_Mid_BN'..drop_sObj.Money_Mid_BN)
    print('Money_Low_BN'..drop_sObj.Money_Low_BN)
    print('Etc_Hi_BN'..drop_sObj.Etc_Hi_BN)
    print('Etc_Mid_BN'..drop_sObj.Etc_Mid_BN)
    print('Etc_Low_BN'..drop_sObj.Etc_Low_BN)
    print('Money_Session1'..drop_sObj.Money_Session1)
    print('Money_Session2'..drop_sObj.Money_Session2)
    print('Money_Session3'..drop_sObj.Money_Session3)
    print('Money_Session4'..drop_sObj.Money_Session4)
    print('Money_Session5'..drop_sObj.Money_Session5)
    print('Money_Session6'..drop_sObj.Money_Session6)
    print(GetClassNumber('Xp',pc.Lv,'Session'))
    print(GetClass('Xp',tostring(pc.Lv)))
end

function md2(pc, mon_lv)
    local drop_sObj = GetSessionObject(pc, 'ssn_drop')
    print('Money_Hi_BN'..drop_sObj.Money_Hi_BN)
    print('Money_Mid_BN'..drop_sObj.Money_Mid_BN)
    print('Money_Low_BN'..drop_sObj.Money_Low_BN)
    print('Etc_Hi_BN'..drop_sObj.Etc_Hi_BN)
    print('Etc_Mid_BN'..drop_sObj.Etc_Mid_BN)
    print('Etc_Low_BN'..drop_sObj.Etc_Low_BN)
    print('Exp_Hi_BN'..drop_sObj.Exp_Hi_BN)
    print('Money_Session1'..drop_sObj.Money_Session1)
    print('Money_Session2'..drop_sObj.Money_Session2)
    print('Money_Session3'..drop_sObj.Money_Session3)
    print('Money_Session4'..drop_sObj.Money_Session4)
    print('Money_Session5'..drop_sObj.Money_Session5)
    print('Money_Session6'..drop_sObj.Money_Session6)
    print('Exp_Session1'..drop_sObj.Exp_Session1)
    print('Exp_Session2'..drop_sObj.Exp_Session2)
    print('Exp_Session3'..drop_sObj.Exp_Session3)
    print('Exp_Session4'..drop_sObj.Exp_Session4)
    print('Exp_Session5'..drop_sObj.Exp_Session5)
    print('Exp_Session6'..drop_sObj.Exp_Session6)
    print(GetClassNumber('Xp',pc.Lv,'Session'))
    print(GetClass('Xp',tostring(pc.Lv)))
end

function md(pc, mon_lv)
--    local drop_sObj = GetSessionObject(pc, 'ssn_drop')
--    print('Money_Hi_BN'..drop_sObj.Money_Hi_BN)
--    print('Money_Mid_BN'..drop_sObj.Money_Mid_BN)
--    print('Money_Low_BN'..drop_sObj.Money_Low_BN)
--    print('Etc_Hi_BN'..drop_sObj.Etc_Hi_BN)
--    print('Etc_Mid_BN'..drop_sObj.Etc_Mid_BN)
--    print('Etc_Low_BN'..drop_sObj.Etc_Low_BN)
--    print('Money_Session1'..drop_sObj.Money_Session1)
--    print('Money_Session2'..drop_sObj.Money_Session2)
--    print('Money_Session3'..drop_sObj.Money_Session3)
--    print('Money_Session4'..drop_sObj.Money_Session4)
--    print('Money_Session5'..drop_sObj.Money_Session5)
--    print('Money_Session6'..drop_sObj.Money_Session6)

    local x,y,z = GetPos(pc)
    local iesObj
    iesObj = CreateGCIES('Monster', 'Goblin_Spear');
    iesObj.Lv = tonumber(mon_lv)
	iesObj.Tactics = 'MON_BASIC';
	local mon = CreateMonster( pc, iesObj, x, y, z,0, 5);
	if mon ~= nil then
	    mon.MHP = 1
	end
end

function DLG_TEST(pc, dlg)

	ShowOkDlg(pc, dlg, 1);

end

function TEST_TEMP_UNHIDE(pc)
    UnHideNPC(pc, 'HUEVILLAGE_58_4_SAULE_BEFORE')
    UnHideNPC(pc, 'VPRISON515_MQ_VAKARINE')
    UnHideNPC(pc, 'CHATHEDRAL53_MQ_BISHOP')
    UnHideNPC(pc, 'SIAULIAI_46_2_AUSTEJA')
    UnHideNPC(pc, 'REMAINS40_GRITA')
end

function CP(pc, name, value)

	RunScript("CP_", pc, name, value);
end

function CP_(pc, name, value)

	local tx = TxBegin(pc);
	TxSetIESProp(tx, pc, name, value);
	local ret = TxCommit(tx);
	
	print(name .. " " .. value);

end

function G_MON(pc, groupName)

	local layer = GetLayer(pc);
	local x, y, z = GetPos(pc);
	CRE_GROUP_MON(pc, groupName, x, y, z, "Monster", layer);

end

function GMG(pc, groupName)

	if groupName == nil or groupName == 0 then
		groupName = "Event1";
	end

	G_MON(pc, groupName);
end

function EVT_RESET(pc)

	local clsList, cnt = GetClassList("FieldEvent");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		CP(pc, 	cls.CheckProp, 0);

	end
end

function EVT(pc, type)

	RaiseFieldEvent(pc, type);

end

function START_EVT(pc, type)

	StartFieldEvent(pc, type);

end

function ss(pc)

	SendAddOnMsg(pc, "NOTICE_Dm_levelup_base", ScpArgMsg("Auto_KilDeu_uiLoeLeul_wanSuHayeossSeupNiDa._DolaKaSeo_BoSangeul_BateuSeyo."), 3);

end

function EXP_TEST_2(pc, cnt, time)

	EXP_TEST_FUNC(pc, 1, 0.5, 10.0, 0.5);
end

function EXP_TEST(pc, cnt, time)

	EXP_TEST_FUNC(pc, cnt, time, 1.0, 1.0);

end

function GET_NEAR_OBJECT(pc, faction)

	local minDist = 999999;
	local minObj = nil;

	local objList, objCount = SelectObject(pc, 600, faction);	
	for index = 1, objCount do
		local obj = objList[index];
		local dist = GetDistance(pc, obj);
		if dist < minDist then
			minDist = dist;
			minObj = obj;
		end
	end

	return minObj;


end

function GET_NEAR_MON(pc)

	return GET_NEAR_OBJECT(pc, "ENEMY");

end

function GET_NEAR_PC(pc)

	local pc_list, Cnt = SelectObjectByClassName(pc, 300, 'PC')
	if Cnt == 0 then
		return nil;
	end

	return pc_list[1];

end

function GET_NEAR_MON_TRI_TYPE(pc, trigType)

	local objList, objCount = SelectObject(pc, 200, 'FRIEND', 1);
	for index = 1, objCount do
		local obj = objList[index];
		local propVal = GetExProp_Str(obj, "TRIG_TYPE");
		if propVal == trigType then
			return obj;
		end
	end

	return nil;

end

function EXP_TEST_FUNC(pc, cnt, time, scale, time)

	if cnt == 0 or cnt == nil then
		cnt = 20;
	end

	if time == 0 or time == nil then
		time = 2.0;
	end
	
	if scale == 0 or scale == nil then
		scale = 1.5;
	end

	local fndList, fndCount = SelectObject(pc, 200, 'ENEMY');
	for i = 1 , fndCount do
		local mon = fndList[i];
		GiveExpToPC(mon, pc, 100, cnt, time, scale, 1.5, 1, 1.5);
		return;
	end

end

function ITEM_TEST(pc, isEnable)

	isEnable = tonumber(isEnable);
	if isEnable == 1 then
		PauseItemGetPacket(pc);
	else
		ResumeItemGetPacket(pc);
	end

end


function HTEST(pc)
print('testtest')
	AddAchievePoint(pc, "Ranking1", 100);

end

function SFPS(pc)

	while 1 do
		local fps = GetFPS();
		SendAddOnMsg(pc, "SERVER_FPS", "", fps);
		sleep(500);
	end

end

function SPCCOUNT(pc)

	while 1 do
		local pcc = GetPCCount(pc);
		print (pcc);
		sleep(500);
	end

end

function PVPMODE(pc)

	SetCurrentFaction(pc, "Pvp");
	BroadcastRelation(pc);

end

function item_take_test(pc, itemname, itemcount)

    local tx = TxBegin(pc);
	TxTakeItem(tx, itemname, itemcount, 'Test');

	local ret = TxCommit(tx);
	

end


function BUFF_TEST_1(pc)

	AddBuff(pc, pc, 'Rejuvenation', 0, 0, 3000000, 1);
end

function BUFF_TEST_2(pc)

	AddBuff(pc, pc, 'Rejuvenation', 0, 0, 30000, -1);
end



function LAYERBOX(pc, width, height, anglex, angley)

	local pc_x, pc_y, pc_z = GetPos(pc);
	CreateLayerBox(pc, pc_x, pc_z, anglex, angley, width, height);

end


function TEST_DIALOG_DIALOG (self, pc)
    print('TEST_DIALOG');
end


function ALL_MON_DESTROY(pc)

	local zoneid = GetZoneInstID(pc);
	DestroyMonster(zoneid, "ALL");
	DestroyDummyPC(zoneid);
	DestroyAllGen(zoneid);

end

function pa(pc)

	local x, y, z = GetPos(pc);
	SetPosMoveAnim(pc, x + 100, z + 100);
    
--	PlayAnim(pc, "SKL_CONVICTION");

end

function CRE_SOBJ(pc, name)

	CreateSessionObject(pc, name);
end

function DEL_SOBJ(pc, name)

	local sobj = GetSessionObject(pc, name);
	if sobj ~= nil then
		DestroySessionObject(pc, sobj);
	end

end



function STAM(pc, add)

	AddStamina(pc, add);

end

function SETLAYER(pc, layer)

	SetLayer(pc, layer);

end


function DMON(pc, monid)

	local moncls = GetClassByType("Monster", monid);
	local zoneid = GetZoneInstID(pc);
	DestroyMonster(zoneid, moncls.ClassName);

end

function CHECKINST(pc)

	local zoneid = GetZoneInstID(pc);
	Chat(pc, string.format("%d", zoneid));

end

function GETLAYER(pc)

	print(GetLayer(pc));

end



function SETPOSTEST(pc)


	SetPosMoveAnim(pc, -857, 1911);


end


function notice_test(pc)
    SendAddOnMsg(pc,'NOTICE_Dm_Clear',ScpArgMsg("Auto_SeongKongJeogeuLo_MonSeuTeoLeul_CheoLi_HaSyeossSeupNiDa_aiTem_JuwiLo_iDongHaMyeon_JaDongSeupDeug_DoepNiDa."),3);
end

function SIN(pc)

	print(GetZoneName(pc));

end

function BACKTO(pc)

	EndSingleMode(pc);

end

function abilpoint(pc, value)

	local tx = TxBegin(pc);
	if tx == 0 then
		return;
	end

	TxSetIESProp(tx, pc, "AbilityPoint", value);

	local ret = TxCommit(tx);
	

end

function statup(pc, value)

	print(value);

	if value == 0 then
		value = 1;
	end

	local tx = TxBegin(pc);
	if tx == 0 then
		return;
	end

	local CurBonusStat = pc.StatByBonus;
	TxSetIESProp(tx, pc, "StatByBonus", CurBonusStat + value);

	local ret = TxCommit(tx);
	local afterValue = pc.StatByBonus
    CustomMongoLog(pc, "StatByBonusADD", "Layer", GetLayer(pc), "beforeValue", CurBonusStat, "afterValue", afterValue, "addValue", value, "Way", "statup", "Type", "statup")
	

end


function tt(pc)

	local x, y = GetPos(pc);
	local MonObj = CreateGCIES('Monster', "SavePlace2");
	MonObj.Dialog = "TEST";
	INIT_ITEM_OWNER(MonObj, pc);
    local result = CreateMonster(pc, MonObj, x + 50, y, 0, 5);



end

function rcp(pc, rcpclassID)

	local RecipeProp = GetClassByType("Recipe", rcpclassID);
	if RecipeProp == nil then
		RecipeProp = GetClassByType("Recipe", 1);
		return;
	end


	local x, y = GetPos(pc);
	local MonObj = CreateGCIES('Monster', RecipeProp.Monster);
	INIT_ITEM_OWNER(MonObj, pc);
	MonObj.Tactics = RecipeProp.MonsterTactics;
	MonObj.Dialog = RecipeProp.Dialog;
	MonObj.NumArg1 = RecipeProp.ClassID;
	MonObj.Appearance = "MON_GAUGE";
    local result = CreateMonster(pc, MonObj, x, y, 0, 5);


end

function MON_GAUGE(mon)



end

function equipdur(pc, val)

	SET_ENDURE_BY_PART(pc, 'RH', val);

end


function SET_ENDURE_BY_PART(pc, part, val)

	local rw = GetEquipItem(pc, part);
	if rw == nil then
		return;
	end

	SET_ENDURE_TX(pc, rw, val);

end

function SET_ENDURE_TX(pc, item, val)

	local tx = TxBegin(pc);
	TxSetIESProp(tx, item, 'Dur', val);
	local ret = TxCommit(tx);
	

end

function test_itemgive(pc,itemname)
    local tx = TxBegin(pc);
    TxGiveItem(tx,itemname, 1, "Test")
    local ret = TxCommit(tx);
	
	print(ret)
	print(type(ret))

	print('TEST START');
    Chat(pc,'GGGGGG')
end


function TEST_EQUIP_DEL(pc, spot)
    local tx = TxBegin(pc);
    TxTakeEquipItem(tx, spot);
	local ret = TxCommit(tx);
	

	print(ret)
	print(type(ret))


end



function Q_R_TEST(pc)

	local sel = ShowQuestSelDlg(pc, "HAMING_KILL_1");
	print(sel);

end

function TEST_CD(pc)


	SetCoolDown(pc, "FeignDeath", 10000);

end

function TEST_HATED(pc)

	local cnt = GetHatedCount(pc);
	for i = 0 , cnt - 1 do
		local actor = GetHatedChar(pc, i);
		Chat(actor, ScpArgMsg("Auto_Jeoyo"));
	end

end


function SKL_UP(pc, cnt)

	cnt = tonumber(cnt);
	if cnt == 0 then
		return;
	end	


        local tx = TxBegin(pc);
        TxSetIESProp(tx, pc, "SkillPtsByLevel", cnt)
        local ret = TxCommit(tx);
    	

end

function TEST_MON_DSKL(pc)

	local mon = GET_NEAR_MON(pc);
	if mon == nil then
		return;
	end

	local cls = GetClass("Skill", "Boss_DashAttack");
	
	local x, y, z = GetPos(mon);
	local dirX, dirZ = GetDirection(mon);
	x = x + dirX * cls.WaveLength;
	z = z + dirZ * cls.WaveLength;
	
	UseMonsterSkillToGround(mon, cls.ClassName, x, y, z);
	HOLD_MON_SCP(mon, 3000);	
	

end

function USE_MONSKL(pc, sklName)

	local mon = GET_NEAR_MON(pc);
	if mon == nil then
		return;
	end

	UseMonsterSkill(mon, pc, sklName);
	Chat(mon, sklName);
		
end

function TEST_MONSKL(pc, sklName)

	local mon = GET_NEAR_MON(pc);
	if mon == nil then
		return;
	end

	if sklName == nil or sklName == 0 then
		sklName = "Boss_JumpAttack";
	end
	
	Chat(mon, sklName);

	local x, y, z = GetPos(mon);
	UseMonsterSkillToGround(mon, sklName, x, y, z);
	HOLD_MON_SCP(mon, 3000);

		
end

function TEST_RIDE(pc)

	local mon = GET_NEAR_MON(pc);
	ChangeTactics(mon, "MON_DUMMY");
	
	local stone = CREATE_SELFPOS_MONSTER(mon, "Obstacle_stone", "MON_DUMMY");
	SetCurrentFaction(stone, "Neutral");
	SetRideActor(mon, stone, 0);
	
end

function TEST_CREC(pc, cnt)

	local x, y, z = GetPos(pc);
	local	angle = 0;
	local faction ="Neutral";
	local layer = GetLayer(pc);
	local tactics = "MON_DUMMY";

	CRE_CARTNPC(pc, cnt, x, y, z, angle, faction, layer, tactics)

end

function CRE_CARTNPC(pc, cnt, x, y, z, angle, faction, layer, tactics)

	local cartDist = 30;
	local head = CREATE_MONSTER(pc, "NPC_Blowfish1", x, y, z, angle, faction, layer, nil, tactics);


	local owner = head;
	local cartList = {};
	for i = 1 , cnt do
		local xDir, zDir = GetDirection(head);
		local cx = x + cartDist * xDir;
		local cz = z + cartDist * zDir;
		local cart1 = CREATE_CART(pc, "NPC_Cart1", cx, y, cz, angle, faction, layer, 12, "MON_CART");
		SetOwner(cart1, owner, 1);
		owner = cart1;
		cartList[i] = cart1;
	end

end

function CREATE_CARTNPC(pc, cartCnt, btreeName, fixMspd)

	local flwList, cnt = GetFollowerList(pc);
	for i = 1, cnt do
		Kill(flwList[i]);
	end

	local x, y, z = GetPos(pc);
	local myAngle = GetDirectionByAngle(pc);
	local dirX, dirZ = GetDirection(pc);
	local cartDist = 30;
	
	if btreeName == nil then
		btreeName = "BT_Dummy";
	end

	local head = CREATE_MONSTER(pc, "NPC_Blowfish1", x, y, z, myAngle, "Summon", GetLayer(pc), pc.Lv, nil, nil, nil, nil, nil, nil, nil, btreeName);
	if fixMspd == nil then
		fixMspd = pc.MSPD;
	end

	head.FIXMSPD_BM = fixMspd;
	InvalidateMSPD(head);


	if cartCnt == 0 or cartCnt == nil then
		cartCnt = 1;
	end
	
	local owner = head;
	local cartList = {};
	for i = 1 , cartCnt do
		local cart1 = CREATE_CART_TAIL(pc, owner, x, y, z, angle, dirX, dirZ, cartDist, i);
		cart1.FIXMSPD_BM = fixMspd * 1.1;
		owner = cart1;
		cartList[i] = cart1;
	end
	
	return head, cartList;
end

function DOG(pc)
	local x, y, z = GetPos(pc);
	local mon = CREATE_MONSTER_EX(pc, 'mon_dog6', x, y, z, GetDirectionByAngle(pc), 'Neutral', pc.Lv, SET_DUMMY_MON);
	RunSimpleAI(mon, "dog");
	SetOwner(mon, pc, 1);
end

function CREATE_CART_TAIL(pc, owner, x, y, z, angle, dirX, dirZ, cartDist, idx)

	local monClsName = "NPC_Cart1";
	local monName = GetClass("Monster", monClsName).Name;
	local pcName = GetName(pc);
	
	local name = ScpArgMsg("Auto_{Auto_1}ui_MaCha","Auto_1", pcName,"Auto_2", monName);
	
	x = x - dirX * cartDist * idx;
	z = z - dirZ * cartDist * idx;
	
	local mon = CREATE_CART(pc, monClsName, x, y, z, angle, "Neutral", GetLayer(pc), 12, "MON_CART", name, pcName);
	SetOwner(mon, owner, 1);
	return mon;

end

function T_DOWN(pc)

	SendAddOnMsg(nil, "NOTICE_Dm_DefExplan", ScpArgMsg("Auto_DeonJeonipKuLo_HyangHaNeun_Muni_yeolLyeossSeupNiDa"), 3);
	
end

function TEST_CRY(pc)

	local x, y, z = GetPos(pc);
	local head = CREATE_MONSTER(pc, "RootCrystal_a", x, y, z, 0, "RootCrystal", GetLayer(pc), pc.Lv, "MON_DUMMY");
-- 	ChangeModel(pc,'RootCrystal_a')
end

function TEST_CRY2(pc)

	local mon = GET_NEAR_MON(pc);
	if mon == nil then
		return;
	end
	
	ChangeModel(mon,'RootCrystal_b');
end

function TEST_COLSKL(pc)

	local x, y, z = GetPos(pc);
	local a = CREATE_MONSTER(pc, "Zombieboss", x, y, z, 0, "Monster", GetLayer(pc), pc.Lv, "MON_DUMMY");
	local b = CREATE_MONSTER(pc, "Guard_fence", x, y, z + 200 , 0, "Monster", GetLayer(pc), pc.Lv, "MON_DUMMY");
	
	local testStr = string.format("%d %d", GetHandle(a), GetHandle(b) );
	SendAddOnMsg(pc, "NOTICE_Dm_DefExplan", testStr, 3);
	
	
end

function TEST_ANGLE(pc)

	local mon = GET_NEAR_MON(pc);
	if mon == nil then
		return;
	end

	local angle = GetLookAngle(pc, mon);
	local testStr = string.format("%d", angle);
	Chat(mon, testStr);
end

function AUTO_LEARN_SKILL(pc)

	local jobName = pc.JobName;
	jobName = string.sub(jobName, 1, string.len(jobName) - 1) .. "1";
	local jobID = GetClass("Job", jobName).ClassID;

	local list = GET_CLS_GROUP("SkillTree", jobName);
	local arglist = {};	
	arglist[1] = jobID;

	local havepts = GetRemainSkillPts(pc, jobID);

	local treename = jobName;
	local treelist = {};
	GET_PC_TREE_INFO_LIST(pc, treename, arglist, treelist);
	
	for i = 1 , #treelist do
		arglist[i+1] = 0;
	end

	while 1 do
		
		if havepts <= 0 then
			break;
		end

		local did = false;
		for i = 1 , #treelist do	
			local tree = treelist[i];
			local cls = tree["class"];
			local maxLv = cls.MaxLevel;
			local curLv = tree["lv"];

			if (curLv + arglist[i+1]) < maxLv then
				did = true;
				havepts = havepts - 1;
				arglist[i+1] = arglist[i+1] + 1;

				if havepts <= 0 then
					break;
				end
			end
		end

		if false == did then
			break;
		end
	end

	SCR_TX_SKILL_UP(pc, arglist);

end

function ALLSKILL(pc)
	
	local jobName = pc.JobName;
	local list = GET_CLS_GROUP("SkillTree", jobName);
	local arglist = {};	
	
	for i = 1 , #list do
		local sklTreeCls = list[i];
		
		if sklTreeCls.ClassID == 1001 then
			arglist[1] = 1;
		elseif sklTreeCls.ClassID == 2001 then
			arglist[1] = 2;
		elseif sklTreeCls.ClassID == 3001 then
			arglist[1] = 3;
		end	
		
		arglist[i+1] = sklTreeCls.MaxLevel;	
	end	
	
		
	local jobID = arglist[1];
	local treename = GetClassByType("Job", jobID).ClassName;
	local treelist = {};
	
	GET_PC_TREE_INFO_LIST(pc, treename, arglist, treelist);
	
	if arglist[1] == 1 then
		for i = 2, #treelist do
			arglist[i] = arglist[i] - treelist[i-1]["lv"];
		end		
	elseif arglist[1] == 2 then
		for i = 2, #treelist do
			arglist[i] = arglist[i] - treelist[i]["lv"];
		end		
	elseif arglist[1] == 3 then
		for i = 2, #treelist do
			arglist[i] = arglist[i] - treelist[i-1]["lv"];
		end
		
		arglist[4] = 0;		
	end
		
	SCR_TX_SKILL_UP(pc, arglist, 1);
	
end

function TEST_RANK(pc)

	
	Chat(pc, "SS");
	ShowRankUI(pc, "OverKill", "NO", "YES");


end

function RANK1(pc)

	
	Chat(pc, "SS");
	ShowRankUI(pc, "OverKill", "NO", "YES");


end

function TEST_WANG(pc)

	local mon = GET_NEAR_MON(pc);
	if mon == nil then
		return;
	end
	
	-- UsePcSkill(pc, mon, 'MongWangGa', 1, 'YES');
	SetExArgCount(mon, 30);
	SetExArg(mon, 1, pc);
	local list, cnt = GetExArgList(mon);
		

end

function TEST_SPOS(pc)

	while 1 do
	
		local x, y, z = GetPos(pc);
		TestDrawPos(pc, x, y + 10, z);
		TEST_SPOS_LOOP(pc, 'ENEMY');
		TEST_SPOS_LOOP(pc, 'NEUTRAL');
		TEST_SPOS_LOOP(pc, 'FRIEND');
		sleep(500);
	end

end

function TEST_SPOS_LOOP(pc, relation)

	local objList, objCount = SelectObject(pc, 200, relation, 1);
	for index = 1, objCount do
		local obj = objList[index];
		local x, y, z = GetPos(obj);
		TestDrawPos(obj, x, y + 10, z);
	end

end


function TEST_WIKI(pc)
	local wiki = GetWiki(pc, 3);
	print(wiki);
end

function TEST_CAM(pc)

	local curzoneID = GetZoneInstID(pc);
	_TRACK(curzoneID, "PLAYER",
	{
		{"RUNSCRIPT", pc, "DIRECT_START"},
		{"SLEEP", 1000},
		{"RUNSCRIPT", pc, "ChangeCameraZoom", 3, 400, -100},
		{"SLEEP", 1000},
		{"RUNSCRIPT", pc, "ChangeCameraZoom", 1, 40, 10},
		{"SLEEP", 1000},
		{"RUNSCRIPT", pc, "CAMERA_RESET"},
		{"SLEEP", 1000},
		{"RUNSCRIPT", pc, "DIRECT_END"},
		{"SLEEP", 1000},
	}
	);

end

function TEST_REINF(pc)

	LoadReinfList(pc);

end

function TEST_STRPROP(pc, name)

	local item = GetInvItemByName(pc, name);
	if item == nil then
		return;
	end
	
	local tx = TxBegin(pc);
	if tx == 0 then
		return;
	end

	TxSetIESProp(tx, item, "FirstGet", GetName(pc));

	local ret = TxCommit(tx);
	

		
	
end

function TEST_MONSTERGEN(pc)

	local layer = GetLayer(pc);
	local x, y, z = GetPos(pc);
	local groupGenName = "NEWFE_2"
	local genTime = 180;
	local genDuration = 25;
		
	local monObj = CreateGCIES('Monster', "HiddenTrigger3");
	if monObj == nil then
		print("Error_S1");
		return;
	end

	MON_LAW_DUMMY(monObj);
	
	local zoneInst = GetZoneInstID(pc);
	monObj = CreateMonster(zoneInst, monObj, x, y, z, 0, 20);
	if monObj == nil then
		print("Error_S2");
		return;
	end
	
	SetLayer(monObj, layer);
	
	REGISTER_ATTACK_GEN(monObj, genTime, genDuration, groupGenName);

end

function TEST_PARTYOBJ(pc)
	

end


function TEST_MON_ANIM(pc, animName)

	local mon = GET_NEAR_MON(pc);
	if mon == nil then
		return;
	end

	PlayAnim(mon, animName, 1, 0, 0);
	Chat ( mon , animName );
		
end

function TEST_MSG2(pc)
	SendSysMsg(pc, "{How}GetSilver",0,"How",3)
end

function TEST_PC_ANIM(pc, animName)

	PlayAnim(pc, "BOX_IN", 1, 0, 0);
	Chat ( pc , animName );
		
end

function TEST_ZONEMOVE(pc)
	local list, cnt = SelectObjectByClassName(pc,100,'statue_vakarine');
	SCR_CAMP_WARP_BY_SKILL(list[1],pc);

end

function TEST_SELOBJ(pc)

	local fndList, fndCount = SelectObject(pc, 20, 'ALL');
	print(fndCount);
	for i = 1 , fndCount do
		 print(fndList[i]);
		--Chat(fndList[i], i .. " TH");
	end

end

function TEST_BT(pc, btName, tcnt)
	
	if btName == 0 or btName == nil then
		Chat(pc, ScpArgMsg("Auto_eopeum"));		
		return;
	end	

	local bt = CreateBTree(btName);
	if bt == nil then
		Chat(pc, btName .. ScpArgMsg("Auto__:_eopNeun_BT"));		
		return;
	end
		
	local x, y, z = GetPos(pc);
	local layer = GetLayer(pc);
	
	if tcnt == nil or tcnt == 0 then
		tcnt = 1;
	end
	
	for i = 1 , tcnt do
		local leader = CREATE_MONSTER(pc, "Aos_Hero_Arc", x, y, z, 0, "Law", layer, 30, "MON_BTREE");
		SetBTree(leader, bt);
	end

end

function TEST_BBT(self)
		
	local x, y, z = GetPos(self);
	local layer = GetLayer(self);
	
	local monGroupname = "Aos_Law_Archer";
	local bt = CreateBTree("AosBT_Law_Hero");
	CRE_GROUP_MON(self, monGroupname, x,y,z, "Law", layer, nil, nil, nil, bt);
	


end

function TEST_EMO(pc, eftName)

	SetEmoticon(pc, eftName);
end

function TEST_SHOW_EMO(pc)

	HideEmoticon(pc, 'I_emo_stun')
end

function TEST_ZONEINST(pc)

	Chat(pc, GetZoneInstID(pc));
	print ( GetZoneInstID(pc));

end

function TEST_MANI(pc)

	CreateSessionObject(pc,'ssn_shop', 1);
	local obj = GetSessionObject(pc, 'ssn_shop');
	
	local tx = TxBegin(pc);
	TxSetIESProp(tx, obj, 'Posion_2', 10);
	local ret = TxCommit(tx);
	

end

function TEST_MBLUR(pc, isOn)

	local mon = GET_NEAR_MON(pc);
	if mon == nil then
		return;
	end
	
	SetMotionBlur(mon, isOn);
	Chat(mon, " " .. isOn);

end

function TEST_B_BOX(pc)

	local x, y, z = GetPos(pc);
	local width = 200;
	local height = 150;
	local boxMon = CREATE_BATTLE_BOX(pc, 20, "None", 1000, x - width / 2, y, z - height/ 2, x + width / 2, y, z + height / 2, "NO");

--	local mon1 = CREATE_MONSTER(pc, "Goblin_Spear", x, y, z, 0, "Monster", 0, 12, "MON_BASIC");
	--ADD_BATTLE_BOX_MONSTER(boxMon, mon1);		
	
end

function DOTIMEACTION_SANI(pc, target, sani, msg, second)
    CancelMouseMove(pc)

	local saniRet = PlaySumAni(pc, target, sani);
	if saniRet == 0.0 then
		StopScript();
		sleep(10);
		return false;
	end

	WaitSumAniEnd(pc);
	--return DOTIMEACTION(pc, msg, "", second);

end


function DOTIMEACTION_SANI_R(pc, target, sani, msg, second, sobjName, ridingAnim)

    local ret = DOTIMEACTION_SANI(pc, target, sani, msg, second);
    if ret == 0 then
        return 0;
    end
    
    return DOTIMEACTION_R(pc, msg, "", second, sobjName, ridingAnim);

end

function DOTIMEACTION_GUILDBATTLE(pc, msg, anim, second, buffObj, ridingAnim)
    CancelMouseMove(pc)
	PlayAnim(buffObj, 'EVENT_LOOP');
    anim = DOTIMEACTION_RIDING_ANIM_CHANGE(pc,anim, ridingAnim)

	local result = DoTimeAction(pc, msg, anim, second);
	if result == 0.0 then
		StopAnim(buffObj)
		StopScript();
		sleep(10);
		return false;
	end
	
	while 1 do
		result = GetTimeActionResult(pc, 0);

		if result == 1 then
			return 1;
		else
			StopAnim(buffObj)
		end
		
		sleep(1);
	end
	
end

function DOTIMEACTION_RIDING_ANIM_CHANGE(pc,anim, ridingAnim)
    local ridingCompanion = GetRidingCompanion(pc);
    if ridingCompanion ~= nil then
        if ridingAnim ~= nil and ridingAnim ~= 'None' then
            return ridingAnim
        else
            return 'ABSORB'
        end
    else
        return anim
    end
end

function DOTIMEACTION(pc, msg, anim, second, ridingAnim)
    anim = DOTIMEACTION_RIDING_ANIM_CHANGE(pc,anim, ridingAnim)

	local result = DoTimeAction(pc, msg, anim, second);
	if result == 0.0 then
		StopScript();
		sleep(10);
		return false;
	end
	
	while 1 do
		result = GetTimeActionResult(pc, 0);

		if result == 1 then
			return;
		end
		
		sleep(1);
	end
	
end

function DOTIMEACTION_R_FAILTIME_SET(pc, questName, msg, sec, animName, addSObj, ridingAnim)
    local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, sec, questName)
    local result = DOTIMEACTION_R(pc, msg, animName, animTime, addSObj, ridingAnim)
    DOTIMEACTION_R_AFTER(pc, result, animTime, before_time, questName)
    return result
end

function DOTIMEACTION_R_BEFORE_CHECK(pc,animTime, questname)
    local before_time = os.clock()
    local sObj_main = GetSessionObject(pc,'ssn_klapeda')
    
    if sObj_main.DOTIMEACTION_FAILQUEST == questname then
        if sObj_main.DOTIMEACTION_FAILTIME > 0 then
            animTime = animTime - (animTime * 0.4 * sObj_main.DOTIMEACTION_FAILTIME)
            
            if animTime < 1 then
                animTime = 1
            end
        end
    end
    
    return animTime, before_time
end

function DOTIMEACTION_R_AFTER(pc, result, animTime, before_time, questname)
    if result == nil or result == 0 then
        local after_time = os.clock()
        if after_time - before_time >= animTime * 0.3 then
            local sObj_main = GetSessionObject(pc,'ssn_klapeda')
            if sObj_main.DOTIMEACTION_FAILQUEST == questname then
                sObj_main.DOTIMEACTION_FAILTIME = sObj_main.DOTIMEACTION_FAILTIME + 1
            else
                sObj_main.DOTIMEACTION_FAILTIME = 1
                sObj_main.DOTIMEACTION_FAILQUEST = questname
            end
        end
    else
        local sObj_main = GetSessionObject(pc,'ssn_klapeda')
        sObj_main.DOTIMEACTION_FAILTIME = 0
        sObj_main.DOTIMEACTION_FAILQUEST = 'None'
    end
end

function DOTIMEACTION_R(pc, msg, anim, second, sObj_name, add_time, ridingAnim)
    CancelMouseMove(pc)
    anim = DOTIMEACTION_RIDING_ANIM_CHANGE(pc,anim, ridingAnim)
    
    local add_timer
    if add_time == nil then
        add_timer = 0
    else
        add_timer = add_time*1000
    end
    
    local xac_ssn = GetSessionObject(pc, 'SSN_EV_STOP')

	if xac_ssn == nil then
    	CreateSessionObject(pc, 'SSN_EV_STOP', 1)
    	xac_ssn = GetSessionObject(pc, 'SSN_EV_STOP')
		if xac_ssn == nil then
			return -2;
		end

    	xac_ssn.Step1 = (second*1000 + 500 + add_timer)
    else
        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("TryLater"), 1);
        return -2;
    end
---------------
    if sObj_name ~= nil and sObj_name ~= 'None' then
        CreateSessionObject(pc, sObj_name, 1)
        local sObj = GetSessionObject(pc, sObj_name)
        if sObj ~= nil then
            sObj.Count = second
        end
    end

	local result = DoTimeAction(pc, msg, anim, second);
	if result == 0.0 then
		StopScript();
		DestroySessionObject(pc, xac_ssn)
		return 0;
	end
	
	while 1 do		
		result = GetTimeActionResult(pc, 1);		
		if result == 1 then
			if IsRest(pc) == 1 then
				PlayAnim(pc, 'REST')
			else
				PlayAnim(pc, 'STD')  
			end
           
            DestroySessionObject(pc, xac_ssn)
			return 1;
		end
		
		if result == 0 then
			if IsRest(pc) == 1 then
				PlayAnim(pc, 'REST')
			else 
			    PlayAnim(pc, 'STD')
			end
		    DestroySessionObject(pc, xac_ssn)
			return 0;
		end
		
		sleep(1);
	end
    DestroySessionObject(pc, xac_ssn)
	return 0;	
		
end

function DOTIMEACTION_ONLY_TARGET(seller, target, msg, anim, second, skillType)
	
	local result = ShowingTimeActionOnlyTarget(seller, target, msg, anim, second, skillType);
	if result == 0.0 then
		StopScript();
		sleep(10);
		return 0;
	end
	
	while 1 do		
		result = GetTimeActionResult(target, 1);
		if result == 1 then
			return 1;
		end
		
		if result == 0 then
			return 0;
		end
		
		sleep(1);
	end
end

function DOTIMEACTION_ONLY_ACTION(pc, msg, anim, second, ridingAnim)
    anim = DOTIMEACTION_RIDING_ANIM_CHANGE(pc,anim, ridingAnim)
    
    local result = DoTimeAction(pc, msg, anim, second);
    
    if result == 0.0 then
        StopScript();
        sleep(10);
        return 0;
    end
    
    while 1 do      
        result = GetTimeActionResult(pc, 1);
        if result == 1 then
            if IsRest(pc) == 1 then
                PlayAnim(pc, 'REST')
            else
                PlayAnim(pc, 'STD')  
            end
            return 1;
        end
        
        if result == 0 then
            if IsRest(pc) == 1 then
                PlayAnim(pc, 'REST')
            end

			return 0;
		end
		
		sleep(1);
	end
end

--self?? Dialog NPC
function DOTIMEACTION_B(pc, msg, anim, second, sObj_name, eff_name, self, ridingAnim)
    CancelMouseMove(pc)
    anim = DOTIMEACTION_RIDING_ANIM_CHANGE(pc,anim, ridingAnim)
    local xac_ssn = GetSessionObject(pc, 'SSN_EV_STOP')
	if xac_ssn == nil then
    	CreateSessionObject(pc, 'SSN_EV_STOP', 1)
    	xac_ssn = GetSessionObject(pc, 'SSN_EV_STOP')
    	xac_ssn.Step1 = (second*1000 + 500)
    else
        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("TryLater"), 1);
        return;
    end
    if sObj_name ~= nil then
        CreateSessionObject(pc, sObj_name, 1)
        local sObj = GetSessionObject(pc, sObj_name)
        sObj.QuestInfoName1 = eff_name
        if self ~= nil and self ~= "None" then
            SetArgObj1(sObj, self)
        end
    end

	local result = DoTimeAction(pc, msg, anim, second);
	if result == 0.0 then
		StopScript();
		sleep(10);
		DestroySessionObject(pc, xac_ssn)
		return 0;
	end
	
	while 1 do
		result = GetTimeActionResult(pc, 1);

		if result == 1 then
		    DestroySessionObject(pc, xac_ssn)
			return 1;
		end
		
		if result == 0 then
		    DestroySessionObject(pc, xac_ssn)
			return 0;
		end
		
		sleep(1);
	end
    DestroySessionObject(pc, xac_ssn)
	return 0;	
		
end


function DOTIMEACTION_R_DUMMY_ITEM(pc, msg, anim, second, sObj_name, add_time, itemNumber, spot, ridingAnim)
    CancelMouseMove(pc)
    anim = DOTIMEACTION_RIDING_ANIM_CHANGE(pc,anim, ridingAnim)
    
    local add_timer
    if add_time == nil then
        add_timer = 0
    else
        add_timer = add_time*1000
    end

	local xac_ssn = GetSessionObject(pc, 'SSN_EV_STOP')

	if xac_ssn == nil then
		CreateSessionObject(pc, 'SSN_EV_STOP', 1)
		xac_ssn = GetSessionObject(pc, 'SSN_EV_STOP')
	
		if xac_ssn == nil then
			return -2;
		end

		xac_ssn.Step1 = (second*1000 + 500 + add_timer)
	else
		SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("TryLater"), 1);
		return -2;
	end

	if sObj_name ~= nil and sObj_name ~= 'None' then
		CreateSessionObject(pc, sObj_name, 1)
		local sObj = GetSessionObject(pc, sObj_name)
		if sObj ~= nil then
			sObj.Count = second
		end
	end

	EquipDummyItemSpot(pc,pc, 0, spot, 0)
	if spot == "LH" then
		AddBuff(pc, pc, 'Warrior_RH_VisibleObject');
	elseif spot == "RH" then
		AddBuff(pc, pc, 'Warrior_LH_VisibleObject');
	end
	
	EquipDummyItemSpot(pc, pc, itemNumber, spot, 0)

	local result = DoTimeAction(pc, msg, anim, second);
	if result == 0.0 then
		StopScript();
		sleep(10);
		DestroySessionObject(pc, xac_ssn)
		return 0;
	end
	
	while 1 do
		result = GetTimeActionResult(pc, 1);		
		if result == 1 then
			if IsRest(pc) == 1 then
				PlayAnim(pc, 'REST')
			else
				PlayAnim(pc, 'STD')  
			end
		
			EquipDummyItemSpot(pc,pc, 0, spot, 0)

			if spot == "LH" then
				RemoveBuff(pc, 'Warrior_RH_VisibleObject');
			elseif spot == "RH" then
				RemoveBuff(pc, 'Warrior_LH_VisibleObject');
			end

			DestroySessionObject(pc, xac_ssn)
			return 1;
		end

		if result == 0 then
			if IsRest(pc) == 1 then
				PlayAnim(pc, 'REST')
			end
			DestroySessionObject(pc, xac_ssn)

			EquipDummyItemSpot(pc,pc, 0, spot, 0)

			if spot == "LH" then
				RemoveBuff(pc, 'Warrior_LH_VisibleObject');
			elseif spot == "RH" then
				RemoveBuff(pc, 'Warrior_RH_VisibleObject');
			end

			return 0;
		end

		sleep(1);
	end
	DestroySessionObject(pc, xac_ssn)
	return 0;	
end


function FORCE_SUMMON(self, faction)

	HoldMonScp(self);
	PlayAnim(self, "SKL_CAST", 1);
	sleep(1000);
	PlayAnim(self, "SKL_SHOT", 0);
	local x, y, z = GetFrontPos(self, 70);
	local throwTime = 0.5;
	MslThrow(self, "archer_poisonarrow", 1.0, x, y, z, range, throwTime, 0, 600, 2.0, "F_explosion071_green", 1.0);
	sleep(throwTime * 1000);

	local mon1 = CREATE_SUMMON(self, "Haming", x, y, z, GetDirectionByAngle(self), self.Lv, nil, faction);
	UnHoldMonScp(self);

end

function TEST_DIRECTION(pc, name, time)

	if time ~= nil then
		sleep(time * 1000);
	end

	PlayDirection(pc, name);

end

function TEST_MUSIC(pc, musicName)
	PlayMusicQueue(pc, musicName);
end

function CLEAR_TACTICS(mon)
	mon.BTree = "None";
	mon.Tactics = "None";
end

function SCR_USE_TEST_SKILL(self ,skill)

	
	local x, y, z = GetFrontPos(self, 150);
	sleep(1000);
	CREATE_MONSTER(self, "Icepillar_1", x, y, z);

	sleep(500);
	CREATE_MONSTER(self, "Icepillar_1", x, y, z);

	sleep(500);
	CREATE_MONSTER(self, "Icepillar_1", x, y, z);



end

function TEST_MEDAL(pc, cnt)

	local tx = TxBegin(pc);
	local aobj = GetAccountObj(pc);
	if cnt == 0 or cnt == nil then
    	TxAddIESProp(tx, aobj, "PremiumMedal", 500, 'TEST_MEDAL');
    	local ret = TxCommit(tx);
	else
    	TxAddIESProp(tx, aobj, "PremiumMedal", cnt, 'TEST_MEDAL');
    	local ret = TxCommit(tx);
    end
	
		
end


function TEST_achi(pc)

        AddAchievePoint(pc, "TreasureBox", 10000);
		AddAchievePoint(pc, "MonKill", 10000);
		AddAchievePoint(pc, "OverKill", 10000);
		AddAchievePoint(pc, "PcRevive", 10000);
		AddAchievePoint(pc, "ItemRecipe", 10000);
		AddAchievePoint(pc, "PcKill", 10000);
		AddAchievePoint(pc, "HairShop", 10000);
		AddAchievePoint(pc, "DaegilCat", 10000);
end


function SCR_USE_TEST_SKILL(self, skill)
	
	sleep(1000);
	local x, y, z = GetFrontPos(self, 100);
	CREATE_MONSTER(pc, "attract_pillar", x, y, z, 0, GetCurrentFaction(pc), 0, 15);

	sleep(500);
	CREATE_MONSTER(pc, "attract_pillar", x, y, z, 0, GetCurrentFaction(pc), 0, 15);

	sleep(500);
	CREATE_MONSTER(pc, "attract_pillar", x, y, z, 0, GetCurrentFaction(pc), 0, 15);
	

end

function TEST_BUFF(self, buffName)
	local mon = GET_NEAR_MON(self);
	AddBuff(self, mon, buffName, 1, 0, 60000, 1);
end

function m_boss_scenario(self)

end


g_testValue = 1;

function TEST_MEMORY_LEAK(pc)

	g_testValue = g_testValue + 1;
	if g_testValue > 100000 then
		print ( pc.ClassName  .. " " ..os.time() );
		g_testValue = 0;
	end

end

function chdnjf(pc, val)	

	local tx = TxBegin(pc);
	for i = 0 , 20 do
		local es = item.GetEquipSpotName(i);
		local equipWeapon = GetEquipItemIgnoreDur(pc, es);		
		if equipWeapon ~= nil and equipWeapon.Transcend ~= val then
			TxSetIESProp(tx, equipWeapon, 'Transcend', val);
		end
	end

	TxCommit(tx);

end

function TEST_FORCE(pc)	

	local tx = TxBegin(pc);
    TxGiveItem(tx, "misc_talt", 1, 'GACHA_CUBE');
    TxCommit(tx);

end

function TEST_F(pc)

	TEST_MAKE_WORD(pc, 5);
	sleep(3000);
	TEST_CALCULATE_WORD(pc, "*", 5);

end

function GTTTTT(pc)

	local tx = TxBegin(pc);
    TxGiveItem(tx, 'SWD01_101', 1, 'Bag');
    TxCommit(tx);

end

function TEST_MEMORY(mon)
	while 1 do
		local list, cnt = SelectObject(mon, 100, 'ENEMY')
		for j = 1 , cnt do
			print(list[j].Name .. " " .. os.time());
			local abc = list[j];
		end
		sleep(500);
	end	
end

function TEST_MEMORY2(mon)
	local ret;
	local loopCnt = 0;
	while 1 do
		local list, cnt = SelectObject(mon, 100, 'ENEMY')
		for j = 1 , cnt do
			ret = list[j];
		end
		sleep(1);
		loopCnt = loopCnt + 1;
		if loopCnt >= 50 then
			return ret;
		end
	end	

	return ret;
end

function TIMEACTION_TEST(pc)
	local makingTime = 5;
	local result2 = DOTIMEACTION_R(pc, ScpArgMsg("ItemCraftProcess"), '#SITGROPESET', makingTime);
end

function TEST_PET(pc)	

	local monCls =	GetClass("Monster", "Velhider");
	local tx = TxBegin(pc);

    TxAdoptPet(tx, monCls.ClassID, "TEST_PET");	
	local ret = TxCommit(tx);
      

	local monCls =	GetClass("Monster", "Velhider");
	SummonPet(pc, monCls.ClassID);

end

function TEST_PILLAR_GUST(pc)

	local mon = GET_NEAR_MON_TRI_TYPE(pc, "FIREPILLAR");
	local x, y, z = GetPos(pc);
	local dx, dz = GetDirection(pc);
	if mon ~= nil then
		ADD_FIREPILLAR_GUST_POS(mon, x, y, z, dx, dz, 2.0);
	end

end

function TEST_NOTICE(pc)

	SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("Auto_HyeonJae_eoleum"), 3);
	SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("Auto_PogTan_SeolChi_SeongKong"), 3);
	
end

function TEST_BUHA(pc)

	print('hi');

	local objList, objCount = SelectObject(pc, 100, 'ALL');
	for i = 1, objCount do
		local obj = objList[i];	
		SetOwner(obj, pc);
		SetTendency(obj, "Attack")
		ResetHateAndAttack(obj);
		--InsertHate(obj, self, 10000);
		BroadcastRelation(obj);
	end
	
end


function TEST_MCY_SUM(pc)

	--[[local x, y, z = GetPos(pc);
	local gol = CREATE_MONSTER(pc, "MCy_Siege", x, y, z, 0, GetCurrentFaction(pc), MCY_DEF_LAYER, 15);
	SetOwner(gol, pc);
	SetTeamID(gol, GetTeamID(pc));
	]]
	
	local x, y, z = GetPos(pc);
	local gol = CREATE_MONSTER(pc, "MCy_Zombieboss", x, y, z, 0, "MCy_Treasure", MCY_DEF_LAYER, 15);
	
	

end

function TOTAL_JOB_TST(pc)
	local jobcircle = GetTotalJobCount(pc)
	print(jobcircle)
end

function idcheck(pc)

	local get_item = GetInvItemList(pc);

	for i = 1 , #get_item do
		
		local equipWeapon = get_item[i];
		
		print(equipWeapon.ClassID)
		print(equipWeapon.InvIndex)
	end	            
	
end

function TEST_PRINT_DUR(pc)

	for i = 0 , 16 do
		local es = item.GetEquipSpotName(i);
		local equipWeapon = GetEquipItem(pc, es);
		if 0 == item.IsNoneItem(equipWeapon.ClassID) then
			print(equipWeapon.Dur)
		end
	end
	
	InvalidateStates(pc);
end

function TEST_DUR_0(pc)

	for i = 0 , 16 do
		local es = item.GetEquipSpotName(i);
		local equipWeapon = GetEquipItem(pc, es);
		if 0 == item.IsNoneItem(equipWeapon.ClassID) then
			local tx = TxBegin(pc);
			TxSetIESProp(tx, equipWeapon, 'Dur', 0);
			local ret = TxCommit(tx);
			  
		end
	end
	
	InvalidateStates(pc);
end

function REPAIR_ALL_CHEAT(pc)

	for i = 0 , 16 do
		local es = item.GetEquipSpotName(i);
		local equipWeapon = GetEquipItem(pc, es);
		if 0 == item.IsNoneItem(equipWeapon.ClassID) then
			local tx = TxBegin(pc);
			TxSetIESProp(tx, equipWeapon, 'Dur', equipWeapon.MaxDur );
			local ret = TxCommit(tx);
			  
		end
	end

	local get_item = GetInvItemList(pc);

	for i = 1 , #get_item do
		
		local equipWeapon = get_item[i];
		if 0 == item.IsNoneItem(equipWeapon.ClassID) then
			if equipWeapon.GroupName == 'Weapon' or equipWeapon.GroupName =='Armor' then
				
				if equipWeapon.Dur < equipWeapon.MaxDur then
				
					local tx = TxBegin(pc);
					TxSetIESProp(tx, equipWeapon, 'Dur', equipWeapon.MaxDur );
					local ret = TxCommit(tx);
					  
				end
			end
		end

	end	            
	
	InvalidateStates(pc);
end

function CHANGE_JOB(pc, jobName)
	while true do
		jlvup(pc, 15)
		local lv, total = GetJobLevelByName(pc, pc.JobName);
		if lv == 15 then
			break;
		end
		sleep(100)
	end
	
	local tx = TxBegin(pc);
    TxChangeJob(tx, jobName);

	local jobObj = GetClass("Job", jobName);
	local abilList = StringSplit(jobObj.DefHaveAbil, '#');
	for i = 1 , #abilList do
		if abilList[i] ~= 'None' then

			local abilObj = GetAbilityIESObject(pc, abilList[i]);	
			if abilObj == nil then
				TxAddAbility(tx, abilList[i]);
			end
		end
	end

	local ret = TxCommit(tx);

	jlvup(pc, 15)

end

-- trunk version
function CHANGE_JOB_2(pc, jobName)
	
	local tx = TxBegin(pc);
    TxChangeJob(tx, jobName);

	local jobObj = GetClass("Job", jobName);
	local abilList = StringSplit(jobObj.DefHaveAbil, '#');
	for i = 1 , #abilList do
		if abilList[i] ~= 'None' then

			local abilObj = GetAbilityIESObject(pc, abilList[i]);	
			if abilObj == nil then
				TxAddAbility(tx, abilList[i]);
			end
		end
	end

	local ret = TxCommit(tx);

	jlvup(pc, 15)

end

function TEST_JOBLV(pc)
	print(pc.JobName)
	local lv, total = GetJobLevelByName(pc, pc.JobName);
	local grade, changedJobCount = GetJobGradeByName(pc, pc.JobName);
	
	print(lv, total,  grade, changedJobCount);	
end

function RANDOM_VIEW(pc)

	local zoneID = GetZoneInstID(pc);
	local layer = GetLayer(pc);
	local list, cnt = GetLayerMonList(zoneID, layer);
	local idx = IMCRandom(1, cnt);
	local mon = list[idx];
	ChangeFocusView(pc, mon);
end

function GETJOB(pc)
    local jobID = TryGetProp(pc, "Job");
    print(jobID)
end
function EXPORT_ITEM(pc)
    ExportItem();
end

function GET_CHECK_OVERLAP_EQUIPPROP_LIST_FOR_EXPORT(propList, prop, list)
    local checkList = propList;
    if list == nil then
        list = {};
    end
    for i = 1, #checkList do
        if checkList[i] ~= prop then
            list = PUSH_BACK_IF_NOT_EXIST(list, checkList[i]);
        end
    end
    
    return list;
end

function GET_EQUIP_TOOLTIP_PROP_LIST_FOR_EXPORT(invitem)

	local groupName = invitem.GroupName;
	if groupName == 'Weapon' then
		return GET_ATK_PROP_LIST();
	
	elseif groupName == "PetWeapon" then
		return GET_PET_WEAPON_PROP_LIST();
	elseif groupName == "PetArmor" then
		return GET_PET_ARMOR_PROP_LIST();
	else
		return GET_DEF_PROP_LIST();
	end

end
function GET_PET_WEAPON_PROP_LIST()
	local list = GET_ATK_PROP_LIST();
	list[#list+1] = "MountPATK";
	list[#list+1] = "MountMATK";
	return list;
    
end
function GET_PET_ARMOR_PROP_LIST()
	local list = GET_DEF_PROP_LIST();
	list[#list+1] = "MountPATK";
	list[#list+1] = "MountMATK";
	return list;    
end

function GET_DEF_PROP_LIST()

	local list = {};
    list[#list+1] = "DEF";
    list[#list+1] = "ADD_DEF";
    list[#list+1] = "PATK";
    list[#list+1] = "MATK";
    list[#list+1] = "ADD_MAXATK";
    list[#list+1] = "ADD_MINATK";
    list[#list+1] = "ADD_MATK";
    list[#list+1] = "STR";
    list[#list+1] = "DEX";
    list[#list+1] = "INT";
    list[#list+1] = "CON";
    list[#list+1] = "MNA";
    list[#list+1] = "MHP";
    list[#list+1] = "MSP";
    list[#list+1] = "MSTA";
    list[#list+1] = "CRTHR";
    list[#list+1] = "CRTDR";
    list[#list+1] = "CRTATK";
    list[#list+1] = "KDPow";
    list[#list+1] = "SkillPower";
    list[#list+1] = "ADD_HR";
    list[#list+1] = "ADD_DR";
    list[#list+1] = "MHR";
    list[#list+1] = "ADD_MHR";
    list[#list+1] = "MDEF";
    list[#list+1] = "ADD_MDEF";
    list[#list+1] = "SkillRange";
    list[#list+1] = "SkillAngle";
    list[#list+1] = "MSPD";
    list[#list+1] = "RHP";
    list[#list+1] = "RSP";
    list[#list+1] = "SR";
    list[#list+1] = "SDR";
    list[#list+1] = "BLK";
    list[#list+1] = "BLK_BREAK";
    list[#list+1] = "ADD_FORESTER";
    list[#list+1] = "ADD_WIDLING";
    list[#list+1] = "ADD_VELIAS";
    list[#list+1] = "ADD_PARAMUNE";
    list[#list+1] = "ADD_KLAIDA";
    list[#list+1] = "ADD_SMALLSIZE";
    list[#list+1] = "ADD_MIDDLESIZE";
    list[#list+1] = "ADD_LARGESIZE";
    list[#list+1] = "ADD_CLOTH";
    list[#list+1] = "ADD_LEATHER";
    list[#list+1] = "ADD_IRON";
    list[#list+1] = "ADD_GHOST";
    list[#list+1] = "ADD_FIRE";
    list[#list+1] = "ADD_ICE";
    list[#list+1] = "ADD_SOUL";
    list[#list+1] = "ADD_POISON";
    list[#list+1] = "ADD_LIGHTNING";
    list[#list+1] = "ADD_EARTH";
    list[#list+1] = "ADD_HOLY";
    list[#list+1] = "ADD_DARK";
    list[#list+1] = "Aries";
    list[#list+1] = "Slash";
    list[#list+1] = "Strike";
    list[#list+1] = "RES_FIRE";
    list[#list+1] = "RES_ICE";
    list[#list+1] = "RES_SOUL";
    list[#list+1] = "RES_POISON";
    list[#list+1] = "RES_LIGHTNING";
    list[#list+1] = "RES_EARTH";
    list[#list+1] = "RES_HOLY";
    list[#list+1] = "RES_DARK";
    list[#list+1] = "AriesDEF";
    list[#list+1] = "SlashDEF";
    list[#list+1] = "StrikeDEF";
    list[#list+1] = "HR";
    list[#list+1] = "DR";
	return list;

end
function GET_ATK_PROP_LIST()
	
	local list = {};
    list[#list+1] = "SR";
    list[#list+1] = "SDR";
    list[#list+1] = "MINATK";
    list[#list+1] = "MAXATK";
    list[#list+1] = "ADD_MAXATK";
    list[#list+1] = "ADD_MINATK";
    list[#list+1] = "ADD_MATK";
    list[#list+1] = "PATK";
    list[#list+1] = "MATK";
    list[#list+1] = "ADD_DEF";
    list[#list+1] = "STR";
    list[#list+1] = "DEX";
    list[#list+1] = "INT";
    list[#list+1] = "MNA";
    list[#list+1] = "CON";
    list[#list+1] = "MHP";
    list[#list+1] = "MSP";
    list[#list+1] = "MSTA";
    list[#list+1] = "CRTHR";
    list[#list+1] = "CRTDR";
    list[#list+1] = "CRTATK";
    list[#list+1] = "KDPow";
    list[#list+1] = "SkillPower";
    list[#list+1] = "ADD_HR";
    list[#list+1] = "ADD_DR";
    list[#list+1] = "MHR";
    list[#list+1] = "ADD_MHR";
    list[#list+1] = "MDEF";
    list[#list+1] = "ADD_MDEF";
    list[#list+1] = "SkillRange";
    list[#list+1] = "SkillAngle";
    list[#list+1] = "MSPD";
    list[#list+1] = "RHP";
    list[#list+1] = "RSP";
    list[#list+1] = "BLK";
    list[#list+1] = "BLK_BREAK";
    list[#list+1] = "ADD_FORESTER";
    list[#list+1] = "ADD_WIDLING";
    list[#list+1] = "ADD_VELIAS";
    list[#list+1] = "ADD_PARAMUNE";
    list[#list+1] = "ADD_KLAIDA";
    list[#list+1] = "ADD_SMALLSIZE";
    list[#list+1] = "ADD_MIDDLESIZE";
    list[#list+1] = "ADD_LARGESIZE";
    list[#list+1] = "ADD_CLOTH";
    list[#list+1] = "ADD_LEATHER";
    list[#list+1] = "ADD_IRON";
    list[#list+1] = "ADD_GHOST";
    list[#list+1] = "ADD_FIRE";
    list[#list+1] = "ADD_ICE";
    list[#list+1] = "ADD_SOUL";
    list[#list+1] = "ADD_POISON";
    list[#list+1] = "ADD_LIGHTNING";
    list[#list+1] = "ADD_EARTH";
    list[#list+1] = "ADD_HOLY";
    list[#list+1] = "ADD_DARK";
    list[#list+1] = "Aries";
    list[#list+1] = "Slash";
    list[#list+1] = "Strike";
    list[#list+1] = "RES_FIRE";
    list[#list+1] = "RES_ICE";
    list[#list+1] = "RES_SOUL";
    list[#list+1] = "RES_POISON";
    list[#list+1] = "RES_LIGHTNING";
    list[#list+1] = "RES_EARTH";
    list[#list+1] = "RES_HOLY";
    list[#list+1] = "RES_DARK";
    list[#list+1] = "AriesDEF";
    list[#list+1] = "SlashDEF";
    list[#list+1] = "StrikeDEF";
    list[#list+1] = "HR";
    list[#list+1] = "DR";
	return list;

end

function GET_MAINOPTION(classID)
    local invitem = GetClassByType("Item", classID);
    local min, max = GET_BASIC_ATK_FOR_EXPORT(invitem);
    local magic = GET_BASIC_MATK_FOR_EXPORT(invitem);
    print("armordef:" .. invitem.DEF);
    print("armormagicdef:" .. invitem.MDEF);
    return min, max, magic;
end
function GET_DEF(classID)
    local item = GetClassByType("Item", classID);

end

function SCR_REFRESH_ACC_FOR_EXPORT(item, enchantUpdate, ignoreReinfAndTranscend)
    if ignoreReinfAndTranscend == nil then
        ignoreReinfAndTranscend = 0;
    end

    local class = GetClassByType('Item', item.ClassID);
    INIT_ARMOR_PROP_FOR_EXPORT(item, class);
    item.Level = GET_ITEM_LEVEL(item);

    local lv = TryGetProp(item, "UseLv");
    if lv == nil then
        return 0;
    end
    
    local hiddenLv = TryGetProp(item,"ItemLv");
    if hiddenLv == nil then
        return 0 ;
    end
    
    if hiddenLv > 0 then
        lv = hiddenLv;
    end
    
    if (GetServerNation() == "KOR" and (GetServerGroupID() == 9001 or GetServerGroupID() == 9501)) then
        local kupoleItemLv = SRC_KUPOLE_GROWTH_ITEM(item, 1);
        if kupoleItemLv ==  nil then
            lv = lv;
        elseif kupoleItemLv > 0 then
            lv = kupoleItemLv;
        end
    end
    
    local classType = TryGetProp(item,"ClassType");
    if classType == nil then
        return 0;
    end
    
    local accRatio;
    
    if classType == 'Neck' then
        accRatio = 5.5;
    elseif classType == 'Ring' then
        accRatio = 11;
    elseif classType == 'Hat' then
        accRatio = 0;
    else
        return 0;
    end

    local grade = TryGetProp(item,"ItemGrade");
    if grade == nil then
            return 0;
    end
    
    local gradeRatio = SCR_GET_ITEM_GRADE_RATIO_FOR_EXPORT(grade, "BasicRatio");

    local PropName = {"DEF", "MDEF", "HR", "DR",  "MHR", "ADD_FIRE", "ADD_ICE", "ADD_LIGHTNING", "DefRatio", "MDefRatio"};
    local changeProp = {};
    
    local basicTooltipPropList = StringSplit(item.BasicTooltipProp, ';');
    for i = 1, #basicTooltipPropList do
        local basicProp = basicTooltipPropList[i];
    
        if basicProp == 'DEF' then
            changeProp["DEF"] = ((20 + lv*3)/accRatio) * gradeRatio + GET_REINFORCE_ADD_VALUE_FOR_EXPORT(basicProp, item, ignoreReinfAndTranscend)
            changeProp["DEF"] = SyncFloor(changeProp["DEF"]);
            changeProp["DefRatio"] = math.floor(item.Reinforce_2 * 0.1);
        elseif basicProp == 'MDEF' then
            changeProp["MDEF"] = ((20 + lv*3)/accRatio) * gradeRatio + GET_REINFORCE_ADD_VALUE_FOR_EXPORT(basicProp, item, ignoreReinfAndTranscend)
            changeProp["MDEF"] = SyncFloor(changeProp["MDEF"]);
        elseif basicProp == 'ADD_FIRE' then
            changeProp["ADD_FIRE"] = math.floor(lv * gradeRatio + GET_REINFORCE_ADD_VALUE_FOR_EXPORT(basicProp, item, ignoreReinfAndTranscend));
            changeProp["ADD_FIRE"] = SyncFloor(changeProp["ADD_FIRE"]);
        elseif basicProp == 'ADD_ICE' then
            changeProp["ADD_ICE"] = math.floor(lv * gradeRatio + GET_REINFORCE_ADD_VALUE_FOR_EXPORT(basicProp, item, ignoreReinfAndTranscend));
            changeProp["ADD_ICE"] = SyncFloor(changeProp["ADD_ICE"]);
        elseif basicProp == 'ADD_LIGHTNING' then
            changeProp["ADD_LIGHTNING"] = math.floor(lv * gradeRatio + GET_REINFORCE_ADD_VALUE_FOR_EXPORT(basicProp, item, ignoreReinfAndTranscend));
            changeProp["ADD_LIGHTNING"] = SyncFloor(changeProp["ADD_LIGHTNING"]);
        end
    end

    for i = 1, #PropName do
        if changeProp[PropName[i]] ~= nil then
            if changeProp[PropName[i]] ~= 0 then
                item[PropName[i]] = changeProp[PropName[i]];
            end
        end
    end

    local propNames, propValues = GET_ITEM_TRANSCENDED_PROPERTY(item, ignoreReinfAndTranscend);
    for i = 1 , #propNames do
        local propName = propNames[i];
        local propValue = propValues[i];
        local upgradeRatio = 1 + propValue / 100;
        item[propName] = math.floor( item[propName] * upgradeRatio );
    end

end

function SCR_REFRESH_ARMOR_FOR_EXPORT(item, enchantUpdate, ignoreReinfAndTranscend, reinfBonusValue)
    if enchantUpdate == nil then
        enchantUpdate = 0
    end
    
    if ignoreReinfAndTranscend == nil then
        ignoreReinfAndTranscend = 0;
    end
    
    if reinfBonusValue == nil then
        reinfBonusValue = 0;
    end
    
    local class = GetClassByType('Item', item.ClassID);
    INIT_ARMOR_PROP_FOR_EXPORT(item, class);
    item.Level = GET_ITEM_LEVEL(item);
    
    local lv = TryGetProp(item , "UseLv");
    if lv == nil then
        return 0;
    end
    local hiddenLv = TryGetProp(item, "ItemLv");
    if hiddenLv == nil then
        return 0;
    end
    
    if hiddenLv > 0 then
        lv = hiddenLv;
    end
    
    if (GetServerNation() == "KOR" and (GetServerGroupID() == 9001 or GetServerGroupID() == 9501)) then
        local kupoleItemLv = SRC_KUPOLE_GROWTH_ITEM(item, 1);
        if kupoleItemLv ==  nil then
            lv = lv;
        elseif kupoleItemLv > 0 then
            lv = kupoleItemLv;
        end
    end
    
    local def=0;
    local hr =0;
    local dr =0;
    local mhr=0;
    local mdef=0;
    local fireAtk = 0;
    local iceAtk = 0;
    local lightningAtk = 0;
    local defRatio = 0;
    local mdefRatio = 0;
    
    local basicTooltipPropList = StringSplit(item.BasicTooltipProp, ';');
    for i = 1, #basicTooltipPropList do
        local basicProp = basicTooltipPropList[i];
        
        local buffarg = 0;
        
        local grade = TryGetProp(item,"ItemGrade");
        if grade == nil then
            return 0;
        end
          
        local gradeRatio = SCR_GET_ITEM_GRADE_RATIO_FOR_EXPORT(grade, "BasicRatio");
          
        if enchantUpdate == 1 then
            buffarg = GetExProp(item, "Rewards_BuffValue");
        end
        
        local equipMaterial = TryGetProp(item, "Material");
        if equipMaterial == nil then
            return 0;
        end
        
        local classType = TryGetProp(item,"ClassType");
        if classType == nil then
            return 0;
        end
        local equipRatio;
        
        if classType == 'Shirt' or classType == 'Pants' or classType == 'Shield'then
                equipRatio = 3.5;
        elseif classType == 'Boots' or classType == 'Gloves' then
                equipRatio = 4.5;
        else
            return 0;
        end
        
        local upgradeRatio = 1;        
        if basicProp == 'DEF' then
            def = ((20 + lv*3)/equipRatio) * gradeRatio;
            upgradeRatio = upgradeRatio + GET_UPGRADE_ADD_DEF_RATIO(item, ignoreReinfAndTranscend) / 100;            
            if item.Material == 'Cloth' then
                def = def * 0.6;
            elseif equipMaterial == 'Leather' then
                def = def * 0.6;
            elseif equipMaterial == 'Iron' then
                def = def * 1.0;
            end
                
            if def < 1 then
                def = 1;
            end
            
            def = math.floor(def) * upgradeRatio + GET_REINFORCE_ADD_VALUE_FOR_EXPORT(basicProp, item, ignoreReinfAndTranscend, reinfBonusValue) + buffarg
            def = SyncFloor(def);            
            print("def" .. def);
        elseif basicProp == 'MDEF' then
            mdef = ((20 + lv*3)/equipRatio) * gradeRatio;
            upgradeRatio = upgradeRatio + GET_UPGRADE_ADD_MDEF_RATIO(item, ignoreReinfAndTranscend) / 100;
            if equipMaterial == 'Cloth' then
                mdef = mdef * 1.0;
            elseif equipMaterial == 'Leather' then
                mdef = mdef * 0.6;
            elseif equipMaterial == 'Iron' then
                mdef = mdef * 0.6;
            end
            
            if mdef < 1 then
                mdef = 1;
            end
    
           mdef = math.floor(mdef) * upgradeRatio + GET_REINFORCE_ADD_VALUE_FOR_EXPORT(basicProp, item, ignoreReinfAndTranscend, reinfBonusValue) + buffarg
           mdef = SyncFloor(mdef);
        end
    end

    item.HR = hr;
    item.DR = dr;
    item.DEF = def;
    item.MHR = mhr;
    item.MDEF = mdef;
    item.DefRatio = defRatio;
    item.MDefRatio = mdefRatio;
    item.ADD_FIRE = fireAtk;
    item.ADD_ICE = iceAtk;
    item.ADD_LIGHTNING = lightningAtk;

end


function INIT_ARMOR_PROP_FOR_EXPORT(item, class)

    item.DEF = class.DEF;
    item.MDEF = class.MDEF;
    item.ADD_DEF = class.ADD_DEF;
    item.ADD_MDEF = class.ADD_MDEF;
    item.ADD_MINATK = class.ADD_MINATK;
    item.ADD_MAXATK = class.ADD_MAXATK;
    item.ADD_MATK = class.ADD_MATK;
    item.MINATK = class.MINATK;
    item.MAXATK = class.MAXATK;
    
    item.PATK = class.PATK;
    item.MATK = class.MATK;
    item.CRTHR = class.CRTHR;
    item.CRTATK = class.CRTATK;
    item.CRTDR = class.CRTDR;
    item.HR = class.HR;
    item.DR = class.DR;
    item.ADD_HR = class.ADD_HR;
    item.ADD_DR = class.ADD_DR;
    item.STR = class.STR;
    item.DEX = class.DEX;
    item.CON = class.CON;
    item.INT = class.INT;
    item.MNA = class.MNA;
    item.SR = class.SR;
    item.SDR = class.SDR;
    item.MHR = class.MHR;
    item.ADD_MHR = class.ADD_MHR;
    item.MGP = class.MGP;
    item.AddSkillMaxR = class.AddSkillMaxR;
    item.SkillRange = class.SkillRange;
    item.SkillAngle = class.SkillAngle;
    item.BlockRate = class.BlockRate;
    item.BLK = class.BLK;
    item.BLK_BREAK = class.BLK_BREAK;
    item.MSPD = class.MSPD;
    item.KDPow = class.KDPow;
    item.MHP = class.MHP;
    item.MSP = class.MSP;
    item.MSTA = class.MSTA;
    item.RHP = class.RHP;
    item.RSP = class.RSP;
    item.RSPTIME = class.RSPTIME;
    item.RSTA = class.RSTA;
    item.ADD_CLOTH = class.ADD_CLOTH;
    item.ADD_LEATHER = class.ADD_LEATHER;
    item.ADD_CHAIN = class.ADD_CHAIN;
    item.ADD_IRON = class.ADD_IRON;
    item.ADD_GHOST = class.ADD_GHOST;
    item.ADD_SMALLSIZE = class.ADD_SMALLSIZE;
    item.ADD_MIDDLESIZE = class.ADD_MIDDLESIZE;
    item.ADD_LARGESIZE = class.ADD_LARGESIZE;
    item.ADD_FORESTER = class.ADD_FORESTER;
    item.ADD_WIDLING = class.ADD_WIDLING;
    item.ADD_VELIAS = class.ADD_VELIAS;
    item.ADD_PARAMUNE = class.ADD_PARAMUNE;
    item.ADD_KLAIDA = class.ADD_KLAIDA;
    item.Aries = class.Aries;
    item.Slash = class.Slash;
    item.Strike = class.Strike;
    item.AriesDEF = class.AriesDEF;
    item.SlashDEF = class.SlashDEF;
    item.StrikeDEF = class.StrikeDEF;
    item.ADD_FIRE = class.ADD_FIRE;
    item.ADD_ICE = class.ADD_ICE;
    item.ADD_POISON = class.ADD_POISON;
    item.ADD_LIGHTNING = class.ADD_LIGHTNING;
    item.ADD_SOUL = class.ADD_SOUL;
    item.ADD_EARTH = class.ADD_EARTH;
    item.ADD_HOLY = class.ADD_HOLY;
    item.ADD_DARK = class.ADD_DARK;
    item.RES_FIRE = class.RES_FIRE;
    item.RES_ICE = class.RES_ICE;
    item.RES_POISON = class.RES_POISON;
    item.RES_LIGHTNING = class.RES_LIGHTNING;
    item.RES_SOUL = class.RES_SOUL;
    item.RES_EARTH = class.RES_EARTH;
    item.RES_HOLY = class.RES_HOLY;
    item.RES_DARK = class.RES_DARK;
    
end
function SCR_GET_ITEM_GRADE_RATIO(grade, prop)
    local class = GetClassByNumProp("item_grade", "Grade", grade)
    if class == nil then
        return 0;
    end
    
    local value = TryGetProp(class, prop);
    if value == nil then
        return 0;
    end
    
    value = value / 100;
    
    return value;
end

function GET_REINFORCE_ADD_VALUE_FOR_EXPORT(prop, item, ignoreReinf, reinfBonusValue)
    if ignoreReinf == 1 then
        return 0;
    end
    if reinfBonusValue == nil then
        reinfBonusValue = 0;
    end
    local value = 0;
    local buffValue =  TryGetProp(item,"BuffValue");
    if buffValue == nil then
        return 0;
    end
    
    local reinforceValue = TryGetProp(item,"Reinforce_2");
    if reinforceValue == nil then
        return 0;
    end
    
    local lv = TryGetProp(item, "UseLv");
    if lv == nil then
        return 0;
    end
    
    if (GetServerNation() == "KOR" and (GetServerGroupID() == 9001 or GetServerGroupID() == 9501)) then
        local kupoleItemLv = SRC_KUPOLE_GROWTH_ITEM(item, 1);
        if kupoleItemLv ==  nil then
            lv = lv;
        elseif kupoleItemLv > 0 then
            lv = kupoleItemLv;
        end
    end
    
    local classType = TryGetProp(item,"ClassType");
    if classType == nil then
        return 0;
    end

    local grade = TryGetProp(item,"ItemGrade");
    if grade == nil then
        return 0;
    end
    
    local gradeRatio = SCR_GET_ITEM_GRADE_RATIO_FOR_EXPORT(grade, "ReinforceRatio")
    
    local typeRatio;
    
    if classType == 'Shirt' or classType == 'Pants' or classType == 'Shield' then
        typeRatio = 3.5;
    elseif classType == 'Gloves' or classType == 'Boots' then
        typeRatio = 4.5;
    elseif classType == 'Neck' then
        typeRatio = 5.5;
    elseif classType == 'Ring' then
        typeRatio = 11;
    else
        return 0;
    end
    
    local value;
    
    reinforceValue = reinforceValue + reinfBonusValue;
    
    value = math.floor((reinforceValue + (lv * (reinforceValue * (0.08 + (math.floor((math.min(21,reinforceValue)-1)/5) * 0.015 )))) / typeRatio)) * gradeRatio;
    value = value * (item.ReinforceRatio / 100) + buffValue;

    return SyncFloor(value);
end
function GET_BASIC_ATK_FOR_EXPORT(item)
    local lv = TryGetProp(item,"UseLv");
    if lv == nil then
        return 0;
    end
    
    local hiddenLv = TryGetProp(item,"ItemLv");        
    if hiddenLv > 0 then
        lv = hiddenLv;
    end
    
    if (GetServerNation() == "KOR" and (GetServerGroupID() == 9001 or GetServerGroupID() == 9501)) then
        local kupoleItemLv = SRC_KUPOLE_GROWTH_ITEM(item , 1);
        if kupoleItemLv ==  nil then
            lv = lv;
        elseif kupoleItemLv > 0 then
            lv = kupoleItemLv;
        end
    end
    
    local grade = TryGetProp(item, "ItemGrade");
    if grade == nil then
        return 0;
    end
    
    local gradeRatio = SCR_GET_ITEM_GRADE_RATIO_FOR_EXPORT(grade, "BasicRatio");
    local itemATK = (20 + ((lv)*3)) * gradeRatio;
    if lv == 0 then
        itemATK = 0;
    end

    local slot = TryGetProp(item,"DefaultEqpSlot");
    if slot == nil then
        return 0;
    end
    
    local classType = TryGetProp(item,"ClassType");
    if classType == nil then
        return 0;
    end
    
    local damageRange = TryGetProp(item,"DamageRange")/100;
    if damageRange == nil then
        return 0;
    end
    
    if slot == "RH" then
        if classType == 'THSpear' then
            itemATK = itemATK * 1.3;
        elseif classType == 'Spear' then
            itemATK = itemATK * 1.1;
        elseif classType == 'Mace' then
            itemATK = itemATK * 0.9;
        elseif classType == 'Bow' or classType == 'Rapier' then
            itemATK = itemATK * 1.0;
        else
            itemATK = itemATK * 1.2;
        end
   elseif slot == "RH LH" then
       if classType == 'Sword' then
           itemATK = itemATK * 1.0;
       end
   elseif slot == "LH" then
        if classType == 'Cannon' then
            itemATK = itemATK * 1.1;
        elseif classType == 'Pistol' then
            itemATK = itemATK * 1.0;
        else
            itemATK = itemATK * 0.9;
        end
    else
        return 0;
    end

    local maxAtk = SyncFloor(itemATK * damageRange);
    local minAtk = SyncFloor(itemATK * (2 - damageRange));
    return maxAtk, minAtk;
end

function GET_BASIC_MATK_FOR_EXPORT(item)
    local grade = TryGetProp(item, "ItemGrade");
    if grade == nil then
        return 0;
    end

    local lv = TryGetProp(item,"UseLv");
    if lv == nil then
        return 0;
    end

    if lv == 0 then
        itemATK = 0;
    end

    local hiddenLv = TryGetProp(item,"ItemLv");
    if hiddenLv == nil then
        return 0;
    end    

    if hiddenLv > 0 then
        lv = hiddenLv 
    end
    
    if (GetServerNation() == "KOR" and (GetServerGroupID() == 9001 or GetServerGroupID() == 9501)) then
        local kupoleItemLv = SRC_KUPOLE_GROWTH_ITEM(item, 1);
        if kupoleItemLv ==  nil then
            lv = lv;
        elseif kupoleItemLv > 0 then
            lv = kupoleItemLv;
        end
    end

    local gradeRatio = SCR_GET_ITEM_GRADE_RATIO_FOR_EXPORT(grade, "BasicRatio");
    local itemATK = (20 + ((lv)*3)) * gradeRatio;
    local classType = TryGetProp(item,"ClassType");
    if classType == nil then
        return 0;
    end
    
    if classType == 'THStaff' then
        itemATK = itemATK * 1.2;
    elseif classType == 'Staff' then
        itemATK = itemATK * 1.0;
    elseif classType == 'Mace' then
        itemATK = itemATK * 0.9;
    else
        return 0;
    end
    
    return itemATK;
end

function GET_ITEM_DESCS(classID)
    local list = {};


    local invitem = GetClassByType("Item", classID);
    local clslist, cnt = GetClassList('SkillTree');


    local basicTooltipPropList = StringSplit(invitem.BasicTooltipProp, ';');

    local basiclist = GET_EQUIP_TOOLTIP_PROP_LIST_FOR_EXPORT(invitem);

    for i = 1, #basicTooltipPropList do
        local basicTooltipProp = basicTooltipPropList[i];
        list = GET_CHECK_OVERLAP_EQUIPPROP_LIST_FOR_EXPORT(basiclist, basicTooltipProp, list);
    end
   

    local mainOption = "";
    if invitem.GroupName == "Weapon" or invitem.GroupName == "SubWeapon" then
        local min, max = GET_BASIC_ATK_FOR_EXPORT(invitem);
        if min ~= 0 then
            mainOption = mainOption .. GetClass("ClientMessage", "PATK").Data .. " " .. min .. " ~ " .. max .. ",";
        end
        local magic = GET_BASIC_MATK_FOR_EXPORT(invitem);
        if magic ~= 0 then
           mainOption = mainOption .. GetClass("ClientMessage", "MATK").Data .. " " .. magic .. ",";
        end

    else
        SCR_REFRESH_ARMOR_FOR_EXPORT(invitem, 0, 0, 0);
        SCR_REFRESH_ACC_FOR_EXPORT(invitem, 0, 0);
        if invitem.DEF ~= 0 then
            mainOption = mainOption .. GetClass("ClientMessage", "DEF").Data .. " " .. invitem.DEF .. ",";
        end
        if invitem.MDEF ~= 0 then
            mainOption = mainOption .. GetClass("ClientMessage", "MDEF").Data .. " " .. invitem.MDEF .. ",";
        end
        if mainOption == "" then -- 물방, 마방과 같은 메인 옵션이 없는 경우(장신구)
             local PropName = {"HR", "DR",  "MHR", "ADD_FIRE", "ADD_ICE", "ADD_LIGHTNING", "DefRatio", "MDefRatio"};
             for i = 1, #PropName do
                if invitem[PropName[i]] ~= nil and invitem[PropName[i]] ~= 0 then
                    mainOption = GetClass("ClientMessage", PropName[i]).Data .. " " .. invitem[PropName[i]];
                end
             end
        end
    end


    local subOption = "";
    for i = 1 , #list do

		local propName = list[i];
		local propValue = invitem[propName];
        local translatedProp = GetClass("ClientMessage", propName);
        if propValue ~= 0 then
            if invitem.GroupName == "Weapon" or invitem.GroupName == "SubWeapon" then
                if propName ~= "PATK" and propName ~= "MATK" then
                    subOption = subOption  .. translatedProp.Data .. " " .. propValue .. ","
                end
            else
                if propName ~= "DEF" and propName ~= "MDEF" then
                    subOption = subOption  .. translatedProp.Data .. " " .. propValue .. ","
                end
            end

        end
	end


    return subOption, mainOption;
end
function TEST_BINDFUNC(self, mon)
  print("TEST_BINDFUNC");
  return 1;
end
function TEST_GETNEAR(pc)
  local nearEnemy = GetNearEnemy(pc);
  if nearEnemy == nil then
    print("nearEnemy is nil")
    return
  end
  local selectedEnemy = GetNearEnemyFromFunc(nearEnemy, "TEST_BINDFUNC")
  if selectedEnemy ~= nil then
    print("selectedEnemy:" .. selectedEnemy.ClassName)
  else
    print("selectedEnemy is NIL")
  end
end
function GET_ITEM_PROPERTY(pc)

    local clsList, cnt = GetClassList('Item');

    local solmickey = GetClass('Item', 'MAC04_110');
    print(solmickey.Name); -- 이름
    print(solmickey.Weight); -- 무게
    print(solmickey.ReqToolTip); -- 한손둔기
    print(solmickey.TeamTrade);
    print(solmickey.ShopTrade);
    print(solmickey.MarketTrade);
    print(solmickey.UserTrade);
    print(solmickey.UseJob) -- 무기 사용 가능 클래스

    for i = 0, 3 do
        local item = GetClassByIndexFromList(clsList, i);
        if item.ItemType == "Equip" then
           
            

        end
        
    end
end

function EXPORT_ALL_SKILLS(pc, fileDir)

    if fileDir == nil or fileDir == "" then
        print("fileDir is nil")
        return;
    end

    local clslist, cnt = GetClassList('SkillTree');
    local skillClsList, skillCnt = GetClassList('Skill');
 
    --[[
    현재 레벨, 
    CaptionTime,
    CaptionRatio, 
    CaptionRatio2, 
    CaptionRatio3, 
    CaptionTime,
    SpendSP
    ]]--
    

    local jobID = TryGetProp(pc, "Job");
    local firstSkill, lastSkill; 
    
        -- 해당 클래스가 배울 수 있는 스킬트리의 수 만큼
    for i = 0, cnt do
        local cls = GetClassByIndexFromList(clslist, i);

        ret = ""

        local skillProperty = GetClass('Skill', cls.SkillName); 
        
        --UnlockGrade:언락되는 서클
        local maxLv = (4 - cls.UnlockGrade) * cls.LevelPerGrade;
        local multFactor = 9;
         --스킬 곱셈 팩터 = 최대랭(8) + 1 - 스킬의 직업 랭크
        if skillProperty.Rank ~= "None" then
          multFactor = 10 - skillProperty.Rank;
        else
          print("No-Rank skill:" .. cls.SkillName);
        end
        
        --3보다 작을 경우 6랭크 이상 스킬
        if multFactor < 3 then
          maxLv = multFactor * cls.LevelPerGrade;
        end;
        
        --MaxLevel프로퍼티가 디폴트 20이 아닌 경우 MaxLevel프로퍼티 값으로 오버라이드
        if cls.MaxLevel ~= 20 then
            maxLv = cls.MaxLevel
        end

        --스킬의 최대 레벨만큼
        for j = 1, maxLv do
           ret = ret .. j .. "/"; 

           local tx = TxBegin(pc);
           skilLv = tonumber(j)
           local sklObj = GetSkill(pc, cls.SkillName);

           if sklObj == nil then
                local idx = TxAddSkill(tx, cls.SkillName);
                TxAppendProperty(tx, idx, 'LevelByDB', skilLv);
            else
                TxSetIESProp(tx, sklObj, 'LevelByDB', skilLv);
            end

            TxCommit(tx);
           local skillCls = GetSkill(pc, cls.SkillName);
           if skillCls.CaptionTime == nil then
              ret = ret .. 0 .. "/";
           else
              ret = ret .. skillCls.CaptionTime .. "/";
           end
           if skillCls.SkillFactor == nil then
              ret = ret .. 0 .. "/";
           else
              ret = ret .. skillCls.SkillFactor .. "/";
           end
           if skillCls.SkillSR == nil then
              ret = ret .. 0 .. "/";
            else
              ret = ret .. skillCls.SkillSR .. "/";
           end
           if skillCls.CaptionRatio == nil then
              ret = ret .. 0 .. "/";
            else
              ret = ret .. skillCls.CaptionRatio .. "/";
           end
           if skillCls.CaptionRatio2 == nil then
              ret = ret .. 0 .. "/";
            else
              ret = ret .. skillCls.CaptionRatio2 .. "/";
           end
           if skillCls.CaptionRatio3 == nil then
              ret = ret .. 0 .. "/";
            else
              ret = ret .. skillCls.CaptionRatio3 .. "/";
           end
		   if skillCls.SpendItemCount == nil then
		     ret = ret .. 0 .. "/";
            else
              ret = ret .. skillCls.SpendItemCount .. "/";
           end
           if skillCls.SpendPoison == nil then
		     ret = ret .. 0 .. "/";
            else
              ret = ret .. skillCls.SpendPoison .. "/";
           end
           if skillCls.SkillAtkAdd == nil then
		     ret = ret .. 0 .. "/";
            else
              ret = ret .. skillCls.SkillAtkAdd .. "/";
           end
           if skillCls["CoolDown"] == nil then
              ret = ret .. 0 .. "/";
            else
              ret = ret .. skillCls["CoolDown"] * 0.001 .. "/";
           end
           if skillCls.SpendSP == nil then
              ret = ret .. 0 .. "/";
            else
              ret = ret .. skillCls.SpendSP .. "{nl}";
           end
        end                                                 --쿨다운에 sp소모량이 들어감..?
        ExportSkillDescJson(pc, cls.SkillName, ret, maxLv, fileDir);
    end
end

function SET_SKL_LV(pc, skillName, skilLv)

	local tx = TxBegin(pc);
	skilLv = tonumber(skilLv)
	local sklObj = GetSkill(pc, skillName);

	if sklObj == nil then
		local idx = TxAddSkill(tx, skillName);
		TxAppendProperty(tx, idx, 'LevelByDB', skilLv);
	else
		TxSetIESProp(tx, sklObj, 'LevelByDB', skilLv);
	end

	local ret = TxCommit(tx);
	
	InvalidateStates(pc);
end

function TEST_KB_END(actor, from)
	
	Chat(actor, "KB".. os.clock());
	Chat(from, "ATTACK".. os.clock());

end

function TEST_F_1(pc, isOn)

	if isOn == "1" then
		Chat(pc, "OPN");
		AttachEffect(pc, "bg_waterfall_down_2", 6.0);
	else
		Chat(pc, "OPFF");
		AttachEffect(pc, "bg_waterfall_down_2", 0.0);
	end

end

function TEST_JJH(pc)

	print(pc.MHP);
	print(pc.MHP);
	
	InvalidateStates(pc);
	
	print(pc.MHP);
	
	
	
	
	--local clsList, cnt = GetClassList("Skill");
	
--	JJHTest(pc);
	
   	
end




function SCR_MON_LYG_TEST_TS_BORN_ENTER(self)
    ObjectColorBlend(self, 10,130,255,150, 1)
end

function SCR_MON_LYG_TEST_TS_BORN_UPDATE(self)

end

function SCR_MON_LYG_TEST_TS_BORN_LEAVE(self)
end


function SCR_MON_LYG_TEST_TS_DEAD_ENTER(self)
end

function SCR_MON_LYG_TEST_TS_DEAD_UPDATE(self)
end

function SCR_MON_LYG_TEST_TS_DEAD_LEAVE(self)
end

function TEST_Charm(self)
	print('2hi');
	local objList, objCount = SelectObject(self, 100, 'ALL');
	for i = 1, objCount do
		local obj = objList[i];	
		AddBuff(obj, obj, 'Rest', 1, 0, 30000, 1, 10000);
	end
	AddBuff(self, self, 'Rest', 1, 0, 30000, 1, 10000);
end

function TEST_STUN(self)
	local objList, objCount = SelectObject(self, 100, 'ALL');
	for i = 1, objCount do
		local obj = objList[i];	
		AddBuff(obj, obj, 'Stun', 1, 0, 3000, 1, 100);
	end
	AddBuff(self, self, 'Stun', 1, 0, 3000, 1, 100);
end

function NPC_DE(self)

	local objList, objCount = SelectObject(self, 250, 'ALL', 1);
	for i = 0, objCount do
		local obj = objList[i];	
		if obj ~= nil then
			
			local dialog, enter = ShowNpcDialogAndEnter(obj);
			if GetGenTypeID(obj) ~= nil then
    			Chat(obj, "Dialog : "..dialog.." / Enter : "..enter.." / GenID : "..GetGenTypeID(obj));
	    		print("Dialog : ",dialog," / Enter : ",enter," / GenID : ",GetGenTypeID(obj))
	    	else
	    	    Chat(obj, "Dialog : "..dialog.." / Enter : "..enter);
	    		print("Dialog : ",dialog," / Enter : ",enter)
	    	end
		end
	end

end

function TEST_BLEND(self)
	local objList, objCount = SelectObject(self, 100, 'ALL');
	
	for i = 1, objCount do
		local obj = objList[i];
		ObjectColorBlend(obj, 255, 255, 255, 50, 0);
	end

	ObjectColorBlend(self, 255, 255, 255, 50, 0);
end

function TEST_FLY(self)
	
	local objList, objCount = SelectObject(self, 100, 'ALL');
	
	for i = 1, objCount do
		local obj = objList[i];
		local x, y, z = GetPos(obj)
		SetPos(obj, x, y+30, z)
		Fly(obj, -1)
	end

end

function TEST_FLYOFF(self)
	
	Fly(self, 0)
end


function TEST_OBB1(self)
	
	local objList, objCount = SelectObject(self, 100, 'ALL');
	
	for i = 1, objCount do
		local obj = objList[i];
		CreateMonOBB(obj, 30, 30, 50);
		Chat(obj, "test")
	end

end

function TEST_OBB2(self)
	
	local objList, objCount = SelectObject(self, 100, 'ALL');
	
	for i = 1, objCount do
		local obj = objList[i];
		RemoveMonOBB(obj);
	end

end

function TEST_P(pc)
	
	print(pc.SkillPtsByLevel)
end

function TEST_SKL_P(pc)
	
    local before_point = pc.SkillPtsByLevel
	local tx = TxBegin(pc);
    TxSetIESProp(tx, pc, "SkillPtsByLevel", before_point + 1)
    local ret = TxCommit(tx);
    
end

function TEST_SKLEXP(self)
	local objList, objCount = SelectObject(self, 100, 'ALL');
	for i=0, objCount do
		local obj = objList[i];
		if obj ~= nil then
			PlaySklExpEffect(self, obj, 2, 'None');
		end
	end
end

function TEST_KD(self)
	KnockDown(self, self, 180, 40, 60, 3); 
end

function TEST_KD1(self)

	EquipDummyItemSpot(self, self,9999993, 'LH', 0);
	EquipDummyItemSpot(self, self,101109, 'RH', 0);
end

function TEST_KD2(self)
	
	local objList, objCount = SelectObject(self, 100, 'ALL');	
	for i=0, objCount do
		local obj = objList[i];
		if obj ~= nil then			
			PushActorEnd(obj, 'test_push');
		end
	end
	
	PushActorEnd(self, 'test_push');
end

function TEST_MR(self, mrName)
	print(mrName)
	for i=1, 10 do
		local name, value = GetInfoMR(mrName, i);
		print(name, value)
	end
end

function TEST_ANI(self, aniname)
    PlayAnim(self, aniname, 1)
end

function TEST_APK(self)

	local objList, objCount = SelectObject(self, 50, 'ALL');
	
	if objCount == 0 then
		return;
	end

	for i=0, objCount do
		local obj = objList[i];
		if obj ~= nil then			
			if obj.ClassName == 'Mon_alpaka' or obj.ClassName == "Velhider" then
				SetCompanionInfo(self, obj, obj.ClassName);
				RunSimpleAI(obj, "companion");
				return;
			end
		end
	end
end

function TEST_APK_R(self)

	local objList, objCount = SelectObject(self, 50, 'ALL');
	
	if objCount == 0 then
		return;
	end

	for i=0, objCount do
		local obj = objList[i];
		if obj ~= nil then			
			if obj.ClassName == 'Mon_alpaka' or obj.ClassName == "Velhider" then
				Chat(self ,"SELF");
				Chat(obj, "OBJ");
				RideVehicle(self, obj, 1);
				return;
			end
		end
	end
end

function testhide1(self)
		
	SendAddOnMsg(self, "NPC_HIDE_MAP", 'SIAUL_WEST_CAMP_MANAGER', 1);
end

function testhide2(self)
		
	SendAddOnMsg(self, "NPC_HIDE_MAP", 'SIAUL_WEST_CAMP_MANAGER', 0);
end

function SCR_RINGTEST(self)
		
	local objList, objCount = SelectObject(self, 100, 'ALL');	
	for i = 1, objCount do
		local obj = objList[i];
		ObjectColorBlend(obj, 255, 255, 255, 20, 1);
	end
	print('123')
end

function SCR_MADNESS(self)
		
	local objList, objCount = SelectObject(self, 100, 'ENEMY');	
	
	local index = IMCRandom(1, objCount);		
	local obj = objList[index];
	
	AddBuff(self, obj, 'Confuse', 1, 0, 10000, 1);	
end

function SCR_KBTEST(self)
		
	local objList, objCount = SelectObject(self, 100, 'ALL');	
	for i = 1, objCount do
		local obj = objList[i];
		local angle = GetAngleTo(self, obj);
		KnockBack(self, obj, 150, angle, 15, 1);
	end
end

function SCR_TESTKILL(self)
	local objList, objCount = SelectObject(self, 100, 'ALL');	
	for i = 1, objCount do
		local obj = objList[i];
		Kill(obj);
	end
end

function FACE_TEST(self)
	--SetFaceState(self, 'base');
	--SetFaceState(self, 'atk');
	SetFaceState(self, 'astd');
end

function TEST_EF(pc)

	local x, y, z = GetPos(pc)
	local rotate = GetDirectionByAngle(pc)
	PlayEffectToGround(pc, "F_circle25_red", x, y, z, 1, 2, 0, rotate)
end

function TEST_NS(pc)

	SendAddOnMsg(pc, "NOTICE_SCREEN", ScpArgMsg("Auto_MeSiJi_TeSeuTeu"), 3);
end

function TEST_EFFECT(pc, str)
    PlayEffect(pc, 'I_test_test')
end

function TEST_EFFECT2(pc, str)
    PlayEffect(pc, 'I_test_test2')
end

function TEST_ABC(pc, str)
    PlayEffect(pc, "E_warrior_assistattack_dagger_shot")
    print('Play Effect : '..str)
end


function TEST_NT(pc)

	SendAddOnMsg(pc, "KEYBOARD_TUTORIAL", "", 0);
end

function TEST_SHOW_ITEM_ALL_GROUPNAME(pc)

    local equipList, equipCnt = GetClassList("Item");
	local namelist = {}

    for i = 1, equipCnt do

        local equipItem = GetClassByIndexFromList(equipList, i);

		local bo = 1

		for j = 1, #namelist do
			if namelist[j] == equipItem.GroupName then
				bo = 0
			end
		end

		if bo == 1 then
			print(equipItem.GroupName)
			namelist[#namelist+1] = equipItem.GroupName
		end

	end
end

function TEST_SHOW_ITEM_ALL_CLASSTYPE(pc)

    local equipList, equipCnt = GetClassList("Item");
	local namelist = {}

    for i = 1, equipCnt do

        local equipItem = GetClassByIndexFromList(equipList, i);

		if GetPropType(equipItem, "ClassType") ~= nil then

			local bo = 1

			for j = 1, #namelist do
				if namelist[j] == equipItem.ClassType then
					bo = 0
				end
			end

			if bo == 1 then
				print(equipItem.ClassType)
				namelist[#namelist+1] = equipItem.ClassType
			end

		end

	end
end


function SHOW_EQUIPLIST(pc)

    local itemList, itemCnt = GetClassList("Item");
    local equipList, equipCnt = GetClassList("Item_Equip");
    local result = io.open('..\\release\\itemstat.txt','w')

    for i = 1, equipCnt do
        if i < 210 then
            local equipItem = GetClassByIndexFromList(equipList, i);
            local itemCls = GetClassByNameFromList(itemList, equipItem.ClassName);
            
            if itemCls ~= nil then
                print(itemCls.Name, "UseLv: "..itemCls.UseLv, "MaxDmg: "..equipItem.MAXATK, "Ratio: "..math.floor(equipItem.MAXATK/(itemCls.UseLv+equipItem.MAXATK)*100));
                result:write(itemCls.Name, ","..itemCls.UseLv, ","..equipItem.MAXATK, ","..math.floor(equipItem.MAXATK/(itemCls.UseLv+equipItem.MAXATK)*100),string.char(10));
            end
        else
            break;
        end
    end
   io.close(result)
end


function TEST_BUFFSCR(self)
		
	local objList, objCount = SelectObject(self, 100, 'ALL');	
	for i = 1, objCount do
		local obj = objList[i];
		AddBuff(self, obj, 'CardCharm', 1, 0, 15000, 1);
	end	

end


function TEST_HEAD(pc, headNum)

	ChangeHeadPC(pc, headNum)
end

function TOALLMSG(pc, msg)

	print(msg)
	ToAll(msg)

end

function TEST_YOUNG_NEWSKILL(pc)

	print('TEST_YOUNG_NEWSKILL', pc)
	local mon = GET_NEAR_MON(pc);
	if mon == nil then
		return;
	end
	

	UsePcSkill(pc, mon, 'YoungTest', 1, 'YES');
	--UsePcSkill(pc, mon, 'MongWangGa', 1, 'YES');
	--SetExArgCount(mon, 30);
	--SetExArg(mon, 1, pc);
	--local list, cnt = GetExArgList(mon);TE
		

end

function IS_HERE_GLOBAL_GENABLE_PLACE_OLD(pc)

	local objList, objCount = SelectObject(pc, 100, 'ALL');	

	local bvalue = 0;

	for i = 1, objCount do
		if GetCurrentFaction(objList[i]) ~= 'Monster' then
			bvalue = 1;
		end
	end	

	if bvalue == 1 then
		local string = ScpArgMsg("Auto_KeulLoBeol_Jen_BulKaNeung_:_")
		for i = 1, objCount do
			local obj = objList[i];
			if GetCurrentFaction(objList[i]) ~= 'Monster' then
				string = string..obj.ClassName.." ";
			end
		end	
		Chat(pc, string);
	else
		Chat(pc, ScpArgMsg("Auto_KeulLoBeol_Jen_KaNeung"));
	end
end


function IS_HERE_GLOBAL_GENABLE_PLACE(pc)
	
	local objList, objCount = SelectObject(pc, 1100, 'ALL');	

	local pcX, pcY, pcZ = GetPos(pc);

	local bvalue = 0;

	for i = 1, objCount do

		local objX, objY, objZ = GetPos(objList[i])
		local dand = SCR_POINT_DISTANCE(pcX, pcZ, objX, objZ)

		if dand < objList[i].CantGenRange then
			bvalue = 1;
		end
	end		
	
	if bvalue == 1 then
		local string = ScpArgMsg("Auto_KeulLoBeol_Jen_BulKaNeung_:_")
		for i = 1, objCount do

			local obj = objList[i];
			local objX, objY, objZ = GetPos(obj)
			local dand = SCR_POINT_DISTANCE(pcX, pcZ, objX, objZ)

			if dand < obj.CantGenRange then
				string = string..obj.ClassName.." ";
			end
		end	
		Chat(pc, string);
	else
		Chat(pc, ScpArgMsg("Auto_KeulLoBeol_Jen_KaNeung"));
	end
end



function TEST_FACTION(pc)

	local objList, objCount = SelectObject(pc, 50, 'ALL');

	for i = 1, objCount do
		local obj = objList[i];
		--Chat(pc,GetCurrentFaction(obj));
		print(obj,GetCurrentFaction(obj));
	end

	
end

function TEST_COOLDOWN(pc, time)
	local CoolList, cnt = GetClassList("CoolDown");
		for i = 0 , cnt - 1 do
			local cal = GetClassByIndexFromList(CoolList , i)
			AddCoolDown(pc, cal.ClassName, -time)
		end
end


function TEST_MOVEPOS(pc)
	local x, y, z = GetPos(pc);
	print(x,y,z);
	SetPos(pc, x+10, y, z+10);
	--SetPosInServer(pc, x+10, y, z+10);
end

function TEST_MOVEPOS2(pc)



	local objList, objCount = SelectObject(pc, 50, 'MONSTER');

	for i = 1, objCount do
		
		SpinObject(objList[i], 0, -1, 1.1, 1.0)
		
	end
end

function TEST_APK_S(pc)

	local objList, objCount = SelectObject(pc, 100, 'MONSTER');

	for i = 1, objCount do
		
		AddBuff(pc, objList[i], "SwellRightArm_Buff", 1, 1, 1000, 1)		
		--SpinObject(objList[i], 0, -1, 1.1, 1.0)
		
	end
end

function TEST_ATTACHNODE(pc)

	local objList, objCount = SelectObject(pc, 50, 'ALL');

	print(objCount);

	for i = 1, objCount do

		local mon = objList[i];

		--AttachToObject(obj, nil, "None", "None", 0);
		AttachToObject(mon, pc, "None", "None", 1, 10, 0, 0, 1);

		--AttachToObject(pc, mon, nodeName, "None", 1, attachSec, 0, holdAI, 0, attachAnim);	
		
	end

	
	
	--SpinObject(pc, 0, -1, 0.1, 1.1)

end

function TEST_MOVEPOS3(pc)

	SpinObject(pc, 0, -1, 0.1, 1.1)

end

function TEST_MOVEPOS4(pc)

	SpinObject(pc, 0, -1, 1.9, 1.1)

end

function TEST_ITEMCOOL(pc)

	local get_item = GetInvItemList(pc);

	for i = 1, #get_item do
		local remainCoolTime = GetRemainItemCoolTime(pc, get_item[i]);
		print(remainCoolTime);
		if get_item[i].ClassID > 190000 and get_item[i].ClassID < 200000 then
			SetItemCoolTime(pc, get_item[i], 0);
		end
	end

end

function TEST_OVERHEATTEST(pc)
--[[
	print('hello');

	local skill = GetSkill(pc, 'Swordman_Thrust');

	RequestReduceOverHeat(pc, skill.OverHeatGroup, -50000 , skill.CoolDownGroup, 0.0);

	print('hello2');
	]]--


	local list, cnt = GetPCSkillList(pc);
	
	for i = 1, cnt do
		if list[i].ClassID > 10000 then

			skill = list[i];

			print(skill.SklUseOverHeat);

			if skill.UseOverHeat > 0 then
				RequestReduceOverHeat(pc, skill.OverHeatGroup, -5000 , skill.CoolDownGroup, 0.0);
			end
		end
	end
end

function TEST_GETMOVE(pc)

	local value = GetMoveState(pc);
	print(pc);

	local objList, objCount = SelectObject(pc, 50, 'ALL');

	print(objCount);

	for i = 1, objCount do

		local obj = objList[i];
		local value = GetMoveState(obj);
		print(value);
		
	end
	
end

function TEST_TESTSTAMINA(pc)

	local maxstamina = GetMaxStamina(pc);
	local asd = GetStamina(pc);
	print(maxstamina,asd);
	
end

function TEST_ARUN(pc)
print("????????")
--ResetStdAnim(pc)
	SetSTDAnim(pc,'SKL_ATAQUE_RUN')
	print("aaaaaaa")
	SetRUNAnim(pc,'SKL_ATAQUE_RUN')	
print("????????")
end

function TEST_ZZZ(pc)

	local x, y, z = GetPos(pc);
	RunPad(pc, 'Paladin_Barrier', nil, x, y, z, 0, 1);
end

function TEST_GG(pc)

	local objList, objCount = SelectObject(pc, 200, 'ALL');
	for i = 0, objCount do
		local obj = objList[i];
		if obj ~= nil and obj.ClassName == 'summons_zombie' then
			SetOwner(obj, pc, 1);
			AddZombieSummon(pc, obj);
		end
	end	
end

function TEST_GGG(pc)

	local x, y, z = GetFrontPos(pc, 50);
	HoverZombieSummon(pc, x, y, z, 50, 2);
end


function TEST_GGGG(pc)

	EndHoverZombieSummon(pc);
	local list, listCnt = GetZombieSummonList(pc);
	print(list, listCnt)
	HoldMonScp(list[1]);
end



function TEST_TTT(pc)

	local objList, objCount = SelectObject(pc, 1000, 'ENEMY');	
	for i = 1, objCount do
		local obj = objList[i];	
		if obj ~= nil then
			SetTendency(obj, "Attack");
			SetTendencysearchRange(obj, 150);
			AddSearchRangeFix(obj, 1);
		end
	end
	
end


function WEAPON_ALLABIL(pc)

	if GetJobObject(pc).CtrlType == 'Archer' then
		local tx = TxBegin(pc);
		TxAddAbility(tx, 'Bow')	
		local ret = TxCommit(tx);
		
		print(ret)
	else
		local tx = TxBegin(pc);
		local idx = TxAddAbility(tx, 'THSword');
		TxAppendProperty(tx, idx, "Level", 1);
		idx = TxAddAbility(tx, 'THStaff');
		TxAppendProperty(tx, idx, "Level", 1);
		idx = TxAddAbility(tx, 'Spear');
		TxAppendProperty(tx, idx, "Level", 1);
		idx = TxAddAbility(tx, 'THSpear');
		TxAppendProperty(tx, idx, "Level", 1);
		idx = TxAddAbility(tx, 'Wand');
		TxAppendProperty(tx, idx, "Level", 1);
		idx = TxAddAbility(tx, 'Helmet');
		TxAppendProperty(tx, idx, "Level", 1);		
		local ret = TxCommit(tx);
		
		print(ret)
	end
end


function TEST_ADD_EMOTICON(pc, emoticonID)

	local tx = TxBegin(pc);
	local etc = GetETCObject(pc);
	TxAddIESProp(tx, etc, "HaveEmoticon_" .. emoticonID, 1);
	local ret = TxCommit(tx);
	
	if ret == 'SUCCESS' then
		SendAddOnMsg(pc, "ADD_CHAT_EMOTICON");
	end
end

function TEST_STAGE_STATE(self)
	local isPlaying = IsPlayingMGame(self, 'G_TOWER_1')
	local isEnabled, isStarted, isComplete = GetStateMGameStage(self, 'G_TOWER_1', 'Stage1');
	print(isPlaying, isEnabled, isStarted, isComplete)
end

function TEST_HEL(self)

	local equipItem = GetEquipItem(self, 'HELMET');

	local tx = TxBegin(self);
	if 0 == item.IsNoneItem(equipItem.ClassID) then
		TxTakeItemByObject(tx, equipItem, 1);
	else
		TxGiveEquipItem(tx, 'HELMET', 'murmillo_helmet', 0);
	end

	local ret = TxCommit(tx);
	
end

function TEST_EFT(pc, name, count, scale, loopTime)

	for i = 0 , count - 1 do
		PlayEffect(pc, name, scale, 0, 1)
		sleep(loopTime)
	end
end

function TEST_EFT2(pc, name, count)

	for i = 0 , count - 1 do
		PlayEffect(pc, name, 1, 0, 1)
	end
end

function TEST_SS(pc)
	SetShadowRender(pc, 0)
end

function TEST_RANDOMBOX(pc)

    local select = ShowSelDlg(pc, 0, 'KLAPEDA_Smith_basic2', ScpArgMsg('Auto_Sword'), ScpArgMsg('Auto_TSword'), ScpArgMsg('Auto_Staff'), ScpArgMsg('Auto_TStaff'), ScpArgMsg('Auto_TBow'), ScpArgMsg('Auto_Bow'), ScpArgMsg('Auto_Mace'));
    
    if select == 1 then
        local tx = TxBegin(pc);
        TxGiveItem(tx, 'SWD01_101', 1, 'Bag');
        local ret = TxCommit(tx);
        
    elseif select == 2 then
        local tx = TxBegin(pc);
        TxGiveItem(tx, 'SWD01_101', 1, 'Bag');
        local ret = TxCommit(tx);
        
    elseif select == 3 then
        local tx = TxBegin(pc);
        TxGiveItem(tx, 'STF01_101', 1, 'Bag');
        local ret = TxCommit(tx);
        
    elseif select == 4 then
        local tx = TxBegin(pc);
        TxGiveItem(tx, 'TSF01_101', 1, 'Bag');
        local ret = TxCommit(tx);
        
    elseif select == 5 then
        local tx = TxBegin(pc);
        TxGiveItem(tx, 'TBW01_101', 1, 'Bag');
        local ret = TxCommit(tx);
        
    elseif select == 6 then
        local tx = TxBegin(pc);
        TxGiveItem(tx, 'BOW01_101', 1, 'Bag');
        local ret = TxCommit(tx);
        
    elseif select == 7 then
        local tx = TxBegin(pc);
        TxGiveItem(tx, 'MAC01_101', 1, 'Bag');
        local ret = TxCommit(tx);
        
    end
    
end

function ALLKILL(pc)
	AllMonsterKill(pc)
end


function EQUIP(pc)
	local item = GetEquipItem(pc, 'RH')
	print(item.MATK)
end

function TEST_P_EVENT_M(pc)
    GetPartyMissionAble(pc)
end

function TESTPJ(pc)
    
    local lv = pc.Lv;
    local cls = GetClassList('Item');
    
    for i = 0, #cls do
        if cls[i].ItemType == 'Equip' then
            if cls[i].ItemGrade == 1 then
                if cls[i].ItemLv >= lv and cls[i].ItemLv <= lv + 5 then
                    print(cls[i].Name)
                end
            end
        end
    end
    
end

function LV35(pc)
    lvup(pc, 35);
    local jobObj = GetJobObject(pc);
    
    local tx = TxBegin(pc);
    if jobObj.CtrlType == 'Wizard' then
        TxGiveItem(tx, 'STF01_121', 1, "Test");
        TxGiveItem(tx, 'TSF01_113', 1, "Test");
    elseif jobObj.CtrlType == 'Archer' then
        TxGiveItem(tx, 'TBW01_121', 1, "Test");
        TxGiveItem(tx, 'BOW01_115', 1, "Test");
    else
        TxGiveItem(tx, 'SWD01_121', 1, "Test");
        TxGiveItem(tx, 'TSW01_115', 1, "Test");
        TxGiveItem(tx, 'MAC01_121', 1, "Test");
    end
    
    TxGiveItem(tx, 'HAND01_105', 1, "Test");
    TxGiveItem(tx, 'FOOT01_105', 1, "Test");
    TxGiveItem(tx, 'LEG01_105', 1, "Test");
    TxGiveItem(tx, 'TOP01_105', 1, "Test");
    
    TxGiveItem(tx, 'SHD01_103', 1, "Test");
    
    TxGiveItem(tx, 'NECK01_114', 1, "Test");
    TxGiveItem(tx, 'BRC01_125', 2, "Test");
    
    TxGiveItem(tx, 'Drug_HP1', 50, "Test");
    TxGiveItem(tx, 'Drug_SP1', 50, "Test");
    TxGiveItem(tx, 'Drug_STA1', 10, "Test");
    
    local ret = TxCommit(tx);
    AUTO_CHANGE_JOB(pc, 2)
    REINFORCE_ALLWEAPON(pc, 5);
end


function LV75(pc)
    lvup(pc, 75);
    local jobObj = GetJobObject(pc);
    
    local tx = TxBegin(pc);
    if jobObj.CtrlType == 'Wizard' then
        TxGiveItem(tx, 'STF01_109', 1, "Test");
        TxGiveItem(tx, 'TSF01_107', 1, "Test");
    elseif jobObj.CtrlType == 'Archer' then
        TxGiveItem(tx, 'TBW01_109', 1, "Test");
        TxGiveItem(tx, 'BOW01_107', 1, "Test");
    else
        TxGiveItem(tx, 'SWD01_109', 1, "Test");
        TxGiveItem(tx, 'TSW01_107', 1, "Test");
        TxGiveItem(tx, 'MAC01_109', 1, "Test");
        TxGiveItem(tx, 'SPR01_104', 1, "Test");
    end
    
    if jobObj.CtrlType == 'Warrior' then
        TxGiveItem(tx, 'HAND01_110', 1, "Test");
        TxGiveItem(tx, 'FOOT01_110', 1, "Test");
        TxGiveItem(tx, 'LEG01_110', 1, "Test");
        TxGiveItem(tx, 'TOP01_110', 1, "Test");
    else
        TxGiveItem(tx, 'HAND01_109', 1, "Test");
        TxGiveItem(tx, 'FOOT01_109', 1, "Test");
        TxGiveItem(tx, 'LEG01_109', 1, "Test");
        TxGiveItem(tx, 'TOP01_109', 1, "Test");
	end
    
    TxGiveItem(tx, 'SHD01_106', 1, "Test");
    
    TxGiveItem(tx, 'NECK01_128', 1, "Test");
    TxGiveItem(tx, 'BRC01_129', 2, "Test");
    
    TxGiveItem(tx, 'Drug_HP2', 50, "Test");
    TxGiveItem(tx, 'Drug_SP2', 50, "Test");
    TxGiveItem(tx, 'Drug_STA1', 10, "Test");
    
    local ret = TxCommit(tx);
    AUTO_CHANGE_JOB(pc, 3)
    REINFORCE_ALLWEAPON(pc, 5);
end


function LV120(pc)
    lvup(pc, 120);
    local jobObj = GetJobObject(pc);
    
    local tx = TxBegin(pc);
    if jobObj.CtrlType == 'Wizard' then
        TxGiveItem(tx, 'STF01_130', 1, "Test");
        TxGiveItem(tx, 'TSF01_122', 1, "Test");
    elseif jobObj.CtrlType == 'Archer' then
        TxGiveItem(tx, 'TBW01_130', 1, "Test");
        TxGiveItem(tx, 'BOW01_123', 1, "Test");
    else
        TxGiveItem(tx, 'SWD01_130', 1, "Test");
        TxGiveItem(tx, 'TSW01_122', 1, "Test");
        TxGiveItem(tx, 'MAC01_129', 1, "Test");
        TxGiveItem(tx, 'SPR01_112', 1, "Test");
        TxGiveItem(tx, 'TSP01_103', 1, "Test");
    end
    
    if jobObj.CtrlType == 'Warrior' then
        TxGiveItem(tx, 'HAND01_140', 1, "Test");
        TxGiveItem(tx, 'FOOT01_140', 1, "Test");
        TxGiveItem(tx, 'LEG01_140', 1, "Test");
        TxGiveItem(tx, 'TOP01_140', 1, "Test");
    else
        TxGiveItem(tx, 'HAND01_139', 1, "Test");
        TxGiveItem(tx, 'FOOT01_139', 1, "Test");
        TxGiveItem(tx, 'LEG01_139', 1, "Test");
        TxGiveItem(tx, 'TOP01_139', 1, "Test");
	end
    
    TxGiveItem(tx, 'SHD01_114', 1, "Test");
    TxGiveItem(tx, 'DAG01_101', 1, "Test");
    
    TxGiveItem(tx, 'NECK01_131', 1, "Test");
    TxGiveItem(tx, 'BRC01_132', 2, "Test");
    
    TxGiveItem(tx, 'Drug_HP3', 50, "Test");
    TxGiveItem(tx, 'Drug_SP3', 50, "Test");
    TxGiveItem(tx, 'Drug_STA1', 10, "Test");
    
    local ret = TxCommit(tx);
    AUTO_CHANGE_JOB(pc, 4)
    REINFORCE_ALLWEAPON(pc, 5);
end


function LV170(pc)
    lvup(pc, 170);
    local jobObj = GetJobObject(pc);
    
    local tx = TxBegin(pc);
    if jobObj.CtrlType == 'Wizard' then
        TxGiveItem(tx, 'STF01_133', 1, "Test");
        TxGiveItem(tx, 'TSF01_125', 1, "Test");
    elseif jobObj.CtrlType == 'Archer' then
        TxGiveItem(tx, 'TBW01_133', 1, "Test");
        TxGiveItem(tx, 'BOW01_126', 1, "Test");
        TxGiveItem(tx, 'PST01_101', 1, "Test");
    else
        TxGiveItem(tx, 'SWD01_133', 1, "Test");
        TxGiveItem(tx, 'TSW01_125', 1, "Test");
        TxGiveItem(tx, 'MAC01_132', 1, "Test");
        TxGiveItem(tx, 'SPR01_115', 1, "Test");
        TxGiveItem(tx, 'TSP01_106', 1, "Test");
    end
    
    if jobObj.CtrlType == 'Warrior' then
        TxGiveItem(tx, 'HAND01_149', 1, "Test");
        TxGiveItem(tx, 'FOOT01_149', 1, "Test");
        TxGiveItem(tx, 'LEG01_149', 1, "Test");
        TxGiveItem(tx, 'TOP01_149', 1, "Test");
    else
        TxGiveItem(tx, 'HAND01_148', 1, "Test");
        TxGiveItem(tx, 'FOOT01_148', 1, "Test");
        TxGiveItem(tx, 'LEG01_148', 1, "Test");
        TxGiveItem(tx, 'TOP01_148', 1, "Test");
	end
    
    TxGiveItem(tx, 'SHD01_117', 1, "Test");
    TxGiveItem(tx, 'DAG01_104', 1, "Test");
    
    TxGiveItem(tx, 'NECK01_140', 1, "Test");
    TxGiveItem(tx, 'BRC01_135', 2, "Test");
    
    TxGiveItem(tx, 'Drug_HP3', 50, "Test");
    TxGiveItem(tx, 'Drug_SP3', 50, "Test");
    TxGiveItem(tx, 'Drug_STA1', 10, "Test");
    
    local ret = TxCommit(tx);
    AUTO_CHANGE_JOB(pc, 5)
    REINFORCE_ALLWEAPON(pc, 5);
end

function LV220(pc)
    lvup(pc, 220);
    local jobObj = GetJobObject(pc);
    local tx = TxBegin(pc);
    
    if jobObj.CtrlType == 'Wizard' then
        TxGiveItem(tx, 'STF01_136', 1, "Test");
        TxGiveItem(tx, 'TSF01_128', 1, "Test");
    elseif jobObj.CtrlType == 'Archer' then
        TxGiveItem(tx, 'TBW01_136', 1, "Test");
        TxGiveItem(tx, 'BOW01_129', 1, "Test");
        TxGiveItem(tx, 'PST01_103', 1, "Test");
    else
        TxGiveItem(tx, 'SWD01_135', 1, "Test");
        TxGiveItem(tx, 'TSW01_128', 1, "Test");
        TxGiveItem(tx, 'MAC01_135', 1, "Test");
        TxGiveItem(tx, 'SPR01_118', 1, "Test");
        TxGiveItem(tx, 'TSP01_110', 1, "Test");
    end
    
    
    if jobObj.CtrlType == 'Warrior' then
        TxGiveItem(tx, 'HAND01_152', 1, "Test");
        TxGiveItem(tx, 'FOOT01_152', 1, "Test");
        TxGiveItem(tx, 'LEG01_152', 1, "Test");
        TxGiveItem(tx, 'TOP01_152', 1, "Test");
    else
        TxGiveItem(tx, 'HAND01_151', 1, "Test");
        TxGiveItem(tx, 'FOOT01_151', 1, "Test");
        TxGiveItem(tx, 'LEG01_151', 1, "Test");
        TxGiveItem(tx, 'TOP01_151', 1, "Test");
	end
    
    TxGiveItem(tx, 'SHD01_119', 1, "Test");
    TxGiveItem(tx, 'DAG01_106', 1, "Test");
    
    TxGiveItem(tx, 'NECK01_141', 1, "Test");
    TxGiveItem(tx, 'BRC01_136', 2, "Test");
    
    TxGiveItem(tx, 'Drug_HP3', 50, "Test");
    TxGiveItem(tx, 'Drug_SP3', 50, "Test");
    TxGiveItem(tx, 'Drug_STA1', 10, "Test");
    
    local ret = TxCommit(tx);
    AUTO_CHANGE_JOB(pc, 6)
    REINFORCE_ALLWEAPON(pc, 5);
end

function LV280(pc)
    lvup(pc, 280);
    local jobObj = GetJobObject(pc);
    local tx = TxBegin(pc);
    
    if jobObj.CtrlType == 'Wizard' then
        TxGiveItem(tx, 'STF04_108', 1, "Test");
        TxGiveItem(tx, 'TSF04_107', 1, "Test");
    elseif jobObj.CtrlType == 'Archer' then
        TxGiveItem(tx, 'TBW04_107', 1, "Test");
        TxGiveItem(tx, 'BOW04_107', 1, "Test");
        TxGiveItem(tx, 'PST04_102', 1, "Test");
        TxGiveItem(tx, 'CAN04_101', 1, "Test");
    else
        TxGiveItem(tx, 'SWD04_107', 1, "Test");
        TxGiveItem(tx, 'TSW04_107', 1, "Test");
        TxGiveItem(tx, 'MAC04_109', 1, "Test");
        TxGiveItem(tx, 'SPR04_108', 1, "Test");
        TxGiveItem(tx, 'TSP04_108', 1, "Test");
        TxGiveItem(tx, 'RAP04_104', 1, "Test");
    end
    
    
    if jobObj.CtrlType == 'Wizard' then
        TxGiveItem(tx, 'HAND04_106', 1, "Test");
        TxGiveItem(tx, 'FOOT04_106', 1, "Test");
        TxGiveItem(tx, 'LEG04_106', 1, "Test");
        TxGiveItem(tx, 'TOP04_106', 1, "Test");
    elseif jobObj.CtrlType == 'Warrior' then
        TxGiveItem(tx, 'HAND04_108', 1, "Test");
        TxGiveItem(tx, 'FOOT04_108', 1, "Test");
        TxGiveItem(tx, 'LEG04_108', 1, "Test");
        TxGiveItem(tx, 'TOP04_108', 1, "Test");
    else
        TxGiveItem(tx, 'HAND04_107', 1, "Test");
        TxGiveItem(tx, 'FOOT04_107', 1, "Test");
        TxGiveItem(tx, 'LEG04_107', 1, "Test");
        TxGiveItem(tx, 'TOP04_107', 1, "Test");
	end
    
    TxGiveItem(tx, 'SHD04_103', 1, "Test");
    TxGiveItem(tx, 'DAG04_102', 1, "Test");
    
    TxGiveItem(tx, 'NECK04_104', 1, "Test");
    TxGiveItem(tx, 'BRC04_102', 2, "Test");
    
    local ret = TxCommit(tx);
    REINFORCE_ALLWEAPON(pc, 10);
    TRANSCEND_ALLWEAPON(pc, 10)
end

function LV330(pc)
    lvup(pc, 330);
    local jobObj = GetJobObject(pc);
    local tx = TxBegin(pc);
    
    if jobObj.CtrlType == 'Wizard' then
        TxGiveItem(tx, 'STF04_109', 1, "Test");
        TxGiveItem(tx, 'TSF04_108', 1, "Test");
    elseif jobObj.CtrlType == 'Archer' then
        TxGiveItem(tx, 'TBW04_108', 1, "Test");
        TxGiveItem(tx, 'BOW04_108', 1, "Test");
        TxGiveItem(tx, 'PST04_103', 1, "Test");
        TxGiveItem(tx, 'CAN04_102', 1, "Test");
        TxGiveItem(tx, 'MUS04_102', 1, "Test");
    else
        TxGiveItem(tx, 'SWD04_108', 1, "Test");
        TxGiveItem(tx, 'TSW04_108', 1, "Test");
        TxGiveItem(tx, 'MAC04_110', 1, "Test");
        TxGiveItem(tx, 'SPR04_109', 1, "Test");
        TxGiveItem(tx, 'TSP04_110', 1, "Test");
        TxGiveItem(tx, 'RAP04_105', 1, "Test");
    end
    
    
    if jobObj.CtrlType == 'Wizard' then
        TxGiveItem(tx, 'HAND04_109', 1, "Test");
        TxGiveItem(tx, 'FOOT04_109', 1, "Test");
        TxGiveItem(tx, 'LEG04_109', 1, "Test");
        TxGiveItem(tx, 'TOP04_109', 1, "Test");
    elseif jobObj.CtrlType == 'Warrior' then
        TxGiveItem(tx, 'HAND04_111', 1, "Test");
        TxGiveItem(tx, 'FOOT04_111', 1, "Test");
        TxGiveItem(tx, 'LEG04_111', 1, "Test");
        TxGiveItem(tx, 'TOP04_111', 1, "Test");
    else
        TxGiveItem(tx, 'HAND04_110', 1, "Test");
        TxGiveItem(tx, 'FOOT04_110', 1, "Test");
        TxGiveItem(tx, 'LEG04_110', 1, "Test");
        TxGiveItem(tx, 'TOP04_110', 1, "Test");
	end
    
    TxGiveItem(tx, 'SHD04_104', 1, "Test");
    TxGiveItem(tx, 'DAG04_103', 1, "Test");
    
    TxGiveItem(tx, 'NECK04_106', 1, "Test");
    TxGiveItem(tx, 'BRC04_104', 2, "Test");
    
    local ret = TxCommit(tx);
    REINFORCE_ALLWEAPON(pc, 10);
    TRANSCEND_ALLWEAPON(pc, 10)
end

function VIEW_STAT(pc)
	local fndList, fndCount = SelectObject(pc, 20, 'ALL');
	for i = 1, fndCount do
		if fndList[i].ClassName ~= 'PC' then
		    print(fndList[i].ClassName);
		    print(fndList[i].Lv);
		    print(fndList[i].STR);
		    print(fndList[i].DEX);
		    print(fndList[i].CON);
		    print(fndList[i].INT);
		    print(fndList[i].MNA);
		end
	end
end

function REINFORCE_ALLWEAPON(pc, value)
    local tx = TxBegin(pc);
    local invItemList = GetInvItemList(pc);
    for i = 1, #invItemList do
        if invItemList[i].ItemType == "Equip" then
            TxAddIESProp(tx, invItemList[i], "Reinforce_2", value);
        end
    end
    local ret = TxCommit(tx);
end

function TRANSCEND_ALLWEAPON(pc, value)
    local tx = TxBegin(pc);
    local invItemList = GetInvItemList(pc);
    for i = 1, #invItemList do
        if invItemList[i].ItemType == "Equip" then
            TxAddIESProp(tx, invItemList[i], "Transcend", value);
        end
    end
    local ret = TxCommit(tx);
end

function AUTO_CHANGE_JOB(pc, rank)
    GiveJobExp(pc, 893770725);
    while 1 == 1 do
        local jobRank = GetTotalJobCount(pc);
        local job = GetJobObject(pc);
        if rank > jobRank then
            local cls, cnt = GetClassList("Job");
            local test = GetClassByIndexFromList(cls, 1)
            local resultCls = {};
            local j = 1;
            for i = 0, cnt - 1 do
                local jobCls = GetClassByIndexFromList(cls, i);
                if job.CtrlType == jobCls.CtrlType and jobRank + 1 == jobCls.Rank then
                    resultCls[j] = jobCls;
                    j = j + 1
                end
                
            end
            
            local select = ShowSelDlg(pc, 0, "Choose the class you want", resultCls[1].Name, resultCls[2].Name, job.Name);
            
            if select == 1 then
                CHANGE_JOB(pc, resultCls[1].ClassName);
            elseif select == 2 then
                CHANGE_JOB(pc, resultCls[2].ClassName);
            elseif select == 3 then
                local curJobRank = GetJobGradeByName(pc, job.ClassName);
                if curJobRank > 2 then
                    Chat(pc, "Current job rank is 3.");
                else
                    CHANGE_JOB(pc, job.ClassName);
                end
            end
           
        else
            break;
        end
        GiveJobExp(pc, 893770725);
    end
end


function TEST_PARTY_MISSION_CALL(pc)
	testPartyMission(pc, "Mission")
end

function TEST_SCP123(party, pc)
	print("??????")
end

function TESTsns(pc)
--EquipDummyItemSpot(pc,pc, 0, "RH", 0)
       --DOTIMEACTION_R_DUMMY_ITEM(pc, ScpArgMsg("REMAINS37_3_SQ_091_MSG04"), 'skl_assistattack_shovel', 3, nil, nil, 630012, "RH")

	DOTIMEACTION_R_DUMMY_ITEM(pc, ScpArgMsg("REMAINS37_3_SQ_091_MSG01"), 'skl_assistattack_metaldetector', 2, nil, nil, 630013, "RH")
end

function UICLOSE2(pc)
	local pobj = GetPartyObj(pc)
	print(pobj.CreateTime)
end

function UICLOSE(pc)
	SendAddOnMsg(pc, 'HELP_MSG_CLOSE',"", 5);
end

function PRINT_TEST(pc)

	local clsList, cnt = GetClassList("QuestProgressCheck");
	for i = 0, cnt -1 do

		local questIES = GetClassByIndexFromList(clsList, i);
		local questclsName = questIES.ClassName

		if questclsName ~= "None" and questclsName ~= nil then

			local sObj = GetSessionObject(pc, 'ssn_klapeda');
			local leaderval = sObj[questclsName]

			if leaderval ~= 0 then
			print(leaderval)	
			end
		
			
		end
	end
end


function TEST_SUPERDROP(pc)
	local fndList, fndCount = SelectObject(pc, 100, 'ALL');
	for i = 1, fndCount do
		if fndList[i].ClassName ~= 'PC' then
		    AddBuff(fndList[i], fndList[i], 'SuperDrop', 1000, 1);
		end
	end
end

function TEST_SUPEREXP(pc)
	local fndList, fndCount = SelectObject(pc, 100, 'ALL');
	for i = 1, fndCount do
		if fndList[i].ClassName ~= 'PC' then
		    AddBuff(fndList[i], fndList[i], 'SuperExp', 1, 1);
		end
	end
end

function TEST_SAMSARA(pc)
	local fndList, fndCount = SelectObject(pc, 100, 'ALL');
	for i = 1, fndCount do
		if fndList[i].ClassName ~= 'PC' then
		    AddBuff(fndList[i], fndList[i], 'Samsara_Buff', 1, 1);
		end
	end
end

function TEST_SAMSARA_AFTER(pc)
	local fndList, fndCount = SelectObject(pc, 100, 'ALL');
	for i = 1, fndCount do
		if fndList[i].ClassName ~= 'PC' then
		    AddBuff(fndList[i], fndList[i], 'SamsaraAfter_Buff', 1, 1);
		end
	end
end

function TEST_START_MISSION(pc)
    ChangePartyProp(pc, PARTY_NORMAL, 'MissionAble', 1)
end


function TEST_TIIII(pc)
	local fndList, fndCount = SelectObject(pc, 350, 'ALL');
	for i = 1, fndCount do
		if fndList[i].ClassName ~= 'PC' then

			print(fndList[i].ClassName)

			InvalidateStates(fndList[i])
		--  local genID = GetGenTypeID(fndList[i])
	     --   local npcState = GetMapNPCState(pc, genID)
		--	print(npcState)



		end

	end
end

function TTTBB(pc)
    local x, y, z = GetPos(pc)
	local boss_mon = CREATE_MONSTER(pc, 'boss_Sparnashorn_Q1', x, y, z, 0, 'Monster', 0, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "BOSS_PROP_INITIALIZE")
	print(boss_mon.DropItemList)
end

function ANFDIR(pc)
    local tx = TxBegin(pc);
    
    TxGiveItem(tx, 'Drug_Alche_HP15', 50, "Test");
    TxGiveItem(tx, 'Drug_Alche_SP15', 50, "Test");
    TxGiveItem(tx, 'food_022', 50, "Test");
    TxGiveItem(tx, 'Dispeller_1', 50, "Test");
    
    local ret = TxCommit(tx);
    
end


function TEST_NPCAA(pc)
	local objList, objCount = SelectObject(pc, 50, 'ALL', 1);
	for i = 1, objCount do
		if objList[i].ClassName ~= "PC" then
			print(objList[i].ClassName)
			 local genID = GetGenTypeID(objList[i])
			if genID ~= nil then
				 local npcState = GetMapNPCState(pc, genID)
					print(npcState)
				 local tx = TxBegin(pc);
				 if npcState ~= nil then
					 TxChangeNPCState(tx, genID, 20)
					end

					local ret = TxCommit(tx);
			end
			end
		
	end
end

function TEST_NPCSSS(pc)
	local objList, objCount = SelectObject(pc, 500, 'ALL', 1);
	for i = 1, objCount do
		if objList[i].ClassName ~= "PC" then
			AddBuff(pc, objList[i], 'TEST_ER', 0, 0, 30000, 1);
		end
	end
end

function TEST_SELFBUFF(pc, buffName, arg1, arg2)
    AddBuff(pc, pc, buffName, arg1, arg2, 10000, 1);
end

function TEST_QUEST_CHECK_LIST(self)
	local cnt, qList, vList = GetQuestCheckStateList(self);
	for i = 1, cnt do
		print(qList[i], vList[i]);
	end
end


function TESTAA(pc)
--	ChangeScale(pc, 2.0, 0)
RunMGame(pc, "M_GTOWER_LOBBY_1")
end

function TEST_TAKE_GUILD_EVENT_REWARD(pc, eventID)
	
	local guildObj = GetGuildObj(pc);
	--local eventID = 0;

	if guildObj == nil then
		print("guild is nil")
	end
	--[[
	if guildObj.GuildInDunFlag == 1 then
		eventID = guildObj.GuildInDunSelectInfo
	elseif guildObj.GuildBossSummonFlag == 1 then
		eventID = guildObj.GuildBossSummonSelectInfo
	elseif guildObj.GuildRaidFlag == 1 then
		eventID = guildObj.GuildRaidSelectInfo
	else
		IMC_LOG("INFO_NORMAL", "guild Event eventID is 0");
		return 0;
	end
	]]--
	local cls = GetClassByType("GuildEvent", eventID)

	if cls == nil then
		print("??????α??: ?????? ???? - eventID : "..eventID)
	end

	local rewardList ={};
	local rewardCnt = {};
	local ratioList = {};
	local listIndex = 0;
	local totalRatio = 0;
	local clslist, cnt = GetClassList("reward_guildevent");
	
	for i = 0, cnt-1 do
		local rewardcls = GetClassByIndexFromList(clslist, i)

		if TryGetProp(rewardcls, "Group") == cls.ClassName then

	        rewardList[listIndex] = rewardcls.ItemName;
		    rewardCnt[listIndex] = rewardcls.Count;
			ratioList[listIndex] = rewardcls.Ratio;
			listIndex = listIndex + 1;
			totalRatio = totalRatio + rewardcls.Ratio;
		end
	end
    
	local result = IMCRandom(1, totalRatio)
	local tx = TxBegin(pc);
	for i = 0, #ratioList do
	    if result <= ratioList[i] then
			TxGiveItemToPartyWareHouse(tx, pc, PARTY_GUILD, rewardList[i], rewardCnt[i], 'Bag', 0, nil);
			break;
		else
			ratioList[i+1] = ratioList[i+1] + ratioList[i];
		end
	end

	local ret = TxCommit(tx);
	
	if ret == "SUCCESS" then
		--return 1;
	end
end


function TEST_GUILD_SET_LEVEL(pc, level)
	local guildObj = GetGuildObj(pc);
	ChangePartyProp(pc, PARTY_GUILD, "UsedTicketCount", 0);
	ChangePartyProp(pc, PARTY_GUILD, "Level", level);

end

function TEST_RESET_TICKET(pc)
	ChangePartyProp(pc, PARTY_GUILD, "UsedTicketCount", 0);
end


function reinfoceSimul(pc)
    for z = 1, 10 do
    	--?o? ???
    	local count = 10000;
    	--?????? ??? ???
    	local sucessReinforce = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    	--?????? ??? ???
    	local failReinforce = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    	--??? ??? (????? ?? * 10 ?? ????? ex. 9?? 90% ???)
    	local reinfoceRate = {9, 8, 7, 6, 5, 5, 5, 5, 5, 4};
    
    	for i = 1, count do
    		for j = 1, #reinfoceRate do
    			local value = IMCRandom(1,10)
    			if reinfoceRate[j] >= value then
    				sucessReinforce[j] = sucessReinforce[j] + 1	
    			else
    				failReinforce[j] = failReinforce[j] + 1
    				break;
    			end
    		end
    	end
    
    	for i = 1, #reinfoceRate do
    		print(i.."?? ???? ??? : "..sucessReinforce[i].."          "..i.."?? ???? ??? : "..failReinforce[i])
    	end
    end
end


function TEST_TX_POST(pc)
	local tx = TxBegin(pc);
	TxGiveItemToPostBox(tx, pc, 624304, 1, ClMsg("SelectPCToBringTheCompanion"), "SelectPCToBringTheCompanion", 6800)
    local ret = TxCommit(tx);
end

function rkdghk(pc, val)

	local tx = TxBegin(pc);
	for i = 0 , 20 do
		local es = item.GetEquipSpotName(i);
		local equipWeapon = GetEquipItemIgnoreDur(pc, es);		
		if equipWeapon ~= nil and equipWeapon.Transcend ~= val then
			TxSetIESProp(tx, equipWeapon, 'Reinforce_2', val);
		end
	end

	TxCommit(tx);
end

function MINIGAMEOVER_TESTOPEN1(pc)		
		local clientScp = string.format("MINIGAME_OVER_FRAME_OPEN()");
		ExecClientScp(pc, clientScp);	
end;

function MINIGAMEOVER_TESTOPEN2(pc)		
		local clientScp = string.format("MINIGAME_OVER_FRAME_OPEN(\'%s\', \'%s\')", "파티장이 전사하였습니다.", "확인을 누르시면, 미션에서 나갑니다.");
		ExecClientScp(pc, clientScp);	
end;

function TEST_PET_EXP(self, addPetExp)
	TestAddPetExp(self, addPetExp * 10)
end

function TEST_FORCE_TEAM(self, num)
	local etc = GetETCObject(self);
	if etc == nil then
		return;
	end	
	local team = etc["Team_Mission"];
	etc["Team_Mission"] = num;
end

function SCR_BRACKEN631_RP_1_NPC_DIALOG(self, pc)

	local select = ShowSelDlg(pc, 0, nil, ScpArgMsg("WorldGuildPVP"), ScpArgMsg("TeamBattleLeagueText"), ScpArgMsg("GT_LUTHA_NPC_SEL_FOLLOW"), ScpArgMsg("Auto_ChwiSo"))

	if select == 1 or select == 2 then
		GMReqJoinGuildPVP(pc, select)
		SendSysMsg(pc, 'PVP_State_Finding');
	elseif select == 3 then
		GMReqJoinGuildPVPMember(pc);
		SendSysMsg(pc, 'PVP_State_Finding');
	else 
		return;
	end	
end

function TEST_INDUNMULTIPLE(pc)
	local etc = GetETCObject(pc);
	if IsIndunMultiple(pc) == 1 then
		Chat(pc, "IndunMultiple Mode On, ".."Rate : ".. etc.IndunMultipleRate + 1)
	else
		Chat(pc, "IndunMultiple Mode Off")
	end
end

function TEST_GUILDA(pc)
	--GuildAuthority_1

--	local guildObj = GetGuildObj(pc);

--	print(guildObj.GuildAuthority_1)

--	ChangePartyProp(pc, PARTY_GUILD, 'GuildAuthority_1', "None")


print(SCR_BINARY(2))

end

function TEST_DPK_RATE(pc, monName, killCount)

    local monCls = GetClass("Monster", monName)
    
    if monCls == nil then
        Chat(pc, "없는 몬스터 입니다.");
        return;
    end

    local dropList = TryGetProp(monCls, "DropItemList");
    local clsList, cnt  = GetClassList("MonsterDropItemList_" .. dropList);

    if dropList == nil then
       Chat(pc, "드랍 리스트가 존재하지 않습니다.");
       return;
    end

    local file = io.open("C:\\DpkTest.txt", "a")
    io.output(file)

    io.write("Monster ClassName : "..monName)
    io.write("\n");
    io.write("\n");

    local dpkItemNameList = {};
    local dpkMinList = {};
    local dpkMaxList = {};
    local killCountList = {};
    local dropItemCountList = {};
    local stringTable = {};
    local dropKillCountString = "";          

    local index = 0;
    for i = 0, cnt - 1 do
        local drop = GetClassByIndexFromList(clsList, i);
        local dpkMin = TryGet(drop, "DPK_Min");
        local dpkMax = TryGet(drop, "DPK_Max");    
        if dpkMin > 0 then
            dpkItemNameList[index] = drop.ItemClassName;
            dpkMinList[index] = dpkMin;
            dpkMaxList[index] = dpkMax;
            killCountList[index] = 0;
            dropItemCountList[index] = 0;
            stringTable[index] = "";
            index = index + 1
        end
    end
   
    for i = 0, killCount do
        for j = 0, #dpkItemNameList do
            local currentValue = killCountList[j]
            killCountList[j] = currentValue + 1
            
            -- Drop xml에 있는 DPK min + max
            local dpkValue = dpkMinList[j] + dpkMaxList[j]

            if killCountList[j] >= dpkValue then
                killCountList[j] = 0;
            end

            -- 현재 DPK 확률
            local finalValue = dpkValue - currentValue

            -- DPK 최소값 보정
            local limitValue = math.floor(dpkValue * 0.01)
            if finalValue < limitValue then
                finalValue = limitValue;
            end

            -- 음수로 떨어졌을 때, 예외 처리
            if finalValue < 1 then
                finalValue = 1;
            end

            -- 현재 아이템을 받을 수 있는가?
            local dpkDropRate = IMCRandom(1, finalValue)

            -- 아이템을 못받으면 드랍 테이블 셋팅 안함
            if dpkDropRate ~= 1 then
            else
                stringTable[j] = stringTable[j]..", "..killCountList[j]
                killCountList[j] = 0;
                dropItemCountList[j] = dropItemCountList[j] + 1;
            end
           
        end   
    end

    for j = 0, #dpkItemNameList do        
        --io.write(dpkItemNameList[j].." 아이템이 ".. dropItemCountList[j] .. " 개 나옴".. stringTable[j])
        io.write(dpkItemNameList[j].." 아이템이 ".. dropItemCountList[j] .. " 개 나옴")
        io.write("\n");
        io.write("\n");
        io.write("\n");
    end

    io.close(file)

    Chat(pc, "파일 출력 끝");
end


function setEX(pc, rate)
    SetEarningRate(pc, rate)
	end

function showEX(pc)
    ShowEarningRate(pc)
end

function TEST_MAP_REVEAL_COMPLETE(pc, zoneClassName)
	MapRevealComplete(pc, zoneClassName);
end


function TEST_DPK_RATE2(pc, monName, killCount)

    local monCls = GetClass("Monster", monName)
    
    if monCls == nil then
        Chat(pc, "없는 몬스터 입니다.");
        return;
    end

    local dropList = TryGetProp(monCls, "DropItemList");
    local clsList, cnt  = GetClassList("MonsterDropItemList_" .. dropList);

    if dropList == nil then
       Chat(pc, "드랍 리스트가 존재하지 않습니다.");
       return;
    end
    local dpkItemNameList = {};
    local dpkMinList = {};
    local dpkMaxList = {};
    local killCountList = {};
    local dropItemCountList = {};
    local stringTable = {};
    local dropKillCountString = "";          

    local index = 0;
    for i = 0, cnt - 1 do
        local drop = GetClassByIndexFromList(clsList, i);
        local dpkMin = TryGet(drop, "DPK_Min");
        local dpkMax = TryGet(drop, "DPK_Max");    
        if dpkMin > 0 then
            dpkItemNameList[index] = drop.ItemClassName;
            dpkMinList[index] = dpkMin;
            dpkMaxList[index] = dpkMax;
            killCountList[index] = 0;
            dropItemCountList[index] = 0;
            stringTable[index] = "";
            index = index + 1
        end
    end
   
    for i = 0, killCount do
        for j = 0, #dpkItemNameList do
            local currentValue = killCountList[j]
            killCountList[j] = currentValue + 1
            
            -- Drop xml에 있는 DPK min + max
            local dpkValue = dpkMinList[j] + dpkMaxList[j]

            if killCountList[j] >= dpkValue then
                killCountList[j] = 0;
            end

            -- 현재 DPK 확률
            local finalValue = dpkValue - currentValue

            -- DPK 최소값 보정
            local limitValue = math.floor(dpkValue * 0.01)
            if finalValue < limitValue then
                finalValue = limitValue;
            end

            -- 음수로 떨어졌을 때, 예외 처리
            if finalValue < 1 then
                finalValue = 1;
            end

            -- 현재 아이템을 받을 수 있는가?
            local dpkDropRate = IMCRandom(1, finalValue)
			
            -- 아이템을 못받으면 드랍 테이블 셋팅 안함
            if dpkDropRate ~= 1 then
            else
                stringTable[j] = stringTable[j]..", "..killCountList[j]
                killCountList[j] = 0;
                dropItemCountList[j] = dropItemCountList[j] + 1;
            end
           
        end   
    end

    for j = 0, #dpkItemNameList do        
        Chat(pc, dpkItemNameList[j].." 아이템이 ".. dropItemCountList[j] .. " 개 나옴")
    end
end

function TEST_PARTY_ITEM_GIVE_TEST(pc)
	local partyPlayerList, cnt = GET_PARTY_ACTOR(pc, 0);
	for i = 1 , cnt do
		RunScript('GIVE_TAKE_SOBJ_ACHIEVE_TXTT', partyPlayerList[i], "Event_170117_1/1/161215Event_Seed/1", nil, nil, nil,giveway, nil)
	end
end

function GIVE_TAKE_SOBJ_ACHIEVE_TXTT(pc)
	local tx = TxBegin(pc);
	TxGiveItem(tx, "Event_170117_1", 1, "TEST");
	TxGiveItem(tx, "161215Event_Seed", 1, "TEST");	
	local ret = TxCommit(tx);
end

function TEST_MON_ITEM_DROP(pc, killCount, monName)
	if monName == 0 then
		monName = nil;
	end

	if monName == "scp" then
		local monClassNameList = {};
		monClassNameList[#monClassNameList + 1] = "Onion";
		monClassNameList[#monClassNameList + 1] = "Onion_Big";
		monClassNameList[#monClassNameList + 1] = "Onion_Red";
		monClassNameList[#monClassNameList + 1] = "Onion_green";
		monClassNameList[#monClassNameList + 1] = "Haming";
		monClassNameList[#monClassNameList + 1] = "Bokchoy";
		monClassNameList[#monClassNameList + 1] = "Bokchoy_Big";
		monClassNameList[#monClassNameList + 1] = "Jukopus";
		monClassNameList[#monClassNameList + 1] = "Jukopus_blue";
		monClassNameList[#monClassNameList + 1] = "Jukopus_gray";
		monClassNameList[#monClassNameList + 1] = "arburn_pokubu";

		MonsterItemDropTest(pc, killCount, "scp", monClassNameList);
	else
		MonsterItemDropTest(pc, killCount, monName);
	end
end
function TEST_MAP_REVEAL_COMPLETE(pc, zoneClassName)
	MapRevealComplete(pc, zoneClassName);
end

function ITEM_COPY_TEST(pc)
	local item = GetInvItemByName(pc, "SWD01_101");
	local tx = TxBegin(pc);
	local cmd = TxGiveItem(tx, "SWD01_101", 1, "Test")
	TxMakeOptionToGivenItem(tx, cmd, item, "CREATE_ITEM_OPTION_COPY");
	local ret = TxCommit(tx);
end

function TEST_MOVE_TO_BOSS(pc)
    SetPosToFieldBoss(pc);
end


function TEST_RESET_MOUSE_MOVE(pc)
    CancelMouseMove(pc);
end

function TEST_RESET_BUY_TPITEM_LIMIT(pc, itemClassID)
	if pc == nil then
		return
	end

	if itemClassID == nil or itemClassID == 0 then
		return
	end

	local tx = TxBegin(pc);
	if tx == nil then
		return
	end
	
	local tpitem = GetClassByType("TPitem", itemClassID)
	local limitResult = TxAddBuyLimitCount(tx, 0, itemClassID, 0, 1);

	local ret = TxCommit(tx);
	if ret == "SUCCESS" then
	end
end


function RUN_BENCHMARKING(self)
	if self == nil then
		return
	end

	RunScript('_RUN_BENCHMARKING', self);
end

function _RUN_BENCHMARKING(self)

	sleep(1000);
	
	for i = 1, 50 do
		local x, y, z = GetPos(self);
		x, y, z = GetRandomPos(self, x, y, z, 100);

		local mon = CREATE_DUMMYPC_RANDOM_EQUIP(self, x, y, z, GetDirectionByAngle(self), 0, 0);

		local rnd = IMCRandom(0, 9);
		if rnd == 0 then
			RunScript('MOVE_RANDOM', mon, self, 1);
		else
			mon.FIXMSPD_BM = IMCRandom(50, 100);
			InvalidateStates(mon);
			
			RunScript('MOVE_RANDOM', mon, self, 0);
		end
		sleep(500);
	end
end

function MOVE_RANDOM(self, owner, jump)
	while 1 do
		if jump == 1 then
			Jump(self, 300);
			
			local rndJumpTime = IMCRandom(500, 2000);
			sleep(rndJumpTime);
		else
			local dist = GetDistance(owner, self);
			if dist > 100 then
				local x, y, z = GetPos(owner);
				MoveToRandom(self, x, y, z, 30);
			else
				RandomMove(self, 100);
			end

			sleep(2000);
		end
	end
end

function TEST_FORCE_RESET_DB_FISHING_RESETTIME()
    TestForceFishingResetTime();
end
function TEST_TOO_MANY_ITEM_GIVE(pc)
	local tx = TxBegin(pc);
	local giveCnt = 0;
	TxGiveItem(tx, 'gem_circle_1', 1, 'Cheat');	

	local clsList, cnt = GetClassList('Item');
	for i = 0, cnt - 1 do
		if giveCnt > 1000 then
			break;
		end
		local cls = GetClassByIndexFromList(clsList, i);
		if cls.Journal == 'TRUE' then
			TxGiveItem(tx, cls.ClassName, 1, 'Cheat');			
			giveCnt = giveCnt + 1;
		end
	end
	local ret = TxCommit(tx);
	Chat(pc, "cheat end!!: "..ret);
end

function TEST_NEW_MONSTERCARD(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'card_Woodspirit', 1, 'TEST_CARD');
    TxGiveItem(tx, 'card_Armaox', 1, 'TEST_CARD');
    TxGiveItem(tx, 'card_Succubus', 1, 'TEST_CARD');
    TxGiveItem(tx, 'card_Stonefroster', 1, 'TEST_CARD');
    TxGiveItem(tx, 'card_Lapene', 1, 'TEST_CARD');
    TxGiveItem(tx, 'card_Rambandgad', 1, 'TEST_CARD');
    TxGiveItem(tx, 'card_SwordBallista', 1, 'TEST_CARD');
    TxGiveItem(tx, 'card_FrosterLord', 1, 'TEST_CARD');
    local ret = TxCommit(tx);
end

function CARD_LVUP(pc, value)
    value = tonumber(value);
    if value > 10 then
        value = 10
    end
    
    if value == 1 then
        value = 200
    elseif value == 2 then
        value = 500
    elseif value == 3 then
        value = 900
    elseif value == 4 then
        value = 1400
    elseif value == 5 then
        value = 2000
    elseif value == 6 then
        value = 2700
    elseif value == 7 then
        value = 3500
    elseif value == 8 then
        value = 4400
    elseif value == 9 then
        value = 5400
    elseif value == 10 then
        value = 6500
    end

    local vv = 0
    local tx = TxBegin(pc);
    local invItemList = GetInvItemList(pc);
    for i = 1, #invItemList do
        if invItemList[i].GroupName == "Card" then
            TxSetIESProp(tx, invItemList[i], "ItemExp", value);
        end
    end
    local ret = TxCommit(tx);
end

function GEM_LVUP(pc, value)
    value = tonumber(value);
    if value > 10 then
        value = 10
    end
    
    if value == 1 then
        value = 300
    elseif value == 2 then
        value = 1200
    elseif value == 3 then
        value = 3900
    elseif value == 4 then
        value = 14700
    elseif value == 5 then
        value = 57900
    elseif value == 6 then
        value = 230700
    elseif value == 7 then
        value = 1094700
    elseif value == 8 then
        value = 5414700
    elseif value == 9 then
        value = 27014700
    elseif value == 10 then
        value = 27014700
    end

    local vv = 0
    local tx = TxBegin(pc);
    local invItemList = GetInvItemList(pc);
    for i = 1, #invItemList do
        if invItemList[i].EquipXpGroup == "Gem" then
            TxSetIESProp(tx, invItemList[i], "ItemExp", value);
        end
    end
    local ret = TxCommit(tx);
end

function TEST_SUMMON_USE_MONSTERCARD(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx,'card_Gorgon', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_NetherBovine', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_necrovanter', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_lecifer', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_spector_gh', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Mummyghast', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Minotaurs', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_mirtis', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Velorchard', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Strongholder', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_ShadowGaoler', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Spector_m', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Throneweaver', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Abomination', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Unknocker', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_ellaganos', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_unicorn', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Chapparition', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_TombLord', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Harpeia', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_helgasercle', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Spector_F', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_fallen_statue', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Sparnanman', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Kerberos', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Naktis', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Durahan', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Riteris', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Nuaele', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Blud', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Pyroego', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_LithoRex', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Nuodai', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Centaurus', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Frogola', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Marionette', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Genmagnus', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_merregina', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Templeshooter', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Fireload', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Deathweaver', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Flammidus', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Marnoks', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Zawra', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Prisoncutter', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Succubus', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_Rambandgad', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_SwordBallista', 1, 'TEST_CARD');
    TxGiveItem(tx,'card_FrosterLord', 1, 'TEST_CARD');
    local ret = TxCommit(tx);
end

function TEST_ALL_CARD(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx,'card_Grinender', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Moyabruka', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Moldyhorn', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Goblin_Warrior_red', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Ironbaum', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_hydra', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_sparnas', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_gremlin', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_GiantWoodGoblin_red', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_GiantWoodGoblin', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_deadbone', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_plokste', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Genmagnus', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_helgasercle', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_ginklas', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Rajatoad', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Mandala', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_lecifer', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Achat', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Clymen', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Merge', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_bearkaras', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_unicorn', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Devilglove', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Reaverpede', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Mothstem', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_moa', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_mirtis', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Goblin_Warrior', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Iltiswort', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_chafer', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_onion_the_great', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_TombLord', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_fallen_statue', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_archon', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Glass_mole', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Chapparition', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Prisoncutter', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Velniamonkey', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Centaurus', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_FrosterLord', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_NetherBovine', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Pyroego', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_ellaganos', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_RingCrawler', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Blud', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_simorph', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Woodhoungan', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Templeshooter', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Kubas', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Minotaurs', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Abomination', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Unknocker', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Mummyghast', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Stonefroster', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Lapene', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Rambandgad', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_SwordBallista', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_bramble', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Saltistter', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Shnayim', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_yonazolem', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Colimencia', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Sequoia_blue', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Sparnanman', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Flammidus', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Gorgon', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Confinedion', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Glackuman', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Golem_gray', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Denoptic', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Golem', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Frogola', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Nuaele', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Zawra', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Woodspirit', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Armaox', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Gaigalas', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_necrovanter', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Malletwyvern', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_mushcaria', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_bebraspion', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Strongholder', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_yekub', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_poata', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_lepus', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Velpede', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_LithoRex', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Marionette', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_merregina', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Fireload', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_honeypin', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Kerberos', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Nepenthes', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Ravinepede', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_spector_gh', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_ShadowGaoler', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_tutu', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_rajapearl', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_GazingGolem', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_capria', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Durahan', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Riteris', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Neop', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Tetraox', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_velnewt', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Canceril', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Crabil', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Deathweaver', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_molich', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Velorchard', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Naktis', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_basilisk', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_BiteRegina', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_mineloader', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_stone_whale', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Rocktortuga', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_salamander', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Spector_m', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Throneweaver', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Carapace', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Kimeleech', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Harpeia', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_MagBurk', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Manticen', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_werewolf', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Yeti', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Spector_F', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Marnoks', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_FerretMarauder', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Nuodai', 1, 'TEST_CARD')
    TxGiveItem(tx,'card_Succubus', 1, 'TEST_CARD')
    local ret = TxCommit(tx);
end

function TEST_ALL_SKILL_GEM(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Gem_Swordman_Thrust', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Swordman_Bash', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Swordman_GungHo', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Swordman_Concentrate', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Swordman_PainBarrier', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Swordman_Restrain', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Swordman_PommelBeat', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Swordman_DoubleSlash', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Highlander_WagonWheel', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Highlander_CartarStroke', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Highlander_Crown', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Highlander_CrossGuard', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Highlander_Moulinet', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Highlander_SkyLiner', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Highlander_CrossCut', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Highlander_ScullSwing', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Highlander_VerticalSlash', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Peltasta_UmboBlow', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Peltasta_RimBlow', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Peltasta_SwashBuckling', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Peltasta_Guardian', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Peltasta_ShieldLob', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Peltasta_HighGuard', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Peltasta_ButterFly', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Peltasta_UmboThrust', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Hoplite_Stabbing', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Hoplite_Pierce', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Hoplite_Finestra', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Hoplite_SynchroThrusting', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Hoplite_LongStride', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Hoplite_SpearLunge', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Hoplite_ThrouwingSpear', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Barbarian_Embowel', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Barbarian_StompingKick', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Barbarian_Cleave', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Barbarian_HelmChopper', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Barbarian_Warcry', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Barbarian_Frenzy', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Barbarian_Seism', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Barbarian_GiantSwing', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Barbarian_Pouncing', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cataphract_Impaler', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cataphract_EarthWave', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cataphract_Trot', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cataphract_SteedCharge', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cataphract_DoomSpike', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cataphract_Rush', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Corsair_JollyRoger', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Corsair_IronHook', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Corsair_Keelhauling', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Corsair_DustDevil', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Corsair_HexenDropper', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Doppelsoeldner_Mordschlag', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Doppelsoeldner_Double_pay_earn', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Doppelsoeldner_Cyclone', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Rodelero_ShieldCharge', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Rodelero_Montano', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Rodelero_TargeSmash', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Rodelero_ShieldPush', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Rodelero_ShieldShoving', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Rodelero_ShieldBash', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Rodelero_Slithering', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Rodelero_ShootingStar', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Squire_Arrest', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Fencer_Lunge', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Fencer_SeptEtoiles', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Fencer_AttaqueCoquille', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Wizard_EnergyBolt', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Wizard_Lethargy', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Wizard_Sleep', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Wizard_ReflectShield', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Wizard_EarthQuake', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Wizard_Surespell', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Wizard_MagicMissile', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Pyromancer_FireBall', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Pyromancer_FireWall', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Pyromancer_EnchantFire', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Pyromancer_Flare', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Pyromancer_FlameGround', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Pyromancer_FirePillar', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Pyromancer_HellBreath', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cryomancer_IceBolt', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cryomancer_IciclePike', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cryomancer_IceWall', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cryomancer_IceBlast', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cryomancer_Gust', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cryomancer_SnowRolling', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cryomancer_FrostPillar', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Psychokino_PsychicPressure', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Psychokino_Telekinesis', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Psychokino_Swap', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Psychokino_Teleportation', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Psychokino_MagneticForce', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Psychokino_Raise', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Psychokino_GravityPole', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Sorcerer_Summoning', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Sorcerer_SummonFamiliar', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Sorcerer_SummonSalamion', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Linker_Physicallink', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Linker_JointPenalty', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Linker_HangmansKnot', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Linker_SpiritualChain', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Linker_UmbilicalCord', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Chronomancer_Quicken', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Chronomancer_Samsara', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Chronomancer_Stop', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Chronomancer_Slow', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Chronomancer_Haste', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Chronomancer_BackMasking', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Necromancer_FleshCannon', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Necromancer_CorpseTower', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Thaumaturge_SwellLeftArm', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Thaumaturge_ShrinkBody', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Thaumaturge_SwellBody', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Thaumaturge_Transpose', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Thaumaturge_SwellRightArm', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Elementalist_Electrocute', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Elementalist_StoneCurse', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Elementalist_Hail', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Elementalist_Prominence', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Elementalist_Meteor', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Elementalist_FreezingSphere', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Elementalist_Rain', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Elementalist_FrostCloud', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Archer_SwiftStep', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Archer_Multishot', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Archer_Fulldraw', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Archer_ObliqueShot', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Archer_Kneelingshot', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Archer_HeavyShot', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Archer_TwinArrows', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Hunter_Coursing', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Hunter_Snatching', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Hunter_Pointing', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Hunter_RushDog', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Hunter_Retrieve', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Hunter_Hounding', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Hunter_Growling', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_QuarrelShooter_DeployPavise', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_QuarrelShooter_ScatterCaltrop', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_QuarrelShooter_StoneShot', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_QuarrelShooter_RapidFire', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_QuarrelShooter_Teardown', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_QuarrelShooter_RunningShot', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Ranger_Barrage', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Ranger_HighAnchoring', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Ranger_CriticalShot', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Ranger_SteadyAim', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Ranger_TimeBombArrow', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Ranger_BounceShot', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Ranger_SpiralArrow', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Sapper_StakeStockades', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Sapper_Cover', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Sapper_Claymore', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Sapper_PunjiStake', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Sapper_DetonateTraps', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Sapper_BroomTrap', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Sapper_CollarBomb', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Sapper_SpikeShooter', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Wugushi_Detoxify', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Wugushi_NeedleBlow', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Wugushi_Bewitch', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Wugushi_WugongGu', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Wugushi_Zhendu', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Wugushi_ThrowGuPot', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Wugushi_JincanGu', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Scout_FluFlu', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Scout_FlareShot', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Scout_Cloaking', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Scout_Undistance', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Rogue_SneakHit', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Rogue_Feint', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Rogue_Spoliation', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Rogue_Vendetta', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Rogue_Backstab', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Schwarzereiter_ConcentratedFire', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Schwarzereiter_Caracole', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Fletcher_BroadHead', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Fletcher_BodkinPoint', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Fletcher_BarbedArrow', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Fletcher_CrossFire', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Fletcher_MagicArrow', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Fletcher_Singijeon', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Falconer_Pheasant', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Falconer_HangingShot', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cleric_Heal', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cleric_Cure', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cleric_SafetyZone', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cleric_DeprotectedZone', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cleric_DivineMight', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cleric_Fade', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cleric_PatronSaint', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Priest_Aspersion', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Priest_Monstrance', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Priest_Blessing', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Priest_Sacrament', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Priest_Revive', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Priest_MassHeal', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Priest_Exorcise', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Priest_StoneSkin', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Kriwi_Aukuras', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Kriwi_Zalciai', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Kriwi_Daino', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Kriwi_Zaibas', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Kriwi_DivineStigma', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Kriwi_Melstis', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Bokor_Hexing', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Bokor_Effigy', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Bokor_Zombify', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Bokor_Mackangdal', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Bokor_BwaKayiman', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Bokor_Samdiveve', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Bokor_Ogouveve', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Bokor_Damballa', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Druid_Chortasmata', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Druid_Carnivory', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Druid_Transform', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Druid_Telepath', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Sadhu_OutofBody', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Sadhu_AstralBodyExplosion', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Sadhu_VashitaSiddhi', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Sadhu_Possession', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Dievdirbys_CarveVakarine', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Dievdirbys_CarveZemina', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Dievdirbys_CarveLaima', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Dievdirbys_Carve', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Dievdirbys_CarveOwl', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Dievdirbys_CarveAustrasKoks', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Dievdirbys_CarveAusirine', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Oracle_ArcaneEnergy', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Oracle_CounterSpell', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Monk_IronSkin', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Monk_DoublePunch', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Monk_PalmStrike', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Monk_HandKnife', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Monk_EnergyBlast', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Monk_Golden_Bell_Shield', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Pardoner_Simony', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Pardoner_Indulgentia', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Pardoner_DiscernEvil', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Pardoner_IncreaseMagicDEF', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Paladin_Smite', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Paladin_Restoration', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Paladin_ResistElements', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Paladin_TurnUndead', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Peltasta_Langort', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Squire_DeadlyCombo', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Corsair_PistolShot', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Doppelsoeldner_Zornhau', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Doppelsoeldner_Redel', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Doppelsoeldner_Zucken', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Doppelsoeldner_Zwerchhau', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Doppelsoeldner_Sturzhau', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Dragoon_Dragontooth', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Dragoon_Serpentine', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Dragoon_Gae_Bulg', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Dragoon_Dragon_Soar', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Templer_BattleOrders', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Templer_NonInvasiveArea', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Cryomancer_SubzeroShield', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Sorcerer_Evocation', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Sorcerer_Desmodus', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Alchemist_Combustion', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Warlock_PoleofAgony', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Warlock_Invocation', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Warlock_DarkTheurge', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Warlock_Mastema', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_QuarrelShooter_StonePicking', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Schwarzereiter_WildShot', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Falconer_BlisteringThrash', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Musketeer_CoveringFire', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Musketeer_HeadShot', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Musketeer_Snipe', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Musketeer_PenetrationShot', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Musketeer_ButtStroke', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Musketeer_BayonetThrust', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Paladin_Sanctuary', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Paladin_Demolition', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Pardoner_Dekatos', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_PlagueDoctor_HealingFactor', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_PlagueDoctor_Incineration', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_PlagueDoctor_Fumigate', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_PlagueDoctor_Pandemic', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_PlagueDoctor_BeakMask', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Kabbalist_RevengedSevenfold', 1, 'TEST_GEM')
    TxGiveItem(tx, 'Gem_Kabbalist_Ayin_sof', 1, 'TEST_GEM')
    local ret = TxCommit(tx);
end

function TEST_GEM_BUY_COUNT_RESET(pc)
    local aobj_pc = GetAccountObj(pc);
    local tx = TxBegin(pc);
    TxSetIESProp(tx, aobj_pc, 'JUNK_SHOP_BUY_COUNT', 0);
    local ret = TxCommit(tx);
end

function RIDING_ANIM_DOTIME_TEST(pc, msg, animName, second, sObj_name, add_time)
    CancelMouseMove(pc)
	local ridingCompanion = GetRidingCompanion(pc)

    ----ridingAnimList
    
    local ridingAnimList = { }
    ridingAnimList[#ridingAnimList+1] = 'SITGROPE_LOOP_RIDE'
    ridingAnimList[#ridingAnimList+1] = 'TALK_RIDE'
    ridingAnimList[#ridingAnimList+1] = 'LOOK_RIDE'
    ridingAnimList[#ridingAnimList+1] = 'MAKING_RIDE'
    ridingAnimList[#ridingAnimList+1] = 'ABSORB_RIDE'
    
    ----

print('tset', ridingAnimList[1], ridingAnimList[2], ridingAnimList[3], ridingAnimList[4], ridingAnimList[5], anim)
    if ridingCompanion ~= nil then
        if table.find(ridingAnimList, string.upper(animName)) == 0 then
            ALL_PET_GET_OFF(pc)
        end
    end
    local add_timer
    if add_time == nil then
        add_timer = 0
    else
        add_timer = add_time*1000
    end
    
    local xac_ssn = GetSessionObject(pc, 'SSN_EV_STOP')
	if xac_ssn == nil then
    	CreateSessionObject(pc, 'SSN_EV_STOP', 1)
    	xac_ssn = GetSessionObject(pc, 'SSN_EV_STOP')
		if xac_ssn == nil then
			return -2;
		end

    	xac_ssn.Step1 = (second*1000 + 500 + add_timer)
    else
        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("TryLater"), 1);
        return -2;
    end
---------------
    if sObj_name ~= nil and sObj_name ~= 'None' then
        CreateSessionObject(pc, sObj_name, 1)
        local sObj = GetSessionObject(pc, sObj_name)
        if sObj ~= nil then
            sObj.Count = second
        end
    end
    

	local result = DoTimeAction(pc, msg, animName, second);
	if result == 0.0 then
		StopScript();
		DestroySessionObject(pc, xac_ssn)
		return 0;
	end
	
	while 1 do		
		result = GetTimeActionResult(pc, 1);		
		if result == 1 then
			if IsRest(pc) == 1 then
				PlayAnim(pc, 'REST')
			else
				PlayAnim(pc, 'STD')  
			end
           
            DestroySessionObject(pc, xac_ssn)
			return 1;
		end
		
		if result == 0 then
			if IsRest(pc) == 1 then
				PlayAnim(pc, 'REST')
			else 
			    PlayAnim(pc, 'STD')
			end
		    DestroySessionObject(pc, xac_ssn)
			return 0;
		end
		
		sleep(1);
	end
    DestroySessionObject(pc, xac_ssn)
    
	return 0;	
		
end

function SCR_RIDING_ANIM_TEST_SITGROPE(self)
    local anim
    if GetRidingCompanion(self) ~= nil then
        anim = 'SITGROPE_LOOP_RIDE'
    else
        anim = 'SITGROPE_LOOP'
    end
    local result = RIDING_ANIM_DOTIME_TEST(self, ScpArgMsg("PROGRESS"), anim, 3.0)
    if result == 1 then
    end
end

function SCR_RIDING_ANIM_TEST_TALK(self)
    local anim
    if GetRidingCompanion(self) ~= nil then
        anim = 'TALK_RIDE'
    else
        anim = 'TALK'
    end
    local result = RIDING_ANIM_DOTIME_TEST(self, ScpArgMsg("PROGRESS"), anim, 3.0)
    if result == 1 then
    end
end

function TEST_GUILD_RECRUITING(self) -- 길드 이벤트 모집상태 강제 종료
    FinishGuildEventRecruiting(self);
end

function TEST_GUILD_EVENT_TICKET_RESET(pc) --길드 이벤트 입장권 리셋
    local guildObj = GetGuildObj(pc)
    ChangePartyProp(pc, PARTY_GUILD, "UsedTicketCount", 0)
end

function SCR_RIDING_ANIM_TEST_LOOK(self)
    local anim
    if GetRidingCompanion(self) ~= nil then
        anim = 'LOOK_RIDE'
    else
        anim = 'LOOK'
    end
    local result = RIDING_ANIM_DOTIME_TEST(self, ScpArgMsg("PROGRESS"), anim, 3.0)
    if result == 1 then
    end
end

function SCR_RIDING_ANIM_TEST_MAKING(self)
    local anim
    if GetRidingCompanion(self) ~= nil then
        anim = 'MAKING_RIDE'
    else
        anim = 'MAKING'
    end
    local result = RIDING_ANIM_DOTIME_TEST(self, ScpArgMsg("PROGRESS"), anim, 3.0)
    if result == 1 then
    end
end

function SCR_RIDING_ANIM_TEST_ABSORB(self)
    local anim
    if GetRidingCompanion(self) ~= nil then
        anim = 'ABSORB_RIDE'
    else
        anim = 'ABSORB'
    end
    local result = RIDING_ANIM_DOTIME_TEST(self, ScpArgMsg("PROGRESS"), anim, 3.0)
    if result == 1 then
    end
end

function TEST_SAY_CURRENT_SERVER_TIME(pc)
	local curTime = GetDBTime();
	Chat(pc, "CurDate: year["..curTime.wYear..'], month['..curTime.wMonth..'], day['..curTime.wDay..'], hour['..curTime.wHour..'], minute['..curTime.wMinute..']')
end

function TEST_ADDON_MSG_DUMP(pc)
	SendAddOnMsg(pc, "TEST_ADDON_MSG_DUMP_MSG", "");
end

function TEST_SAY_CURRENT_SERVER_TIME2(pc)
	local curTime = geTime.GetServerSystemTime();
	Chat(pc, "CurDate: year["..curTime.wYear..'], month['..curTime.wMonth..'], day['..curTime.wDay..'], hour['..curTime.wHour..'], minute['..curTime.wMinute..']')
end

function TEST_LEGEND_CARD_OPEN(pc, num)
	local pcEtc = GetETCObject(pc);
		
	local tx = TxBegin(pc)
	TxSetIESProp(tx, pcEtc, 'IS_LEGEND_CARD_OPEN', num)
    SendAddOnMsg(pc, "MSG_PLAY_LEGENDCARD_OPEN_EFFECT", "", 0)
	local ret = TxCommit(tx)
	
end

function TEST_LEGENDCARD_EFFECT_SUCCESS(pc)
	SendAddOnMsg(pc, "DO_TEST_LEGENDCARD_REINFORCE_EFFECT_SUCCESS", "", 0)
end

function TEST_LEGENDCARD_EFFECT_FAIL(pc)
	SendAddOnMsg(pc, "DO_TEST_LEGENDCARD_REINFORCE_EFFECT_FAIL", "", 0)
end

function TEST_LEGENDCARD_EFFECT_BROKEN(pc)
	SendAddOnMsg(pc, "DO_TEST_LEGENDCARD_REINFORCE_EFFECT_BROKEN", "", 0)
end

function TEST_LEGENDCARD_OPEN_EFFECT(pc)
	SendAddOnMsg(pc, "MSG_PLAY_LEGENDCARD_OPEN_EFFECT", "", 0)
end

function TEST_LEGENDCARD(pc)
--    local itemID = "item"
--	local clslist, cnt = GetClassList(itemID);
--	local itemGroup = "Legend_Card"
--    local itemGroupName = {};
--	
--	for i = 0, cnt do
--	    local itemcls = GetClassByIndexFromList(clslist, i);
--        if TryGetProp(itemcls, "EquipXpGroup") == itemGroup then
--            clslist[listIndex] = clslist.ItemName;
--			local cls = GetClass("Item", clslist.ClassName);
--			if nil ~= cls then
--				itemGroupName[listIndex] = cls.ClassName;
--			else
--				itemGroupName[listIndex] = "None";
--			end
--            
--            listIndex = listIndex + 1;
--        end
--    end
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Legend_card_Marnoks', 1, 'TEST_CARD');
    TxGiveItem(tx, 'Legend_card_Blud', 1, 'TEST_CARD');
    TxGiveItem(tx, 'Legend_card_Zawra', 1, 'TEST_CARD');
    TxGiveItem(tx, 'Legend_card_Nuaele', 1, 'TEST_CARD');
    TxGiveItem(tx, 'Legend_card_Helgasercle', 1, 'TEST_CARD');
    TxGiveItem(tx, 'Legend_card_Lecifer', 1, 'TEST_CARD');
    TxGiveItem(tx, 'Legend_card_Kucarry_Balzermance', 1, 'TEST_CARD');
    TxGiveItem(tx, 'Legend_card_PantoRex', 1, 'TEST_CARD');
    TxGiveItem(tx, 'Legend_card_Mirtis', 1, 'TEST_CARD');
    local ret = TxCommit(tx);
end

function TEST_REINFORCE_LEGENDCARD(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'legend_reinforce_card_lv1', 1, 'TEST_CARD');
    TxGiveItem(tx, 'legend_reinforce_card_lv2', 1, 'TEST_CARD');
    TxGiveItem(tx, 'legend_reinforce_card_lv3', 1, 'TEST_CARD');
    TxGiveItem(tx, 'legend_reinforce_card_lv4', 1, 'TEST_CARD');
    local ret = TxCommit(tx);
end

function TEST_RNF_CARD_LVUP(pc, value)
    value = tonumber(value);
    if value >= 10 then
        value = 10
    end
    
    if value == 2 then
        value = 6000
    elseif value == 3 then
        value = 13200
    elseif value == 4 then
        value = 29100
    elseif value == 5 then
        value = 64100
    elseif value == 6 then
        value = 141100
    elseif value == 7 then
        value = 310500
    elseif value == 8 then
        value = 683100
    elseif value == 9 then
        value = 1502900
    elseif value == 10 then
        value = 3306400
    elseif value == 1 then
        value = 0
    end

    local vv = 0
    local tx = TxBegin(pc);
    local invItemList = GetInvItemList(pc);
    for i = 1, #invItemList do
        if invItemList[i].GroupName == "Card" then
            TxSetIESProp(tx, invItemList[i], "ItemExp", value);
        end
    end
    local ret = TxCommit(tx);
end


function TEST_ONMYOJI_HIDDEN_CLEAR(pc)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        for i = 1, 9 do
            if sObj['Step'..i] == 1 then
                if i == 6 then
                    if sObj['Goal'..i] ~= 1000 then
                        sObj['Goal'..i] = 1000
                    end
                elseif i == 9 then
                    if sObj['Goal'..i] ~= 100 then
                        sObj['Goal'..i] = 100
                    end
                else
                    if sObj['Goal'..i] ~= 10 then
                        sObj['Goal'..i] = 10
                    end
                end
            end
        end
    end
end

function TEST_ONMYOJI_HIDDEN_RESETTING(pc, num1, num2)
    if num1 == nil or num1 == 0 or num1 == "" and num2 == nil or num2 == 0 or num1 == "" then
        return
    end
    local prop = SCR_SET_HIDDEN_JOB_PROP(pc, 'Char2_20', 0)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        DestroySessionObject(pc, sObj)
    end
    local cnt = GetInvItemCount(pc, "CHAR220_MSTEP1_ITEM1")
    if cnt >= 1 then
        RunScript('TAKE_ITEM_TX', pc, "CHAR220_MSTEP1_ITEM1", cnt, "Quest_HIDDEN_ONMYOJI");
    end
    sleep(500)
    local sObj1 = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj1 == nil then
        CreateSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    end
    sleep(500)
    local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
    if sObj ~= nil then
        local tx = TxBegin(pc)
        if GetInvItemCount(pc, "CHAR220_MSTEP1_ITEM1") < 1 then
            TxGiveItem(tx,"CHAR220_MSTEP1_ITEM1", 1, 'Quest_HIDDEN_ONMYOJI');
        end
        local ret = TxCommit(tx)
        if sObj['Step'..num1] ~= 1 then
            sObj['Step'..num1] = 1
        end
        if sObj['Step'..num2] ~= 1 then
            sObj['Step'..num2] = 1
        end
        SCR_SET_HIDDEN_JOB_PROP(pc, 'Char2_20', 10)
        ShowOkDlg(pc, "CHAR220_MSETP1_DLG1", 1)
        SaveSessionObject(pc, sObj)
    end
    if isHideNPC(pc, "ONMYOJI_MASTER") == "NO" then
        HideNPC(pc, "ONMYOJI_MASTER")
    end
    if isHideNPC(pc, "CHAR220_MSETP2_4_NPC") == "NO" then
        HideNPC(pc, "CHAR220_MSETP2_4_NPC")
    end
end

function TEST_SERVER_LEG_CARD_OPEN(pc)
	local pcEtc = GetETCObject(pc);
		
	local tx = TxBegin(pc)
	TxSetIESProp(tx, pcEtc, 'IS_LEGEND_CARD_OPEN', 1)
    SendAddOnMsg(pc, "MSG_PLAY_LEGENDCARD_OPEN_EFFECT", "", 0)
	local ret = TxCommit(tx)
end

function TEST_MONSTER_HP_SET_PERCENT(self, arg1)
    local x,y,z = GetPos(self)
    local objList, objCount = SelectObjectPos(self, x, y, z, 100, 'ENEMY', 0, 0 ,0)
    local per = arg1 / 100

    for i = 1, objCount do
	    local obj = objList[i];
        obj.HP = obj.HP * per
    end
end

function TEST_MON_DEBUFF_ALL(self)
    local list, cnt = SelectObject(self, 50, "ALL", 1)

    if cnt >= 1 then
        for i = 1, cnt do
            local target = list[i]
            print(target.Name, target.DEF)
            local bufflist = GetBuffList(target);
            if target.Faction == 'Monster' then
                AddBuff(self, target, 'UC_armorbreak', 1, 0, 60000, 1);
                AddBuff(self, target, 'SpearLunge_Debuff', 5, 0, 60000, 1);
                AddBuff(self, target, 'AttaqueCoquille_Debuff', 5, 0, 60000, 1);
                AddBuff(self, target, 'Kagura_Debuff', 5, 0, 60000, 1);
                AddBuff(self, target, 'Cleave_Debuff', 5, 0, 60000, 1);
                AddBuff(self, target, 'ResistElements_Debuff', 15, 0, 60000, 1);
                AddBuff(self, target, 'Hagalaz_Debuff', 1, 0, 60000, 1);
                AddBuff(self, target, 'Conviction_Debuff', 5, 0, 60000, 1);
                AddBuff(self, target, 'Hexing_Debuff', 15, 0, 60000, 1);
                AddBuff(self, self, 'KaguraDance_Buff', 5, 0, 60000, 1);
            end
            for b = 1, #bufflist do
                local buff = bufflist[b]
                print(target.Name.." : "..buff.ClassName);
            end
        end
    end
end
function SCR_TTTTT(self)
    local maxHP = self.MHP
    local nowHP = self.HP
    local healHP = maxHP * 0.15
    local prop = GetExProp(buff, 'useHeal')

    for i = 1, maxHP do
        if nowHP < maxHP then
            Heal(self, math.floor(healHP) , 0);
            break;
        end
        SetExProp(buff, 'useHeal', 1)
    end
        
end

function TEST_ENABLE_EQUIP(pc)
	local spot = "LH"
	local flag = 0
	print(spot)
	print(flag)
	
	EnableEquipItemBySlot(pc, spot, flag)
end

function TEST_BLACKSMIT_IMAGE(pc)
print('----')
	SendAddOnMsg(pc, "MSG_PLAY_BLACKSMITH_SUCCESS_EFFECT", "", 0)
				print('gaf')
end


function TEST_OPTIONEXTRACT_SUCCESS(pc)
	SendAddOnMsg(pc, "MSG_SUCCESS_ITEM_OPTION_EXTRACT", "", 0)

end

function TEST_OPTIONEXTRACT_FAIL(pc)
	SendAddOnMsg(pc, "MSG_FAIL_ITEM_OPTION_EXTRACT", "", 0)

end

function TEST_GET_ENEMY_OBJ(pc, dist)
	local objList, objCount = SelectObject(pc, dist, 'Enemy')
	for i = 1, objCount do
		local mon = objList[i];
		return mon;
	end
	return nil;	
end

function TEST_CHECK_FIND_PATH_TO_PC(pc, dist)
	local mon = TEST_GET_ENEMY_OBJ(pc, dist)
	if mon ~= nil then
        local isFound = IsEnableMoveCloseToTarget(mon, pc);
        Chat(mon, isFound)
        print(mon.ClassName, isFound)
	end
end

function TEST_BEAUTY_TRACK(pc, value)
    value = tonumber(value);
    if value == 1 then
        PlayDirection(pc, "BARBER_TRACK_1")
    elseif value == 2 then
        PlayDirection(pc, "DRESS_TRACK_1")
    end
end

function REINFORCE_ALLWEAPON2(pc, value)
    value = tonumber(value);    
    local tx = TxBegin(pc);
    local invItemList = GetInvItemList(pc);
    for i = 1, #invItemList do
        if invItemList[i].ItemType == "Equip" then
            TxSetIESProp(tx, invItemList[i], "Reinforce_2", value);
        end
    end
    local ret = TxCommit(tx);
end


function GET_RANDOM_ITEM(pc, columName, itemClassType , itemLv, grade, itemCnt)
-- 특정 컬럼으로 필터하여 아이템 얻기 --
--ex) //run GET_RANDOM_ITEM LegendGroup, Boots, 360, 4, 1  이렇게 넣으면 벨코퍼 부츠 (천, 가죽, 판금) 다 나옴 -- 
    local itemList, cnt = GetClassList('Item')
    local getItemList = {};
    
    for i = 0 , cnt - 1 do
        local cls = GetClassByIndexFromList(itemList, i);
        local checkColumName = TryGetProp(cls, columName)
        
        if (checkColumName ~= nil and checkColumName ~= 'None' and checkColumName ~= 0) then
            local checkLv = TryGetProp(cls, 'UseLv')
                if checkLv == tonumber(itemLv) then
                    local checkGrade = TryGetProp(cls, 'ItemGrade')
                        if checkGrade == tonumber(grade) then
                            local ClassType =  TryGetProp(cls, 'ClassType')
                            if ClassType == itemClassType then
                                getItemList[#getItemList + 1] = cls;
                            end
                        end
                end
        end
    end

    local tx = TxBegin(pc);
        for j = 1 , #getItemList do
            TxGiveItem(tx, getItemList[j].ClassName, itemCnt, 'Package_Trumpwarm');
        end
    local ret = TxCommit(tx);
    
end 

  function testbuff(pc)
	  AddBuff(pc, pc, 'Premium_Fortunecookie_5');
	  AddBuff(pc, pc, 'Event_161215_5');
	  AddBuff(pc, pc, 'Event_LargeRice_Soup');
	  AddBuff(pc, pc, 'Event_WeddingCake');
	  AddBuff(pc, pc, 'GIMMICK_Drug_Elements_Fire_Atk');
	  AddBuff(pc, pc, 'Drug_AriesAtk_PC');
	  AddBuff(pc, pc, 'squire_food1_buff');
	  AddBuff(pc, pc, 'DRUG_LOOTINGCHANCE', 100, 0, 1800000, 1);
	  AddBuff(pc, pc, 'Blessing_Buff', 100, 0, 1800000, 1);
	  AddBuff(pc, pc, 'ChallengeMode_Completed', 100, 0, 1800000, 1);
	  AddBuff(pc, pc, 'DivineMight_Buff', 100, 0, 1800000, 1);
	  AddBuff(pc, pc, 'GM_Stat_Buff', 100, 0, 1800000, 1);
	  AddBuff(pc, pc, 'SCR_USE_ITEM_HasteBuff', 2, 0, 3600000, 1);
	  ExecClientScp(gm, scp);
  end

  function TEST_VERTICAL_ON(self)
	local mon = TEST_GET_OBJ(self, 500, "Monster");
    if mon == nil then
        return;
    end

	local isOn = 1;
	local maxHeight = 20;
	local speed = 1;
	SetVerticalMotion(mon, isOn, maxHeight, speed);
end

function TEST_VERTICAL_OFF(self)
	local mon = TEST_GET_OBJ(self, 500, "Monster");
    if mon == nil then
        return;
    end
    
	local isOn = 0;
	SetVerticalMotion(mon, isOn);
end

function TEST_GET_OBJ(self, dist, type)
	local objList, objCount = SelectObject(self, dist, type)
	for i = 1, objCount do
		local mon = objList[i];
		return mon;
	end
	return nil;	
end

function TEST_PLAY_FLUTING(pc)
    local octave = 1;
    local isSharp = 0;
    print('E')
    PlayFluting(pc, 'E', octave, isSharp);
    sleep(600)
    StopFluting(pc, 'E', octave, isSharp);

    print('D')
    PlayFluting(pc, 'D', octave, isSharp);
    sleep(300)
    StopFluting(pc, 'D', octave, isSharp);

    print('C')
    PlayFluting(pc, 'C', octave, isSharp);
    sleep(300)
    StopFluting(pc, 'C', octave, isSharp);
end

function TEST_REGISTER_SOLO_DUNGEON(pc)
    local score = 1000;
    local stage = 20;
    local killCount = 123;

    RegisterSoloDungeonRanking(pc, score, stage, killCount)
end

function TEST_VELCOFFER_SUMAZIN(pc)
    local tx = TxBegin(pc);
    local invItemList = GetInvItemList(pc);
    for i = 1, #invItemList do
        if invItemList[i].ItemType == "Equip" and invItemList[i].UseLv == 360 then
            if invItemList[i].LegendGroup == "Velcoffer" then
            TxSetIESProp(tx, invItemList[i], "LegendPrefix", "Set_Sumazin");
            end
        end
    end
    local ret = TxCommit(tx);
end

function TEST_VELCOFFER_TIKSLINE(pc)
    local tx = TxBegin(pc);
    local invItemList = GetInvItemList(pc);
    for i = 1, #invItemList do
        if invItemList[i].ItemType == "Equip" and invItemList[i].UseLv == 360 then
            if invItemList[i].LegendGroup == "Velcoffer" then
            TxSetIESProp(tx, invItemList[i], "LegendPrefix", "Set_Tiksline");
            end
        end
    end
    local ret = TxCommit(tx);
end

function TEST_VELCOFFER_KRAUJAS(pc)
    local tx = TxBegin(pc);
    local invItemList = GetInvItemList(pc);
    for i = 1, #invItemList do
        if invItemList[i].ItemType == "Equip" and invItemList[i].UseLv == 360 then
            if invItemList[i].LegendGroup == "Velcoffer" then
            TxSetIESProp(tx, invItemList[i], "LegendPrefix", "Set_Kraujas");
            end
        end
    end
    local ret = TxCommit(tx);
end

function TEST_VELCOFFER_MERGAITE(pc)
    local tx = TxBegin(pc);
    local invItemList = GetInvItemList(pc);
    for i = 1, #invItemList do
        if invItemList[i].ItemType == "Equip" and invItemList[i].UseLv == 360 then
            if invItemList[i].LegendGroup == "Velcoffer" then
            TxSetIESProp(tx, invItemList[i], "LegendPrefix", "Set_Mergaite");
            end
        end
    end
    local ret = TxCommit(tx);
end


function TEST_VELCOFFER_GYVENIMAS(pc)
    local tx = TxBegin(pc);
    local invItemList = GetInvItemList(pc);
    for i = 1, #invItemList do
        if invItemList[i].ItemType == "Equip" and invItemList[i].UseLv == 360 then
            if invItemList[i].LegendGroup == "Velcoffer" then
            TxSetIESProp(tx, invItemList[i], "LegendPrefix", "Set_Gyvenimas");
            end
        end
    end
    local ret = TxCommit(tx);
end

function TEST_REG_SOLO_DUNGEON_PREV_WEEK(pc)
    local score = IMCRandom(1, 10000);
    local stage = IMCRandom(1, 100);
    local killCount = IMCRandom(1, 100);
    local lastScore = GetPrevSoloDungeonInfo(pc, "All")
    print('prev', score, stage, killCount, lastScore)
    RegisterSoloDungeonRankingPrevForTest(pc, score, stage, killCount, lastScore)
end

function TEST_REG_SOLO_DUNGEON_NEXT_WEEK(pc)
    local score = IMCRandom(1, 10000);
    local stage = IMCRandom(1, 100);
    local killCount = IMCRandom(1, 100);
    local lastScore = GetCurrentSoloDungeonInfo(pc, "All");
    print('next', score, stage, killCount, lastScore)
    local ret = RegisterSoloDungeonRanking(pc, score, stage, killCount, lastScore)
end


function TEST_SOLO_DUNGEON_PLAY_LOG(pc)
    local year, weekNumber = SoloDungeonSeason();
    SoloDungeonMongoLog(pc, year, weekNumber, "Start", stage, 0);
    SoloDungeonMongoLog(pc, year, weekNumber, "Success", stage, 0, "MonKillCnt", monKillCnt, "PlayTime", playTime, "Score", score);
    SoloDungeonMongoLog(pc, year, weekNumber, "Fail", stage, 0, "MonKillCnt", monKillCnt, "PlayTime", playTime, "Score", score);
    SoloDungeonMongoLog(pc, year, weekNumber, "End", stage, 1, "MonKillCnt", monKillCnt, "PlayTime", playTime, "Score", score, "Rank", rank);
end
function TEST_SOLO_DUNGEON_CLEAR_RANKING(pc, year, weekNum)
    ClearSoloDungeonRankingForTest(pc, year, weekNum);
end
